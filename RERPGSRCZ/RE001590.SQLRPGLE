     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas RE Account Balance Check')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE001590 - Account Balance Check                             *
      *                                                               *
      *  Function:  This program will perform Account Balance         *
      *             Checking for transactions which enter the Midas   *
      *             system via an RPG program.                        *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD044087           Date 14Feb17               *
      *  Prev Amend No. MD023554           Date 19Nov13               *
      *                 MD023412           Date 14Nov13               *
      *                 MD021158           Date 30Sep13               *
      *                 MD019039           Date 30Sep13               *
      *                 AR1083172          Date 30Sep13               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR1089494          Date 30Sep13               *
      *                 AR1096610          Date 02Apr13               *
      *                 CGL131  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044087 - Database Error Control is encountered when        *
      *             accessing account via Account Movements           *
      *             Enquiry screen                                    *
      *  MD023554 - Unable to proceed with the transaction            *
      *             (withdrawal) as it already hanged                 *
      *  MD023412 - DBERRCTL appears when making a withdrawal upon    *
      *             key enter has been made                           *
      *  MD021158 - CGL131 - Avail Bal on A/C Mvmts Enq not include   *
      *             Reservations                                      *
      *  MD019039 - Days Forward 1 for RPG                            *
      *  AR1083172 - ABC check not working for RTS                    *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR1089494 - Test Minimum balance only if a minimum credit    *
      *              balance has been defined on the account          *
      *  AR1096610 - Enquiry screens displayed incorrect balances     *
      *              of account with value dated OPAY                 *
      *  CGL131 - Customer Account Balance Enquiry (with available    *
      *           balance)                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  *PSSR          - Error handling subroutine                   *
      *  SrCHECK        - Perform the Account Balance Checking        *
      *  ZDAT10         - Convert date to Midas number date via       *
      *                   /COPYs ZDAT10Z1LE & ZDAT10Z2LE, including   *
      *                   ZDATE9Z1LE & ZDATE9Z4                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLACNTL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Extension File
      *
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Accounts Master
      *
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABR)
      ** Midas FT Retail accounts LF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs
 
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D AVAIL_DATES     DS
     D  F1DAT0
     D  F1DAT1
     D  F1DAT2
     D  F1DAT3
     D  F1DAT4
     D  F1DAT5
     D  F1DAT6
     D  F1DAT7
     D  F1DAT8
     D  F1DAT9
     D*AvailDates                          Like(F1DAT0) Dim(10)                             MD023412
     D AvailDates                          Like(F1DAT0) Dim(10) INZ(0)                      MD023412
     D                                     Overlay(AVAIL_DATES)
 
     D ACCT_BAL        DS
     D  F1BAV0
     D  F1BAV1
     D  F1BAV2
     D  F1BAV3
     D  F1BAV4
     D  F1BAV5
     D  F1BAV6
     D  F1BAV7
     D  F1BAV8
     D  F1BAV9
     D*AcctBal**                           Like(F1BAV0) Dim(10)                             MD023412
     D AcctBal                             Like(F1BAV0) Dim(10) INZ(0)                      MD023412
     D                                     Overlay(ACCT_BAL)
 
     D*AccBal***                           Like(F1BAV0) Dim(10)                             MD023412
     D AccBal                              Like(F1BAV0) Dim(10) INZ(0)                      MD023412
 
     D AVAIL_BAL       DS
     D  F1AVA0
     D  F1AVA1
     D  F1AVA2
     D  F1AVA3
     D  F1AVA4
     D  F1AVA5
     D  F1AVA6
     D  F1AVA7
     D  F1AVA8
     D  F1AVA9
     D*AvailBal*                           Like(F1AVA0) Dim(10)                             MD023412
     D AvailBal                            Like(F1AVA0) Dim(10) INZ(0)                      MD023412
     D                                     Overlay(AVAIL_BAL)
 
     D*AvaBal***                           Like(F1AVA0) Dim(10)                             MD023412
     D AvaBal                              Like(F1AVA0) Dim(10) INZ(0)                      MD023412
     D*AvaBalOv*                           Like(F1AVA0) Dim(10)                             MD023412
     D AvaBalOv                            Like(F1AVA0) Dim(10) INZ(0)                      MD023412
 
     D LDA             DS           256
      ** Local data area for database error details
 
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
     D RefDS           DS            50
     D  BRCA
     D  CNUM
     D  CCY
     D  ACOD
     D  ACSQ
 
     D SQTabDS         DS
     D  SQRef                  1     50
     D  SQValDat              51     60D
     D  SQMatDat              61     70D
     D**SQAsstAmt             71     85  0                                                  MD021158
     D  SQAsstAmt             71     83P 8                                                  MD021158
                                                                                            MD021158
     D Nulls           DS                                                                   MD021158
     D                                2                                                     MD021158
     D   SQValDatNull                 5I 0                                                  MD021158
     D   SQMatDatNull                 5I 0                                                  MD021158
     D                                2                                                     MD021158
     D   NullArray                    5I 0 DIM(4)                                           MD021158
     D                                     Overlay(Nulls)                                   MD021158
                                                                                            MD021158
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D SQAsstAmtX      S             15S 0                                                  MD021158
     D SQMatDatOK      S              1A                                                    MD021158
     D********** PRtAcNum        S             10S 0                                        MD044087
     D PRtAcNum        S             10  0                                                  MD044087
     D PCusn           S              6A
     D PCurr           S              3A
     D PACod           S             10S 0
     D PASeq           S              2S 0
     D PBrch           S              3A
     D PTrnTyp         S             10A
     D PValDat         S              5S 0
     D PAmt            S             15S 0
     D PErr01          S              7A
     D PErr02          S              7A
     D PActBal         S             15S 0
     D PAvlBal         S             15S 0
     D PFailDat        S              5S 0
     D PFailBal        S             15S 0
 
     D POptn           S              7A
 
     D PRtCd           S              7A
     D PSysVal01       S             20A
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
 
     D PRunDat         S              5  0
     D PChkDat         S              5  0                                                  MD019039
 
     D KCusn           S                   Like(PCusn)
     D KCurr           S                   Like(PCurr)
     D KACod           S                   Like(PACod)
     D KASeq           S                   Like(PASeq)
     D KBrch           S                   Like(PBrch)
 
     D WProcType       S              1A
     D WValDat         S              5S 0
     D WRun            S              1A
     D N1              S              2S 0
     D N2              S              2S 0
     D ABC             S              1A
     D WMinBal         S                   Like(MINB)
     D WRef            S             50A
     D MINBX           S             15S 0
     D WSpDt           S              5S 0                                                  MD019039
     D WAvDt           S              5S 0                                                  MD019039
 
      ** Arrays/variables for date conversion
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZDAT10Z1LE
     D DateISO         S               D   datfmt(*iso)
     D TValDat         S              5  0
     D TMatDat         S              5  0
                                                                                            MD019039
     D/COPY ZSRSRC,ZHOLELE                                                                  MD019039
     D/COPY ZSRSRC,ZHOLILE                                                                  MD019039
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing                                            *
      *****************************************************************
      *
     C                   EVAL      PErr01 = *BLANK
     C                   EVAL      PErr02 = *BLANK
     C                   EVAL      PActBal = 0
     C                   EVAL      PAvlBal = 0
     C                   EVAL      PFailDat = 0
     C                   EVAL      PFailBal  = 0
      *
     C                   IF        PRtAcNum <> 0
      *
      ** Access records from ACCNTAB via ACNUMA
      *
     C     PRtAcNum      CHAIN     ACNUMA
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001590'
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   Move(P)   PRtAcNum      DBKEY
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PCusn = CNUM
     C                   EVAL      PCurr = CCY
     C                   EVAL      PACod = ACOD
     C                   EVAL      PASeq = ACSQ
     C                   EVAL      PBrch = BRCA
      *
     C                   ELSE
      *
      ** Access records from ACCNTAB via ACCNT
      *
     C                   EVAL      KCusn = PCusn
     C                   EVAL      KCurr = PCurr
     C                   EVAL      KACod = PACod
     C                   EVAL      KASeq = PASeq
     C                   EVAL      KBrch = PBrch
      *
     C     KGlAcnt       CHAIN     ACCNT
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001590'
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY = KCusn + KCurr +
     C                             %Trim(%Char(KAcod)) +
     C                             %Trim(%Char(KASeq)) + KBrch
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Get Currency Details via AOCURRR0
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCurr
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            MD019039
      ** Get actual Spot Date via ZFWDT.                                                    MD019039
                                                                                            MD019039
     C                   EVAL      ZDayNo = BJRDNB                                          MD019039
     C                   EVAL      ZNrDys = A6SPDY                                          MD019039
     C                   EVAL      ZCcy = BJLCCY                                            MD019039
     C                   EVAL      ZLoc = *Blanks                                           MD019039
     C                   EXSR      ZFWDT                                                    MD019039
     C                   EVAL      WSpDt = ZDyNbr                                           MD019039
      *
     C                   IF        PTrnTyp <> 'BAL ENQY'
     C
     C                   IF        PTrnTyp = 'RETELD'
     C**********         IF        PValDat <= (BJRDNB + A6SPDY)                             MD019039
     C                   IF        PValDat <= WSpDt                                         MD019039
     C                   EVAL      WProcType = WProcTypeAS
     C                   ELSE
     C                   EVAL      WProcType = WProcTypeAF
     C                   ENDIF
     C                   ELSE
     C**********         IF        PValDat <= (BJRDNB + A6SPDY)                             MD019039
     C                   IF        PValDat <= WSpDt                                         MD019039
     C                   EVAL      WProcType = WProcTypeTS
     C                   ELSE
     C                   EVAL      WProcType = WProcTypeTF
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      WProcType = '1'
     C                   EVAL      WValDat = PRunDat
     C                   WHEN      WProcType = '2' OR
     C                             WProcType = '3' AND
     C                             PValDat <= PRunDat
     C                   EVAL      WValDat = PValDat
     C                   WHEN      WProcType = '3' AND
     C                             PValDat > PRunDat OR
     C                             WProcType = '4'
     C                   EVAL      PErr01 = 'ABC0004'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Access records from GLACNTQD
      *
     C                   EVAL      KCusn = CNUM
     C                   EVAL      KCurr = CCY
     C                   EVAL      KACod = ACOD
     C                   EVAL      KASeq = ACSQ
     C                   EVAL      KBrch = BRCA
      *
     C     KGlAcnt       CHAIN     GLACNTL3
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001590'
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY = KCusn + KCurr +
     C                             %Trim(%Char(KAcod)) +
     C                             %Trim(%Char(KASeq)) + KBrch
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PActBal = F1BAV1
     C                   ENDIF
      *
     C                   IF        F1IABC = 'Y' AND
     C                             FACT = 000
     C                             OR F1IABC = 'Y'
     C                             AND PTrnTyp = 'BAL ENQY'
     C                             OR ATYP = 'R'
     C                             AND PTrnTyp = 'BAL ENQY'
     C                   EXSR      SrCHECK
     C                   ENDIF
      *
     C                   IF        F1IABC <> 'Y' AND ATYP <> 'R'
     C                             AND PTrnTyp = 'BAL ENQY'
     C                   EVAL      PErr01 = 'NOABC'
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SrCHECK -  Perform the Account Balance Checking              *
      *                                                               *
      ** Called by: Main routine                                      *
      *                                                               *
      ** Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrCHECK       BEGSR
      *
      ** Consider the decimal places on the Minimum Balance Check
      *
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C     MINB          MULT      1             MINBX
     C                   WHEN      A6NBDP = 1
     C     MINB          MULT      10            MINBX
     C                   WHEN      A6NBDP = 2
     C     MINB          MULT      100           MINBX
     C                   WHEN      A6NBDP = 3
     C     MINB          MULT      1000          MINBX
     C                   ENDSL
      *
     C                   EVAL      N1 = 1
     C                   EVAL      WMinBal = MINBX * (-1)
     C                   EVAL      ABC = 'N'
      *
     C                   IF        PTrnTyp <> 'BAL ENQY'
      *
     C                   DOW       N1 < 10 AND ABC = 'N'
     C                   IF        AvailDates(N1) <> 0
                                                                                            MD019039
      ** Get actual Available Date (including holidays) via ZFWDT                           MD019039
                                                                                            MD019039
     C                   EVAL      ZDayNo = AvailDates(N1)                                  MD019039
     C                   EVAL      ZNrDys = 1                                               MD019039
     C                   EXSR      ZFWDT                                                    MD019039
     C                   EVAL      WAvDt = (ZDyNbr - 1)                                     MD019039
     C**********         IF        AvailDates(N1) >= WValDat                                MD019039
     C                   IF        WAvDt >= WValDat                                         MD019039
     C                   EVAL      ABC = 'Y'
     C                   ELSE
     C                   EVAL      N1 = N1 + 1
     C                   ENDIF
     C                   ELSE
     C                   EVAL      N1 = 10
     C                   EVAL      PErr01 = 'ABC0004'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        ABC = 'N'
     C                   EVAL      PErr01 = 'ABC0004'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Reset the value of N2 to 1 and not with the value of N1.
      *
     C                   EVAL      N2 = 1
     C                   DOW       N2 <= WForward
     C                   EVAL      AccBal(N2) = AcctBal(N2)
     C                   EVAL      AvaBal(N2) = AvailBal(N2)
     C                   EVAL      AvaBalOv(N2) = (AvailBal(N2)-F1TOLR)
     C                   EVAL      N2 = N2 + 1
     C                   ENDDO
      *
     C                   EVAL      N2 = N1
     C                   EVAL      WRef = RefDS
 
     c/Exec Sql
     c+ Declare RE001590Cur1 Cursor
     c+   for
     c+ Select RTREF, RTVALDATE, RTMATDATE, RTASSETAMT
     c+   from T_MLRSVTRN
      ** Midas GP Reserved Transactions
     c****where RTREF = :WRef                                                               MD021158
     c+   where RTREF = :WRef and ABCUPD = 'N'                                              MD021158
     c/End-Exec
 
     c/Exec Sql
     c+ Open RE001590Cur1
     c/End-Exec
 
     c/Exec Sql
     c+ Fetch next
     c+   from RE001590Cur1
     c****into*:SQTabDS                                                                     MD021158
     c+   into :SQTabDS:NullArray                                                           MD021158
     c/End-Exec
 
     C                   DOW       SQLSTT = '00000'
      *
      ** When record is found
      *
     C                   EVAL      DateIso = SQValDat
     C     *iso          MOVE      DateISO       ZZDTIN
     C                   EXSR      ZDAT10
     C                   EVAL      TValDat = ZZMDNO
      *
     C                   IF        SQMatDatNull = -1                                        MD021158
     C                   EVAL      TMatDat = 0                                              MD021158
     C                   ELSE                                                               MD021158
     C                   EVAL      DateIso = SQMatDat
     C     *iso          MOVE      DateISO       ZZDTIN
     C                   EXSR      ZDAT10
     C                   EVAL      TMatDat = ZZMDNO
     C                   ENDIF                                                              MD021158
      *
     C                   SELECT                                                             MD021158
     C                   WHEN      A6NBDP = 0                                               MD021158
     C     SQAsstAmt     MULT      1             SQAsstAmtX                                 MD021158
     C                   WHEN      A6NBDP = 1                                               MD021158
     C     SQAsstAmt     MULT      10            SQAsstAmtX                                 MD021158
     C                   WHEN      A6NBDP = 2                                               MD021158
     C     SQAsstAmt     MULT      100           SQAsstAmtX                                 MD021158
     C                   WHEN      A6NBDP = 3                                               MD021158
     C     SQAsstAmt     MULT      1000          SQAsstAmtX                                 MD021158
     C                   ENDSL                                                              MD021158
      *                                                                                     MD021158
     C                   DOW       N2 <= WForward
                                                                                            MD019039
      ** Get actual Available Date (including holidays) via ZFWDT                           MD019039
                                                                                            MD019039
     C                   EVAL      ZDayNo = AvailDates(N2)                                  MD019039
     C                   EVAL      ZNrDys = 1                                               MD019039
     C                   EXSR      ZFWDT                                                    MD019039
     C                   EVAL      WAvDt = (ZDyNbr - 1)                                     MD019039
     C**********         IF        TValDat <= AvailDates(N2) AND                            MD019039
     C**********                   TMatDat = 0 OR                                           MD019039
     C**********                   TValDat <= AvailDates(N2) AND                            MD019039
     C**********                   AvailDates(N2) <= TMatDat                                MD019039
     C**********         EVAL      AccBal(N2) = (AccBal(N2) + SQAsstAmt)                    MD019039
     C**********         EVAL      AvaBal(N2) = (AvaBal(N2) + SQAsstAmt)                    MD019039
     C**********         EVAL      AvaBalOv(N2) = (AvaBalOv(N2)+ SQAsstAmt)                 MD019039
     C                   IF        TValDat <= WAvDt AND                                     MD019039
     C                             TMatDat = 0 OR                                           MD019039
     C                             TValDat <= WAvDt AND                                     MD019039
     C                             AvailDates(N2) <= TMatDat                                MD019039
     C                   EVAL      AccBal(N2) = (AccBal(N2) + SQAsstAmtX)                   MD021158
     C                   EVAL      AvaBal(N2) = (AvaBal(N2) + SQAsstAmtX)                   MD021158
     C                   EVAL      AvaBalOv(N2) = (AvaBalOv(N2)+ SQAsstAmtX)                MD021158
     C                   ENDIF
     C                   EVAL      N2 = N2 + 1
     C                   ENDDO
     C                   EVAL      N2 = N1
 
     c/Exec Sql
     c+ Fetch next
     c+   from RE001590Cur1
     c****into*:SQTabDS                                                                     MD021158
     c+   into :SQTabDS:NullArray                                                           MD021158
     c/End-Exec
 
     C                   ENDDO
 
     c/Exec Sql
     c+ Close RE001590Cur1
     c/End-Exec
 
     C                   IF        PTrnTyp = 'BAL ENQY'                                     MD021158
     C                   EVAL      PAvlBal = AvaBal(2)                                      MD021158
     C                   ELSE                                                               MD021158
     C**********         EVAL      PAvlBal = AvaBal(N1)                                    AR1096610
     C                   EVAL      PAvlBal = AvaBal(N1 + 1)                                AR1096610
     C                   ENDIF                                                              MD021158
      *
     C                   IF        PTrnTyp <> 'BAL ENQY'
      *
     C                   DOW       N1 <= WForward
      *
     C                   IF        PErr01 = *Blank
     C                   IF        (AccBal(N1) + PAmt) > WMinBal
     C                             AND WMinBal <> 0                                        AR1089494
     C                   EVAL      PErr01 = 'ABC0001'
     C                   IF        PFailDat = 0
     C                   EVAL      PFailDat = AvailDates(N1)
     C                   EVAL      PFailBal = AvaBal(N1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PErr02 = *BLANK
     C                   IF        (AvaBal(N1) + PAmt) > 0
     C                   IF        (AvaBalOv(N1) + PAmt) > 0
     C                   EVAL      PErr02 = 'ABC0003'
     C                   ELSE
     C                   EVAL      PErr02 = 'ABC0002'
     C                   ENDIF
     C                   IF        PFailDat = 0
     C                   EVAL      PFailDat = AvailDates(N1)
     C                   EVAL      PFailBal = AvaBal(N1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PErr01 <> *BLANK AND PErr02 <> *BLANK
     C                             OR PTrnTyp = 'RETELD'
     C**********         EVAL      N1 = 10                                                  MD023554
     C                   EVAL      N1 = 11                                                  MD023554
     C                   ELSE
     C                   EVAL      N1 = N1 + 1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** ZDAT10 - /COPY SR to convert date to Midas number date       *
      *                                                               *
      ** Called by: (**calling routines**)                            *
      *                                                               *
      ** Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C/COPY ZSRSRC,ZDAT10Z2LE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** *INZSR - Program Initialisation routine                      *
      *                                                               *
      ** Called by: Implicitly on program activation                  *
      *                                                               *
      ** Calls: AOBANKR0                                              *
      **        AOSVALR0                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtAcNum
     C                   PARM                    PCusn
     C                   PARM                    PCurr
     C                   PARM                    PACod
     C                   PARM                    PASeq
     C                   PARM                    PBrch
     C                   PARM                    PTrnTyp
     C                   PARM                    PValDat
     C                   PARM                    PAmt
     C                   PARM                    PErr01
     C                   PARM                    PErr02
     C                   PARM                    PActBal
     C                   PARM                    PAvlBal
     C                   PARM                    PFailDat
     C                   PARM                    PFailBal
      *
     C     KGlAcnt       KLIST
     C                   KFLD                    KCusn
     C                   KFLD                    KCurr
     C                   KFLD                    KACod
     C                   KFLD                    KASeq
     C                   KFLD                    KBrch
      *
      ** Read in data area
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE001590'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'AOBANKR0'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PRunDat = BJRDNB
     C                   Eval      PChkDat = (BJDNWD - 1)                                   MD019039
      *
      ** Get System Value via AOSVALR0
      *
     C                   EVAL      PSysVal01 = 'ABCAcctfrsameDR'
     C                   EVAL      PSysVal02 = 'ABCAcctfrfrwdDR'
     C                   EVAL      PSysVal03 = 'ABCTransValueDR'
     C                   EVAL      PSysVal04 = 'ABCTransForwardDR'
     C                   EVAL      PSysVal05 = 'ABCNoDaysForward'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal01
     C                   PARM      *BLANKS       PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM      *BLANKS       PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM      *BLANKS       PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM      *BLANKS       PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM      *BLANKS       PCurSet05
     C                   PARM      *BLANKS       PSysVal06
     C                   PARM      *BLANKS       PCurSet06
     C                   PARM      *BLANKS       PSysVal07
     C                   PARM      *BLANKS       PCurSet07
     C                   PARM      *BLANKS       PSysVal08
     C                   PARM      *BLANKS       PCurSet08
     C                   PARM      *BLANKS       PSysVal09
     C                   PARM      *BLANKS       PCurSet09
     C                   PARM      *BLANKS       PSysVal10
     C                   PARM      *BLANKS       PCurSet10
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = PSysVal01
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     PCurSet01     WProcTypeAS       1
     C                   MOVEL     PCurSet02     WProcTypeAF       1
     C                   MOVEL     PCurSet03     WProcTypeTS       1
     C                   MOVEL     PCurSet04     WProcTypeTF       1
     C                   MOVEL     PCurSet05     VForward          1
     C                   MOVE      VForward      WForward          2 0
     C                   ADD       1             WForward                                  AR1083172
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** *PSSR  - Program exception error routine                     *
      **          Called automatically if a program error occurs,     *
      **          or directly by the program code using EXSR.         *
      **          This subroutine DUMPs the program just once.        *
      **                                                              *
      ** Called by: (**calling routines**)                            *
      *                                                               *
      ** Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *InU7 = *ON
     C                   EVAL      *InU8 = *ON
     C                   EVAL      *Inlr = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
     C/COPY ZSRSRC,ZACCHLE                                                                  MD019039
     C/COPY ZSRSRC,ZFWDT_ILE                                                                MD019039
 
      /COPY ZSRSRC,ZDATE9Z4
