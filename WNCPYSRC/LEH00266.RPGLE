      *****************************************************************
      *  Start of /COPY LEH00266                                      *
      *****************************************************************
      *                                                               *
      *  LEH00266 - LEFCIPRTV - Call AOSARDR0                         *
      *                                                               *
      *  Last Amend No. DAI104  *Create    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI104 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           DAI104            1            DAI104
     C                   CallB     'AOSARDR0'                                   DAI104
     C                   Parm      *BLANKS       @RTCD                          DAI104
     C                   Parm      '*VERIFY '    @OPTN                          DAI104
     C                   Parm      'DAI104'      @SARD                          DAI104
      *                                                                         DAI104
     C     @RTCD         Ifeq      *Blank                                       DAI104
     C                   Move      'Y'           DAI104                         DAI104
     C                   Endif                                                  DAI104
      *
      *****************************************************************
      *  End of /COPY LEH00266                                        *
      *****************************************************************
