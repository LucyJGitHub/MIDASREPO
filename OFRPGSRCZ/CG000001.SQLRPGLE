     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF RE Interim Interest Statement Driver')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG000001 - Midas Interim Interest Statement DRIVER           *
      *                                                               *
      *  Function:  This program drives the Interim Interest          *
      *             Statement Generation                              *
      *                                                               *
      *  Called By: CGC000001 in Close of Business                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD032380           Date 12Feb15               *
      *  Prev Amend No. MD032091           Date 26Jan15               *
      *                 CRE101  *Create    Date 06Oct14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD032380 - Next IIS date not updated when on holiday         *
      *  MD032091 - New flag for back-valuations                      *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRClcNISD - Calculate next interim interest statement date   *
      *  SRMain    - Controls main flow of program                    *
      *  SRAudit   - Calls CGZAUDIT to do auditing                    *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GL Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Switchable feature details

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D LIST1_DS        DS
     D  IIsCnum                1      6
     D  IIsCcy                 7      9
     D  IIsAcod               10     19  0
     D  IIsAcsq               20     21  0
     D  IIsBrca               22     24
     D  IIsAcno               25     34  0
     D  IIsStdt               35     39  0
     D  IIsCrpr               40     44  0
     D  IIsEddt               45     49  0
     D  IIsStmd               50     54  0
     D  IIsType               55     64
     D  IIsCfbl               65     79  0
     D  IIsBval               80     80                                            MD032091
     D  IMiLisd               81     85  0                                         MD032380
     D  IMiNisd               86     90  0                                         MD032380
     D  IMiIsff               91     91                                            MD032380
     D  IMiIsfm               92     93  0                                         MD032380
     D  IMiStmi               94     94                                            MD032380

     D*LIST2_DS*       DS                                                          MD032380
     D**IMiCnum*               1      6                                            MD032380
     D**IMiCcy**               7      9                                            MD032380
     D**IMiAcod*              10     19  0                                         MD032380
     D**IMiAcsq*              20     21  0                                         MD032380
     D**IMiBrca*              22     24                                            MD032380
     D**IMiLisd*              25     29  0                                         MD032380
     D**IMiNisd*              30     34  0                                         MD032380
     D**IMiIsff*              35     35                                            MD032380
     D**IMiIsfm*              36     37  0                                         MD032380
     D**IMiStmi*              38     38                                            MD032380


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry parameter fields
     D PInp_Commit     S              3A
     D PRtnCode        S              7A
     D PSequence       S              5A
     D CCG015          S              1A

      ** Work Variables
     D WCounter        S              5P 0
     D PTime           S               Z
     D PNisd           S              5S 0

      ** Fields, data structures, arrays definition for CG error processing
     D/COPY CGCPYSRC,SRERRDLE

      ** Fields, data structures, arrays definition for CG audit processing
     D/COPY CGCPYSRC,CGAUDTDLE

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
     C                   MOVEL     'Main      '  @STK(Q)

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

     C                   EXSR      SRMain

      ** Audit processing

     C                   EXSR      SRAudit

      ***Update*Next*Interim*Interest*Statement*Date                            MD032380

     C**exec*SQL                                                                MD032380
     C**declare*LIST2 cursor for                                                MD032380
     C**Select*MICNUM, MICCY, MIACOD, MIACSQ, MIBRCA, MILISD,                   MD032380
     C**MINISD**MIISFF, MIISFM, MISTMI                                          MD032380
     C**From*GLACMI1d                                                           MD032380
     C**where*MINISD <= :BJRDNB                                                 MD032380
     C**where*MINISD <= :BKAPDT                                                 MD032380
     C****and*MINISD <> 0                                                       MD032380
     C****and*MISTMI <> ' '                                                     MD032380
     C*end*exec*                                                                MD032380

     C*exec*SQL*                                                                MD032380
     C**open*LIST2                                                              MD032380
     C*end*exec*                                                                MD032380

      ** Handle SQL Error (if not %EOF)                                         MD032380
     C**********         If        SQLCOD < 0                                   MD032380
     C******LOCK         IN        LDA                                          MD032380
     C**********         eval      DBASE = 5                                    MD032380
     C**********         eval      DBFILE = 'SQL STM'                           MD032380
     C**********         eval      DBKEY = 'SQLSTT : ' + SQLSTT                 MD032380
     C**********                         + ';  SQLCOD : ' + %char(SQLCOD)       MD032380
     C**********         Out       LDA                                          MD032380
     C**********         Exsr      *PSSR                                        MD032380
     C**********         EndIf

     C*exec*SQL*                                                                MD032380
     C**fetch*next                                                              MD032380
     C**from*LIST2                                                              MD032380
     C**into*:LIST2_DS                                                          MD032380
     C*end*exec*                                                                MD032380
                                                                                MD032380
     C**********         DOW       SQLCode <> 100                               MD032380

     C**********         Exsr      SRClcNisd                                    MD032380

     C*exec*SQL*                                                                MD032380
     C**update*GLACMI1D                                                         MD032380
     C****set MILISD = :IMiNISD,                                                MD032380
     C********MINISD = :PNisd                                                   MD032380
     C**where*MIBRCA = :IMiBrca                                                 MD032380
     C****and*MICNUM = :IMiCnum                                                 MD032380
     C****and*MIACOD = :IMiAcod                                                 MD032380
     C****and*MIACSQ = :IMiAcsq                                                 MD032380
     C****and*MICCY = :IMiCcy                                                   MD032380
     C*end*exec                                                                 MD032380

     C*exec*SQL*                                                                MD032380
     C**fetch*next from LIST2                                                   MD032380
     C**into*:LIST2_DS                                                          MD032380
     C*end*exec*                                                                MD032380

     C**********         ENDDO                                                  MD032380

      ***Handle*SQL Error (if not %EOF)                                         MD032380
     C**********         If        SQLCode < 100                                MD032380
     C******LOCK         IN        LDA                                          MD032380
     C**********         EVAL      DBASE = 6                                    MD032380
     C**********         EVAL      DBFILE = 'SQL STM'                           MD032380
     C**********         EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                 MD032380
     C**********                         + ';  SQLCOD : ' + %char(SQLCOD)       MD032380
     C**********         OUT       LDA                                          MD032380
     C**********         EXSR      *PSSR                                        MD032380
     C**********         EndIf

     C*exec*SQL*                                                                MD032380
     C**close*LIST2                                                             MD032380
     C*end*exec*                                                                MD032380

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
      *  SRMain  - Controls main flow of program                      *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SRMain'      @STK(Q)

      ** Retrieve details from RESTMTTD

     C/exec SQL
     C+ declare LIST1 cursor for
     C+ Select ISCNUM, ISCCY, ISACOD, ISACSQ, ISBRCA, ISACNO,
     ****ISSTDT, ISCRPR, ISEDDT, ISSTMD, ISTYPE, ISCFBL                                  MD032091
     C***ISSTDT, ISCRPR, ISEDDT, ISSTMD, ISTYPE, ISCFBL, ISBVAL                 MD032091 MD032380
     C+  ISSTDT, ISCRPR, ISEDDT, ISSTMD, ISTYPE, ISCFBL, ISBVAL,                         MD032380
     C+  b.MILISD, b.MINISD, b.MIISFF, b.MIISFM, b.MISTMI                                MD032380
     C+ From RESTMTTD
     C+ Inner join GLACMI1D b on b.mibrca = Isbrca and b.micnum = iscnum and             MD032380
     C+ b.miacod = isacod and b.miacsq = isacsq and b.miccy = isccy                      MD032380
     C+ where ISSTAT = ' '
     C+   and ISSTMD <= :BJRDNB
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

     C                   ADD       1             WCounter

      ** Call the Extract Program.

     C                   Call      'CG000002'
     C                   Parm      *BLANKS       PRtnCode
     C                   Parm                    PInp_Commit
     C                   Parm                    LIST1_DS
     C                   Parm                    CCG015
     C                   Parm                    WProduce          1

     C                   If        PRtnCode <> *BLANKS
     C                   Exsr      SRAudit
     C                   Eval      W0File = 'CG000002'
     C                   Eval      W0Key = PRtnCode
     C                   Eval      W0ErNb = 04
     C                   Eval      W0MsgD = 'MEM5003'
     C                   Eval      W0MsgF = 'MIDAS'
     C                   Exsr      SRERR
     C                   Endif

     C                   TIME                    PTime

     C                   If        WProduce = 'Y'
     C/exec SQL
     C+ update RESTMTTD
     C+   set ISSTAT = 'Y',
     C+       ISTmst = :PTime,
     C+       ISStdt = :IIsStdt,                                                          MD032091
     C+       ISBval = :IIsBval,                                                          MD032091
     C+       ISCfbl = :IIsCfbl
     C+ where ISSTMD <= :Bjrdnb
     C+   and ISBRCA = :IIsBrca
     C+   and ISCNUM = :IIsCnum
     C+   and ISACOD = :IIsAcod
     C+   and ISACSQ = :IIsAcsq
     C+   and ISCCY = :IIsCcy
     C+   and ISSTAT = ' '
     C+   and ISTYPE = :IIsType
     C/end-exec

      ** Update Next Interim Interest Statement Date for account                MD032380
                                                                                MD032380
     C                   Exsr      SRClcNisd                                    MD032380
                                                                                MD032380
     C/exec SQL                                                                 MD032380
     C+ update GLACMI1D                                                         MD032380
     C+   set MILISD = :IMiNISD,                                                MD032380
     C+       MINISD = :PNisd                                                   MD032380
     C+ where MIBRCA = :IIsBrca                                                 MD032380
     C+   and MICNUM = :IIsCnum                                                 MD032380
     C+   and MIACOD = :IIsAcod                                                 MD032380
     C+   and MIACSQ = :IIsAcsq                                                 MD032380
     C+   and MICCY = :IIsCcy                                                   MD032380
     C+   and MINISD <= :BKAPDT                                                 MD032380
     C+   and MINISD <> 0                                                       MD032380
     C+   and MISTMI <> ' '                                                     MD032380
     C/end-exec                                                                 MD032380
                                                                                MD032380
     C                   Endif

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

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Calls CGZAUDIT to do auditing.                     *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Set up subroutine stack name

     C                   ADD       1             Q
     C                   MOVEL     'SRAudit   '  @STK(Q)

      ** Output the count of records read

     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG000001 '   I#REF
     C                   MOVEL     'CGD9001'     I#TITL
     C                   MOVEL     'CGD9002'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     *BLANKS       I#SUB
     C                   MOVEL     'RESTMTTD'    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WCounter      I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT

      ** Write line of text

     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*LINE   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence

      ** Skip a line

     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*SKIP   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence

      ** Close Audit Printer file

     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG000001'    I#REF
     C                   MOVEL     'CGD9001'     I#TITL
     C                   MOVEL     'CGD9002'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'CAD1008'     I#TEXT

     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence

      ** Unwind subroutine stack name

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClCNisd - Calculate Next Interim Interest Statement Date   *
      *                                                               *
      *****************************************************************
     C     SRClcNisd     BEGSR

     C                   eval      ZFreq = IMiISFF
     C                   eval      ZDayNo = IMiNisd
     C                   eval      ZMday = IMiISFM
     C                   eval      ZCcy = BJLCCY

     C                   Callb     'ZFRQB3'
     C                   Parm                    ZFREQ             1
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZMDAY             2 0
     C                   Parm                    ZCCY              3
     C                   Parm                    BJSLCD
     C                   Parm                    ZERR              7

     C                   z-add     ZDayNo        PNisd

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
     C                   PARM                    PInp_Commit

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

      ** Access Switchable feature details - CCG015

     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+ where SARN = 'CCG015'
     C/end-exec

     C     SQLCOD        Ifne      100
     C                   movel     'Y'           CCG015
     C                   else
     C                   move      'N'           CCG015
     C                   Endif


      ** Reset @STK index

     C                   Z-ADD     0             Q

      ** Initialize the counter.

     C                   Z-ADD     *ZERO         WCounter

      ** Open the Audit Print file

     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG000001AU'  I#SPLN
     C                   MOVEL     'CG000001  '  I#REF
     C                   MOVEL     'CGD9001'     I#TITL
     C                   MOVEL     'CGD9002'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE

     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence

     C                   ENDSR

      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
      *****************************************************************
