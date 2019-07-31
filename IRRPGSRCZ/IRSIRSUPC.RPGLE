     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single ccy IRS dbase update controller')      *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSIRSUPC - Single Currency Interest Rate Swaps              *
      *             DATABASE UPDATE CONTROLLER                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CIR017             Date 10Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247804             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CIR014             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8899            Date 07Oct05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 07Jan02               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 16Mar99               *
      *                 CAP004             Date 06Aug98               *
      *                 CAP003  *CREATE    Date 01May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR017 - SIRS Business Day Conventions for both legs         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247804 - DBU_SIRS in MSGW due to record not found in         *
      *           IRVXSIRPD. Initialize retun code.                   *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8899- Front office ID not set up for chain to date        *
      *           schedule valid file                                 *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines                                        *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *           Recompiled due to changes in IRVSIRSPD.             *
      *  201589 - Change to check a new locking dataarea IRSIRSLCK    *
      *           to determine whether this DBU is already active.    *
      *  CIR005 - FRA/IRS Business Day Conventions (Recompiled)       *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP004 - Add APIs Interest Rate Calendar processing          *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FIRVSIRSPD UF   E             DISK
     F                                     COMMIT
     FIRVSIRSL1 UF   E           K DISK
     F                                     RENAME(IRVSIRSD0:IRVSIRSD1)
     FIRVESIRSPDO    E             DISK
     F                                     RENAME(IRVSIRSD0:IRVSIRSERR)
 
     FIRVXSIRL0 UF   E           K DISK                                                       CLE025
     F                                                                                        CLE025
                                                                                              CLE025
     FIRVDTSCL0 UF A E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     RENAME(IRVDTSCD0:IRVDTSCD1)          CAP004
                                                                                CAP004
     FIRVEDTSCPDO  A E             DISK    INFSR(*PSSR)                         CAP004
     F                                     RENAME(IRVDTSCD0:IRVDTSCERR)         CAP004
                                                                                CAP004
     FIRVCFSCL0 UF A E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRVCFSCD0:IRVCFSCD1)                        CAP043
     F                                     PREFIX(CV)                                         CAP043
                                                                                              CAP043
     FIRVPCSCL0 UF A E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRVPCSCD0:IRVPCSCD1)                        CAP043
     F                                     PREFIX(PV)                                         CAP043
                                                                                              CAP043
     FIRVECFSCPDO  A E             DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRVCFSCD0:IRVCFSCERR)                       CAP043
     F                                     PREFIX(CV)                                         CAP043
                                                                                              CAP043
     FIRVEPCSCPDO  A E             DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRVPCSCD0:IRVPCSCERR)                       CAP043
     F                                     PREFIX(PV)                                         CAP043
                                                                                              CAP043
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRSIRSU008
 
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
 
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes the definitions for fields           CAP006
      ** used in checking whether there are messages on the data queue.         CAP006
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in IRS API update')
 
      *****************************************************************
 
     D***ValIRCs       E DS                  EXTNAME(IRVDTSCPD)                        CAP004 CAP043
      **Our*Rate*Change*Dates*(IRCs)                                                   CAP004 CAP043
     D***IRCrecAlp               1    294                                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
     D***OurRatChgD    E DS                  EXTNAME(IRVDTSCPD)                        CAP004 CAP043
      **Our*Rate*Change*Dates*(IRCs)                                                   CAP004 CAP043
     D**********                           PREFIX(OR)                                  CAP004 CAP043
     D***ORFoTran      E                     EXTFLD(XFOTRANID)                         CAP004 CAP043
     D***ORDatesAlp              1    294                                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
     D***OurIntPayD    E DS                  EXTNAME(IRVDTSCPD)                        CAP004 CAP043
      **Our*Interest*Payment*Dates*(IRCs)                                              CAP004 CAP043
     D**********                           PREFIX(OP)                                  CAP004 CAP043
     D***OPFoTran      E                     EXTFLD(XFOTRANID)                         CAP004 CAP043
     D***OPDatesAlp              1    294                                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
     D***ThrRatChgD    E DS                  EXTNAME(IRVDTSCPD)                        CAP004 CAP043
      **Their*Rate*Change*Dates*(IRCs)                                                 CAP004 CAP043
     D**********                           PREFIX(TR)                                  CAP004 CAP043
     D***TRFoTran      E                     EXTFLD(XFOTRANID)                         CAP004 CAP043
     D***TRDatesAlp              1    294                                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
     D***ThrIntPayD    E DS                  EXTNAME(IRVDTSCPD)                        CAP004 CAP043
      **Their*Interest*Payment*Dates*(IRCs)                                            CAP004 CAP043
     D**********                           PREFIX(TP)                                  CAP004 CAP043
     D***TPFoTran      E                     EXTFLD(XFOTRANID)                         CAP004 CAP043
     D***TPDatesAlp              1    294                                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN & DEPOSIT
     D IRVSIRS       E DS                  EXTNAME(IRVSIRSPD)
 
     D IRVXSIR       E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      **  Externally described data structure for valid extension file                        CLE025
                                                                                              CLE025
     D IRSIRSUPC       DS             1    DTAARA(IRSIRSUPC)
 
     D Object          S             10A   INZ('IRSIRSUPC')
     D LockObj         S             10A   INZ('IRSIRSLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D PRetCode        S              7A                                                      CIR008
     D POption         S              7A                                                      CIR008
     D PSARD           S              6A                                                      CIR008
     D PModeOfOp       S              6A                                                      CAP056
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
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP004
     D SCA_LCD       E                     EXTFLD(LCD)                          CAP004
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP004
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CAP004
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                     CAP004
 
      ** Screen/Server input flag (passed to IRSIRSUPD to indicate              CAP004
      ** source of transaction.                                                 CAP004
     D ScreenInpt      S              1A                                        CAP004
                                                                                CAP004
      ** Variable used for CAP043                                                             CAP043
     D CAP041          S              1A                                                      CAP043
     D CAP043          S              1A                                                      CAP043
     D PRtcd           S              7A                                                      CAP043
     D POptn           S              7A                                                      CAP043
                                                                                              CAP043
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
     D CLE025          S              1A                                                      CLE025
                                                                                              CAP056
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRSIRSU009
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
                                                                                CAP004
      /COPY WNCPYSRC,IRSIRSU001                                                 CAP004
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APSIRSDTQ'                       CAP006
                                                                                CAP006
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes a check for whether there            CAP006
      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
      ** message to the data queue if there are not.                            CAP006
     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APSIRSDTQ'
     C                   EVAL      DtqLib = '*LIBL'
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
                                                                                CAP004
      /COPY WNCPYSRC,IRSIRSU002                                                 CAP004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     IRVSIRSPD
 
      ***READ*VALID*LOANS*&*DEPOSITS                                            CAP004
      ** READ VALID IRS                                                         CAP004
     C                   READ      IRVSIRSD0                              99    *
     C     *IN99         DOWEQ     '0'
                                                                                CAP004
      /COPY WNCPYSRC,IRSIRSU003                                                 CAP004
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = RSFRNT
     C                   EVAL      ARRprLocn  = RSREPA
                                                                                CAP004
      ** Retrieve deal extension details                                                      CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   CLEAR                   IRVXSIR                                      CLE025
     C                   MOVE      RSDLNO        WDLNO             6                          CLE025
     C     WDLNO         CHAIN     IRVXSIRP0                          01                      CLE025
     C                   ENDIF                                                                CLE025
      /COPY WNCPYSRC,IRSIRSU004                                                 CAP004
 
      ***If*Interest*Rate*Calendars*feature*is*on,*get*the*IRC*data                    CAP004 CAP043
      ***which*relates*to*this*transaction*from*the*Valid*IRC*file*and                 CAP004 CAP043
      ***load*into*the*relevent*parms*for*the*call*to*the*update*program.              CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         CLEAR                   ORDatesAlp                            CAP004 CAP043
     C**********         CLEAR                   OPDatesAlp                            CAP004 CAP043
     C**********         CLEAR                   TRDatesAlp                            CAP004 CAP043
     C**********         CLEAR                   TPDatesAlp                            CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C*****CIR001        IFEQ      'Y'                                                 CAP004 CAP043
     C**********         MOVE      RSFRNT        FOffKey                               CAP004 CAP043
      **********                                                                       CAP004 CAP043
      ***Our*Rate*Change*Dates                                                         CAP004 CAP043
     C**********         MOVE      'U'           OurThrKey                             CAP004 CAP043
     C**********         MOVE      'R'           RatPayKey                             CAP004 CAP043
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C**N98*****         EVAL      ORDatesAlp = IRCrecAlp                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
      ***Our*Interest*Payment*Dates                                                    CAP004 CAP043
     C**********         MOVE      'U'           OurThrKey                             CAP004 CAP043
     C**********         MOVE      'P'           RatPayKey                             CAP004 CAP043
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C**N98*****         EVAL      OPDatesAlp = IRCrecAlp                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
      ***Their*Rate*Change*Dates                                                       CAP004 CAP043
     C**********         MOVE      'T'           OurThrKey                             CAP004 CAP043
     C**********         MOVE      'R'           RatPayKey                             CAP004 CAP043
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C**N98*****         EVAL      TRDatesAlp = IRCrecAlp                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
      ***Their*Interest*Payment*Dates                                                  CAP004 CAP043
     C**********         MOVE      'T'           OurThrKey                             CAP004 CAP043
     C**********         MOVE      'P'           RatPayKey                             CAP004 CAP043
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C**N98*****         EVAL      TPDatesAlp = IRCrecAlp                              CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
                                                                                CAP004
      ** DL DATABASE UPDATE
     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
     C     RSCHTP        IFEQ      'I'
     C     RSCHTP        OREQ      'A'
     C     RSCHTP        OREQ      'R'
     C     RSCHTP        OREQ      'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   CALLB     'IRSIRSUPD'
     C**********         PARM                    @@RTCD            7                          247804
     C                   PARM      *BLANKS       @@RTCD            7                          247804
     C                   PARM      '*FRONT'      PModeOfOp                                    CAP056
     C                   PARM                    IRVSIRS
     C                   PARM                    IRVXSIR                                      CLE025
     C**********         PARM      ORDatesAlp    OurRatChgs      294                   CAP004 CAP043
     C**********         PARM      OPDatesAlp    OurPayDats      294                   CAP004 CAP043
     C**********         PARM      TRDatesAlp    ThrRatChgs      294                   CAP004 CAP043
     C**********         PARM      TPDatesAlp    ThrPayDats      294                   CAP004 CAP043
     C                   PARM      'N'           ScreenInpt                     CAP004
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
                                                                                CAP004
      /COPY WNCPYSRC,IRSIRSU005                                                 CAP004
     C                   END                                                    CAP006
     C                   END
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   ELSE
     C                   DELETE    IRVSIRSD0
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C     *IN01         ANDEQ     *OFF                                                       247804
     C                   DELETE    IRVXSIRP0                                                  CLE025
     C                   ENDIF                                                                CLE025
                                                                                CAP004
      ** If Interest Rate Calendars feature is on, delete records               CAP004
      ** for this transaction from valid file                                   CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
                                                                                CAP004
      ** Delete Our Rate Change Dates                                           CAP004
     C                   MOVE      'U'           OurThrKey                      CAP004
     C                   MOVE      'R'           RatPayKey                      CAP004
     C                   Eval      FoffKey = RSFRNT                                          BUG8899
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C**N98*****         DELETE    IRVDTSCD1                                           CAP004 CAP043
     C                   DELETE    IRVDTSCD1                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                CAP004
      ** Delete Our Interest Payment Dates                                      CAP004
     C                   MOVE      'U'           OurThrKey                      CAP004
     C                   MOVE      'P'           RatPayKey                      CAP004
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C**N98*****         DELETE    IRVDTSCD1                                           CAP004 CAP043
     C                   DELETE    IRVDTSCD1                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                CAP004
      ** Delete Their Rate Change Dates                                         CAP004
     C                   MOVE      'T'           OurThrKey                      CAP004
     C                   MOVE      'R'           RatPayKey                      CAP004
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C**N98*****         DELETE    IRVDTSCD1                                           CAP004 CAP043
     C                   DELETE    IRVDTSCD1                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                CAP004
      ** Delete Their Interest Payment Dates                                    CAP004
     C                   MOVE      'T'           OurThrKey                      CAP004
     C                   MOVE      'P'           RatPayKey                      CAP004
     C*****@KIRC         CHAIN     IRVDTSCL0                          98               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C**N98*****         DELETE    IRVDTSCD1                                           CAP004 CAP043
     C                   DELETE    IRVDTSCD1                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Delete Our Cash Flow                                                                 CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   MOVE      'U'           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVCFSCL0                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C                   DELETE    IRVCFSCD1                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Delete Their Cash Flow                                                               CAP043
                                                                                              CAP043
     C                   MOVE      'T'           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVCFSCL0                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C                   DELETE    IRVCFSCD1                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Delete Our Principal Change                                                          CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   MOVE      ' '           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVPCSCL0                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              98                  CAP043
     C                   DOW       *IN98 = *OFF                                               CAP043
     C                   DELETE    IRVPCSCD1                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                CAP004
     C                   END                                                    CAP004
                                                                                CAP004
     C                   COMMIT
     C/COPY WNCPYSRC,IRSIRSUC01
     C                   END
                                                                                CAP004
      /COPY WNCPYSRC,IRSIRSU006                                                 CAP004
                                                                                CAP004
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   EVAL      @Dealno = RSDLNO
     C                   EVAL      @Timestamp = RSTMESTMP
     C     @KSIRSL1      CHAIN     IRVSIRSL1                          89
     ** Write details of record to error file (same format as IRVSIRSPD)
     C                   WRITE     IRVSIRSERR
     C                   DELETE    IRVSIRSD1
                                                                                CAP004
      ** If Interest Rate Calendars feature is on,                              CAP004
      ** write details of record to error file (same format as IRVDTSCPD)       CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
                                                                                CAP004
      ** Our Rate Change Dates                                                  CAP004
     C                   MOVE      'U'           OurThrKey                      CAP004
     C                   MOVE      'R'           RatPayKey                      CAP004
     C*****@KIRC*        CHAIN     IRVDTSCL0                          89               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C******IN89*        IFEQ      '0'                                                 CAP004 CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVDTSCERR                                   CAP004
     C                   DELETE    IRVDTSCD1                                    CAP004
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C                   END                                                    CAP004
                                                                                CAP004
      ** Our Interest Payment Dates                                             CAP004
     C                   MOVE      'U'           OurThrKey                      CAP004
     C                   MOVE      'P'           RatPayKey                      CAP004
     C*****@KIRC*        CHAIN     IRVDTSCL0                          89               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C******IN89*        IFEQ      '0'                                                 CAP004 CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVDTSCERR                                   CAP004
     C                   DELETE    IRVDTSCD1                                    CAP004
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C                   END                                                    CAP004
                                                                                CAP004
      ** Their Rate Change Dates                                                CAP004
     C                   MOVE      'T'           OurThrKey                      CAP004
     C                   MOVE      'R'           RatPayKey                      CAP004
     C*****@KIRC*        CHAIN     IRVDTSCL0                          89               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C******IN89*        IFEQ      '0'                                                 CAP004 CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVDTSCERR                                   CAP004
     C                   DELETE    IRVDTSCD1                                    CAP004
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C                   END                                                    CAP004
                                                                                CAP004
      ** Delete Their Interest Payment Dates                                    CAP004
     C                   MOVE      'T'           OurThrKey                      CAP004
     C                   MOVE      'P'           RatPayKey                      CAP004
     C*****@KIRC*        CHAIN     IRVDTSCL0                          89               CAP004 CAP043
     C     @KIRC         SETLL     IRVDTSCL0                                                  CAP043
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C******IN89*        IFEQ      '0'                                                 CAP004 CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVDTSCERR                                   CAP004
     C                   DELETE    IRVDTSCD1                                    CAP004
     C     @KIRC         READE     IRVDTSCL0                              89                  CAP043
     C                   END                                                    CAP004
                                                                                              CAP043
      ** Our Cash Flow                                                                        CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   MOVE      'U'           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVCFSCL0                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              89                  CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVCFSCERR                                                 CAP043
     C                   DELETE    IRVCFSCD1                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              89                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Their Cash Flow                                                                      CAP043
                                                                                              CAP043
     C                   MOVE      'T'           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVCFSCL0                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              89                  CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVCFSCERR                                                 CAP043
     C                   DELETE    IRVCFSCD1                                                  CAP043
     C     KCFPC         READE     IRVCFSCL0                              89                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Our Principal Change                                                                 CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   MOVE      ' '           OurThrKey                                    CAP043
     C     KCFPC         SETLL     IRVPCSCL0                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              89                  CAP043
     C                   DOW       *IN89 = *OFF                                               CAP043
     C                   WRITE     IRVPCSCERR                                                 CAP043
     C                   DELETE    IRVPCSCD1                                                  CAP043
     C     KCFPC         READE     IRVPCSCL0                              89                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                CAP004
     C                   END                                                    CAP004
                                                                                CAP004
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID FORWARD RATE AGREEMENTS
     C                   READ      IRVSIRSD0                              99    *
     C                   END
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
     C                   END
                                                                                CAP004
      /COPY WNCPYSRC,IRSIRSU007                                                 CAP004
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRSIRSU010
 
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE                                                   CAP004
      ********************************************************************      CAP004
      /EJECT                                                                    CAP004
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
      *  Define key list for IRVSIRSL1
     C     @KSIRSL1      KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @Timestamp
      *
      *  Define key list for IRVDTSCL0                                          CAP004
     C     @KIRC         KLIST                                                  CAP004
     C                   KFLD                    FOffKey          20            CAP004
     C                   KFLD                    OurThrKey         1            CAP004
     C                   KFLD                    RatPayKey         1            CAP004
                                                                                              CAP043
      ** Define KLIST for IRVCFSCL0 and IRVPCSCL0                                             CAP043
                                                                                              CAP043
     C     KCFPC         KLIST                                                                CAP043
     C                   KFLD                    FOffKey                                      CAP043
     C                   KFLD                    OurThrKey                                    CAP043
      *                                                                         CAP004
      **  Access SAR details file to determine if CIR008 is installed                         CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSARD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*NRF   '              CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 901                                                CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *BLANKS                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      **  Access SAR details file to determine if CAP056 is installed                         CAP056
                                                                                              CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRetCode                                     CAP056
     C                   PARM      '*VERIFY'     POption                                      CAP056
     C                   PARM      'CAP056'      PSARD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRetCode <> *BLANKS AND PRetCode <> '*NRF   '              CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 902                                                CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        PRetCode = *BLANKS                                         CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CLE025
      **  Access SAR details file to determine if CLE025 is installed                         CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRetCode                                     CLE025
     C                   PARM      '*VERIFY'     POption                                      CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*NRF   '              CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBASE = 899                                                CLE025
     C                   EVAL      DBKEY = 'CLE025'                                           CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRetCode = *BLANKS                                         CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CAP056
      *  Check if an existing DBU_SIRS job is active in the subsystem.                        201589
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
 
      ** ACCESS SAR DETAILS FOR Interest Rate Calendars                         CAP004
      *                                                                         CAP004
     C                   CALL      'AOSARDR0'                                   CAP004
     C                   PARM      *BLANKS       @RTCD                          CAP004
     C                   PARM      '*VERIFY'     @OPTN                          CAP004
     C                   PARM      'CIR001'      @SARD             6            CAP004
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP004
      *                                                                         CAP004
      * DATABASE ERROR                                                          CAP004
      *                                                                         CAP004
     C     @RTCD         IFNE      *BLANKS                                      CAP004
     C     @RTCD         ANDNE     '*NRF   '                                    CAP004
     C                   MOVEL     'CIR001'      DBKEY                          CAP004
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************CAP004
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *CAP004
     C                   EXSR      *PSSR                                        *************CAP004
     C                   END                                                    CAP004
     C*                                                                         CAP004
     C     @RTCD         IFEQ      *BLANK                                       CAP004
     C                   MOVEL     'Y'           CIR001            1            CAP004
     C                   ELSE                                                   CAP004
     C                   MOVEL     'N'           CIR001                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      ** Determine if CAP043 enhancement is installed                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *Blanks       PRtcd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtcd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtcd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 906                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Determine if CAP041 enhancement is installed                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP041'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP041 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP041 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP041'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 908                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRSIRSU011
 
     C                   ENDSR
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2001
