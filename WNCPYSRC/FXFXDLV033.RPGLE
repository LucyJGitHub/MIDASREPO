      *****************************************************************
      *                                                               *
      *  Midas - FX Dealer Module                                     *
      *                                                               *
      *  FXFXDLV033  - FX Deal Validation                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC104  *CREATE    Date 16Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC104 - KondorPlus Details on Deals                         *
      *                                                               *
      *****************************************************************
      ** Access SAR details to determine if LBV061 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'LUC104'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   MOVEL     'LUC104'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           LUC104            1
     C                   ELSE
     C                   MOVEL     'N'           LUC104            1
     C                   ENDIF
