     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG FTP Transmission Parameters Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3612 - Midas CG FTP Transmission Parameters Retrieval      *
      *                                                               *
      *  Function:  This module will retrieve parameters for the FTP  *
      *             command generator                                 *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCG016             Date 13Sep06               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD053             Date 07Jul06               *
      *                 CCG015  *CREATE    Date 18Mar02               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG016 - Correspondence Manager for Retail Teller System     *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * INIT - Initialise                                             *
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
      * PUT FTP command
     D Put             C                   'PUT'
 
      * ASCII FTP command
     D Ascii           C                   'ASCII'
 
      * BINARY FTP command
     D Binary          C                   'BINARY'
 
      * NAME 1 FTP command (Change file system to HFS)
     D Name1           C                   'NAME 1'
     D TellerP         C                   '/CorrespondenceManagerTeller'                     CCG016
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Correspondence Manager ICD
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)
 
      * Data Structure (long) used by Access Programs
     D Dsldy         E DS                  EXTNAME(DSLDY)
                                                                                              CCG016
      ** For QUSRJOBI                                                                         CCG016
     D WWRTRN          DS           187                                                       CCG016
     D  WWJOB                117    126                                                       CCG016
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CCG016
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      * Entry Parameters
     D RtnCode         S             10
     D StreamFile      S             20
     D SourceDir       S            100
     D DestDir         S            100
     D Action          S             10
     D Option          S             50    DIM(15)
     D User            S             20
     D Password        S             20
     D Host            S             30
 
      * Parameters for AOCORMR0
     D Rtcd            S              7
     D Optn            S              7
                                                                                              CCG016
     D WWLENG          S              4B 0                                                    CCG016
     D WWINPT          S              8A                                                      CCG016
     D WWQUAL          S             26A                                                      CCG016
     D WWINTR          S             16A                                                      CCG016
 
      * Procedures interfaces
     D FullPathName    PR           100
     D StreamF                       20    VALUE
     D Directory                     75    VALUE
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
 
      * Initialise variables  and retrieve ICD
     C                   EXSR      INIT
      * Format Source directory
     C                   EVAL      SourceDir = FullPathName(StreamFile:CMLODI)
      * Format Destination directory
      * If job was submitted by UDC_TELLER, set destination directory to                      CCG016
     C                   IF        WWJOB = 'UDC_TELLER'                                       CCG016
     C                   EVAL      CMPSDI = *BLANKS                                           CCG016
     C     TellerP       CAT       LIBR          CMPSDI                                       CCG016
     C                   ENDIF                                                                CCG016
     C                   EVAL      DestDir = FullPathName(StreamFile:CMPSDI)
      * Action
     C                   EVAL      Action = Put
      * Options
     C                   EVAL      Option(1) = Binary
     C                   EVAL      Option(2) = Name1
      * Username
     C                   EVAL      User = CMFUSR
      * Password
     C                   EVAL      Password = CMFPWD
      * Host (IP Address)
     C                   EVAL      Host = CMPSIP
 
     C                   SETON                                        LR
 
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT   - Initialisation                                       *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     INIT          BEGSR
 
      * Initialise variables
 
     C                   EVAL      SourceDir = *BLANKS
     C                   EVAL      DestDir = *BLANKS
     C                   EVAL      Action = *BLANKS
     C                   CLEAR                   Option
     C                   EVAL      User = *BLANKS
     C                   EVAL      Password = *BLANKS
     C                   EVAL      Host = *BLANKS
 
      * Retrieve Correspondence Manager ICD
 
     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy
 
     C                   IF        %ERROR OR Rtcd <> *BLANK
     C                   EVAL      RtnCode = '*ERROR'
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WWRTRN = *BLANKS                                           CCG016
     C                   Z-ADD     187           WWLENG                                       CCG016
     C                   EVAL      WWINPT = 'JOBI0300'                                        CCG016
     C                   EVAL      WWQUAL = *BLANKS                                           CCG016
     C                   EVAL      WWINTR = *BLANKS                                           CCG016
                                                                                              CCG016
     C                   CALL      'QUSRJOBI'                                                 CCG016
     C                   PARM                    WWRTRN                                       CCG016
     C                   PARM                    WWLENG                                       CCG016
     C                   PARM                    WWINPT                                       CCG016
     C                   PARM      '*'           WWQUAL                                       CCG016
     C                   PARM                    WWINTR                                       CCG016
     C                   IN        SDSTAT                                                     CCG016
                                                                                              CCG016
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
 
     C     *entry        PLIST
     C                   PARM                    RtnCode
     C                   PARM                    StreamFile
     C                   PARM                    SourceDir
     C                   PARM                    DestDir
     C                   PARM                    Action
     C                   PARM                    Option
     C                   PARM                    User
     C                   PARM                    Password
     C                   PARM                    Host
 
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
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FullPathName - Formats the full path name                     *
      *                                                               *
      *****************************************************************
     PFullPathName     B
 
     D FullPathName    PI           100
     D  StreamF                      20    VALUE
     D  Directory                    75    VALUE
 
      * Full Path
     D Path            S            100
 
      * Unix style directory
     D Unix            C                   '/'
 
      * Windows style directory
     D Windows         C                   '\'
 
      * Position of '/' in directory
     D Pos             S              5U 0
 
      * Check whether it's a Windows or Unix Directory
     C                   EVAL      Pos = %SCAN(Unix:Directory)
 
      * Format as a Windows directory path
     C                   IF        Pos = 0
 
      * If it is the root directory, just append the stream file name
      * to the end of the directory, else, append '\' before the stream
      * file name before appending it to the end of the directory
     C                   IF        %SUBST(Directory:4:1) = *BLANKS
     C                   EVAL      Path = %TRIM(Directory) + %TRIM(StreamF)
     C                   ELSE
     C                   EVAL      Path=%TRIM(Directory)+Windows+%TRIM(StreamF)
     C                   ENDIF
 
      * Format as a Unix directory path
     C                   ELSE
 
      * If it is the root directory, just append the stream file name
      * to the end of the directory, else, append '/' before the stream
      * file name before appending it to the end of the directory
     C                   IF        %SUBST(Directory:2:1) = *BLANKS
     C                   EVAL      Path = %TRIM(Directory) + %TRIM(StreamF)
     C                   ELSE
     C                   EVAL      Path = %TRIM(Directory)+Unix+%TRIM(StreamF)
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN    Path
     P                 E
