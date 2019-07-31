     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF RE Interim Interest Statement Extract')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG000002 - Midas OF RE Interim Interest Statement Extract    *
      *                                                               *
      *  Function:  This program generates the Interim Interest       *
      *             Statement for those accounts for which it is due. *
      *                                                               *
      *  Called By: CG000001 - Midas OF RE Interim Interest           *
      *                        Statement Driver                       *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032162A          Date 12Feb15               *
      *                 MD032161           Date 29Jan15               *
      *                 MD032162           Date 29Jan15               *
      *                 MD032091           Date 26Jan15               *
      *                 MD032013           Date 20Jan15               *
      *                 MD031602           Date 09Dec14               *
      *                 CRE101   *Create   Date 06Oct14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032162A - Set Last Statement Date = 1Jan72 for CM fmt      *
      *  MD032161 - New requirements in the set-up of the Start Date  *
      *  MD032162 - Include Last Statement Date element in the advice *
      *  MD032091 - New flag for back-valuations                      *
      *  MD032013- No End /Postings Tag in statement                 *
      *  MD031602 - IIS changes on IIS Ind and CurPeriod flag         *
      *  CRE101 - Interim Interest Statement on a frequency           *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FREINTHI0  IF   E           K Disk

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D WCPrtItmTyp     C                   CONST('STATEMENT')
      ** Print Item Type

     D WCPrtItmSubTyp  C                   CONST('INTEREST')
      ** Print Item Sub-Type

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for SD Customer details file

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure Currency details

     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      ** Data structure A/c officer details

     D DSACCNT       E DS                  EXTNAME(ACCNTAB)
      ** Data structure Account details

     D DSACMI        E DS                  EXTNAME(GLACMI1D)                                MD031602
      ** Data structure Account ext details                                                 MD031602

     D REINTH        E DS                  EXTNAME(REINTHTD)
      ** Data structure for RE Int History details

     D RESTMT        E DS                  EXTNAME(RESTMTTD)
      ** Data structure for RE Statements due

     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file

     D WMDsPath        DS                  OCCURS(20)
      ** Multi-occurence data structure to store path starting from Z_STMT
     D  WMDsPathGrp            1      6

     D                 DS
      ** General data structure to define fields that need to share data
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)

     D DSPARM          DS
     D  PIsCnum                1      6
     D  PIsCcy                 7      9
     D  PIsAcod               10     19  0
     D  PIsAcsq               20     21  0
     D  PIsBrca               22     24
     D  PIsAcno               25     34  0
     D  PIsStdt               35     39  0
     D  PIsCrpr               40     44  0
     D  PIsEddt               45     49  0
     D  PIsStmd               50     54  0
     D  PIsType               55     64
     D  PIsCfbl               65     79  0
     D  PIsBVal               80     80                                          MD032091
      ** Data Structure of Parameters Passed from CG000001

     D LIST1_DS        DS                                                        MD032091
     D  RIsCfbl                1     15  0                                       MD032091
     D  RIsEddt               16     20  0                                                  MD032162

     D LIST2_DS        DS                                                        MD032091
     D  IACnum                 1      6                                          MD032091
     D  IAccy                  7      9                                          MD032091
     D  IAAcod                10     19  0                                       MD032091
     D  IAAcsq                20     21  0                                       MD032091
     D  IABrca                22     24                                          MD032091
     D  IAPstd                25     27P 0                                       MD032091
     D  IAVald                28     30P 0                                       MD032091
     D  IAGetp                31     31                                          MD032091
     D  IRHisd                32     34P 0                                       MD032091
     D  IRPdid                35     37P 0                                       MD032091
     D  IRPcid                38     40P 0                                       MD032091

     D LIST3_DS        DS                                                                   MD032161
     D  REddt                  1      5  0                                                  MD032161

      ** Compile-time array to contain RDE definitions
     D*WTbGrp***       S             10    DIM(77) CTDATA PERRCD(1)                         MD032091
     D*WTbRDE***       S             22    DIM(77) ALT(WTbGrp)                              MD032091
     D*WTbGrp***       S             10    DIM(78) CTDATA PERRCD(1)                MD032091 MD032162
     D*WTbRDE***       S             22    DIM(78) ALT(WTbGrp)                     MD032091 MD032162
     D WTbGrp          S             10    DIM(79) CTDATA PERRCD(1)                         MD032162
     D WTbRDE          S             22    DIM(79) ALT(WTbGrp)                              MD032162

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WPathStr        S            256A
      ** String that contains the concatenated path

     D WPx             S              3P 0
      ** Index for WMDsPath only

     D ##ITEM          S              8  0
      ** Confirmation Text code

      ** General purpose variables
     D WProduce        S              1A
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D BranchName      S             30A
     D WAmt            S             15S 0
     D WRat            S             11S 7
     D WChqNA          S              8A
     D WTratA          S              5A
     D WStdt           S              5S 0
     D K_Brca          S              3A
     D K_Cnum          S              6A
     D K_Ccy           S              3A
     D K_Acod          S             10S 0
     D K_Acsq          S              2S 0

      ** Parameter fields
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D CCG015          S              1A
     D W0SPAT          S             70A
     D WEddt           S              5S 0                                       MD032091
     D LstStmtD        S              5S 0 INZ(1)                                MD032162A

     D/COPY CGCPYSRC,CGPACKDLE
      ** Data pack arrays and data structures

     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, data structures, arrays definition for
      ** CG error processing

     IREINTHD2      22
     IREINTHD3      23
     IREINTHD1      24
     IAPOSTPDF      33
     IGLACPHPF      34

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'MAIN      '  @STK(Q)

      ** Execute main subroutine

     C                   EXSR      SrMain

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

      ** Termination

     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMain - Performs validation and invokes top group set.      *
      *                                                               *
      *****************************************************************
     C     SrMain        BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrMain    '  @STK(Q)

      ** Generate reference number by writing to PF/CGUDCRPD.
      ** If no confirmation to produce, then bypass.

     C                   EXSR      SrGenRef

      ** Top group set

     C                   IF        WProduce = 'Y'
     C                   If        PIsBval = *Blank                              MD032091
     C                   EXSR      SrSetStdt                                     MD032091
     C                   Endif                                                   MD032091
     C                   EXSR      SrSetCfbl
     C                   EXSR      SrIIStatm
     C                   ENDIF

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIIStatm - Top group set                                    *
      *                                                               *
      *****************************************************************
     C     SrIIStatm     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrIIStatm '  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_STMT'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Header (Simple)

     C                   EXSR      SrHdrDet

      ** Branch (Simple)

     C                   EXSR      SrBranch

      ** Account (Simple)

     C                   EXSR      SrAccount

      ** Customer (Simple)

     C                   EXSR      SrCustomer

      ** Account Officer (Simple)

     C                   EXSR      SrAcOfficer

      ** Currency (Simple)

     C                   EXSR      SrCurrency

      ** Opening Balance (Simple)

     C                   EXSR      SrOpeningBal

      ** Daily Info (Complex)

     C                   EXSR      SrDailyInfo

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetCfbl - Set Carried forward balance                      *
      *                                                               *
      *****************************************************************
     C     SrSetCfbl     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrSetCfbl '  @STK(Q)

     C                   clear                   REINTH

      ** Retrieve End record from REINTHTD

     C/exec SQL
     C+ Select * into :REINTH
     C+ From REINTHTD
     C+ where IhCnum = :PIsCnum
     C+   and IhAcod = :PIsAcod
     C+   and IhAcsq = :PIsAcsq
     C+   and IhCcy = :PIsCcy
     C+   and IhBrca = :PIsBrca
     C+   and IhHisd = :PIsEddt
     C+   and IhMvnt <> 'C'
     C/end-exec

     C                   Eval      PIsCfbl = IhHisb

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
                                                                                MD032091
      *****************************************************************         MD032091
      /EJECT                                                                    MD032091
      *****************************************************************         MD032091
      *                                                               *         MD032091
      *  SrSetStdt - Check for back-valued postings today             *         MD032091
      *                                                               *         MD032091
      *****************************************************************         MD032091
     C     SrSetStdt     BEGSR                                                  MD032091
                                                                                MD032091
      ** Set up subroutine stack name                                           MD032091
                                                                                MD032091
     C                   ADD       1             Q                              MD032091
     C                   MOVEL     'SrSetStdt '  @STK(Q)                        MD032091
     C/exec SQL                                                                 MD032091
     C+ declare LIST2 cursor for                                                MD032091
     C+ Select a.Cnum, a.Ccy, a.ACod, a.Acsq, a.Brca, a.Pstd, a.Vald,           MD032091
     C+  a.getp, b.hisd, b.pdid, b.pcid                                         MD032091
     C+ From APOSTPD a                                                          MD032091
     C+ Inner Join REHISPD b ON b.Brca = a.Brca and b.Cnum = a.Cnum and         MD032091
     C+ b.CCY = a.Ccy and b.Acod = a.Acod AND b.Acsq = a.Acsq and               MD032091
     C+ b.Hisd = a.Vald                                                         MD032091
     C+ where a.Pstd + 1 >= :PIsCrpr                                            MD032091
     C+   and a.Pstd <= :PIsEddt                                                MD032091
     C+   and a.Vald < :PIsCrpr                                                 MD032091
     C+   and a.Cnum = :PIsCnum                                                 MD032091
     C+   and a.Acod = :PIsAcod                                                 MD032091
     C+   and a.Acsq = :PIsAcsq                                                 MD032091
     C+   and a.Brca = :PIsBrca                                                 MD032091
     C+   and a.Ccy = :PIsCcy                                                   MD032091
     C+   and a.Getp = 'C'                                                      MD032091
     C+   or a.Pstd >= :PIsCrpr                                                 MD032091
     C+   and a.Pstd <= :PIsEddt                                                MD032091
     C+   and a.Vald < :PIsCrpr                                                 MD032091
     C+   and a.Cnum = :PIsCnum                                                 MD032091
     C+   and a.Acod = :PIsAcod                                                 MD032091
     C+   and a.Acsq = :PIsAcsq                                                 MD032091
     C+   and a.Brca = :PisBrca                                                 MD032091
     C+   and a.Ccy = :PIsCcy                                                   MD032091
     C+   and a.Getp <> 'C'                                                     MD032091
     C+ Order by                                                                MD032091
     C+       a.CNUM, a.CCY, a.ACOD, a.ACSQ, a.BRCA, a.VALD                     MD032091
     C/End-Exec                                                                 MD032091
                                                                                MD032091
     C/exec SQL                                                                 MD032091
     C+ open LIST2                                                              MD032091
     C/end-exec                                                                 MD032091
                                                                                MD032091
      ** Handle SQL Error (if not %EOF)                                         MD032091
     C                   If        SQLCOD < 0                                   MD032091
     C     *LOCK         IN        LDA                                          MD032091
     C                   eval      DBASE = 2                                    MD032091
     C                   eval      DBFILE = 'SQL STM'                           MD032091
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT                 MD032091
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)       MD032091
     C                   Out       LDA                                          MD032091
     C                   Exsr      *PSSR                                        MD032091
     C                   EndIf                                                  MD032091
                                                                                MD032091
     C/exec SQL                                                                 MD032091
     C+ fetch next                                                              MD032091
     C+ from LIST2                                                              MD032091
     C+ into :LIST2_DS                                                          MD032091
     C/end-exec                                                                 MD032091
                                                                                MD032091
     C                   If        SQLCode <> 100                               MD032091
     C/exec SQL                                                                             MD032161
     C+ declare LIST3 cursor for                                                            MD032161
     C+ Select a.IsEddt                                                                     MD032161
     C+ From RESTMTTD a                                                                     MD032161
     C+ where IsCnum = :PIsCnum                                                             MD032161
     C+   and IsAcod = :PIsAcod                                                             MD032161
     C+   and IsAcsq = :PIsAcsq                                                             MD032161
     C+   and IsCcy = :PIsCcy                                                               MD032161
     C+   and IsBrca = :PIsBrca                                                             MD032161
     C+   and IsStat = 'Y'                                                                  MD032161
     C+   and IsEddt < :IAVald                                                              MD032161
     C+ Order by                                                                            MD032161
     C+       a.IsCNUM, a.IsCCY, a.IsACOD, a.IsACSQ, a.IsBRCA, a.IsEddt                     MD032161
     C+ Desc                                                                                MD032161
     C/end-exec                                                                             MD032161
                                                                                            MD032161
     C/exec SQL                                                                             MD032161
     C+ open LIST3                                                                          MD032161
     C/end-exec                                                                             MD032161
                                                                                            MD032161
      ** Handle SQL Error (if not %EOF)                                                     MD032161
     C                   If        SQLCOD < 0                                               MD032161
     C     *LOCK         IN        LDA                                                      MD032161
     C                   eval      DBASE = 9                                                MD032161
     C                   eval      DBFILE = 'SQL STM'                                       MD032161
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT                             MD032161
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD032161
     C                   Out       LDA                                                      MD032161
     C                   Exsr      *PSSR                                                    MD032161
     C                   EndIf                                                              MD032161
                                                                                            MD032161
     C/exec SQL                                                                             MD032161
     C+ fetch next                                                                          MD032161
     C+ from LIST3                                                                          MD032161
     C+ into :LIST3_DS                                                                      MD032161
     C/end-exec                                                                             MD032161
                                                                                            MD032161
      ** Handle SQL Error (if not %EOF)                                                     MD032161
     C                   If        SQLCode < 0                                              MD032161
     C     *LOCK         IN        LDA                                                      MD032161
     C                   EVAL      DBASE = 10                                               MD032161
     C                   EVAL      DBFILE = 'SQL STM'                                       MD032161
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD032161
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD032161
     C                   OUT       LDA                                                      MD032161
     C                   EXSR      *PSSR                                                    MD032161
     C                   EndIf                                                              MD032161
                                                                                            MD032161
     C                   If        SQLCode <> 100                                           MD032161
     C                   eval      PIsStdt = REddt                                          MD032161
     C                   else                                                               MD032161
     C                   If        IRPDID >= IRPCID                                MD032091
     C**********         eval      PIsStdt = IRPDID + 1                            MD032091 MD032161
     C                   eval      PIsStdt = IRPDID                                         MD032161
     C                   else                                                      MD032091
     C**********         eval      PIsStdt = IRPCID + 1                            MD032091 MD032161
     C                   eval      PIsStdt = IRPCID                                         MD032161
     C                   Endif                                                     MD032091
     C                   Endif                                                              MD032161
     C                   If        PIsStdt <> DACO                                          MD032161
     C                   eval      PIsStdt = PIsStdt + 1                                    MD032161
     C                   Endif                                                              MD032161
                                                                                            MD032161
     C/exec SQL                                                                             MD032161
     C+ close LIST3                                                                         MD032161
     C/end-exec                                                                             MD032161
     C                   eval      PIsBval = 'Y'                                MD032091
     C                   Endif                                                  MD032091
                                                                                MD032091
      ** Handle SQL Error (if not %EOF)                                         MD032091
     C                   If        SQLCode < 0                                  MD032091
     C     *LOCK         IN        LDA                                          MD032091
     C                   EVAL      DBASE = 4                                    MD032091
     C                   EVAL      DBFILE = 'SQL STM'                           MD032091
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                 MD032091
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)       MD032091
     C                   OUT       LDA                                          MD032091
     C                   EXSR      *PSSR                                        MD032091
     C                   EndIf                                                  MD032091
                                                                                MD032091
     C/exec SQL                                                                 MD032091
     C+ close LIST2                                                             MD032091
     C/end-exec                                                                 MD032091
                                                                                MD032091
      ** Unwind subroutine stack name                                           MD032091
                                                                                MD032091
     C                   MOVEA     *BLANKS       @STK(Q)                        MD032091
     C                   SUB       1             Q                              MD032091

     C                   ENDSR                                                  MD032091
                                                                                MD032091
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHdrDet - Header details                                    *
      *                                                               *
      *****************************************************************
     C     SrHdrDet      BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrHdrDet  '  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_SHDR'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_SHDR'      WGrpNme
     C                   EXSR      SrRtvRDE

      ***AdHocIndicator***
      ** Interim Interest Statement Indicator                                               MD031602
                                                                                            MD031602
     C/exec SQL                                                                             MD031602
     C+ Select * into :DSACMI                                                               MD031602
     C+ From GLACMI1D                                                                       MD031602
     C+ where MiBrca = :PIsBrca                                                             MD031602
     C+   and MiCnum = :PIsCnum                                                             MD031602
     C+   and MiAcod = :PIsAcod                                                             MD031602
     C+   and MiAcsq = :PIsAcsq                                                             MD031602
     C+   and MiCcy = :PIsCcy                                                               MD031602
     C/end-exec                                                                             MD031602
     C**********         Movel     'I'           ##D(1)                                     MD031602
     C                   Movel     MiStmi        ##D(1)                                     MD031602

      ** CurrentPeriod
     C                   Movel     PIsCrpr       ##D(2)

      ** Period To - End date
     C                   Movel     PIsEddt       ##D(3)

      ** Period From - Start Date
     C                   Movel     PIsStdt       ##D(4)

      ** Statement Type
     C                   Movel     PIsType       ##D(5)
                                                                                            MD032091
      ** Back-valuations Flag                                                               MD032091
     C                   Movel     PIsBval       ##D(6)                                     MD032091

      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBranch - Branch details                                    *
      *                                                               *
      *****************************************************************
     C     SrBranch      BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrBranch  '  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'BRANCH'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'BRANCH'      WGrpNme
     C                   EXSR      SrRtvRDE

      ** Branch Code
     C                   Movel     PIsBrca       ##D(1)

     C/exec SQL
     C+ Select A8Brnm into :BranchName
     C+ From SDBRCHPD
     C+ where A8Brcd = :PIsBrca
     C/end-exec

      ** Branch Name
     C                   Movel     BranchName    ##D(2)


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccount - Account details                                  *
      *                                                               *
      *****************************************************************
     C     SrAccount     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrAccount '  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'ACCNT'       WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'ACCNT '      WGrpNme
     C                   EXSR      SrRtvRDE

      ** Account Id
     C                   Movel     A5Acky        ##D(1)

      ** Account Name
     C                   Movel     ANAM          ##D(2)

      ** Account Type
     C                   Movel     ATYP          ##D(3)

      ** IBAN
     C                   Movel     IBAN          ##D(4)

      ** Retail A/c Number
     C                   Movel     ACNO          ##D(5)


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCustomer - Customer Details                                *
      *                                                               *
      *****************************************************************
     C     SrCustomer    BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrCustomer'  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CUST'        WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'CUST  '      WGrpNme
     C                   EXSR      SrRtvRDE

     C/exec SQL
     C+ Select * into :SDCUST
     C+ From SDCUSTPD
     C+ where BBCUST = :PIsCnum
     C/end-exec

      ** Customer
     C                   Movel     BBCust        ##D(1)

      ** Customer Name
     C                   Movel     BBCrnm        ##D(2)

      ** Customer Town
     C                   Movel     BBCrTn        ##D(3)

      ** Cust Addr 1
     C                   Movel     BBCna1        ##D(4)

      ** Cust Addr 2
     C                   Movel     BBCna2        ##D(5)

      ** Cust Addr 3
     C                   Movel     BBcna3        ##D(6)

      ** Cust Addr 4
     C                   Movel     BBCna4        ##D(7)


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAcOfficer - Account Officer Details                        *
      *                                                               *
      *****************************************************************
     C     SrAcOfficer   BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrAcOfficer' @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'ACOF'        WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'ACOF  '      WGrpNme
     C                   EXSR      SrRtvRDE

     C/exec SQL
     C+ Select * into :SDACOF
     C+ From SDACOFPD
     C+ where AZACOC = :BBAcoc
     C/end-exec

      ** Acc Officer Code
     C                   Movel     AzAcoc        ##D(1)

      ** Acc Officer Dept Code
     C                   Movel     AzDpcd        ##D(2)

      ** Acc Officer Name
     C                   Movel     AzAcon        ##D(3)

      ** Acc Officer Tel Ext
     C                   Movel     AzAext        ##D(4)

      ** Acc Officer Tel No
     C                   Movel     AzAphn        ##D(5)


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurrency - Currency Details                                *
      *                                                               *
      *****************************************************************
     C     SrCurrency    BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrCurrency'  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CCY'         WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'CCY   '      WGrpNme
     C                   EXSR      SrRtvRDE

     C/exec SQL
     C+ Select * into :SDCURR
     C+ From SDCURRPD
     C+ where A6CYCD = :PIsCcy
     C/end-exec

      ** Currency Code
     C                   Movel     A6CYCD        ##D(1)

      ** Currency Name
     C                   Movel     A6CYNM        ##D(2)

      ** Precious Metal Ind
     C                   Movel     A6Pmrt        ##D(3)



      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOpeningBal - Opening Balance detail                        *
      *                                                               *
      *****************************************************************
     C     SrOpeningBal  BEGSR

     C                   clear                   REINTH

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrOpeningBal'@STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_OBAL'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_OBAL'      WGrpNme
     C                   EXSR      SrRtvRDE

     C                   If        PIsBval = 'Y'                                 MD032091
     C                   Eval      WStdt = PIsStdt - 1
     C                   else                                                    MD032091
     C                   Eval      WStdt = PIsCrpr - 1                           MD032091
     C                   Endif                                                   MD032091

     C/exec SQL
     C+ Declare C_REINTH scroll cursor for
     C+ Select * from REINTHTD
     C+ where IhCnum = :PIsCnum
     C+   and IhAcod = :PIsAcod
     C+   and IhAcsq = :PIsAcsq
     C+   and IhCcy = :PIsCcy
     C+   and IhBrca = :PIsBrca
     C+   and IhHisd = :WStdt
     C+ order by IhBrca, IhCnum, IhCcy, IhAcod, IhAcsq, IhHisd
     C/end-exec

     C/exec SQL
     C+ open C_REINTH
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   eval      DBASE = 3
     C                   eval      DBFILE = 'SQL STM'
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch after from C_REINTH
     C/end-exec

     C/exec SQL
     C+ fetch prior
     C+ from C_REINTH
     C+ into :REINTH
     C/end-exec

     C                   If        SQLCode <> 100

      ** History Balance

     C                   eval      R#Data = *Blanks

     C                   If        IhHisb < *Zero
     C                   z-sub     IhHisb        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhHisb        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA
     C                   Movel     R#Data        ##D(1)

     C                   Endif

     C/exec SQL
     C+ close C_REINTH
     C/end-exec

      ** Retrieve Carried fwd balance from last statement

     **********C/exec SQL                                                       MD032091
     **********C+ Select * into :RESTMT                                         MD032091
     **********C+ From RESTMTTD                                                 MD032091
     **********C+ where IsCnum = :PIsCnum                                       MD032091
     **********C+   and IsAcod = :PIsAcod                                       MD032091
     **********C+   and IsAcsq = :PIsAcsq                                       MD032091
     **********C+   and IsCcy = :PIsCcy                                         MD032091
     **********C+   and IsBrca = :PIsBrca                                       MD032091
     **********and IsEddt = :PIsCrpr                                            MD032091
     **********C/end-exec                                                       MD032091

     C/exec SQL                                                                 MD032091
     C+ declare LIST1 cursor for                                                MD032091
     C**Select*a.IsCfbl                                                         MD032091    MD032162
     C+ Select a.IsCfbl, a.IsEddt                                                           MD032162
     C+ From RESTMTTD a                                                         MD032091
     C+ where IsCnum = :PIsCnum                                                 MD032091
     C+   and IsAcod = :PIsAcod                                                 MD032091
     C+   and IsAcsq = :PIsAcsq                                                 MD032091
     C+   and IsCcy = :PIsCcy                                                   MD032091
     C+   and IsBrca = :PIsBrca                                                 MD032091
     C+   and IsStat = 'Y'                                                      MD032091
     C****and*IsStmd < :Bjrdnb                                                  MD032091    MD032162
     C+   and IsStmd < :PIsStmd                                                             MD032162
     C+ Order by                                                                MD032091
     C+       a.IsCNUM, a.IsCCY, a.IsACOD, a.IsACSQ, a.IsBRCA, a.IsStmd         MD032091
     C+ Desc                                                                    MD032091
     C/end-exec                                                                 MD032091
                                                                                MD032091
     C/exec SQL                                                                 MD032091
     C+ open LIST1                                                              MD032091
     C/end-exec                                                                 MD032091
                                                                                MD032091
      ** Handle SQL Error (if not %EOF)                                         MD032091
     C                   If        SQLCOD < 0                                   MD032091
     C     *LOCK         IN        LDA                                          MD032091
     C                   eval      DBASE = 7                                    MD032091
     C                   eval      DBFILE = 'SQL STM'                           MD032091
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT                 MD032091
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)       MD032091
     C                   Out       LDA                                          MD032091
     C                   Exsr      *PSSR                                        MD032091
     C                   EndIf                                                  MD032091
                                                                                MD032091
     C/exec SQL                                                                 MD032091
     C+ fetch next                                                              MD032091
     C+ from LIST1                                                              MD032091
     C+ into :LIST1_DS                                                          MD032091
     C/end-exec                                                                 MD032091
                                                                                MD032091
      ** Handle SQL Error (if not %EOF)                                         MD032091
     C                   If        SQLCode < 0                                  MD032091
     C     *LOCK         IN        LDA                                          MD032091
     C                   EVAL      DBASE = 8                                    MD032091
     C                   EVAL      DBFILE = 'SQL STM'                           MD032091
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                 MD032091
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)       MD032091
     C                   OUT       LDA                                          MD032091
     C                   EXSR      *PSSR                                        MD032091
     C                   EndIf                                                  MD032091
                                                                                MD032091
     C                   If        SQLCode <> 100
     C**********         If        IsCfbl < *Zero                               MD032091
     C**********         z-sub     IsCfbl        WAmt                           MD032091
     C                   If        RIsCfbl < *Zero                              MD032091
     C                   z-sub     RIsCfbl       WAmt                           MD032091
     C                   eval      ##Sign = '-'
     C                   else
     C**********         z-add     IsCfbl        WAmt                           MD032091
     C                   z-add     RIsCfbl       WAmt                           MD032091
     C                   eval      ##Sign = *Blanks
     C                   Endif
     C/exec SQL                                                                 MD032091
     C+ close LIST1                                                             MD032091
     C/end-exec                                                                 MD032091

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA
     C                   Movel     R#Data        ##D(2)
                                                                                MD032162
      ** Last Statement date                                                    MD032162
     C                   Movel     RIsEddt       ##D(3)                         MD032162
                                                                                MD032162
     C                   else                                                   MD032162A
     C                   Movel     LstStmtD      ##D(3)                         MD032162A
     C                   Endif

      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDailyInfo - Daily Info                                     *
      *                                                               *
      *****************************************************************
     C     SrDailyInfo   BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrDailyInfo' @STK(Q)

      ***Set*up*path*multi-occurence*data*structure*&*path*string                           MD032013

     C**********         ADD       1             WPx                                        MD032013
     C*****WPx**         OCCUR     WMDsPath                                                 MD032013
     C**********         MOVEL     'Z_DAYI'      WMDsPathGrp                                MD032013

     C**********         EXSR      SrPath                                                   MD032013

     C**********         EXSR      PSHGRS                                                   MD032013

     C                   Eval      K_Brca = PIsBrca
     C                   Eval      K_Cnum = PIsCnum
     C                   Eval      K_Ccy  = PIsCcy
     C                   Eval      K_Acod = PIsAcod
     C                   Eval      K_Acsq = PIsAcsq
     C                   Eval      Vald = PIsStdt

     C                   Eval      *In22 = *Off
     C                   Eval      *In23 = *Off
     C                   Eval      *In24 = *Off
     C                   Eval      *In33 = *Off
     C                   Eval      *In34 = *Off

     C     KAcctVald     Setll     REINTHI0
     C     KAcct         Reade     REINTHI0

     C                   If        Not %Eof(REINTHI0)
     C                   DoU       %Eof(REINTHI0)

     C                   ADD       1             WPx                                        MD032013
     C     WPx           OCCUR     WMDsPath                                                 MD032013
     C                   MOVEL     'Z_DAYI'      WMDsPathGrp                                MD032013
     C                   EXSR      SrPath                                                   MD032013
     C                   EXSR      PSHGRS                                                   MD032013
                                                                                            MD032013
     C                   Select
     C                   When      *In22 = *On
     C                             Or *In23 = *On
     C                             Or *In24 = *On
     C                   If        IhHisD <= PIsEddt
     C                   Exsr      SrInterest
     C                   Endif
     C                   When      *In33 = *On
     C                             Or *In34 = *On
     C                   Exsr      SrMovement
     C                   Endsl

     C     WPx           OCCUR     WMDsPath                                                 MD032013
     C                   CLEAR                   WMDsPathGrp                                MD032013
     C                   SUB       1             WPx                                        MD032013
     C                   EXSR      POPGRS                                                   MD032013
                                                                                            MD032013
     C                   Eval      *In22 = *Off
     C                   Eval      *In23 = *Off
     C                   Eval      *In24 = *Off
     C                   Eval      *In33 = *Off
     C                   Eval      *In34 = *Off

     C     KAcct         Reade     REINTHI0


     C                   Enddo

      * Get next day capitalisation
     C                   Eval      K_Brca = PIsBrca
     C                   Eval      K_Cnum = PIsCnum
     C                   Eval      K_Ccy  = PIsCcy
     C                   Eval      K_Acod = PIsAcod
     C                   Eval      K_Acsq = PIsAcsq
     C                   Eval      Vald = PIsEddt + 1

     C/exec SQL
     C+ declare LISTA cursor for
     C+ Select * from REINTHTD
     C+ where IhCnum = :PIsCnum
     C+   and IhAcod = :PIsAcod
     C+   and IhAcsq = :PIsAcsq
     C+   and IhCcy = :PIsCcy
     C+   and IhBrca = :PIsBrca
     C+   and IhHisd = :Vald
     C/end-exec

     C/exec SQL
     C+ open LISTA
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTA
     C+ into :REINTH
     C/end-exec

     C                   If        SQLCode <> 100
                                                                                            MD032013
     C                   ADD       1             WPx                                        MD032013
     C     WPx           OCCUR     WMDsPath                                                 MD032013
     C                   MOVEL     'Z_DAYI'      WMDsPathGrp                                MD032013
     C                   EXSR      SrPath                                                   MD032013
     C                   EXSR      PSHGRS                                                   MD032013
                                                                                            MD032013
     C                   Exsr      SrInterest
                                                                                            MD032013
     C     WPx           OCCUR     WMDsPath                                                 MD032013
     C                   CLEAR                   WMDsPathGrp                                MD032013
     C                   SUB       1             WPx                                        MD032013
     C                   EXSR      POPGRS                                                   MD032013
                                                                                            MD032013
     C                   Endif

     C/exec SQL
     C+ close LISTA
     C/end-exec
     C                   Endif

      ***Decrement*Path*DS*index                                                            MD032013

     C*****WPx**         OCCUR     WMDsPath                                                 MD032013
     C**********         CLEAR                   WMDsPathGrp                                MD032013
     C**********         SUB       1             WPx                                        MD032013

     C**********         EXSR      POPGRS                                                   MD032013

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInterest - Interest details                                *
      *                                                               *
      *****************************************************************
     C     SrInterest    BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrInterest'  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_INTD'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      * Interest Details 1

     C                   EXSR      SrIntDet1

      * Interest Details 2

     C                   EXSR      SrIntDet2

      * Interest Details - Period details

     C                   EXSR      SrPeriodIn

      * Interest Details - Overdraft details

     C                   EXSR      SrODDetail


      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIntDet1  - Interest details part 1                         *
      *                                                               *
      *****************************************************************
     C     SrIntDet1     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrIntDet1 '  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_INT1'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_INT1'      WGrpNme
     C                   EXSR      SrRtvRDE

      ** Start Record

     C                   If        IhStrt <> *Blanks
     C                   Movel     IhStrt        ##D(1)
     C                   Endif

      * Movement/Accrual
     C                   If        IHMVNT <> *Blanks
     C                   Movel     IhMvnt        ##D(2)
     C                   Endif

      * Debit Rate Change
     C                   If        IHDRCI <> *Blanks
     C                   Movel     IhDrci        ##D(3)
     C                   Endif

      * Credit Rate Change
     C                   If        IHCRCI <> *Blanks
     C                   Movel     IhCrci        ##D(4)
     C                   Endif

      * Debit Capitalisation
     C                   If        IHDRCP <> *Blanks
     C                   Movel     IhDrcp        ##D(5)
     C                   Endif

      * Credit Capitalisation
     C                   If        IHCRCP <> *Blanks
     C                   Movel     IhCrcp        ##D(6)
     C                   Endif

      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIntDet2  - Interest details part 2                         *
      *                                                               *
      *****************************************************************
     C     SrIntDet2     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrIntDet2 '  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_INT2'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_INT2'      WGrpNme
     C                   EXSR      SrRtvRDE

      * History Date
     C                   Movel     IhHisd        ##D(1)

      * History Balance
     C                   eval      R#Data = *Blanks

     C                   If        IhHisb < *Zero
     C                   z-sub     IhHisb        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhHisb        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(2)

      * Debit Movements
     C                   eval      R#Data = *Blanks

     C                   If        IhDmvt < *Zero
     C                   z-sub     IhDmvt        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhDmvt        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(3)

      * Credit Movements
     C                   eval      R#Data = *Blanks

     C                   If        IhCmvt < *Zero
     C                   z-sub     IhCmvt        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhCmvt        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(4)

      * Debit Rate Used
     C                   eval      R#Data = *Blanks

     C                   If        IhDrir < *Zero
     C                   z-sub     IhDrir        WRat
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhDrir        WRat
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      '7'           ##DCPA
     C                   Movel     WRat          ##NUMA

     C                   Movel     R#Data        ##D(5)

      * Credit Rate Used
     C                   eval      R#Data = *Blanks

     C                   If        IhCrir < *Zero
     C                   z-sub     IhCrir        WRat
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhCrir        WRat
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      '7'           ##DCPA
     C                   Movel     WRat          ##NUMA

     C                   Movel     R#Data        ##D(6)

      * Number of Accrued Days
     C                   If        IhADay > 0
     C                   eval      R#Data = *Blanks
     C                   z-add     IhADay        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Move      '0'           ##DCPA
     C                   Movel     WAmt          ##NUMA
     C                   Movel     R#Data        ##D(7)
     C                   Endif


      * Debit Interest Accrued
     C                   Eval      R#Data = *Blanks

     C                   If        IhDrac < *Zero
     C                   z-sub     IhDrac        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhDrac        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(8)

      * Credit Interest Accrued
     C                   Eval      R#Data = *Blanks

     C                   If        IhCrac < *Zero
     C                   z-sub     IhCrac        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhCrac        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(9)

      * Debit Int. Accrued Balance
     C                   Eval      R#Data = *Blanks

     C                   If        IhDrab < *Zero
     C                   z-sub     IhDrab        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhDrab        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(10)

      * Credit Int. Accrued Balance
     C                   Eval      R#Data = *Blanks

     C                   If        IhCrab < *Zero
     C                   z-sub     IhCrab        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhCrab        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(11)

      * Debit Int. Posted
     C                   Eval      R#Data = *Blanks

     C                   If        IhDrIP < *Zero
     C                   z-sub     IhDrIP        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhDrIP        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(12)

      * Credit Int. Posted
     C                   Eval      R#Data = *Blanks

     C                   If        IhCrIP < *Zero
     C                   z-sub     IhCrIP        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhCrIP        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(13)

      * Debit Int. Not Posted
     C                   Eval      R#Data = *Blanks

     C                   If        IhDrIA < *Zero
     C                   z-sub     IhDrIA        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhDrIA        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(14)

      * Credit Int. Not Posted
     C                   Eval      R#Data = *Blanks

     C                   If        IhCrIA < *Zero
     C                   z-sub     IhCrIA        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhCrIA        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(15)

      * Debit Int. Calc. Type
     C                   If        IHDICT <> *Blanks
     C                   Eval      ##D(16) = IHDICT + IHDCST
     C                   Endif

      * Credit Int. Calc. Type
     C                   If        IHCICT <> *Blanks
     C                   Eval      ##D(17) = IHCICT + IHCCST
     C                   Endif

      * Debit Int. Calc. Basis
     C                   If        IHDric <> *Blanks
     C                   Eval      ##D(18) = IHDric
     C                   Endif

      * Credit Int. Calc. Basis
     C                   If        IHCric <> *Blanks
     C                   Eval      ##D(19) = IHCric
     C                   Endif


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPeriodIn - Period Details for Interest group set           *
      *                                                               *
      *****************************************************************
     C     SrPeriodIn    BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrPeriodIn'  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_PERI'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_PERI'      WGrpNme
     C                   EXSR      SrRtvRDE

      * Current Period
     C                   Select
     C                   When      IHMVNT = 'C'          And
     C                             IhHisD < PIsCrpr + 1
     C                   Eval      ##D(1) = 'N'
     C                   When      IhHisD < PIsCrpr
     C                   Eval      ##D(1) = 'N'
     C                   Other
     C                   Eval      ##D(1) = 'Y'
     C                   Endsl

      * Type
     C                   Eval      ##D(2) = 'I'


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrODDetail  - Interest details Overdraft                     *
      *                                                               *
      *****************************************************************
     C     SrODDetail    BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrODDetail'  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_ODDT'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_ODDT'      WGrpNme
     C                   EXSR      SrRtvRDE

      * O/D Line change
     C                   If        IHMVNT = 'O'
     C                   Movel     'Y'           ##D(1)
     C                   Endif

      * O/D Line Amount
     C                   eval      R#Data = *Blanks

     C                   If        IhOdln < *Zero
     C                   z-sub     IhOdln        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhOdln        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      '0'           ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(2)

      * O/D Rate
     C                   eval      R#Data = *Blanks

     C                   If        IhAodr < *Zero
     C                   z-sub     IhAodr        WRat
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhAodr        WRat
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      '7'           ##DCPA
     C                   Movel     WRat          ##NUMA

     C                   Movel     R#Data        ##D(3)

      * O/D Rate used flag
     C                   If        IHHISB > IHODLN
     C                             and IHAODR > 0
     C                   Movel     'Y'           ##D(4)
     C                   Endif


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMovement - Movements details                               *
      *                                                               *
      *****************************************************************
     C     SrMovement    BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrMovement'  @STK(Q)

      ** Set up path multi-occurence data structure & path string

     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Z_MVMD'      WMDsPathGrp

     C                   EXSR      SrPath

     C                   EXSR      PSHGRS

      ** Retrieve RDE info

     C                   MOVEL     'Z_MVMD'      WGrpNme
     C                   EXSR      SrRtvRDE

      * Account Balance
     C                   Eval      R#Data = *Blanks

     C                   If        IhHisb < *Zero
     C                   z-sub     IhHisb        WAmt
     C                   eval      ##Sign = '-'
     C                   else
     C                   z-add     IhHisb        WAmt
     C                   eval      ##Sign = *Blanks
     C                   Endif

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(1)

      * Amount
     C                   Eval      R#Data = *Blanks

     C                   If        Drcr = 1
     C                   eval      ##Sign = '-'
     C                   else
     C                   eval      ##Sign = *Blanks
     C                   Endif
     C                   z-add     Psta          WAmt

     C                   Move      A6NBDP        ##DCPA
     C                   Movel     WAmt          ##NUMA

     C                   Movel     R#Data        ##D(2)

      * Batch Item No / Batch No

     C                   Select
     C                   When      Getp = *Blanks
     C                   Eval      ##D(3) = %Subst(Spos:4:3)
     C                   Eval      ##D(4) = %Subst(Spos:1:3)

     C                   When      Getp   = 'G'
     C                   Other
     C                   Endsl

      * Cheque number

     C                   If        ChqN  > 0
     C                   Movel     ChqN          WChqNA
     C                   Eval      ##D(5) = WChqNA
     C                   Endif

      * Generated Entry Type

     C                   If        Getp  <> *Blanks
     C                   Eval      ##D(6) = GetP
     C                   Endif

      * Module

     C                   Select
     C                   When      Getp  = *Blanks
     C                   Eval      ##D(7) = 'ME'

     C                   When      Getp = 'A' Or
     C                             Getp = 'F' Or
     C                             Getp = 'H' Or
     C                             Getp = 'I' Or
     C                             Getp = 'J' Or
     C                             Getp = 'K' Or
     C                             Getp = 'M' Or
     C                             Getp = 'R' Or
     C                             Getp = 'Y' Or
     C                             Getp = 'L' Or
     C                             Getp = 'R'
     C                   Eval      ##D(7) = 'GL'

     C                   When      Getp = 'C' Or
     C                             Getp = 'E' Or
     C                             Getp = 'O' Or
     C                             Getp = 'P' Or
     C                             Getp = 'Q'
     C                   Eval      ##D(7) = 'RE'

     C                   When      Getp = 'D'
     C                   Eval      ##D(7) = 'DL'

     C                   When      Getp = 'G'
     C                   Eval      ##D(7) = 'FT'

     C                   When      Getp = 'S'
     C                   Eval      ##D(7) = 'SE'

     C                   When      Getp = 'T'
     C                   Eval      ##D(7) = 'FO'

     C                   When      Getp = 'U'
     C                   Eval      ##D(7) = 'LE'

     C                   Other
     C                   Eval      ##D(7) = '??'
     C                   Endsl

      * Narrative
     C                   Eval      ##D(8) = PNar

      * Original Reference
     C                   Eval      ##D(9) = OtRf

      * Posting Date
     C                   Movel     PSTD          ##D(10)

      * Swift Common reference
     C                   If        SwCr <> *Blanks
     C                   Eval      ##D(11) = SwCr
     C                   Endif

      * Transaction No
     C                   Select
     C                   When      Getp   = *Blanks
     C                   When      Getp   = 'G'
     C                   Eval      ##D(12) = Pref
     C                   Other
     C                   Eval      ##D(12) = DlRef
     C                   Endsl

      * Transaction Type
     C                   Movel     Trat          WTratA
     C                   Eval      ##D(13) = WTratA

      * Value Date
     C                   Movel     Vald          ##D(14)

      * Advised Booking Date
     C                   Movel     PSTD          ##D(15)

      * Current Period
     C                   Select
     C                   When      Vald > PIsEddt
     C**********         Eval      ##D(16) = 'N'                                            MD031602
     C                   Eval      ##D(16) = 'F'                                            MD031602
     C                   When      Pstd +1 >= PIsCrPr And
     C                             Getp     = 'C'
     C                   Eval      ##D(16) = 'Y'
     C                   When      Vald >= PIsCrPr
     C                   Eval      ##D(16) = 'Y'
     C                   When      Pstd < PIsCrPr
     C                   Eval      ##D(16) = 'N'
     C                   Other
     C                   Eval      ##D(16) = 'Y'
     C                   Endsl

      * Type
     C                   Eval      ##D(17) = 'P'


      ** Accumulate RDEs and associated data and output to CGUDTAPD

     C                   EXSR      SrPackDta

      ** Decrement Path DS index

     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx

     C                   EXSR      POPGRS

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGenRef - Generate reference number and write to CGUDCRPD.  *
      *                                                               *
      *****************************************************************
     C     SrGenRef      BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrGenRef  '  @STK(Q)

      ** Reset the flag that indicates wether a correspondence is to be
      ** produced or not.

     C                   MOVEL     'N'           WProduce

      ** Set up fields of parameter PEDsCGUDCRPD to be passed to CG9010

     C                   CLEAR                   PEDsCGUDCRPD

     C/exec SQL
     C+ Select * into :DSACCNT
     C+ From ACCNTAB
     C+ where Brca = :PIsBrca
     C+   and Cnum = :PIsCnum
     C+   and Acod = :PIsAcod
     C+   and Acsq = :PIsAcsq
     C+   and Ccy = :PIsCcy
     C/end-exec

      ** Booking/Main branch (mandatory)

     C                   MOVEL     PIsBrca       DRBrca
     C                   MOVEL     PIsBrca       DROrbr

      ** Module ID (madatory)

     C                   MOVEL     'RE'          DRMODI

      ** MIDAS Transaction number

     C                   Movel     PIsAcno       DRMTRN

     C                   Eval      DrMAct = %Subst(A5Acky:4:21)
     C                                    + %Subst(A5Acky:1:3)
     C                   Eval      DrFRef = *Blanks

      ** Print Item Type

     C                   MOVEL     WCPrtItmTyp   DRPTYP

      ** Print Item Subtype

     C                   MOVEL     WCPrtItmSubTypDRPSTP

      ** Auto Transmission indicator

     C                   MOVEL     'N'           DRATRM

      ** Customer

     C                   MOVE      *BLANKS       PCustNumChr6
     C                   MOVE      PIsCnum       PCustNumChr6

      ** Output to CGUDCRPD

     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM                    W0CMT
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef

     C                   SELECT

      ** No error, generate correspondence

     C                   WHEN      PRtnCode = *BLANKS
     C                   MOVEL     'Y'           WProduce
     C                   MOVEL     PItmRef       ##ITEM
     C     DRPTYP        CAT       ':':0         COLON            11
     C     COLON         CAT       DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF

      ** No error, suppress output

     C                   WHEN      PRtnCode = 'CGD1270'

      ** Error.

     C                   OTHER
     C                   MOVEL     'CG9010'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     02            W0ERNB
     C                   MOVEL     'CGD1286'     W0MsgD
     C                   MOVEL     'CGUSRMSG'    W0MsgF
     C                   EXSR      SRERR

     C                   ENDSL

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPath - Set up path string.                                 *
      *                                                               *
      *****************************************************************
     C     SrPath        BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrPath    '  @STK(Q)

      ** Reset output path string

     C                   MOVEL     *BLANKS       WPathStr

      ** Copy path from multi-occurence DS to string. Each entry is to be
      ** preceded by '\'.

     C                   DO        WPx           Wx1
     C     Wx1           OCCUR     WMDsPath
     C                   CAT       '\':0         WPathStr
     C                   CAT       WMDsPathGrp:0 WPathStr
     C                   ENDDO

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *            store it in ##R.                                   *
      *                                                               *
      *****************************************************************
     C     SrRtvRDE      BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrRtvRDE  '  @STK(Q)

      ** Reset primary arrays

     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S

      ** Get info from compile time array of the 20 RDEs in group set

     C                   Z-ADD     1             Wx1
     C                   Z-ADD     1             WGrpSeq
     C                   DOU       *IN61 = *OFF
     C                             OR (Wx1 > 20)
     C                   Z-ADD     1             Wx2
     C     WGrp10        LOOKUP    WTbGrp(Wx2)                            61
     C                   IF        *IN61 = *ON
     C                   MOVEL     WTbRDE(Wx2)   ##R(Wx1)
     C                   ADD       1             Wx1
     C                   ADD       1             WGrpSeq
     C                   ENDIF
     C                   ENDDO

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDta - Reformat data before packing it.                   *
      *                                                               *
      *****************************************************************
     C     SrFmtDta      BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrFmtDta  '  @STK(Q)

      ** Loop through RDE's and data

     C                   Z-ADD     0             Wx1

     C     Wx1           DOUEQ     20

      ** Move RDE's and its data to their templates

     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA

      ** Reformat only if data is present and RDE is edited

     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK

      ** Right-align amount

     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANK        LOOKUP    WAr29(Wx2)                             61
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
     C     Wx2           DOWGT     1
     C     Wx2           ANDLE     20
     C     Wx3           ANDGT     1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO

      ** Sign

     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF

      ** Edit type

     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF

      ** Default decimal places

     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF

      ** New RDE data

     C                   MOVEL     R#DATA        ##D(Wx1)

     C                   ENDIF

     C                   ENDDO

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *                                                               *
      *****************************************************************
     C     SrPackDta     BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SrPackDta '  @STK(Q)

      ** Reformat RDE data

     C                   EXSR      SrFmtDta

     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT

      ** Pack RDEs and associated data into data strings

     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PAction8
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM

     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG3999'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   EXSR      WRTRDE

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    DsParm
     C                   PARM                    CCG015
     C                   PARM                    WProduce

     C                   Z-ADD     0             Q

      ** Access Bank details

     C/exec SQL
     C+ select *
     C+ into :SDBANK
     C+ from SDBANKPD
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     *LOCK         In        LDA
     C                   eval      DBKey = '*FIRST'
     C                   eval      DBFile = 'SDBANKPD'
     C                   eval      DBase = 1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

     C     KAcctVald     Klist
     C                   KFld                    K_Brca
     C                   KFld                    K_Cnum
     C                   KFld                    K_Ccy
     C                   KFld                    K_Acod
     C                   KFld                    K_Acsq
     C                   KFld                    Vald

     C     KAcct         Klist
     C                   KFld                    K_Brca
     C                   KFld                    K_Cnum
     C                   KFld                    K_Ccy
     C                   KFld                    K_Acod
     C                   KFld                    K_Acsq

      ** Initialise XML increment

     C                   EXSR      INIXML

      ** Index of WMDsPath

     C                   Z-ADD     0             WPx
     C                   CLEAR                   WMDsPath

     C                   ENDSR

      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
     C/COPY CGCPYSRC,CGNWEXILE
      /EJECT
      *****************************************************************
