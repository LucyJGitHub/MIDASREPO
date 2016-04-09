     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment Database update controller')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFEADUPC - Fee Adjustment Update Controller                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 222373             Date 30Oct03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE073 - Calculated Loan Based Fees (Recompile)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FLEVFEADPD UF   E             DISK
     F                                     COMMIT
     FLEVFEADL1 UF   E           K DISK
     F                                     RENAME(LEVFEADD0:LEVFEADD1)
 
     FLEVEFEADPDO    E             DISK
     F                                     RENAME(LEVFEADD0:LEVFEADERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEFEADC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the LE standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in FEAD API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID Transaction
     D LEVFEAD       E DS                  EXTNAME(LEVFEADPD)
 
     D LEFEADUPC       DS             1    DTAARA(LEFEADUPC)
 
      ** Fee Adjustment Details OK indicator
     D FEAD_OK       E DS                  EXTNAME(LEEFEADPD)
 
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D  FLREC                  1     69
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                  1    559
 
     D Object          S             10A   INZ('LEFEADUPC')
     D LockObj         S             10A   INZ('LEFEADLCK')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A
     D Endjob          S              1A   INZ('Y')
     D @Timestamp      S             26Z
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APFEADDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFEADC002
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,LEFEADC003
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFEADDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C                   DOW       DtqDta <> 'END'
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
 
      ** If data queue entry is 'END', leave the DOW loop at this point
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
 
      ** If data queue entry says run, first lock allocation data area
     C                   IF        DtqDta = 'GO'
 
      ** Allocate with exclusive lock state
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8
 
 
      /COPY WNCPYSRC,LEFEADC004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     LEVFEADPD
 
      ** READ VALID LE Transaction
     C                   READ      LEVFEADD0                              99    *
     C                   DOW       *IN99 = *OFF
 
      /COPY WNCPYSRC,LEFEADC005
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = ADFRNT
     C                   EVAL      ARFOAsocID = ADAFRT
     C                   EVAL      ARRprLocn  = ADREPA
 
      /COPY WNCPYSRC,LEFEADC006
 
      ** LE Database Update
     C                   CALLB     'LEFEADUPD'
     C                   PARM      *BLANK        @@RTCD            7
      * Mode
     C                   PARM      'B'           P#MODE            1
      * Action Code
     C                   PARM                    S#ACTN            1
      * Fee Adjustment Details in file format
     C                   PARM                    LEVFEAD
      **File*Receive instructions                                                             222373
     C**********         PARM                    F_REC                                        222373
      **********                                                                              222373
      **File*Payment instructions                                                             222373
     C**********         PARM                    F_PAY                                        222373
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee settlement record on LEFEEAD
     C                   PARM                    H#TNLU            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C                   PARM                    FcbrSYCU          6 0
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      * Field OK flags
     C                   PARM                    FEAD_OK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
      * Commit Updates if No Error
     C                   SETOFF                                         66
     C                   IF        @@RTCD = '       '
     C                   DELETE    LEVFEADD0
 
      ** Re-position file cursor to start of file to prevent problems
     C     1             SETLL     LEVFEADPD
     C                   READ      LEVFEADD0                              99
     C                   DELETE    LEVFEADD0                            66
     C                   COMMIT
     C                   ENDIF
 
      /COPY WNCPYSRC,LEFEADC007
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C                   IF        @@RTCD = '*ERROR ' OR
     C                             @@RTCD = '*RECUPD' OR
     C                             *IN66  = '1'
 
      * Check for Fee Settlement on Valid file
     C                   MOVE      ADCNUM        K#CNUM
     C                   MOVE      ADFACL        K#FACL
     C                   MOVE      ADLOAN        K#LOAN
     C                   MOVE      ADFSEQ        K#FSEQ
     C     KFADL1        CHAIN     LEVFEADL1                          89
 
     ** Write details of record to error file (same format as LEVFEADPD)
     C                   IF        *IN66 =  '0'
     C                   WRITE     LEVFEADERR
     C                   DELETE    LEVFEADD1
     C                   COMMIT
 
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     ** If the error was on the previous delete, just delete here; no need for
     ** roll back.
     C                   ELSE
     C                   DELETE    LEVFEADD1
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read Valid LE Transaction Details
     C                   READ      LEVFEADD0                              99    *
     C                   ENDDO
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   ENDIF
      ** End loop for data queue prompt
     C                   ENDDO
 
      /COPY WNCPYSRC,LEFEADC008
 
      * Exit from Program
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LEFEADC009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key list for file LEVFEADL1
     C     *LIKE         DEFINE    ADCNUM        K#CNUM
     C     *LIKE         DEFINE    ADFACL        K#FACL
     C     *LIKE         DEFINE    ADLOAN        K#LOAN
     C     *LIKE         DEFINE    ADFSEQ        K#FSEQ
 
     C     KFADL1        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
 
 
      *  Check if an existing DBU_FEAD job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      *  Lock allocation data area
 
      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.
 
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
 
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
 
      *   Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM      *BLANK        ReturnCde        10
      *
      * Overrride LEFEADLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFEADC010
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
      *
     C                   EVAL      @@RTCD = '*ERROR '
     C                   MOVEL     'LEFEADUPD'   DBPGM            10
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      **  Terminate the Program
      *
     C                   RETURN
      *
     C                   ENDSR
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** ##OX1
OVRDBF FILE(LEFEADLR) TOFILE(LEFEADL0) SHARE(*NO)
