      *****************************************************************
      *  Start of /COPY LEH00266                                      *
      *****************************************************************
      *                                                               *
      *  LEH00266 - LEFCIPRTV - Call AOSARDR0                         *
      *                                                               *
      *  Last Amend No. LUC123  *Create    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           LUC123            1            LUC123
     C                   CallB     'AOSARDR0'                                   LUC123
     C                   Parm      *BLANKS       @RTCD                          LUC123
     C                   Parm      '*VERIFY '    @OPTN                          LUC123
     C                   Parm      'LUC123'      @SARD                          LUC123
      *                                                                         LUC123
     C     @RTCD         Ifeq      *Blank                                       LUC123
     C                   Move      'Y'           LUC123                         LUC123
     C                   Endif                                                  LUC123
      *
      *****************************************************************
      *  End of /COPY LEH00266                                        *
      *****************************************************************
