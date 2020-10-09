     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instr database update controller')   *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LELERIUPC - LE Rollover Instr database update controller     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13843           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9737            Date 29Dec05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CAP084             Date 09Jan04               *
      *                 TDA023             Date 22Mar04               *
      *                 201589             Date 03Jan03               *
      *                 CAP076  *CREATE    Date 03May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9737- Must included in CLE106 delivery due to changes made*
      *           CLE036 in loans file.(Recompile)                    *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CAP084 - API wrapper project                                 *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  201589 - Change to check a new locking dataarea MMLDNILCK    *
      *           to determine whether this DBU is already active.    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************

     FLEVLERLPD UF   E             DISK
     F                                     COMMIT
     F                                     RENAME(LEVCLILD0:LEVLERLD0)
     FLEVLERKPD UF   E             DISK
     F                                     PREFIX(K_)
     F                                     COMMIT
     F                                     RENAME(LEVCLIKD0:LEVLERKD0)
     FLEVLERLL1 UF   E           K DISK
     F                                     RENAME(LEVCLILD0:LEVLERLD1)
     FLEVLERKL1 UF   E           K DISK
     F                                     RENAME(LEVCLIKD0:LEVLERKD1)
     FLEVECLILPDO    E             DISK
     F                                     RENAME(LEVCLILD0:LEVLERLERR)
     FLEVECLIKPDO    E             DISK
     F                                     RENAME(LEVCLIKD0:LEVLERKERR)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELERIU001

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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
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
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in LERI API update')

      *****************************************************************

      **  Externally described data structure for valid Loans (CL & CK)
      *
     D ValidloanL    E DS                  EXTNAME(LEVLERLPD)
      ***  New Loan in File Format CL
      *
     D ValidloanK    E DS                  EXTNAME(LEVLERKPD)
     D                                     PREFIX(K_)

     D LELERIUPC       DS             1    DTAARA(LELERIUPC)

     D Object          S             10A   INZ('LELERIUPC')
     D LockObj         S             10A   INZ('LELERILCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access ProgramsS, Short DS

     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for access programs, very long data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LELERIU002

      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      /COPY WNCPYSRC,LELERIU003

      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APLERIDTQ'

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APLERIDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *  Lock allocation data area
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return

      /COPY WNCPYSRC,LELERIU004

      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     LEVLERLPD
     C     1             SETLL     LEVLERKPD

      ** READ VALID LOANS
     C                   READ      LEVLERLPD                              99    *
     C                   READ      LEVLERKPD                              99    *
     C     *IN99         DOWEQ     '0'

     C                   EVAL      @LoanNo = CLLNRF
     C                   EVAL      @Timestamp = CLTMES
      /COPY WNCPYSRC,LELERIU005

      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = CLFRNT
     C                   EVAL      ARFOAsocID = CLAFRT
     C                   EVAL      ARRprLocn  = CLREPA

      /COPY WNCPYSRC,LELERIU006

     C                   CALLB     'LELERIUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    CLCHTP
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
      ***  Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      ***  Called from CTU
     C                   PARM      *blank        @@CTU             1

      /COPY WNCPYSRC,LELERIU007

      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    LEVLERLD0
     C                   DELETE    LEVLERKD0
     C                   COMMIT
     C                   END

      /COPY WNCPYSRC,LELERIU008

     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @LoanNo = CLLNRF
     C                   EVAL      @Timestamp = CLTMES

     ** Write details of record to error file
     ** (same format as LEVLERLPD & LEVLERKPD)

      * process LEVLERLPD
     C                   WRITE     LEVLERLERR
     C     @KLECL2       CHAIN     LEVLERLL1                          89
B004 C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVLERLPD'   DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     CLLNRF        DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ENDIF
     C                   DELETE    LEVLERLD1
      * process LEVLERKPD
     C                   WRITE     LEVLERKERR
     C     @KLECL2       CHAIN     LEVLERKL1                          89
B004 C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVLERKPD'   DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     CLLNRF        DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ENDIF
     C                   DELETE    LEVLERKD1

     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   ENDIF

      ** READ VALID LOANS
     C                   READ      LEVLERLD0                              99    *
     C                   READ      LEVLERKD0                              99    *
     C                   ENDDO
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      ** End loop for data queue prompt
     C                   ENDDO

      /COPY WNCPYSRC,LELERIU009

      * EXIT FROM PROGRAM
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELERIU010

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
      *
      ** Define key list for LEVLERLL1 and LEVLERKL1
      *
     C     @KLECL2       KLIST
     C**********         KFLD                    @LoanNo           6 0                       CLE148
     C                   KFLD                    @LoanNo           6                         CLE148
     C                   KFLD                    @Timestamp
      *
      ** Check if Customer Lending Enhancements - Authorisation
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE002'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE002            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE002
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Backvaluations
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE003            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE003
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Others
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE005
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END

      *  Check if an existing DBU_LERI job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589

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
     C                   PARM                    ReturnCde        10

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LELERIU011

     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
