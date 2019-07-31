     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF RE Extract O/D Line Changes')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000004 - RE IIS Capitalisation Extract                     *
      *                                                               *
      *  Function:  This program will check for O/D line changes      *
      *                                                               *
      *  Called By: REC000002                                         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032091           Date 27Jan15               *
      *                 CRE101   *Create   Date 29Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032091 - New flag for back-valuations (Recompile)          *
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
      *  SrInit         - Initial processing                          *
      *  *PSSR          - Error handling subroutine                   *
      *  SrProcess      - Main processing                             *
      *  SrODLExtract   - Extract OD Line change                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D INTH          E DS                  ExtName(REINTHTD)
     D I_INTH        E DS                  ExtName(REINTHTD)
     D                                     Prefix(I_)


     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.

      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
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
     D  IIsEddt               40     44  0

     D LIST2_DS        DS
     D  ICnum                  1      6
     D  ICcy                   7      9
     D  IAcod                 10     19  0
     D  IAcsq                 20     21  0
     D  IBrca                 22     24
     D  IOdHisd               25     27P 0
     D  IOdOdln               28     33P 0
     D  IODOded               34     36P 0

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
     D WHisd           S                   Like(IhHisd)
     D Sv_IIsCnum      S                   Like(IhCnum)
     D Sv_IIsAcod      S                   Like(IhAcod)
     D Sv_IIsAcsq      S                   Like(IhAcsq)
     D Sv_IIsBrca      S                   Like(IhBrca)
     D Sv_IIsCcy       S                   Like(IhCcy)
     D Sv_Hisd         S                   Like(IOdHisd)
     D Sv_EHisd        S                   Like(IOdHisd)
     D Sv_Odln         S                   Like(IOdOdln)
     D Sv_Oded         S                   Like(IOdOded)
     D Sv_SqlCode      S                   Like(SqlCode)
     D PAodr           S                   Like(IhAodr)

     D WRun            S              1

      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************

      * Initialisation
     C                   Exsr      SrInit

      * Process request
     C                   Exsr      SrProcess

     C                   Movel     *On           *InLr
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit - Initialisation routine                               *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr

      * Initial Clears
     C                   Clear                   PAodr

     C                   move      *Blanks       Sv_IIsCnum
     C                   move      *Blanks       Sv_IIsBrca
     C                   move      *Blanks       Sv_IIsCcy
     C                   z-add     0             Sv_IIsAcod
     C                   z-add     0             Sv_IIsAcsq

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Main processing                                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrProcess     Begsr

      * Process only accounts in RESTMTTD with Extract Status = *blanks and
      * Statement Generation Date = Today

     C/Exec SQL
     C+ Declare LIST1 cursor for
     C+ Select ISCNUM, ISCCY, ISACOD, ISACSQ, ISBRCA, ISACNO,
     C+  ISSTDT, ISEDDT
     C+ From RESTMTTD
     C+                          where ISSTAT = ' '
     C+                          and   ISSTMD = :Bjrdnb
     C+ Order by
     C+       ISCNUM, ISCCY, ISACOD, ISACSQ, ISBRCA
     C/End-Exec

     C/Exec SQL
     C+ Open LIST1
     C/End-Exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   eval      DBASE = 2
     C                   eval      DBFILE = 'SQL STM'
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

     C/Exec SQL
     C+ fetch next
     C+   From LIST1
     C+   into :LIST1_DS
     C/End-Exec

     C                   Dow       SQLCode <> 100

     C                   If        Sv_IIsCnum <> IIsCnum or
     C                             Sv_IIsAcod <> IIsAcod or
     C                             Sv_IIsCcy <> IIsCcy or
     C                             Sv_IIsAcsq <> IIsAcsq or
     C                             Sv_IIsBrca <> IIsBrca

     C                   Exsr      SrInit

     C/Exec SQL
     C+ Declare LIST2 cursor for
     C+ Select CNUM, CCY, ACOD, ACSQ, BRCA, HISD, ODLN, ODED
     C+ From REODHSPD
     C+  where CNUM = :IIsCnum and CCY = :IIsCcy and Acod = :IISAcod
     C+    and Acsq =:IIsAcsq and Brca = :IIsBrca
     C+ Order by
     C+       CNUM, CCY, ACOD, ACSQ, BRCA, HISD
     C/End-Exec

     C/Exec SQL
     C+ Open LIST2
     C/End-Exec

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

     C/Exec SQL
     C+ fetch next
     C+   From LIST2
     C+   into :LIST2_DS
     C/End-Exec

     C                   Dow       SQLCode <> 100


      * Extract O/D Line Amount changes

     C                   Exsr      SrODLExtract
     C                   Eval      Sv_Hisd = IOdHisd
     C                   Eval      Sv_Odln = IOdOdln
     C                   Eval      Sv_Oded = IOdOded

     C/Exec SQL
     C+ Fetch next from LIST2
     C+   into :LIST2_DS
     C/End-Exec

      * Update O/D Line Amounts in REINTHTD
     C                   Eval      Sv_SqlCode = SqlCode
     C     SqlCode       Ifne      100
     C                   Eval      Sv_EHisd = IOdHisd
     C                   else
     C                   Eval      Sv_EHisd = Bjrdnb
     C                   Endif

     C                   Exsr      SrODLUpdate
     C                   Eval      SqlCode = Sv_SqlCode
     C                   EndDo
      *
     C/Exec SQL
     C+ Close LIST2
     C/End-Exec

     C                   Eval      Sv_IIsCnum = IIsCnum
     C                   Eval      Sv_IIsAcod = IIsAcod
     C                   Eval      Sv_IIsAcsq = IIsAcsq
     C                   Eval      Sv_IIsBrca = IIsBrca
     C                   Eval      Sv_IIsCcy = IIsCcy

     C                   Endif

     C/Exec SQL
     C+ Fetch next from LIST1
     C+   into :LIST1_DS
     C/End-Exec
      *
     C                   Enddo

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
      *
     C/Exec SQL
     C+ Close LIST1
     C/End-Exec

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrODLExtract - Extract OD Line change                         *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrODLExtract  Begsr

     C/exec SQL
     C+ declare LISTA cursor for
     C+ select * from REINTHTD
     C+ where
     C+       IhCnum = :IIsCnum
     C+   and IhAcod = :IIsAcod
     C+   and IhCcy = :IIsCcy
     C+   and IhBrca = :IIsBrca
     C+   and IhAcsq = :IIsAcsq
     C+   and IhHisd = :IOdHisd
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
     C+ into :INTH
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PAodr = IhAodr
     C                   else

     C                   Eval      WHisd = IOdHisd - 1

     C/exec SQL
     C+ Declare C_REINTH scroll cursor for
     C+ Select * from REINTHTD
     C+ where IhCnum = :IIsCnum
     C+   and IhAcod = :IIsAcod
     C+   and IhAcsq = :IIsAcsq
     C+   and IhCcy = :IIsCcy
     C+   and IhBrca = :IIsBrca
     C+   and IhHisd = :WHisd
     C+ order by IhBrca, IhCnum, IhCcy, IhAcod, IhAcsq, IhHisd
     C/end-exec

     C/exec SQL
     C+ open C_REINTH
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   eval      DBASE = 4
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
     C+ into :INTH
     C/end-exec

     C                   If        SQLCode <> 100
     C                   eval      PAodr = IhAodr
     C                   Endif

     C/exec SQL
     C+ close C_REINTH
     C/end-exec
     C                   Endif

     C/exec SQL
     C+ close LISTA
     C/end-exec

     C                   clear                   INTH
     C                   eval      I_INTH = INTH
     C                   eval      I_IhBrca = IIsBrca
     C                   eval      I_IhCnum = IIsCnum
     C                   eval      I_IhCcy = IIsCcy
     C                   eval      I_IhAcod = IIsAcod
     C                   eval      I_IhAcsq = IIsAcsq
     C                   eval      I_IhAcno = IIsAcno
     C                   eval      I_IhMvnt = 'O'
     C                   eval      I_IhHisd = IOdHisd
     C                   eval      I_IhOdln = IOdOdln
     C                   eval      I_IhAodr = PAodr
     C/Exec SQL
     C+ insert into REINTHTD
     C+ Values
     C+ (:I_INTH)
     C/End-Exec
     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrODLUpdate - Update OD Line Amount in REINTHTD               *
      *                                                               *
      * Called by: SrProcess                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrODLUpdate   Begsr

     C/exec SQL
     C+ update REINTHTD
     C+   set IhOdln = :Sv_Odln
     C+ where IhBRCA = :IIsBrca
     C+   and IhCNUM = :IIsCnum
     C+   and IhACOD = :IIsAcod
     C+   and IhACSQ = :IIsAcsq
     C+   and IhCCY = :IIsCcy
     C+   and IhHisd <= :Sv_Oded
     C+   and IhHisd >= :Sv_Hisd
     C+   and IhHisd <= :Sv_EHisd
     C/end-exec

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSr - Program Initialisation Routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *InzSr        Begsr

      ** Read in data area

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE000004'
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

     C                   EndSr

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

     C                   RETURN

     C                   ENDSR

