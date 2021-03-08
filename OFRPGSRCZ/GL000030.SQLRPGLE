     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
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
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL176 *CREATE     Date 10Sep15               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL176 - Optimisation of Nostro Balances by Company          *
      *                                                               *
      *****************************************************************
     F*SCSARDL0* UF A E           K DISK                                                    MD055681
      *
     DN@NAR            S             50    INZ('Internal Feature for CGL176')
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT)
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
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
     C*****'CGL158'      CHAIN     SCSARDL0                           55                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CGL158'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       55                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        55                    MD055681
     C                   ENDIF                                                              MD055681
      *
      ** Check whether feature already on file
     C*****'CQQ006'      CHAIN     SCSARDL0                           50                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CQQ006'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       50                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        50                    MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
      ** deactive CQQ006 feature when CGL176 is being enabled or amended
     C     P@Action      IFEQ      '1'
     C     P@Action      OREQ      '2'
     C     *IN50         IFEQ      *OFF
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
     C**********         WRITE     @SARDL0                                                  MD055681
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
      ** if CQQ006 is found in SCSARD and CGL158 is OFF,delete CQQ006 in SCSARD
     C     *IN50         IFEQ      *OFF
     C     *IN55         ANDEQ     *ON
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
     C                   ENDIF
      *
     C                   SETON                                        LR
