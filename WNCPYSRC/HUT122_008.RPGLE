      *****************************************************************
      *  Start of /COPY HUT122_008                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDRTV - CUSTOMER DETAILS RETRIEVE                        *
      *              (WITH ACTION CODE VERSUS CUSTOMER NO VALIDATION  *
      *                                                               *
      *  Last Amend No. HUT122 *CREATE     Date 10May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT122 - Deletion of PMPORTPD SDEXSTPD and STDSED Details    *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT122
      ***  Determine if switchable feature HUT122 is activated                                HUT122
      *                                                                                       HUT122
     C                   CALLB     'AOSARDR0'                                                 HUT122
     C                   PARM      *BLANKS       @RTCD                                        HUT122
     C                   PARM      '*VERIFY'     @OPTN                                        HUT122
     C                   PARM      'HUT122'      @SARD                                        HUT122
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT122
      *                                                                                       HUT122
     C     @RTCD         IFEQ      *BLANKS                                                    HUT122
     C                   MOVEL     'Y'           HUT122            1                          HUT122
     C                   ELSE                                                                 HUT122
     C                   MOVEL     'N'           HUT122                                       HUT122
     C                   ENDIF                                                                HUT122
      *                                                                                       HUT122
      *****************************************************************
      * End of /COPY HUT122_008                                       *
      *****************************************************************
