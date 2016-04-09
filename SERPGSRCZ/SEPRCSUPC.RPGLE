     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')                         CAP060
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Market prices database updat controller')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  SEPRCSUPC - SE Market Price Database Update Controller       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL031             Date 05Jul04               *
      *                 BUG2812            Date 01Jun04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189506             Date 22Feb01               *
      *                 CAP060             Date 22Nov00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CAP030  *CREATE    Date 02Mar99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income                          *
      *  BUG2812 - Commitment Control Changes for MidasPlus (CSC022)  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *           (Recompile)                                         *
      *  201589 - Change to check a new locking dataarea SEPRCSLCK    *
      *           to determine whether this DBU is already active.    *
      *  189506 - Securities Prices API could not update extel        *
      *           (Recompile)                                         *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *  CAP030 - API for SE Price input                              *
      *                                                               *
      *****************************************************************
     FSEVPRCSPD UF   E             DISK
     F                                     COMMIT
     FSEVPRXTL1 UF   E           K DISK
     F                                     COMMIT
     FSEVEXVLL1 UF   E           K DISK                                                       CAP060
     F                                     COMMIT                                             CAP060
     FSEVPRCSL1 UF   E           K DISK
     F                                     RENAME(SEVPRCSD0:SEVPRCSD1)
     FSEVEPRCSPDO    E             DISK
     F                                     RENAME(SEVPRCSD0:SEVPRCSERR)
 
     FSEVEEXVLPDO    E             DISK                                                       CAP060
     F                                     RENAME(SEVEXVLD0:SEVEXVLERR)                       CAP060
 
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
                                                                                             BUG2812
     D WCmtJobArr      S             10A   DIM(10)                                           BUG2812
      ** Array for commitment job names                                                      BUG2812
                                                                                             BUG2812
     D DBerrUpd        C                   CONST('DB error in Prices update')
 
      *****************************************************************
 
      ** Externally described data structure for valid Price record
     D SEVPRC        E DS                  EXTNAME(SEVPRCSPD)
 
      ** Externally described data structure for valid Extra Data Price Rcd
     D SEVPRX        E DS                  EXTNAME(SEVPRXTPD)
 
     D SEVEXVL       E DS                  EXTNAME(SEVEXVLPD)                                 CAP060
      ** New Extel Details in file format                                                     CAP060
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                             BUG2812
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2812
     D  ComitJob               4    103                                                      BUG2812
      ** Midas SC Jobs handling commitment control data area                                 BUG2812
 
     D SEPRCSUPC       DS             1
 
     D Object          S             10A   INZ('SEPRCSUPC')
     D LockObj         S             10A   INZ('SEPRCSLCK')                                   201589
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
                                                                                              CGL031
     D PRTCD           S              7A                                                      CGL031
     D POPTN           S              7A                                                      CGL031
     D PSARD           S              6A                                                      CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                             BUG2812
     D CSC022          S              1A                                                     BUG2812
                                                                                             BUG2812
     D WCommitSkip     S              1A                                                     BUG2812
      ** Commitment Skip Field                                                               BUG2812
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,SEPRCSU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APPRCSDTQ'                       CAP006
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
     C                   EVAL      DtqNam = 'APPRCSDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid Prices file
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
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems                         CAP060
      ** caused by earlier errors.                                                            CAP060
     C                   CLEAR                   *inu7                                        CAP060
     C                   CLEAR                   *inu8                                        CAP060
 
      /COPY WNCPYSRC,SEPRCSU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SEVPRCSPD
 
      ***Read*valid*forward*rates*record**********************                                CAP060
      ** Read valid Price record                                                              CAP060
     C                   READ      SEVPRCSD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,SEPRCSU003
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   IF        CAP060F= 'N'                                               CAP060
     C                   EVAL      ARFOTranID = PRPSSN
     C                   ELSE                                                                 CAP060
     C                   EVAL      ARFOTranID = PRFRNT                                        CAP060
     C                   EVAL      ARFOAsocID = PRAFRT                                        CAP060
     C                   EVAL      ARRprLocn  = PRREPA                                        CAP060
     C                   EVAL      @Timestamp = PRTMESTMP                                     CAP060
     C                   ENDIF                                                                CAP060
 
      /COPY WNCPYSRC,SEPRCSU004
 
      *
      ** Access to the Extra Data Price Details record
      *
     C                   IF        CAP060F= 'N'                                               CAP060
     C                   EVAL      @Secshnam = PRPSSN
     C                   EVAL      @valuedat = PRPVDT
     C                   EVAL      @Timestamp = PRTMESTMP
     C     @KPRXL1       CHAIN     SEVPRXTL1                          88
     C                   ENDIF                                                                CAP060
 
     C                   IF        CAP060F= 'Y'                                               CAP060
     C                   EVAL      @Secshnam = PRPSSN                                         CAP060
     C                   EVAL      @Timestamp = PRTMESTMP                                     CAP060
     C     @KPEXL1       CHAIN     SEVEXVLL1                          90                      CAP060
     C                   ENDIF                                                                CAP060
 
     C     *IN88         IFEQ      '0'
 
      ** SE DATABASE UPDATE
     C                   CALLB     'SEPRCSUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    SEVPRC
     C                   PARM                    SEVEXVL                                      CAP060
     C                   PARM                    SEVPRX
     C                   PARM                    CAC005
     C                   PARM                    CGL031                                       CGL031
 
      /COPY WNCPYSRC,SEPRCSU005
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                                  CAP060
      *                                                                                      BUG2812
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2812
     C                   ROLBK
     C                   EndIf                                                               BUG2812
     C                   ELSE
     C                   DELETE    SEVPRCSD0
     C     *IN88         IFEQ      '0'
     C     CAP060F       ANDEQ     'N'                                                        CAP060
     C                   DELETE    SEVPRXTD0
     C                   ENDIF
     C     CAP060F       IFEQ      'Y'                                                        CAP060
     C     *IN90         ANDEQ     '0'                                                        CAP060
     C                   DELETE    SEVEXVLD0                                                  CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                      BUG2812
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2812
     C                   COMMIT
     C                   EndIf                                                               BUG2812
     C                   END
 
      /COPY WNCPYSRC,SEPRCSU006
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                                  CAP060
     C                   EVAL      @Secshnam = PRPSSN
     C                   EVAL      @Pricetyp = PRPPRT
     C                   EVAL      @Valuedat = PRPVDT
     C                   EVAL      @Timestamp = PRTMESTMP
     C     @KPRCL1       CHAIN     SEVPRCSL1                          89
     ** Write details of record to error file (same format as SEVPRCSPD)
     C                   WRITE     SEVPRCSERR
     C                   DELETE    SEVPRCSD1
     C     *IN88         IFEQ      '0'
     C     CAP060F       ANDEQ     'N'                                                        CAP060
     C                   DELETE    SEVPRXTD0
     C                   ENDIF
     C     *IN90         IFEQ      '0'                                                        CAP060
     C     CAP060F       ANDEQ     'Y'                                                        CAP060
     C     @KPEXL1       CHAIN     SEVEXVLL1                                                  CAP060
     C                   IF        %FOUND                                                     CAP060
     C                   WRITE     SEVEXVLERR                                                 CAP060
     C                   DELETE    SEVEXVLD0                                                  CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Read valid securities prices record
     C                   READ      SEVPRCSD0                              99    *
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
 
      /COPY WNCPYSRC,SEPRCSU007
 
      * EXIT FROM PROGRAM
     C                   RETURN
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
 
      *  Define data area used to check if DB update running
     C     *DTAARA       DEFINE                  SEPRCSUPC
 
      *  Define key list for SEPRCSLL1
     C     @KPRCL1       KLIST
     C                   KFLD                    @Secshnam        10
     C                   KFLD                    @Pricetyp         2
     C                   KFLD                    @Valuedat         5 0
     C                   KFLD                    @Timestamp
 
      *  Define key list for SEVPRXTL1
     C     @KPRXL1       KLIST
     C                   KFLD                    @Secshnam
     C                   KFLD                    @Valuedat
     C                   KFLD                    @Timestamp
      *  Define key list for SEVEXVLL1                                                        CAP060
     C     @KPEXL1       KLIST                                                                CAP060
     C                   KFLD                    @Secshnam                                    CAP060
     C                   KFLD                    @Timestamp                                   CAP060
 
      *  Check if an existing DBU_PRCS job is active in the subsystem.                        201589
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
      *
      ** Access SAR details file to determine if CAC005
      ** (Profit Centre Accounting) is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CAC005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAC005            1
     C                   ELSE
     C                   MOVEL     'N'           CAC005
     C                   END
      *                                                                                       CAP060
      ** Access SAR details file to determine if CAP060 on                                    CAP060
      *                                                                                       CAP060
     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD             7                          CAP060
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
      *                                                                                       CAP060
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060F           1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060F                                      CAP060
     C                   END                                                                  CAP060
 
      *                                                                                      BUG2812
      ** Access Switchable Features File, for CSC022                                         BUG2812
      *                                                                                      BUG2812
     C                   Eval      CSC022 = 'N'                                              BUG2812
     C                   CallB     'AOSARDR0'                                                BUG2812
     C                   Parm      *BLANKS       @RTCD                                       BUG2812
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2812
     C                   Parm      'CSC022'      @SARD                                       BUG2812
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD = *Blanks                                           BUG2812
     C                   Eval      CSC022 = 'Y'                                              BUG2812
     C                   Eval      WCommitSkip = 'N'                                         BUG2812
      *                                                                                      BUG2812
     C                   In        SCCMTJOB                                                  BUG2812
     C                   If        ComitNum > 0                                              BUG2812
     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2812
      *                                                                                      BUG2812
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2812
     C                   If        *IN87 = *ON                                               BUG2812
     C                   Eval      WCommitSkip = 'Y'                                         BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
     C                   Else                                                                BUG2812
      *                                                                                      BUG2812
      ** If return code <> *NRF, call program exception error routine                        BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD <> '*NRF'                                           BUG2812
     C     *LOCK         IN        LDA                                                       BUG2812
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2812
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2812
     C                   EVAL      DBASE = 1                                                 BUG2812
     C                   OUT       LDA                                                       BUG2812
     C                   Exsr      *PSSR                                                     BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
      *                                                                                       CGL031
     C     PRTCD         IFEQ      *BLANK                                                     CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
      *                                                                                       CGL031
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
      /EJECT
