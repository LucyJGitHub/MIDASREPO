      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
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
      *  Last Amend No. MD054346           Date 18Jul21               *
      *  Prev Amend No. MD057885           Date 13Apr21               *
      *                 MD056781           Date 20Sep20               *
      *                 MD055681           Date 31Jul20               *
      *                 MD055694           Date 09Mar20               *
      *                 CSW219 *CREATE     Date 04Mar19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054346 - Switchable Features Password Encryption           *
      *  MD057885 - Remove CSW220 changes                             *
      *  MD056781 - Deliverable Data Split for MESWACPD               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055694 - SWIFT Changes 2021                                *
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
     F*SCSARDL0* UF A E           K DISK                                                    MD055681
     F*SCPASSPD* UF A E           K DISK                                                    MD054346
     F*SCSARSL1* IF   E           K DISK                                                    MD055681
     F*MESWACL0* IF   E           K DISK                                                    MD056781
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
     D**********                      6    INZ('CSW220')                           MD055694 MD057885
     D                                6    INZ('CSW221')                                    MD055694
     D Feat                           6    DIM(N) OVERLAY(FeatDS)
      *
      ** Data Structure for Feature Password
     D PWordDS         DS
     D                               16    INZ('GALERA')
     D**********                     16    INZ('CARMONA')                          MD055694 MD057885
     D                               16    INZ('ABBEY ROAD')                                MD055694
     D PWord                         16    DIM(N) OVERLAY(PWordDS)
      *
     D CacheDT       E DS                  EXTNAME(CACHEDT) DTAARA(CACHEDT)
      *
     D SDBank        E DS                  EXTNAME(SDBankpd)
      *
      ** First DS for Access programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
     D MESWAC        E DS                  EXTNAME(MESWAJW0)                                MD056781
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Increment N, everytime a new Feature is added in DS
     D*N********       C                   1                                               MD055694
     D N               C                   3                                               MD055694
      *
     D I               S              4S 0
     D WriteFlag       S              1A
     D WRun            S              1A
     D Msg             S            100A
     D PRetCode        S              7A
     D POption         S              7A
     D XXFeat          S              6A                                                    MD055681
     D P@SARN          S              6A                                                    MD054346
     D PASS            S             16A                                                    MD054346
     D PReturnCode     S              7A                                                    MD054346
     D PAction         S              1A                                                    MD054346
     D PValidList      S             10A   INZ('SCFEATVL')                                  MD054346
     D PLibrary        S             10A                                                    MD054346
     D PIDName         S            100A                                                    MD054346
     D PPass1          S            600A                                                    MD054346
     D PPass2          S            600A                                                    MD054346
     D PDescr          S           1000A                                                    MD054346
      * Action codes.                                                                       MD054346
     D Insert          C                   CONST('A')                                       MD054346
     D Modify          C                   CONST('M')                                       MD054346
     D Reset           C                   CONST('R')                                       MD054346
     D Delete          C                   CONST('D')                                       MD054346
     D Find            C                   CONST('F')                                       MD054346
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
     C*****Feat(I)       CHAIN(N)  SCSARDL0                                                 MD055681
     C                   EVAL      XXFeat = Feat(I)                                         MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :XXFeat                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C**********         IF        %FOUND(SCSARDL0)                                         MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   ITER
      *
     C                   ELSE
     C*****Feat(I)       CHAIN     MESWACL0                                                 MD056781
     C/EXEC SQL                                                                             MD056781
     C+ SELECT *                                                                            MD056781
     C+ into :MESWAC                                                                        MD056781
     C+ from MESWAJW0                                                                       MD056781
     C+ where SWFEAT = :XXFeat                                                              MD056781
     C/END-EXEC                                                                             MD056781
     C**********         IF        %FOUND(MESWACL0) AND                                     MD056781
     C                   IF        SQLCODE = 0 AND                                          MD056781
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
     C*****Feat(I)       CHAIN(N)  SCSARDL0                                                 MD055681
     C                   EVAL      XXFeat = Feat(I)                                         MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :XXFeat                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C**********         IF        NOT%FOUND(SCSARDL0)                                      MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   EXSR      SrWriteSard
     C                   ELSE
     C**********         UNLOCK    SCSARDL0                                                 MD055681
     C                   ENDIF
      *
     C*****Feat(I)       CHAIN     SCPASSPD                                                 MD054346
     C                   CALL      'UT000033'                                               MD054346
     C                   PARM      *Blanks       PReturnCode                                MD054346
     C                   PARM      Find          PAction                                    MD054346
     C                   PARM                    PValidList                                 MD054346
     C                   PARM                    PLibrary                                   MD054346
     C                   PARM      XXFeat        PIDName                                    MD054346
     C                   PARM      *Blanks       PPass1                                     MD054346
     C                   PARM      *Blanks       PPass2                                     MD054346
     C                   PARM      *Blanks       PDescr                                     MD054346
                                                                                            MD054346
     C**********         IF        NOT%FOUND(SCPASSPD)                                      MD054346
     C     PReturnCode   IFNE      *Blanks                                                  MD054346
     C                   EXSR      SrWritePass
     C                   ELSE
     C**********         UNLOCK    SCPASSPD                                                 MD054346
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
     C**********         CLEAR                   @SARDL0                                    MD055681
     C                   MOVEL     *BLANKS       XXSARD           50                        MD055681
     C*****Feat(I)       CHAIN     SCSARSL1                                                 MD055681
     C                   eval      XXFeat = Feat(I)                                         MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :XXFeat and AXMODE = 'C'                                             MD055681
     C/END-EXEC                                                                             MD055681
     C**********         IF        %FOUND(SCSARSL1)                                         MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C**********         EVAL      ABSARD = AXSARD                                          MD055681
     C                   EVAL      XXSARD = AXSARD                                          MD055681
     C                   ENDIF
     C**********         EVAL      ABSARN = Feat(I)                                         MD055681
     C                   EVAL      XXFeat = Feat(I)                                         MD055681
     C**********         EVAL      ABTYLC = 'I'                                             MD055681
     C                   EVAL      WriteFlag = 'Y'
     C**********         WRITE(E)  @SARDL0                                                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , SARD                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :XXFeat                                                                           MD055681
     C+ , :XXSARD                                                                           MD055681
     C+ , 0                                                                                 MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :XXFeat                                                                           MD055681
     C+ , 0                                                                                 MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
      *
     C**********         IF        %ERROR                                                   MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
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
     C**********         CLEAR                   SCPASSD0                                   MD054346
     C                   EVAL      PASS = PWord(I)
     C                   EVAL      P@SARN = Feat(I)
     C**********         EVAL      WriteFlag = 'Y'                                          MD054346
     C**********         WRITE(E)  SCPASSD0                                                 MD054346
     C                   CALL      'UT000033'                                               MD054346
     C                   PARM      *Blanks       PReturnCode                                MD054346
     C                   PARM      Insert        PAction                                    MD054346
     C                   PARM                    PValidList                                 MD054346
     C                   PARM                    PLibrary                                   MD054346
     C                   PARM      P@SARN        PIDName                                    MD054346
     C                   PARM      PASS          PPass1                                     MD054346
     C                   PARM      PASS          PPass2                                     MD054346
     C                   PARM      *Blanks       PDescr                                     MD054346
                                                                                            MD054346
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
