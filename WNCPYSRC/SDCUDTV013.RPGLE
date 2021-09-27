      *****************************************************************
      *                                                               *
      *  SDCUSD7VL - Customer New Participants Validation             *
      *                                                               *
      *  Last Amend No. LLE100  *CREATE    Date 08May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLE100 - Customer Details Field Changes                      *
      *                                                               *
      *****************************************************************
      *
     C                   CALLB     'AOSARDR0'                                                 LLE100
     C                   PARM      *BLANKS       @RTCD                                        LLE100
     C                   PARM      '*VERIFY'     @OPTN                                        LLE100
     C                   PARM      'LLE100'      @SARD                                        LLE100
     C     SCSARD        PARM      SCSARD        DSFDY                                        LLE100
      *                                                                                       LLE100
     C                   MOVEL     'N'           LLE100            1                          LLE100
     C     @RTCD         IFEQ      *BLANKS                                                    LLE100
     C                   MOVEL     'Y'           LLE100                                       LLE100
     C                   ENDIF                                                                LLE100
      *                                                                                       LLE100
