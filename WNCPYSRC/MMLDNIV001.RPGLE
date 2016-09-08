      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (MMLDNIVAL)                             *
      *                                                               *
      *  MMLDNIV001  - MM Loans/Deposits Validation                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC104  *CREATE    Date 14Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC104 - KondorPlus Details on Deals                         *
      *                                                               *
      *****************************************************************
      *
      *================================================================
      * Deal Sub Type Generation
      *================================================================
     C     *LIKE         DEFINE    #ZDYNO        #DYVAL
     C     *LIKE         DEFINE    #ZDYNO        #DYMAT
      * Determine subtype if not already entered...
     C     LUC104        IFEQ      'Y'
     C     DDSTYP        IFEQ      '  '
     C     DDSTYP        OREQ      '**'
      * Convert value date...
     C                   MOVEL     DDVDAT        #ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANK        #ERROR            7
     C                   PARM                    #ZDATE            6 0
     C                   PARM      BJDFIN        #FRMAT            1
     C     #DYVAL        PARM      *ZERO         #ZDYNO            5 0
      * Convert maturity date...
     C                   MOVEL     DDMDAT        #ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANK        #ERROR            7
     C                   PARM                    #ZDATE            6 0
     C                   PARM      BJDFIN        #FRMAT
     C     #DYMAT        PARM      *ZERO         #ZDYNO            5 0
      * Return deal sub type...
     C                   CALL      'R015000'
     C                   PARM      *BLANK        #RETRN            7
     C                   PARM      DDCUST        WP0001           10            CustNo:CustShrtNm
     C                   PARM      DDTYPE        WP0002            2            Deal type
     C                   PARM      #DYVAL        WP0003            5 0          Value date
     C                   PARM      #DYMAT        WP0004            5 0          Maturity date
     C                   PARM      DDCCY         WP0005            3            Par currency on
     C                   PARM      *BLANK        WP0006            3            Par currency tw
     C     DDSTYP        PARM                    WP0007            2            Sub type
      *
     C                   END
     C                   ENDIF
      *================================================================
