     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT CHGOBJINF CPP')
      *****************************************************************
      *                                                               *
      *  Midas  - Utilities                                           *
      *                                                               *
      *  UT000005 - CPP for CHGOBJINF                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. BUG27980           Date 05Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27133 *CREATE   Date 21Feb08               *
      *                 xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27980 - Remove DBGVIEW (Recompile).                       *
      *  BUG27133 - CHGOBJINF utility - delivery to core.             *
      *                                                               *
      *****************************************************************
      /EJECT
      * Parameters
     D PObjectandLib   S             20
     D PObjectType     S             10
     D PSourceFile     S             10
     D PLibrary        S             10
     D PMember         S             10
     D PSourceDate     S             13
     D PCompiler       S             13
     D PObjLvl         S              8
     D PLicPgm         S             13
     D PPTF            S              7
     D PAPAR           S              6
     D PUsrDfnAtr      S             10
     D PText           S             50
     D PUseCount       S              6
     D PPrdOptLdId     S              4
     D PPrdOptId       S              4
     D PCmpId          S              4
     D PUseDate        S              6
     D PChgDate        S              6
     D PMbrUseCount    S             10
     D PRODSourceF     S             10
     D PRODLibrary     S             10
     D PRODmember      S             10
     D PException      S              7
     D PExceptionData  S             27
      *
      * Flag for each parameter passed to QLICOBJD.
     D Key01Flag       S              1    INZ('N')
     D Key02Flag       S              1    INZ('N')
     D Key03Flag       S              1    INZ('N')
     D Key04Flag       S              1    INZ('N')
     D Key05Flag       S              1    INZ('N')
     D Key06Flag       S              1    INZ('N')
     D Key07Flag       S              1    INZ('N')
     D Key08Flag       S              1    INZ('N')
     D Key09Flag       S              1    INZ('N')
     D Key10Flag       S              1    INZ('N')
     D Key11Flag       S              1    INZ('N')
     D Key12Flag       S              1    INZ('N')
     D Key13Flag       S              1    INZ('N')
     D Key14Flag       S              1    INZ('N')
     D Key15Flag       S              1    INZ('N')
     D Key16Flag       S              1    INZ('N')
     D Key17Flag       S              1    INZ('N')
      *
     D ChgObjInf       S            307
     D ReturnLib       S             10
     D ObjectAndLib    S             20
     D ObjectType      S             10
     D Offset          S              3  0 INZ(1)
      *
     D NumberOfRecsDS  DS
     D  NumberOfRecs           1      4B 0 INZ(0)
      *
      * Data structure for key 01 - Source
     D Key01DS         DS
     D  Key01                  1      4B 0 INZ(1)
     D  Key01Length            5      8B 0 INZ(30)
     D  SourceFile             9     18
     D  Library               19     28
     D  Member                29     38
      *
      * Data structure for key 02 - Source file last changed date and time
     D Key02DS         DS
     D  Key02                  1      4B 0 INZ(2)
     D  Key02Length            5      8B 0 INZ(13)
     D  SourceDate             9     21
      *
      * Data structure for key 03 - Compiler
     D Key03DS         DS
     D  Key03                  1      4B 0 INZ(3)
     D  Key03Length            5      8B 0 INZ(13)
     D  Compiler               9     21
      *
      * Data structure for key 04 - Object control level
     D Key04DS         DS
     D  Key04                  1      4B 0 INZ(4)
     D  Key04Length            5      8B 0 INZ(8)
     D  ObjLvl                 9     16
      *
      * Data structure for key 05 - Licensed program
     D Key05DS         DS
     D  Key05                  1      4B 0 INZ(5)
     D  Key05Length            5      8B 0 INZ(13)
     D  LicPgm                 9     21
      *
      * Data structure for key 06 - PTF
     D Key06DS         DS
     D  Key06                  1      4B 0 INZ(6)
     D  Key06Length            5      8B 0 INZ(7)
     D  PTF                    9     15
      *
      * Data structure for key 07 - APAR
     D Key07DS         DS
     D  Key07                  1      4B 0 INZ(7)
     D  Key07Length            5      8B 0 INZ(6)
     D  APAR                   9     14
      *
      * Data structure for key 08 - Allow change by program
     D Key08DS         DS
     D  Key08                  1      4B 0 INZ(8)
     D  Key08Length            5      8B 0 INZ(1)
     D  AllowChg               9      9
      *
      * Data structure for key 09 - User-defined attribute
     D Key09DS         DS
     D  Key09                  1      4B 0 INZ(9)
     D  Key09Length            5      8B 0 INZ(10)
     D  UsrDfnAtr              9     18
      *
      * Data structure for key 10 - Text
     D Key10DS         DS
     D  Key10                  1      4B 0 INZ(10)
     D  Key10Length            5      8B 0 INZ(50)
     D  Text                   9     58
      *
      * Data structure for key 11 - Days used count
     D Key11DS         DS
     D  Key11                  1      4B 0 INZ(11)
     D  Key11Length            5      8B 0 INZ(1)
     D  UseCount               9      9
      *
      * Data structure for key 12 - Production option load ID
     D Key12DS         DS
     D  Key12                  1      4B 0 INZ(12)
     D  Key12Length            5      8B 0 INZ(4)
     D  PrdOptLdId             9     12
      *
      * Data structure for key 13 - Production option ID
     D Key13DS         DS
     D  Key13                  1      4B 0 INZ(13)
     D  Key13Length            5      8B 0 INZ(4)
     D  PrdOptId               9     12
      *
      * Data structure for key 14 - Component ID
     D Key14DS         DS
     D  Key14                  1      4B 0 INZ(14)
     D  Key14Length            5      8B 0 INZ(4)
     D  CmpId                  9     12
      *
      * Data structure for key 15 - Last used date
     D Key15DS         DS
     D  Key15                  1      4B 0 INZ(15)
     D  Key15Length            5      8B 0 INZ(1)
     D  UseDate                9      9
      *
      * Data structure for key 16 - Changed date and time stamp
     D Key16DS         DS
     D  Key16                  1      4B 0 INZ(16)
     D  Key16Length            5      8B 0 INZ(1)
     D  ChgDate                9      9
      *
      * Data structure for key 17 - Member's days used count
     D Key17DS         DS
     D  Key17                  1      4B 0 INZ(17)
     D  Key17Length            5      8B 0 INZ(10)
     D  MbrUseCount            9     18
      *
      * Data structure to return error information
     D ErrorCode       DS
     D  BytesProv              1      4B 0
     D  BytesAvail             5      8B 0
     D  Exception              9     15
     D  ExceptionRes          16     16
     D  ExceptionData         17     43
      *
     C     *ENTRY        PLIST
     C                   PARM                    PObjectandLib
     C                   PARM                    PObjectType
     C                   PARM                    PSourceFile
     C                   PARM                    PLibrary
     C                   PARM                    PMember
     C                   PARM                    PSourceDate
     C                   PARM                    PCompiler
     C                   PARM                    PObjLvl
     C                   PARM                    PLicPgm
     C                   PARM                    PPTF
     C                   PARM                    PAPAR
     C                   PARM                    PUsrDfnAtr
     C                   PARM                    PText
     C                   PARM                    PUseCount
     C                   PARM                    PPrdOptLdId
     C                   PARM                    PPrdOptId
     C                   PARM                    PCmpId
     C                   PARM                    PUseDate
     C                   PARM                    PChgDate
     C                   PARM                    PMbrUseCount
     C                   PARM                    PRODSourceF
     C                   PARM                    PRODLibrary
     C                   PARM                    PRODMember
      *
     C                   PARM                    PException
     C                   PARM                    PExceptionData
      *
     C                   EVAL      ObjectAndLib = PObjectAndLib
     C                   EVAL      ObjectType = PObjectType
      *
      * Check entry parameters and start building parameter for QLICOBJD.
      *
      * Source file information from where the object was created.  As the
      * member, file and library are passed to QLICOBJD in one parameter they
      * are dealt with together; if a parameter is not changed then the value
      * retrieved from the RTVOBJD in the CL is used.
     C                   IF        PSourceFile <> '*SAME'
     C                             or PLibrary <> '*SAME'
     C                             or PMember <> '*SAME'
     C                   IF        PSourceFile <> '*SAME'
     C                   EVAL      SourceFile = PSourceFile
     C                   ELSE
     C                   EVAL      SourceFile = PRODSourceF
     C                   ENDIF
     C                   IF        PLibrary <> '*SAME'
     C                   EVAL      Library = PLibrary
     C                   ELSE
     C                   EVAL      Library = PRODLibrary
     C                   ENDIF
     C                   IF        PMember <> '*SAME'
     C                   EVAL      Member = PMember
     C                   ELSE
     C                   EVAL      Member = PRODMember
     C                   ENDIF
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key01Flag = 'Y'
     C                   ENDIF
      * Source file last changed date and time.
     C                   IF        PSourceDate <> '*SAME'
     C                   EVAL      SourceDate = PSourceDate
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key02Flag = 'Y'
     C                   ENDIF
      * Compiler
     C                   IF        PCompiler <> '*SAME'
     C                   EVAL      Compiler = PCompiler
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key03Flag = 'Y'
     C                   ENDIF
      * Object control level
     C                   IF        PObjLvl <> '*SAME'
     C                   EVAL      ObjLvl = PObjLvl
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key04Flag = 'Y'
     C                   ENDIF
      * Licensed program
     C                   IF        PLicPgm <> '*SAME'
     C                   EVAL      LicPgm = PLicPgm
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key05Flag = 'Y'
     C                   ENDIF
      * PTF
     C                   IF        PPTF <> '*SAME'
     C                   EVAL      PTF = PPTF
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key06Flag = 'Y'
     C                   ENDIF
      * APAR
     C                   IF        PAPAR <> '*SAME'
     C                   EVAL      APAR = PAPAR
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key07Flag = 'Y'
     C                   ENDIF
      * User-defined attribute
     C                   IF        PUsrDfnAtr <> '*SAME'
     C                   EVAL      UsrDfnAtr = PUsrDfnAtr
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key09Flag = 'Y'
     C                   ENDIF
      * Text
     C                   IF        PText <> '*SAME'
     C                   EVAL      Text = PText
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key10Flag = 'Y'
     C                   ENDIF
      * Days used count
     C                   IF        PUseCount <> '*SAME'
     C                   EVAL      UseCount = '1'
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key11Flag = 'Y'
     C                   ENDIF
      * Product option load ID
     C                   IF        PPrdOptLdId <> '*S  '
     C                   EVAL      PrdOptLdId = PPrdOptLdId
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key12Flag = 'Y'
     C                   ENDIF
      * Product option ID
     C                   IF        PPrdOptId <> '*S  '
     C                   EVAL      PrdOptId = PPrdOptId
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key13Flag = 'Y'
     C                   ENDIF
      * Component ID
     C                   IF        PCmpId <> '*S  '
     C                   EVAL      CmpId = PCmpId
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key14Flag = 'Y'
     C                   ENDIF
      * Last used date
     C                   IF        PUseDate <> '*SAME'
     C                   EVAL      UseDate = '1'
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key15Flag = 'Y'
     C                   ENDIF
      * Changed date and time stamp
     C                   IF        PChgDate <> '*SAME'
     C                   EVAL      ChgDate = '1'
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key16Flag = 'Y'
     C                   ENDIF
      * Member's days used count
     C                   IF        PMbrUseCount <> '*SAME'
     C                   EVAL      MbrUseCount = PMbrUseCount
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key17Flag = 'Y'
     C                   ENDIF
      *
     C                   IF        NumberOfRecs <> 0
     C                   EVAL      AllowChg = '0'
     C                   EVAL      NumberOfRecs = NumberOfRecs + 1
     C                   EVAL      Key08Flag = 'Y'
     C                   ENDIF
      *
      * Check if any paramters need to be changed and build string to pass
      *  to QLICOBJD.
     C                   IF        NumberOfRecs <> 0
     C                   EVAL      ChgObjInf = NumberOfRecsDS
     C                   EVAL      Offset = Offset + 4
      *
     C                   IF        Key01Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key01DS)) =
     C                             Key01DS
     C                   EVAL      Offset = Offset + %LEN(Key01DS)
     C                   ENDIF
      *
     C                   IF        Key02Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key02DS)) =
     C                             Key02DS
     C                   EVAL      Offset = Offset + %LEN(Key02DS)
     C                   ENDIF
      *
     C                   IF        Key03Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key03DS)) =
     C                             Key03DS
     C                   EVAL      Offset = Offset + %LEN(Key03DS)
     C                   ENDIF
      *
     C                   IF        Key04Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key04DS)) =
     C                             Key04DS
     C                   EVAL      Offset = Offset + %LEN(Key04DS)
     C                   ENDIF
      *
     C                   IF        Key05Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key05DS)) =
     C                             Key05DS
     C                   EVAL      Offset = Offset + %LEN(Key05DS)
     C                   ENDIF
      *
     C                   IF        Key06Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key06DS)) =
     C                             Key06DS
     C                   EVAL      Offset = Offset + %LEN(Key06DS)
     C                   ENDIF
      *
     C                   IF        Key07Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key07DS)) =
     C                             Key07DS
     C                   EVAL      Offset = Offset + %LEN(Key07DS)
     C                   ENDIF
      *
     C                   IF        Key08Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key08DS)) =
     C                             Key08DS
     C                   EVAL      Offset = Offset + %LEN(Key08DS)
     C                   ENDIF
      *
     C                   IF        Key09Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key09DS)) =
     C                             Key09DS
     C                   EVAL      Offset = Offset + %LEN(Key09DS)
     C                   ENDIF
      *
     C                   IF        Key10Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key10DS)) =
     C                             Key10DS
     C                   EVAL      Offset = Offset + %LEN(Key10DS)
     C                   ENDIF
      *
     C                   IF        Key11Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key11DS)) =
     C                             Key11DS
     C                   EVAL      Offset = Offset + %LEN(Key11DS)
     C                   ENDIF
      *
     C                   IF        Key12Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key12DS)) =
     C                             Key12DS
     C                   EVAL      Offset = Offset + %LEN(Key12DS)
     C                   ENDIF
      *
     C                   IF        Key13Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key13DS)) =
     C                             Key13DS
     C                   EVAL      Offset = Offset + %LEN(Key13DS)
     C                   ENDIF
      *
     C                   IF        Key14Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key14DS)) =
     C                             Key14DS
     C                   EVAL      Offset = Offset + %LEN(Key14DS)
     C                   ENDIF
      *
     C                   IF        Key15Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key15DS)) =
     C                             Key15DS
     C                   EVAL      Offset = Offset + %LEN(Key15DS)
     C                   ENDIF
      *
     C                   IF        Key16Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key16DS)) =
     C                             Key16DS
     C                   EVAL      Offset = Offset + %LEN(Key16DS)
     C                   ENDIF
      *
     C                   IF        Key17Flag = 'Y'
     C                   EVAL      %SUBST(ChgObjInf:Offset:%LEN(Key17DS)) =
     C                             Key17DS
     C                   EVAL      Offset = Offset + %LEN(Key17DS)
     C                   ENDIF
      *
     C                   CALL      'QLICOBJD'
     C                   PARM                    ReturnLib
     C                   PARM                    ObjectAndLib
     C                   PARM                    ObjectType
     C                   PARM                    ChgObjInf
     C                   PARM                    ErrorCode
      *
      * Check exception message from call and pass back to CL.
     C                   EVAL      PException = Exception
     C                   EVAL      PExceptionData = ExceptionData
      *
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
