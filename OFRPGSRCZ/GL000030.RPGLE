     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS Switch on feature CQQ006 for CGL176')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000030 - Switch on/off feature CQQ006                      *
      *                                                               *
      *  Function:  This program switches on or off feature reference *
      *             CQQ006 whenever CGL176 is maintained.             *
      *                                                               *
      *             CQQ006 switches off the CGL158 menu items         *
      *             0000005291 and 0000005292 which were replaced by  *
      *             0000005309 and 0000005310 introduced by CGL176    *
      *                                                               *
      *  Called By: SCOFMENU                                          *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL176 *CREATE     Date 10Sep15               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL176 - Optimisation of Nostro Balances by Company          *
      *                                                               *
      *****************************************************************
     FSCSARDL0  UF A E           K DISK
      *
     DN@NAR            S             50    INZ('Internal Feature for CGL176')
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@Rtcd            7
     C                   PARM                    P@Action          1
      *
      ** Access run-date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check whether other interfaces are on
     C     'CGL158'      CHAIN     SCSARDL0                           55
      *
      ** Check whether feature already on file
     C     'CQQ006'      CHAIN     SCSARDL0                           50
      ** deactive CQQ006 feature when CGL176 is being enabled or amended
     C     P@Action      IFEQ      '1'
     C     P@Action      OREQ      '2'
     C     *IN50         IFEQ      *OFF
     C                   DELETE    @SARDL0
     C                   ENDIF
     C                   ENDIF
      ** processing when CGL176 is being deactivated
     C     P@Action      IFEQ      '3'
      ** if CQQ006 is not found in SCSARD and CGL158 is ON,insert CQQ006 in SCSARD
     C     *IN50         IFEQ      *ON
     C     *IN55         ANDEQ     *OFF
     C                   MOVEL     'CQQ006'      ABSARN
     C                   MOVEL     N@NAR         ABSARD
     C                   Z-ADD     AGRDNB        ABLCD
     C                   MOVEL     'I'           ABTYLC
     C                   WRITE     @SARDL0
     C                   ENDIF
      ** if CQQ006 is found in SCSARD and CGL158 is OFF,delete CQQ006 in SCSARD
     C     *IN50         IFEQ      *OFF
     C     *IN55         ANDEQ     *ON
     C                   DELETE    @SARDL0
     C                   ENDIF
     C                   ENDIF
      *
     C                   SETON                                        LR
