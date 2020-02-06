     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant update controller')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFPRTUPC - Funding Participant controller                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CLE023             Date 12Apr02               *
      *                 CAP068  *CREATE    Date 22Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE023 - Recompiled due to changes to LEVFCLNPD.             *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FLEVFCLMPD UF   E             DISK
     F                                     COMMIT
     FLEVFCLML1 UF   E           K DISK
     F                                     RENAME(LEVFCLMD0:LEVFCLMD1)
     FLEVFCLNPD UF   E             DISK
     F                                     COMMIT
     FLEVFCLNL1 UF   E           K DISK
     F                                     RENAME(LEVFCLND0:LEVFCLND1)
 
     FLEVEFCLMPDO    E             DISK
     F                                     RENAME(LEVFCLMD0:LEVFCLMERR)
 
      **  Facilities Details file
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEFPRTC001
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
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
     D DBerrUpd        C                   CONST('DB error in FPRT API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID Transaction record 'A'
     D LEVFCLM       E DS                  EXTNAME(LEVFCLMPD)
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID Transaction record 'B'
     D LEVFCLN       E DS                  EXTNAME(LEVFCLNPD)
 
     D LEFPRTUPC       DS             1    DTAARA(LEFPRTUPC)
 
      ** Assignment Details OK indicator
     D FPRT_OK       E DS                  EXTNAME(LEEFPRTPD)
 
 
     D Object          S             10A   INZ('LEFPRTUPC')
     D LockObj         S             10A   INZ('LEFPRTLCK')
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
     D DtqNam          S             10A   INZ('APFPRTDTQ')
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
      /COPY WNCPYSRC,LEFPRTC002
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,LEFPRTC003
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFPRTDTQ'
 
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
     C                   PARM      *BLANK        Return
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8
 
 
      /COPY WNCPYSRC,LEFPRTC004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     LEVFCLMPD
     C     1             SETLL     LEVFCLNPD
 
      ** READ VALID Mm Transaction
     C                   READ      LEVFCLMD0                              99    *
     C                   READ      LEVFCLND0                              99    *
     C                   DOW       *IN99 = *OFF
 
      /COPY WNCPYSRC,LEFPRTC005
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = FPFRNT
     C                   EVAL      ARFOAsocID = FPAFRT
     C                   EVAL      ARRprLocn  = FPREPA
 
      /COPY WNCPYSRC,LEFPRTC006
      ** Retrieve the transaction number of last update from FCLTYFM
 
     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO
     C                   MOVE      'A'           K#RCTP
 
     C     FCLTYK        CHAIN     FCLTY                              80
 
      ** LE Database Update
     C                   CALLB     'LEFPRTUPD'
     C                   PARM      *BLANK        @@RTCD            7
      * Mode
     C                   PARM      'B'           P#MODE            1
 
      * Action Code
     C                   PARM      FPCHTP        S#ACTN            1
 
      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM      TNLU          H#TNLU            5 0
 
      * Funding Participant details in file format record 'A'
     C                   PARM                    LEVFCLM
      * Funding Participant details in file format record 'B'
     C                   PARM                    LEVFCLN
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FPRT_OK
      *
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
      * Facility sequence assigned
 
     C                   PARM                    A_FCNO            2
 
      * Commit Updates if No Error
     C                   SETOFF                                         66
     C                   IF        @@RTCD = '       '
 
      ** Re-position file cursor to start of file to prevent problems
     C     1             SETLL     LEVFCLMPD
     C     1             SETLL     LEVFCLNPD
     C                   READ      LEVFCLMD0                              99    *
     C                   READ      LEVFCLND0                              99    *
     C                   DELETE    LEVFCLMD0                            66
     C                   DELETE    LEVFCLND0                            66
     C                   COMMIT
     C                   ENDIF
 
      /COPY WNCPYSRC,LEFPRTC007
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C                   IF        @@RTCD = '*ERROR ' OR
     C                             @@RTCD = '*RECUPD' OR
     C                             *IN66  = '1'
 
      * Check for Funding Participant on valid file
     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO
     C     PFCLTK        CHAIN     LEVFCLML1                          89
     C     PFCLTK        CHAIN     LEVFCLNL1                          89
      * Write details of record to error file (same format as LEVFCLMPD)
     C                   IF        *IN66 =  '0'
     C                   WRITE     LEVFCLMERR
     C                   DELETE    LEVFCLMD1
     C                   DELETE    LEVFCLND1
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
     C                   DELETE    LEVFCLMD1
     C                   DELETE    LEVFCLND1
     C                   ENDIF
     C                   ENDIF
 
      ** Read Valid LE Transaction Details
     C                   READ      LEVFCLMD0                              99    *
     C                   READ      LEVFCLND0                              99    *
     C                   ENDDO
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM      *BLANK        Return
     C                   ENDIF
      ** End loop for data queue prompt
     C                   ENDDO
 
      /COPY WNCPYSRC,LEFPRTC008
 
      * Exit from Program
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LEFPRTC009
 
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
 
     C     *LIKE         DEFINE    FPCNUM        K#CNUM
     C     *LIKE         DEFINE    FPFACT        K#FACT
     C     *LIKE         DEFINE    FPFCNO        K#FCNO
     C     *LIKE         DEFINE    RCTP          K#RCTP
 
      *  Define key list for LEVFCLML1
     C     PFCLTK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
 
     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCTP
 
      *  Check if an existing DBU_FPRT job is active in the subsystem.
 
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
     C                   PARM      *BLANK        Return
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM      *BLANK        ReturnCde        10
      *
     C* Overrride LEFPRTLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFPRTC010
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   EVAL      @@RTCD = '*ERROR '
     C                   MOVEL     'LEFPRTUPD'   DBPGM            10
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C*
     C**  Terminate the Program
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ##OX1
OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)
