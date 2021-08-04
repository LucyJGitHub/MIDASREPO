     h debug   alwnull(*usrctl)
     h copyright('(c) Finastra Systems Technology, Inc. 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Make a Directory')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPMAKDIR  - Make a Directory                                 *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1     *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     D COMMA           S              1    DIM(1) CTDATA PERRCD(1)
 
      /copy zacpysrc,psds
      /copy qsysinc/qrpglesrc,qusec
      /copy qsysinc/qrpglesrc,qusgen
      /copy qsysinc/qrpglesrc,quslfld
 
      /copy zacpysrc,ifsio_h
      /copy zacpysrc,ifstext_h
 
     D DirName         S            200A
     D #X              S              2  0
     D #Y              S              2  0
     D DirArr1         S              1    DIM(200)
     D DirArr2         S              1    DIM(200)
     D Slash           C                   CONST('/')
     D RC              S             10I 0
 
     d pDir            S               *
     d PathName        S            256
     d Name            S            256
     d tempLen         s             10  0
 
 
      *  Create the Directory name if required
 
     c                   eval      PathName    = %trim(Directory)
     c                                         + x'00'
     c                   eval      pDir        = opendir(%addr(PathName))
 
     c                   if        pDir = *NULL
     c                   exsr      createdir
     c                   endif
 
     c                   exsr      closedown
 
      *****************************************************************
     C     CREATEDIR     BEGSR
 
      *  Load Directory name into an array field
     C                   eval      DirName=Directory
     C                   MOVEA     Directory     DirArr1
 
      *  Initialise work array indeces and set indicator *IN20 = *ON
      *  (this is to simulate a successful 'initial' lookup operation
      *   and to enable the Do While (DOW) operation below).
     C                   EVAL      #X = 1
     C                   EVAL      #Y = 1
     C                   EVAL      *IN20 = *ON
 
      *  Continue scanning Directory name until no slash is found.
     C                   DOW       *IN20 = *ON
 
      *  Increment index to a value of 2 for 'first time' lookup to
      *  bypass the first slash (i.e. the root directory). At this
      *  point, we are only interested if the directory to be created
      *  is a subdirectory (i.e. '/<dir1>/<dir2>' where <dir2> is a
      *  subdirectory of <dir1>).
 
     C                   EVAL      #X = #X + 1
     C     Slash         LOOKUP    DirArr1(#X)                            20
 
      *  If slash is found, process the directory name.
     C                   IF        *IN20 = *ON
 
     C                   DOU       #Y = #X
     C                   MOVE      DirArr1(#Y)   DirArr2(#Y)
     C                   EVAL      #Y = #Y + 1
     C                   ENDDO
 
      *  Move the directory name extracted to a character field
      *  and create it.
     C                   MOVEA     DirArr2       DirName
     C                   EXSR      MAKEDIR
 
     C                   ENDIF
 
     C                   ENDDO
 
      *  Load the last remaining directory to create
     C                   MOVEA     DirArr1(#Y)   DirArr2(#Y)
     C                   MOVEA     DirArr2       DirName
     C                   EXSR      MAKEDIR
 
     C                   ENDSR
      *****************************************************************
     C     MAKEDIR       BEGSR
 
      *  Create the iSeries local directory
 
     C                   eval      rc=mkdir(%TRIM(DirName):S_IRWXU +
     C                                  S_IRWXG + S_IRWXO)
 
     C                   ENDSR
      *****************************************************************
     c     closedown     begsr
     c                   eval      *inlr       = *on
     c                   return
     c                   endsr
      *********************************************************************
     c     *inzsr        begsr
     C     *ENTRY        PLIST
     C                   PARM                    Directory        50
     C     COMMA(1)      SCAN      Directory                              99
     C   99              EXSR      *PSSR
     c                   endsr
      *********************************************************************
     C     *PSSR         BEGSR
     C                   IF        ERR <> 'Y'
     C                   MOVE      'Y'           ERR               1
     C                   DUMP
     C                   SETON                                        LR
     C                   ENDIF
     C                   RETURN
     C                   ENDSR
      *********************************************************************
      /EJECT
      /define ERRNO_LOAD_PROCEDURE
**
'
