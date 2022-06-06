     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                     MD058280
/*STD *  RPGSQLBND                                                    *                     MD058280
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
      *  Last Amend No. MD058280           Date 07Jun21               *
      *  Prev Amend No. HUT113 *CREATE     Date 06Dec16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058280 - Deliverable Data Split for SAR. Patterned fix     *
      *             from MD055681 of program UP000044.                *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *                                                               *
      *****************************************************************
     F*scsardl0* uf a e           k disk                                                    MD058280
      *
     Dn@nar            s             50    inz('Internal Feature for HUT113')
      *
     Drundat         e ds                  extname(rundat)
      ** Data Area for run-date
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD058280
     D                                     PREFIX(AB)                                       MD058280
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
     C*****'CRP006'      chain     scsardl0                           55                    MD058280
     C/exec sql                                                                             MD058280
     C+ select *                                                                            MD058280
     C+ into :SCSARD                                                                        MD058280
     C+ from SCSRDJW0                                                                       MD058280
     C+ where SARN = 'CRP006'                                                               MD058280
     C/end-exec                                                                             MD058280
     C                   setoff                                       55                    MD058280
     C                   if        SQLCODE = 100                                            MD058280
     C                   seton                                        55                    MD058280
     C                   endif                                                              MD058280
      *                                                                                     MD058280
      ** Check whether feature already on file
     C*****'XQQ001'      chain     scsardl0                           50                    MD058280
     C/exec sql                                                                             MD058280
     C+ select *                                                                            MD058280
     C+ into :SCSARD                                                                        MD058280
     C+ from SCSRDJW0                                                                       MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C                   setoff                                       50                    MD058280
     C                   if        SQLCODE = 100                                            MD058280
     C                   seton                                        50                    MD058280
     C                   endif                                                              MD058280
                                                                                            MD058280
     C/exec sql                                                                             MD058280
     C+ select *                                                                            MD058280
     C+ into :SCSARD                                                                        MD058280
     C+ from SCSRDJW2                                                                       MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C                   setoff                                       51                    MD058280
     C                   if        SQLCODE = 100                                            MD058280
     C                   seton                                        51                    MD058280
     C                   endif                                                              MD058280
                                                                                            MD058280
      ** deactive XQQ001 feature when HUT113 is being enabled or amended
     C     p@action      ifeq      '1'
     C     p@action      oreq      '2'
     C     *in50         ifeq      *off
     C**********         delete    @sardl0                                                  MD058280
     C/exec sql                                                                             MD058280
     C+ delete from SCSRDBTD                                                                MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C/exec sql                                                                             MD058280
     C+ delete from SCSRDXTD                                                                MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C                   endif
     C                   endif
      ** processing when HUT113 is being deactivated
     C     p@action      ifeq      '3'
      ** if XQQ001 is not found in SCSARD and CRP006 is ON,insert XQQ001 in SCSARD
     C     *in50         ifeq      *on
     C     *in55         andeq     *off
      *                                                                                     MD058280
     C     *in51         ifeq      *on                                                      MD058280
     C                   movel     'XQQ001'      ABSARN
     C                   movel     n@nar         ABSARD
     C                   z-add     AGRDNB        ABLCD
     C                   movel     'I'           ABTYLC
     C**********         write     @sardl0                                                  MD058280
     C/exec sql                                                                             MD058280
     C+ insert into SCSRDBTD                                                                MD058280
     C+ (                                                                                   MD058280
     C+   SARN                                                                              MD058280
     C+ , SARD                                                                              MD058280
     C+ , LCD                                                                               MD058280
     C+ , TYLC                                                                              MD058280
     C+ , ZONE                                                                              MD058280
     C+ , ENABLD                                                                            MD058280
     C+ , MODE                                                                              MD058280
     C+ )                                                                                   MD058280
     C+ Values                                                                              MD058280
     C+ (                                                                                   MD058280
     C+   :ABSARN                                                                           MD058280
     C+ , :ABSARD                                                                           MD058280
     C+ , :ABLCD                                                                            MD058280
     C+ , :ABTYLC                                                                           MD058280
     C+ , ' '                                                                               MD058280
     C+ , 'E'                                                                               MD058280
     C+ , 'B'                                                                               MD058280
     C+ )                                                                                   MD058280
     C/end-exec                                                                             MD058280
      *                                                                                     MD058280
     C/exec sql                                                                             MD058280
     C+ insert into SCSRDXTD                                                                MD058280
     C+ (                                                                                   MD058280
     C+   SARN                                                                              MD058280
     C+ , LCD                                                                               MD058280
     C+ , TYLC                                                                              MD058280
     C+ , ZONE                                                                              MD058280
     C+ , ENABLD                                                                            MD058280
     C+ , MODE                                                                              MD058280
     C+ )                                                                                   MD058280
     C+ Values                                                                              MD058280
     C+ (                                                                                   MD058280
     C+   :ABSARN                                                                           MD058280
     C+ , :ABLCD                                                                            MD058280
     C+ , :ABTYLC                                                                           MD058280
     C+ , ' '                                                                               MD058280
     C+ , 'E'                                                                               MD058280
     C+ , 'B'                                                                               MD058280
     C+ )                                                                                   MD058280
     C/end-exec                                                                             MD058280
      *                                                                                     MD058280
     C                   else                                                               MD058280
     C/exec sql                                                                             MD058280
     C+ update SCSRDXTD                                                                     MD058280
     C+ set ENABLD = 'E'                                                                    MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C                   endif                                                              MD058280
      *                                                                                     MD058280
     C                   endif                                                              MD058280
      *
      ** if XQQ001 is found in SCSARD and CRP006 is OFF,delete XQQ001 in SCSARD
     C     *in50         ifeq      *off
     C     *in55         andeq     *on
     C**********         delete    @sardl0                                                  MD058280
     C/exec sql                                                                             MD058280
     C+ delete from SCSRDBTD                                                                MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C/exec sql                                                                             MD058280
     C+ delete from SCSRDXTD                                                                MD058280
     C+ where SARN = 'XQQ001'                                                               MD058280
     C/end-exec                                                                             MD058280
     C                   endif
     C                   endif
      *
     C                   seton                                        lr


