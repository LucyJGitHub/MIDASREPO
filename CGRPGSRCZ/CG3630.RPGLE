     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Directory Explorer')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3630 - Midas CG Directory Explorer                         *
      *                                                               *
      *  Function:  This module will read the directory entry and     *
      *             decide whether the stream file need to be         *
      *             transmitted or deleted                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. BA6020             Date 23Jan23               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CCG015  *CREATE    Date 21Aug01               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA6020 - Add specific header field to CM XML output          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  CCG015 - Correspondence Manager Phase 1                      *
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

     FCGUDCLL3  IF   E           K DISK
     FCGXDCLL2  IF   E           K DISK

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
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)

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
     D*PathName******  S            100                                                       BA6020
     D*CtlPathName***  S            100                                                       BA6020
     D*StreamF*******  S             16                                                       BA6020
     D PathName        S            150                                                       BA6020
     D CtlPathName     S            150                                                       BA6020
     D StreamF         S             66                                                       BA6020
     D BA6020          S              1A   INZ('N')                                           BA6020
     D PRTCD           S              7A                                                      BA6020
     D POPTN           S              7A                                                      BA6020
     D PSARD           S                   LIKE(SARN)                                         BA6020
     D DatExists       S              1A   INZ('N')                                           BA6020
     D StartExt        S              5I 0                                                    BA6020
      *                                                                                       BA6020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  BA6020
      ** Externally described DS for SAR Details                                              BA6020
      *                                                                                       BA6020
     D DirName         S             75
     D Transmitted     S              1
     D StmfEntry       S              1
     D BackupDirName   S             84

      * Keylist for logfiles
     D KStmf           S                   LIKE(DLSTFN)
     D KMsgId          S                   LIKE(DLMSID)

      * *ENTRY parameters
     D RtnCde          S             10
     D*Stmf*****       S             20                                                       BA6020
     D Stmf            S             70                                                       BA6020

      * Return code for OPENDIR() API
     D pDir            S               *
     D pDir2           S               *

      * Parameters for OPEN() API
     D FDescDat        S             10I 0
     D FDescCtl        S             10I 0
     D*Oflag****       S             10I 0                                                    CSD053
     D Oflag           S             10I 0 INZ                                                CSD053
     D Mode1           S             10I 0 INZ                                                CSD053
     D Ccsid           S              5  0                                                    CSD053

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

     D*FullPathName*** PR           100                                                       BA6020
     D*DirectoryName**               75    VALUE                                              BA6020
     D*StreamFile*****               16    VALUE                                              BA6020
     D FullPathName    PR           150                                                       BA6020
     D DirectoryName                 75    VALUE                                              BA6020
     D StreamFile                    66    VALUE                                              BA6020
     D Mode                           1    VALUE

     D*BackupPath***   PR           105
     D BackupPath      PR           155                                                       BA6020
     D BckUpDrNm                           VALUE LIKE(BackupDirName)
     D*StrmFile***                   16    VALUE                                              BA6020
     D StrmFile                      66    VALUE                                              BA6020
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

      * Read directory for all .dat stream file entries
     C                   EVAL      pDirEnt = READDIR(pDir)

     C                   DOW       pDirEnt <> *NULL

     C                   IF        (BA6020 = 'Y')                                             BA6020
      * Determine if .dat file exists                                                         BA6020
     C                   Z-ADD     *ZEROS        LENGTH            3 0                        BA6020
     C                   EVAL      LENGTH = %LEN(%TRIM(d_name))                               BA6020
     C                   IF        LENGTH > 4                                                 BA6020
     C                   EVAL      StartExt = %SCAN('.DAT':d_name)                            BA6020
     C                   IF        StartExt > 0                                               BA6020
     C                   EVAL      StartExt = StartExt + 1                                    BA6020
     C                   EVAL      DatExists = 'Y'                                            BA6020
     C                   ELSE                                                                 BA6020
     C                   EVAL      DatExists = 'N'                                            BA6020
     C                   ENDIF                                                                BA6020
     C                   ENDIF                                                                BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C**********         IF        %SUBST(d_name:18:3)='DAT'                                  BA6020
     C                   IF        (%SUBST(d_name:18:3)='DAT' AND (BA6020='N'))               BA6020
     C                             OR ((DatExists = 'Y') AND (BA6020 = 'Y'))                  BA6020
      *                                                                                       BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
     C                   EVAL      StreamF = %SUBST(d_name:1:StartExt-2)                      BA6020
     C                   ELSE                                                                 BA6020

     C                   EVAL      StreamF = %SUBST(d_name:1:16)
     C                   ENDIF                                                                BA6020

      * Try to open .dat stream file in exclusive mode
     C                   EVAL      PathName = FullPathName(DirName:StreamF:'D')
     C**********         EVAL      FDescDat = OPEN(%TRIMR(PathName):Oflag)                    CSD053
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName):Oflag :                   CSD053
     C                                                          Mode1 : Ccsid)                CSD053

     C                   IF        FDescDat <> -1

      * Try to open .ctl stream file in exclusive mode (which indicates
      * whether it exists or not aswell)
      *                                                                                       BA6020
      * Stmf needs to contain the standard stream file name, without the prefix set by BA6020.BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
     C                   EVAL      LENGTH = %LEN(%TRIM(StreamF))                              BA6020
     C                   MOVE      *BLANKS       CFN              16                          BA6020
     C                   EVAL      CFN = %SUBST(%TRIM(StreamF):LENGTH-15:16)                  BA6020
     C                   EVAL      CtlPathName=FullPathName(DirName:CFN:'C')                  BA6020
     C                   EVAL      FDescCtl = OPEN(%TRIMR(CtlPathName):Oflag :                BA6020
     C                                                          Mode1 : Ccsid)                BA6020
     C                   ELSE                                                                 BA6020
     C                   EVAL      CtlPathName=FullPathName(DirName:StreamF:'C')
     C**********         EVAL      FDescCtl = OPEN(%TRIMR(CtlPathName):Oflag)                 CSD053
     C                   EVAL      FDescCtl = OPEN(%TRIMR(CtlPathName):Oflag :                CSD053
     C                                                          Mode1 : Ccsid)                CSD053
     C                   ENDIF                                                                BA6020

      * if doesnt exist, delete .dat stream file
      * if doesnt exist, do not delete .dat stream file as .ctl may be created later          BA6020
     C                   IF        FDescCtl = -1
     C**********         EVAL      RC = UNLINK(%TRIMR(PathName))                              BA6020
     C                   ELSE

      * If both files can be accessed in exclusive mode, check it has
      * not already been transmitted. (If it has been already transmitted
      * this means that the backup has failed previously).
     C                   EXSR      ChkTransf

      * If files were not backed up previously, stream file needs to be
      * transmitted
     C                   IF        Transmitted = *BLANKS
     C                   EVAL      StmfEntry = 'Y'
     C                   ENDIF

      * Close .ctl stream file
     C                   EVAL      RC3 = CLOSE(FDescCtl)

     C                   ENDIF
     C                   EVAL      RC3 = CLOSE(FDescDat)
     C                   ENDIF
     C                   ENDIF

      * .dat stream file needs to be transmitted
     C                   IF        StmfEntry = 'Y'
     C                   LEAVE
     C                   ENDIF

      * Read directory
     C                   EVAL      d_name = *blanks
     C                   EVAL      pDirEnt = READDIR(pDir)
     C                   ENDDO

      * Close directory
     C                   EVAL      RC2 = CLOSEDIR(pDir)

      * If streamfile needs to be transmitted, pass streamfile name to
      * calling program else return *NOFILES return code for no file to
      * transmit
     C                   IF        StmfEntry = 'Y'
     C                   EVAL      RtnCde = *BLANKS
     C                   IF        BA6020 = 'Y'                                               BA6020
     C                   EVAL      Stmf = %TRIM(StreamF) + '.DAT'                             BA6020
     C                   ELSE                                                                 BA6020
     C                   EVAL      Stmf = StreamF + '.DAT'
     C                   ENDIF                                                                BA6020
     C                   ELSE
     C                   EVAL      RtnCde = '*NOFILES'
     C                   ENDIF

     C                   SETON                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkTransf - Check if back up of files has failed previously   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: BackUpSF                                               *
      *                                                               *
      *****************************************************************

     C     ChkTransf     BEGSR

      * Stmf needs to contain the standard stream file name, without the prefix set by BA6020.BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
     C                   EVAL      LENGTH = %LEN(%TRIM(StreamF))                              BA6020
     C                   EVAL      KStmF = %SUBST(%TRIM(StreamF):LENGTH-15:16)                BA6020
     C                   ELSE                                                                 BA6020
     C                   EVAL      KStmf = StreamF
     C                   ENDIF                                                                BA6020

      * Check 'backup failed' log on log file
     C     KLogFile      SETLL     CGUDCLL3
      *
      * Check 'backup failed' log on archive log file
     C                   IF        NOT %EQUAL
     C     KLogFile      SETLL     CGXDCLL2

     C                   IF        %EQUAL

      * Attempt to backup stream file
     C                   EXSR      BackUpSF
     C                   EVAL      Transmitted = 'Y'
     C                   ELSE
     C                   EVAL      Transmitted = *BLANKS
     C                   ENDIF

     C                   ELSE

      * Attempt to backup stream file
     C                   EXSR      BackUpSF
     C                   EVAL      Transmitted = 'Y'
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * BackUpSF - Back up stream files                               *
      *                                                               *
      * Called by: ChkBckUp                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     BackUpSF      BEGSR

      * Check if backup directory exists
     C                   EVAL      pDir2 = OPENDIR(%TRIMR(BackupDirName))

      * Create backup directory if it doesn't exist
     C                   IF        pDir2 = *NULL

      *  Set file mode parameter
     C                   EVAL      MKMode = S_IRWXU + S_IRWXG +
     C                                    S_IRWXO

     C                   EVAL      RC4 = MKDIR(%TRIMR(BackupDirName):MKMode)
      *                                                                                       BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
     C                   MOVEL     BackupDirName WrkPath         150                          BA6020
     C                   CALL      'A6C000003'                                                BA6020
     C                   PARM                    WrkPath                                      BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDIF

      * Create link to stream file
     C                   EVAL      NewPth = BackUpPath(BackUpDirName:StreamF)
     C                   EVAL      RC5 = LINK(%TRIMR(PathName):(%TRIMR(NewPth)))

     C                   IF        RC5 <> -1
      * Remove link to stream file
     C                   EVAL      RC = UNLINK(%TRIMR(PathName))
     C                   EVAL      RC = UNLINK(%TRIMR(CtlPathName))
      * Change authority: allow Delete for PUBLIC, so that the purging
      * directory job can delete the stream file
      *                                                                                       BA6020
     C                   IF        BA6020 = 'N'                                               BA6020
      *                                                                                       BA6020
     C                   EVAL      CMMode = S_IRWXU + S_IRWXG + S_IRWXO
     C                   EVAL      RC6 = CHMOD(%TRIMR(NewPth):CMMode)
      *                                                                                       BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDIF

      * Close directory
     C                   EVAL      RC2 = CLOSEDIR(pDir2)

     C                   ENDSR
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

      * Retrieve Correspondence Manager ICD

     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy

     C                   IF        %ERROR OR Rtcd <> *BLANK
     C                   EVAL      RtnCde = '*ERROR'
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF

      * Directory name
     C                   EVAL      DirName = CMLODI

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

      * Backup directory name
     C                   MOVE      SSDAT8        TempAlpha8        8
     C                   EVAL      BackupDirName  = %TRIMR(CMLODI)
     C                             + '/' + TempAlpha8

      * Exclusive mode for OPEN() API
     C                   EVAL      Oflag = O_RDONLY +
     C**********                           O_TEXTDATA + O_SHARE_NONE                          CSD053
     C                                                  O_SHARE_NONE                          CSD053
     C                                                  + O_CCSID                             CSD053
     C                   MOVE      CMFCCS        CCSID                                        CSD053
      * Set file mode parameter                                                               CSD053
     C                   EVAL      Mode1 = S_IRWXU + S_IRWXG +                                CSD053
     C                                     S_IROTH + S_IXOTH                                  CSD053

      * Keylist for Log files
     C     KLogFile      KLIST
     C                   KFLD                    KStmf
     C                   KFLD                    KMsgId

     C                   EVAL      KMsgId = SuccessTrf
     C                   EVAL      StmfEntry = *BLANKS
     C                   CALLB     'AOSARDR0'                                                 BA6020
     C                   PARM      *BLANKS       PRTCD                                        BA6020
     C                   PARM      '*VERIFY'     POPTN                                        BA6020
     C                   PARM      'BA6020'      PSARD                                        BA6020
     C     SCSARD        PARM      SCSARD        DSFDY                                        BA6020
      *                                                                                       BA6020
     C                   IF        PRTCD = *Blanks                                            BA6020
     C                   EVAL      BA6020 = 'Y'                                               BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020

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
     D*FullPathName*** PI           100                                                       BA6020
     D FullPathName    PI           150                                                       BA6020
     D  DirectoryName                75    VALUE
     D**StreamFile****               16    VALUE                                              BA6020
     D  StreamFile                   66    VALUE                                              BA6020
     D  Mode                          1    VALUE
      *
      * Directory pathname
     D*FullPathName*** S            100                                                       BA6020
     D FullPathName    S            150                                                       BA6020

      * Unix style directory
     D Unix            C                   '/'

      * .dat extension
     D Dat             C                   '.DAT'

      * .ctl extension
     D Ctl             C                   '.CTL'

      * Directory pathname
     C                   IF        Mode = 'D'
     C                   EVAL      FullPathName = %TRIM(DirectoryName) +
     C                                          Unix + %TRIM(StreamFile) +
     C                                          Dat
     C                   ELSE
     C                   EVAL      FullPathName = %TRIM(DirectoryName) +
     C                                          Unix + %TRIM(StreamFile) +
     C                                          Ctl
     C                   ENDIF

     C                   RETURN    FullPathName
     P                 E
      /EJECT
      *****************************************************************
      *                                                               *
      * BackupPath - Creates the full pathname for the backing up of  *
      *              stream file                                      *
      *****************************************************************
     PBackupPath       B
     D*BackupPath***   PI           105                                                       BA6020
     D BackupPath      PI           155                                                       BA6020
     D  BckUpDrNm                          VALUE LIKE(BackupDirName)
     D**StrmFile****                 16    VALUE                                              BA6020
     D  StrmFile                     66    VALUE                                              BA6020
      *
      * Backup directory pathname
     D BackupPath      S            105

      * .dat extension
     D Dat             C                   '.DAT'

      * Backup directory pathname
     C                   EVAL      BackupPath = %TRIMR(BckUpDrNM) + '/'
     C                                          + %TRIM(StrmFile)+
     C                                          Dat

     C                   RETURN    BackupPath
     P                 E
