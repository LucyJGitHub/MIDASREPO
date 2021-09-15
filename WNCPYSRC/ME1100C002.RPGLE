      *****************************************************************
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 204117             DATE 20MAR02               *
      *                 ESL010   *CREATE   Date 19JUL99               *
      *---------------------------------------------------------------*
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level  LOW *
      *  204117 - RATE NOT PASSED TO OTPAY SCREEN - HOOKS - SEE BELOW *
      *  ESL010 - Processing of Payments from ICBS through Midas      *
      *****************************************************************
      *                                                                                       ESL010
      **  Translate message                                                                   ESL010
      *                                                                                       ESL010
      ** Tag :82:  - Rate                                                                     ESL010
     C     SVTAG         IFEQ      ':82:'                                                     ESL010
     C                   MOVEL     DSTRAN        DSIN                                         ESL010
     C                   MOVEL     *BLANK        DSOUT                                        204117
     C                   MOVEL     L82           DSOUT                                        ESL010
     C                   EXSR      SRFILL                                                     ESL010
     C                   MOVEL     DSOUT         L82                                          ESL010
     C                   ENDIF                                                                ESL010
      *                                                                                       ESL010
