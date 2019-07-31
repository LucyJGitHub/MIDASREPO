     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE item DB update controller')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITPUPC - Journal Batch Entry Items Database Update        *
      *              Controller                                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23742           Date 09May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 28Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 CSC024             Date 07Feb05               *
      *                 CMM121             Date 29Jun04               *
      *                 TCA102             Date 02Apr04               *
      *                 CRE019             Date 12Jan04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSC024 - Open Month End                                      *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:GLBITPU002,GLBITPU007            *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  201589 - Change to check a new locking dataarea GLBITPLCK    *
      *           to determine whether this DBU is already active.    *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** Valid JE Items file
     FGLVBITPPD UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid JE Items file by Front Office Id and Timestamp
     FGLVBITPL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLVBITPD0:GLVBITPD1)
      *
      ** Valid JE Items in Error file
     FGLVEBITPPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLVBITPD0:GLVBITPERR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLBITPU001
     FGLVBPLX1L0UF   E           K DISK    USROPN                                             CER001
      ** Midas GL BITP - Valid File - LU Window                                               CER001
      *                                                                                       CER001
     F                                     COMMIT                                             CER001
     FGLVEBPX1PDO    E             DISK    USROPN                                             CER001
      ** Midas GL BITP - Deal in Error from DBU - LU Window                                   CER001
      *                                                                                       CER001
     F                                     RENAME(GLVBPLXDL:GLVBPLXDLR)                       CER001
      *                                                                                       246418
      ** Valid JE Items Additional Information                                                246418
     FGLVBIPXL1 UF   E           K DISK    INFSR(*PSSR)                                       246418
      *
      ** Midas Valid Journal Batch Entry Items Additional Inf                               BUG23742
      *                                                                                     BUG23742
     FGLVMNARL0 UF   E           K DISK    INFSR(*PSSR)                                     BUG23742
      *                                                                                     BUG23742
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D WDBerrUpd       C                   CONST('DB error in JE API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
     D GLBITPUPC       DS             1
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     D PVBITPX       E DS                  EXTNAME(GLVBIPXPD)                                 246418
      *                                                                                     BUG23742
      ** Valid Journal Batch Entry Items Additional Inf                                     BUG23742
      *                                                                                     BUG23742
     D GLVMNAR       E DS                  EXTNAME(GLVMNARPD)                               BUG23742
      *                                                                                     BUG23742
     D GLMNARR         DS           770                                                     BUG23742
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PObject         S             10A   INZ('GLBITPUPC')
     D PLockObj        S             10A   INZ('GLBITPLCK')                                   201589
     D PLib            S             10A   INZ('*LIBL')
     D PObjtype        S              7A   INZ('*DTAARA')
     D PLockStateE     S              7A   INZ('*EXCL')
     D PLockStateS     S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('*CLS')
     D PDlcobj         S              1A
     D PReturn         S              7A
     D PReturn2        S              7A                                                      201589
     D PEndjob         S              1A   INZ('Y')                                           201589
      *
     D WTimestamp      S             26Z
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
      *
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *                                                                                       246418
      ** Switchable feature CGL013                                                            246418
     D CGL013          S              1                                                       246418
      *                                                                                       246418
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLBITPU002
      ** New valid extended GL Journal entry interface file for IBLC 2002                     CER001
     D GLVBPLXL      E DS                  EXTNAME(GLVBPLX1L0)                                CER001
     D GLVBPLXLS     E DS                  EXTNAME(GLVBPLX1L0)                                CER001
     D                                     PREFIX(SS)                                         CER001
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,GLBITPU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APBITPDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise data queue parameters.
      *
     C                   EVAL      PDtqLen = 10
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'APBITPDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Wait for data queue prompt.
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file.
      *
     C     PDtqDta       DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam          10
     C                   PARM                    PDtqLib          10
     C                   PARM                    PDtqLen           5 0
     C                   PARM                    PDtqDta          10
     C                   PARM                    PDtqWait          5 0
      *
     C     PDtqDta       IFEQ      'GO'
      *
      ** Lock allocation data area.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      /COPY WNCPYSRC,GLBITPU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
      *
     C     1             SETLL     GLVBITPPD
      *
      ** Read valid JE Item record.
      *
     C                   READ      GLVBITPD0                              01
      *
     C     *IN01         DOWEQ     *OFF
      *
      /COPY WNCPYSRC,GLBITPU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = B2FRNT
     C                   EVAL      ARFOAsocID = B2AFRT
      *
      /COPY WNCPYSRC,GLBITPU006
     C     CGL013        IFEQ      'Y'                                                        246418
     C                   EVAL      KBTNBX = B2BTNB                                            246418
     C                   EVAL      KBINBX = B2BINB                                            246418
     C     KBITPX        CHAIN     GLVBIPXL1                          90                      246418
     C                   ENDIF                                                                246418
      *                                                                                     BUG23742
     C     CER030        IFEQ      'Y'                                                      BUG23742
     C                   EVAL      KBTNBX = B2BTNB                                          BUG23742
     C                   EVAL      KBINBX = B2BINB                                          BUG23742
     C     KBITPX        CHAIN     GLVMNARL0                          91                    BUG23742
      *                                                                                     BUG23742
     C                   IF        *IN91 = *OFF                                             BUG23742
     C                   EVAL      GLMNARR =  %SUBST(GLVMNAR:9)                             BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *
      ** Update JE Items file.
      *
     C                   CALLB     'GLBITPUPD'
      *                             =========
      ** Return code
     C                   PARM                    PRTCD             7
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Security on Journal Entry
     C                   PARM                    CGL008
      *                                                                                       CRE019
      ** Cheque processing and maintenance                                                    CRE019
     C                   PARM                    CRE019                                       CRE019
      *                                                                                       246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013                                       246418
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
                                                                                              246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     C                   PARM                    PVBITPX                                      246418
      *                                                                                     BUG23742
     C                   PARM                    GLMNARR                                    BUG23742
                                                                                              CSC024
      ** Action Code for OME system                                                           CSC024
     C                   PARM                    PActnCde          1                          CSC024
                                                                                              CSC024
      *
      /COPY WNCPYSRC,GLBITPU007
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,GLBITPU008
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *blank
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError         28
     C                   MOVEL     WMQError      PMQErrLong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PMQErrLong      132
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   ROLBK
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLBITPU009
      ** Perform IBLC 2002 Treatment if Required                                              CER001
      *                                                                                       CER001
     C     ULX607        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
     C     PRTCD         ANDEQ     *BLANKS                                                    CER001
      *                                                                                       CER001
     C                   CLEAR                   GLVBPLXL                                     CER001
     C                   CLEAR                   GLVBPLXLS                                    CER001
      *                                                                                       CER001
     C     KKEY1         CHAIN     GLVBPLX1L0                         89                      CER001
      *                                                                                       CER001
      ** Setup parameter to call GLBPLX2UP                                                    CER001
      *                                                                                       CER001
     C                   MOVE(P)   B2BTNB        #LLXJEBTNB                                   CER001
     C                   Z-ADD     B2BINB        #LLXJEBINB                                   CER001
      *                                                                                       CER001
      ** GL Extended database update                                                          CER001
      *                                                                                       CER001
     C                   CALLB     'GLBPLX2UP'                                                CER001
     C                   PARM                    ActionCode                                   CER001
     C                   PARM      *BLANK        PRTCD                                        CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    GLVBPLXL                                     CER001
     C                   PARM                    GLVBPLXLS                                    CER001
      *                                                                                       CER001
      ** Delete Record from Valid File                                                        CER001
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANK                                                     CER001
     C                   DELETE    GLVBPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
      ** Commit updates if no error.
      *
     C     PRTCD         IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
     C                   DELETE    GLVBITPD0
      *                                                                                     BUG23742
     C                   IF        CER030 = 'Y'                                             BUG23742
      *                                                                                     BUG23742
     C                   IF        *IN91 = *OFF                                             BUG23742
     C                   DELETE    GLVMNARD0                                                BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   COMMIT
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLBITPU010
     C     ULX607        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     PRTCD         IFEQ      '*ERROR '                                                  CER001
     C     PRTCD         OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
      ** Write Record Details in Error Valid File and Remove it from File                     CER001
      *                                                                                       CER001
     C                   WRITE     GLVBPLXDLR                                                 CER001
     C                   DELETE    GLVBPLXDL                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
      *
     C     PRTCD         IFEQ      '*ERROR '
      *
     C     KBITPL1       CHAIN     GLVBITPL1                          02
      *
      ** Write details of record to error file (same format as GLVBITPPD).
      *
     C                   WRITE     GLVBITPERR
     C                   DELETE    GLVBITPD1
      *                                                                                     BUG23742
     C                   IF        CER030 = 'Y'                                             BUG23742
      *                                                                                     BUG23742
     C                   IF        *IN91 = *OFF                                             BUG23742
     C                   DELETE    GLVMNARD0                                                BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *
      ** Send message to system operator.
      *
     C                   MOVEL     WDBerrUpd     PDBError         28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn       10
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
     C                   ENDIF
      *
     C                   EVAL      PRTCD = *BLANKS
      *
      ** Read valid JE Item record.
      *
     C                   READ      GLVBITPD0                              01
     C                   ENDDO
      *
      ** Unlock allocation data area.
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PReturn
      *
     C                   ENDIF
      *
      ** End loop for data queue prompt.
      *
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLBITPU011
      *
      ** Exit from program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLBITPU012
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define data area used to check if DB update running.
      *
     C     *DTAARA       DEFINE                  GLBITPUPC
      *
      ** Define key list for GLVBITPL1.
      *
     C     KBITPL1       KLIST
     C                   KFLD                    B2FRNT
     C                   KFLD                    B2TMST
      *                                                                                       246418
     C     KBITPX        KLIST                                                                246418
     C                   KFLD                    KBTNBX            3                          246418
     C                   KFLD                    KBINBX            3 0                        246418
      *
      *  Check if an existing DBU_BITP job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    PLockObj                                     201589
     C                   PARM                    PLib                                         201589
     C                   PARM                    PObjType                                     201589
     C                   PARM                    PLockStateE                                  201589
     C                   PARM                    PMember                                      201589
     C                   PARM                    PEndjob                                      201589
     C                   PARM                    PReturn2                                     201589
                                                                                              201589
      **  Lock allocation data area.
      *
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **  of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
      **
      **                        Submitter             Controller
      **
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
      **  Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateS
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      ** Create required QTEMP objects.
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PReturnCde       10
      *
      ** Access SAR file to determine if CGL008 (Security on Journal
      ** Entry) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL008'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL008'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   ENDIF
      *                                                                                       CRE019
      ** Access SAR file to determine if Cheque book processing is installed                  CRE019
      *                                                                                       CRE019
     C                   CALLB     'AOSARDR0'                                                 CRE019
     C                   PARM      *BLANKS       PRTCD                                        CRE019
     C                   PARM      '*VERIFY'     POPTN                                        CRE019
     C                   PARM      'CRE019'      PSARD                                        CRE019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE019
      *                                                                                       CRE019
      ** An NRF (No Record Found) return code is valid.  Issue database error                 CRE019
      ** only for error return codes.                                                         CRE019
      *                                                                                       CRE019
     C     PRTCD         IFNE      *BLANKS                                                    CRE019
     C     PRTCD         ANDNE     '*NRF   '                                                  CRE019
     C                   MOVEL     'CRE019'      DBKEY                                        CRE019
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE019
     C                   Z-ADD     2             DBASE                                        CRE019
     C                   EXSR      *PSSR                                                      CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       CRE019
     C                   MOVE      'N'           CRE019                                       CRE019
     C     PRTCD         IFEQ      *BLANK                                                     CRE019
     C                   MOVE      'Y'           CRE019            1                          CRE019
     C                   ENDIF                                                                CRE019
      *                                                                                       246418
      ** Access SAR details file to determine if MT94x Messages Generation                    246418
      ** processing is switched ON                                                            246418
      *                                                                                       246418
     C                   EVAL      CGL013 = 'N'                                               246418
     C                   CALLB     'AOSARDR0'                                                 246418
     C                   PARM      *BLANKS       PRTCD                                        246418
     C                   PARM      '*VERIFY'     POPTN                                        246418
     C                   PARM      'CGL013'      PSARD                                        246418
     C     SCSARD        PARM      SCSARD        DSFDY                                        246418
      *                                                                                       246418
      ** An NRF (No Record Found) return code is valid. Issue database                        246418
      ** error only for error return codes.                                                   246418
      *                                                                                       246418
     C                   IF        PRTCD <> *BLANKS AND                                       246418
     C                             PRTCD <> '*NRF   '                                         246418
     C                   EVAL      DBKEY = 'CGL013'                                           246418
     C                   EVAL      DBFILE = 'SCSARDPD'                                        246418
     C                   EVAL      DBASE = 011                                                246418
     C                   EXSR      *PSSR                                                      246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   IF        PRTCD = *BLANK                                             246418
     C                   EVAL      CGL013 = 'Y'                                               246418
     C                   ENDIF                                                                246418
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLBITPU013
     C                   MOVEL     'N'           ULX607            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX607'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   EVAL      PRTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX607                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBKEY  = 'ULX607'                                          CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE  = 3                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ***  ULX043 - New IBLC 2002 as Feature                                                  CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE  = 4                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX607        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
     C                   OPEN      GLVBPLX1L0                                                 CER001
     C                   OPEN      GLVEBPX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                     BUG23742
      ** Check if the Feature is installed                                                  BUG23742
      *                                                                                     BUG23742
     C                   CALL      'AOSARDR0'                                               BUG23742
     C                   PARM      *BLANKS       PRTCD                                      BUG23742
     C                   PARM      '*VERIFY'     POPTN                                      BUG23742
     C                   PARM      'CER030'      PSARD                                      BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
     C     PRTCD         IFNE      *BLANKS                                                  BUG23742
     C     PRTCD         ANDNE     '*NRF   '                                                BUG23742
     C                   MOVEL     'CER030'      DBKEY                                      BUG23742
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG23742
     C                   Z-ADD     012           DBASE                                      BUG23742
     C                   EXSR      *PSSR                                                    BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C     PRTCD         IFEQ      *BLANK                                                   BUG23742
     C                   MOVE      'Y'           CER030            1                        BUG23742
     C                   ELSE                                                               BUG23742
     C                   MOVE      'N'           CER030                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CER001
      ** Klist to access GLVBPLX1L0                                                           CER001
      *                                                                                       CER001
     C     KKEY1         KLIST                                                                CER001
     C                   KFLD                    B2FRNT                                       CER001
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
