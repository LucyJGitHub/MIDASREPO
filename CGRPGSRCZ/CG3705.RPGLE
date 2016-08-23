     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Extract CTL File Name')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3705 - Midas CG Extract .CTL file from FTP Log             *
      *                                                               *
      *  Function:  This module retrieves all .CTL files from log     *
      *             generated from last FTP LIST (LS) processing.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 221287             Date 07Jul05               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 21Feb02               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  221287 - Increase wcount                                     *
      *  CCG015 - Correspondence Manager (Phase 1)                    *
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
 
     FCGFTPLPD  IF   E             DISK
     FCGOUTFPD  O    E             DISK    COMMIT
 
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
     D CtlString       C                   '.ctl'
     D BlankChar       C                   ' '
     D Asterisk        C                   '*'
     D ForwardSlash    C                   '/'
     D BackSlash       C                   '\'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Work variables
      * --------------
     D LogArr          S              1    DIM(210)
     D x               S              3  0
     D WPos1           S              3  0
     D WPos2           S              3  0
     D WLen            S              3  0
     D*WCount***       S              3  0 INZ(0)                                             221287
     D WCount          S              4  0 INZ(0)                                             221287
     D CtlFileName     S             30
     D Log_Eof         S              1    INZ('0')
 
      * *PSSR processing
      * ----------------
     D @Run            S              1
 
      * Entry Parameters
      * ----------------
     D RtnCode         S             10
 
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
 
      *+------------------------------------------------------------------+
      *¦ Main Procedure                                                   ¦
      *+------------------------------------------------------------------+
 
      * Read a log record
 
     C                   EXSR      ReadLog
 
      * Process FTP log file until end of file is reached.
 
     C                   DOW       Log_Eof <> '1'
 
      * Initialise Control File Name
 
     C                   EVAL      CtlFileName = *BLANKS
 
      * Scan the record for .CTL filename
 
     C                   EXSR      ScanRcd
 
      * If Control File Name is not blank during last scan, write
      * the value into the file
 
     C                   IF        CtlFileName <> *BLANKS
     C                   EXSR      WriteFile
     C                   EVAL      WCount = WCount + 1
     C                   ENDIF
 
      * Read a log record
 
     C                   EXSR      ReadLog
 
     C                   ENDDO
 
      * If no .CTL record is found, set return code
 
     C                   IF        WCount = 0
     C                   EVAL      RtnCode = '*NORECORD '
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   SETON                                        LR
      **********************************************************************
 
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ ReadLog     - Read log file.                                    ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     ReadLog       BEGSR
 
      * Read log file
     C                   READ      CGFTPLPD
 
      * Database error processing (if %ERROR)
 
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR'
     C                   EVAL      DBFILE =  'CGFTPLPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save current %EOF setting ('0' if not EOF)
 
     C                   EVAL      Log_Eof = %EOF
 
     C                   ENDSR
      *--------------------------------------------------------------------*
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ ScanRcd     - Scan FTP log record for .CTL filename, if any.    ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     ScanRcd       BEGSR
 
      * Calculate the actual length of the log record.
 
     C     BlankChar     CHECKR    FCLOG         WLen
 
      * Get the position of string '.ctl' in the log record.
 
     C     CtlString     SCAN      FCLOG         Wpos1
 
      * If string is found and it is not a wild card (i.e. '*.ctl')
 
     C                   IF        (WPos1 <> 0) AND (WPos1 < WLen)
     C                             AND (%SUBST(FCLOG:WPos1-1:1) <> Asterisk)
 
      * A records with string '.ctl' is found, load into a work array
      * for further processing.
 
     C                   MOVEA     FCLOG         LogArr
 
      * Starting from the position of '.ctl' string, scan backward one
      * element at a time until the slash is found.
 
     C                   EVAL      x = WPos1
     C                   DOU       (LogArr(x) = ForwardSlash)
     C                             OR (LogArr(x) = BackSlash)
     C                             OR (x = 1)
     C                   EVAL      x = x - 1
     C                   ENDDO
 
      * Load control file name into CGOUTFPD file field name
 
     C                   EVAL      CtlFileName = %SUBST(FCLOG:x+1:WLen-x)
 
     C                   ENDIF
 
     C                   ENDSR
      *--------------------------------------------------------------------*
 
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ WriteFile   - Write .ctl file name into CGOUTFPD.               ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     WriteFile     BEGSR
 
      * Load .ctl filename into record field name
 
     C                   EVAL      CTLREC = CtlFileName
     C                   EVAL      CTLSTS = *Blank
 
      * Output record to file
 
     C                   WRITE(E)  CGOUTFD0
 
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR'
     C                   EVAL      DBFILE =  'CGOUTFPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *--------------------------------------------------------------------*
 
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ Subr/*INZSR - Program Initialisation subroutine                 ¦
      * ¦ Called by: Implicitly on program activation                     ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCode
 
     C                   ENDSR
      *--------------------------------------------------------------------*
 
      /EJECT
      *---------------------------------------------------------------*
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      * Called by: (**calling routines**)                             *
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
