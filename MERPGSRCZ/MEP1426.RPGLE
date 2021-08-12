     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME BIC Directory Explorer')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP1426 - Midas BIC Directory Explorer                       *
      *                                                               *
      *  Function:  This module will read the directory entries to    *
      *             find name of EBCDIC File                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 ESL044  *Create    Date 01Feb2005             *
      * Midas Release 4.01 -------------------------------------------*
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  ESL044 - Local Clearing                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * +--------------------------------------+
      * ¦ Prototypes required for the IFS APIs ¦
      * +--------------------------------------+
      /COPY CGCPYSRC,IFSPROTO
      /COPY CGCPYSRC,OPENDFN

     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D SuccessTrf      C                   'CGD2563'
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Directory Entry Information
     D DirEnt          DS                  BASED(pDirEnt) ALIGN
     D  d_reserved1                  16
     D  d_filenogenid                10U 0
     D  d_fileno                     10U 0
     D  d_reclen                     10U 0
     D  d_reserved3                  10I 0
     D  d_reserved4                   6
     D  d_reserved5                   2
     D  d_nlsinfo                    12
     D   d_ccsid                     10I 0 OVERLAY(d_nlsinfo:1)
     D   d_country_id                 2    OVERLAY(d_nlsinfo:5)
     D   d_lang_id                    3    OVERLAY(d_nlsinfo:7)
     D   d_nls_reserv                 3    OVERLAY(d_nlsinfo:10)
     D  d_namelen                    10U 0
     D  d_name                      640

      **  Correspondence Manager ICD
      * Data Structure (long) used by Access Programs
     D Dsldy         E DS                  EXTNAME(DSLDY)

      * Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * Dummy DS
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D PathName        S            100
     D CtlPathName     S            100
     D StreamF         S             16
     D DirName         S             75
     D Transmitted     S              1
     D StmfEntry       S              1
     D BackupDirName   S             84

      * Keylist for logfiles

      * *ENTRY parameters
     D RtnCde          S             10
     D Stmf            S             20

      * Return code for OPENDIR() API
     D pDir            S               *
     D pDir2           S               *

      * Parameters for OPEN() API
     D FDescDat        S             10I 0
     D FDescCtl        S             10I 0
     D Oflag           S             10I 0

      * Return code for UNLINK() API
     D RC              S             10I 0

      * Parameters for LINK() API
     D RC5             S             10I 0
     D NewPth          S            105

      * Return code for CLOSEDIR() API
     D RC2             S             10I 0

      * Return code for CLOSE() API
     D RC3             S             10I 0

      * Parameters for MKDIR() API
     D RC4             S             10I 0
     D MKMode          S             10I 0

      * Parameters for CHMOD() API
     D RC6             S             10I 0
     D CMMode          S             10I 0

      * Parameters for AOCORMR0
     D Rtcd            S              7
     D Optn            S              7

      * Parameters for ZA0140M
     D SSRTN           S              1
     D SSDAYN          S              5  0
     D SSDFMT          S              1
     D SSDATE          S              6  0
     D SSDATA          S              7
     D SSDAT8          S              8  0
     D SSDAT8F         S              8  0

      * Parameters for AOBANKR0
     D P@RTCD          S              7
     D P@OPTN          S              7

      * Procedures interfaces

     D FullPathName    PR           100
     D DirectoryName                 75    VALUE
     D StreamFile                    16    VALUE
     D Mode                           1    VALUE

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

      * Initialisation
     C                   EXSR      Init

      * Open directory
     C                   EVAL      pDir = OPENDIR(%TRIM(DirName))

      * Read directory for all .EBC stream file entries
     C                   EVAL      pDirEnt = READDIR(pDir)

     C                   DOW       pDirEnt <> *NULL

      * If EBC then note and exit
     C                   IF        %SUBST(d_name:10:3)='EBC'
     C                   EVAL      StreamF = %SUBST(d_name:1:08)
     C                   EVAL      StmfEntry = 'Y'
     C                   ENDIF

      * .EBC stream file needs to be transmitted
     C                   IF        StmfEntry = 'Y'
     C                   LEAVE
     C                   ENDIF

      * Read directory
     C                   EVAL      d_name = *blanks
     C                   EVAL      pDirEnt = READDIR(pDir)
     C                   ENDDO

      * Close directory
     C                   EVAL      RC2 = CLOSEDIR(pDir)

      * If streamfile has been found set return as streamfile name to
      * calling program else return *NOFILES return code for no file to
      * transmit
     C                   IF        StmfEntry = 'Y'
     C                   EVAL      RtnCde = *BLANKS
     C                   EVAL      Stmf = StreamF + '.EBC'
     C                   EVAL      PathName = FullPathName(DirName:StreamF:'D')
     C                   ELSE
     C                   EVAL      RtnCde = '*NOFILES'
     C                   ENDIF

     C                   SETON                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * Init - Program Initialisation routine                         *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     Init          BEGSR

      * Retrieve Directory Name

      * Directory name
     C                   If        PathName = *blanks
     C                   EVAL      DirName = '/QOPT/BICPLUS/EBCDIC'
     C                   Else
     C                   EVAL      DirName = PathName
     C                   Endif

      * Retrieve bank details
     C                   CALLB(E)  'AOBANKR0'
     C                   PARM                    P@RTCD
     C                   PARM      '*FIRST'      P@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        %ERROR OR P@RTCD = '*ERROR '
     C                   EVAL      RtnCde = '*ERROR'
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF

      * Convert run day number to YYYYMMDD format

     C                   CALLB     'ZA0140M'
     C                   PARM                    SSRTN
     C                   PARM      BJRDNB        SSDAYN
     C                   PARM      BJDFIN        SSDFMT
     C                   PARM                    SSDATE
     C                   PARM                    SSDATA
     C                   PARM                    SSDAT8
     C                   PARM                    SSDAT8F

     C                   EVAL      StmfEntry = *BLANKS

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RtnCde
     C                   PARM                    Stmf
     C                   PARM                    PathName

     C                   ENDSR

      *****************************************************************

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * FullPathName - Creates the full pathname for opening of file  *
      *                in exclusive mode                              *
      *                                                               *
      *****************************************************************
     PFullPathName     B
     D FullPathName    PI           100
     D  DirectoryName                75    VALUE
     D  StreamFile                   16    VALUE
     D  Mode                          1    VALUE
      *
      * Directory pathname
     D FullPathName    S            100

      * Unix style directory
     D Unix            C                   '/'

      * file . extension
     D Dat             C                   '.EBC'

      * Directory pathname
     C                   EVAL      FullPathName = %TRIM(DirectoryName) +
     C                                          Unix + %TRIM(StreamFile) +
     C                                          Dat

     C                   RETURN    FullPathName
     P                 E
      /EJECT
