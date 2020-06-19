000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas FX Deals database update controller')            *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - FX Dealer Module                                     *
000900200529      *                                                               *
001000200529      *  FXFXDLUPC - FX DEALS DATABASE UPDATE CONTROLLER              *
001100200529      *                                                               *
001200200529      *  (c) Finastra International Limited 2001                      *
001300200529      *                                                               *
001400200604      *  Last Amend No. 251029             Date 22May20               *
001500200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200529      *                 CDL099             Date 06Oct17               *
001700200529      *                 CSW212             Date 03May12               *
001800200529      *                 CER059             Date 19Jul10               *
001900200529      *                 CER043             Date 19May08               *
002000200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002100200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002200200529      *                 257309             Date 22Oct08               *
002300200529      *                 256564             Date 17Sep08               *
002400200529      *                 245219             Date 09Mar07               *
002500200529      * Midas Plus 1.4 Base ------------------------------------------*
002600200529      *                 244036             Date 22Sep06               *
002700200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002800200529      *                 CDL049             Date 07Jul06               *
002900200529      *                 CSD027             Date 09Dec05               *
003000200529      *                 CDL038             Date 10May05               *
003100200529      *                 CFX114             Date 15Jun04               *
003200200529      *                 CDL010             Date 02Aug02               *
003300200529      * Midas Release 4.01 -------------------------------------------*
003400200529      *                 CAS001             Date 23Nov01               *
003500200529      *                 201589             Date 03Jan02               *
003600200529      * Midas Release 4 --------------- Base -------------------------*
003700200529      * Midas DBA 3.04 -----------------------------------------------*
003800200529      *                 CDL008             Date 02May00               *
003900200529      * Midas DBA 3.02 -----------------------------------------------*
004000200529      *                 CAP051             Date 11Nov99               *
004100200529      *                 CPB001             Date 01Jun99               *
004200200529      * Midas DBA 3.00 ---------------- Base -------------------------*
004300200529      *                 CAP006             Date 24Feb99               *
004400200529      *                 CAP002  *CREATE    Date 01Nov97               *
004500200529      *                                                               *
004600200529      *---------------------------------------------------------------*
004700200529      *                                                               *
004800200529      *  251029 - Applied fix 231306.                                 *
004900200529      *  231306 - Handle file locking properly.                       *
005000200529      *  MD046248 - Finastra Rebranding                               *
005100200529      *  CDL099 - Split Value Date (Recompile)                        *
005200200529      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
005300200529      *  CER059 - German Feature Upgrade to Delhi                     *
005400200529      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
005500200529      *           (Recompile)                                         *
005600200529      *  257309 - Prevents DLDLDBQD locking                           *
005700200529      *  256564 - Recompile due to PF changes done by fix 256330      *
005800200529      *  245219 - DLDLDBQD should be updated when FXDEALPP is updated *
005900200529      *           as this is the stage java would update it.          *
006000200529      *  244036 - Missing deals in extension file DLDLDBQD (done from *
006100200529      *           Java layer).                                        *
006200200529      *  CDL049 - Addition of a Reference Rate field (recompile)      *
006300200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
006400200529      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
006500200529      *  CFX114 - Core changes for GBO014                             *
006600200529      *         - Perform Override when Exchange Rate Tolerance is    *
006700200529      *           exceeded.                                           *
006800200529      *         - Upgrade to Midasplus                                *
006900200529      *           Core hooks amended:FXFXDLU011,FXFXDLU005            *
007000200529      *  CDL010 - Prevent last user that actioned the trade from      *
007100200529      *           authorising it.Recompile due to changes in FXVFXDLPD*
007200200529      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
007300200529      *  201589 - Change to check a new locking dataarea FXFXDLLCK    *
007400200529      *           to determine whether this DBU is already active.    *
007500200529      *  CDL008 - Continuous Linked Settlement                        *
007600200529      *  CAP051 - Automatic Authorisation (FX Part)                   *
007700200529      *           Recompiled due to changes in FXVFXDLPD              *
007800200529      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
007900200529      *           Recompiled due to changes in FXVFXDLPD              *
008000200529      *  CAP006 - Check for deal being updated by another workstation *
008100200529      *         - Send prompt to DTAQ to restart update process after *
008200200529      *           failure.                                            *
008300200529      *  CAP002 - Conversion of FX inputs into modular structure to   *
008400200529      *           use as APIs.                                        *
008500200529      *                                                               *
008600200529      *****************************************************************
008700200529     FFXVFXDLPD UF   E             DISK
008800200529     F                                     COMMIT
008900200529     FFXVFXDLL1 UF   E           K DISK
009000200529     F                                     RENAME(FXVFXDLD0:FXVFXDLD1)
009100200529     FFXVEFXDLPDO    E             DISK
009200200529     F                                     BLOCK(*NO)                                         231306
009300200529     F                                     RENAME(FXVFXDLD0:FXVFXDLERR)
009400200529                                                                                              244036
009500200529      ** Midas DL Foreign Exchange Deals Extension Details.                                   244036
009600200529     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       244036
009700200529     F                                     IGNORE(DLDLDCD0)                                   244036
009800200529     F                                     IGNORE(DLDLDGD0)                                   244036
009900200529     F                                     USROPN                                             257309
010000200529
010100200529      * Hook to enable non-core files to be included
010200200529      /COPY WNCPYSRC,FXFXDLU010
010300200529
010400200529      *****************************************************************
010500200529      ** +--------------------------------------+
010600200529      ** ¦ Automatically included D-specs       ¦
010700200529      ** ¦ ==============================       ¦
010800200529      ** +--------------------------------------+
010900200529      **
011000200529      ** Standard D-specs
011100200529      ** ================
011200200529      **
011300200529      ** The following /COPY line includes the LDA layout,
011400200529      ** the copyright array definition,
011500200529      ** and the following named constants:
011600200529      **    True       logical = *on (for indcator processing)
011700200529      **    False      logical = *off (for indcator processing)
011800200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
011900200529      **                                    handler)
012000200529      ** and the following variables:
012100200529      **    RunBefore  1A (for the PSSR)
012200200529
012300200529     D/COPY ZACPYSRC,STD_D_SPEC
012400200529
012500200529      ** Include the FX standard declares
012600200529     D/COPY ZACPYSRC,STDDECLARE
012700200529
012800200529      ** Program Status Data Structure
012900200529      ** =============================
013000200529      ** The following /COPY line includes all the defined fields in the
013100200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
013200200529
013300200529     D/COPY ZACPYSRC,PSDS
013400200529
013500200529      **------------------------------------------------------------------------CAP006--------------
013600200529      ** The following /COPY line includes the definitions for fields           CAP006
013700200529      ** used in checking whether there are messages on the data queue.         CAP006
013800200529     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
013900200529      **------------------------------------------------------------------------CAP006--------------
014000200529                                                                                CAP006
014100200529      ** +--------------------------------------+
014200200529      ** ¦ End of automatically included D-specs¦
014300200529      ** ¦ =====================================¦
014400200529      ** +--------------------------------------+
014500200529     D DBerrUpd        C                   CONST('DB error in FX API update')
014600200529
014700200529      *****************************************************************
014800200529
014900200529      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FX DEAL
015000200529     D FXVFXD        E DS                  EXTNAME(FXVFXDLPD)
015100200529
015200200529     D FXFXDLUPC       DS             1
015300200529
015400200529     D Object          S             10A   INZ('FXFXDLUPC')
015500200529     D LockObj         S             10A   INZ('FXFXDLLCK')                                   201589
015600200529     D Lib             S             10A   INZ('*LIBL')
015700200529     D ObjType         S              7A   INZ('*DTAARA')
015800200529     D LockStateE      S              7A   INZ('*EXCL')
015900200529     D LockStateS      S              7A   INZ('*SHRRD')
016000200529     D Member          S             10A
016100200529     D WaitTime        S              6A   INZ('*CLS')
016200200529     D Dlcobj          S              1A
016300200529     D Return          S              7A
016400200529     D Return2         S              7A                                                      201589
016500200529     D Endjob          S              1A   INZ('Y')                                           201589
016600200529     D @Timestamp      S             26Z
016700200529
016800200529      ** Dummy message ID and message file fields for use on the calls to
016900200529      ** ZAMSGTOOPR
017000200529     D DummyMsgID      S                   LIKE(#MsgID)
017100200529     D DummyMsgF       S             10A
017200200529
017300200529
017400200529      ** +--------------------------------------+
017500200529      ** ¦ End of D-specs                       ¦
017600200529      ** ¦ ==============                       ¦
017700200529      ** +--------------------------------------+
017800200529
017900200529      ** +----------------------------------------+
018000200529      ** ¦ Hook for non-core D-specs (all types)  ¦
018100200529      ** ¦ also any I-specs (if necessary)        ¦
018200200529      ** ¦ =====================================  ¦
018300200529      ** +----------------------------------------+
018400200529      /COPY WNCPYSRC,FXFXDLU011
018500200529
018600200529      /EJECT
018700200529     C*****************************************************************
018800200529     C*                                                               *
018900200529     C* MAIN - MAIN BODY                                              *
019000200529     C*                                                               *
019100200529     C*****************************************************************
019200200529
019300200529      /COPY WNCPYSRC,FXFXDLU001
019400200529
019500200529      ** Set up the name of the server/database updater data queue.             CAP006
019600200529     C                   EVAL      DtaQName = 'APFXDLDTQ'                       CAP006
019700200529                                                                                CAP006
019800200529      **------------------------------------------------------------------------CAP006--------------
019900200529      ** The following /COPY line includes a check for whether there            CAP006
020000200529      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
020100200529      ** message to the data queue if there are not.                            CAP006
020200200529     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
020300200529      **------------------------------------------------------------------------CAP006--------------
020400200529                                                                                CAP006
020500200529      *  Initialise Data queue parms
020600200529     C                   EVAL      DtqLen = 10
020700200529     C                   EVAL      DtqWait = -1
020800200529     C                   EVAL      DtqNam = 'APFXDLDTQ'
020900200529     C                   EVAL      DtqLib = '*LIBL'
021000200529     C                   EVAL      ObjType = '*DTAARA'
021100200529      ** Wait for data queue prompt
021200200529      ** Server program will send data queue entry when record is
021300200529      ** written to the valid transactions file
021400200529     C     DtqDta        DOWNE     'END'
021500200529     C                   CALL      'QRCVDTAQ'
021600200529     C                   PARM                    DtqNam           10
021700200529     C                   PARM                    DtqLib           10
021800200529     C                   PARM                    DtqLen            5 0
021900200529     C                   PARM                    DtqDta           10
022000200529     C                   PARM                    DtqWait           5 0
022100200529     C     DtqDta        IFEQ      'GO'
022200200529      *  Lock allocation data area
022300200529     C                   CALLB     'APCALCOBJ'
022400200529     C                   PARM                    Object
022500200529     C                   PARM                    Lib
022600200529     C                   PARM                    ObjType
022700200529     C                   PARM                    LockStateE
022800200529     C                   PARM                    Member
022900200529     C                   PARM                    WaitTime
023000200529     C                   PARM                    Dlcobj
023100200529     C                   PARM                    Return
023200200529
023300200529      /COPY WNCPYSRC,FXFXDLU002
023400200529
023500200529      ** Position file cursor to start of file to prevent problems on
023600200529      ** later calls
023700200529     C     1             SETLL     FXVFXDLPD
023800200529
023900200529      ** READ VALID FX DEAL
024000200529     C                   READ      FXVFXDLD0                              99    *
024100200529     C     *IN99         DOWEQ     '0'
024200200529
024300200529      /COPY WNCPYSRC,FXFXDLU003
024400200529
024500200529      ** Load the API Dump data area with as many fields from the message
024600200529      **  header as are available, so that dumps in any lowere level modules
024700200529      **  will include the key information
024800200529     C                   EVAL      ARFOTranID = F3FRNT
024900200529     C                   EVAL      ARFOAsocID = F3AFRT
025000200529     C                   EVAL      ARRprLocn  = F3REPA
025100200529     C                   EVAL      @Timestamp = F3TMESTMP                                     231306
025200200529
025300200529      /COPY WNCPYSRC,FXFXDLU004
025400200529
025500200529      ** FX DATABASE UPDATE
025600200529     C                   CALLB     'FXFXDLUPF'
025700200529     C**********         PARM                    @@RTCD            7            CAP006
025800200529     C                   PARM      *BLANKS       @@RTCD            7            CAP006
025900200529     C                   PARM                    FXVFXD
026000200529
026100200529      /COPY WNCPYSRC,FXFXDLU005
026200200529
026300200529      ** DL DATABASE UPDATE IF NO ERROR
026400200529     C     @@RTCD        IFEQ      '*ERROR '
026500200529     C                   ROLBK
026600200529     C                   ELSE
026700200529                                                                                              245219
026800200529      ** Add record to DLDLDBQD once deal is on FXDEALPP as this is what java does            245219
026900200529     C                   IF        F3CHTP = *blanks                                           245219
027000200529     C                   EXSR      WriteDLDLDB                                                245219
027100200529     C                   END                                                                  245219
027200200529                                                                                              245219
027300200529     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
027400200529     C     @@RTCD        ANDNE     '*RECLCK'                                                  231306
027500200529     C     F3CHTP        IFEQ      'I'
027600200529     C     F3CHTP        OREQ      'A'
027700200529     C     F3CHTP        OREQ      'R'
027800200529
027900200529      /COPY WNCPYSRC,FXFXDLU006
028000200529
028100200529     C                   CALLB     'FXFXDLUPD'
028200200529     C                   PARM                    @@RTCD            7
028300200529     C                   PARM                    FXVFXD
028400200529     C/COPY WNCPYSRC,FXH00251
028500200529                                                                                              245219
028600200529      * DLDLDBQD records needs to be written when FXDEALPP record is written, not DEALSDB     245219
028700200529      * This is when F3CHTP is blank.  Authorisation needed must be YES for                   245219
028800200529      * midasplus so F3CHTP will always be blank when writing to FXDEALPP.                    245219
028900200529      *********                                                                        244036 245219
029000200529      ***Add*record within Deals Master Extension File (done from Java layer).         244036 245219
029100200529     C*********          IF        F3CHTP = 'I'                                        244036 245219
029200200529     C*********          EXSR      WriteDLDLDB                                         244036 245219
029300200529     C*********          END                                                           244036 245219
029400200529                                                                                       244036 245219
029500200529     C                   END
029600200529     C                   END                                                    CAP006
029700200529     C                   END
029800200529
029900200529      /COPY WNCPYSRC,FXFXDLU007
030000200529
030100200529      * COMIT UPDATES IF NO ERROR
030200200529     C     @@RTCD        IFEQ      '*ERROR '
030300200529     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
030400200529     C     @@RTCD        OREQ      '*RECLCK'                                                  231306
030500200529     C                   ROLBK
030600200529     C                   ELSE
030700200529     C                   DELETE    FXVFXDLD0
030800200529
030900200529      /COPY WNCPYSRC,FXFXDLU014
031000200529
031100200529     C                   COMMIT
031200200529     C/COPY WNCPYSRC,FXFXDLUC01
031300200529     C                   END
031400200529
031500200529      /COPY WNCPYSRC,FXFXDLU008
031600200529
031700200529     ** If an error has occurred, reaccess record in error and remove from
031800200529     ** the file to prevent program processing the same record again
031900200529     C     @@RTCD        IFEQ      '*ERROR '
032000200529     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
032100200529     C     @@RTCD        OREQ      '*RECLCK'                                                  231306
032200200529     C                   EVAL      @Dealno = F3DN38
032300200529     C**********         EVAL      @Timestamp = F3TMESTMP                                     231306
032400200529     C     @KFXDL1       CHAIN     FXVFXDLL1                          89
032500200529     ** Write details of record to error file (same format as FXVFXDLPD)
032600200529     C                   WRITE     FXVFXDLERR
032700200529     C                   DELETE    FXVFXDLD1
032800200529
032900200529      /COPY WNCPYSRC,FXFXDLU015
033000200529
033100200529     ** Send message to system operator
033200200529     C                   MOVEL     DBerrUpd      DBError          28
033300200529     C                   CALLB     'ZAMSGTOOPR'
033400200529     C                   PARM                    MsgSndRtn        10
033500200529     C                   PARM                    DBError
033600200529     C                   PARM                    DummyMsgID
033700200529     C                   PARM                    DummyMsgF
033800200529
033900200529     C                   ENDIF
034000200529
034100200529      ** READ VALID FX DEAL
034200200529     C                   READ      FXVFXDLD0                              99    *
034300200529     C                   END
034400200529     ** Unlock allocation data area
034500200529     C                   CALLB     'APCDLCOBJ'
034600200529     C                   PARM                    Object
034700200529     C                   PARM                    Lib
034800200529     C                   PARM                    ObjType
034900200529     C                   PARM                    LockStateE
035000200529     C                   PARM                    Member
035100200529     C                   PARM                    Return
035200200529     C                   END
035300200529      ** End loop for data queue prompt
035400200529     C                   END
035500200529
035600200529      /COPY WNCPYSRC,FXFXDLU009
035700200529
035800200529      * EXIT FROM PROGRAM
035900200529     C                   RETURN
036000200529
036100200529      * Hook to enable non-core subroutines to be included
036200200529      /COPY WNCPYSRC,FXFXDLU012
036300200529
036400200529      *****************************************************************                       244036
036500200529      /EJECT                                                                                  244036
036600200529      *****************************************************************                       244036
036700200529      *                                                               *                       244036
036800200529      * WriteDLDLDB - WRITE Foreign Exchange Extension record (done   *                       244036
036900200529      *               from Java layer).                               *                       244036
037000200529      *                                                               *                       244036
037100200529      *****************************************************************                       244036
037200200529     C     WriteDLDLDB   BEGSR                                                                244036
037300200529      *                                                                                       244036
037400200529      ** When opening new deals within DEALSDB, write a corresponding                         244036
037500200529      ** record in the Deals details extension file DLDLDBQD.                                 244036
037600200529      *                                                                                       244036
037700200529     C     @KeyDealL5    KLIST                                                                244036
037800200529     C                   KFLD                    F1DLNO                                       244036
037900200529      *                                                                                       244036
038000200529     C                   MOVE      F3DN38        F1DLNO                                       244036
038100200529     C                   OPEN      DLDEALL5                                                   257309
038200200529     C     @KeyDealL5    CHAIN     DLDLDBD0                           82                      244036
038300200529      *                                                                                       244036
038400200529     C     *IN82         IFEQ      *ON                                                        244036
038500200529     C                   EVAL      F1BRCA = F3MBCA                                            244036
038600200529     C                   WRITE     DLDLDBD0                                                   244036
038700200529                                                                                              244036
038800200529     C                   ENDIF                                                                244036
038900200529     C                   CLOSE     DLDEALL5                                                   257309
039000200529                                                                                              244036
039100200529     C                   ENDSR                                                                244036
039200200529      *****************************************************************                       244036
039300200529      /EJECT
039400200529      *****************************************************************
039500200529      *                                                               *
039600200529      * *INZSR - Program Initialisation routine                       *
039700200529      *                                                               *
039800200529      * Called by: Main processing                                    *
039900200529      *                                                               *
040000200529      * Calls: None                                                   *
040100200529      *                                                               *
040200200529      *****************************************************************
040300200529     C     *INZSR        BEGSR
040400200529
040500200529      *  Define data area used to check if DB update running
040600200529     C     *DTAARA       DEFINE                  FXFXDLUPC
040700200529      *  Define key list for FXVFXDLL1
040800200529     C     @KFXDL1       KLIST
040900200529     C                   KFLD                    @Dealno           6 0
041000200529     C                   KFLD                    @Timestamp
041100200529
041200200529      *  Check if an existing DBU_FXDL job is active in the subsystem.                        201589
041300200529                                                                                              201589
041400200529     C                   CALL      'SCC0520'                                                  201589
041500200529     C                   PARM                    LockObj                                      201589
041600200529     C                   PARM                    Lib                                          201589
041700200529     C                   PARM                    ObjType                                      201589
041800200529     C                   PARM                    LockStateE                                   201589
041900200529     C                   PARM                    Member                                       201589
042000200529     C                   PARM                    Endjob                                       201589
042100200529     C                   PARM                    Return2                                      201589
042200200529                                                                                              201589
042300200529      *  Lock allocation data area
042400200529
042500200529      *   The data area is allocated *SHRRD here and *EXCL whilst processing
042600200529      *    of the valid file is actually taking place.
042700200529      *   The function to submit this updater tries to get a *EXCL lock.
042800200529      *   The controller tries to get a *SHRRD lock.
042900200529
043000200529      *                         Submitter             Controller
043100200529      *                 Lock      Lock     Submitter     Lock     Controller
043200200529      *      Status    Status   Successful   Action   Successful    Action
043300200529      *      ------    ------   ---------- ---------  ----------  ----------
043400200529      *   Not running  None        Yes      Submit       Yes        Prompt
043500200529      *                                     updater                 updater
043600200529
043700200529      *   Running not  *SHRRD      No        None        Yes        Prompt
043800200529      *    processing                                               updater
043900200529
044000200529      *   Processing   *EXCL       No        None        No         None
044100200529
044200200529     C                   CALLB     'APCALCOBJ'
044300200529     C                   PARM                    Object
044400200529     C                   PARM                    Lib
044500200529     C                   PARM                    ObjType
044600200529     C                   PARM                    LockStateS
044700200529     C                   PARM                    Member
044800200529     C                   PARM                    WaitTime
044900200529     C                   PARM                    Dlcobj
045000200529     C                   PARM                    Return
045100200529
045200200529      ** Create required QTEMP objects
045300200529     C                   CALL      'APCCRTQTO'
045400200529     C                   PARM                    ReturnCde        10
045500200529
045600200529      *  Hook to enable non-core initial processing to be included
045700200529      /COPY WNCPYSRC,FXFXDLU013
045800200529
045900200529     C                   ENDSR
046000200529     C****************************************************************
046100200529      /EJECT
046200200529      *****************************************************************
046300200529      **--------------------------------------------------------------------------------------------
046400200529      ** The following /COPY contains the standard program status
046500200529      ** subroutine, including a bound call to the DBERRCTL module.
046600200529     C/COPY ZACPYSRC,PSSR_ILE
046700200529      **--------------------------------------------------------------------------------------------
046800200529      *****************************************************************
046900200529      /EJECT
047000200529**  CPY@
047100200529(c) Finastra International Limited 2001
