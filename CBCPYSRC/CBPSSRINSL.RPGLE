      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPGLE)                                 *
      *                                                               *
      *  CBPSSRINSL - Midas CB Installation PSSR processing           *
      *                                                               *
      *  Last Amend No. MD055681 *CREATE   Date 31Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *                                                               *
      *****************************************************************
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'PSSR   '     P0RTN
     C                   DUMP
     C                   END
      *
     C                   SETON                                        LR
      *
     C                   RETURN
      *****************************************************************
      * End of /COPY CBPSSRINSL                                       *
      *****************************************************************
