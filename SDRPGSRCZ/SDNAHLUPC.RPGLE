     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Database Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLUPC - SD Non-A/C Holders Database Update Controller    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 03Aug17               *
      *  Prev Amend No. MD041313           Date 16Sep16               *
      *                 MD040876           Date 26Aug16               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL132             Date 01May13               *
      *                 AR1043440          Date 11Oct12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24746           Date 02Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 06Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234279             Date 28Jul05               *
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender Fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD041313 - US Indicia System Values are not populated        *
      *  MD040876 - CRS MQ                                            *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  AR1043440 - Tax records wrongly created by NAHL RPG API      *
      *              (Child:AR1044219)                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24746 - Missing Source for German Features (Recompile)    *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes (Recompile)                     *
      *  234279 - SDNHTXPD Records are not defaulted                  *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
 
     FSDVNAHLPD UF   E             Disk
     F                                     COMMIT
 
     FSDVNAHLL1 UF   E           K Disk
     F                                     Rename(SDVNAHLD0:SDVNAHLD1)
     FSDVFTNHL0 UF   E           K DISK                                                       CGL132
     F                                     COMMIT                                             CGL132
     FSDVFTNHL1 UF   E           K DISK                                                     MD040876
     F                                     Rename(SDVFTNHD0:SDVFTNHD1)                      MD040876
     F                                     COMMIT                                           MD040876
     FSDVCRNHL0 UF   E           K DISK                                                     MD040876
     F                                     COMMIT                                           MD040876
     FSDVCRNHL1 UF   E           K DISK                                                     MD040876
     F                                     Rename(SDVCRNHD0:SDVCRNHD1)                      MD040876
     F                                     COMMIT                                           MD040876
     FSDVCRSNL0 UF   E           K DISK                                                     MD040876
     F                                     COMMIT                                           MD040876
     FSDVCRSNL1 UF   E           K DISK                                                     MD040876
     F                                     Rename(SDVCRSND0:SDVCRSND1)                      MD040876
     F                                     COMMIT                                           MD040876
 
     FSDVENAHLPDO    E             Disk
     F                                     Rename(SDVNAHLD0:SDVNAHLERR)
     FSDVEFTNHPDO    E             Disk                                                     MD040876
     F                                     Rename(SDVFTNHD0:SDVFTNHERR)                     MD040876
     FSDVECRNHPDO    E             Disk                                                     MD040876
     F                                     Rename(SDVCRNHD0:SDVCRNHERR)                     MD040876
     FSDVECRSNPDO    E             Disk                                                     MD040876
     F                                     Rename(SDVCRSND0:SDVCRSNERR)                     MD040876
 
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
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   Const('DB error in NAHL API update')
 
      *****************************************************************
 
      **  Externally Described Data Structure for Valid Non-A/C Holder
     D SDVNAH        E DS                  Extname(SDVNAHLPD)
     D SDVFATCA      E DS                  Extname(SDVFTNHPD)                                 CGL132
     D SDVCRNH       E DS                  Extname(SDVCRNHPD)                               MD040876
     D SDVCRSN       E DS                  Extname(SDVCRSNPD)                               MD040876
 
     D SDNAHLUPC       DS             1    Dtaara(SDNAHLUPC)
 
      ** External DS for SAR details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D  SCA_LCD      E                     Extfld(LCD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Override Database Table                                                            MD041313
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                          MD041313
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                          MD041313
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)                          MD041313
     D ##OV4           S             50    DIM(1) CTDATA PERRCD(1)                          MD041313
                                                                                            MD041313

     D PCrsdF          S            222A   DIM(30)                                          MD040876
     D Object          S             10A   Inz('SDNAHLUPC')
     D LockObj         S             10A   Inz('SDNAHLLCK')
     D Lib             S             10A   Inz('*LIBL')
     D ObjType         S              7A   Inz('*DTAARA')
     D LockStateE      S              7A   Inz('*EXCL')
     D LockStateS      S              7A   Inz('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   Inz('*CLS')
     D Dlcobj          S              1A
     D RETURN          S              7A
     D RETURN2         S              7A
     D Endjob          S              1A   Inz('Y')
     D @CuNaho         S             10A
     D @Timestamp      S             26Z
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   Like(#MsgID)
     D DummyMsgF       S             10A
     D MsgSndRtn       S             10
 
      ** Command length for QCMDEXC                                                           234279
     D CommandLen      S             15P 5 INZ(35)                                            234279
     D Command         S             50A   INZ(*BLANKS)                                       234279
                                                                                              234279
      ** Data queue details
     D DtqLen          S              5P 0 Inz(10)
     D DtqWait         S              5P 0 Inz(-1)
     D DtqNam          S             10A   Inz('APNAHLDTQ')
     D DtqLib          S             10A   Inz('*LIBL')
     D DtqDta          S             10A
 
     D @@RTCD          S              7
     D DBError         S             28
     D ReturnCde       S             10
     D PRtCd           S              7A                                                   AR1043440
     D POptn           S              7A                                                   AR1043440
     D PSard           S              6A                                                   AR1043440
     D CGL031          S              1A                                                   AR1043440
     D CGL032          S              1A                                                   AR1043440
     D CGL132          S              1A                                                      CGL132
     D CGL157          S              1A                                                    MD040876
     D X               S              2S 0                                                  MD040876
     D PReturn         S              7A                                                    MD041313
     D PTranID         S             10A                                                    MD041313
     D PSource         S              1A                                                    MD041313
     D PClass          S              5A   INZ(*BLANKS)                                     MD041313
     D PRepType        S              1A                                                    MD041313
     D PMode           S              1A                                                    MD041313
     D WMsgLen         S             15P 5 INZ(50)                                          MD041313
     D WTimestamp      S             26A                                                      CGL157
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APNAHLDTQ'
 
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
 
     C     DtqDta        IFEQ      'GO'
 
      ** Allocate with exclusive lock state
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    RETURN
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
 
     C                   CLEAR                   *InU7
     C                   CLEAR                   *InU8
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
 
     C     1             SETLL     SDVNAHLPD
 
      ** Read Valid SD Non-A/C Holder
 
     C                   READ      SDVNAHLD0                              99
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C     NANAHO        CHAIN     SDVFTNHL0                          99                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CGL157 = 'Y'                                             MD040876
     C     NANAHO        CHAIN     SDVCRNHL0                          99                    MD040876
                                                                                            MD040876
     C                   EVAL      X = 1                                                    MD040876
     C                   CLEAR                   PCrsdF                                     MD040876
     C     NANAHO        SETLL     SDVCRSNL0                                                MD040876
     C     NANAHO        READE     SDVCRSNL0                                                MD040876
     C                   DOW       NOT %EOF(SDVCRSNL0)                                      MD040876
     C                             AND NANAHO = RVNAHO                                      MD040876
     C                             AND X < 31                                               MD040876
     C                   EVAL      PCrsdF(X) = SDVCRSN                                      MD040876
     C                   EVAL      X = X + 1                                                MD040876
     C     NANAHO        READE     SDVCRSNL0                                                MD040876
     C                   ENDDO                                                              MD040876
     C                   ENDIF                                                              MD040876
                                                                                            MD040876
     C     *IN99         DOWEQ     '0'
 
      ** Load the API dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
 
     C                   EVAL      ARFOTranID = NAFRNT
     C                   EVAL      ARFOAsocID = *Blank
     C                   EVAL      ARRprLocn  = NAREPA
     C                   EVAL      @Timestamp = NATMST
 
      ** SD Database Update
 
     C                   CALLB     'SDNAHLUPD'
     C                   PARM      *BLANK        @@RTCD
     C                   PARM                    SDVNAH
     C                   PARM                    SDVFATCA                                     CGL132
     C                   PARM                    SDVCRNH                                    MD040876
     C                   PARM                    PCrsdF                                     MD040876
 
      ** Commit updates if no error
 
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
 
     C                   ROLBK
     C                   ELSE
 
     C                   DELETE    SDVNAHLD0
                                                                                            MD040876
     C                   IF        CGL132 = 'Y'                                             MD040876
     C     NANAHO        CHAIN     SDVFTNHL0                                                MD040876
     C                   IF        %FOUND(SDVFTNHL0)                                        MD040876
     C                   DELETE    SDVFTNHD0                                                  CGL132
     C                   ENDIF                                                              MD040876
     C                   ENDIF                                                              MD040876
     C                   IF        CGL157 = 'Y'                                             MD040876
     C     NANAHO        CHAIN     SDVCRNHL0                          99                    MD041313
     C                   IF        %FOUND(SDVCRNHL0)                                        MD041313
     C                   DELETE    SDVCRNHD0                                                MD040876
     C     NANAHO        SETLL     SDVCRSNL0                                                MD040876
     C     NANAHO        READE     SDVCRSNL0                                                MD040876
     C                   DOW       NOT %EOF(SDVCRSNL0)                                      MD040876
     C                             AND NANAHO = RVNAHO                                      MD040876
     C                   DELETE    SDVCRSND0                                                MD040876
     C     NANAHO        READE     SDVCRSNL0                                                MD040876
     C                   ENDDO                                                              MD040876
     C                   ENDIF                                                              MD041313
     C                   ENDIF                                                              MD040876
     C                   COMMIT
     C                   IF        @@RTCD = *BLANKS                                         MD041313
     C                             AND CGL132 ='Y'                                          MD041313
                                                                                            MD041313
     C                   CALL      'QCMDEXC'                                                MD041313
     C                   PARM                    ##OV1                                      MD041313
     C                   PARM                    WMsgLen                                    MD041313
                                                                                            MD041313
     C                   CALL      'QCMDEXC'                                                MD041313
     C                   PARM                    ##OV3                                      MD041313
     C                   PARM                    WMsgLen                                    MD041313
                                                                                            MD041313
     C                   CALL      'SD000732'                                               MD041313
     C                   PARM      *BLANKS       PReturn                                    MD041313
     C                   PARM      NANAHO        PTranID                                    MD041313
     C                   PARM      'N'           PSource                                    MD041313
     C                   PARM                    PClass                                     MD041313
     C                   PARM                    PClass                                     MD041313
     C                   PARM      ' '           PRepType                                   MD041313
     C                   PARM      'A'           PMode                                      MD041313
                                                                                            MD041313
     C                   CALL      'QCMDEXC'                                                MD041313
     C                   PARM                    ##OV2                                      MD041313
     C                   PARM                    WMsgLen                                    MD041313
                                                                                            MD041313
     C                   CALL      'QCMDEXC'                                                MD041313
     C                   PARM                    ##OV4                                      MD041313
     C                   PARM                    WMsgLen                                    MD041313
                                                                                            MD041313
     C                   ENDIF                                                              MD041313
                                                                                           AR1043440
     C                   IF        CGL031 = 'Y' AND                                        AR1043440
     C                             CGL032 = 'Y'                                            AR1043440
                                                                                              234279
      ** Default records in PF/SDNHTXPD                                                       234279
                                                                                              234279
     C                   EVAL      Command = 'OVRDBF FILE(SDNAHOL1) SHARE(*NO)'               234279
     C                   CALL      'QCMDEXC'                                                  234279
     C                   PARM                    Command                                      234279
     C                   PARM                    CommandLen                                   234279
                                                                                              234279
     C                   CALL      'SD000779'                                                 234279
     C                   ENDIF                                                             AR1043440
 
     C                   ENDIF
 
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again
 
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @CuNaho = NANAHO
     C                   EVAL      @Timestamp = NATMST
 
     C     @KeyNahoL1    CHAIN     SDVNAHLL1                          89
 
      ** Write details of record to error file (same format as SDVNAHLPD)
 
     C                   WRITE     SDVNAHLERR
     C                   DELETE    SDVNAHLD1
     C                   IF        CGL132 = 'Y'                                             MD040876
     C                   MOVE      @Timestamp    WTimestamp                                   CGL157
     C     WKeyNahoL1    CHAIN     SDVFTNHL1                          89                    MD040876
                                                                                            MD040876
     C                   WRITE     SDVFTNHERR                                               MD040876
     C                   DELETE    SDVFTNHD1                                                MD040876
     C                   ENDIF                                                              MD040876
     C                   IF        CGL157 = 'Y'                                             MD040876
     C     @KeyNahoL1    CHAIN     SDVCRNHL1                          89                    MD040876
                                                                                            MD040876
     C                   WRITE     SDVCRNHERR                                               MD040876
     C                   DELETE    SDVCRNHD1                                                MD040876
                                                                                            MD040876
     C     @KeyNahoL1    SETLL     SDVCRSNL1                                                MD040876
     C     @KeyNahoL1    READE     SDVCRSNL1                                                MD040876
     C                   DOW       %FOUND(SDVCRSNL1)                                        MD040876
     C                             AND NANAHO = RVNAHO                                      MD040876
     C                   WRITE     SDVCRSNERR                                               MD040876
     C                   DELETE    SDVCRSND1                                                MD040876
     C     @KeyNahoL1    READE     SDVCRSNL1                                                MD040876
     C                   ENDDO                                                              MD040876
     C                   ENDIF                                                              MD040876
 
      ** Send message to system operator
 
     C                   MOVEL     DBerrUpd      DBError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
     C                   READ      SDVNAHLD0                              99
     C                   ENDDO
 
      ** Unlock allocation data area
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    RETURN
 
     C                   ENDIF
 
      ** End loop for data queue prompt
 
     C                   ENDDO
 
      ** Exit from program
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Define key list for SDVNAHLL1
 
     C     @KeyNahoL1    KLIST
     C                   KFLD                    @CuNaho
     C                   KFLD                    @Timestamp
                                                                                              CGL157
     C     WKeyNahoL1    KLIST                                                                CGL157
     C                   KFLD                    @CuNaho                                      CGL157
     C                   KFLD                    WTimestamp                                   CGL157
 
      ** Check if an existing DBU_NAHL job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    RETURN2
 
      ** Lock allocation data area
 
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **   of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
 
      **                        Submitter             Controller
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
 
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
 
      **  Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    RETURN
 
      ** Create required QTEMP objects
 
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde
                                                                                           AR1043440
      ** Check if CGL031 is installed                                                      AR1043440
                                                                                           AR1043440
     C                   EVAL      CGL031 = 'N'                                            AR1043440
                                                                                           AR1043440
     C                   CALLB     'AOSARDR0'                                              AR1043440
     C                   PARM      *BLANKS       PRtCd                                     AR1043440
     C                   PARM      '*VERIFY'     POptn                                     AR1043440
     C                   PARM      'CGL031'      PSard                                     AR1043440
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1043440
                                                                                           AR1043440
      ** Database error                                                                    AR1043440
                                                                                           AR1043440
     C                   IF        (PRtCd <> *BLANKS) and                                  AR1043440
     C                             (PRtCd <> '*NRF   ')                                    AR1043440
     C                   EVAL      DBKEY = 'CGL031'                                        AR1043440
     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR1043440
     C                   EVAL      DBASE = 001                                             AR1043440
     C                   EXSR      SRERR                                                   AR1043440
     C                   ENDIF                                                             AR1043440
                                                                                           AR1043440
     C                   IF        PRtCd = *BLANKS                                         AR1043440
     C                   EVAL      CGL031 = 'Y'                                            AR1043440
     C                   ENDIF                                                             AR1043440
                                                                                           AR1043440
      ** Check if CGL032 is installed                                                      AR1043440
                                                                                           AR1043440
     C                   EVAL      CGL032 = 'N'                                            AR1043440
                                                                                           AR1043440
     C                   CALLB     'AOSARDR0'                                              AR1043440
     C                   PARM      *BLANKS       PRtCd                                     AR1043440
     C                   PARM      '*VERIFY'     POptn                                     AR1043440
     C                   PARM      'CGL032'      PSard                                     AR1043440
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1043440
                                                                                           AR1043440
      ** Database error                                                                    AR1043440
                                                                                           AR1043440
     C                   IF        (PRtCd <> *BLANKS) and                                  AR1043440
     C                             (PRtCd <> '*NRF   ')                                    AR1043440
     C                   EVAL      DBKEY = 'CGL032'                                        AR1043440
     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR1043440
     C                   EVAL      DBASE = 002                                             AR1043440
     C                   EXSR      SRERR                                                   AR1043440
     C                   ENDIF                                                             AR1043440
                                                                                           AR1043440
     C                   IF        PRtCd = *BLANKS                                         AR1043440
     C                   EVAL      CGL032 = 'Y'                                            AR1043440
     C                   ENDIF                                                             AR1043440
 
                                                                                              CGL132
      ** Access SAR details file to determine if CGL132                                       CGL132
      ** FATCA Phase 1 is installed                                                           CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
     C                   PARM      'CGL132'      @SARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
      *                                                                                       CGL132
     C     @RTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Access SAR details file to determine if CGL157                                     MD040876
      ** CRS is installed                                                                   MD040876
                                                                                            MD040876
     C                   CALLB     'AOSARDR0'                                               MD040876
     C                   PARM      *BLANKS       @RTCD                                      MD040876
     C                   PARM      '*VERIFY'     @OPTN                                      MD040876
     C                   PARM      'CGL157'      @SARD                                      MD040876
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD040876
      *                                                                                     MD040876
     C     @RTCD         IFEQ      *BLANK                                                   MD040876
     C                   MOVEL     'Y'           CGL157                                     MD040876
     C                   ELSE                                                               MD040876
     C                   MOVEL     'N'           CGL157                                     MD040876
     C                   ENDIF                                                              MD040876
                                                                                            MD040876
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception errors                                     *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDNAHLUPD'   Dbpgm
     C                   MOVE      '1'           *InU7
     C                   MOVE      '1'           *InU8
     C                   MOVE      '1'           *InLR
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2004
** ##OV1
OVRDBF FILE(SDNAHOL0) TOFILE(SDNAHOL0) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDNAHOL0)
** ##OV3
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)
** ##OV4
DLTOVR FILE(SDFTNHL0)
