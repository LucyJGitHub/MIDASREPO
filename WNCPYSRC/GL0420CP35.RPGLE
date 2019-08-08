      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP35 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC133             Date 01Aug19               *
      *  Prev Amend No. LUC110             Date 29Jan19               *
      *                 LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
      **  Access SAR details file to see if LUC108 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'LUC108'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   MOVE      'N'           LUC108
     C                   MOVE      *OFF          *IN79
     C     PRTCD         IFEQ      *BLANKS
     C                   OPEN      SDBSRTL1
     C                   MOVE      'Y'           LUC108            1
     C                   MOVE      *ON           *IN79
     C                   ENDIF
      *
     C                   CALL      'AOSARDR0'                                            LUC110
     C                   PARM      '       '     @RTCD                                   LUC110
     C                   PARM      '*VERIFY'     @OPTN                                   LUC110
     C                   PARM      'LUC110'      @SARD             6                     LUC110
     C     SCSARD        PARM      SCSARD        DSFDY                                   LUC110
     C*                                                                                  LUC110
     C     @RTCD         Ifeq      *BLANKS                                               LUC110
     C                   Move      'Y'           LUC110            1                     LUC110
     C                   else                                                            LUC110
     C                   Move      'N'           LUC110            1                     LUC110
     C                   Endif                                                           LUC110
      *                                                                                  LUC110
     C                   CALL      'AOSARDR0'                                            LUC133
     C                   PARM      '       '     @RTCD                                   LUC133
     C                   PARM      '*VERIFY'     @OPTN                                   LUC133
     C                   PARM      'LUC133'      @SARD             6                     LUC133
     C     SCSARD        PARM      SCSARD        DSFDY                                   LUC133
      *                                                                                  LUC133
     C     @RTCD         Ifeq      *BLANKS                                               LUC133
     C                   Move      'Y'           LUC133                                  LUC133
     C                   MOVE      *ON           *INKP                                   LUC133
     C                   else                                                            LUC133
     C                   Move      'N'           LUC133            1                     LUC133
     C                   MOVE      *OFF          *INKP                                   LUC133
     C                   Endif                                                           LUC133
      *                                                                                  LUC133
      *****************************************************************
      * End of /COPY GL0420CP35                                       *
      *****************************************************************
