     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Structured MT940 Mapping Details Display 2')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  A6046002  - Structured MT940 Mapping Details Screen 2        *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2023                 *
      *                                                               *
      *  Last Amend No. BA6026 *CREATE     Date 18Jan23               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.      *
      *           Include GSH046, GSH046CC1, GSH046CC2                *
      *                                                               *
      *****************************************************************

      *
      ** +--------------------------------------+
      ** ¦ File and Screen Formats              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
      *
      ** Structured MT940 Mapping details rtv
     FA6M940L0  IF   E           K DISK
     F                                     RENAME(A6M940D0:A6M940DR)
      *
      ** Structured MT940 Mapping details upd
     FA6M940TD  O    E             DISK
      *
      ** Structured MT940 Mapping Header upd
     FA6H940TD  O    E             DISK
      *
      ** SWIFT Codewords details rtv
     FA6CODEL0  IF   E           K DISK
      *
      ** Maintenance Screen Display
     FA6046002DFCF   E             WORKSTN INFSR(*PSSR)
     F

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D NAR1            S              6    DIM(24) CTDATA PERRCD(1)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS For Bank Details ICD retrieval
      *
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** External DS For Network ICD details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Second DS for access programs, Long Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, Long Data Structure
      *
     DPSDS            SDS

      ** Procedure name
     D PSProcName        *PROC
      ** Job name
     D PSJobName             244    253
      ** User name
     D PSUser                254    263

     D/COPY ZACPYSRC,STD_D_SPEC

     D DSLine          DS
     D  SSwcd                  1     11
     D  SNar1                 12     17
     D  SLen1                 18     19
     D  SSlsh                 20     20
     D  SNar2                 21     26
     D  SLen2                 27     28
     D  SNar3                 29     34
     D  SLen3                 35     36
     D  SNar4                 37     42
     D  SLen4                 43     44
     D  SOmit                 45     45
     D  SNewl                 46     46

     D DSNarr          DS
     D  PnarW                  1      4
     D  Nm12                   5      6
     D  Num1                   5      5
     D  Num2                   6      6

      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *
     D RetCode         S              7A
      *
     D PJob            S             10
     D PUser           S             10
      *
     D ScrLvl          S              1A   INZ('1')
     D ValErr          S              1  0 INZ(1)
     D TotLen          S              5  0 INZ(0)
     D WRun            S              1    INZ(*Blanks)
     D ModId           S              2    INZ('FT')
     D @Z              S              2  0
      *
     D ZAPGM           S             10    INZ(*Blanks)
     D ZAPGRL          S              5    INZ(*Blanks)
     D ZAMSID          S              7    INZ(*Blanks)
     D ZAMSGF          S             10    INZ(*Blanks)
     D ZAMSDA          S            132    INZ(*Blanks)
     D ZAMSTP          S              7    INZ(*Blanks)
      *
     D MapCount        S              2S 0
      *
      ** Array to return characters that contain '/'
     D SArr            S              2  0 DIM(11)
      *
      ** Array to hold narratives
     D NarrArr         S              6A   DIM(88)
      *
     D PSysVal01       S             20A   INZ('BA6026TotMaxMsgLgth')
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
     D WSysVal01       S              3P 0
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtrn             7
     C                   PARM                    PSwid             4
     C                   PARM                    PTrat             5
     C                   PARM                    PActn             1

     C                   Exsr      Init

      ** Display Details Screen (Input / Display)
     C     ScreenFlow    Tag
     C                   Eval      ValErr = 1

     C                   Dow       *INKL = *OFF and ValErr = 1
     C                             and *INKC = *Off

     C                   Select

     C                   When      PActn = 'E'
     C                   If        *INKL = *Off
     C                             and *INKC = *Off
     C                   If        ScrLvl <> 'F'
     C                   Exsr      RstInd
     C                   Exsr      DspDetails
     C                   Else
     C                   Eval      ValErr = 0
     C                   Endif
     C                   Endif
     C                   If        *INKL = *On
     C                   Select
     C                   When      ScrLvl = '1'
     C                   Eval      ValErr = 0
     C                   When      ScrLvl = '2'
     C                   Eval      ScrLvl = '1'
     C                   Endsl
     C                   If        ValErr <> 0
     C                   Exsr      RstInd
     C                   Exsr      DspDetails
     C                   Endif
     C                   Endif

     C                   When      PActn = 'I' or PActn = 'A'
     C                   Exsr      InpValCode
     C                   Endsl

     C                   Enddo

     C                   If        *INKL = *Off
     C                             and *INKC = *Off

     C                   If        PActn = 'E'
     C                   GOTO      EndPgm
     C                   Endif

     C                   If        PActn = 'A' or PActn = 'I'
     C                   Exsr      SrUpdats
     C                   Endif

     C                   Endif

     C     EndPgm        TAG

     C                   If        *INKC = *On
     C                   Eval      PRtrn = 'Y2U9999'
     C                   Endif

     C                   Eval      *INLR = *ON
     C                   Return

      /EJECT
      *****************************************************************
      *                                                               *
      * DspDetails - Display fields for user selected action          *
      *                                                               *
      *****************************************************************
      *
     C     DspDetails    BEGSR
      *
     C                   Select
     C                   When      ScrLvl = '1'
     C                   Write     A6046002F1
     C                   Write     A6046002M0
     C                   Exfmt     A6046002D1
     C                   When      ScrLvl = '2'
     C                   Write     A6046002F1
     C                   Write     A6046002M0
     C                   Exfmt     A6046002D2
     C                   Endsl

     C                   If        *InkL = *Off
     C                             and *Inkc = *Off
     C                   Select
     C                   When      ScrLvl = '1'
     C                             and MapCount > 15
     C                   Eval      ScrLvl = '2'
     C                   Other
     C                   Eval      ScrLvl = 'F'
     C                   Endsl
     C                   Endif

     C                   Exsr      ClrMsgQue

     C     DspDetailsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Init - Initialise screen header data                          *
      *                                                               *
      *****************************************************************
      *
     C     Init          BEGSR
      *
     C                   Eval      ZAPGM = PSProcName
     C                   Eval      SPGM = PSProcName
     C                   Eval      DDWID = PSJobName
     C                   Eval      DDUSER = PSUser

     C                   Exsr      ClrMsgQue

     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE                         ************
     C                   Movel     '901'         DBASE                          * DBERR 901*
     C                   Movel     @OPTN         DBKEY                          ************
     C                   Exsr      *PSSR
     C                   Endif

      * Get System Value - Maximum Total Message Length

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM                    PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10

     C                   If        PRtCd = *BLANKS
     C                   MOVEL     PCurSet01     BA6026MaxLen      3 0
     C                   Else

     C                   If        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 902
     C                   EVAL      DBKey = PSysVal01
     C                   EVAL      DBPgm = 'A6046002'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   Endif

     C                   If        PActn = 'E'
     C                   Move      *On           *In21
     C                   else
     C                   Move      *Off          *In21
     C                   Endif

     C/exec SQL
     C+ SELECT COUNT(*) into: MapCount from A6M940TD
     C+ where MPSWID = :PSwid and MPTRAT = :PTrat
     C/end-exec

     C                   Call      'AONWRKR1'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY'        @Optn
     C                   Parm      'SWIFT'       @Nwrk             6
     C     SDNWRK        Parm      SDNWRK        DSLDY

     C                   Z-Add     0             MaxNo             5 0
     C     EDNOLN        Mult      EDNCLN        MaxNo

     C     K1M940        KList
     C                   KFld                    PSwid
     C                   KFld                    PTrat

     C     KCODEW        KList
     C                   KFld                    ValSSwcd
     C                   KFld                    ModId

     C                   If        PActn = 'E' or PACTN = 'A'
     C                   Exsr      RtvDetails
     C                   Endif
     C                   If        PActn = 'I'
     C                   Exsr      InzDetails
     C                   Endif

     C     InitE         ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * InpValCode - Validate Amend/Insert screens                    *
      *                                                               *
      *****************************************************************
      *
     C     InpValCode    BEGSR

     C                   Eval      ValErr = 1

     C                   DoW       ValErr = 1
     C                             and *INKC = *OFF

     C                   Select

     C                   When      ScrLvl = '1'
     C                   Eval      *Inkl = *Off
     C                   Eval      *Inkc = *Off
     C                   Write     A6046002F1
     C                   Write     A6046002M0
     C                   Exfmt     A6046002D1
     C                   Exsr      ClrMsgQue
     C                   Exsr      RstInd
     C                   If        *Inkl = *Off
     C                             and *Inkc = *Off
     C                   Exsr      ValScreen1
     C                   Endif

     C                   When      ScrLvl = '2'
     C                   Eval      *Inkl = *Off
     C                   Eval      *Inkc = *Off
     C                   Write     A6046002F1
     C                   Write     A6046002M0
     C                   Exfmt     A6046002D2
     C                   Exsr      ClrMsgQue
     C                   Exsr      RstInd
     C                   If        *Inkl = *Off
     C                             and *Inkc = *Off
     C                   Exsr      ValScreen2
     C                   Endif

     C                   Endsl

     C                   If        *Inkl = *On
     C                   Select
     C                   When      ScrLvl = '1'
     C                   Eval      ValErr = 0
     C                   When      ScrLvl = '2'
     C                   Eval      ScrLvl = '1'
     C                   Endsl
     C                   Endif

     C                   Enddo

     C     InpValCodeE   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * ValScreen1 - Validate Screen 1                                *
      *                                                               *
      *****************************************************************
      *
     C     ValScreen1    BEGSR

     C                   Move      *Off          *In60
     C                   Eval      ValErr = 1
     C                   Eval      TotLen = 0
     C                   Eval      NarrArr = *Blanks
     C                   Eval      @Z = 1

     C                   Move      *Blanks       DSLin1           46
     C                   Move      *Blanks       DSLin2           46
     C                   Move      *Blanks       DSLin3           46
     C                   Move      *Blanks       DSLin4           46
     C                   Move      *Blanks       DSLin5           46
     C                   Move      *Blanks       DSLin6           46
     C                   Move      *Blanks       DSLin7           46
     C                   Move      *Blanks       DSLin8           46
     C                   Move      *Blanks       DSLin9           46
     C                   Move      *Blanks       DSLin10          46
     C                   Move      *Blanks       DSLin11          46
     C                   Move      *Blanks       DSLin12          46
     C                   Move      *Blanks       DSLin13          46
     C                   Move      *Blanks       DSLin14          46
     C                   Move      *Blanks       DSLin15          46
      *
      ** Line 1
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_1       SSWCD            11
     C                   Movel     SNAR1_1       SNAR1             6
     C                   Movel     SLEN1_1       SLEN1             2
     C                   Movel     SSLSH_1       SSLSH             1
     C                   Movel     SNAR2_1       SNAR2             6
     C                   Movel     SLEN2_1       SLEN2             2
     C                   Movel     SNAR3_1       SNAR3             6
     C                   Movel     SLEN3_1       SLEN3             2
     C                   Movel     SNAR4_1       SNAR4             6
     C                   Movel     SLEN4_1       SLEN4             2
     C                   Movel     SOMIT_1       SOMIT             1
     C                   Movel     SNEWL_1       SNEWL             1
     C                   Move      DSLine        DSLin1
      *
     C                   If        DSLin1 = *Blanks
     C                   Move      *On           *IN36
     C                   Move      *On           *IN60
     C                   Movel     'A6X4606'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN36
     C                   Endif
     C                   Endif
      *
      ** Line 2
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_2       SSWCD
     C                   Movel     SNAR1_2       SNAR1
     C                   Movel     SLEN1_2       SLEN1
     C                   Movel     SSLSH_2       SSLSH
     C                   Movel     SNAR2_2       SNAR2
     C                   Movel     SLEN2_2       SLEN2
     C                   Movel     SNAR3_2       SNAR3
     C                   Movel     SLEN3_2       SLEN3
     C                   Movel     SNAR4_2       SNAR4
     C                   Movel     SLEN4_2       SLEN4
     C                   Movel     SOMIT_2       SOMIT
     C                   Movel     SNEWL_2       SNEWL
     C                   Move      DSLine        DSLin2
      *
     C                   If        DSLin2 <> *Blanks
     C                             and DSLin1 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In37
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN37
     C                   Endif
     C                   Endif
      *
      ** Line 3
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_3       SSWCD
     C                   Movel     SNAR1_3       SNAR1
     C                   Movel     SLEN1_3       SLEN1
     C                   Movel     SSLSH_3       SSLSH
     C                   Movel     SNAR2_3       SNAR2
     C                   Movel     SLEN2_3       SLEN2
     C                   Movel     SNAR3_3       SNAR3
     C                   Movel     SLEN3_3       SLEN3
     C                   Movel     SNAR4_3       SNAR4
     C                   Movel     SLEN4_3       SLEN4
     C                   Movel     SOMIT_3       SOMIT
     C                   Movel     SNEWL_3       SNEWL
     C                   Move      DSLine        DSLin3
      *
     C                   If        DSLin3 <> *Blanks
     C                             and DSLin2 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In38
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN38
     C                   Endif
     C                   Endif
      *
      ** Line 4
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_4       SSWCD
     C                   Movel     SNAR1_4       SNAR1
     C                   Movel     SLEN1_4       SLEN1
     C                   Movel     SSLSH_4       SSLSH
     C                   Movel     SNAR2_4       SNAR2
     C                   Movel     SLEN2_4       SLEN2
     C                   Movel     SNAR3_4       SNAR3
     C                   Movel     SLEN3_4       SLEN3
     C                   Movel     SNAR4_4       SNAR4
     C                   Movel     SLEN4_4       SLEN4
     C                   Movel     SOMIT_4       SOMIT
     C                   Movel     SNEWL_4       SNEWL
     C                   Move      DSLine        DSLin4
      *
     C                   If        DSLin4 <> *Blanks
     C                             and DSLin3 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In39
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN39
     C                   Endif
     C                   Endif
      *
      ** Line 5
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_5       SSWCD
     C                   Movel     SNAR1_5       SNAR1
     C                   Movel     SLEN1_5       SLEN1
     C                   Movel     SSLSH_5       SSLSH
     C                   Movel     SNAR2_5       SNAR2
     C                   Movel     SLEN2_5       SLEN2
     C                   Movel     SNAR3_5       SNAR3
     C                   Movel     SLEN3_5       SLEN3
     C                   Movel     SNAR4_5       SNAR4
     C                   Movel     SLEN4_5       SLEN4
     C                   Movel     SOMIT_5       SOMIT
     C                   Movel     SNEWL_5       SNEWL
     C                   Move      DSLine        DSLin5
      *
      *
     C                   If        DSLin5 <> *Blanks
     C                             and DSLin4 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In40
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN40
     C                   Endif
     C                   Endif
      *
      ** Line 6
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_6       SSWCD
     C                   Movel     SNAR1_6       SNAR1
     C                   Movel     SLEN1_6       SLEN1
     C                   Movel     SSLSH_6       SSLSH
     C                   Movel     SNAR2_6       SNAR2
     C                   Movel     SLEN2_6       SLEN2
     C                   Movel     SNAR3_6       SNAR3
     C                   Movel     SLEN3_6       SLEN3
     C                   Movel     SNAR4_6       SNAR4
     C                   Movel     SLEN4_6       SLEN4
     C                   Movel     SOMIT_6       SOMIT
     C                   Movel     SNEWL_6       SNEWL
     C                   Move      DSLine        DSLin6
      *
      *
     C                   If        DSLin6 <> *Blanks
     C                             and DSLin5 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In41
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN41
     C                   Endif
     C                   Endif
      *
      ** Line 7
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_7       SSWCD
     C                   Movel     SNAR1_7       SNAR1
     C                   Movel     SLEN1_7       SLEN1
     C                   Movel     SSLSH_7       SSLSH
     C                   Movel     SNAR2_7       SNAR2
     C                   Movel     SLEN2_7       SLEN2
     C                   Movel     SNAR3_7       SNAR3
     C                   Movel     SLEN3_7       SLEN3
     C                   Movel     SNAR4_7       SNAR4
     C                   Movel     SLEN4_7       SLEN4
     C                   Movel     SOMIT_7       SOMIT
     C                   Movel     SNEWL_7       SNEWL
     C                   Move      DSLine        DSLin7
      *
      *
     C                   If        DSLin7 <> *Blanks
     C                             and DSLin6 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In42
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *In42
     C                   Endif
     C                   Endif
      *
      ** Line 8
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_8       SSWCD
     C                   Movel     SNAR1_8       SNAR1
     C                   Movel     SLEN1_8       SLEN1
     C                   Movel     SSLSH_8       SSLSH
     C                   Movel     SNAR2_8       SNAR2
     C                   Movel     SLEN2_8       SLEN2
     C                   Movel     SNAR3_8       SNAR3
     C                   Movel     SLEN3_8       SLEN3
     C                   Movel     SNAR4_8       SNAR4
     C                   Movel     SLEN4_8       SLEN4
     C                   Movel     SOMIT_8       SOMIT
     C                   Movel     SNEWL_8       SNEWL
     C                   Move      DSLine        DSLin8
      *
      *
     C                   If        DSLin8 <> *Blanks
     C                             and DSLin7 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In43
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN43
     C                   Endif
     C                   Endif
      *
      ** Line 9
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_9       SSWCD
     C                   Movel     SNAR1_9       SNAR1
     C                   Movel     SLEN1_9       SLEN1
     C                   Movel     SSLSH_9       SSLSH
     C                   Movel     SNAR2_9       SNAR2
     C                   Movel     SLEN2_9       SLEN2
     C                   Movel     SNAR3_9       SNAR3
     C                   Movel     SLEN3_9       SLEN3
     C                   Movel     SNAR4_9       SNAR4
     C                   Movel     SLEN4_9       SLEN4
     C                   Movel     SOMIT_9       SOMIT
     C                   Movel     SNEWL_9       SNEWL
     C                   Move      DSLine        DSLin9
      *
      *
     C                   If        DSLin9 <> *Blanks
     C                             and DSLin8 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In44
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN44
     C                   Endif
     C                   Endif
      *
      ** Line 10
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_10      SSWCD
     C                   Movel     SNAR1_10      SNAR1
     C                   Movel     SLEN1_10      SLEN1
     C                   Movel     SSLSH_10      SSLSH
     C                   Movel     SNAR2_10      SNAR2
     C                   Movel     SLEN2_10      SLEN2
     C                   Movel     SNAR3_10      SNAR3
     C                   Movel     SLEN3_10      SLEN3
     C                   Movel     SNAR4_10      SNAR4
     C                   Movel     SLEN4_10      SLEN4
     C                   Movel     SOMIT_10      SOMIT
     C                   Movel     SNEWL_10      SNEWL
     C                   Move      DSLine        DSLin10
      *
      *
     C                   If        DSLin10 <> *Blanks
     C                             and DSLin9 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In45
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN45
     C                   Endif
     C                   Endif
      *
      ** Line 11
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_11      SSWCD
     C                   Movel     SNAR1_11      SNAR1
     C                   Movel     SLEN1_11      SLEN1
     C                   Movel     SSLSH_11      SSLSH
     C                   Movel     SNAR2_11      SNAR2
     C                   Movel     SLEN2_11      SLEN2
     C                   Movel     SNAR3_11      SNAR3
     C                   Movel     SLEN3_11      SLEN3
     C                   Movel     SNAR4_11      SNAR4
     C                   Movel     SLEN4_11      SLEN4
     C                   Movel     SOMIT_11      SOMIT
     C                   Movel     SNEWL_11      SNEWL
     C                   Move      DSLine        DSLin11
      *
      *
     C                   If        DSLin11 <> *Blanks
     C                             and DSLin10 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In46
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN46
     C                   Endif
     C                   Endif
      *
      ** Line 12
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_12      SSWCD
     C                   Movel     SNAR1_12      SNAR1
     C                   Movel     SLEN1_12      SLEN1
     C                   Movel     SSLSH_12      SSLSH
     C                   Movel     SNAR2_12      SNAR2
     C                   Movel     SLEN2_12      SLEN2
     C                   Movel     SNAR3_12      SNAR3
     C                   Movel     SLEN3_12      SLEN3
     C                   Movel     SNAR4_12      SNAR4
     C                   Movel     SLEN4_12      SLEN4
     C                   Movel     SOMIT_12      SOMIT
     C                   Movel     SNEWL_12      SNEWL
     C                   Move      DSLine        DSLin12
      *
      *
     C                   If        DSLin12 <> *Blanks
     C                             and DSLin11 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In47
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN47
     C                   Endif
     C                   Endif
      *
      ** Line 13
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_13      SSWCD
     C                   Movel     SNAR1_13      SNAR1
     C                   Movel     SLEN1_13      SLEN1
     C                   Movel     SSLSH_13      SSLSH
     C                   Movel     SNAR2_13      SNAR2
     C                   Movel     SLEN2_13      SLEN2
     C                   Movel     SNAR3_13      SNAR3
     C                   Movel     SLEN3_13      SLEN3
     C                   Movel     SNAR4_13      SNAR4
     C                   Movel     SLEN4_13      SLEN4
     C                   Movel     SOMIT_13      SOMIT
     C                   Movel     SNEWL_13      SNEWL
     C                   Move      DSLine        DSLin13
      *
      *
     C                   If        DSLin13 <> *Blanks
     C                             and DSLin12 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In48
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN48
     C                   Endif
     C                   Endif
      *
      ** Line 14
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_14      SSWCD
     C                   Movel     SNAR1_14      SNAR1
     C                   Movel     SLEN1_14      SLEN1
     C                   Movel     SSLSH_14      SSLSH
     C                   Movel     SNAR2_14      SNAR2
     C                   Movel     SLEN2_14      SLEN2
     C                   Movel     SNAR3_14      SNAR3
     C                   Movel     SLEN3_14      SLEN3
     C                   Movel     SNAR4_14      SNAR4
     C                   Movel     SLEN4_14      SLEN4
     C                   Movel     SOMIT_14      SOMIT
     C                   Movel     SNEWL_14      SNEWL
     C                   Move      DSLine        DSLin14
      *
      *
     C                   If        DSLin14 <> *Blanks
     C                             and DSLin13 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In49
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN49
     C                   Endif
     C                   Endif
      *
      ** Line 15
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_15      SSWCD
     C                   Movel     SNAR1_15      SNAR1
     C                   Movel     SLEN1_15      SLEN1
     C                   Movel     SSLSH_15      SSLSH
     C                   Movel     SNAR2_15      SNAR2
     C                   Movel     SLEN2_15      SLEN2
     C                   Movel     SNAR3_15      SNAR3
     C                   Movel     SLEN3_15      SLEN3
     C                   Movel     SNAR4_15      SNAR4
     C                   Movel     SLEN4_15      SLEN4
     C                   Movel     SOMIT_15      SOMIT
     C                   Movel     SNEWL_15      SNEWL
     C                   Move      DSLine        DSLin15
      *
      *
     C                   If        DSLin15 <> *Blanks
     C                             and DSLin14 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In50
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN50
     C                   Endif
     C                   Endif
      *
     C                   If        *In60 = *Off
     C                             and DSLin16 = *Blanks
     C                   If        Totlen > MaxNo
     C                             or Totlen > BA6026MaxLen
     C                   Movel     'A6X4616'     ZAMSID
     C                   Movel     'TOTAL'       ZAMSDA
     C                   Move      *On           *In36
     C                   If        DSLin2 <> *Blanks
     C                   Move      *On           *In37
     C                   Endif
     C                   If        DSLin3 <> *Blanks
     C                   Move      *On           *In38
     C                   Endif
     C                   If        DSLin4 <> *Blanks
     C                   Move      *On           *In39
     C                   Endif
     C                   If        DSLin5 <> *Blanks
     C                   Move      *On           *In40
     C                   Endif
     C                   If        DSLin6 <> *Blanks
     C                   Move      *On           *In41
     C                   Endif
     C                   If        DSLin7 <> *Blanks
     C                   Move      *On           *In42
     C                   Endif
     C                   If        DSLin8 <> *Blanks
     C                   Move      *On           *In43
     C                   Endif
     C                   If        DSLin9 <> *Blanks
     C                   Move      *On           *In44
     C                   Endif
     C                   If        DSLin10 <> *Blanks
     C                   Move      *On           *In45
     C                   Endif
     C                   If        DSLin11 <> *Blanks
     C                   Move      *On           *In46
     C                   Endif
     C                   If        DSLin12 <> *Blanks
     C                   Move      *On           *In47
     C                   Endif
     C                   If        DSLin13 <> *Blanks
     C                   Move      *On           *In48
     C                   Endif
     C                   If        DSLin14 <> *Blanks
     C                   Move      *On           *In49
     C                   Endif
     C                   If        DSLin15 <> *Blanks
     C                   Move      *On           *In50
     C                   Endif
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        *In60 = *Off
     C                   If        DSLin15 <> *Blanks
     C                   Eval      ScrLvl = '2'
     C                   Else
     C                   Write     A6046002F1
     C                   Write     A6046002M0
     C                   Write     A6046002D1
     C                   Eval      ValErr = 0
     C                   Endif
     C                   Endif
      *
     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * ValLine - Validate Line                                       *
      *                                                               *
      *****************************************************************
      *
     C     ValLine       BEGSR
      *
     C                   Move      'N'           Error             1
      *
     C                   If        DSLINE <> *Blanks
      *
      ** Validate SWIFT Codeword
      *
     C                   If        SSWCD   = *Blanks
     C                   Movel     'A6X4608'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
      *
     C                   Else
      *
     C     '/'           Scan      SSWCD         SArr
      *
      ** If more than 1 codeword, split in two and check each individually
      *
     C                   If        SArr(3) <> 0
      *
     C                   Move      *Blanks       ValSSwcd         20
     C     SArr(2)       Subst     SSWCD:1       ValSSwcd
     C     KCodeW        Chain     A6CODEL0                           01
     C                   If        *In01 = *On
     C                   Movel     'A6X4609'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
      *
     C                   Else
      *
     C                   Z-Add     0             VarSubst          2 0
     C                   Move      *Blanks       ValSSwcd
     C                   Eval      VarSubst = SArr(3) - Sarr(2) + 1
     C     VarSubst      Subst     SSWCD:SArr(2) ValSSwcd
     C     KCodeW        Chain     A6CODEL0                           01
     C                   If        *In01 = *On
     C                   Movel     'A6X4609'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
      ** One codeword only
      *
     C                   Else
     C                   Move      *Blanks       ValSSwcd
     C                   MoveL     SSwcd         ValSSwcd
     C     KCodeW        Chain     A6CODEL0                           01
     C                   If        *In01 = *On
     C                   Movel     'A6X4609'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** Validate Narrative 1
      *
     C                   If        SNAR1   = *Blanks
     C                   Movel     'A6X4610'     ZAMSID
     C                   Movel     'SNAR1'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
      *
     C                   Else
     C     SNAR1         Lookup    Nar1                                   98
     C                   If        *In98 = *Off
     C                   Movel     'A6X4611'     ZAMSID
     C                   Movel     'SNAR1'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C     SNar1         Lookup    NarrArr                                98
     C                   If        *In98 = *On
     C                   Movel     'A6X4618'     ZAMSID
     C                   Movel     'SNAR1'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   MoveL     SNar1         NarrArr(@Z)
     C                   Add       1             @Z
     C                   Endif
     C                   Endif
      *
      ** Validate Length 1
      *
     C                   If        SLEN1   = *Blanks
     C                             or SLEN1 = '00'
     C                   Movel     'A6X4612'     ZAMSID
     C                   Movel     'SLEN1'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
      *
     C                   Else
     C                   Z-Add     0             NumLen            2 0
     C                   Move      SLen1         NumLen
     C                   If        NumLen < 1
     C                             Or NumLen > 35
     C                   Movel     'A6X4613'     ZAMSID
     C                   Movel     'SLEN1'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
      ** Validate Slash
      *
     C                   If        SSLSH  <> *Blanks
     C                             and SSLSH <> 'N'
     C                             and SSLSH <> 'Y'
     C                   Movel     'A6X4614'     ZAMSID
     C                   Movel     'SSLSH'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
      *
      ** Validate Narrative 2
      *
     C                   If        SNAR2 <> *Blanks
     C     SNAR2         Lookup    Nar1                                   98
     C                   If        *In98 = *Off
     C                   Movel     'A6X4611'     ZAMSID
     C                   Movel     'SNAR2'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C     SNar2         Lookup    NarrArr                                98
     C                   If        *In98 = *On
     C                   Movel     'A6X4618'     ZAMSID
     C                   Movel     'SNAR2'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   MoveL     SNar2         NarrArr(@Z)
     C                   Add       1             @Z
     C                   Endif
     C                   Endif
      *
      ** Validate Length 2
      *
     C                   If        SNAR2 <> *Blanks
     C                   If        SLEN2 = *Blanks or SLEN2 = '00'
     C                   Movel     'A6X4615'     ZAMSID
     C                   Movel     'SLEN2'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        SNAR2 = *Blanks
     C                   If        SLEN2 <> *Blanks and SLEN2 <> '00'
     C                   Movel     'A6X4615'     ZAMSID
     C                   Movel     'SLEN2'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C*                  Write     A6046002M0
     C                   Endif
     C                   Endif
      *
     C                   If        SNAR2 <> *Blanks
     C                   Z-Add     0             NumLen
     C                   Move      SLen2         NumLen
     C                   If        NumLen < 1
     C                             Or NumLen > 35
     C                   Movel     'A6X4613'     ZAMSID
     C                   Movel     'SLEN2'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
      ** Validate Narrative 3
      *
     C                   If        SNAR3 <> *Blanks
     C                   If        SNAR2 = *Blanks
     C                   Movel     'A6X4617'     ZAMSID
     C                   Movel     'SNAR3'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C     SNAR3         Lookup    Nar1                                   98
     C                   If        *In98 = *Off
     C                   Movel     'A6X4611'     ZAMSID
     C                   Movel     'SNAR3'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C     SNar3         Lookup    NarrArr                                98
     C                   If        *In98 = *On
     C                   Movel     'A6X4618'     ZAMSID
     C                   Movel     'SNAR3'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   MoveL     SNar3         NarrArr(@Z)
     C                   Add       1             @Z
     C                   Endif
     C                   Endif
     C                   Endif
      *
      ** Validate Length 3
      *
     C                   If        SNAR3 <> *Blanks
     C                   If        SLEN3 = *Blanks or SLEN3 = '00'
     C                   Movel     'A6X4615'     ZAMSID
     C                   Movel     'SLEN3'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        SNAR3 = *Blanks
     C                   If        SLEN3 <> *Blanks and SLEN3 <> '00'
     C                   Movel     'A6X4615'     ZAMSID
     C                   Movel     'SLEN3'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        SNAR3 <> *Blanks
     C                   Z-Add     0             NumLen
     C                   Move      SLen3         NumLen
     C                   If        NumLen < 1
     C                             Or NumLen > 35
     C                   Movel     'A6X4613'     ZAMSID
     C                   Movel     'SLEN3'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
      ** Validate Narrative 4
      *
     C                   If        SNAR4 <> *Blanks
     C                   If        SNAR3 = *Blanks
     C                   Movel     'A6X4617'     ZAMSID
     C                   Movel     'SNAR4'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C     SNAR4         Lookup    Nar1                                   98
     C                   If        *In98 = *Off
     C                   Movel     'A6X4611'     ZAMSID
     C                   Movel     'SNAR4'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C     SNar4         Lookup    NarrArr                                98
     C                   If        *In98 = *On
     C                   Movel     'A6X4618'     ZAMSID
     C                   Movel     'SNAR4'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   MoveL     SNar4         NarrArr(@Z)
     C                   Add       1             @Z
     C                   Endif
     C                   Endif
     C                   Endif
      *
      ** Validate Length 4
      *
     C                   If        SNAR4 <> *Blanks
     C                   If        SLEN4 = *Blanks or SLEN4 = '00'
     C                   Movel     'A6X4615'     ZAMSID
     C                   Movel     'SLEN4'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        SNAR4 = *Blanks
     C                   If        SLEN4 <> *Blanks and SLEN4 <> '00'
     C                   Movel     'A6X4615'     ZAMSID
     C                   Movel     'SLEN4'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        SNAR4 <> *Blanks
     C                   Z-Add     0             NumLen
     C                   Move      SLen4         NumLen
     C                   If        NumLen < 1
     C                             Or NumLen > 35
     C                   Movel     'A6X4613'     ZAMSID
     C                   Movel     'SLEN4'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
      ** Validate Omit
      *
     C                   If        SOmit  <> *Blanks
     C                             and SOmit <> 'N'
     C                             and SOmit <> 'Y'
     C                   Movel     'A6X4619'     ZAMSID
     C                   Movel     'SOMIT'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
      *
      ** Validate New Line
      *
     C                   If        SNewL  <> *Blanks
     C                             and SNewL <> 'N'
     C                             and SNewL <> 'Y'
     C                   Movel     'A6X4620'     ZAMSID
     C                   Movel     'SNEWL'       ZAMSDA
     C                   Move      'Y'           Error
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif

      ** Calculate length of Line

     C                   If        Error = 'N'

     C     ' '           Scan      SSWCD         SwcdLen           2 0
     C                   If        SwcdLen = 0
     C                   Z-Add     12            SwcdLen
     C                   Endif

     C                   Z-Add     0             LineLen1          5 0
     C                   Z-Add     0             SlshLen           1 0
     C                   Z-Add     0             NLen1             2 0
     C                   Z-Add     0             NLen2             2 0
     C                   Z-Add     0             NLen3             2 0
     C                   Z-Add     0             NLen4             2 0
     C                   Z-Add     0             BlkSpace          1 0
     C                   Z-Add     0             DivRslt           5 0
     C                   Z-Add     0             DivRmdr           5 0
     C                   Z-Add     0             RmdgBlk           5 0

     C                   If        SSlsh = 'Y'
     C                   Z-Add     1             SlshLen
     C                   Endif

     C                   Move      SLen1         NLen1
     C                   Move      SLen2         NLen2
     C                   Move      SLen3         NLen3
     C                   Move      SLen4         NLen4

      ** Add count for blank spaces between Narratives
     C                   If        NLen2 <> 0
     C                   Add       1             BlkSpace
     C                   Endif
     C                   If        NLen3 <> 0
     C                   Add       1             BlkSpace
     C                   Endif
     C                   If        NLen4 <> 0
     C                   Add       1             BlkSpace
     C                   Endif

     C                   If        TotLen > 0
     C                             and SNewL = 'Y'
     C                   If        TotLen > EDNCLN
     C     Totlen        Div       EDNCLN        DivRslt
     C                   MVR                     DivRmdr
     C                   If        DivRmdr > 0
     C     EDNCLN        Sub       DivRmdr       RmdgBlk
     C                   Endif
     C                   else
     C     EDNCLN        Sub       TotLen        RmdgBlk
     C                   Endif
     C                   Endif

     C                   Eval      TotLen = TotLen + SwcdLen - 1 + SlshLen +
     C                             NLen1 + Nlen2 + Nlen3 + Nlen4
     C                             + BlkSpace + RmdgBlk

     C                   Endif

     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * ValScreen2 - Validate Screen 2                                *
      *                                                               *
      *****************************************************************
      *
     C     ValScreen2    BEGSR

     C                   Eval      ValErr = 1
     C                   Move      *Off          *In60

     C                   Move      *Blanks       DSLin16          46
     C                   Move      *Blanks       DSLin17          46
     C                   Move      *Blanks       DSLin18          46
     C                   Move      *Blanks       DSLin19          46
     C                   Move      *Blanks       DSLin20          46
     C                   Move      *Blanks       DSLin21          46
     C                   Move      *Blanks       DSLin22          46
      *
      ** Line 16
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_16      SSWCD
     C                   Movel     SNAR1_16      SNAR1
     C                   Movel     SLEN1_16      SLEN1
     C                   Movel     SSLSH_16      SSLSH
     C                   Movel     SNAR2_16      SNAR2
     C                   Movel     SLEN2_16      SLEN2
     C                   Movel     SNAR3_16      SNAR3
     C                   Movel     SLEN3_16      SLEN3
     C                   Movel     SNAR4_16      SNAR4
     C                   Movel     SLEN4_16      SLEN4
     C                   Movel     SOMIT_16      SOMIT
     C                   Movel     SNEWL_16      SNEWL
     C                   Move      DSLine        DSLin16
      *
      *
     C                   If        DSLin16 <> *Blanks
     C                             and DSLin15 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In51
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN51
     C                   Endif
     C                   Endif
      *
      ** Line 17
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_17      SSWCD
     C                   Movel     SNAR1_17      SNAR1
     C                   Movel     SLEN1_17      SLEN1
     C                   Movel     SSLSH_17      SSLSH
     C                   Movel     SNAR2_17      SNAR2
     C                   Movel     SLEN2_17      SLEN2
     C                   Movel     SNAR3_17      SNAR3
     C                   Movel     SLEN3_17      SLEN3
     C                   Movel     SNAR4_17      SNAR4
     C                   Movel     SLEN4_17      SLEN4
     C                   Movel     SOMIT_17      SOMIT
     C                   Movel     SNEWL_17      SNEWL
     C                   Move      DSLine        DSLin17
      *
     C                   If        DSLin17 <> *Blanks
     C                             and DSLin16 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In52
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN52
     C                   Endif
     C                   Endif
      *
      ** Line 18
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_18      SSWCD
     C                   Movel     SNAR1_18      SNAR1
     C                   Movel     SLEN1_18      SLEN1
     C                   Movel     SSLSH_18      SSLSH
     C                   Movel     SNAR2_18      SNAR2
     C                   Movel     SLEN2_18      SLEN2
     C                   Movel     SNAR3_18      SNAR3
     C                   Movel     SLEN3_18      SLEN3
     C                   Movel     SNAR4_18      SNAR4
     C                   Movel     SLEN4_18      SLEN4
     C                   Movel     SOMIT_18      SOMIT
     C                   Movel     SNEWL_18      SNEWL
     C                   Move      DSLine        DSLin18
      *
     C                   If        DSLin18 <> *Blanks
     C                             and DSLin17 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In53
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN53
     C                   Endif
     C                   Endif
      *
      ** Line 19
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_19      SSWCD
     C                   Movel     SNAR1_19      SNAR1
     C                   Movel     SLEN1_19      SLEN1
     C                   Movel     SSLSH_19      SSLSH
     C                   Movel     SNAR2_19      SNAR2
     C                   Movel     SLEN2_19      SLEN2
     C                   Movel     SNAR3_19      SNAR3
     C                   Movel     SLEN3_19      SLEN3
     C                   Movel     SNAR4_19      SNAR4
     C                   Movel     SLEN4_19      SLEN4
     C                   Movel     SOMIT_19      SOMIT
     C                   Movel     SNEWL_19      SNEWL
     C                   Move      DSLine        DSLin19
      *
     C                   If        DSLin19 <> *Blanks
     C                             and DSLin18 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In54
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN54
     C                   Endif
     C                   Endif
      *
      ** Line 20
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_20      SSWCD
     C                   Movel     SNAR1_20      SNAR1
     C                   Movel     SLEN1_20      SLEN1
     C                   Movel     SSLSH_20      SSLSH
     C                   Movel     SNAR2_20      SNAR2
     C                   Movel     SLEN2_20      SLEN2
     C                   Movel     SNAR3_20      SNAR3
     C                   Movel     SLEN3_20      SLEN3
     C                   Movel     SNAR4_20      SNAR4
     C                   Movel     SLEN4_20      SLEN4
     C                   Movel     SOMIT_20      SOMIT
     C                   Movel     SNEWL_20      SNEWL
     C                   Move      DSLine        DSLin20
      *
     C                   If        DSLin20 <> *Blanks
     C                             and DSLin19 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In55
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN55
     C                   Endif
     C                   Endif
      *
      ** Line 21
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_21      SSWCD
     C                   Movel     SNAR1_21      SNAR1
     C                   Movel     SLEN1_21      SLEN1
     C                   Movel     SSLSH_21      SSLSH
     C                   Movel     SNAR2_21      SNAR2
     C                   Movel     SLEN2_21      SLEN2
     C                   Movel     SNAR3_21      SNAR3
     C                   Movel     SLEN3_21      SLEN3
     C                   Movel     SNAR4_21      SNAR4
     C                   Movel     SLEN4_21      SLEN4
     C                   Movel     SOMIT_21      SOMIT
     C                   Movel     SNEWL_21      SNEWL
     C                   Move      DSLine        DSLin21
      *
     C                   If        DSLin21 <> *Blanks
     C                             and DSLin20 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In56
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN56
     C                   Endif
     C                   Endif
      *
      ** Line 22
      *
     C                   Move      *Blanks       DSLine
     C                   Movel     SSWCD_22      SSWCD
     C                   Movel     SNAR1_22      SNAR1
     C                   Movel     SLEN1_22      SLEN1
     C                   Movel     SSLSH_22      SSLSH
     C                   Movel     SNAR2_22      SNAR2
     C                   Movel     SLEN2_22      SLEN2
     C                   Movel     SNAR3_22      SNAR3
     C                   Movel     SLEN3_22      SLEN3
     C                   Movel     SNAR4_22      SNAR4
     C                   Movel     SLEN4_22      SLEN4
     C                   Movel     SOMIT_22      SOMIT
     C                   Movel     SNEWL_22      SNEWL
     C                   Move      DSLine        DSLin22
      *
     C                   If        DSLin22 <> *Blanks
     C                             and DSLin21 = *Blanks
     C                   Movel     'A6X4607'     ZAMSID
     C                   Movel     'SSWCD'       ZAMSDA
     C                   Move      *On           *In57
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   else
     C                   Exsr      ValLine
     C                   If        Error = 'Y'
     C                   Move      *On           *IN57
     C                   Endif
     C                   Endif
      *
      ** Validate total length
      *
     C                   If        *In60 = *Off
     C                   If        Totlen > MaxNo
     C                             or Totlen > BA6026MaxLen
     C                   Movel     'A6X4616'     ZAMSID
     C                   Movel     'TOTAL'       ZAMSDA
     C                   Movea     '111111111111'*In(36)
     C                   Movea     '111'         *In(48)
     C                   If        DSLin16 <> *Blanks
     C                   Move      *On           *In51
     C                   Endif
     C                   If        DSLin17 <> *Blanks
     C                   Move      *On           *In52
     C                   Endif
     C                   If        DSLin18 <> *Blanks
     C                   Move      *On           *In53
     C                   Endif
     C                   If        DSLin19 <> *Blanks
     C                   Move      *On           *In54
     C                   Endif
     C                   If        DSLin20 <> *Blanks
     C                   Move      *On           *In55
     C                   Endif
     C                   If        DSLin21 <> *Blanks
     C                   Move      *On           *In56
     C                   Endif
     C                   If        DSLin22 <> *Blanks
     C                   Move      *On           *In57
     C                   Endif
     C                   Move      *On           *In60
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        *In60 = *Off
     C                   Eval      ValErr = 0
     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * RstInd - Resets display file indicators                       *
      *                                                               *
      *****************************************************************
      *
     C     RstInd        BEGSR

     C                   Movea     '000000000000'*IN(36)
     C                   Movea     '0000000000'  *IN(48)

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * RtvDetails - Retrieve details for Enquiry & Amend Mode        *
      *                                                               *
      *****************************************************************
      *
     C     RtvDetails    BEGSR

     C     K1M940        Setll     A6M940L0
     C                   Read      A6M940L0                               99

     C     *In99         Doweq     *Off
     C                   Eval      SSwid = PSwid
     C                   Eval      STrat = PTrat
     C     MPSeqn        Ifeq      1
     C                   Eval      SSwcd_1 = MPSwcd
     C                   Eval      SNar1_1 = MPNar1
     C                   Eval      SNar2_1 = MPNar2
     C                   Eval      SNar3_1 = MPNar3
     C                   Eval      SNar4_1 = MPNar4
     C                   Eval      SSlsh_1 = MPSlsh
     C                   Eval      SOmit_1 = MPOmit
     C                   Eval      SNewl_1 = MPNewl
     C                   Move      MPLen1        SLen1_1
     C                   Move      MPLen2        SLen2_1
     C                   Move      MPLen3        SLen3_1
     C                   Move      MPLen4        SLen4_1
     C                   Endif
     C     MPSeqn        Ifeq      2
     C                   Eval      SSwcd_2 = MPSwcd
     C                   Eval      SNar1_2 = MPNar1
     C                   Eval      SNar2_2 = MPNar2
     C                   Eval      SNar3_2 = MPNar3
     C                   Eval      SNar4_2 = MPNar4
     C                   Eval      SSlsh_2 = MPSlsh
     C                   Eval      SOmit_2 = MPOmit
     C                   Eval      SNewl_2 = MPNewl
     C                   Move      MPLen1        SLen1_2
     C                   Move      MPLen2        SLen2_2
     C                   Move      MPLen3        SLen3_2
     C                   Move      MPLen4        SLen4_2
     C                   Endif
     C     MPSeqn        Ifeq      3
     C                   Eval      SSwcd_3 = MPSwcd
     C                   Eval      SNar1_3 = MPNar1
     C                   Eval      SNar2_3 = MPNar2
     C                   Eval      SNar3_3 = MPNar3
     C                   Eval      SNar4_3 = MPNar4
     C                   Eval      SSlsh_3 = MPSlsh
     C                   Eval      SOmit_3 = MPOmit
     C                   Eval      SNewl_3 = MPNewl
     C                   Move      MPLen1        SLen1_3
     C                   Move      MPLen2        SLen2_3
     C                   Move      MPLen3        SLen3_3
     C                   Move      MPLen4        SLen4_3
     C                   Endif
     C     MPSeqn        Ifeq      4
     C                   Eval      SSwcd_4 = MPSwcd
     C                   Eval      SNar1_4 = MPNar1
     C                   Eval      SNar2_4 = MPNar2
     C                   Eval      SNar3_4 = MPNar3
     C                   Eval      SNar4_4 = MPNar4
     C                   Eval      SSlsh_4 = MPSlsh
     C                   Eval      SOmit_4 = MPOmit
     C                   Eval      SNewl_4 = MPNewl
     C                   Move      MPLen1        SLen1_4
     C                   Move      MPLen2        SLen2_4
     C                   Move      MPLen3        SLen3_4
     C                   Move      MPLen4        SLen4_4
     C                   Endif
     C     MPSeqn        Ifeq      5
     C                   Eval      SSwcd_5 = MPSwcd
     C                   Eval      SNar1_5 = MPNar1
     C                   Eval      SNar2_5 = MPNar2
     C                   Eval      SNar3_5 = MPNar3
     C                   Eval      SNar4_5 = MPNar4
     C                   Eval      SSlsh_5 = MPSlsh
     C                   Eval      SOmit_5 = MPOmit
     C                   Eval      SNewl_5 = MPNewl
     C                   Move      MPLen1        SLen1_5
     C                   Move      MPLen2        SLen2_5
     C                   Move      MPLen3        SLen3_5
     C                   Move      MPLen4        SLen4_5
     C                   Endif
     C     MPSeqn        Ifeq      6
     C                   Eval      SSwcd_6 = MPSwcd
     C                   Eval      SNar1_6 = MPNar1
     C                   Eval      SNar2_6 = MPNar2
     C                   Eval      SNar3_6 = MPNar3
     C                   Eval      SNar4_6 = MPNar4
     C                   Eval      SSlsh_6 = MPSlsh
     C                   Eval      SOmit_6 = MPOmit
     C                   Eval      SNewl_6 = MPNewl
     C                   Move      MPLen1        SLen1_6
     C                   Move      MPLen2        SLen2_6
     C                   Move      MPLen3        SLen3_6
     C                   Move      MPLen4        SLen4_6
     C                   Endif
     C     MPSeqn        Ifeq      7
     C                   Eval      SSwcd_7 = MPSwcd
     C                   Eval      SNar1_7 = MPNar1
     C                   Eval      SNar2_7 = MPNar2
     C                   Eval      SNar3_7 = MPNar3
     C                   Eval      SNar4_7 = MPNar4
     C                   Eval      SSlsh_7 = MPSlsh
     C                   Eval      SOmit_7 = MPOmit
     C                   Eval      SNewl_7 = MPNewl
     C                   Move      MPLen1        SLen1_7
     C                   Move      MPLen2        SLen2_7
     C                   Move      MPLen3        SLen3_7
     C                   Move      MPLen4        SLen4_7
     C                   Endif
     C     MPSeqn        Ifeq      8
     C                   Eval      SSwcd_8 = MPSwcd
     C                   Eval      SNar1_8 = MPNar1
     C                   Eval      SNar2_8 = MPNar2
     C                   Eval      SNar3_8 = MPNar3
     C                   Eval      SNar4_8 = MPNar4
     C                   Eval      SSlsh_8 = MPSlsh
     C                   Eval      SOmit_8 = MPOmit
     C                   Eval      SNewl_8 = MPNewl
     C                   Move      MPLen1        SLen1_8
     C                   Move      MPLen2        SLen2_8
     C                   Move      MPLen3        SLen3_8
     C                   Move      MPLen4        SLen4_8
     C                   Endif
     C     MPSeqn        Ifeq      9
     C                   Eval      SSwcd_9 = MPSwcd
     C                   Eval      SNar1_9 = MPNar1
     C                   Eval      SNar2_9 = MPNar2
     C                   Eval      SNar3_9 = MPNar3
     C                   Eval      SNar4_9 = MPNar4
     C                   Eval      SSlsh_9 = MPSlsh
     C                   Eval      SOmit_9 = MPOmit
     C                   Eval      SNewl_9 = MPNewl
     C                   Move      MPLen1        SLen1_9
     C                   Move      MPLen2        SLen2_9
     C                   Move      MPLen3        SLen3_9
     C                   Move      MPLen4        SLen4_9
     C                   Endif
     C     MPSeqn        Ifeq      10
     C                   Eval      SSwcd_10 = MPSwcd
     C                   Eval      SNar1_10 = MPNar1
     C                   Eval      SNar2_10 = MPNar2
     C                   Eval      SNar3_10 = MPNar3
     C                   Eval      SNar4_10 = MPNar4
     C                   Eval      SSlsh_10 = MPSlsh
     C                   Eval      SOmit_10 = MPOmit
     C                   Eval      SNewl_10 = MPNewl
     C                   Move      MPLen1        SLen1_10
     C                   Move      MPLen2        SLen2_10
     C                   Move      MPLen3        SLen3_10
     C                   Move      MPLen4        SLen4_10
     C                   Endif
     C     MPSeqn        Ifeq      11
     C                   Eval      SSwcd_11 = MPSwcd
     C                   Eval      SNar1_11 = MPNar1
     C                   Eval      SNar2_11 = MPNar2
     C                   Eval      SNar3_11 = MPNar3
     C                   Eval      SNar4_11 = MPNar4
     C                   Eval      SSlsh_11 = MPSlsh
     C                   Eval      SOmit_11 = MPOmit
     C                   Eval      SNewl_11 = MPNewl
     C                   Move      MPLen1        SLen1_11
     C                   Move      MPLen2        SLen2_11
     C                   Move      MPLen3        SLen3_11
     C                   Move      MPLen4        SLen4_11
     C                   Endif
     C     MPSeqn        Ifeq      12
     C                   Eval      SSwcd_12 = MPSwcd
     C                   Eval      SNar1_12 = MPNar1
     C                   Eval      SNar2_12 = MPNar2
     C                   Eval      SNar3_12 = MPNar3
     C                   Eval      SNar4_12 = MPNar4
     C                   Eval      SSlsh_12 = MPSlsh
     C                   Eval      SOmit_12 = MPOmit
     C                   Eval      SNewl_12 = MPNewl
     C                   Move      MPLen1        SLen1_12
     C                   Move      MPLen2        SLen2_12
     C                   Move      MPLen3        SLen3_12
     C                   Move      MPLen4        SLen4_12
     C                   Endif
     C     MPSeqn        Ifeq      13
     C                   Eval      SSwcd_13 = MPSwcd
     C                   Eval      SNar1_13 = MPNar1
     C                   Eval      SNar2_13 = MPNar2
     C                   Eval      SNar3_13 = MPNar3
     C                   Eval      SNar4_13 = MPNar4
     C                   Eval      SSlsh_13 = MPSlsh
     C                   Eval      SOmit_13 = MPOmit
     C                   Eval      SNewl_13 = MPNewl
     C                   Move      MPLen1        SLen1_13
     C                   Move      MPLen2        SLen2_13
     C                   Move      MPLen3        SLen3_13
     C                   Move      MPLen4        SLen4_13
     C                   Endif
     C     MPSeqn        Ifeq      14
     C                   Eval      SSwcd_14 = MPSwcd
     C                   Eval      SNar1_14 = MPNar1
     C                   Eval      SNar2_14 = MPNar2
     C                   Eval      SNar3_14 = MPNar3
     C                   Eval      SNar4_14 = MPNar4
     C                   Eval      SSlsh_14 = MPSlsh
     C                   Eval      SOmit_14 = MPOmit
     C                   Eval      SNewl_14 = MPNewl
     C                   Move      MPLen1        SLen1_14
     C                   Move      MPLen2        SLen2_14
     C                   Move      MPLen3        SLen3_14
     C                   Move      MPLen4        SLen4_14
     C                   Endif
     C     MPSeqn        Ifeq      15
     C                   Eval      SSwcd_15 = MPSwcd
     C                   Eval      SNar1_15 = MPNar1
     C                   Eval      SNar2_15 = MPNar2
     C                   Eval      SNar3_15 = MPNar3
     C                   Eval      SNar4_15 = MPNar4
     C                   Eval      SSlsh_15 = MPSlsh
     C                   Eval      SOmit_15 = MPOmit
     C                   Eval      SNewl_15 = MPNewl
     C                   Move      MPLen1        SLen1_15
     C                   Move      MPLen2        SLen2_15
     C                   Move      MPLen3        SLen3_15
     C                   Move      MPLen4        SLen4_15
     C                   Endif
     C     MPSeqn        Ifeq      16
     C                   Eval      SSwcd_16 = MPSwcd
     C                   Eval      SNar1_16 = MPNar1
     C                   Eval      SNar2_16 = MPNar2
     C                   Eval      SNar3_16 = MPNar3
     C                   Eval      SNar4_16 = MPNar4
     C                   Eval      SSlsh_16 = MPSlsh
     C                   Eval      SOmit_16 = MPOmit
     C                   Eval      SNewl_16 = MPNewl
     C                   Move      MPLen1        SLen1_16
     C                   Move      MPLen2        SLen2_16
     C                   Move      MPLen3        SLen3_16
     C                   Move      MPLen4        SLen4_16
     C                   Endif
     C     MPSeqn        Ifeq      17
     C                   Eval      SSwcd_17 = MPSwcd
     C                   Eval      SNar1_17 = MPNar1
     C                   Eval      SNar2_17 = MPNar2
     C                   Eval      SNar3_17 = MPNar3
     C                   Eval      SNar4_17 = MPNar4
     C                   Eval      SSlsh_17 = MPSlsh
     C                   Eval      SOmit_17 = MPOmit
     C                   Eval      SNewl_17 = MPNewl
     C                   Move      MPLen1        SLen1_17
     C                   Move      MPLen2        SLen2_17
     C                   Move      MPLen3        SLen3_17
     C                   Move      MPLen4        SLen4_17
     C                   Endif
     C     MPSeqn        Ifeq      18
     C                   Eval      SSwcd_18 = MPSwcd
     C                   Eval      SNar1_18 = MPNar1
     C                   Eval      SNar2_18 = MPNar2
     C                   Eval      SNar3_18 = MPNar3
     C                   Eval      SNar4_18 = MPNar4
     C                   Eval      SSlsh_18 = MPSlsh
     C                   Eval      SOmit_18 = MPOmit
     C                   Eval      SNewl_18 = MPNewl
     C                   Move      MPLen1        SLen1_18
     C                   Move      MPLen2        SLen2_18
     C                   Move      MPLen3        SLen3_18
     C                   Move      MPLen4        SLen4_18
     C                   Endif
     C     MPSeqn        Ifeq      19
     C                   Eval      SSwcd_19 = MPSwcd
     C                   Eval      SNar1_19 = MPNar1
     C                   Eval      SNar2_19 = MPNar2
     C                   Eval      SNar3_19 = MPNar3
     C                   Eval      SNar4_19 = MPNar4
     C                   Eval      SSlsh_19 = MPSlsh
     C                   Eval      SOmit_19 = MPOmit
     C                   Eval      SNewl_19 = MPNewl
     C                   Move      MPLen1        SLen1_19
     C                   Move      MPLen2        SLen2_19
     C                   Move      MPLen3        SLen3_19
     C                   Move      MPLen4        SLen4_19
     C                   Endif
     C     MPSeqn        Ifeq      20
     C                   Eval      SSwcd_20 = MPSwcd
     C                   Eval      SNar1_20 = MPNar1
     C                   Eval      SNar2_20 = MPNar2
     C                   Eval      SNar3_20 = MPNar3
     C                   Eval      SNar4_20 = MPNar4
     C                   Eval      SSlsh_20 = MPSlsh
     C                   Eval      SOmit_20 = MPOmit
     C                   Eval      SNewl_20 = MPNewl
     C                   Move      MPLen1        SLen1_20
     C                   Move      MPLen2        SLen2_20
     C                   Move      MPLen3        SLen3_20
     C                   Move      MPLen4        SLen4_20
     C                   Endif
     C     MPSeqn        Ifeq      21
     C                   Eval      SSwcd_21 = MPSwcd
     C                   Eval      SNar1_21 = MPNar1
     C                   Eval      SNar2_21 = MPNar2
     C                   Eval      SNar3_21 = MPNar3
     C                   Eval      SNar4_21 = MPNar4
     C                   Eval      SSlsh_21 = MPSlsh
     C                   Eval      SOmit_21 = MPOmit
     C                   Eval      SNewl_21 = MPNewl
     C                   Move      MPLen1        SLen1_21
     C                   Move      MPLen2        SLen2_21
     C                   Move      MPLen3        SLen3_21
     C                   Move      MPLen4        SLen4_21
     C                   Endif
     C     MPSeqn        Ifeq      22
     C                   Eval      SSwcd_22 = MPSwcd
     C                   Eval      SNar1_22 = MPNar1
     C                   Eval      SNar2_22 = MPNar2
     C                   Eval      SNar3_22 = MPNar3
     C                   Eval      SNar4_22 = MPNar4
     C                   Eval      SSlsh_22 = MPSlsh
     C                   Eval      SOmit_22 = MPOmit
     C                   Eval      SNewl_22 = MPNewl
     C                   Move      MPLen1        SLen1_22
     C                   Move      MPLen2        SLen2_22
     C                   Move      MPLen3        SLen3_22
     C                   Move      MPLen4        SLen4_22
     C                   Endif

     C     K1M940        ReadE     A6M940L0                               99

     C                   Enddo

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * InzDetails - Initialise screen for Insert Mode                *
      *                                                               *
      *****************************************************************
      *
     C     InzDetails    BEGSR

     C                   Eval      SSwid = PSwid
     C                   Eval      STrat = PTrat

     C                   Eval      SSwcd_1 = *Blanks
     C                   Eval      SNar1_1 = *Blanks
     C                   Eval      SNar2_1 = *Blanks
     C                   Eval      SNar3_1 = *Blanks
     C                   Eval      SNar4_1 = *Blanks
     C                   Eval      SSlsh_1 = *Blanks
     C                   Eval      SLen1_1 = *Blanks
     C                   Eval      SLen2_1 = *Blanks
     C                   Eval      SLen3_1 = *Blanks
     C                   Eval      SLen4_1 = *Blanks
     C                   Eval      SOmit_1 = *Blanks
     C                   Eval      SNewl_1 = *Blanks

     C                   Eval      SSwcd_2 = *Blanks
     C                   Eval      SNar1_2 = *Blanks
     C                   Eval      SNar2_2 = *Blanks
     C                   Eval      SNar3_2 = *Blanks
     C                   Eval      SNar4_2 = *Blanks
     C                   Eval      SSlsh_2 = *Blanks
     C                   Eval      SLen1_2 = *Blanks
     C                   Eval      SLen2_2 = *Blanks
     C                   Eval      SLen3_2 = *Blanks
     C                   Eval      SLen4_2 = *Blanks
     C                   Eval      SOmit_2 = *Blanks
     C                   Eval      SNewl_2 = *Blanks

     C                   Eval      SSwcd_3 = *Blanks
     C                   Eval      SNar1_3 = *Blanks
     C                   Eval      SNar2_3 = *Blanks
     C                   Eval      SNar3_3 = *Blanks
     C                   Eval      SNar4_3 = *Blanks
     C                   Eval      SSlsh_3 = *Blanks
     C                   Eval      SLen1_3 = *Blanks
     C                   Eval      SLen2_3 = *Blanks
     C                   Eval      SLen3_3 = *Blanks
     C                   Eval      SLen4_3 = *Blanks
     C                   Eval      SOmit_3 = *Blanks
     C                   Eval      SNewl_3 = *Blanks

     C                   Eval      SSwcd_4 = *Blanks
     C                   Eval      SNar1_4 = *Blanks
     C                   Eval      SNar2_4 = *Blanks
     C                   Eval      SNar3_4 = *Blanks
     C                   Eval      SNar4_4 = *Blanks
     C                   Eval      SSlsh_4 = *Blanks
     C                   Eval      SLen1_4 = *Blanks
     C                   Eval      SLen2_4 = *Blanks
     C                   Eval      SLen3_4 = *Blanks
     C                   Eval      SLen4_4 = *Blanks
     C                   Eval      SOmit_4 = *Blanks
     C                   Eval      SNewl_4 = *Blanks

     C                   Eval      SSwcd_5 = *Blanks
     C                   Eval      SNar1_5 = *Blanks
     C                   Eval      SNar2_5 = *Blanks
     C                   Eval      SNar3_5 = *Blanks
     C                   Eval      SNar4_5 = *Blanks
     C                   Eval      SSlsh_5 = *Blanks
     C                   Eval      SLen1_5 = *Blanks
     C                   Eval      SLen2_5 = *Blanks
     C                   Eval      SLen3_5 = *Blanks
     C                   Eval      SLen4_5 = *Blanks
     C                   Eval      SOmit_5 = *Blanks
     C                   Eval      SNewl_5 = *Blanks

     C                   Eval      SSwcd_6 = *Blanks
     C                   Eval      SNar1_6 = *Blanks
     C                   Eval      SNar2_6 = *Blanks
     C                   Eval      SNar3_6 = *Blanks
     C                   Eval      SNar4_6 = *Blanks
     C                   Eval      SSlsh_6 = *Blanks
     C                   Eval      SLen1_6 = *Blanks
     C                   Eval      SLen2_6 = *Blanks
     C                   Eval      SLen3_6 = *Blanks
     C                   Eval      SLen4_6 = *Blanks
     C                   Eval      SOmit_6 = *Blanks
     C                   Eval      SNewl_6 = *Blanks

     C                   Eval      SSwcd_7 = *Blanks
     C                   Eval      SNar1_7 = *Blanks
     C                   Eval      SNar2_7 = *Blanks
     C                   Eval      SNar3_7 = *Blanks
     C                   Eval      SNar4_7 = *Blanks
     C                   Eval      SSlsh_7 = *Blanks
     C                   Eval      SLen1_7 = *Blanks
     C                   Eval      SLen2_7 = *Blanks
     C                   Eval      SLen3_7 = *Blanks
     C                   Eval      SLen4_7 = *Blanks
     C                   Eval      SOmit_7 = *Blanks
     C                   Eval      SNewl_7 = *Blanks

     C                   Eval      SSwcd_8 = *Blanks
     C                   Eval      SNar1_8 = *Blanks
     C                   Eval      SNar2_8 = *Blanks
     C                   Eval      SNar3_8 = *Blanks
     C                   Eval      SNar4_8 = *Blanks
     C                   Eval      SSlsh_8 = *Blanks
     C                   Eval      SLen1_8 = *Blanks
     C                   Eval      SLen2_8 = *Blanks
     C                   Eval      SLen3_8 = *Blanks
     C                   Eval      SLen4_8 = *Blanks
     C                   Eval      SOmit_8 = *Blanks
     C                   Eval      SNewl_8 = *Blanks

     C                   Eval      SSwcd_9 = *Blanks
     C                   Eval      SNar1_9 = *Blanks
     C                   Eval      SNar2_9 = *Blanks
     C                   Eval      SNar3_9 = *Blanks
     C                   Eval      SNar4_9 = *Blanks
     C                   Eval      SSlsh_9 = *Blanks
     C                   Eval      SLen1_9 = *Blanks
     C                   Eval      SLen2_9 = *Blanks
     C                   Eval      SLen3_9 = *Blanks
     C                   Eval      SLen4_9 = *Blanks
     C                   Eval      SOmit_9 = *Blanks
     C                   Eval      SNewl_9 = *Blanks

     C                   Eval      SSwcd_10 = *Blanks
     C                   Eval      SNar1_10 = *Blanks
     C                   Eval      SNar2_10 = *Blanks
     C                   Eval      SNar3_10 = *Blanks
     C                   Eval      SNar4_10 = *Blanks
     C                   Eval      SSlsh_10 = *Blanks
     C                   Eval      SLen1_10 = *Blanks
     C                   Eval      SLen2_10 = *Blanks
     C                   Eval      SLen3_10 = *Blanks
     C                   Eval      SLen4_10 = *Blanks
     C                   Eval      SOmit_10 = *Blanks
     C                   Eval      SNewl_10 = *Blanks

     C                   Eval      SSwcd_11 = *Blanks
     C                   Eval      SNar1_11 = *Blanks
     C                   Eval      SNar2_11 = *Blanks
     C                   Eval      SNar3_11 = *Blanks
     C                   Eval      SNar4_11 = *Blanks
     C                   Eval      SSlsh_11 = *Blanks
     C                   Eval      SLen1_11 = *Blanks
     C                   Eval      SLen2_11 = *Blanks
     C                   Eval      SLen3_11 = *Blanks
     C                   Eval      SLen4_11 = *Blanks
     C                   Eval      SOmit_11 = *Blanks
     C                   Eval      SNewl_11 = *Blanks

     C                   Eval      SSwcd_12 = *Blanks
     C                   Eval      SNar1_12 = *Blanks
     C                   Eval      SNar2_12 = *Blanks
     C                   Eval      SNar3_12 = *Blanks
     C                   Eval      SNar4_12 = *Blanks
     C                   Eval      SSlsh_12 = *Blanks
     C                   Eval      SLen1_12 = *Blanks
     C                   Eval      SLen2_12 = *Blanks
     C                   Eval      SLen3_12 = *Blanks
     C                   Eval      SLen4_12 = *Blanks
     C                   Eval      SOmit_12 = *Blanks
     C                   Eval      SNewl_12 = *Blanks

     C                   Eval      SSwcd_13 = *Blanks
     C                   Eval      SNar1_13 = *Blanks
     C                   Eval      SNar2_13 = *Blanks
     C                   Eval      SNar3_13 = *Blanks
     C                   Eval      SNar4_13 = *Blanks
     C                   Eval      SSlsh_13 = *Blanks
     C                   Eval      SLen1_13 = *Blanks
     C                   Eval      SLen2_13 = *Blanks
     C                   Eval      SLen3_13 = *Blanks
     C                   Eval      SLen4_13 = *Blanks
     C                   Eval      SOmit_13 = *Blanks
     C                   Eval      SNewl_13 = *Blanks

     C                   Eval      SSwcd_14 = *Blanks
     C                   Eval      SNar1_14 = *Blanks
     C                   Eval      SNar2_14 = *Blanks
     C                   Eval      SNar3_14 = *Blanks
     C                   Eval      SNar4_14 = *Blanks
     C                   Eval      SSlsh_14 = *Blanks
     C                   Eval      SLen1_14 = *Blanks
     C                   Eval      SLen2_14 = *Blanks
     C                   Eval      SLen3_14 = *Blanks
     C                   Eval      SLen4_14 = *Blanks
     C                   Eval      SOmit_14 = *Blanks
     C                   Eval      SNewl_14 = *Blanks

     C                   Eval      SSwcd_15 = *Blanks
     C                   Eval      SNar1_15 = *Blanks
     C                   Eval      SNar2_15 = *Blanks
     C                   Eval      SNar3_15 = *Blanks
     C                   Eval      SNar4_15 = *Blanks
     C                   Eval      SSlsh_15 = *Blanks
     C                   Eval      SLen1_15 = *Blanks
     C                   Eval      SLen2_15 = *Blanks
     C                   Eval      SLen3_15 = *Blanks
     C                   Eval      SLen4_15 = *Blanks
     C                   Eval      SOmit_15 = *Blanks
     C                   Eval      SNewl_15 = *Blanks

     C                   Eval      SSwcd_16 = *Blanks
     C                   Eval      SNar1_16 = *Blanks
     C                   Eval      SNar2_16 = *Blanks
     C                   Eval      SNar3_16 = *Blanks
     C                   Eval      SNar4_16 = *Blanks
     C                   Eval      SSlsh_16 = *Blanks
     C                   Eval      SLen1_16 = *Blanks
     C                   Eval      SLen2_16 = *Blanks
     C                   Eval      SLen3_16 = *Blanks
     C                   Eval      SLen4_16 = *Blanks
     C                   Eval      SOmit_16 = *Blanks
     C                   Eval      SNewl_16 = *Blanks

     C                   Eval      SSwcd_17 = *Blanks
     C                   Eval      SNar1_17 = *Blanks
     C                   Eval      SNar2_17 = *Blanks
     C                   Eval      SNar3_17 = *Blanks
     C                   Eval      SNar4_17 = *Blanks
     C                   Eval      SSlsh_17 = *Blanks
     C                   Eval      SLen1_17 = *Blanks
     C                   Eval      SLen2_17 = *Blanks
     C                   Eval      SLen3_17 = *Blanks
     C                   Eval      SLen4_17 = *Blanks
     C                   Eval      SOmit_17 = *Blanks
     C                   Eval      SNewl_17 = *Blanks

     C                   Eval      SSwcd_18 = *Blanks
     C                   Eval      SNar1_18 = *Blanks
     C                   Eval      SNar2_18 = *Blanks
     C                   Eval      SNar3_18 = *Blanks
     C                   Eval      SNar4_18 = *Blanks
     C                   Eval      SSlsh_18 = *Blanks
     C                   Eval      SLen1_18 = *Blanks
     C                   Eval      SLen2_18 = *Blanks
     C                   Eval      SLen3_18 = *Blanks
     C                   Eval      SLen4_18 = *Blanks
     C                   Eval      SOmit_18 = *Blanks
     C                   Eval      SNewl_18 = *Blanks

     C                   Eval      SSwcd_19 = *Blanks
     C                   Eval      SNar1_19 = *Blanks
     C                   Eval      SNar2_19 = *Blanks
     C                   Eval      SNar3_19 = *Blanks
     C                   Eval      SNar4_19 = *Blanks
     C                   Eval      SSlsh_19 = *Blanks
     C                   Eval      SLen1_19 = *Blanks
     C                   Eval      SLen2_19 = *Blanks
     C                   Eval      SLen3_19 = *Blanks
     C                   Eval      SLen4_19 = *Blanks
     C                   Eval      SOmit_19 = *Blanks
     C                   Eval      SNewl_19 = *Blanks

     C                   Eval      SSwcd_20 = *Blanks
     C                   Eval      SNar1_20 = *Blanks
     C                   Eval      SNar2_20 = *Blanks
     C                   Eval      SNar3_20 = *Blanks
     C                   Eval      SNar4_20 = *Blanks
     C                   Eval      SSlsh_20 = *Blanks
     C                   Eval      SLen1_20 = *Blanks
     C                   Eval      SLen2_20 = *Blanks
     C                   Eval      SLen3_20 = *Blanks
     C                   Eval      SLen4_20 = *Blanks
     C                   Eval      SOmit_20 = *Blanks
     C                   Eval      SNewl_20 = *Blanks

     C                   Eval      SSwcd_21 = *Blanks
     C                   Eval      SNar1_21 = *Blanks
     C                   Eval      SNar2_21 = *Blanks
     C                   Eval      SNar3_21 = *Blanks
     C                   Eval      SNar4_21 = *Blanks
     C                   Eval      SSlsh_21 = *Blanks
     C                   Eval      SLen1_21 = *Blanks
     C                   Eval      SLen2_21 = *Blanks
     C                   Eval      SLen3_21 = *Blanks
     C                   Eval      SLen4_21 = *Blanks
     C                   Eval      SOmit_21 = *Blanks
     C                   Eval      SNewl_21 = *Blanks

     C                   Eval      SSwcd_22 = *Blanks
     C                   Eval      SNar1_22 = *Blanks
     C                   Eval      SNar2_22 = *Blanks
     C                   Eval      SNar3_22 = *Blanks
     C                   Eval      SNar4_22 = *Blanks
     C                   Eval      SSlsh_22 = *Blanks
     C                   Eval      SLen1_22 = *Blanks
     C                   Eval      SLen2_22 = *Blanks
     C                   Eval      SLen3_22 = *Blanks
     C                   Eval      SLen4_22 = *Blanks
     C                   Eval      SOmit_22 = *Blanks
     C                   Eval      SNewl_22 = *Blanks

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdats - Populates A6M940TD and A6H940TD files              *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdats      BEGSR

     C/EXEC SQL
     C+ delete from A6M940TD
     C+ where MPSwid = :PSwid
     C+  and MPTrat = :PTrat
     C/END-EXEC

     C     PActn         Ifeq      'I'
     C                   Eval      HPSwid = PSwid
     C                   Eval      HPTrat = PTrat
     C                   Write     A6H940D0
     C                   Endif

     C                   Eval      MPSwid = PSwid
     C                   Eval      MPTrat = PTrat

     C     DsLin1        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_1
     C                   Eval      MPNar1 = SNar1_1
     C                   Eval      MPSlsh = SSlsh_1
     C                   Eval      MPNar2 = SNar2_1
     C                   Eval      MPNar3 = SNar3_1
     C                   Eval      MPNar4 = SNar4_1
     C                   Eval      MPOmit = SOmit_1
     C                   Eval      MPNewl = SNewl_1
     C                   Move      SLen1_1       MPLen1
     C                   Move      SLen2_1       MPLen2
     C                   Move      SLen3_1       MPLen3
     C                   Move      SLen4_1       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_1       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_1 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_1       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_1 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_1       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_1 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_1       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     1             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin2        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_2
     C                   Eval      MPNar1 = SNar1_2
     C                   Eval      MPSlsh = SSlsh_2
     C                   Eval      MPNar2 = SNar2_2
     C                   Eval      MPNar3 = SNar3_2
     C                   Eval      MPNar4 = SNar4_2
     C                   Eval      MPOmit = SOmit_2
     C                   Eval      MPNewl = SNewl_2
     C                   Move      SLen1_2       MPLen1
     C                   Move      SLen2_2       MPLen2
     C                   Move      SLen3_2       MPLen3
     C                   Move      SLen4_2       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_2       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_2 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_2       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_2 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_2       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_2 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_2       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     2             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin3        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_3
     C                   Eval      MPNar1 = SNar1_3
     C                   Eval      MPSlsh = SSlsh_3
     C                   Eval      MPNar2 = SNar2_3
     C                   Eval      MPNar3 = SNar3_3
     C                   Eval      MPNar4 = SNar4_3
     C                   Eval      MPOmit = SOmit_3
     C                   Eval      MPNewl = SNewl_3
     C
     C                   Move      SLen1_3       MPLen1
     C                   Move      SLen2_3       MPLen2
     C                   Move      SLen3_3       MPLen3
     C                   Move      SLen4_3       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_3       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_3 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_3       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_3 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_3       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_3 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_3       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     3             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin4        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_4
     C                   Eval      MPNar1 = SNar1_4
     C                   Eval      MPSlsh = SSlsh_4
     C                   Eval      MPNar2 = SNar2_4
     C                   Eval      MPNar3 = SNar3_4
     C                   Eval      MPNar4 = SNar4_4
     C                   Eval      MPOmit = SOmit_4
     C                   Eval      MPNewl = SNewl_4
     C                   Move      SLen1_4       MPLen1
     C                   Move      SLen2_4       MPLen2
     C                   Move      SLen3_4       MPLen3
     C                   Move      SLen4_4       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_4       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_4 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_4       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_4 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_4       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_4 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_4       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     4             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin5        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_5
     C                   Eval      MPNar1 = SNar1_5
     C                   Eval      MPSlsh = SSlsh_5
     C                   Eval      MPNar2 = SNar2_5
     C                   Eval      MPNar3 = SNar3_5
     C                   Eval      MPNar4 = SNar4_5
     C                   Eval      MPOmit = SOmit_5
     C                   Eval      MPNewl = SNewl_5
     C                   Move      SLen1_5       MPLen1
     C                   Move      SLen2_5       MPLen2
     C                   Move      SLen3_5       MPLen3
     C                   Move      SLen4_5       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_5       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_5 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_5       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_5 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_5       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_5 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_5       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     5             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin6        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_6
     C                   Eval      MPNar1 = SNar1_6
     C                   Eval      MPSlsh = SSlsh_6
     C                   Eval      MPNar2 = SNar2_6
     C                   Eval      MPNar3 = SNar3_6
     C                   Eval      MPNar4 = SNar4_6
     C                   Eval      MPOmit = SOmit_6
     C                   Eval      MPNewl = SNewl_6
     C                   Move      SLen1_6       MPLen1
     C                   Move      SLen2_6       MPLen2
     C                   Move      SLen3_6       MPLen3
     C                   Move      SLen4_6       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_6       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_6 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_6       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_6 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_6       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_6 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_6       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     6             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin7        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_7
     C                   Eval      MPNar1 = SNar1_7
     C                   Eval      MPSlsh = SSlsh_7
     C                   Eval      MPNar2 = SNar2_7
     C                   Eval      MPNar3 = SNar3_7
     C                   Eval      MPNar4 = SNar4_7
     C                   Eval      MPOmit = SOmit_7
     C                   Eval      MPNewl = SNewl_7
     C                   Move      SLen1_7       MPLen1
     C                   Move      SLen2_7       MPLen2
     C                   Move      SLen3_7       MPLen3
     C                   Move      SLen4_7       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_7       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_7 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_7       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_7 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_7       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_7 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_7       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     7             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin8        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_8
     C                   Eval      MPNar1 = SNar1_8
     C                   Eval      MPSlsh = SSlsh_8
     C                   Eval      MPNar2 = SNar2_8
     C                   Eval      MPNar3 = SNar3_8
     C                   Eval      MPNar4 = SNar4_8
     C                   Eval      MPOmit = SOmit_8
     C                   Eval      MPNewl = SNewl_8
     C                   Move      SLen1_8       MPLen1
     C                   Move      SLen2_8       MPLen2
     C                   Move      SLen3_8       MPLen3
     C                   Move      SLen4_8       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_8       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_8 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_8       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_8 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_8       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_8 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_8       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     8             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin9        Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_9
     C                   Eval      MPNar1 = SNar1_9
     C                   Eval      MPSlsh = SSlsh_9
     C                   Eval      MPNar2 = SNar2_9
     C                   Eval      MPNar3 = SNar3_9
     C                   Eval      MPNar4 = SNar4_9
     C                   Eval      MPOmit = SOmit_9
     C                   Eval      MPNewl = SNewl_9
     C                   Move      SLen1_9       MPLen1
     C                   Move      SLen2_9       MPLen2
     C                   Move      SLen3_9       MPLen3
     C                   Move      SLen4_9       MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_9       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_9 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_9       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_9 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_9       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_9 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_9       DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     9             MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin10       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_10
     C                   Eval      MPNar1 = SNar1_10
     C                   Eval      MPSlsh = SSlsh_10
     C                   Eval      MPNar2 = SNar2_10
     C                   Eval      MPNar3 = SNar3_10
     C                   Eval      MPNar4 = SNar4_10
     C                   Eval      MPOmit = SOmit_10
     C                   Eval      MPNewl = SNewl_10
     C                   Move      SLen1_10      MPLen1
     C                   Move      SLen2_10      MPLen2
     C                   Move      SLen3_10      MPLen3
     C                   Move      SLen4_10      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_10      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_10 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_10      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_10 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_10      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_10 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_10      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     10            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin11       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_11
     C                   Eval      MPNar1 = SNar1_11
     C                   Eval      MPSlsh = SSlsh_11
     C                   Eval      MPNar2 = SNar2_11
     C                   Eval      MPNar3 = SNar3_11
     C                   Eval      MPNar4 = SNar4_11
     C                   Eval      MPOmit = SOmit_11
     C                   Eval      MPNewl = SNewl_11
     C                   Move      SLen1_11      MPLen1
     C                   Move      SLen2_11      MPLen2
     C                   Move      SLen3_11      MPLen3
     C                   Move      SLen4_11      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_11      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_11 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_11      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_11 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_11      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_11 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_11      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     11            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin12       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_12
     C                   Eval      MPNar1 = SNar1_12
     C                   Eval      MPSlsh = SSlsh_12
     C                   Eval      MPNar2 = SNar2_12
     C                   Eval      MPNar3 = SNar3_12
     C                   Eval      MPNar4 = SNar4_12
     C                   Eval      MPOmit = SOmit_12
     C                   Eval      MPNewl = SNewl_12
     C                   Move      SLen1_12      MPLen1
     C                   Move      SLen2_12      MPLen2
     C                   Move      SLen3_12      MPLen3
     C                   Move      SLen4_12      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_12      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_12 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_12      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_12 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_12      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_12 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_12      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     12            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin13       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_13
     C                   Eval      MPNar1 = SNar1_13
     C                   Eval      MPSlsh = SSlsh_13
     C                   Eval      MPNar2 = SNar2_13
     C                   Eval      MPNar3 = SNar3_13
     C                   Eval      MPNar4 = SNar4_13
     C                   Eval      MPOmit = SOmit_13
     C                   Eval      MPNewl = SNewl_13
     C                   Move      SLen1_13      MPLen1
     C                   Move      SLen2_13      MPLen2
     C                   Move      SLen3_13      MPLen3
     C                   Move      SLen4_13      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_13      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_13 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_13      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_13 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_13      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_13 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_13      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     13            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin14       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_14
     C                   Eval      MPNar1 = SNar1_14
     C                   Eval      MPSlsh = SSlsh_14
     C                   Eval      MPNar2 = SNar2_14
     C                   Eval      MPNar3 = SNar3_14
     C                   Eval      MPNar4 = SNar4_14
     C                   Eval      MPOmit = SOmit_14
     C                   Eval      MPNewl = SNewl_14
     C                   Move      SLen1_14      MPLen1
     C                   Move      SLen2_14      MPLen2
     C                   Move      SLen3_14      MPLen3
     C                   Move      SLen4_14      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_14      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_14 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_14      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_14 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_14      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_14 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_14      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     14            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin15       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_15
     C                   Eval      MPNar1 = SNar1_15
     C                   Eval      MPSlsh = SSlsh_15
     C                   Eval      MPNar2 = SNar2_15
     C                   Eval      MPNar3 = SNar3_15
     C                   Eval      MPNar4 = SNar4_15
     C                   Eval      MPOmit = SOmit_15
     C                   Eval      MPNewl = SNewl_15
     C                   Move      SLen1_15      MPLen1
     C                   Move      SLen2_15      MPLen2
     C                   Move      SLen3_15      MPLen3
     C                   Move      SLen4_15      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_15      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_15 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_15      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_15 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_15      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_15 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_15      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     15            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin16       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_16
     C                   Eval      MPNar1 = SNar1_16
     C                   Eval      MPSlsh = SSlsh_16
     C                   Eval      MPNar2 = SNar2_16
     C                   Eval      MPNar3 = SNar3_16
     C                   Eval      MPNar4 = SNar4_16
     C                   Eval      MPOmit = SOmit_16
     C                   Eval      MPNewl = SNewl_16
     C                   Move      SLen1_16      MPLen1
     C                   Move      SLen2_16      MPLen2
     C                   Move      SLen3_16      MPLen3
     C                   Move      SLen4_16      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_16      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_16 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_16      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_16 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_16      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_16 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_16      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     16            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin17       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_17
     C                   Eval      MPNar1 = SNar1_17
     C                   Eval      MPSlsh = SSlsh_17
     C                   Eval      MPNar2 = SNar2_17
     C                   Eval      MPNar3 = SNar3_17
     C                   Eval      MPNar4 = SNar4_17
     C                   Eval      MPOmit = SOmit_17
     C                   Eval      MPNewl = SNewl_17                             G         SH046CC2
     C                   Move      SLen1_17      MPLen1
     C                   Move      SLen2_17      MPLen2
     C                   Move      SLen3_17      MPLen3
     C                   Move      SLen4_17      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_17      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_17 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_17      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_17 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_17      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_17 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_17      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     17            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin18       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_18
     C                   Eval      MPNar1 = SNar1_18
     C                   Eval      MPSlsh = SSlsh_18
     C                   Eval      MPNar2 = SNar2_18
     C                   Eval      MPNar3 = SNar3_18
     C                   Eval      MPNar4 = SNar4_18
     C                   Eval      MPOmit = SOmit_18
     C                   Eval      MPNewl = SNewl_18
     C                   Move      SLen1_18      MPLen1
     C                   Move      SLen2_18      MPLen2
     C                   Move      SLen3_18      MPLen3
     C                   Move      SLen4_18      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_18      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_18 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_18      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_18 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_18      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_18 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_18      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     18            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin19       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_19
     C                   Eval      MPNar1 = SNar1_19
     C                   Eval      MPSlsh = SSlsh_19
     C                   Eval      MPNar2 = SNar2_19
     C                   Eval      MPNar3 = SNar3_19
     C                   Eval      MPNar4 = SNar4_19
     C                   Eval      MPOmit = SOmit_19
     C                   Eval      MPNewl = SNewl_19
     C                   Move      SLen1_19      MPLen1
     C                   Move      SLen2_19      MPLen2
     C                   Move      SLen3_19      MPLen3
     C                   Move      SLen4_19      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_19      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_19 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_19      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_19 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_19      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_19 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_19      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     19            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin20       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_20
     C                   Eval      MPNar1 = SNar1_20
     C                   Eval      MPSlsh = SSlsh_20
     C                   Eval      MPNar2 = SNar2_20
     C                   Eval      MPNar3 = SNar3_20
     C                   Eval      MPNar4 = SNar4_20
     C                   Eval      MPOmit = SOmit_20
     C                   Eval      MPNewl = SNewl_20
     C                   Move      SLen1_20      MPLen1
     C                   Move      SLen2_20      MPLen2
     C                   Move      SLen3_20      MPLen3
     C                   Move      SLen4_20      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_20      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_20 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_20      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_20 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_20      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_20 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_20      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     20            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin21       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_21
     C                   Eval      MPNar1 = SNar1_21
     C                   Eval      MPSlsh = SSlsh_21
     C                   Eval      MPNar2 = SNar2_21
     C                   Eval      MPNar3 = SNar3_21
     C                   Eval      MPNar4 = SNar4_21
     C                   Eval      MPOmit = SOmit_21
     C                   Eval      MPNewl = SNewl_21
     C                   Move      SLen1_21      MPLen1
     C                   Move      SLen2_21      MPLen2
     C                   Move      SLen3_21      MPLen3
     C                   Move      SLen4_21      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_21      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_21 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_21      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_21 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_21      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_21 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_21      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     21            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C     DsLin22       Ifne      *Blanks
     C                   Eval      MPSwcd = SSwcd_22
     C                   Eval      MPNar1 = SNar1_22
     C                   Eval      MPSlsh = SSlsh_22
     C                   Eval      MPNar2 = SNar2_22
     C                   Eval      MPNar3 = SNar3_22
     C                   Eval      MPNar4 = SNar4_22
     C                   Eval      MPOmit = SOmit_22
     C                   Eval      MPNewl = SNewl_22
     C                   Move      SLen1_22      MPLen1
     C                   Move      SLen2_22      MPLen2
     C                   Move      SLen3_22      MPLen3
     C                   Move      SLen4_22      MPLen4
     C                   Z-Add     0             MPNex1
     C                   Z-Add     0             MPNex2
     C                   Z-Add     0             MPNex3
     C                   Z-Add     0             MPNex4

     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar1_22      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX1
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX1
     C                   else
     C                   Move      Nm12          MPNEX1
     C                   Endif
     C                   Endif
     C                   If        SNar2_22 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar2_22      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX2
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX2
     C                   else
     C                   Move      Nm12          MPNEX2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar3_22 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar3_22      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX3
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX3
     C                   else
     C                   Move      Nm12          MPNEX3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        SNar4_22 <> *Blanks
     C                   Move      *Blanks       DSNarr
     C                   MoveL     SNar4_22      DSNarr
     C                   If        PNarW = 'PNAR'
     C                   Z-Add     50            MPNEX4
     C                   else
     C                   If        Num2 = *Blank
     C                   Move      Num1          MPNEX4
     C                   else
     C                   Move      Nm12          MPNEX4
     C                   Endif
     C                   Endif
     C                   Endif

     C                   Z-Add     22            MPSeqn
     C                   Write     A6M940D0
     C                   Endif

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ClrMsgQue - Clear program message queue                       *
      *                                                               *
      *****************************************************************
      *
     C     ClrMsgQue     BEGSR

      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      PsProcName    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR
      *
      *
     C     ZAPGM         IFEQ      *BLANK
     C                   Movel     PsProcName    ZAPGM
     C                   ENDIF
      *
      ** If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'GBSDU'       ZAMSGF
     C                   MOVE      'SRMSG'       ZAMSGF
     C                   ENDIF
      *
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGM                          Program queue
     C                   Parm                    ZAPGRL                         Rel queue
     C                   Parm                    ZAMSID                         Message Id
     C                   Parm                    ZAMSGF                         Message file
     C                   Parm                    ZAMSDA                         Message data
     C                   Parm                    ZAMSTP                         Message type
      *
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGM
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   If        WRun = *BLANKS
     C                   Eval      WRun = 'Y'
     C                   Dump
     C                   Endif

     C                   Eval      PRtrn = '*Error'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
      *
     C                   Return
      *
     C                   ENDSR
      *
      *****************************************************************
** NAR1
BAEX1
BAEX2
BAEX3
BAEX4
BAEX5
BAEX6
BAEX7
BAEX8
BAEX9
BAEX10
BAEX11
BAEX12
BAEX13
BAEX14
BAEX15
BAEX16
BAEX17
BAEX18
BAEX19
BAEX20
BAEX21
BAEX22
PNAR
