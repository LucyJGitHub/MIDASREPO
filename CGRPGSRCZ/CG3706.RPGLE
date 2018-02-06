     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Read FTP Control File')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3706 - Midas CG Read FTP Control File                      *
      *                                                               *
      *  Function:  For each call to this program, a .CTL record      *
      *             is read from PF/CGOUTFPD, formats the name of     *
      *             its corresponding .LOG file and returns the       *
      *             .LOG file name back to main Feedback CL program.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 22Feb02               *
      *                 XXXXXX             Date DDMmmYY               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     FCGOUTFL0  IF   E             DISK
 
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
     D LogString       C                   '.log'
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      * Work variables
      * --------------
     D LogArr          S              1    DIM(50)
     D Idx1            S              3  0
     D WPos1           S              3  0
     D WPos2           S              3  0
     D Ctl_Eof         S              1
     D LogPrtd         S              1
 
      * *PSSR processing
      * ----------------
     D @Run            S              1
 
      * Entry Parameters
      * ----------------
     D LogFileName     S             30
     D CtlFileName     S             30
     D RtnCode         S             10
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *+----------------- Start of Main processing ---------------------+
      *¦                                                                ¦
      *¦ Initial processing is performed automatically: the *INZSR is   ¦
      *¦ executed at program activation.                                ¦
      *¦                                                                ¦
      *+----------------------------------------------------------------+
 
      *+----------------------------------------------------------------+
      *¦ Main Procedure                                                 ¦
      *+----------------------------------------------------------------+
 
      * Initialise return parameters
 
     C                   EVAL      RtnCode = *Blanks
     C                   EVAL      LogFileName = *Blanks
     C                   EVAL      CtlFileName = *Blanks
 
      * Read a .CTL record
 
     C                   EXSR      ReadCtlFile
 
      * Process FTP log file until end of file is reached.
 
     C                   DOW       Ctl_Eof <> '1'
 
      * Skip record if Processed Flag is already 'P'
      * (NOTE: Processed Flag will only be updated to
      *        'P' after successful update of Item
      *        Status and a UDC log record for action
      *        CGD2615 (Printed by FMaster) is written)
 
     C                   IF        CTLSTS = *BLANK
 
      * Retrieve .CTL file name and format it to get the
      * corresponding .LOG file name.
 
     C                   EVAL      CtlFileName = CTLREC
     C                   EVAL      LogFileName = *BLANKS
 
     C                   EXSR      FormatRcd
 
      * If .LOG File Name is not blank after formatting, leave
      * DOW loop and pass back .CTL and .LOG file names to calling
      * Feedback job.
 
     C                   IF        LogFileName <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
      * Read a .CTL record
 
     C                   EXSR      ReadCtlFile
 
     C                   ENDDO
 
      * If .LOG file name is blank, no record is read from file so
      * set Return Code accordingly to be processed by calling program.
 
     C                   IF        LogFileName = *BLANKS
     C                   EVAL      RtnCode = '*NORECORD '
     C                   ENDIF
 
     C                   SETON                                        LR
      **********************************************************************
 
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ ReadCtlFile - Read control file (PF/CGOUTFPD)                   ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     ReadCtlFile   BEGSR
 
      * Read file
     C                   READ(E)   CGOUTFL0
 
      * Database error processing (if %ERROR)
 
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR'
     C                   EVAL      DBFILE =  'CGOUTFPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save current %EOF setting (value is '0' if not EOF, '1' if EOF)
 
     C                   EVAL      Ctl_Eof = %EOF
 
     C                   ENDSR
      *--------------------------------------------------------------------*
 
      /EJECT
      * +-----------------------------------------------------------------+
      * ¦ FormatRcd   - Replace .CTL file extention with '.log'.          ¦
      * ¦ Called by: MAIN                                                 ¦
      * ¦ Calls: None                                                     ¦
      * +-----------------------------------------------------------------+
     C     FormatRcd     BEGSR
 
      * Get the position of string '.ctl' in the record.
 
     C     CtlString     SCAN      CTLREC        Wpos1
 
      * If string is found, load record into a work array.
 
     C                   IF        WPos1 <> 0
 
     C                   MOVEA     CTLREC        LogArr
 
      * Use the position of '.CTL' in the string and replace it
      * with '.LOG'.
 
     C                   MOVEA     LogString     LogArr(WPos1)
 
      * Load the formatted name into return parameter to be passed
      * to calling program.
 
     C                   MOVEA     LogArr        LogFileName
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
     C                   PARM                    LogFileName
     C                   PARM                    CtlFileName
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
