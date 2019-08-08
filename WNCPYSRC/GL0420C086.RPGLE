      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420C086 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC133             Date 01Aug19               *
      *  Prev Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      */OMITEND                                                                 LUC133
      *                                                                         LUC133
     C     LUC133        IFEQ      'N'                                          LUC133
     C*    ADD POSTING ENTRY TO BALANCE                                         LUC133
     C   22                                                                     LUC133
     CANN04PSTBAL        SUB       PSTA          PSTBAL               47        LUC133
     C   23                                                                     LUC133
     CANN04PSTA          ADD       PSTBAL        PSTBAL               47        LUC133
      *                                                                         LUC133
     C                   ELSE                                                   LUC133
     C*    ADD POSTING ENTRY TO BALANCE                                         LUC133
     C   22                                                                     LUC133
     CANN04PSTBAL        SUB       PSTA          PSTBAL               47        LUC133
     C   22                                                                     LUC133
     CANN04              Z-ADD     PSTBAL        RUNBAL           15 047        LUC133
     C   23                                                                     LUC133
     CANN04PSTA          ADD       PSTBAL        PSTBAL               47        LUC133
     C   23                                                                     LUC133
     CANN04              Z-ADD     PSTBAL        RUNBAL               47        LUC133
      *                                                                         LUC133
     C     *IN04         IFEQ      *OFF                                         LUC133
     C     *IN22         IFEQ      *ON                                          LUC133
     C     *IN23         OREQ      *ON                                          LUC133
     C     RUNBAL        IFGT      *ZEROS                                       LUC133
     C                   MOVE      *ON           *IN09                          LUC133
     C                   ELSE                                                   LUC133
     C     RUNBAL        IFLT      *ZEROS                                       LUC133
     C                   MOVE      *OFF          *IN09                          LUC133
     C                   ENDIF                                                  LUC133
     C                   ENDIF                                                  LUC133
     C                   ENDIF                                                  LUC133
     C                   ENDIF                                                  LUC133
     C                   ENDIF                                                  LUC133
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
