     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
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
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD036147 *CREATE   Date 12Oct15               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036147 - New take-on pgm to initialise CQQ006 on all zone  *
      *                                                               *
      *****************************************************************
     F*SCSARDL0* UF A E           K DISK                                                    MD055681
      *
     DN@NAR            S             50    INZ('Internal Feature for CGL176')
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
      ** Access run-date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check whether CGL158 is enabled
     C*****'CGL158'      CHAIN     SCSARDL0                           50                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CGL158'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       50                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        50                    MD055681
     C                   ENDIF                                                              MD055681
      *
      ** Check whether CGL176 is enabled
     C*****'CGL176'      CHAIN     SCSARDL0                           51                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CGL176'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       51                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        51                    MD055681
     C                   ENDIF                                                              MD055681
      *
      ** Check whether CQQ006 feature is enabled
     C*****'CQQ006'      CHAIN     SCSARDL0                           52                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CQQ006'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       52                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        52                    MD055681
     C                   ENDIF                                                              MD055681
      *
      ** If CGL176 is enabled and CQQ006 is enabled, remove entry
      ** of CQQ006 feature in SCSARDPD to disable such feature
     C     *in51         IFEQ      *OFF
     C     *in52         ANDEQ     *OFF
     C**********         DELETE    @SARDL0                                                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDCTD                                                                MD055681
     C+ where SARN = 'CQQ006'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDXTD                                                                MD055681
     C+ where SARN = 'CQQ006'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDIF
      *
      ** If CGL158 is disabled and CQQ006 is enabled, remove entry
      ** of CQQ006 feature in SCSARDPD to disable such feature
     C     *in51         IFEQ      *ON
     C     *in52         ANDEQ     *OFF
     C**********         DELETE    @SARDL0                                                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDCTD                                                                MD055681
     C+ where SARN = 'CQQ006'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDXTD                                                                MD055681
     C+ where SARN = 'CQQ006'                                                               MD055681
     C/END-EXEC                                                                             MD055681
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
     C**********         WRITE     @SARDL0
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDCTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , SARD                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABSARD                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'C'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'C'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDIF
      *
     C                   SETON                                        LR
