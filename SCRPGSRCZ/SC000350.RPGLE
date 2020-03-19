      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Activation of Feature')                       *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000350 - Midas SC Activation of Feature                    *
      *                                                               *
      *  Function:  This program will activate the features           *
      *             automatically                                     *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSW220             Date 09Mar20               *
      *  Prev Amend No. CSW219 *CREATE     Date 04Mar19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW220 - SWIFT Changes 2020                                  *
      *  CSW219 - SWIFT Changes 2019                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SrProcess - Process All Available Features                   *
      *  SrWrite   - Determine which Feature will be written          *
      *  SrWriteSard - Insert SCSARDPD Record                         *
      *  SrWritePass - Insert SCPASSPD Record                         *
      *  SrCache   - Call Caching of Features                         *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **
     FSCSARDL0  UF A E           K DISK
     FSCPASSPD  UF A E           K DISK
     FSCSARSL1  IF   E           K DISK
     FMESWACL0  IF   E           K DISK
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     DPSDS            SDS
     D PSExcpType             40     42
      **  Exception number.
     D PSExcpNo               43     46
      ** Job name.
     D PSJobName             244    253
      ** User name.
     D PSUser                254    263
      *

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data Structure for Feature
     D FeatDS          DS
     D                                6    INZ('CSW219')
     D                                6    INZ('CSW220')                        CSW220
     D Feat                           6    DIM(N) OVERLAY(FeatDS)
      *
      ** Data Structure for Feature Password
     D PWordDS         DS
     D                               16    INZ('GALERA')
     D                               16    INZ('CARMONA')                       CSW220
     D PWord                         16    DIM(N) OVERLAY(PWordDS)
      *
     D CacheDT       E DS                  EXTNAME(CACHEDT) DTAARA(CACHEDT)
      *
     D SDBank        E DS                  EXTNAME(SDBankpd)
      *
      ** First DS for Access programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Increment N, everytime a new Feature is added in DS
     D*N********       C                   1                                    CSW220
     D N               C                   2                                    CSW220
      *
     D I               S              4S 0
     D WriteFlag       S              1A
     D WRun            S              1A
     D Msg             S            100A
     D PRetCode        S              7A
     D POption         S              7A
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
     C                   EXSR      SrProcess
     C                   EXSR      SrCache
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess - Process All Available Features                   *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR
      *
      ** Process all available features, if it exist in file
      ** skip processing and proceed to the next feature.
      *
     C                   FOR        I = 1 to N
     C     Feat(I)       CHAIN(N)  SCSARDL0
     C                   IF        %FOUND(SCSARDL0)
     C                   ITER
      *
     C                   ELSE
     C     Feat(I)       CHAIN     MESWACL0
     C                   IF        %FOUND(MESWACL0) AND
     C                             BJDNWD >= SWACDT
     C                   EXSR      SrWrite
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDFOR
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWrite - Determine which Feature will be written            *
      *                                                               *
      *****************************************************************
     C     SrWrite       BEGSR
      *
     C                   CLEAR                   WriteFlag
      *
     C     Feat(I)       CHAIN     SCSARDL0
     C                   IF        NOT%FOUND(SCSARDL0)
     C                   EXSR      SrWriteSard
     C                   ELSE
     C                   UNLOCK    SCSARDL0
     C                   ENDIF
      *
     C     Feat(I)       CHAIN     SCPASSPD
     C                   IF        NOT%FOUND(SCPASSPD)
     C                   EXSR      SrWritePass
     C                   ELSE
     C                   UNLOCK    SCPASSPD
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteSard - Insert SCSARDPD Record                         *
      *                                                               *
      *****************************************************************
     C     SrWriteSard   BEGSR
      *
     C                   CLEAR                   @SARDL0
     C     Feat(I)       CHAIN     SCSARSL1
     C                   IF        %FOUND(SCSARSL1)
     C                   EVAL      ABSARD = AXSARD
     C                   ENDIF
     C                   EVAL      ABSARN = Feat(I)
     C                   EVAL      ABTYLC = 'I'
     C                   EVAL      WriteFlag = 'Y'
     C                   WRITE(E)  @SARDL0
      *
     C                   IF        %ERROR
     C                   EVAL      Msg = 'Write to SCSARDL0 ended in error.'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWritePass - Insert SCPASSPD Record                         *
      *                                                               *
      *****************************************************************
     C     SrWritePass   BEGSR
      *
     C                   CLEAR                   SCPASSD0
     C                   EVAL      PASS = PWord(I)
     C                   EVAL      P@SARN = Feat(I)
     C                   EVAL      WriteFlag = 'Y'
     C                   WRITE(E)  SCPASSD0
      *
     C                   IF        %ERROR
     C                   EVAL      Msg = 'Write to SCPASSPD ended in error.'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCache - Call Caching of Features                           *
      *                                                               *
      *****************************************************************
     C     SrCache       BEGSR
      *
     C                   IF        WriteFlag = 'Y'
      *
      ** Call the caching of feature in SCSARHTD.
      *
     C                   CALL(E)   'SC000300'
      *
     C                   IF        %ERROR
     C                   EVAL      Msg = 'Call to SC000300 ended in error...'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set CACHEDT (data area) to Y, to enable Caching of URL
      ** in the next component.
      *
     C     *LOCK         IN(E)     CACHEDT
     C                   EVAL      SCACHE = 'Y'
     C                   OUT       CACHEDT

     C                   IF        %ERROR
     C                   EVAL      Msg = 'Access to CACHEDT-Data Area ' +
     C                             'ended in error.'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBank        PARM      SDBank        DSFDY
      *
      ** Initialize Data Area to blanks.
      *
     C     *LOCK         IN(E)     CACHEDT
     C                   EVAL      SCACHE = *BLANKS
     C                   OUT       CACHEDT
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
