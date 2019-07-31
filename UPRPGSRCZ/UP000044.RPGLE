     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Take-On program for CGL176 enhancement')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000044 - Configuration of CQQ006 feature for CGL176 enh.   *
      *                                                               *
      *  Function:  This program switches on or off feature reference *
      *             CQQ006 depending on the availability of CGL158    *
      *             and/or CGL176                                     *
      *                                                               *
      *  Called By: SCOFMENU                                          *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036147 *CREATE   Date 12Oct15               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036147 - New take-on pgm to initialise CQQ006 on all zone  *
      *                                                               *
      *****************************************************************
     FSCSARDL0  UF A E           K DISK
      *
     DN@NAR            S             50    INZ('Internal Feature for CGL176')
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
      ** Access run-date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check whether CGL158 is enabled
     C     'CGL158'      CHAIN     SCSARDL0                           50
      *
      ** Check whether CGL176 is enabled
     C     'CGL176'      CHAIN     SCSARDL0                           51
      *
      ** Check whether CQQ006 feature is enabled
     C     'CQQ006'      CHAIN     SCSARDL0                           52
      *
      ** If CGL176 is enabled and CQQ006 is enabled, remove entry
      ** of CQQ006 feature in SCSARDPD to disable such feature
     C     *in51         IFEQ      *OFF
     C     *in52         ANDEQ     *OFF
     C                   DELETE    @SARDL0
     C                   ENDIF
      *
      ** If CGL158 is disabled and CQQ006 is enabled, remove entry
      ** of CQQ006 feature in SCSARDPD to disable such feature
     C     *in51         IFEQ      *ON
     C     *in52         ANDEQ     *OFF
     C                   DELETE    @SARDL0
     C                   ENDIF
      *
      ** If CGL158 is enabled and CGL176 is disabled, activate CQQ006
     C     *in50         IFEQ      *OFF
     C     *in51         ANDEQ     *ON
     C     *in52         ANDEQ     *ON
     C                   MOVEL     'CQQ006'      ABSARN
     C                   MOVEL     N@NAR         ABSARD
     C                   Z-ADD     AGRDNB        ABLCD
     C                   MOVEL     'I'           ABTYLC
     C                   WRITE     @SARDL0
     C                   ENDIF
      *
     C                   SETON                                        LR
