     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Historic Market Data Housekeeping')           *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS000021 - Midas AS Historic Market Data Housekeeping        *
      *                                                               *
      *  Function:  This module maintains the Historic Market Data    *
      *             files ASDLHMPD, ASLEHMPD and ASSEHMPD. Records    *
      *             with older value dates beyond data points plus    *
      *             one are dropped.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 228948             Date 27Sep04               *
      *                 CAS008             Date 11May04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  CAS008 - Delayed Hedge Assessment                            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FASHTRNPD  IF   E           K DISK
      ** Hedge Transactions File
 
     FASHGLKL1  IF   E           K DISK
      ** Hedge Linkages File
 
     FASDLHML1  UF   E           K DISK    INFSR(*PSSR)
      ** Dealing Historic Market Data File
 
     FASLEHML1  UF   E           K DISK    INFSR(*PSSR)
      ** Lending Historic Market Data File
 
     FASSEHML1  UF   E           K DISK    INFSR(*PSSR)
      ** Security Positions Historic Market Data File
 
     FUPLHXL2   UF   E           K DISK    INFSR(*PSSR)                                       CAS008
      ** Security Delayed Historic Data File                                                  CAS008
                                                                                              CAS008
     FIRSNHVPD  UF   E           K DISK    INFSR(*PSSR)                                       CAS008
     FRXSNHVPD  UF   E           K DISK    INFSR(*PSSR)                                       CAS008
     FFRANHVPD  UF   E           K DISK    INFSR(*PSSR)                                       CAS008
     FDLNHVLPD  UF   E           K DISK    INFSR(*PSSR)                                       CAS008
      ** DL Historic Dollar Offset Net Value Files                                            CAS008
                                                                                              CAS008
      *****************************************************************
      /EJECT
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
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D CAS008          S              1A                                                      CAS008
     D PRetCode        S              7A                                                      CAS008
     D POption         S              7A                                                      CAS008
     D PSard           S              6A                                                      CAS008
                                                                                              CAS008
      ** Work Variables                                                                       CAS008
     D WkEffd          S              5P 0                                                    CAS008
     D PzDayNo3        S              5  0                                                    CAS008
     D PzCCY3          S              3                                                       CAS008
     D PZLoc3          S              3                                                       CAS008
     D PZNRdys3        S              2  0                                                    CAS008
     D PZDyNbr3        S              5  0                                                    CAS008
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CAS008
                                                                                              CAS008
      ** External DS for Hedging ICD                                                          CAS008
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  CAS008
 
      ** First DS for access programs, short data structure                                   CAS008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS008
                                                                                              CAS008
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D WDataPt         S              4S 0 INZ(0)
     D WRecCnt         S              4S 0 INZ(0)
     D WDlydPt         S              4S 0 INZ(0)                                             CAS008
     D WDlyRec         S              4S 0 INZ(0)                                             CAS008
 
      ** Key Variables
     D KHEDI           S                   LIKE(FSHEDI)
     D KDLNO           S                   LIKE(FSDLNO)
     D KSESN           S                   LIKE(FSFPSE)
     D KBRCA           S                   LIKE(FSBRCA)
     D KBKCD           S                   LIKE(FSBKCD)
     D KMKTI           S                   LIKE(FSMKTI)
     D KBHTV           S                   LIKE(FSBHTV)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
                                                                                              CAS008
     IDLNHVLD0                                                                                CAS008
     I              FSDAMT                      DLDAMT                                        CAS008
     I              FSDLNO                      DLDLNO                                        CLE148
                                                                                              CAS008
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Read thru AS Hedge Transactions file to retrieve Hedge ID
      ** number and transaction details.
 
     C                   READ      ASHTRNPD
 
     C                   DOW       NOT %EOF(ASHTRNPD)
 
      ** Retrieve data points required for hedge assessment
 
     C     FSHEDI        CHAIN     ASHGLKL1
     C                   IF        %FOUND(ASHGLKL1)
     C                   Z-ADD     1             WDataPt
     C                   ADD       FSDPTS        WDataPt
     C                   Z-ADD     *ZERO         WRecCnt
     C                   Z-ADD     FSHEDI        KHEDI
 
      ** Determine which AS Historic Market data to maintain
 
     C                   SELECT
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SrProcDLHM
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SrProcLEHM
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SrProcSEHM
     C                   ENDSL
 
     C                   ELSE
 
      ** Process database error if chain fails
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   MOVE      FSHEDI        DBKEY
     C                   EVAL      DBFILE = 'ASHGLKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   READ      ASHTRNPD
     C                   ENDDO
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
      ** DL Derivatives                                                                       CAS008
     C                   EXSR      SrDlyNHVDL                                                 CAS008
      ** SE Hedged Items                                                                      CAS008
     C                   EXSR      SrDlyMHVSE                                                 CAS008
     C                   ENDIF                                                                CAS008
 
      ** End Program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrProcDLHM - Process maintenance of DL Historic Market Data   *
      *                                                               *
      *****************************************************************
     C     SrProcDLHM    BEGSR
 
     C**********         Z-ADD     FSDLNO        KDLNO                                        CLE148
     C                   MOVEL     FSDLNO        KDLNO                                        CLE148
     C     KDLMktDta     SETLL     ASDLHML1
     C     KDLMktDta     READE     ASDLHML1
 
     C                   DOW       NOT %EOF(ASDLHML1)
 
      ** If record count is more than the data point required, or
      ** record is no longer live, delete record.
 
     C                   IF        XXRECI = '*'
     C                   DELETE    ASDLHMD0
     C                   ELSE
     C                   ADD       1             WRecCnt
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             AND FSSECR = 'Y'                                           CAS008
     C                             AND FSNDDP <> 0                                            CAS008
     C                             AND WDataPt < WRecCnt                                      CAS008
     C                             AND FSLASD  < XXVDAT                                       CAS008
     C                   ADD       1             WDataPt                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        WDataPt < WRecCnt
     C                   DELETE    ASDLHMD0
     C                   ENDIF
     C                   ENDIF
 
     C     KDLMktDta     READE     ASDLHML1
     C                   ENDDO
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrProcLEHM - Process maintenance of LE Historic Market Data   *
      *                                                               *
      *****************************************************************
     C     SrProcLEHM    BEGSR
 
     C**********         Z-ADD     FSDLNO        KDLNO                                        CLE148
     C                   MOVEL     FSDLNO        KDLNO                                        CLE148
     C     KDLMktDta     SETLL     ASLEHML1
     C     KDLMktDta     READE     ASLEHML1
 
     C                   DOW       NOT %EOF(ASLEHML1)
 
      ** If record count is more than the data point required, or
      ** record is no longer live, delete record.
 
     C                   IF        XXRECI = '*'
     C                   DELETE    ASLEHMD0
     C                   ELSE
     C                   ADD       1             WRecCnt
     C                   IF        WDataPt < WRecCnt
     C                   DELETE    ASLEHMD0
     C                   ENDIF
     C                   ENDIF
 
     C     KDLMktDta     READE     ASLEHML1
     C                   ENDDO
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrProcSEHM - Process maintenance of SE Historic Market Data   *
      *                                                               *
      *****************************************************************
     C     SrProcSEHM    BEGSR
 
     C                   MOVE      FSFPSE        KSESN
     C                   MOVE      FSBRCA        KBRCA
     C                   MOVE      FSBKCD        KBKCD
     C                   MOVE      FSMKTI        KMKTI
     C                   MOVE      FSBHTV        KBHTV
 
     C     KSeMktDta     SETLL     ASSEHML1
     C     KSeMktDta     READE     ASSEHML1
 
     C                   DOW       NOT %EOF(ASSEHML1)
 
      ** If record count is more than the data point required, or
      ** record is no longer live, delete record.
 
     C                   IF        XXRECI = '*'
     C                   DELETE    ASSEHMD0
     C                   ELSE
     C                   ADD       1             WRecCnt
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             AND FSSECR = 'Y'                                           CAS008
     C                             AND FSNDDP <> 0                                            CAS008
     C                             AND WDataPt < WRecCnt                                      CAS008
     C                             AND FSLASD  < XXVDAT                                       CAS008
     C                   ADD       1             WDataPt                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        WDataPt < WRecCnt
     C                   DELETE    ASSEHMD0
                                                                                              CAS008
      ** Delete regression collected data in UPLHXD if record dropped in ASSEHMPD.            CAS008
                                                                                              CAS008
     C                   IF        CAS008 ='Y'                                                CAS008
     C     KSeDlyDta     CHAIN     UPLHXL2                            11                      CAS008
     C                   IF        *IN11 = '0'                                                CAS008
     C                   DELETE    UPLHXL2                                                    CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDIF
     C                   ENDIF
 
     C     KSeMktDta     READE     ASSEHML1
     C                   ENDDO
                                                                                              CAS008
      ** Delete Dollar Off-set method data in UPLHXD if effective date is already reached.    CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C     *LOVAL        SETLL     UPLHXL2                                                    CAS008
     C                   READ      UPLHXL2                                                    CAS008
                                                                                              CAS008
     C                   DOW       NOT %EOF(UPLHXL2)                                          CAS008
                                                                                              CAS008
     C                   IF        NDTA = 0                                                   CAS008
                                                                                              CAS008
     C                   EVAL      WkEffd = EFDT                                              CAS008
     C                   EXSR      SrFwdEffdt                                                 CAS008
                                                                                              CAS008
     C                   IF        WkEffd <= BJRDNB                                           CAS008
     C                   DELETE    UPLHXL2                                                    CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   READ      UPLHXL2                                                    CAS008
     C                   ENDDO                                                                CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDSR
 
      *****************************************************************                       CAS008
      /EJECT                                                                                  CAS008
      *****************************************************************                       CAS008
      *                                                               *                       CAS008
      * SrDlyNHVDL - Drop historic dollar offset net present values   *                       CAS008
      *                                                               *                       CAS008
      *****************************************************************                       CAS008
     C     SrDlyNHVDL    BEGSR                                                                CAS008
                                                                                              CAS008
      ** Single currencies                                                                    CAS008
     C                   READ      IRSNHVPD                                                   CAS008
                                                                                              CAS008
     C                   DOW       NOT %EOF(IRSNHVPD)                                         CAS008
                                                                                              CAS008
     C                   EVAL      WkEffd = IREFFD                                            CAS008
     C                   EXSR      SrFwdEffdt                                                 CAS008
                                                                                              CAS008
     C                   IF        WkEffd <= BJRDNB                                           CAS008
     C                   DELETE    IRSNHVPD                                                   CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   READ      IRSNHVPD                                                   CAS008
     C                   ENDDO                                                                CAS008
                                                                                              CAS008
      ** Cross currencies                                                                     CAS008
     C                   READ      RXSNHVPD                                                   CAS008
                                                                                              CAS008
     C                   DOW       NOT %EOF(RXSNHVPD)                                         CAS008
                                                                                              CAS008
     C                   EVAL      WkEffd = IREFFD                                            CAS008
     C                   EXSR      SrFwdEffdt                                                 CAS008
                                                                                              CAS008
     C                   IF        WkEffd <= BJRDNB                                           CAS008
     C                   DELETE    RXSNHVPD                                                   CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   READ      RXSNHVPD                                                   CAS008
     C                   ENDDO                                                                CAS008
                                                                                              CAS008
      ** FRA                                                                                  CAS008
     C                   READ      FRANHVPD                                                   CAS008
                                                                                              CAS008
     C                   DOW       NOT %EOF(FRANHVPD)                                         CAS008
                                                                                              CAS008
     C                   EVAL      WkEffd = IREFFD                                            CAS008
     C                   EXSR      SrFwdEffdt                                                 CAS008
                                                                                              CAS008
     C                   IF        WkEffd <= BJRDNB                                           CAS008
     C                   DELETE    FRANHVPD                                                   CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   READ      FRANHVPD                                                   CAS008
     C                   ENDDO                                                                CAS008
                                                                                              CAS008
      ** Deals                                                                                CAS008
     C                   READ      DLNHVLPD                                                   CAS008
                                                                                              CAS008
     C                   DOW       NOT %EOF(DLNHVLPD)                                         CAS008
                                                                                              CLE148
     C                   MOVEL     DLDLNO        FSDLNO                                       CLE148
                                                                                              CAS008
     C                   EVAL      WkEffd = FSEFFD                                            CAS008
     C                   EXSR      SrFwdEffdt                                                 CAS008
                                                                                              CAS008
     C                   IF        WkEffd <= BJRDNB                                           CAS008
     C                   DELETE    DLNHVLPD                                                   CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   READ      DLNHVLPD                                                   CAS008
     C                   ENDDO                                                                CAS008
     C                   ENDSR                                                                CAS008
                                                                                              CAS008
      *****************************************************************                       CAS008
      /EJECT                                                                                  CAS008
      *****************************************************************                       CAS008
      *                                                               *                       CAS008
      * SrFwdEffDt - Gets forward effective date.                     *                       CAS008
      *                                                               *                       CAS008
      *****************************************************************                       CAS008
     C     SrFwdEffDt    BEGSR                                                                CAS008
                                                                                              CAS008
     C                   CALLB     'ZFWDT'                                                    CAS008
     C                   PARM      WkEffd        PzDayNo3                                     CAS008
     C                   PARM      FSNDDP        PZNRdys3                                     CAS008
     C                   PARM                    PZDyNbr3                                     CAS008
     C                   PARM      BJCYCD        PzCCY3                                       CAS008
     C                   PARM                    PZLoc3                                       CAS008
                                                                                              CAS008
     C                   EVAL      WkEffd = PZDyNbr3                                          CAS008
                                                                                              CAS008
     C                   ENDSR                                                                CAS008
                                                                                              CAS008
      *****************************************************************                       CAS008
      /EJECT                                                                                  CAS008
      *****************************************************************                       CAS008
      *                                                               *                       CAS008
      * SrDlyMHVSE - Drop historic dollar offset market values        *                       CAS008
      *                                                               *                       CAS008
      *****************************************************************                       CAS008
     C     SrDlyMHVSE    BEGSR                                                                CAS008
                                                                                              CAS008
     C     *LOVAL        SETLL     UPLHXL2                                                    CAS008
     C                   READ      UPLHXL2                                                    CAS008
                                                                                              CAS008
     C                   DOW       NOT %EOF(UPLHXL2)                                          CAS008
                                                                                              CAS008
     C                   EVAL      WkEffd = EFDT                                              CAS008
     C                   EXSR      SrFwdEffdt                                                 CAS008
                                                                                              CAS008
     C                   IF        WkEffd < BJRDNB                                            CAS008
     C                             AND NDTA = 0                                               CAS008
     C                   DELETE    UPLHXL2                                                    CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   READ      UPLHXL2                                                    CAS008
     C                   ENDDO                                                                CAS008
     C                   ENDSR                                                                CAS008
                                                                                              CAS008
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key List For ASDLHML1/ASLEHML1
 
     C     KDLMktDta     KLIST
     C                   KFLD                    KHEDI
     C                   KFLD                    KDLNO
 
      ** Key List For ASSEHML1
 
     C     KSeMktDta     KLIST
     C                   KFLD                    KHEDI
     C                   KFLD                    KSESN
     C                   KFLD                    KBRCA
     C                   KFLD                    KBKCD
     C                   KFLD                    KMKTI
     C                   KFLD                    KBHTV
                                                                                              CAS008
     C     KSeDlyDta     KLIST                                                                CAS008
     C                   KFLD                    XXHEDI                                       CAS008
     C                   KFLD                    XXSESN                                       CAS008
     C                   KFLD                    XXBRCA                                       CAS008
     C                   KFLD                    XXBKCD                                       CAS008
     C                   KFLD                    XXMKTI                                       CAS008
     C                   KFLD                    XXVDAT                                       CAS008
                                                                                              CAS008
     C                   CALL      'AOBANKR0'                                                 CAS008
     C                   PARM      '*MSG   '     PRetCode                                     CAS008
     C                   PARM      '*FIRST '     POption                                      CAS008
     C     SDBANK        PARM      SDBANK        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        PRetCode <> *BLANKS                                        CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      *INU7 = *ON                                                CAS008
     C                   EVAL      *INU8 = *ON                                                CAS008
     C                   EVAL      DBKEY = 'CALL'                                             CAS008
     C                   EVAL      DBFILE = 'SDBANKPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Check if CAS008 is installed                                                         CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRetCode                                     CAS008
     C                   PARM      '*VERIFY'     POption                                      CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRetCode <> *BLANKS) and                                  CAS008
     C                             (PRetCode <> '*NRF   ')                                    CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 3                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRetCode = *BLANKS                                         CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Access Midas SD Hedging ICD File                                                     CAS008
                                                                                              CAS008
     C                   CALL      'AOHEDGR0'                                                 CAS008
     C                   PARM      *BLANKS       PRetCode                                     CAS008
     C                   PARM      '*FIRST '     POption                                      CAS008
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database Error                                                                       CAS008
                                                                                              CAS008
     C                   IF        PRetCode <> *BLANKS                                        CAS008
     C                   EVAL      DBKEY  =  POption                                          CAS008
     C                   EVAL      DBFILE =  'SDHEDGPD'                                       CAS008
     C                   EVAL      DBASE  =  4                                                CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
 
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
