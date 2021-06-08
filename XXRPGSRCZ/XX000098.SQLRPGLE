     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                     MD058280
/*STD *  RPGSQLBND                                                    *                     MD058280
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
      *  Last Amend No. MD058280           Date 07Jun21               *
      *  Prev Amend No. HUT113  *Create    Date 06Dec16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058280 - Deliverable Data Split for SAR. Patterned fix     *
      *             from MD055681 of program UP000044.                *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *         - New take-on pgm to initialise XQQ001                *
      *                                                               *
      *****************************************************************
     F*SCSARDL0* UF A E           K DISK                                                    MD058280
      *
     DN@NAR            S             50    INZ('Internal Feature for HUT113')
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD058280
     D                                     PREFIX(AB)                                       MD058280
      *
      ** Access run-date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check whether CRP006 is enabled
     C*****'CRP006'      CHAIN     SCSARDL0                           50                    MD058280
     C/EXEC SQL                                                                             MD058280
     C+ SELECT *                                                                            MD058280
     C+ INTO :SCSARD                                                                        MD058280
     C+ FROM SCSRDJW0                                                                       MD058280
     C+ WHERE SARN = 'CRP006'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C                   SETOFF                                       50                    MD058280
     C                   IF        SQLCODE = 100                                            MD058280
     C                   SETON                                        50                    MD058280
     C                   ENDIF                                                              MD058280
      *
      ** Check whether HUT113 is enabled
     C*****'HUT113'      CHAIN     SCSARDL0                           51                    MD058280
     C/EXEC SQL                                                                             MD058280
     C+ SELECT *                                                                            MD058280
     C+ INTO :SCSARD                                                                        MD058280
     C+ FROM SCSRDJW0                                                                       MD058280
     C+ WHERE SARN = 'HUT113'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C                   SETOFF                                       51                    MD058280
     C                   IF        SQLCODE = 100                                            MD058280
     C                   SETON                                        51                    MD058280
     C                   ENDIF                                                              MD058280
      *
      ** Check whether XQQ001 feature is enabled
     C*****'XQQ001'      CHAIN     SCSARDL0                           52                    MD058280
     C/EXEC SQL                                                                             MD058280
     C+ SELECT *                                                                            MD058280
     C+ INTO :SCSARD                                                                        MD058280
     C+ FROM SCSRDJW0                                                                       MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C                   SETOFF                                       52                    MD058280
     C                   IF        SQLCODE = 100                                            MD058280
     C                   SETON                                        52                    MD058280
     C                   ENDIF                                                              MD058280
      *                                                                                     MD058280
     C/EXEC SQL                                                                             MD058280
     C+ SELECT *                                                                            MD058280
     C+ INTO :SCSARD                                                                        MD058280
     C+ FROM SCSRDJW2                                                                       MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C                   SETOFF                                       53                    MD058280
     C                   IF        SQLCODE = 100                                            MD058280
     C                   SETON                                        53                    MD058280
     C                   ENDIF                                                              MD058280
      *                                                                                     MD058280
      ** If HUT113 is enabled and XQQ001 is enabled, remove entry
      ** of XQQ001 feature in SCSARDPD to disable such feature
     C     *in51         IFEQ      *OFF
     C     *in52         ANDEQ     *OFF
     C**********         DELETE    @SARDL0                                                  MD058280
     C/EXEC SQL                                                                             MD058280
     C+ DELETE FROM SCSRDBTD                                                                MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C/EXEC SQL                                                                             MD058280
     C+ DELETE FROM SCSRDXTD                                                                MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C                   ENDIF
      *
      ** If CRP006 is disabled and XQQ001 is enabled, remove entry
      ** of XQQ001 feature in SCSARDPD to disable such feature
     C     *in50         IFEQ      *ON
     C     *in52         ANDEQ     *OFF
     C**********         DELETE    @SARDL0                                                  MD058280
     C/EXEC SQL                                                                             MD058280
     C+ DELETE FROM SCSRDBTD                                                                MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C/EXEC SQL                                                                             MD058280
     C+ DELETE FROM SCSRDXTD                                                                MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
     C                   ENDIF
      *
      ** If CRP006 is enabled and HUT113 is disabled, activate XQQ001
     C     *in50         IFEQ      *OFF
     C     *in51         ANDEQ     *ON
     C     *in52         ANDEQ     *ON
      *
     C     *in52         IFEQ      *ON                                                      MD058280
     C                   MOVEL     'XQQ001'      ABSARN
     C                   MOVEL     N@NAR         ABSARD
     C                   Z-ADD     AGRDNB        ABLCD
     C                   MOVEL     'I'           ABTYLC
     C**********         WRITE     @SARDL0                                                  MD058280
     C/EXEC SQL                                                                             MD058280
     C+ INSERT INTO SCSRDBTD                                                                MD058280
     C+ (                                                                                   MD058280
     C+   SARN                                                                              MD058280
     C+ , SARD                                                                              MD058280
     C+ , LCD                                                                               MD058280
     C+ , TYLC                                                                              MD058280
     C+ , ZONE                                                                              MD058280
     C+ , ENABLD                                                                            MD058280
     C+ , MODE                                                                              MD058280
     C+ )                                                                                   MD058280
     C+ VALUES                                                                              MD058280
     C+ (                                                                                   MD058280
     C+   :ABSARN                                                                           MD058280
     C+ , :ABSARD                                                                           MD058280
     C+ , :ABLCD                                                                            MD058280
     C+ , :ABTYLC                                                                           MD058280
     C+ , ' '                                                                               MD058280
     C+ , 'E'                                                                               MD058280
     C+ , 'B'                                                                               MD058280
     C+ )                                                                                   MD058280
     C/END-EXEC                                                                             MD058280
      *                                                                                     MD058280
     C/EXEC SQL                                                                             MD058280
     C+ INSERT INTO SCSRDXTD                                                                MD058280
     C+ (                                                                                   MD058280
     C+   SARN                                                                              MD058280
     C+ , LCD                                                                               MD058280
     C+ , TYLC                                                                              MD058280
     C+ , ZONE                                                                              MD058280
     C+ , ENABLD                                                                            MD058280
     C+ , MODE                                                                              MD058280
     C+ )                                                                                   MD058280
     C+ VALUES                                                                              MD058280
     C+ (                                                                                   MD058280
     C+   :ABSARN                                                                           MD058280
     C+ , :ABLCD                                                                            MD058280
     C+ , :ABTYLC                                                                           MD058280
     C+ , ' '                                                                               MD058280
     C+ , 'E'                                                                               MD058280
     C+ , 'B'                                                                               MD058280
     C+ )                                                                                   MD058280
     C/END-EXEC                                                                             MD058280
      *                                                                                     MD058280
     C                   ELSE                                                               MD058280
     C/EXEC SQL                                                                             MD058280
     C+ UPDATE SCSRDXTD                                                                     MD058280
     C+ SET ENABLD = 'E'                                                                    MD058280
     C+ WHERE SARN = 'XQQ001'                                                               MD058280
     C/END-EXEC                                                                             MD058280
      *                                                                                     MD058280
     C                   ENDIF                                                              MD058280
      *                                                                                     MD058280
     C                   ENDIF
      *
     C                   SETON                                        LR


