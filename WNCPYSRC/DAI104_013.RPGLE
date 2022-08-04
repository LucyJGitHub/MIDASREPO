      *****************************************************************
      *  Start of /COPY DAI104_013                                    *
      *****************************************************************
      *                                                               *
      *  DAI104_013 - LECLIP1VL - Call AOCUSTR1                       *
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
     C                   Parm      DDCUST        @CUST                          DAI104
     C                   Parm                    @KEYSTS                        DAI104
     C     SDCUST        Parm      SDCUST        DSLDY                          DAI104
      *                                                                         DAI104
     C                   else                                                   DAI104
      *                                                                         DAI104
      *****************************************************************
      *  End of /COPY DAI104_013                                      *
      *****************************************************************
