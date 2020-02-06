     h debug   alwnull(*usrctl)
     h copyright('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Clear or Create Export Directory')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNCLRDIR   - Create or Clear Export Directory.               *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRN001  *CREATE    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /copy zacpysrc,psds
      /copy qsysinc/qrpglesrc,qusec
      /copy qsysinc/qrpglesrc,qusgen
      /copy qsysinc/qrpglesrc,quslfld
 
     d pValDs          ds
     d  pValK1                       20
     d  pVal1                       200
     d  pValK2                             like(pValK1)
     d  pVal2                              like(pVal1)
     d  pValK3                             like(pValK1)
     d  pVal3                              like(pVal1)
     d  pValK4                             like(pValK1)
     d  pVal4                              like(pVal1)
     d  pValK5                             like(pValK1)
     d  pVal5                              like(pVal1)
     d  pValK6                             like(pValK1)
     d  pVal6                              like(pVal1)
     d  pValK7                             like(pValK1)
     d  pVal7                              like(pVal1)
     d  pValK8                             like(pValK1)
     d  pVal8                              like(pVal1)
     d  pValK9                             like(pValK1)
     d  pVal9                              like(pVal1)
     d  pValK10                            like(pValK1)
     d  pVal10                             like(pVal1)
 
     d pRtnCod         s              7
 
      /copy rncpysrc,ifsio_h
      /copy rncpysrc,ifstext_h
      /copy rncpysrc,rnpssrdfn
 
     D DirName         S            200A
     D X               S              2  0
     D Y               S              2  0
     D DirArr1         S              1    DIM(200)
     D DirArr2         S              1    DIM(200)
     D Slash           C                   CONST('/')
     D RC              S             10I 0
 
     d pDir            S               *
     d PathName        S            256
     d Name            S            256
     d CheckCSV        s              3  0
     d CheckGZ         s              3  0
     d vRtnCod         s              7
     d xRtnCod         s              7
     d pRtnCd          s              7
     d tempLen         s             10  0
 
      *=====================================================================
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     c                   exsr      cleardir
     c                   exsr      closedown
 
      *****************************************************************
      /EJECT
      * +---------------------------------------------------------+
      * ¦ Subr/CLEARDIR  - Clear the export directory if it exists¦
      * ¦                  and directory entries exist            ¦
      * +---------------------------------------------------------+
     c     cleardir      begsr
 
     c                   eval      PathName    = %trim(pVal1)
     c                                         + x'00'
     c                   eval      pDir        = opendir(%addr(PathName))
 
     c                   if        pDir = *NULL
      *  Process the Directory name and then create as required
     c                   exsr      createdir
     c                   endif
 
      * Read each entry from the directory (in a loop).
     c                   eval      p_DirEnt    = readdir(pDir)
 
     c                   dow       p_DirEnt   <> *NULL
 
      * This code can only handle file/dir names under 256 bytes long
      * because thats the size of "Name"
 
     c                   eval      tempLen     = %scan(x'00' : d_name)
     c                   if        (tempLen < 256  and pVal1  <> *blank)
     c                   eval      Name         = %subst(d_name: 1: d_namelen)
 
     c                   if        Name<>*blank
     c                             and Name <> '.'
     c                             and Name <> '..'
 
     c                   if        unlink(%trim(pVal1) + '/' + %trim(Name)) < 0
     c                   exsr      *pssr
     c                   endif
     c                   endif
 
     c                   endif
 
      * Read Next file
     c                   eval      d_name      = *blanks
     c                   eval      p_DirEnt    = readdir(pDir)
 
     c                   enddo
     c                   endsr
      * +---------------------------------------------------------+
      * ¦ Subr/CREATEDIR - Explore the Directory Name and create  ¦
      * ¦                  each subdirectories as required.       ¦
      * +---------------------------------------------------------+
     C     CREATEDIR     BEGSR
 
      *  Load Directory name into an array field
     C                   eval      DirName=pVal1
     C                   MOVEA     pVal1         DirArr1
 
      *  Initialise work array indeces and set indicator *IN20 = *ON
      *  (this is to simulate a successful 'initial' lookup operation
      *   and to enable the Do While (DOW) operation below).
     C                   EVAL      X = 1
     C                   EVAL      Y = 1
     C                   EVAL      *IN20 = *ON
 
      *  Continue scanning Directory name until no slash is found.
     C                   DOW       *IN20 = *ON
 
      *  Increment index to a value of 2 for 'first time' lookup to
      *  bypass the first slash (i.e. the root directory). At this
      *  point, we are only interested if the directory to be created
      *  is a subdirectory (i.e. '/<dir1>/<dir2>' where <dir2> is a
      *  subdirectory of <dir1>).
     C                   EVAL      X = X + 1
     C     Slash         LOOKUP    DirArr1(X)                             20
 
      *  If slash is found, process the directory name.
     C                   IF        *IN20 = *ON
 
     C                   DOU       Y = X
     C                   MOVE      DirArr1(Y)    DirArr2(Y)
     C                   EVAL      Y = Y + 1
     C                   ENDDO
 
      *  Move the directory name extracted to a character field
      *  and create it.
     C                   MOVEA     DirArr2       DirName
     C                   EXSR      MAKEDIR
 
     C                   ENDIF
 
     C                   ENDDO
 
      *  Load the last remaining directory to create
     C                   MOVEA     DirArr1(Y)    DirArr2(Y)
     C                   MOVEA     DirArr2       DirName
     C                   EXSR      MAKEDIR
 
     C                   ENDSR
 
      /EJECT
      * +---------------------------------------------------+
      * ¦ Subr/MAKEDIR - Create the iSeries Local Directory ¦
      * +---------------------------------------------------+
     C     MAKEDIR       BEGSR
 
      *  Create the iSeries local directory
     C                   eval      rc=mkdir(%TRIM(DirName):S_IRWXU +
     C                                  S_IRWXG + S_IRWXO)
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  closedown -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
 
     c     closedown     begsr
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
 
     c     *inzsr        begsr
 
      * Retrieve Midas AO system value
     c                   eval      pValDs      = *blank
     c                   eval      pValK1      = 'FRSExportDirectory'
 
     c                   call      'AOSVALR0'
     c                   parm      '*DBERR'      pRtnCod
     c                   parm                    pValK1
     c                   parm                    pVal1
     c                   parm                    pValK2
     c                   parm                    pVal2
     c                   parm                    pValK3
     c                   parm                    pVal3
     c                   parm                    pValK4
     c                   parm                    pVal4
     c                   parm                    pValK5
     c                   parm                    pVal5
     c                   parm                    pValK6
     c                   parm                    pVal6
     c                   parm                    pValK7
     c                   parm                    pVal7
     c                   parm                    pValK8
     c                   parm                    pVal8
     c                   parm                    pValK9
     c                   parm                    pVal9
     c                   parm                    pValK10
     c                   parm                    pVal10
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      /copy rncpysrc,rnpssrsr
      /define ERRNO_LOAD_PROCEDURE
