      *****************************************************************
      *  Start of /COPY DAI104_009                                    *
      *****************************************************************
      *                                                               *
      *  DAI104_009 - LEFCIPRTV - Call AOCUSTR1                       *
      *                                                               *
      *  Last Amend No. DAI104  *Create    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI104 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *                                                                         DAI104
     C     DAI104        Ifeq      'Y'                                          DAI104
      *                                                                         DAI104
     C                   CallB     'AOCUSTR1'                                   DAI104
     C                   Parm      *BLANKS       @RTCD                          DAI104
     C                   Parm      '*KEY   '     @OPTN                          DAI104
     C                   Parm      DDCSSN        @KEY1                          DAI104
     C                   Parm                    @KYST                          DAI104
     C     SDCUST        Parm      SDCUST        DSLDY                          DAI104
      *                                                                         DAI104
     C                   else                                                   DAI104
      *                                                                         DAI104
      *****************************************************************
      *  End of /COPY DAI104_009                                      *
      *****************************************************************
