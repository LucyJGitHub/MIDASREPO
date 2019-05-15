     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Retrieve service program information')        *
      *****************************************************************
      *                                                               *
      *  Midas Utilities Module                                       *
      *                                                               *
      *  UT000036 - Display service program information to files      *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT008  *CREATE    Date 21Dec10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT008 - Rewrite of CRTOBJ.                                  *
      *                                                               *
      *****************************************************************
     FUTSPMDPD  UF A E             DISK    USROPN
     FUTSPSPPD  UF A E             DISK    USROPN
     FUTSPEAPD  UF A E             DISK    USROPN
     FUTSPDIPD  UF A E             DISK    USROPN
     FUTSPCIPD  UF A E             DISK    USROPN
     FUTSPPEPD  UF A E             DISK    USROPN
     FUTSPDEPD  UF A E             DISK    USROPN
     FUTSPSGPD  UF A E             DISK    USROPN
      *
     D SrvPgmName      S             10
     D SrvPgmLib       S             10
     D SrvPgmInf       S             10
     D ReturnCode      S              7
      *
     D UsrSpcName      S             10
     D UsrSpcLib       S             10
     D APIFmt          S              8
     D USData          S           5000
     D USStart         S              9B 0
     D USLen           S              9B 0
     D Count           S              3  0 INZ(1)
     D HtoCWorkB       S            100
     D HtoCWorkA       S            200
     D HtoCWorkBPos    S              3S 0
     D HtoCWorkAPos    S              3S 0
     D DoLoopNo        S              3S 0
     D CheckBitPos     S              3S 0
     D Work01A         S              1
     D HighOrLow       S              1    INZ('L')
     D Recursive       S              1
      *
     D                 DS
     D  TwoDigitN              1      2  0
     D  OneDigitA              2      2
      *
     D QSrvPgm         DS
     D  QSrvPgmName            1     10
     D  QSrvPgmLib            11     20
      *
     D QUsrSpc         DS
     D  QUsrSpcName            1     10    INZ('SRVPGMUS')
     D  QUsrSpcLib            11     20    INZ('QTEMP')
      *
     D USError         DS
     D  BytesProv              1      4B 0 INZ(15)
     D  BytesAvail             5      8B 0
     D  ErrorMsg               9     15
      *
     D USGenHdrDS      DS
     D  AllGenHdrDS            1    576
     D  USHUserArea            1     64
     D  USHSize               65     68B 0
     D  USHRlsLvl             69     72
     D  USHFmtName            73     80
     D  USHAPIName            81     90
     D  USHCrtInfo            91    103
     D  USHInfSts            104    104
     D  USHUSSize            105    108B 0
     D  USHInpParmOff        109    112B 0
     D  USHInpParmSiz        113    116B 0
     D  USHHdrSectOff        117    120B 0
     D  USHHdrSectSiz        121    124B 0
     D  USHListOff           125    128B 0
     D  USHListSiz           129    132B 0
     D  USHNoOfListE         133    136B 0
     D  USHEntSize           137    140B 0
     D  USHCCSID             141    144B 0
     D  USHCtryID            145    146
     D  USHLangID            147    149
     D  USHSubListInd        150    150
     D  USHReserved01        151    192
     D  USHAPIEntPt          193    448
     D  USHReserved02        449    576
      *
     D USSrvPgm0100DS  DS
     D  SrvPgm0100DS           1   3995
     D  SrvPgmNam0100          1     10
     D  SrvPgmLib0100         11     20
     D  BModNam0100           21     30
     D  BModLib0100           31     40
     D  SrcFNam0100           41     50
     D  SrcFLib0100           51     60
     D  SrcFMbr0100           61     70
     D  ModAtr0100            71     80
     D  ModCrtInf0100         81     93
     D  SrcUpdInf0100         94    106
     D  SrtSqTbN0100         107    116
     D  SrtSqTbL0100         117    126
     D  LangID0100           127    136
     D  OptLvl0100           137    140B 0
     D  MaxOptLvl0100        141    144B 0
     D  DbgData0100          145    154
     D  OnRlsLvl0100         155    160
     D  ForRlsLvl0100        161    166
     D  Rsrvd010100          167    186
     D  UserMod0100          187    187
     D  LicPgm0100           188    200
     D  PTFNo0100            201    205
     D  APARId0100           206    211
     D  CrtData0100          212    212
     D  CCSID0100            213    216B 0
     D  ObjCtlLvl0100        217    224
     D  EnPerfCol0100        225    225
     D  ProfData0100         226    235
     D  RTVCLSRC0100         236    236
     D  ProcNo0100           237    240B 0
     D  ProcNoBR0100         241    244B 0
     D  ProcNoBoM0100        245    248B 0
     D  TSpcStgEn0100        249    249
     D  StgMdl0100           250    250
     D  Rsrvd020100          251    324
     D  SQLNo0100            325    328B 0
     D  RltnlDB0100          329    346
     D  CmtCtl0100           347    356
     D  AlwCpyDta0100        357    366
     D  ClsSQLCrs0100        367    376
     D  NamConv0100          377    386
     D  DateFmt0100          387    396
     D  DateSep0100          397    397
     D  TimeFmt0100          398    407
     D  TimeSep0100          408    408
     D  DlyPREP0100          409    418
     D  AlwBlck0100          419    428
     D  DftColl0100          429    438
     D  SQLPckNam0100        439    448
     D  SQLPckLib0100        449    458
     D  DynUsrPrf0100        459    468
     D  SQLSSTNam0100        469    478
     D  SQLSSTLib0100        479    488
     D  SQLLangID0100        489    498
     D  ConnMeth0100         499    508
     D  SQLPthLen0100        509    512B 0
     D  SQLPth0100           513   3995
      *
     D USSrvPgm0200DS  DS
     D  SrvPgm0200DS           1     66
     D  SrvPgmNam0200          1     10
     D  SrvPgmLib0200         11     20
     D  BSPgmNam0200          21     30
     D  BSPgmLib0200          31     40
     D  BSPgmSig0200          41     56
     D  BSPgmAct0200          57     66
      *
     D USSrvPgm0300DS  DS
     D  SrvPgm0300DS           1    287
     D  SrvPgmNam0300          1     10
     D  SrvPgmLib0300         11     20
     D  ItmExpSiz0300         21     24B 0
     D  IECCSID0300           25     28B 0
     D  IELen0300             29     32B 0
     D  IEName0300            33    287
      *
     D USSrvPgm0400DS  DS
     D  SrvPgm0400DS           1    283
     D  SrvPgmNam0400          1     10
     D  SrvPgmLib0400         11     20
     D  IECCSID0400           21     24B 0
     D  IELen0400             25     28B 0
     D  IEName0400            29    283
      *
     D USSrvPgm0500DS  DS
     D  SrvPgm0500DS           1    283
     D  SrvPgmNam0500          1     10
     D  SrvPgmLib0500         11     20
     D  Rsrvd010500           21     24
     D  CpyrtLen0500          25     28B 0
     D  Cpyrt0500             29    283
      *
     D USSrvPgm0600DS  DS
     D  SrvPgm0600DS           1    293
     D  SrvPgmNam0600          1     10
     D  SrvPgmLib0600         11     20
     D  PECCSID0600           21     24B 0
     D  PELen0600             25     28B 0
     D  PEName0600            29    283
     D  ArgOpt0600           284    293
      *
     D USSrvPgm0700DS  DS
     D  SrvPgm0700DS           1    283
     D  SrvPgmNam0700          1     10
     D  SrvPgmLib0700         11     20
     D  DECCSID0700           21     24B 0
     D  DELen0700             25     28B 0
     D  DEName0700            29    283
      *
     D USSrvPgm0800DS  DS
     D  SrvPgm0800DS           1     36
     D  SrvPgmNam0800          1     10
     D  SrvPgmLib0800         11     20
     D  Sig0800               21     36
      *
      /EJECT
      *
     C     *ENTRY        PLIST
     C                   PARM                    SrvPgmName
     C                   PARM                    SrvPgmLib
     C                   PARM                    SrvPgmInf
     C                   PARM                    ReturnCode
      *
     C                   EVAL      QSrvPgmName = SrvPgmName
     C                   EVAL      QSrvPgmLib = SrvPgmLib
      *
     C                   SELECT
     C                   WHEN      SrvPgmInf = '*MODULE'
     C                   EVAL      APIFmt = 'SPGL0100'
     C                   OPEN      UTSPMDPD
      *
     C                   WHEN      SrvPgmInf = '*SRVPGM'
     C                   EVAL      APIFmt = 'SPGL0200'
     C                   OPEN      UTSPSPPD
      *
     C                   WHEN      SrvPgmInf = '*ACTGRPEXP'
     C                   EVAL      APIFmt = 'SPGL0300'
     C                   OPEN      UTSPEAPD
      *
     C                   WHEN      SrvPgmInf = '*ACTGRPIMP'
     C                   EVAL      APIFmt = 'SPGL0400'
     C                   OPEN      UTSPDIPD
      *
     C                   WHEN      SrvPgmInf = '*COPYRIGHT'
     C                   EVAL      APIFmt = 'SPGL0500'
     C                   OPEN      UTSPCIPD
      *
     C                   WHEN      SrvPgmInf = '*PROCEXP'
     C                   EVAL      APIFmt = 'SPGL0600'
     C                   OPEN      UTSPPEPD
      *
     C                   WHEN      SrvPgmInf = '*DTAEXP'
     C                   EVAL      APIFmt = 'SPGL0700'
     C                   OPEN      UTSPDEPD
      *
     C                   WHEN      SrvPgmInf = '*SIGNATURE'
     C                   EVAL      APIFmt = 'SPGL0800'
     C                   OPEN      UTSPSGPD
      *
     C                   ENDSL
      *
      * Populate User Space.
     C                   EXSR      PopUS
      *
      * Get header information from User Space.
     C                   EXSR      RtvUSHdrData
      *
      * Loop for number of entries.
     C                   EVAL      USStart = USHListOff + 1
     C                   EVAL      USLen = USHEntSize
     C                   DOU       Count > USHNoOfListE
      *
      * Retrieve list data.
     C                   EXSR      RtvUSListData
      *
     C                   EVAL      Count = Count + 1
     C                   EVAL      USStart = USStart + USHEntSize
     C                   ENDDO
      *
      * Perform file close downs.
     C                   EXSR      CloseFile
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CheckBit - Translate hex value to characte                   *
      *           - Called from *VARIOUS                              *
      *                                                               *
      *****************************************************************
     C     CheckBit      BEGSR
      *
     C                   EVAL      Work01A = %SUBST(HtoCWorkB:HtoCWorkBPos:1)
     C                   DO        DoLoopNo
      *
     C                   IF        HighOrLow = 'L'
     C                   EVAL      TwoDigitN = 0
     C                   TESTB     '0'           Work01A                  08
     C                   TESTB     '1'           Work01A                  04
     C                   TESTB     '2'           Work01A                  02
     C                   TESTB     '3'           Work01A                  01
     C   08              ADD       8             TwoDigitN
     C   04              ADD       4             TwoDigitN
     C   02              ADD       2             TwoDigitN
     C   01              ADD       1             TwoDigitN
      *
     C                   EVAL      HighOrLow ='H'
     C                   EXSR      UpdChar
      *
     C                   ELSE
      *
     C                   EVAL      TwoDigitN = 0
     C                   TESTB     '4'           Work01A                  08
     C                   TESTB     '5'           Work01A                  04
     C                   TESTB     '6'           Work01A                  02
     C                   TESTB     '7'           Work01A                  01
     C   08              ADD       8             TwoDigitN
     C   04              ADD       4             TwoDigitN
     C   02              ADD       2             TwoDigitN
     C   01              ADD       1             TwoDigitN
      *
     C                   EVAL      HighOrLow ='L'
     C                   EVAL      HtoCWorkBPos = HtoCWorkBPos + 1
     C                   IF        HtoCWorkBPos < CheckBitPos
     C                   EVAL      Work01A = %SUBST(HtoCWorkB:HtoCWorkBPos:1)
     C                   ENDIF
      *
     C                   EXSR      UpdChar
      *
     C                   ENDIF
      *
     C                   EVAL      %SUBST(HtoCWorkA:HtoCWorkAPos:1) = OneDigitA
     C                   EVAL      HtoCWorkAPos = HtoCWorkAPos + 1
     C                   ENDDO
      *
     C     CheckBitE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  UpdChar - Update character field based on bit settings       *
      *          - Called from CheckBit                               *
      *                                                               *
      *****************************************************************
     C     UpdChar       BEGSR
      *
     C                   IF        TwoDigitN > 9
     C                   SELECT
     C                   WHEN      TwoDigitN = 10
     C                   EVAL      OneDigitA = 'A'
     C                   WHEN      TwoDigitN = 11
     C                   EVAL      OneDigitA = 'B'
     C                   WHEN      TwoDigitN = 12
     C                   EVAL      OneDigitA = 'C'
     C                   WHEN      TwoDigitN = 13
     C                   EVAL      OneDigitA = 'D'
     C                   WHEN      TwoDigitN = 14
     C                   EVAL      OneDigitA = 'E'
     C                   WHEN      TwoDigitN = 15
     C                   EVAL      OneDigitA = 'F'
     C                   ENDSL
     C                   ENDIF
      *
     C     UpdCharE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RtvUSListData - Retrieve list data from User Space.          *
      *                - Called from *MAIN                            *
      *                                                               *
      *****************************************************************
     C     RtvUSListData BEGSR
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    QUsrSpc
     C                   PARM                    USStart
     C                   PARM                    USLen
     C                   PARM                    USData
      *
      * Depending on information requested move data to appropriate data structure.
     C                   SELECT
     C                   WHEN      SrvPgmInf = '*MODULE'
     C                   EVAL      USSrvPgm0100DS = USData
     C                   EXSR      Fmt0100SR
      *
     C                   WHEN      SrvPgmInf = '*SRVPGM'
     C                   EVAL      USSrvPgm0200DS = USData
     C                   EXSR      Fmt0200SR
      *
     C                   WHEN      SrvPgmInf = '*ACTGRPEXP'
     C                   EVAL      USSrvPgm0300DS = USData
     C                   EXSR      Fmt0300SR
      *
     C                   WHEN      SrvPgmInf = '*ACTGRPIMP'
     C                   EVAL      USSrvPgm0400DS = USData
     C                   EXSR      Fmt0400SR
      *
     C                   WHEN      SrvPgmInf = '*COPYRIGHT'
     C                   EVAL      USSrvPgm0500DS = USData
     C                   EXSR      Fmt0500SR
      *
     C                   WHEN      SrvPgmInf = '*PROCEXP'
     C                   EVAL      USSrvPgm0600DS = USData
     C                   EXSR      Fmt0600SR
      *
     C                   WHEN      SrvPgmInf = '*DTAEXP'
     C                   EVAL      USSrvPgm0700DS = USData
     C                   EXSR      Fmt0700SR
      *
     C                   WHEN      SrvPgmInf = '*SIGNATURE'
     C                   EVAL      USSrvPgm0800DS = USData
     C                   EXSR      Fmt0800SR
      *
     C                   ENDSL
      *
     C     RtvUSListDataEENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PopUS - Populate User Space using IBM API.                   *
      *        - Called from *MAIN                                    *
      *                                                               *
      *****************************************************************
     C     PopUS         BEGSR
      *
     C                   CALL      'QBNLSPGM'
     C                   PARM                    QUsrSpc
     C                   PARM                    APIFmt
     C                   PARM                    QSrvPgm
     C                   PARM                    USError
     C                   IF        ErrorMsg <> *blanks
     C                   EVAL      ReturnCode = ErrorMsg
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PopUSE        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  RtvUSHdrData - Retrieve header data from User Space          *
      *               - Called from *MAIN                             *
      *                                                               *
      *****************************************************************
     C     RtvUSHdrData  BEGSR
      *
     C                   EVAL      USStart = 1
     C                   EVAL      USLen = 576
     C                   CALL      'QUSRTVUS'
     C                   PARM                    QUsrSpc
     C                   PARM                    USStart
     C                   PARM                    USLen
     C                   PARM                    USGenHdrDS
      *
     C     RtvUSHdrDataE ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0100SR - Module information.                              *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0100SR     BEGSR
      *
     C                   EVAL      SMSPNM = SrvPgmNam0100
     C                   EVAL      SMSPLB = SrvPgmLib0100
     C                   EVAL      SMBMDN = BModNam0100
     C                   EVAL      SMBMDL = BModLib0100
     C                   EVAL      SMSRCF = SrcFNam0100
     C                   EVAL      SMSFLB = SrcFLib0100
     C                   EVAL      SMSFMB = SrcFMbr0100
     C                   EVAL      SMMDAT = ModAtr0100
     C                   EVAL      SMCRTD = ModCrtInf0100
     C                   EVAL      SMSUPD = SrcUpdInf0100
     C                   EVAL      SMSSTN = SrtSqTbN0100
     C                   EVAL      SMSSTL = SrtSqTbL0100
     C                   EVAL      SMLNGI = LangID0100
      *
     C                   SELECT
     C                   WHEN      OptLvl0100 = 65535
     C                   EVAL      SMOPTL = '*NOMAX'
     C                   WHEN      OptLvl0100 = 40
     C                   EVAL      SMOPTL = '*MAX  '
     C                   WHEN      OptLvl0100 = 30
     C                   EVAL      SMOPTL = '*FULL '
     C                   WHEN      OptLvl0100 = 20
     C                   EVAL      SMOPTL = '*BASIC'
     C                   WHEN      OptLvl0100 = 10
     C                   EVAL      SMOPTL = '*NONE '
     C                   ENDSL
      *
     C                   SELECT
     C                   WHEN      MaxOptLvl0100 = 65535
     C                   EVAL      SMMOPL = '*NOMAX'
     C                   WHEN      MaxOptLvl0100 = 40
     C                   EVAL      SMMOPL = '*MAX  '
     C                   WHEN      MaxOptLvl0100 = 30
     C                   EVAL      SMMOPL = '*FULL '
     C                   WHEN      MaxOptLvl0100 = 20
     C                   EVAL      SMMOPL = '*BASIC'
     C                   WHEN      MaxOptLvl0100 = 10
     C                   EVAL      SMMOPL = '*NONE '
     C                   ENDSL
      *
     C                   EVAL      SMDBGD = DbgData0100
     C                   EVAL      SMRCTO = OnRlsLvl0100
     C                   EVAL      SMRCTF = ForRlsLvl0100
     C                   EVAL      SMRSV1 = Rsrvd010100
      *
     C                   IF        UserMod0100 ='0'
     C                   EVAL      SMUSRM = 'N'
     C                   ELSE
     C                   EVAL      SMUSRM = 'Y'
     C                   ENDIF
      *
     C                   EVAL      SMLICP = LicPgm0100
     C                   EVAL      SMPTFN = PTFNo0100
     C                   EVAL      SMAPID = APARId0100
      *
     C                   SELECT
     C                   WHEN      CrtData0100 ='0'
     C                   EVAL      SMCDTA = '*NO'
     C                   WHEN      CrtData0100 ='1'
     C                   EVAL      SMCDTA = '*YES'
     C                   WHEN      CrtData0100 ='2'
     C                   EVAL      SMCDTA = '*UNOBS'
     C                   ENDSL
      *
     C                   EVAL      SMCDTA = CrtData0100
     C                   EVAL      SMCSID = CCSID0100
     C                   EVAL      SMOBCL = ObjCtlLvl0100
      *
     C                   EVAL      HtoCWorkB = EnPerfCol0100
     C                   EVAL      HtoCWorkBPos = 1
     C                   EVAL      HtoCWorkAPos = 1
     C                   EVAL      DoLoopNo = 2
     C                   EVAL      CheckBitPos = 2
     C                   EXSR      CheckBit
     C                   SELECT
     C                   WHEN      HtoCWorkA = '00'
     C                   EVAL      SMENPC = '*NONE'
     C                   WHEN      HtoCWorkA = '10'
     C                   EVAL      SMENPC = '*PEP'
     C                   WHEN      HtoCWorkA = '50'
     C                   EVAL      SMENPC = '*ENTRYEXIT *NONLEAF'
     C                   WHEN      HtoCWorkA = '70'
     C                   EVAL      SMENPC = '*ENTRYEXIT *ALLPRC'
     C                   WHEN      HtoCWorkA = 'D0'
     C                   EVAL      SMENPC = '*FULL *NONLEAF'
     C                   WHEN      HtoCWorkA = 'F0'
     C                   EVAL      SMENPC = '*FULL *ALLPRC'
     C                   ENDSL
      *
     C                   EVAL      SMPRFD = ProfData0100
      *
     C                   IF        RTVCLSRC0100 ='0'
     C                   EVAL      SMRTVC = 'N'
     C                   ELSE
     C                   EVAL      SMRTVC = 'Y'
     C                   ENDIF
      *
     C                   EVAL      SMPRCN = ProcNo0100
     C                   EVAL      SMNPBR = ProcNoBR0100
     C                   EVAL      SMNPBM = ProcNoBoM0100
      *
     C                   EVAL      HtoCWorkB = TSpcStgEn0100
     C                   EVAL      HtoCWorkBPos = 1
     C                   EVAL      HtoCWorkAPos = 1
     C                   EVAL      DoLoopNo = 2
     C                   EVAL      CheckBitPos = 2
     C                   EXSR      CheckBit
     C                   SELECT
     C                   WHEN      HtoCWorkA = '00'
     C                   EVAL      SMTSPE = 'N'
     C                   WHEN      HtoCWorkA = '80'
     C                   EVAL      SMTSPE = 'Y'
     C                   ENDSL
      *
     C                   SELECT
     C                   WHEN      StgMdl0100 ='0'
     C                   EVAL      SMSTGM = '*SNGLVL'
     C                   WHEN      StgMdl0100 ='1'
     C                   EVAL      SMSTGM = '*TERASPACE'
     C                   WHEN      StgMdl0100 ='2'
     C                   EVAL      SMSTGM = '*INHERIT'
     C                   ENDSL
      *
     C                   EVAL      SMRSV2 = Rsrvd020100
     C                   EVAL      SMNSQL = SQLNo0100
     C                   EVAL      SMRLDB = RltnlDB0100
     C                   EVAL      SMCCTL = CmtCtl0100
     C                   EVAL      SMACPY = AlwCpyDta0100
     C                   EVAL      SMCLSC = ClsSQLCrs0100
     C                   EVAL      SMNAMC = NamConv0100
     C                   EVAL      SMDATF = DateFmt0100
     C                   EVAL      SMDATS = DateSep0100
     C                   EVAL      SMTIMF = TimeFmt0100
     C                   EVAL      SMTIMS = TimeSep0100
     C                   EVAL      SMDLYP = DlyPREP0100
     C                   EVAL      SMALWB = AlwBlck0100
     C                   EVAL      SMDFTC = DftColl0100
     C                   EVAL      SMSPCK = SQLPckNam0100
     C                   EVAL      SMSPKL = SQLPckLib0100
     C                   EVAL      SMDUSP = DynUsrPrf0100
     C                   EVAL      SMSSST = SQLSSTNam0100
     C                   EVAL      SMSSSL = SQLSSTLib0100
     C                   EVAL      SMSLID = SQLLangID0100
     C                   EVAL      SMCMTH = ConnMeth0100
     C                   EVAL      SMPTHL = SQLPthLen0100
     C                   EVAL      SMPATH = SQLPth0100
     C                   WRITE     UTSPMDD0
      *
     C     Fmt0100SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0200SR - Service program information.                     *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0200SR     BEGSR
      *
     C                   EVAL      SSSPNM = SrvPgmNam0200
     C                   EVAL      SSSPLB = SrvPgmLib0200
     C                   EVAL      SSBSPN = BSPgmNam0200
     C                   EVAL      SSBSPL = BSPgmLib0200
     C                   EVAL      HtoCWorkB = BSPgmSig0200
     C                   EVAL      HtoCWorkBPos = 1
     C                   EVAL      HtoCWorkAPos = 1
     C                   EVAL      DoLoopNo = 32
     C                   EVAL      CheckBitPos = 17
     C                   EXSR      CheckBit
     C                   EVAL      SSBSPS = HtoCWorkA
     C                   EVAL      SSBSPA = BSPgmAct0200
     C                   WRITE     UTSPSPD0
      *
     C     Fmt0200SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0300SR - Activation group exported data items.            *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0300SR     BEGSR
      *
     C                   EVAL      SASPNM = SrvPgmNam0300
     C                   EVAL      SASPLB = SrvPgmLib0300
     C                   EVAL      SAESIZ = ItmExpSiz0300
     C                   EVAL      SACSID = IECCSID0300
     C                   EVAL      SAELEN = IELen0300
     C                   EVAL      SAEXPN = IEName0300
     C                   WRITE     UTSPEAD0
      *
     C     Fmt0300SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0400SR - Activation group imported data items.            *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0400SR     BEGSR
      *
     C                   EVAL      SISPNM = SrvPgmNam0400
     C                   EVAL      SISPLB = SrvPgmLib0400
     C                   EVAL      SICSID = IECCSID0400
     C                   EVAL      SIILEN = IELen0400
     C                   EVAL      SIIMPN = IEName0400
     C                   WRITE     UTSPDID0
      *
     C     Fmt0400SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0500SR - Copyright information.                           *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0500SR     BEGSR
      *
     C                   EVAL      SCSPNM = SrvPgmNam0500
     C                   EVAL      SCSPLB = SrvPgmLib0500
     C                   EVAL      SCRSV1 = Rsrvd010500
     C                   EVAL      SCCLEN = CpyrtLen0500
     C                   EVAL      SCCPYR = Cpyrt0500
     C                   WRITE     UTSPCID0
      *
     C     Fmt0500SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0600SR - Exported procedures.                             *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0600SR     BEGSR
      *
     C                   EVAL      SPSPNM = SrvPgmNam0600
     C                   EVAL      SPSPLB = SrvPgmLib0600
     C                   EVAL      SPCSID = PECCSID0600
     C                   EVAL      SPPLEN = PELen0600
     C                   EVAL      SPEPRC = PEName0600
     C                   EVAL      SPARGO = ArgOpt0600
     C                   WRITE     UTSPPED0
      *
     C     Fmt0600SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0700SR - Exported data items.                             *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0700SR     BEGSR
      *
     C                   EVAL      SDSPNM = SrvPgmNam0700
     C                   EVAL      SDSPLB = SrvPgmLib0700
     C                   EVAL      SDCSID = DECCSID0700
     C                   EVAL      SDDLEN = DELen0700
     C                   EVAL      SDDATA = DEName0700
     C                   WRITE     UTSPDED0
      *
     C     Fmt0700SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Fmt0800SR - Signature information.                           *
      *            - Called from RtvUSListData                        *
      *                                                               *
      *****************************************************************
     C     Fmt0800SR     BEGSR
      *
     C                   EVAL      SGSPNM = SrvPgmNam0800
     C                   EVAL      SGSPLB = SrvPgmLib0800
     C                   EVAL      HtoCWorkB = Sig0800
     C                   EVAL      HtoCWorkBPos = 1
     C                   EVAL      HtoCWorkAPos = 1
     C                   EVAL      DoLoopNo = 32
     C                   EVAL      CheckBitPos = 17
     C                   EXSR      CheckBit
     C                   EVAL      SGSIGN = HtoCWorkA
     C                   WRITE     UTSPSGD0
      *
     C     Fmt0800SRE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  CloseFile - Close files down before ending the program.      *
      *            - Called from *MAIN                                *
      *                                                               *
      *****************************************************************
     C     CloseFile     BEGSR
      *
     C                   SELECT
     C                   WHEN      SrvPgmInf = '*MODULE'
     C                   CLOSE     UTSPMDPD
      *
     C                   WHEN      SrvPgmInf = '*SRVPGM'
     C                   CLOSE     UTSPSPPD
      *
     C                   WHEN      SrvPgmInf = '*ACTGRPEXP'
     C                   CLOSE     UTSPEAPD
      *
     C                   WHEN      SrvPgmInf = '*ACTGRPIMP'
     C                   CLOSE     UTSPDIPD
      *
     C                   WHEN      SrvPgmInf = '*COPYRIGHT'
     C                   CLOSE     UTSPCIPD
      *
     C                   WHEN      SrvPgmInf = '*PROCEXP'
     C                   CLOSE     UTSPPEPD
      *
     C                   WHEN      SrvPgmInf = '*DTAEXP'
     C                   CLOSE     UTSPDEPD
      *
     C                   WHEN      SrvPgmInf = '*SIGNATURE'
     C                   CLOSE     UTSPSGPD
      *
     C                   ENDSL
      *
     C     CloseFileE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
