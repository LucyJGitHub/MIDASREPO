      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420C086 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC132             DATE 30Jul19               *
      *  Prev Amend No. LUC108  *CREATE    DATE 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC132 - Amendments to Statement of Account feature AG       *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC132        IFEQ      'Y'                                             LUC132
     C   23                                                                        LUC132
     CANN04              Z-ADD     PSTBAL        RUNBAL           15 047           LUC132
     C     *IN04         IFEQ      *OFF                                            LUC132
     C     *IN22         IFEQ      *ON                                             LUC132
     C     *IN23         OREQ      *ON                                             LUC132
     C     RUNBAL        IFGT      *ZEROS                                          LUC132
     C                   MOVE      *ON           *IN09                          DR LUC132
     C                   ELSE                                                      LUC132
     C     RUNBAL        IFLT      *ZEROS                                          LUC132
     C                   MOVE      *OFF          *IN09                          CR LUC132
     C                   ENDIF                                                     LUC132
     C                   ENDIF                                                     LUC132
     C                   ENDIF                                                     LUC132
     C                   ENDIF                                                     LUC132
     C                   ENDIF                                                     LUC132
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
