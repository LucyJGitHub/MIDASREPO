     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Correspondence Explorer')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3703 - Midas CG Correspondence Explorer                    *
      *                                                               *
      *  Function:  This module will scan the UDC log files           *
      *             CGUDCLPD and CGXDCLPD for Items sent              *
      *             to FormsMaster currently awaiting feedback.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 248399A            Date 03Jul07               *
      *  Prev Amend No. 248399             Date 11Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 07Jul06               *
      *                 229939             Date 02Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 05Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  248399A - Change file names fr CGUDCRL#1 to CGUDCRL9;        *
      *            CGXDCRL#1 to CGXDCRL9.                             *
      *  248399 - Warning with wrong number of Items awaiting         *
      *           feedback.                                           *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  229939 - Do not update DLPROC.                               *
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
 
     FCGUDCLL4  UF   E           K DISK
      ** Current UDC log file
 
     FCGXDCLL3  UF   E           K DISK
      ** Archive UDC log file
 
     F*CGUDCRL#1 IF   E           K DISK                                               248399248399A
     FCGUDCRL9  IF   E           K DISK                                                      248399A
      ** Current with PRTQ status                                                             248399
                                                                                              248399
     F*CGXDCRL#1 IF   E           K DISK                                               248399248399A
     FCGXDCRL9  IF   E           K DISK                                                      248399A
      ** Archive with PRTQ status                                                             248399
                                                                                              248399
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
      **       Defines:                     134 141 DBFILE
      **                                    142 170 DBKEY
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
 
      ** +--------------------+
      ** ¦ Declared variables ¦
      ** ¦ ================== ¦
      ** +--------------------+
 
     D @Run            S              1
     D eof_curr        S              1
     D eof_arch        S                   LIKE(eof_curr)
     D RecFound        S              5  0
     D ErrItem         S              5  0
     D cErrItem        S              5
     D NbrErrItem      S              5
     D ElapTime        S              6  0
     D TotalMaxPrt     S              6  0
     D MaxPollTime     S              5
     D TotalMaxPoll    S              6  0
 
      * +-------------------------+
      * ¦ Parameters for AOCORMR0 ¦
      * +-------------------------+
     D Rtcd            S              7    INZ(*BLANK)
     D Optn            S              7    INZ(*BLANK)
 
      ** +-------------------+
      *  ¦ *ENTRY parameters ¦
      ** ¦ ================= ¦
      ** +-------------------+
 
     D RtnCode         S             10
     D Items           S              5
 
      ** +-----------------+
      ** ¦ Data Structures ¦
      ** ¦ =============== ¦
      ** +-----------------+
 
      **  Correspondence Manager ICD
 
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)
 
      * Data Structure (long) used by Access Programs
 
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
      * Data Structure to hold Maximum Print Wait Time for Item
 
     D MaxPrtTime      DS
     D   MaxMin                       2  0
     D   MaxSec                       2  0
 
      * Function to remove preceeding zeros in alphanumeric fld.
 
     DTrimZero         PR             5
     D cErrItem                       5    VALUE
 
      * Function to calculate elapsed time for an Iten sent.
 
     DCalcElapse       PR             6  0
     D ElapseTime                     6  0 VALUE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +----------------- Start of Main processing ---------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *-------------------------------------------------------------------*
      * MAIN PROCEDURE                                                    *
      *-------------------------------------------------------------------*
      * *--------------------------------------------------*
      * ¦Calculate Maximum Print Wait Time in unit Seconds ¦
      * *--------------------------------------------------*
      *Load Maximum Print Wait Time retrieved from CM ICD
 
     C                   EVAL      MaxPrtTime = CMPRTW
 
     C                   EVAL      TotalMaxPrt = (MaxMin * 60) +
     C                                            MaxSec
 
      * *-----------------------------------*
      * ¦SCAN CURRENT UDC LOG FILE CGUDCLPD ¦
      * *-----------------------------------*
      * Initialise work variables
 
     C                   EVAL      eof_curr = *OFF
 
      * Read current log file until EOF is reached or while a
      * record with blank PDF file name is found (this selection
      * criteria is inherent to the LF used over CGUDCLPD).
 
     C                   DOW       eof_curr = *OFF
 
     C                   EXSR      ReadCurr
 
     C                   ENDDO
 
      * *-----------------------------------*
      * ¦SCAN ARCHIVE UDC LOG FILE CGXDCLPD ¦
      * *-----------------------------------*
      * Initialise work variable
 
     C                   EVAL      eof_arch = *OFF
 
      * Read archive log file until EOF is reached or while a
      * record with blank PDF file name is found (this selection
      * criteria is inherent to the LF used over CGUDCLPD).
 
     C                   DOW       eof_arch = *OFF
 
     C                   EXSR      ReadArch
 
     C                   ENDDO
 
      * Set Return code if NO record is read
 
     C                   IF        RecFound = 0
     C                   EVAL      RtnCode = '*NOFILES  '
     C                   ENDIF
 
      * If Item in Error is found, send this back to calling pgm to
      * notify QSYSOPR via Send Message.
 
      * Calculate number of items awaiting feedback based on PRTQ status                      248399
      * Initialise work variables                                                             248399
                                                                                              248399
     C                   EVAL      ErrItem = 0                                                248399
                                                                                              248399
     C                   EVAL      eof_curr = *OFF                                            248399
                                                                                              248399
                                                                                              248399
     C                   DOW       eof_curr = *OFF                                            248399
                                                                                              248399
     C                   EXSR      ReadCurrPRTQ                                               248399
                                                                                              248399
     C                   ENDDO                                                                248399
                                                                                              248399
      * Calculate number of items awaiting feedback based on PRTQ status                      248399
      * Initialise work variables                                                             248399
                                                                                              248399
     C                   EVAL      eof_curr = *OFF                                            248399
                                                                                              248399
                                                                                              248399
     C                   DOW       eof_curr = *OFF                                            248399
                                                                                              248399
     C                   EXSR      ReadArchPRTQ                                               248399
                                                                                              248399
     C                   ENDDO                                                                248399
                                                                                              248399
     C                   IF        ErrItem > 0
     C                   MOVEL     ErrItem       cErrItem
     C                   EVAL      NbrErrItem = TrimZero(cErrItem)
     C                   ENDIF
 
      * Return to calling program.
 
     C                   SETON                                        LR
      *-------------*
      * SUBROUTINES *
      *-------------*
      *-----------------------------------------------------------------*
      * ReadCurr - Subroutine to read Current UDC log file via CGUDCLL4 *
      *-----------------------------------------------------------------*
     C     ReadCurr      BEGSR
     C                   READ(E)   CGUDCLL4
 
      * Handle database error
 
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR    '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If no error, check end of file status
 
     C                   EVAL      eof_curr = %EOF
 
      * If not end of file
 
     C                   IF        eof_curr = *OFF
 
      * Calculate the elapsed time since item was
      * transmitted to FormsMaster.
 
     C                   EVAL      ElapTime = CalcElapse(DLATIM)
 
      * If calculated elapsed time is greater than maximum
      * print wait time, flag this item as 'in error'
 
     C                   IF        ElapTime > TotalMaxPrt
     C                   EVAL      ErrItem = ErrItem + 1
     C**********         EVAL      DLPROC = 'E'                                               229939
     C                   EVAL      DLPROC = ' '                                               229939
     C                   UPDATE    @UDCLL4
 
      * Otherwise, count as valid record
 
     C                   ELSE
     C                   UNLOCK    CGUDCLL4
     C                   EVAL      RecFound = RecFound + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *-----------------------------------------------------------------*                     248399
      * ReadCurrPRTQ  - Subroutine to read LF CGUDCRL#1                                       248399
      *-----------------------------------------------------------------*                     248399
     C     ReadCurrPRTQ  BEGSR                                                                248399
     C**********         READ(E)   CGUDCRL#1                                           248399248399A
     C                   READ(E)   CGUDCRL9                                                  248399A
                                                                                              248399
      * Handle database error                                                                 248399
                                                                                              248399
     C                   IF        %ERROR                                                     248399
     C                   EVAL      RtnCode = '*ERROR    '                                     248399
     C                   EXSR      *PSSR                                                      248399
     C                   ENDIF                                                                248399
                                                                                              248399
      * If no error, check end of file status                                                 248399
                                                                                              248399
     C                   EVAL      eof_curr = %EOF                                            248399
                                                                                              248399
      * If not end of file                                                                    248399
                                                                                              248399
     C                   IF        eof_curr = *OFF                                            248399
     C                   EVAL      ErrItem = ErrItem + 1                                      248399
     C                   ENDIF                                                                248399
                                                                                              248399
     C                   ENDSR                                                                248399
                                                                                              248399
      *-----------------------------------------------------------------*                     248399
      * ReadArchPRTQ  - Subroutine to read LF CGXDCRL#1                                       248399
      *-----------------------------------------------------------------*                     248399
     C     ReadArchPRTQ  BEGSR                                                                248399
     C**********         READ(E)   CGXDCRL#1                                           248399248399A
     C                   READ(E)   CGXDCRL9                                                  248399A
                                                                                              248399
      * Handle database error                                                                 248399
                                                                                              248399
     C                   IF        %ERROR                                                     248399
     C                   EVAL      RtnCode = '*ERROR    '                                     248399
     C                   EXSR      *PSSR                                                      248399
     C                   ENDIF                                                                248399
                                                                                              248399
      * If no error, check end of file status                                                 248399
                                                                                              248399
     C                   EVAL      eof_curr = %EOF                                            248399
                                                                                              248399
      * If not end of file                                                                    248399
                                                                                              248399
     C                   IF        eof_curr = *OFF                                            248399
     C                   EVAL      ErrItem = ErrItem + 1                                      248399
     C                   ENDIF                                                                248399
                                                                                              248399
     C                   ENDSR                                                                248399
                                                                                              248399
      *-----------------------------------------------------------------*
      * ReadArch - Subroutine to read Archive UDC log file via CGXDCLL3 *
      *-----------------------------------------------------------------*
     C     ReadArch      BEGSR
     C                   READ(E)   CGXDCLL3
 
      * Handle database error
 
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR    '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If no error, check end of file status
 
     C                   EVAL      eof_arch = %EOF
 
      * If not end of file and Streamfile name is BLANK
      * and Processed by FormsMaster flag is BLANK,
 
     C                   IF        eof_arch = *OFF
 
      * Calculate the elapsed time since item was
      * transmitted to FormsMaster.
 
     C                   EVAL      ElapTime = CalcElapse(DLATIM)
 
      * If calculated elapsed time is greater than maximum
      * print wait time, flag this item as 'in error'
 
     C                   IF        ElapTime > TotalMaxPrt
     C                   EVAL      ErrItem = ErrItem + 1
     C                   EVAL      DLPROC = 'E'
     C                   UPDATE    @XDCLL3
 
      * Otherwise, count as valid record
 
     C                   ELSE
     C                   UNLOCK    CGXDCLL3
     C                   EVAL      RecFound = RecFound + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *---------------------------------------------------------------*
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *---------------------------------------------------------------*
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCode
     C                   PARM                    NbrErrItem
 
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
 
     C                   ENDSR
 
      *****************************************************************
 
      *********************************************************************
      /EJECT
      *-------------------------------------------------------------------*
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
      *-------------------------------------------------------------------*
 
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
 
      /EJECT
      * +---------------------------------------------------------+
      * ¦ Func/TrimZero - Remove preceeding ZEROES in alpha-      ¦
      * ¦                 numeric data field.                     ¦
      * +---------------------------------------------------------+
     PTrimZero         B
 
     DTrimZero         PI             5
     D  cNbrOfItems                   5    VALUE
 
      * Actual length of data field to be trimmed (incl. quotes)
     D Pos1            S              2  0 INZ(1)
 
      * Field to contain trimmed data
     D TrimFld         S              5
 
      * Determine position of first non-zero digit in the data field.
 
     C                   DOW       %SUBST(cNbrOfItems:Pos1:1) = '0'
     C                   EVAL      Pos1 = Pos1 + 1
     C                   ENDDO
 
     C                   EVAL      TrimFld = %SUBST(cNbrOfItems:Pos1:6-Pos1)
 
     C                   RETURN    TrimFld
     P                 E
 
      /EJECT
      * +---------------------------------------------------------+
      * ¦ Func/CalcElapse - calculate elapsed time since the      ¦
      * ¦                   Item was sent to FormsMaster.         ¦
      * +---------------------------------------------------------+
     PCalcElapse       B
 
     DCalcElapse       PI             6  0
     D  ActionTime                    6  0 VALUE
 
     D ElapseTime      S              6  0
     D TotalSysTime    S              6  0
     D TotalActTime    S              6  0
     D SystemTime      S              6  0
     D PollFrq         S              5  0
 
     D cSystemTime     DS
     D   SysHour                      2  0
     D   SysMin                       2  0
     D   SysSec                       2  0
 
     D cActionTime     DS
     D   ActHour                      2  0
     D   ActMin                       2  0
     D   ActSec                       2  0
 
      * Load System time into data structure
     C                   TIME                    SystemTime
     C                   MOVEL     SystemTime    cSystemTime
 
      * Convert Polling Frequency to numeric value
     C                   MOVEL     CMPFRQ        PollFrq
 
      * Calculate Total System Time in seconds
      * NOTE: If System Time is less than Action Time (i.e.
      *       there is 1 day gap between the 2 times), add
      *       24 to the calculated system HOUR.
 
     C                   IF        SystemTime < ActionTime
     C                   EVAL      SysHour = SysHour + 24
     C                   ENDIF
 
     C                   EVAL      TotalSysTime = (SysHour * 3600) +
     C                                            (SysMin * 60) + SysSec
 
      * Calculate Total Action Time in seconds
     C                   MOVEL     ActionTime    cActionTime
     C                   EVAL      TotalActTime = (ActHour * 3600) +
     C                                            (ActMin * 60) + ActSec
 
      * Calculate Elapsed time
     C                   EVAL      ElapseTime = TotalSysTime -
     C                                          TotalActTime -
     C                                          PollFrq
 
     C                   RETURN    ElapseTime
     P                 E
