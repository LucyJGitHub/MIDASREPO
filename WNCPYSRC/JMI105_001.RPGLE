      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  JMI105_001 - (/COPY Name)                                    *
      *                                                               *
      *  Last Amend No. JMI105  *CREATE    Date 012May20              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI105 - Validate Subtype and Settle/Pay Ccy combination     *
      *                                                               *
      *****************************************************************
      ** Start of /COPY JMI105_001
      *****************************************************************
      *
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'JMI105'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           JMI105            1
     C                   If        @RTCD <> *BLANKS and
     C                             @RTCD <> '*NRF   '
     C                   Eval      DBFILE = 'SCSARDPD'
     C                   Eval      DBASE = 903
     C                   Eval      DBKEY = 'JMI105'
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   If        @RTCD = *BLANKS
     C                   Eval      JMI105 = 'Y'
     C                   EndIf
      *
      *****************************************************************
      ** End of /COPY JMI105_001
      *****************************************************************
