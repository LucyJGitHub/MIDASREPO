     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS Switch on feature CQQ004 for CSW017')
      *****************************************************************
      *                                                               *
      *  Midas System Control/MSDL                                    *
      *                                                               *
      *  MS6140 - Switch on/off feature CQQ004                        *
      *                                                               *
      *  Function:  This program switches on or off feature reference *
      *             CQQ004 whenever CSW017 is maintained.             *
      *                                                               *
      *             CQQ004 switches off the standard Midas/SWIFT      *
      *             Direct Link menu items which are not required by  *
      *             the Midas/Swift Meridian interface (CSW017).      *
      *                                                               *
      *  Called By: SCOFMENU                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. CSW017 *CREATE     Date 11Feb99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW017 - Midas/Swift Meridian interface                      *
      *                                                               *
      *****************************************************************
     Fscsardl0  uf a e           k disk
      *
     Dn@nar            s             50    inz('Midas-SWIFT Meridian I/F')
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
     C     'CSW008'      chain     scsardl0                           55
     C   55'CSW009'      chain     scsardl0                           55
      *
      ** Check whether feature already on file
     C     'CQQ004'      chain     scsardl0                           50
      *
      ** If action is Insert add feature details if not already there
     C     p@action      ifeq      '1'
     C     p@action      oreq      '2'
     C     *in50         ifeq      *on
     C                   movel     'CQQ004'      ABSARN
     C                   movel     n@nar         ABSARD
     C                   z-add     AGRDNB        ABLCD
     C                   movel     'I'           ABTYLC
     C                   write     @sardl0
     C                   endif
     C                   endif
      *
      ** If action is Delete and other interfaces are off, remove
      ** feature CQQ004
     C     p@action      ifeq      '3'
     C     *in55         andeq     *on
     C     *in50         andeq     *off
     C                   delete    @sardl0
     C                   endif
      *
     C                   seton                                        lr
