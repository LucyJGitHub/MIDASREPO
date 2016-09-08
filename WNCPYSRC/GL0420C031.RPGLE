      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420C031 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC107   *CREATE   Date 21Dec15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
      *
     C     LUC107        IFEQ      'Y'
     C     *IN03         ANDEQ     *ON
     C                   Z-ADD     STPA          W0STPA
     C                   Z-ADD     LSTPX         STPA
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420C031                                       *
      *****************************************************************
