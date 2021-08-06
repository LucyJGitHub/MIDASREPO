      *****************************************************************
      *                                                               *
      *  SDCUSDCVT Customer New Participants Validation             *
      *                                                               *
      *  Last Amend No. LLE100  *CREATE    Date 08May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLE100 - Customer Details Field Changes                      *
      *                                                               *
      *****************************************************************
      *
      ** Check if feature LLE100 is switched on                                               LLE100
      *                                                                                       LLE100
     C                   CALLB     'AOSARDR0'                                                 LLE100
     C                   PARM      *BLANKS       @RTCD                                        LLE100
     C                   PARM      '*VERIFY'     @OPTN                                        LLE100
     C                   PARM      'LLE100'      @SARD                                        LLE100
     C     SCSARD        PARM      SCSARD        DSFDY                                        LLE100
     C     @RTCD         IFEQ      *BLANK                                                     LLE100
     C                   MOVEL     'Y'           LLE100            1                          LLE100
     C                   ELSE                                                                 LLE100
     C                   MOVEL     'N'           LLE100                                       LLE100
     C                   END                                                                  LLE100
      *                                                                                       LLE100
