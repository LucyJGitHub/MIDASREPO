     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Directories purging')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3632 - Directories Purging                                 *
      *                                                               *
      *  Function:  This module removes backup directories (that are  *
      *             formatted like CCYYMMDD).                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSD053             Date 07Jul06               *
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         Indicator to test Directory Name Format         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRDATE - SR to convert date in CCYYMMDD format to day number  *
      * *PSSR  - Error Processing                                     *
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
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      **
      ** Midas Local Data Area for database error reporting; based on
      ** external file
      **
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Directory Entry Information
 
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
 
      ** Correspondence Manager ICD
 
     D SDCORM        E DS                  EXTNAME(SDCORMPD)
 
      ** Bank details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Structure used by Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data Structure (long) used by Access Programs
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Prototypes required for the IFS APIs
 
      /COPY CGCPYSRC,IFSPROTO
      /COPY CGCPYSRC,OPENDFN
 
      ** Return code IBM API for RMDIR
 
     D RC              S             10I 0
 
      ** Return code IBM API for CLOSEDIR
 
     D RC2             S             10I 0
 
     D ReturnCode      S             10
 
     D pathToRmv       S             94
 
     D PRtCd           S              7A
 
     D POptn           S              7A
 
     D pDir            S               *
 
     D pDirEnt         S               *
 
     D WRunDay         S              5  0
 
     D isDirDate       S              8
 
     D WDateIn         S              8
 
     D WDayNumber      S              5  0
 
     D WDirDate        S              5  0
 
     D WRetention      S              3  0
 
     D WRun            S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Open directory
 
     C                   EVAL      pDir = OpenDir(%TRIM(CMLODI))
 
      ** Read directory entry
 
     C                   EVAL      pDirEnt = ReadDir(pDir)
 
     C                   DOW       pDirEnt <> *NULL
 
     C                   EVAL      pathToRmv = %TRIM(CMLODI) + '/' +
     C                                       %SUBST(d_name:1:d_namelen)
 
      ** The entry read must be a real directory
 
     C                   IF        %SUBST(d_name:1:d_namelen) <> '.'
     C                             AND %SUBST(d_name:1:d_namelen) <> '..'
     C                             AND OpenDir(%TRIM(pathToRmv)) <> *NULL
 
      ** The directory name is a backup directory
      ** Its name is a date with format CCYYMMDD
 
     C                   EVAL      isDirDate = %SUBST(d_name:1:8)
 
     C     *ISO0         TEST(D)                 isDirDate              90
 
     C                   IF        *IN90 <> '1'
     C                   EXSR      SRDate
 
     C     WDirDate      IFLE      WRunday
 
      ** Remove all the files inside the directory
 
     C                   CALLB     'CG3633'
     C                   PARM                    ReturnCode
     C                   PARM                    pathToRmv
 
     C                   IF        ReturnCode = *BLANK
     C                   EVAL      RC = rmdir(%TRIM(pathToRmv))
 
      ** If operation is not successful
 
     C                   IF        RC = -1
     C     *LOCK         IN        LDA
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE =  'CG3632'
     C                   EVAL      DBKEY  =  'RMVDIR'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE =  'CG3633'
     C                   EVAL      DBKEY  = pathToRmv
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read directory entry
 
     C                   EVAL      pDirEnt = ReadDir(pDir)
     C
     C                   ENDDO
 
      ** Close the directory
 
     C                   EVAL      RC2 = CloseDir(PDir)
 
     C                   MOVE      *ON           *INLR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate - Subroutine to Convert Dates                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   EVAL      WDateIn = *BLANKS
     C                   EVAL      WDayNumber = *ZEROS
     C                   EVAL      WRetention = *ZEROS
     C                   EVAL      WDirDate = *ZEROS
 
     C                   EVAL      WDateIn = isDirDate
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    WDateIn
     C                   PARM                    WDayNumber
 
     C                   MOVEL     CMRETP        WRetention
     C     WDayNumber    ADD       WRetention    WDirDate
 
     C                   ENDSR
 
      *****************************************************************
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
     C                   PARM                    ReturnCode
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL(E)   'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        %ERROR OR PRtcd = '*ERROR '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Local Directory
 
     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDCORM        PARM      *BLANKS       DSLDY
 
      ** Database error
 
     C                   IF        %ERROR OR PRtcd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     BJRDNB        WRunDay
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
