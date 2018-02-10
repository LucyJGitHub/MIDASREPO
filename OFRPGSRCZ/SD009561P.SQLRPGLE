     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF Forecast Static Dta Rep. - full and audit')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009561P - Midas OF Forecast Static Data Full List Report   *
      *                                                               *
      *  Function: The purpose of the pgm is to list records from     *
      *            SQL table SDFCSDTD containing Forecast Static Data *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL145  *CREATE    Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FACCNT     IF   E           K DISK

     FSD009561P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

     FSD009561AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:

     D/COPY ZACPYSRC,STD_D_SPEC

      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for Currency details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details

     DSDRETL         E DS                  EXTNAME(SDRETLPD)
      ** External DS for Retail ICD

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure

     D DSSDY         E DS                  Extname(DSSDY)
      **  Long DS for access programs

     D FOREC         E DS                  EXTNAME(SDFCSDTD)
     **   Midas SD Forecast Static Data

     D TRAIL         E DS                  EXTNAME(SDFCTLPA)
     **   Midas SD Standing Data controls File

      ** Parameter list fields for AOCUSTR0
     D @KEY1           S             10
     D @KYST           S              7

      ** Parameter for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A

     D WHead1          S             20
     D WLine1          S             20
     D WHead2          S             16
     D WLine2          S             16

     D WorkNum         S              5P 0
     D PReptNam        S             10

     D WNORC           S                   LIKE(AHNORC)
     D WNORC2          S                   LIKE(AHNORC)
     D WNOIN           S                   LIKE(AHNOIN)
     D WNOAM           S                   LIKE(AHNOAM)
     D WNODL           S                   LIKE(AHNODL)

      ** Indicator Array

     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
     D  RecNotFnd             03     03

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SPOOL1          DS
      **  File Information Data Structure for SD009561P1
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD009561AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

     D  RETAC          DS
      **  Retail account number
     D  FCBRC2                 1      3
     D  FCRCU2                 4      9
     D  FCRCC2                10     12
     D  FCRAC2                13     22  0
     D  FCRAS2                23     24  0

     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** DATA AREA GIVING ICD

      ** Time data
     D PTimestamp      DS            26
     D  Hour1                 12     13
     D  Min1                  15     16
     D  Sec1                  18     19

     D PTime           DS
     D  Hour2                  1      2
     D  Colon1                 3      3    INZ(':')
     D  Min2                   4      5
     D  Colon2                 6      6    INZ(':')
     D  Sec2                   7      8

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WA6NBDP         s                   like(A6NBDP)
     D WPrintDetails   S              1A

     D FCCUS1          S              6A
     D FCCSR1          S             34A
     D FCCUR1          S              3A
     D FCNOT1          S              2S 0
     D FCDLM1          S             15S 0
     D FCRET1          S             10S 0
     D FCLAS1          S              5S 0
     D FCCHG1          S              1A

      ** Parameters for ZSEDIT
     D PZFLD15         S             15  0
     D PZDECS          S              1  0
     D PZECODE         S              1
     D PZOUT21         S             21

      ** Parameters for ZSFILE
     D PParm           S              1A
     D PSeq            S              5
     D SEnty           S              3
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameters for access object programs
     D POccy           S              3
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6

      ** Other fields used
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0

     D WError          S              1
     D PFlag           S              1

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   MOVE      'N'           WPrintDetails

      ** Set SQL return code
     C                   Eval      SQLCOD = 0
      *
     C/exec sql
     C+    declare RECORD cursor for
     C+    Select * from SDFCSDTD
     C+    Order by FCCUST, FCCSRC, FCCURR, FCNOTR
     C/End-Exec

     C/exec SQL
     C+  Open RECORD
     C/End-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   ExSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from RECORD
     C+ into: FOREC
     C/end-exec


     C                   DOW       SQLCode <> 100

     C                   MOVE      '1'           *IN01

      ** If report is requested, process only live records

      ** Test if record must be processed
      ** audit list (Last change date = Run date)
      *
     C                   IF        ((*IN21 = *ON) AND (FCLASD = BJRDNB))
     C                             OR ((*IN21 = *OFF) AND
     C                             (FCCHGT <> 'D'))

      ** Report details in printer file SD009561P1  (Full list or Audit list)

     C                   MOVE      'Y'           WPrintDetails
     C                   EXSR      SrPrintP1

     C                   ENDIF
     C/Exec SQL
     C+  fetch next from RECORD
     C+ Into :FOREC
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

     C/EXEC SQL
     C+  CLOSE RECORD
     C/END-EXEC

      ** When EOF, write trailer

      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.

     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 4
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C     Difln1        Ifle      Rqdln1
     C     WFirst        Oreq      'Y'
      *
     C                   WRITE     HEADER1
     C  N21              WRITE     HEADER2
     C   21              WRITE     HEADER3
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

     C                   IF        WNoRec = 0
     C                   EVAL      *IN11 = '1'
     C                   ENDIF

     C                   WRITE     TRAILP1

     C                   ENDIF

      ** Retrieve control details file SDFCTLPA to compare Trailer file with number of Records
      ** Only if the Audit list is produced

     C     *IN21         IFEQ      '1'

      ** Set SQL return code
     C                   Eval      SQLCOD = 0
      *
     C/exec sql
     C+    Declare TRAILER cursor for
     C+    Select * from SDFCTLPA
     c+    where AHFLNM = 'SDFCSDTD'
     c+    order by AHFLNM
     C/End-Exec

     C/exec SQL
     C+  Open TRAILER
     C/End-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   ExSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from TRAILER
     C+ into: TRAIL
     C/end-exec

     C                   DOW       SQLcode <> 100

      ** process all records until SDFCSDTD is found ..

     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec

     C/Exec SQL
     C+ fetch next
     C+ from TRAILER
     C+ into :TRAIL
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/EXEC SQL
     C+  CLOSE TRAILER
     C/END-EXEC

     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN25 = *On
     C                   ELSE
     C                   EVAL      *IN25 = *Off
     C                   ENDIF

     C                   EXSR      SRAUDIT

     C                   ENDIF

     C                   EVAL      *INLR = *ON

     C                   RETURN

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

     C                   DUMP

     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      ReturnCode = '*ERROR'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

     C                   OPEN      SD009561AU

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = SFNUMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Request : 'Audit list' (IN21 *on)  'full list' (IN21 *OFF)
      *
     C                   IF        PParm = 'A'
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
      *
     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report.

     C                   IF        WNoRec <> 0
     C                   WRITE     CONTROL
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      *INLR ='1'
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrintP1 - Print details into PRTF/Detail                    *
      *                                                               *
      *****************************************************************
     C     SrPrintP1     BEGSR

     C                   Eval      *IN10 = '1'

      ** Eval Customer
     C                   Eval      DDCUS1     =  FCCUST

      ** Eval Customer souce account
     C                   Eval      DDCSR1     =  FCCSRC

      ** Eval Currency
     C                   Eval      DDCUR1     =  FCCURR

      ** Eval Nostro Code
     C                   Eval      DDNOT1     =  FCNOTR

      ** Eval Nostro Daily Amount

     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FCCURR        POccy
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBPGM  = 'SD009561P'
     C                   EVAL      DBASE  = 008
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
     C                   EVAL      WA6NBDP = A6NBDP
     C                   ENDIF

     C                   CLEAR                   PZFLD15
     C                   MOVE      FCDLMT        PZFLD15

     C                   CALLB     'ZSEDIT'

      ** Field to edit
      ** Decimal places
      ** Edit code ('J', 'L' or ' ')

     C                   PARM                    PZFLD15
     C                   PARM      WA6NBDP       PZDECS
     C                   PARM      'J'           PZECODE

      ** Output

     C                   PARM                    PZOUT21

     C                   MOVE      PZOUT21       DDDLM1

      ** Eval Retail Account or GL Full General Account

     C                   EVAL      DDRET1     =  *BLANKS
     C                   EVAL      RETAC      =  *BLANKS

     C     BMRANR        IFEQ      'Y'
     C     FCRETL        ANDNE     0
      *
     C     KACCNT        CHAIN     ACCNT                              30
     C     *IN30         IFEQ      '0'
     C     ACNO          IFNE      0
     C                   MOVEL     ACNO          A_ACNO           10
     C                   EVAL      DDRET1     =  A_ACNO
     C                   ELSE
     C                   Eval      FCBRC2     =  FCBRCA
     C                   Eval      FCRCU2     =  FCRCUS
     C                   Eval      FCRCC2     =  FCRCCY
     C     FCRACD        Ifne      0
     C     FCRASQ        Andne     0
     C                   Eval      FCRAC2     =  FCRACD
     C                   Eval      FCRAS2     =  FCRASQ
     C                   Eval      DDRET1     =  RETAC
     C                   End
     C                   ENDIF
      ** Eval Account Name
     C                   Eval      DDACNM = ANAM
     C                   ENDIF
     C                   else
      *
     C                   Eval      FCBRC2     =  FCBRCA
     C                   Eval      FCRCU2     =  FCRCUS
     C                   Eval      FCRCC2     =  FCRCCY
     C     FCRACD        Ifne      0
     C     FCRASQ        Andne     0
     C                   Eval      FCRAC2     =  FCRACD
     C                   Eval      FCRAS2     =  FCRASQ
     C                   Eval      DDRET1     =  RETAC
     C                   End
     C                   Eval      DDACNM = *Blanks

     C                   ENDIF

      ** print only on Audit list

     C     *IN21         IFEQ      '1'

      ** Eval Last Change Date
     C                   EVAL      ZDAYNO    =   FCLASD
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE
      *
     C                   MOVE      ZADATE        DDPRD1

      ** Get Last Change type
     C                   EXSR      SRCHTP

      ** Get Last Processing Time

     C                   MOVEL     FCTMST        PTimestamp
     C                   EVAL      Hour2 = Hour1
     C                   EVAL      Min2  = Min1
     C                   EVAL      Sec2  = Sec1
     C                   EVAL      DDTRD1 = Ptime


      ** Get User
     C                   MOVEL     FCUSER        DDUSR1

     C                   ENDIF

      ** Eval Customer souce account
     C                   Eval      DDACS1     =  FCACSA

      ** Eval Customer Report Name and Town
     C                   EXSR      GetCustDtls


      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.

     C                   Eval      Rqdln1 = 4
     C                   Eval      Difln1 = Oflln1 - Prtln1

     C     Difln1        Ifle      Rqdln1
     C     WFirst        Oreq      'Y'
      *
     C                   WRITE     HEADER1
     C  N21              WRITE     HEADER2
     C   21              WRITE     HEADER3
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

      ** Write Details
     C                   WRITE     DETAIL

     C     FCRECI        IFNE      '*'
     C                   EVAL      WNorec  = WNorec + 1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHTP - Determine Last Action done to record                 *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCHTP        BEGSR

      ** Populate action fields only in AUDIT mode

     C                   SELECT
     C                   WHEN      FCCHGT = 'I'
     C                   EVAL      DDPRL1 = 'INSERT'
     C                   WHEN      FCCHGT = 'A'
     C                   EVAL      DDPRL1 = 'AMEND'
     C                   WHEN      FCCHGT = 'D'
     C                   EVAL      DDPRL1 = 'DELETE'
     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls - Get Customer Details (Report Name and Town)    *
      *                                                               *
      *****************************************************************
     C     GetCustDtls   BEGSR

     C                   EVAL      @KEY1 = FCCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      DDCRN1   = BBCRNM
     C                   EVAL      DDCRT1   = BBCRTN
     C                   ELSE
     C                   EVAL      DDCRN1   = *Blanks
     C                   EVAL      DDCRT1   = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PParm
     C                   PARM                    Pseq

     C/COPY ZACPYSRC,DBFIELDS
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** TEST DATE FORMAT FLAG FOR STANDARD ROUTINES
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Handle Database Error.
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   ENDIF

      ** Prepare the Header Title to be used (must be centered)

     C                   EVAL      WHead1 = 'Forecast Static Data'
     C                   EVAL      WLine1 = '--------------------'

     C                   IF        PParm = 'A'
     C                   EVAL      WHead2 = ' - Audit Report'
     C                   EVAL      WLine2 = '---------------'
     C                   EVAL      RTITLE = '          ' +
     C                                      WHead1 + WHead2
     C                   EVAL      RUNDLN = '          ' +
     C                                      WLine1 + WLine2
     C                   ELSE

     C                   EVAL      WHead2 = ' - Full Report'
     C                   EVAL      WLine2 = '--------------'
     C                   EVAL      RTITLE = '          ' +
     C                                      WHead1 + WHead2
     C                   EVAL      RUNDLN = '          ' +
     C                                      WLine1 + WLine2
     C                   ENDIF

      ** Report Work fields.

     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0

     C                   OPEN      SD009561P1

      ** Ensure Detail Spool File recorded by RCF.

     C                   EVAL      ZSnum = SFNUM1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blanks       ZSerr

     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
      *
      ** Request : 'Audit list' (IN21 *on)  'full list' (IN21 *OFF)
      *
     C                   IF        PParm = 'A'
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
      *
      *   Check ICD retail

     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
     C*
     C** DEFINE KEY TO LF/ACCNT
     C*
     C     KACCNT        KLIST
     C                   KFLD                    FCRCUS
     C                   KFLD                    FCRCCY
     C                   KFLD                    FCRACD
     C                   KFLD                    FCRASQ
     C                   KFLD                    FCBRCA
     C*
     C                   ENDSR
      *****************************************************************
