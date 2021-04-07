     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS Switch on feature XQQ001 for HUT113')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Tradings Module                           *
      *                                                               *
      *  XX000097 - Switch on/off feature XQQ001                      *
      *                                                               *
      *  Function:  This program switches on or off feature reference *
      *             XQQ001 whenever HUT113 is maintained.             *
      *                                                               *
      *  Called By: SCOFMENU                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. HUT113 *CREATE     Date 06Dec16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *                                                               *
      *****************************************************************
     Fscsardl0  uf a e           k disk
      *
     Dn@nar            s             50    inz('Internal Feature for HUT113')
      *
     Drundat         e ds                  extname(rundat)
      ** Data Area for run-date
      *
     C     *entry        plist
     C                   parm                    p@rtcd            7
     C                   parm                    p@action          1
      *
      ** Access run-date
     C     *dtaara       define                  rundat
     C                   in        rundat
      *
      ** Check whether other interfaces are on
     C     'CRP006'      chain     scsardl0                           55
      *
      ** Check whether feature already on file
     C     'XQQ001'      chain     scsardl0                           50
      ** deactive XQQ001 feature when HUT113 is being enabled or amended
     C     p@action      ifeq      '1'
     C     p@action      oreq      '2'
     C     *in50         ifeq      *off
     C                   delete    @sardl0
     C                   endif
     C                   endif
      ** processing when HUT113 is being deactivated
     C     p@action      ifeq      '3'
      ** if XQQ001 is not found in SCSARD and CRP006 is ON,insert XQQ001 in SCSARD
     C     *in50         ifeq      *on
     C     *in55         andeq     *off
     C                   movel     'XQQ001'      ABSARN
     C                   movel     n@nar         ABSARD
     C                   z-add     AGRDNB        ABLCD
     C                   movel     'I'           ABTYLC
     C                   write     @sardl0
     C                   endif
      ** if XQQ001 is found in SCSARD and CRP006 is OFF,delete XQQ001 in SCSARD
     C     *in50         ifeq      *off
     C     *in55         andeq     *on
     C                   delete    @sardl0
     C                   endif
     C                   endif
      *
     C                   seton                                        lr


