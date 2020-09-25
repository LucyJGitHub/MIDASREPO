     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
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
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW017 *CREATE     Date 11Feb99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW017 - Midas/Swift Meridian interface                      *
      *                                                               *
      *****************************************************************
     F*scsardl0* uf a e           k disk                                                    MD055681
      *
     Dn@nar            s             50    inz('Midas-SWIFT Meridian I/F')
      *
     Drundat         e ds                  extname(rundat)
      ** Data Area for run-date
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
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
     C*****'CSW008'      chain     scsardl0                           55                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CSW008'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       55                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        55                    MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
     C                   IF        *IN55 = '1'                                              MD055681
     C***55'CSW017'      chain     scsardl0                           55                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CSW017'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        55                    MD055681
     C                   ENDIF                                                              MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
      *
      ** Check whether feature already on file
     C*****'CQQ004'      chain     scsardl0                           50                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'CQQ004'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   setoff                                       50                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        50                    MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
      *
      ** If action is Insert add feature details if not already there
     C     p@action      ifeq      '1'
     C     p@action      oreq      '2'
     C     *in50         ifeq      *on
     C                   movel     'CQQ004'      ABSARN
     C                   movel     n@nar         ABSARD
     C                   z-add     AGRDNB        ABLCD
     C                   movel     'I'           ABTYLC
     C**********         write     @sardl0                                                  MD055681
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
     C                   endif
     C                   endif
      *
      ** If action is Delete and other interfaces are off, remove
      ** feature CQQ004
     C     p@action      ifeq      '3'
     C     *in55         andeq     *on
     C     *in50         andeq     *off
     C***********        delete    @sardl0                                                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDCTD                                                                MD055681
     C+ where SARN = 'CQQ004'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDXTD                                                                MD055681
     C+ where SARN = 'CQQ004'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   endif
      *
     C                   seton                                        lr
