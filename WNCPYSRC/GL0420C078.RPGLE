      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420C078 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'
     C                   Z-ADD     1             STPP              3 0
     C                   Z-ADD     CFSB          PSTAVL           15 0
     C     CLBL          IFGT      *ZERO
     C                   Z-ADD     CLBL          CLBL1            15 0
     C                   ELSE
     C                   Z-SUB     CLBL          CLBL1            15 0
     C                   ENDIF
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420C078                                     *
      *****************************************************************
