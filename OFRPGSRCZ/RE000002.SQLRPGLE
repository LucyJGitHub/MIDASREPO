     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF RE IIS Capitalisation Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000002 - RE IIS Capitalisation Extract                     *
      *                                                               *
      *  Function:  This program will check if an Interim Interest    *
      *             Statement is required for today's COB for         *
      *             capitalisation.                                   *
      *                                                               *
      *  Called By: REC000001                                         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032380           Date 12Feb15               *
      *                 MD032161           Date 29Jan15               *
      *                 MD032091           Date 26Jan15               *
      *                 CRE101   *Create   Date 01Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032380 - Delayed capitalisation when on holiday            *
      *  MD032161 - New requirements for the set-up of start date     *
      *  MD032091 - Add new flag for back-valuations                  *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Error Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  *PSSR          - Error handling subroutine                   *
      *  SrWrtSTMT      - Write record for statement generation       *
      *  ZFWD           - Calculate nth forward working day           *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger details

     D ACQD          E DS                  EXTNAME(GLACNTQD)
      ** External DS for A/c extension file

     D STMT          E DS                  EXTNAME(RESTMTTD)
      ** External DS for RE IIS Driver file

     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.

      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D LIST1_DS        DS
     D  IMiCnum                1      6
     D  IMiCcy                 7      9
     D  IMiAcod               10     19  0
     D  IMiAcsq               20     21  0
     D  IMiBrca               22     24
     D  IMiStmi               25     25
     D  IMiNisd               26     30  0
     D  IMiLisd               31     35  0
     D  IAcno                 36     45  0
     D  ILDID                 46     48P 0
     D  ILCID                 49     51P 0
     D  INDID                 52     54P 0
     D  INCID                 55     57P 0
     D  IDACO                 58     60P 0                                          MD032161

     D LIST2_DS        DS
     D  IACnum                 1      6
     D  IAccy                  7      9
     D  IAAcod                10     19  0
     D  IAAcsq                20     21  0
     D  IABrca                22     24
     D  IAPstd                25     27P 0
     D  IAVald                28     30P 0
     D  IAGetp                31     31
     D  IRHisd                32     34P 0
     D  IRPdid                35     37P 0
     D  IRPcid                38     40P 0

     D LIST3_DS        DS                                                           MD032161
     D  REddt                  1      5  0                                          MD032161

     D LDA             DS           256
      ** Local data area for database error details

     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PStdt           S              5S 0
     D PEndt           S              5S 0
     D PCrpr           S              5S 0
     D PStmd           S              5S 0
     D PType           S             10A
     D PTime           S               Z
     D WUpdate         S              1A   INZ(*Blanks)
     D WRun            S              1A   INZ(*Blanks)
     D PBval           S              1A   INZ(*Blanks)                             MD032091
     D PStCr           S              1A   INZ(*Blanks)                             MD032161

     D ZdayNo          S              5P 0 INZ(0)
     D ZDyNbr          S              5P 0 INZ(0)
     D ZNrDys          S              2P 0 INZ(0)
     D ZCcy            S              3A
     D ZLoc            S              3A   INZ(*Blanks)

      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

      ** Retrieve details from GLACMI1D

     C/exec SQL
     C+ declare LIST1 cursor for
     C+ Select MICNUM, MICCY, MIACOD, MIACSQ, MIBRCA, MISTMI,
     C***MINISD, MILISD, b.ACNO, b.LCID, b.LDID, b.NCID, b.NDID                     MD032161
     C+  MINISD, MILISD, b.ACNO, b.LCID, b.LDID, b.NCID, b.NDID, b.DACO             MD032161
     C+ From GLACMI1d
     C+ Inner Join accntab b ON b.Brca = MiBrca and b.Cnum = MiCnum and
     C+ b.CCY = MiCcy and b.Acod = MiAcod AND b.Acsq = MiAcsq
     C+ where MISTMI <> ' '
     C+   and B.NDID <= :BKAPDT
     C+   and B.NDID <> 0
     C+   and B.RECI = 'D'
     C+   or MISTMI <> ' '
     C+   and B.NCID <= :BKAPDT
     C+   and B.NCID <> 0
     C+   and B.RECI = 'D'
     C/end-exec

     C/exec SQL
     C+ open LIST1
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
     C+ fetch next
     C+ from LIST1
     C+ into :LIST1_DS
     C/end-exec

     C                   DOW       SQLCode <> 100


     C                   Exsr      SrWrtSTMT

     C/exec SQL
     C+ fetch next from LIST1
     C+ into :LIST1_DS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST1
     C/end-exec

      ** Terminate program

     C                   Eval      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWrtSTMT - Write details for statement generation            *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrWrtStmt     BEGSR

     C                   TIME                    PTime

      ** Start Date
     C                   If        ILcid >= ILdid
     C                   eval      PStdt = ILcid
     C                   else
     C                   eval      PStdt = ILdid
     C                   Endif

      ** Current period
     C                   eval      PStCr = *Blanks                                  MD032161
     C                   Select
     C     IMiSTMI       Wheneq    '1'
     C                   If        IMiLisd <> 0 and IMILisd >= PStdt
     C                   eval      PCrpr = IMiLisd
     C                   else
     C                   eval      PCrpr = PStdt
     C                   eval      PStCr = 'Y'                                      MD032161
     C                   Endif
     C     IMiSTMI       Wheneq    '2'
     C     IMiSTMI       oreq      '3'
     C                   eval      PCrpr = PStdt
     C                   eval      PStCr = 'Y'                                      MD032161
     C                   Endsl

      ** End Date
     C                   If        INcid <> INdid
     C                   If        INcid <= BKAPDT
     C                             and INcid <> 0
     C                   eval      PEndt = INcid
     C                   else
     C                   eval      PEndt = INdid
     C                   Endif
     C                   else
     C                   eval      PEndt = INdid
     C                   Endif

     C                   If        PStCr = *Blank or                                MD032161
     C                             PStCr = 'Y' and PStdt <> IDaco                   MD032161
     C                   eval      PCrpr = PCrpr + 1                                MD032091
     C                   Endif                                                      MD032161
     C                   Exsr      SrSetSTDT

     C                   If        PStDt <> IDaco                                   MD032161
     C                   eval      PStdt = PStdt + 1                                MD032091
     C                   Endif                                                      MD032161

      ** Statement Generation Date - check for delayed capitalisation

     C/exec SQL
     C+ select * into :ACQD from GLACNTQD
     C+ where
     C+       F1BRCA = :IMiBrca
     C+   and F1CNUM = :IMiCnum
     C+   and F1ACOD = :IMiAcod
     C+   and F1ACSQ = :IMiAcsq
     C+   and F1CCY = :IMiCcy
     C/end-exec

     C                   If        SQLCODE = 0
     C                             and F1DECD = 0
     C                             OR SQLCODE = 100
     C                   eval      PStmd = Bjrdnb
     C                   eval      PType = 'INT. CAPIT'
     C                   else
     C**********         z-add     Bjrdnb        ZDayNo                         MD032380
     C                   z-add     PEndt         ZDayNo                         MD032380
     C                   z-add     F1DECD        ZNrDys
     C                   move      BjLccy        ZCcy
     C                   Exsr      ZFWDT
     C                   z-add     ZDyNbr        PStmd
     C                   eval      PType = 'DLY. CAPIT'
     C                   Endif

     C/exec SQL
     C+ select * into :STMT from RESTMTTD
     C+ where
     C+       ISSTMD = :Bjrdnb
     C+   and ISBRCA = :IMiBrca
     C+   and ISCNUM = :IMiCnum
     C+   and ISACOD = :IMiAcod
     C+   and ISACSQ = :IMiAcsq
     C+   and ISCCY = :IMiCcy
     C+   and ISSTAT = ' '
     C+   and ISTYPE = 'INTERIM'
     C+   and ISEDDT = :PEndt                                                   MD032380
     C/end-exec

     C                   If        SQLCODE = 0

     C/exec SQL
     C+ update RESTMTTD
     C+   set ISBRCA = :IMiBrca,
     C+       ISCNUM = :IMiCnum,
     C+       ISCCY  = :IMiCcy,
     C+       ISACOD = :IMiAcod,
     C+       ISACSQ = :IMiAcsq,
     C+       ISAcno = :IAcno,
     C+       ISStdt = :PStdt,
     C+       ISEddt = :PEndt,
     C+       ISCrpr = :PCrpr,
     C+       ISStat = ' ',
     C+       ISType = :PType,
     C+       ISStmd = :PStmd,
     C+       ISTmst = :PTime
     C+ where ISSTMD = :Bjrdnb
     C+   and ISBRCA = :IMiBrca
     C+   and ISCNUM = :IMiCnum
     C+   and ISACOD = :IMiAcod
     C+   and ISACSQ = :IMiAcsq
     C+   and ISCCY = :IMiCcy
     C+   and ISSTAT = ' '
     C+   and ISTYPE = 'INTERIM'
     C+   and ISEDDT = :PEndt                                                   MD032380
     C/end-exec

     C                   Endif

     C                   If        SQLCODE = 100

     C/Exec SQL
     C+ insert into RESTMTTD
     C+ (
     C+  ISBrca
     C+ ,ISCnum
     C+ ,ISCcy
     C+ ,ISAcod
     C+ ,ISAcsq
     C+ ,ISAcno
     C+ ,ISStdt
     C+ ,ISEddt
     C+ ,ISCrpr
     C+ ,ISStat
     C+ ,ISType
     C+ ,ISStmd
     C+ ,ISTmst
     C+ ,ISCfbl
     C+ ,ISBval                                                                            MD032091
     C+ )
     C+ Values
     C+ (
     C+  :IMiBrca
     C+ ,:IMiCnum
     C+ ,:IMiCcy
     C+ ,:IMiAcod
     C+ ,:IMiAcsq
     C+ ,:IAcno
     C+ ,:PStdt
     C+ ,:PEndt
     C+ ,:PCrpr
     C+ , ' '
     C+ ,:PType
     C+ ,:PStmd
     C+ ,:PTime
     C+ , 0
     C+ ,:PBval                                                                            MD032091
     C+ )
     C/End-Exec

     C                   Endif

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetStdt - Set Start date                                   *
      *                                                               *
      *****************************************************************
     C     SrSetStdt     BEGSR

     C                   eval      PBval = *Blanks                               MD032091
     C/exec SQL
     C+ declare LIST2 cursor for
     C+ Select a.Cnum, a.Ccy, a.ACod, a.Acsq, a.Brca, a.Pstd, a.Vald,
     C+  a.getp, b.hisd, b.pdid, b.pcid
     C+ From APOSTPD a
     C+ Inner Join REHISPD b ON b.Brca = a.Brca and b.Cnum = a.Cnum and
     C+ b.CCY = a.Ccy and b.Acod = a.Acod AND b.Acsq = a.Acsq and
     C+ b.Hisd = a.Vald
     C+ where a.Pstd + 1 >= :PCrpr
     C+   and a.Pstd <= :PEndt
     C+   and a.Vald < :PCrpr
     C+   and a.Cnum = :IMiCnum
     C+   and a.Acod = :IMiAcod
     C+   and a.Acsq = :IMiAcsq
     C+   and a.Brca = :IMiBrca
     C+   and a.Ccy = :IMiCcy
     C+   and a.Getp = 'C'
     C+   or a.Pstd >= :PCrpr
     C+   and a.Pstd <= :PEndt
     C+   and a.Vald < :PCrpr
     C+   and a.Cnum = :IMiCnum
     C+   and a.Acod = :IMiAcod
     C+   and a.Acsq = :IMiAcsq
     C+   and a.Brca = :IMiBrca
     C+   and a.Ccy = :IMiCcy
     C+   and a.Getp <> 'C'
     C+ Order by
     C+       a.CNUM, a.CCY, a.ACOD, a.ACSQ, a.BRCA, a.VALD
     C/End-Exec

     C/exec SQL
     C+ open LIST2
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   eval      DBASE = 5
     C                   eval      DBFILE = 'SQL STM'
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into :LIST2_DS
     C/end-exec

     C                   If        SQLCode <> 100
     C/exec SQL                                                                     MD032161
     C+ declare LIST3 cursor for                                                    MD032161
     C+ Select a.IsEddt                                                             MD032161
     C+ From RESTMTTD a                                                             MD032161
     C+ where IsCnum = :IMiCnum                                                     MD032161
     C+   and IsAcod = :IMiAcod                                                     MD032161
     C+   and IsAcsq = :IMiAcsq                                                     MD032161
     C+   and IsCcy = :IMiCcy                                                       MD032161
     C+   and IsBrca = :IMiBrca                                                     MD032161
     C+   and IsStat = 'Y'                                                          MD032161
     C+   and IsEddt < :IAVald                                                      MD032161
     C+ Order by                                                                    MD032161
     C+       a.IsCNUM, a.IsCCY, a.IsACOD, a.IsACSQ, a.IsBRCA, a.IsEddt             MD032161
     C+ Desc                                                                        MD032161
     C/end-exec                                                                     MD032161
                                                                                    MD032161
     C/exec SQL                                                                     MD032161
     C+ open LIST3                                                                  MD032161
     C/end-exec                                                                     MD032161
                                                                                    MD032161
      ** Handle SQL Error (if not %EOF)                                             MD032161
     C                   If        SQLCOD < 0                                       MD032161
     C     *LOCK         IN        LDA                                              MD032161
     C                   eval      DBASE = 9                                        MD032161
     C                   eval      DBFILE = 'SQL STM'                               MD032161
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT                     MD032161
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)           MD032161
     C                   Out       LDA                                              MD032161
     C                   Exsr      *PSSR                                            MD032161
     C                   EndIf                                                      MD032161
                                                                                    MD032161
     C/exec SQL                                                                     MD032161
     C+ fetch next                                                                  MD032161
     C+ from LIST3                                                                  MD032161
     C+ into :LIST3_DS                                                              MD032161
     C/end-exec                                                                     MD032161
                                                                                    MD032161
      ** Handle SQL Error (if not %EOF)                                             MD032161
     C                   If        SQLCode < 0                                      MD032161
     C     *LOCK         IN        LDA                                              MD032161
     C                   EVAL      DBASE = 10                                       MD032161
     C                   EVAL      DBFILE = 'SQL STM'                               MD032161
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                     MD032161
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)           MD032161
     C                   OUT       LDA                                              MD032161
     C                   EXSR      *PSSR                                            MD032161
     C                   EndIf                                                      MD032161
                                                                                    MD032161
     C                   If        SQLCode <> 100                                   MD032161
     C                   eval      PStdt = REddt                                    MD032161
     C                   else                                                       MD032161
     C                   If        IRPDID >= IRPCID
     C                   eval      PStdt = IRPDID
     C                   else
     C                   eval      PStdt = IRPCID
     C                   Endif
     C                   Endif                                                      MD032161
                                                                                    MD032161
     C/exec SQL                                                                     MD032161
     C+ close LIST3                                                                 MD032161
     C/end-exec                                                                     MD032161
     C                   eval      PBval = 'Y'                                      MD032091
     C                   Endif

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST2
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFWDT    - Get next Nth working day                           *
      *                                                               *
      *****************************************************************

     C     ZFWDT         BEGSR

     C                   CALL      'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM      *ZERO         ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Read in data area

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE000002'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA

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

      ** Access GL details

     C/exec SQL
     C+ select *
     C+ into :SDGELR
     C+ from SDGELRPD
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     *LOCK         In        LDA
     C                   eval      DBKey = '*FIRST'
     C                   eval      DBFile = 'SDGELRPD'
     C                   eval      DBase = 2
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   ROLBK
     C                   RETURN

     C                   ENDSR

