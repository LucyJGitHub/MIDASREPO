     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Customer Ranges Def. List/Audit Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000951P - Midas SD Customer Ranges Def. List/Audit Report  *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD050571           Date 23Apr18               *
      *  Prev Amend No. CRE113CC1 *CREATE  Date 27Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050571 - Adding an already deleted customer range is no    *
      *             longer accepted by the system. Error in header in *
      *             List P1 report if all records are deleted.        *
      *  CRE113CC1 - Include Audit Reports                            *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Customer Ranges Def. List/Audit - Detail
     FSD000951P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas SD Customer Ranges Def. List/Audit - Audit
     FSD000951AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     ** File DS
     **   Midas SD Customer Ranges Definition
     D CusRangeDS    E DS                  EXTNAME(SDCUSRTD)

      ** File Information Data Structure for SD000951P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD000951AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Parameter data
     D PData           DS
     D  Data                   1    100A

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3

      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNo          S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D CountActiv      S              2  0                                                  MD050571
     D CountToday      S              2  0                                                  MD050571

      ** Parameter list fields for ZDATE2
     D PzDayNo         S              5  0
     D PBJDFIN         S              1
     D PzDate          S              6  0
     D PZADate         S              7

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

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Set file pointer to first record and do initial read for the Customer Ranges Definition

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from SDCUSRTD
     C+  order by
     C+  CRFCIR, CRLCIR
     C/end-exec

     C/exec SQL
     C+ open LIST
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf


     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: CusRangeDS
     C/end-exec

      ** Count Active Records                                                               MD050571
     C                   EXSR      SRCntActiv                                               MD050571
      ** Count Today's Changed Records                                                      MD050571
     C                   EXSR      SRCntToday                                               MD050571
                                                                                            MD050571
     C                   IF        (CountActiv > 0 and PMode <> 'A')                        MD050571
     C                             or (CountToday > 0 and PMode = 'A')                      MD050571
      ** Print Report Headers

     C                   EXSR      SRPrintHdr

     C
      ** Read  Customer Ranges Definition Table until end of file

     C                   DOW       SQLCode <> 100

     C                   IF        ((PMode = 'A') AND (CRCHGD = BJRDNB))
     C                             OR ((PMode <> 'A') AND
     C                             (CRRECI = 'D'))

      ** Print Details

     C                   EXSR      SRPrintDtl

      ** Count Customer Range Definition
     C                   EVAL      WRecNo = WRecNo + 1

     C                   ENDIF

     C/exec SQL
     C+ fetch next from LIST
     C+ into: CusRangeDS
     C/end-exec

     C                   ENDDO

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

     C/exec SQL
     C+ close LIST
     C/end-exec
                                                                                            MD050571
     C                   Endif                                                              MD050571

     C                   EXSR      SRPrintFtr

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr - Print Header Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr    BEGSR

      ** Prepare the Header Title to be used (must be centered)

     C                   IF        PMode = 'L'
     C                   EVAL      FTITLE = 'CUSTOMER RANGES DEFINITION ' +
     C                                      '- LIST MODE'
     C                   EVAL      FUNDRS = '---------------------------' +
     C                                      '-----------'
     C                   EVAL      *IN01 = *OFF
     C                   WRITE     HEADER1
     C                   WRITE     HEADP1
     C                   ELSE
     C                   EVAL      FTITLE = 'CUSTOMER RANGES DEFINITION ' +
     C                                      '- AUDIT MODE'
     C                   EVAL      FUNDRS = '---------------------------' +
     C                                      '------------'
     C                   EVAL      *IN01 = *ON
     C                   WRITE     HEADER1
     C                   WRITE     HEADAU1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAuditFlds - Prepare Audit fields Routine                   *
      *                                                               *
      *****************************************************************
     C     SRAuditFlds   BEGSR

      ** Audit fields

      ** Last Change User
     C                   EVAL      LCUSER = CRUSER
      ** Date
     C                   EVAL      PZDayNo = CRCHGD
     C                   EXSR      ConvertDate
     C                   MOVE      *Blanks       LDATE
     C                   MOVE      PZADate       LDATE
      ** Time
     C                   MOVEL     CRTMST        PTimestamp
     C                   EVAL      Hour2 = Hour1
     C                   EVAL      Min2  = Min1
     C                   EVAL      Sec2  = Sec1
     C                   EVAL      LTIME = Ptime
      ** Last action type
     C                   SELECT
     C                   WHEN      CRCHGT = 'I'
     C                   EVAL      LACTN  = 'INSERT'
     C                   WHEN      CRCHGT = 'A'
     C                   EVAL      LACTN  = 'AMEND'
     C                   WHEN      CRCHGT = 'D'
     C                   EVAL      LACTN  = 'DELETE'
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvertDate - Convert  Date to DDMMYY                        *
      *                                                               *
      *****************************************************************
     C     ConvertDate   BEGSR

      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMMYY format.
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    PBJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintDtl - Print Detail Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintDtl    BEGSR

      ** Set up Details

     C                   CLEAR                   DTLAU
     C                   CLEAR                   DTLP1

     C                   EVAL      FCUSTN = CRFCIR
     C                   EVAL      LCUSTN = CRLCIR
     C
     C                   IF        PMODE = 'A'
     C                   EXSR      SRAuditFlds
     C                   ENDIF

     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr
     C                   ENDIF

     C                   IF        PMODE = 'A'
     C                   WRITE     DTLAU
     C                   ELSE
     C                   WRITE     DTLP1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintFtr    BEGSR

     C                   IF        WRecNo > 0
     C                   WRITE     FOOTER
     C                   ENDIF

     C                   EXSR      SRAudit

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

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

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

      ** Total
     C                   EVAL      TCOUNT = WRecNo

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report.

     C                   IF        WRecNo <> 0
     C                   WRITE     CONTROL
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD050571
      *                                                               *                     MD050571
      * SRCntActiv - Count number of active records in SDCUSRTD       *                     MD050571
      *                                                               *                     MD050571
      *****************************************************************                     MD050571
     C     SRCntActiv    BEGSR                                                              MD050571
                                                                                            MD050571
     C/exec sql                                                                             MD050571
     C+ declare CustRangeActiv Cursor with return to client                                 MD050571
     C+  for select count(*)                                                                MD050571
     C+  from SDCUSRTD                                                                      MD050571
     C+  where CRRECI = 'D'                                                                 MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C/exec sql                                                                             MD050571
     C+ open CustRangeActiv                                                                 MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C/exec SQL                                                                             MD050571
     C+ fetch CustRangeActiv                                                                MD050571
     C+ into :CountActiv                                                                    MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C/exec SQL                                                                             MD050571
     C+ close CustRangeActiv                                                                MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C                   ENDSR                                                              MD050571
      *****************************************************************                     MD050571
      /EJECT                                                                                MD050571
      *****************************************************************                     MD050571
      *                                                               *                     MD050571
      * SRCntToday - Count number of today's amendment in SDCUSRTD    *                     MD050571
      *                                                               *                     MD050571
      *****************************************************************                     MD050571
     C     SRCntToday    BEGSR                                                              MD050571
                                                                                            MD050571
     C/exec sql                                                                             MD050571
     C+ declare CustRangeToday Cursor with return to client                                 MD050571
     C+  for select count(*)                                                                MD050571
     C+  from SDCUSRTD                                                                      MD050571
     C+  where CRCHGD = :BJRDNB                                                             MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C/exec sql                                                                             MD050571
     C+ open CustRangeToday                                                                 MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C/exec SQL                                                                             MD050571
     C+ fetch CustRangeToday                                                                MD050571
     C+ into :CountToday                                                                    MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C/exec SQL                                                                             MD050571
     C+ close CustRangeToday                                                                MD050571
     C/end-exec                                                                             MD050571
                                                                                            MD050571
     C                   ENDSR                                                              MD050571
      *****************************************************************                     MD050571
      /EJECT                                                                                MD050571
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details
      **   Retrieve Run day number

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up Header details

     C                   CLEAR                   HEADER1
     C                   CLEAR                   HEADP1
     C                   CLEAR                   HEADAU1

     C                   EVAL      RRPTDS = BJURPT
     C                   EVAL      PBJDFIN = BJDFIN
     C                   EVAL      RJMRDT = BJMRDT

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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      ReturnCode = '*ERROR'

     C                   EXSR      SRAUDIT

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
