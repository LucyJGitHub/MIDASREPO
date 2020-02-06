     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG FTP Feedback Command Generator')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3704 - Midas CG FTP Feedback Command Generator             *
      *                                                               *
      *  Function:  This module prepares a set of FTP commands        *
      *             for Feedback processing (List, Get and Delete)    *
      *             and output to PF/CGFTPCPD.                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSD053             Date 07Jul06               *
      *                 CCG015  *CREATE    Date 21Feb02               *
      *                 xxxxxx             Date ddmmmyy               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  CCG015 - Correspondence Manager (Phase 1)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR    -  Error processing                                  *
      * *INZSR   -  Initialise                                        *
      * SubrInit -  Initialise                                        *
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
     FCGFTPCPD  O    E             DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      * UNIX Directory
      * --------------
     D Unix            C                   '/'
 
      * DIRECTORY  'DIR' command
      * ------------------------
     D Dir             C                   'DIR'
 
      * LIST 'LS' command
      * -----------------
     D List            C                   'LS'
 
      * GET FTP command
      * ---------------
     D Get             C                   'GET'
 
      * DEL FTP command
      * ---------------
     D Delete          C                   'DEL'
 
      * ASCII FTP command
      * -----------------
     D Ascii           C                   'ASCII'
 
      * BINARY FTP command
      * ------------------
     D Binary          C                   'BINARY'
 
      * NAME 1 FTP command (Note: this will change file system to HFS)
      * ------------------
     D Name1           C                   'NAME 1'
 
      * LCD FTP command (Change Local Directory from iSeries side)
      * ---------------
     D ChgLocDir       C                   'LCD'
 
      * QUIT FTP command
      * ----------------
     D QuitFTP         C                   'QUIT'
 
      * Wild Card for .CTL
      * ------------------
     D WildCtl         C                   '*.ctl'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Correspondence Manager ICD
 
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)
 
      * Data Structure (long) used by Access Programs
 
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * *PSSR processing
      * ----------------
     D @Run            S              1
 
      * Entry Parameters
      * ----------------
     D ActParm         S             10
     D JobParm         S             30
     D HstParm         S             30
     D FrqParm         S              5  0
     D RtnParm         S             10
 
      * Parameters for AOCORMR0
      * -----------------------
     D Rtcd            S              7
     D Optn            S              7
 
      * Work variables
      * --------------
     D FTPUser         S             51
     D SourceDir       S            100
     D DestDir         S            100
     D FTPAction       S            100
     D User            S             20
     D Password        S             20
     D UnixFlag        S              3  0 INZ(0)
 
      * Procedures interfaces
      * ---------------------
     D FullPath        PR           100
     D Directory                     75    VALUE
     D PCFileName                    20    VALUE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +------------------Start of Main processing----------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      * Initialise variables  and retrieve SDCORMPD details.
 
     C                   EXSR      SubrInit
 
      * Return IP Address of Print Server for FTP processing
 
     C                   EVAL      HstParm = CMPSIP
 
      * Return Polling Frequency for Feedback processing
 
     C                   MOVEL     CMPFRQ        FrqParm
 
      * Prepare complete set of FTP commands according to action
      * parameter passed.
 
     C                   SELECT
 
      *  Action  = LIST
     C                   WHEN      ActParm = '*LIST     '
     C                   EXSR      SubrFTPList
 
      *  Action  = GET
     C                   WHEN      ActParm = '*GET      '
     C                   EXSR      SubrFTPGet
 
      *  Action  = DELETE
     C                   WHEN      ActParm = '*DELETE   '
     C                   EXSR      SubrFTPDel
 
     C                   ENDSL
 
     C                   SETON                                        LR
 
      *-------------------------------------------------------------------*
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ SubrFTPList - List .CTL files found in Print Server Feedback    ¦
      * ¦               directory.                                        ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     SubrFTPList   BEGSR
 
      * Format full FTP log on (User and Password)
 
     C                   EXSR      SubrFTPUSer
     C                   EVAL      FCCMD = FTPUser
     C                   EXSR      SubrWrite
 
      * Load NAME 1 command (to change file system to HFS)
 
     C                   EVAL      FCCMD = Name1
     C                   EXSR      SubrWrite
 
      * Load LS command + formatted PC Feedback Directory +
      * .CTL file (i.e. 'LS /<Feedback Dir>/xxxx.CTL' for UNIX
      * or 'DIR C:\<Feedback Dir>\xxxx.CTL' for WINDOWS)
 
     C                   EVAL      SourceDir = FullPath(CMFBDI:WildCtl)
 
      * Determine if path is in UNIX or WINDOWS format
 
     C                   EVAL      UnixFlag = %SCAN(UNIX:SourceDir)
 
      * If path is in UNIX format (UnixFlag <> 0), use LS FTP command,
      * otherwise use DIR (for WINDOWS)
 
     C                   IF        UnixFlag = 0
     C                   EVAL      FTPAction = Dir  + ' ' + SourceDir
     C                   ELSE
     C                   EVAL      FTPAction = List + ' ' + SourceDir
     C                   ENDIF
 
     C                   EVAL      FCCMD = FTPAction
     C                   EXSR      SubrWrite
 
      * Load QUIT to exit FTP session
 
     C                   EVAL      FCCMD = QuitFTP
     C                   EXSR      SubrWrite
 
     C                   ENDSR
      * +-----------------------------------------------------------------+
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ SubrFTPGet  - Retrieve .DAT file  for .CTL currently in         ¦
      * ¦               process.                                          ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     SubrFTPGet    BEGSR
 
      * Format full FTP log on (User and Password)
 
     C                   EXSR      SubrFTPUSer
     C                   EVAL      FCCMD = FTPUser
     C                   EXSR      SubrWrite
 
      * Load NAME 1 command (to change file system to HFS)
 
     C                   EVAL      FCCMD = Name1
     C                   EXSR      SubrWrite
 
      * Change iSeries Local Directory to point to iSeries
      * Feedback Directory (this will be target dir for GET command)
 
     C                   EVAL      DestDir = ChgLocDir + ' ' + CMLDFD
     C                   EVAL      FCCMD = DestDir
     C                   EXSR      SubrWrite
 
      * Load FTP GET command
 
     C                   EVAL      SourceDir = FullPath(CMFBDI:JobParm)
     C                   EVAL      FTPAction = Get + ' ' + SourceDir
     C                   EVAL      FCCMD = FTPAction
     C                   EXSR      SubrWrite
 
      * Load QUIT to exit FTP session
 
     C                   EVAL      FCCMD = QuitFTP
     C                   EXSR      SubrWrite
 
     C                   ENDSR
      * +-----------------------------------------------------------------+
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ SubrFTPDel  - Delete .CTL file from Print Server Feedback       ¦
      * ¦               Directory.                                        ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     SubrFTPDel    BEGSR
 
      * Format full FTP log on (User and Password)
 
     C                   EXSR      SubrFTPUSer
     C                   EVAL      FCCMD = FTPUser
     C                   EXSR      SubrWrite
 
      * Load NAME 1 command (to change file system to HFS)
 
     C                   EVAL      FCCMD = Name1
     C                   EXSR      SubrWrite
 
      * Load FTP DEL command
 
     C                   EVAL      SourceDir = FullPath(CMFBDI:JobParm)
     C                   EVAL      FTPAction = Delete + ' ' + SourceDir
     C                   EVAL      FCCMD = FTPAction
     C                   EXSR      SubrWrite
 
      * Load QUIT to exit FTP session
 
     C                   EVAL      FCCMD = QuitFTP
     C                   EXSR      SubrWrite
 
     C                   ENDSR
      * +-----------------------------------------------------------------+
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ SubrFTPUser - Format User and Password for FTP log on.          ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     SubrFTPUser   BEGSR
     C                   EVAL      FTPUser = %TRIM(CMFUSR) + ' ' +
     C                                       %TRIM(CMFPWD)
     C                   ENDSR
      * +-----------------------------------------------------------------+
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ SubrWrite   - Write command to CGFTPCPD command file.           ¦
      * ¦ Called by: various subroutine                                   ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     SubrWrite     BEGSR
 
     C                   WRITE(E)  CGFTPCD0
 
     C                   IF        %ERROR
     C                   EVAL      RtnParm = '*ERROR'
     C                   EVAL      DBFILE =  'CGFTPCPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      * +-----------------------------------------------------------------+
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ SubrInit - Initialisation subroutine                            ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     SubrInit      BEGSR
 
      * Initialise variables
 
     C                   EVAL      FTPAction = *BLANKS
     C                   EVAL      SourceDir = *BLANKS
     C                   EVAL      DestDir = *BLANKS
 
      * Retrieve Correspondence Manager ICD
 
     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy
 
     C                   IF        %ERROR OR Rtcd <> *BLANK
     C                   EVAL      RtnParm = '*ERROR'
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      * +-----------------------------------------------------------------+
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ Subr/*INZSR - Program Initialisation subroutine                 ¦
      * ¦ Called by: Implicitly on program activation                     ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ActParm
     C                   PARM                    JobParm
     C                   PARM                    HstParm
     C                   PARM                    FrqParm
     C                   PARM                    RtnParm
 
     C                   ENDSR
 
      *****************************************************************
 
      *********************************************************************
      /EJECT
      *---------------------------------------------------------------*
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *---------------------------------------------------------------*
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @Run = *BLANK
     C                   EVAL      @Run = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *---------------------------------------------------------------*
      /EJECT
      *---------------------------------------------------------------*
      * FullPath - Formats the full path name (includes the Feedback  *
      *            directory plus the File Name) as UNIX or WINDOWS   *
      *---------------------------------------------------------------*
     PFullPath         B
 
     D FullPath        PI           100
     D  Directory                    75    VALUE
     D  PCFileName                   20    VALUE
 
      * Full Path after formatting (i.e. '/<Directory>/<PCFileName>')
 
     D Path            S            100
 
      * Unix style directory
 
     D Unix            C                   '/'
 
      * Windows style directory
 
     D Windows         C                   '\'
 
      * Position of '/' in directory
     D Pos             S              5U 0
 
      * Check whether it's a Windows or Unix Directory
 
     C                   EVAL      Pos = %SCAN(Unix:Directory)
 
      * Format is Windows directory if Pos = *ZERO
 
     C                   IF        Pos = 0
 
      * If it is the root directory, just append the File name
      * at the end of the Directory, else, append '\' before
      * appending the File Name at the end of the Directory
 
     C                   IF        %SUBST(Directory:4:1) = *BLANKS
     C                   EVAL      Path = %TRIM(Directory) +
     C                                    %TRIM(PCFileName)
     C                   ELSE
     C                   EVAL      Path=%TRIM(Directory) + Windows +
     C                                  %TRIM(PCFileName)
     C                   ENDIF
 
      * Format is UNIX directory path, so format accordingly
     C                   ELSE
 
      * If it is the root directory, just append the file name
      * to the end of the directory, else, append '/' before
      * appending the File Name at the end of the Directory
 
     C                   IF        %SUBST(Directory:2:1) = *BLANKS
     C                   EVAL      Path = %TRIM(Directory) +
     C                                    %TRIM(PCFileName)
     C                   ELSE
     C                   EVAL      Path = %TRIM(Directory) + Unix +
     C                                    %TRIM(PCFileName)
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN    Path
     P                 E