** WTbGrp/WTbRDE
Z_SHDR0001 Z_ADHOCIND                    Interim Int Stmt Ind
Z_SHDR0002 Z_C_PERIOD Date               Current Period
Z_SHDR0003 PERIOD_TO  Date               End Date
Z_SHDR0004 PERIOD_FRM Date               Start Date
Z_SHDR0005 Z_STMT_TYP                    Statement Type
Z_SHDR0006 Z_BVAL                        Back-valued postings
BRANCH0001 BRANCH                        Branch Code
BRANCH0002 BRANCH NAM                    Branch Name
ACCNT 0001 ACCOUNT                       Account ID
ACCNT 0002 ACC_NAME                      Account Name
ACCNT 0003 ACC_TYPE                      Account Type
ACCNT 0004 IBAN                          IBAN Number
ACCNT 0005 RETL_ACNO                     Retail Account Number
CUST  0001 CUSTOMER                      Customer Number
CUST  0002 CUST_NAME                     Customer Name
CUST  0003 CUST_TOWN                     Customer Town
CUST  0004 CUST_ADR1                     Customer Name & Address 1
CUST  0005 CUST_ADR2                     Customer Name & Address 2
CUST  0006 CUST_ADR3                     Customer Name & Address 3
CUST  0007 CUST_ADR4                     Customer Name & Address 4
ACOF  0001 ACOF_CODE                     Acc Officer Code
ACOF  0002 ACOF_DEPT                     Acc Officer Dep Code
ACOF  0003 ACOF_NAME                     Acc Officer Name
ACOF  0004 ACOF_TELX                     Acc Officer Telext
ACOF  0005 ACOF_TELP                     Acc Officer Tel No
CCY   0001 CURRENCY                      Currency Code
CCY   0002 CCY_DESC                      Currency Name
CCY   0003 PREC_METIN                    Precious Metal Ind
Z_OBAL0001 STMT_BFBAL AmountL            Opening Balance
Z_OBAL0002 STMT_CFBAL AmountL            CFwd Balance
Z_OBAL0003 STMT_LSD   Date               Last Stmt Date                                     MD032162
Z_INT10001 Z_STR_REC                     Start Record
Z_INT10002 Z_MVM_ACCR                    Movement Accrual
Z_INT10003 Z_DR_RATC                     DR Rate Change
Z_INT10004 Z_CR_RATC                     CR Rate Change
Z_INT10005 Z_DR_CAP                      DR Capitalisation
Z_INT10006 Z_CR_CAP                      CR Capitalisation
Z_INT20001 TRAN_DATE  Date               History Date
Z_INT20002 STMT_ACBL  AmountL            History Balance
Z_INT20003 DR_AMOUNT  AmountL            Debit Movements
Z_INT20004 CR_AMOUNT  AmountL            Credit Movements
Z_INT20005 ZZFDRRT    Rate  L7           Debit Rate Used
Z_INT20006 ZZFCRRT    Rate  L7           Credit Rate Used
Z_INT20007 Z_NO_DAYS  AmountL            No of Accrued Days
Z_INT20008 Z_DR_INTA  AmountL            DR Interest Accrued
Z_INT20009 Z_CR_INTA  AmountL            CR Interest Accrued
Z_INT20010 Z_DR_BALA  AmountL            DR Accrued Balance
Z_INT20011 Z_CR_BALA  AmountL            CR Accrued Balance
Z_INT20012 Z_DR_INTP  AmountL            DR Int posted
Z_INT20013 Z_CR_INTP  AmountL            CR Int posted
Z_INT20014 Z_DR_INTN  AmountL            DR Int not posted
Z_INT20015 Z_CR_INTN  AmountL            CR Int not posted
Z_INT20016 ZZFDICT                       DR Int Calc Type
Z_INT20017 ZZFCICT                       CR Int Calc Type
Z_INT20018 Z_DR_CALB                     DR Calc Basis
Z_INT20019 Z_CR_CALB                     CR Calc Basis
Z_PERI0001 Z_CPER_IND                    Current Period
Z_PERI0002 Z_TYPE                        Type
Z_MVMD0001 STMT_ACBL  AmountL            Account Balance
Z_MVMD0002 POST_AMT   AmountL            Posting Amount
Z_MVMD0003 POST_BITEM                    Batch Item No
Z_MVMD0004 POST_BCHN                     Batch No
Z_MVMD0005 CHQ_NUMBER                    Cheque Number
Z_MVMD0006 POST_GETP                     Gen Entry Type
Z_MVMD0007 POST_MODUL                    Module
Z_MVMD0008 POST_NARR                     Narrative
Z_MVMD0009 Z_ORI_REF                     Orig Reference
Z_MVMD0010 POST_DATE  Date               Posting Date
Z_MVMD0011 Z_SWI_REF                     Swift Reference
Z_MVMD0012 Z_TRN_NO                      Transaction No
Z_MVMD0013 TRANS TYPE                    Transaction Type
Z_MVMD0014 VALUE DATE Date               Value Date
Z_MVMD0015 Z_ADBK_DAT Date               Advised Booking Dat
Z_MVMD0016 Z_CPER_IND                    Current Period
Z_MVMD0017 Z_TYPE                        Type
Z_ODDT0001 Z_ODLC                        O/D Line Change
Z_ODDT0002 Z_ODLN     AmountL            O/D Line Amount
Z_ODDT0003 Z_AODR     Rate  L7           Overdraft Rate
Z_ODDT0004 Z_ODRT                        O/D Rate Used
