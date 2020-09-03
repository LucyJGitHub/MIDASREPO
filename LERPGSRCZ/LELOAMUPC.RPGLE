     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments dbase update controller')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMUPC - LE Loan Amendment controller                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1054921          Date 10Jun13               *
      *                 AR868380           Date 10Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE034             Date 01Dec03               *
      *                 222373             Date 29Oct03               *
      *                 201589             Date 03Jan02               *
      *                 CLE030             Date 03Oct02               *
      *                 CAP075  *CREATE    Date 22Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1054921 - Corrected the error handling introduced by       *
      *             AR868380. (Child: AR1054924)                      *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  222373 - Parameter Mismatch                                  *
      *  201589 - Change to check a new locking dataarea LECLIPLCK    *
      *           to determine whether this DBU is already active.    *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP075 - Lending API enhancements - Loan Amendments          *
      *                                                               *
      *****************************************************************
 
      * Valid loan amendments in file format
     FLEVLOAMPD UF   E             DISK
     F                                     COMMIT
     FLEVLOAML1 UF   E           K DISK
     F                                     RENAME(LEVLOAMD0:LEVLOAMD1)
 
      * Valid loan amendments in error from update routine
     FLEVELOAMPDO    E             DISK
     F                                     RENAME(LEVLOAMD0:LEVLOAMERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELOAMC001
 
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **-----------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **-----------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in LOAM API update')
 
      *****************************************************************
 
      **  DS for valid loan amendment
     D V_LOAM        E DS                  EXTNAME(LEVLOAMPD)
 
      ** Customer lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ***  Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
     D LELOAMUPC       DS             1    DTAARA(LELOAMUPC)
 
      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * 24X7 Data Area Structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      * SDSTAT Data Area Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D Object          S             10A   INZ('LELOAMUPC')
     D LockObj         S             10A   INZ('LELOAMLCK')
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
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APLOAMDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LELOAMC002
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,LELOAMC003
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APLOAMDTQ'
 
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
 
 
      /COPY WNCPYSRC,LELOAMC004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     LEVLOAMPD
 
      ** Read valid loan amendment
     C                   READ      LEVLOAMD0                              99    *
     C                   DOW       *IN99 = *OFF
 
      /COPY WNCPYSRC,LELOAMC005
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information
     C                   EVAL      ARFOTranID = LAFRNT
     C                   EVAL      ARFOAsocID = LAAFRT
     C                   EVAL      ARRprLocn  = LAREPA
     C                   EVAL      @Timestamp = LATMST
 
      /COPY WNCPYSRC,LELOAMC006
 
      ** LE Database update
     C                   CALLB     'LELOAMUPD'
 
      ** Return Code
     C                   PARM      *BLANK        @@RTCD            7
      ** Action requested                                                                     222373
     C                   PARM      LACHTP        DDACTN            1                          222373
 
      ** Externally described DS for valid loan Amendment
     C                   PARM                    V_LOAM
      * Calling module code                                                                   222373
     C                   PARM      'UPC'         CallModCod        3                          222373
 
      ** Parameter to allow LELOAMVU to pass reservation Id direct
      ** to updater
     C                   PARM                    ReservID         10
 
      * Features
     C                   PARM                    CDE001
     C                   PARM                    CDE005
     C                   PARM                    CEU004
     C                   PARM                    CEU020
     C                   PARM                    CLE002
     C                   PARM                    CLE005
     C                   PARM                    CLE009
     C                   PARM                    CLE014
     C                   PARM                    CLE023
     C                   PARM                    CLE030                                       CLE030
 
      * Authorise amends / authorise principal tfr / consolidated conf.
     C                   PARM                    BPLMAU
     C                   PARM                    BPTPAU
     C                   PARM                    BPCONR
 
      ** Date Format Indicator, Local Currency & Run day number
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    WRNDAY
      ** Multi-branching                                                                 222373
     C                   PARM                    BGMBIN                                  222373
                                                                                         222373
      * Which system is active (24x7)                                                    222373
     C                   PARM                    System            1                     222373
 
      * Commit updates if no error (if error, roll back issued in DBERRCTL)
     C**********         IF        @@RTCD <> '*ERROR ' OR                                  AR1054921
     C                   IF        @@RTCD <> '*ERROR ' AND                                 AR1054921
     C                             @@RTCD <> '*RECUPD'
     C**********                   OR @@RTCD <> '*RECLCK'                         AR868380 AR1054921
     C                             AND @@RTCD <> '*RECLCK'                                 AR1054921
     C                   DELETE    LEVLOAMD0
     C                   COMMIT
     C                   ENDIF
 
      /COPY WNCPYSRC,LELOAMC007
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C                   IF        @@RTCD = '*ERROR ' OR
     C                             @@RTCD = '*RECUPD'
     C                             OR @@RTCD = '*RECLCK'                                    AR868380
     C                   EVAL      @LoanRef = LALNRF
     C                   EVAL      @Timestamp = LATMST
     C     @KeyLOAML1    CHAIN     LEVLOAML1                          89
 
     ** Write details of record to error file (same format as LEVLOAMPD)
     C                   WRITE     LEVLOAMERR
     C                   DELETE    LEVLOAMD1
 
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Read valid loan amendment
     C                   READ      LEVLOAMD0                              99    *
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
 
      /COPY WNCPYSRC,LELOAMC008
 
      * Exit from Program
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELOAMC009
 
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
 
      ** Determine if CDE001 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDE001            1
     C                   ELSE
     C                   MOVEL     'N'           CDE001
     C                   ENDIF
 
      ** Determine if CDE002 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDE002            1
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   ENDIF
 
      ** Determine if CDE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDE005            1
     C                   ELSE
     C                   MOVEL     'N'           CDE005
     C                   ENDIF
 
      ** Determine if CEU004 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU004            1
     C                   ELSE
     C                   MOVEL     'N'           CEU004
     C                   END
 
      ** Determine if CEU020 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU020            1
     C                   ELSE
     C                   MOVEL     'N'           CEU020
     C                   END
 
      ** Determine if CLE002 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE002            1
     C                   ELSE
     C                   MOVEL     'N'           CLE002
     C                   END
 
      ** Determine if CLE003 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE003            1
     C                   ELSE
     C                   MOVEL     'N'           CLE003
     C                   END
 
      ** Determine if CLE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE005            1
     C                   ELSE
     C                   MOVEL     'N'           CLE005
     C                   ENDIF
 
      ** Determine if CLE009 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE009            1
     C                   ELSE
     C                   MOVEL     'N'           CLE009
     C                   ENDIF
 
      ** Determine if CLE014 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE014            1
     C                   ELSE
     C                   MOVEL     'N'           CLE014
     C                   END
 
      ** Determine if CLE023 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE023            1
     C                   ELSE
     C                   MOVEL     'N'           CLE023
     C                   END
                                                                                              CLE030
      ** Determine if CLE030 is switched on                                                   CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD                                        CLE030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE030
     C                   IF        @RTCD = *BLANK                                             CLE030
     C                   MOVEL     'Y'           CLE030            1                          CLE030
     C                   ELSE                                                                 CLE030
     C                   MOVEL     'N'           CLE030                                       CLE030
     C                   END                                                                  CLE030
 
      ** Determine if CSC011 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSC011            1
     C                   ELSE
     C                   MOVEL     'N'           CSC011
     C                   END
 
      ** Access bank details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM                    DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Customer lending ICD
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDCLND        PARM                    DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Midas Module details
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM                    DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If CSC011 is installed and in switchover mode, use
      * S1DATE from DTAARA/SC24x7 as the rundate.
     C                   IN        SC24X7
     C                   IN        SDSTAT
      *
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   Z-ADD     S1DATE        WRNDAY            5 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   MOVE      'S'           System            1                          222373
     C                   ENDIF
 
      ** Initialise program name
     C                   MOVEL     'LELOAMUPC'   DBPGM
 
      *  Define key list for LEVLOAML1
     C     @KeyLOAML1    KLIST
     C**********         KFLD                    @LoanRef          6 0                        CLE148
     C                   KFLD                    @LoanRef          6                          CLE148
     C                   KFLD                    @ValueDate        5 0
     C                   KFLD                    @Sequence         3 0
     C                   KFLD                    @AmendType        2
                                                                                              201589
      *  Check if an existing DBU_LOAM job is active in the subsystem.                        201589
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
      /COPY WNCPYSRC,LELOAMC010
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
