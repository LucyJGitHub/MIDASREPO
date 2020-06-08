     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX Take-On program for HUT113 enhancement')      *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  XX000098 - Configuration of XQQ001 feature for HUT113 enh.   *
      *                                                               *
      *  Function:  This program switches on or off feature reference *
      *             XQQ001 depending on the availability of CRP006    *
      *             and/or HUT113                                     *
      *                                                               *
      *  Called By: SCOFMENU                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. HUT113  *Create    Date 06Dec16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *         - New take-on pgm to initialise XQQ001                *
      *                                                               *
      *****************************************************************
     FSCSARDL0  UF A E           K DISK
      *
     DN@NAR            S             50    INZ('Internal Feature for HUT113')
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
      ** Access run-date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check whether CRP006 is enabled
     C     'CRP006'      CHAIN     SCSARDL0                           50
      *
      ** Check whether HUT113 is enabled
     C     'HUT113'      CHAIN     SCSARDL0                           51
      *
      ** Check whether XQQ001 feature is enabled
     C     'XQQ001'      CHAIN     SCSARDL0                           52
      *
      ** If HUT113 is enabled and XQQ001 is enabled, remove entry
      ** of XQQ001 feature in SCSARDPD to disable such feature
     C     *in51         IFEQ      *OFF
     C     *in52         ANDEQ     *OFF
     C                   DELETE    @SARDL0
     C                   ENDIF
      *
      ** If CRP006 is disabled and XQQ001 is enabled, remove entry
      ** of XQQ001 feature in SCSARDPD to disable such feature
     C     *in50         IFEQ      *ON
     C     *in52         ANDEQ     *OFF
     C                   DELETE    @SARDL0
     C                   ENDIF
      *
      ** If CRP006 is enabled and HUT113 is disabled, activate XQQ001
     C     *in50         IFEQ      *OFF
     C     *in51         ANDEQ     *ON
     C     *in52         ANDEQ     *ON
     C                   MOVEL     'XQQ001'      ABSARN
     C                   MOVEL     N@NAR         ABSARD
     C                   Z-ADD     AGRDNB        ABLCD
     C                   MOVEL     'I'           ABTYLC
     C                   WRITE     @SARDL0
     C                   ENDIF
      *
     C                   SETON                                        LR


