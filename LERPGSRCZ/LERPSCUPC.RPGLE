     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Database update Ctr')   *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LERPSCUPC - LE Repayments Schedule - Database update Ctr.    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 TDA070             Date 26Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 201589             Date 03Jan02               *
      *                 CAP079  *CREATE    Date 16Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  201589 - Change to check a new locking dataarea LERPSCLCK    *
      *           to determine whether this DBU is already active.    *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      *
     FLEVRPSCPD UF   E             DISK    RECNO(WRRN)
     F                                     COMMIT
     FLEVRPSCL2 UF   E           K DISK
     F                                     RENAME(LEVRPSCD0:LEVRPSCD2)
     FLEVERPSCPDO    E             DISK
     F                                     RENAME(LEVRPSCD0:LEVERPSCRR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(CL_)
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LERPSCU001
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in RPSC API update')
      *
      *****************************************************************
      *
      ***  Externally described data structure for valid repayments schedule
      *
     D ValidRPSC     E DS                  EXTNAME(LEVRPSCPD)
      ***  New repayment shedule in File Format
      *
     D LERPSCUPC       DS             1    DTAARA(LERPSCUPC)
      *
     D ErrorRpSc     E DS                  EXTNAME(LEERPSCPD)
      ***  Error indicators Screen
      *
     D CrRpScFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Current Repayment schedule in File Format
     D                                     PREFIX(L)
      *
     D  OldStsDS       DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029
      *
     D  NewStsDS       DS
      ***  New settlement details
      *
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***WSPI1**               35     64                                                      CGL029
     D***WSPI2**               65     94                                                      CGL029
     D***WSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  WSPI1                 41     70                                                       CGL029
     D  WSPI2                 71    100                                                       CGL029
     D  WSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029
      *
     D  PasDtaDS       DS           256
      ***  New settlement details
      *
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20
      *
     D  RPSC_DBER      DS            16
      ***  DS For Data error in RPSC valid file
      *
     D**K@LNRF**               1      6  0                                                    CLE148
     D  K@LNRF                 1      6                                                       CLE148
     D  BLK1                   7      7
     D  K@VDAT                 8     12  0
     D  BLK2                  13     13
     D  K@LASN                14     16  0
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External data structure for SAR details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  Data structure for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  DS for Access ProgramsS, Short DS
      *
     D Object          S             10A   INZ('LERPSCUPC')
     D LockObj         S             10A   INZ('LERPSCLCK')                                   201589
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
     D K@TMES          S             26Z
      *
      ***  Dummy message ID and message file fields for use on the calls to
      ***  ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
     D WRRN            S              7S 0
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                              TDA070  BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LERPSCU002
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
      *
      /COPY WNCPYSRC,LERPSCU003
      *
      ***  Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APRPSCDTQ'
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
      *
      ***  Initialise Data queue parms
      *
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APRPSCDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      *
      ***  Wait for data queue prompt
      ***  Server program will send data queue entry when record is
      ***  written to the valid transactions file
      *
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *
      ***  Lock allocation data area
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
      *
      /COPY WNCPYSRC,LERPSCU004
      *
      ***  Position file cursor to start of file to prevent problems on
      ***  later calls
      *
     C     1             SETLL     LEVRPSCPD
      *
      ***  Read valid records
      *
     C                   READ      LEVRPSCPD                              99    *
     C     *IN99         DOWEQ     '0'
      *
     C                   EVAL      K@LNRF = RPLNRF
     C                   EVAL      K@VDAT = RPVDAT
     C                   EVAL      K@LASN = RPLASN
     C                   EVAL      K@TMES = RPTMES
      *
      /COPY WNCPYSRC,LERPSCU005
      *
      ***  Load the API Dump data area with as many fields from the message
      ***  header as are available, so that dumps in any lowere level modules
      ***  will include the key information
      *
     C                   EVAL      ARFOTranID = RPFRNT
     C                   EVAL      ARFOAsocID = RPAFRT
     C                   EVAL      ARRprLocn  = RPREPA
      *
      /COPY WNCPYSRC,LERPSCU006
      *
     C                   Z-ADD     *ZERO         Idx               3 0
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
      *
      ***  Convert the value date and set up the retrieve parameters
      *
     C                   MOVE      RPVDAT        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVDAT
      *
     C                   MOVEL     RPCHTP        DDACTN
     C                   MOVE      RPLNRF        DDLNRF
     C                   MOVE      RPLASN        DDSEQN
      *
      ***  Retrieve Repayment schedule details
      *
     C     RPCHTP        IFNE      'I'
     C                   EXSR      RTVRPSC
     C                   ENDIF
      *
      ***  Check if no error
      *
     C     DDACTNOK      IFEQ      'Y'
     C     DDLNRFOK      ANDEQ     'Y'
     C     DDSEQNOK      ANDEQ     'Y'
     C     DDVDATOK      ANDEQ     'Y'
     C     Idx           ANDEQ     *ZERO
      *
     C                   CALLB     'LERPSCUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    ValidRPSC
     C                   PARM                    OldStsDS
     C                   PARM                    NewStsDS
     C                   PARM                    PasDtaDS
     C                   PARM                    ErrorRpSc
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      *
     C                   ELSE
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   ENDIF
      *
      /COPY WNCPYSRC,LERPSCU007
      *
      ***  Commit updates if no error
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C     Idx           ORNE      *ZERO
     C     @@RTCD        OREQ      '*RECLCK'                                                AR868380
     C                   ROLBK
     C                   ELSE
     C     WRRN          CHAIN     LEVRPSCPD                          99
B004 C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVRPSCPD'   DBFILE                         *************
     C                   Z-ADD     WRRN          DBASE                          * DBERR 001 *
     C                   MOVE      *BLANKS       DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ELSE
     C                   DELETE    LEVRPSCPD
     C                   COMMIT
E004 C                   ENDIF
     C                   ENDIF
      *
      /COPY WNCPYSRC,LERPSCU008
      *
      ***  If an error has occurred, reaccess record in error and remove from
      ***  the file to prevent program processing the same record again
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C     Idx           ORNE      *ZERO
     C     @@RTCD        OREQ      '*RECLCK'                                                AR868380
     C                   EVAL      K@LNRF = RPLNRF
     C                   EVAL      K@VDAT = RPVDAT
     C                   EVAL      K@LASN = RPLASN
     C                   EVAL      K@TMES = RPTMES
      *
      ***  Write details of record to error file
      *
      ***  process LEVRPSCPD
      *
     C                   WRITE     LEVERPSCRR
     C     KKRPSC        CHAIN     LEVRPSCL2                          99
B004 C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEVRPSCPD'   DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVE      RPSC_DBER     DBKEY                          *************
     C                   EXSR      *PSSR
E004 C                   ENDIF
     C                   DELETE    LEVRPSCD2
      *
      ***  Send message to system operator
      *
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   ENDIF
      *
      ***  Read valid record
      *
     C                   READ      LEVRPSCD0                              99    *
     C                   ENDDO
      *
      ***  Unlock allocation data area
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      *
      ***  End loop for data queue prompt
      *
     C                   ENDDO
      *
      /COPY WNCPYSRC,LERPSCU009
      *
      ***  Exit from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVRPSC- Retrieve Repayment schedule                          *
      *****************************************************************
     C     RTVRPSC       BEGSR
      *
     C                   CALLB     'LERPSCRTV'
      *
      ***  Inputs
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ***  Response mode SECURITY CKECKING
     C                   PARM      'S'           @@RSMD            1
      *
      ***  Action Code
     C                   PARM                    DDACTN            1
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  (Midas) Loan Number
     C                   PARM                    DDLNRF            6
      *
      ***  (Midas) Sequence no.
     C                   PARM                    DDSEQN            3
      *
      ***  (Midas) Value date
     C                   PARM                    DDVDAT            6
      *
      ***  Outputs
      *
      ***  (Current) Repayment schedule in file format
     C                   PARM                    CrRpScFilFmt
      *
      ***  OK - Action code
     C                   PARM                    DDACTNOK
      *
      ***  OK - Loan Number
     C                   PARM                    DDLNRFOK
      *
      ***  OK - Sequence no.
     C                   PARM                    DDSEQNOK
      *
      ***  OK - Value Date
     C                   PARM                    DDVDATOK
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
      *
      ***  Check if no error
      *
     C     DDACTNOK      IFEQ      'Y'
     C     DDLNRFOK      ANDEQ     'Y'
     C     DDSEQNOK      ANDEQ     'Y'
     C     DDVDATOK      ANDEQ     'Y'
      *
      ***  Save the settlement details for update
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
      *
      ***  Save the last update for test
      *
     C                   Z-ADD     LLCD          WLCD
     C                   MOVE      LCHTP         WCHTP
     C                   Z-ADD     LTNLU         WTNLU
     C                   MOVE      WLSTC         SAVLC
      *
      ***  Access the related loan
      ***  Loan must exist on Loans file as live
      *
     C                   MOVE      RPLNRF        K@LNRF
     C                   MOVE      'A'           K@RCDT
      *
     C     K@LOAN        CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           DDLNRFOK
      *
     C                   ELSE
      *
      ***  Save the new settlement details for update
      *
     C     CL_PTYP       IFEQ      66
     C     CLE005        OREQ      'Y'
     C     CL_PTYP       ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     CL_PTYP       ANDEQ     72
     C                   MOVEL     RPPSTM        WSETP
     C                   MOVEL     RPPONS        WOSAC
     C                   ELSE
     C                   MOVEL     RPRSTM        WSETP
     C                   MOVEL     RPRONS        WOSAC
     C                   ENDIF
      *
     C                   MOVEL     RPFACO        WFACO
     C                   MOVEL     RPTSEN        WTSEN
     C                   MOVE      RPSCCY        WSCCY
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *
      ***  Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,LERPSCU010
      *
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Define key list for LEVRPSCL2
      *
     C     KKRPSC        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF                                       CLE148
     C                   KFLD                    K@VDAT            5 0
     C                   KFLD                    K@LASN            3 0
     C                   KFLD                    K@TMES
      *
      ***  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 003 *
     C                   Z-ADD     3             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C                   KFLD                    K@LNRF
     C                   KFLD                    K@RCDT            1
      *
      ***  Check if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005
     C                   END

      *  Check if an existing DBU_RPSC job is active in the subsystem.                        201589
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
      *
      ***  Lock allocation data area
      *    =========================
      *
      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.
      *
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
      *
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
      *
      *   Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
      *
      ***  Create required QTEMP objects
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
      *
      ***  Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,LERPSCU011
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ***  The following /COPY contains the standard program status
      ***  subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
