      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420C086 - BALANCE STATEMENTS (A/C FORMATS)                *
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
      *    SET UP AVAILABLE BALANCE FOR HVB STMTS
     C     VALD          IFLE      RUND
     C   22
     CANN04PSTAVL        SUB       PSTA          PSTAVL           15 0
     C   23
     CANN04PSTA          ADD       PSTAVL        PSTAVL
     C                   ENDIF
     C     PSTAVL        COMP      PSTBAL                             4646
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420C086                                       *
      *****************************************************************
