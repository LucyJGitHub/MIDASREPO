     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield rates database update controller')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  SDYRATUPC - Yield Rates Database Update Controller           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 225408             Date 20Sep06               *
      *  Prev Amend No. CAS008             Date 16Jun04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  225408 - Tried to delete with prior READ/CHAIN.              *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F*SDVYRATPDUF***E******       DISK    COMMIT                                             225408
     FSDVYRATPD IF   E             DISK                                                       225408
     F*SDVYRATL1UF***E******     K DISK                                                       225408
     FSDVYRATL1 UF   E           K DISK    COMMIT                                             225408
     F                                     RENAME(SDVYRATD0:SDVYRATD1)
     FSDVEYRATPDO    E             DISK
     F                                     RENAME(SDVYRATD0:SDVYRATERR)
 
     F/COPY WNCPYSRC,SDYRATUF01
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  80  - Scan/Chain/Lookup indicator                            *
      *  LR  - Last record indicator (program termination)            *
      *  U7  - DB error processing indicator                          *
      *  U8  - DB error processing indicator                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLOGERROR - Send a message to the system operator for       *
      *               invalid transactions, and exit.                 *
      *  *INZSR     - Program Initialisation                          *
      *  *PSSR      - DB Error Processing                             *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WDBerrUpd       C                   CONST('DB error in Yld Rates Update')
 
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described data structure for valid yield rates record
     D SDVYRAT       E DS                  EXTNAME(SDVYRATPD)
 
      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SDYRATUPC       DS             1    DTAARA(SDYRATUPC)
 
     D/COPY WNCPYSRC,SDYRATUD01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PObject         S             10A   INZ('SDYRATUPC')
     D PLockObj        S             10A   INZ('SDYRATLCK')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A   INZ('*DTAARA')
     D PLockStateE     S              7A   INZ('*EXCL')
     D PLockStateS     S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('*CLS')
     D PDlcobj         S              1A
     D PReturn         S              7A
     D PReturn2        S              7A
     D PEndjob         S              1A   INZ('Y')
     D PReturnCde      S             10A
     D PDBError        S             28A
     D PLongError      S            132A
 
      ** Parameter list for QRCVDTAQ
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5P 0
     D PDtqDta         S             10A
     D PDtqWait        S              5P 0
 
      ** Key fields for SDVYRATL1
     D KYLDC           S                   LIKE(FSYLDC)
     D KYCCY           S                   LIKE(FSYCCY)
     D KYICM           S                   LIKE(FSYICM)
     D KTMES           S                   LIKE(FSTMES)
 
      ** Timestamp
     D WTimestamp      S             26Z
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APYRATDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
      ** Initialise Data queue parms
 
     C                   EVAL      PDtqLen = 10
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'APYRATDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PObjType = '*DTAARA'
 
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
 
     C                   DOW       PDtqDta <> 'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam
     C                   PARM                    PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqDta
     C                   PARM                    PDtqWait
 
     C                   IF        PDtqDta = 'GO'
 
      ** Lock allocation data area
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
 
     C     1             SETLL     SDVYRATPD
 
      ** Read valid yield rates record
 
     C                   READ      SDVYRATD0                              80
 
     C                   DOW       *IN80 = *OFF
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      **  will include the key information
 
     C                   EVAL      ARFOTRANID = FSYLDC + FSYCCY + FSYICM
     C                   EVAL      ARFOASOCID = *BLANKS
     C                   EVAL      ARRPRLOCN  = FSRPRL
 
      ** Save key fields
 
     C                   EVAL      KYLDC = FSYLDC
     C                   EVAL      KYCCY = FSYCCY
     C                   EVAL      KYICM = FSYICM
     C                   EVAL      KTMES = FSTMES
 
      ** Process only insert, amend and delete transactions.
 
     C                   IF        (FSCHTP = 'I') OR (FSCHTP = 'A') OR
     C                             (FSCHTP = 'D')
     C                   CALLB     'SDYRATUPD'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    SDVYRAT
     C                   ENDIF
 
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** rollback changes then terminate program
 
     C                   IN        APDUMP
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EXSR      SRLOGERROR
     C                   ENDIF
 
      ** Commit updates if no error
 
     C                   IF        (RetCodeOut = '*ERROR ') OR
     C                             (RetCodeOut = '*RECUPD')
     C                   ROLBK
     C                   ELSE
     C/COPY WNCPYSRC,SDYRATUC01
     C**********         DELETE    SDVYRATD0                                                  225408
     C     KYIELDR       CHAIN     SDVYRATL1                          80                      225408
     C                   DELETE    SDVYRATD1                                                  225408
     C/COPY WNCPYSRC,SDYRATUC02
     C                   COMMIT
     C                   ENDIF
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
 
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
     C     KYIELDR       CHAIN     SDVYRATL1                          80
     C                   DELETE    SDVYRATD1                                                  225408
 
     ** Write details of record to error file (same format as SDVYRATPD)
 
     C                   WRITE     SDVYRATERR
     C**********         DELETE    SDVYRATD1                                                  225408
     C/COPY WNCPYSRC,SDYRATUC03
 
     ** Send message to system operator
 
     C                   MOVEL     WDBerrUpd     PDBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C                   ENDIF
 
      ** Read valid yield rates record
 
     C                   READ      SDVYRATD0                              80
     C                   ENDDO
 
     ** Unlock allocation data area
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PReturn
     C                   ENDIF
 
      ** End loop for data queue prompt
 
     C                   ENDDO
 
      ** Exit from program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOGERROR - Send a message to the system operator for        *
      *              invalid transactions, and exit.                  *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * ZAMSGTOOPR  - Send message to system operator                 *
      *                                                               *
      *****************************************************************
 
     C     SRLOGERROR    BEGSR
 
      ** Set up the message to send to the operator
 
     C                   CLEAR                   PLongError
     C                   RESET                   ReturnCode
     C                   EVAL      PLongError = WProcErr + '   ' + ARERRMOD
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    PLongError
     C                   PARM                    PDummyMsgId
     C                   PARM                    PDummyMsgF
 
      ** Remove the failing module's details from the dump information
      ** data area.
 
     C     *LOCK         IN        APDUMP
     C                   CLEAR                   ARERRMOD
     C                   OUT       APDUMP
     C                   ROLBK
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR      - Program Initialisation routine                  *
      *                                                               *
      * Called by : Main processing                                   *
      *                                                               *
      * Calls : None                                                  *
      * APCALCOBJ   - Allocate an object                              *
      * APCCRTQTO   - Create QTEMP objects required by API            *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define key list for SDVYRATL1
 
     C     KYIELDR       KLIST
     C                   KFLD                    KYLDC
     C                   KFLD                    KYCCY
     C                   KFLD                    KYICM
     C                   KFLD                    KTMES
 
      *  Check if an existing DBU_INTC job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    PLockObj
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PEndjob
     C                   PARM                    PReturn2
 
      ** Lock allocation data area.
      ** The data area is allocated *SHRRD here and *EXCL whilst processing
      ** of the valid file is actually taking place.
      ** The function to submit this updater tries to get a *EXCL lock.
      ** The controller tries to get a *SHRRD lock.
      **
      **                        Submitter             Controller
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
      **
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
      **
      **  Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateS
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
 
      ** Create required QTEMP objects
 
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PReturnCde
 
     C/COPY WNCPYSRC,SDYRATUC04
     C                   ENDSR
 
     C****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
