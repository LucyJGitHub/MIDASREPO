     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Files purging')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3633 - Files Purging                                       *
      *                                                               *
      *  Function:  This module deletes all the files that are in the *
      *             directory.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Prototypes required for the IFS APIs
 
      /COPY CGCPYSRC,IFSPROTO
      /COPY CGCPYSRC,OPENDFN
 
      ** Return code IBM API for UNLINK
 
     D RC              S             10I 0
 
      ** Return code IBM API for CLOSEDIR
 
     D RC2             S             10I 0
 
     D ReturnCode      S             10A
 
     D stmfToRmv       S            100
 
     D PRtCd           S              7A
 
     D POptn           S              7A
 
     D Path            S             94A
 
     D WRun            S              1A
 
     D pDir            S               *
 
     D pDirEnt         S               *
 
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
 
     C                   EVAL      pDir = OpenDir(%TRIM(Path))
 
      ** Read directory entry
 
     C                   EVAL      pDirEnt = ReadDir(pDir)
     C
 
     C                   DOW       pDirEnt <> *NULL
 
      ** In the backup directory there are only files
 
     C                   IF        %SUBST(d_name:1:d_namelen) <> '.'
     C                             AND %SUBST(d_name:1:d_namelen) <> '..'
 
     C                   EVAL      stmfToRmv = (%TRIM(Path)) + '/' +
     C                             %SUBST(d_name:1:d_namelen)
 
      ** Delete the stream file
 
     C                   EVAL      RC = UNLINK(%TRIMR(stmfToRmv))
 
      ** If operation is not successful
 
     C                   IF        RC = -1
     C     *LOCK         IN        LDA
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE =  'CG3633'
     C                   EVAL      DBKEY  =  'UNLINK'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      pDirEnt = ReadDir(pDir)
 
     C                   ENDDO
 
      ** Close the directory
 
     C                   EVAL      RC2 = CloseDir(PDir)
 
     C                   MOVE      *ON           *INLR
 
      **********************************************************************
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
     C                   PARM                    Path
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
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
