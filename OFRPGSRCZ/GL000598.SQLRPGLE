     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Estimated Exchange Rates Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000598 - Midas OF Estimated Exchange Rates Housekeeping    *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD052296           Date 26Nov18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034487           Date 02Jul15               *
      *                 CGL153   *CREATE   Date 13Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052296 - Problems caused by use of special characters      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034487 - Avoid overflow when footer has to be printed at   *
      *             the very bottom of page.                          *
      *  CGL153 - Bank Position Report                                *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF Estimated Exchange Rates Dropped - Detail
     FGL000598P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas OF Estimated Exchange Rates Dropped - Audit list
     FGL000598AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)


      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

     ** File DS
     **   Midas OF Estimated Exchange Rates Table
     D EERT          E DS                  EXTNAME(SDEERTTD)

      ** File Information Data Structure for GL000598P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for GL000598AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Data structure for AOSVALR0 string
     D PSVAL1          DS           200
     D  SVAL1                  1    200
     D  SVAL1_1                1      3S 0

      ** Parameter list fields for ZDATE2
     D PzDayNo         S              5  0
     D PBJDFIN         S              1
     D PzDate          S              6  0
     D PZADate         S              7

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7

     D WRun            S              1A   Inz
     D WTimeStmp       S             26A
     D WRetDate        S              5P 0

      ** Parameter variables for AOSVALR0 string
     D RTNCDE          S              7
     D SVALK1          S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200

      ** Parameter list fields
     D PMode           S              1
     D PEnty           S              3
     D ReturnCode      S             10

      ** Parameter list fields for AOCUSTR0
     D PAKEY1          S             10
     D PAKYST          S              7

      ** Parameter list fields for AONOSTR0
     D PACUST          S              6
     D PACCY           S              3
     D PAACCD          S             10
     D PAACSN          S              2
     D PANOST          S              2
     D PABRCA          S              3
     D PACSSN          S             10
     D PAPNOI          S              1

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

     D DifLn1          S              4  0
     D RqdLn1          S              3  0
     D WRecNo          S              7S 0 Inz

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
      *
      ** Print all records found for dropping
      *
     C                   EXSR      SREsExRate
      *
      ** Drop of Estimated Exchange Rate file
      *
     C                   EXSR      SRDropRecs

      ** End Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREsExRate - Estimated Exchange Rate file drop               *
      *                                                               *
      *****************************************************************
     C     SREsExRate    BEGSR

      ** Set file pointer to first record and do initial read

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from SDEERTTD
     C+ where ERDATE < :WRetDate
     C+ order by
     C+       ERCUST,
     C+       ERCCY,
     C+       ERNOSC,
     C+       ERTCCY
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
     C+ into :EERT
     C/end-exec

      ** Read Accounting Rules Batch Details until end of file

     C                   DOW       SQLCode <> 100


     C                   EVAL      WRecNo = WRecNo + 1

      ** Print Details

     C                   EXSR      SRPrintDtl


     C/exec SQL
     C+ fetch next from LIST
     C+ into :EERT
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

     C                   EXSR      SRPrintFtr


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CnvFcastDat - Convert Forecast Date to DDMMYY                *
      *                                                               *
      *****************************************************************
     C     CnvFcastDat   BEGSR

      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMMYY format

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
      *  GetNostDtls - Get Nostro Details                             *
      *                                                               *
      *****************************************************************
     C     GetNostDtls   BEGSR

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PACUST
     C                   PARM      ERCCY         PACCY
     C                   PARM      *BLANKS       PAACCD
     C                   PARM      *BLANKS       PAACSN
     C                   PARM      ERNOSC        PANOST
     C                   PARM      *BLANKS       PABRCA
     C                   PARM      *BLANKS       PACSSN
     C                   PARM      *BLANKS       PAPNOI
     C     SDNOST        PARM      SDNOST        DSSDY

     C     PRtCd         IFEQ      *BLANKS
     C                   EVAL      PDNTNM = A7NOSN
     C                   ELSE
     C                   EVAL      PDNTNM = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1- Print Header 1 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr2- Print Header 2 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr2   BEGSR

      ** Set up Header 2 details

     C                   CLEAR                   HEADER2

      ** Prepare the Header Title to be used

     C                   IF        PMode = 'A'
     C                   EVAL      *IN50 = *OFF
     C                   ELSE
     C                   EVAL      *IN50 = *ON
     C                   ENDIF

     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr3 - Print Header 3 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr3   BEGSR

     C                   CLEAR                   HEADER3

     C                   WRITE     HEADER3

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

     C                   CLEAR                   DETAIL


     C                   EVAL      PDCUST = ERCUST
     C                   EVAL      PDCURR = ERCCY
     C                   EVAL      PDNOST = ERNOSC

     C                   EVAL      PZDayNo = ERDATE
     C                   EXSR      CnvFcastDat
     C                   MOVE      *Blanks       PDDATE
     C                   MOVE      PZADate       PDDATE

     C                   EVAL      PDTCUR = ERTCCY
     C                   MOVE      EREXRT        PDEXRT
     C                   EVAL      PDMDIN = ERMDIN

      ** Report name and Town

     C                   EXSR      GetCustDtls

      ** Nostro Name and Branch

     C                   EXSR      GetNostDtls
     C                   EVAL      PDBRCH = ERNBRC

      ** Print Report Headers for every new page

     C                   IF        WRecNo = 1
     C                   EVAL      PRTLN1 = 70
     C                   ENDIF

     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   EXSR      SRPrintHdr3
     C                   ENDIF

     C                   WRITE     DETAIL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls - Get Customer Details (Report Name and Town)    *
      *                                                               *
      *****************************************************************
     C     GetCustDtls   BEGSR

     C                   EVAL      PAKEY1 = ERCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAKEY1
     C                   PARM      *BLANKS       PAKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     PRtCd         IFEQ      *BLANKS
     C                   EVAL      PDRPNM = BBCRNM
     C                   EVAL      PDRPTW = BBCRTN
     C                   EVAL      PDSHRT = BBCSSN
     C                   ELSE
     C                   EVAL      PDRPNM = *Blanks
     C                   EVAL      PDRPTW = *Blanks
     C                   EVAL      PDSHRT = *Blanks
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

     C                   EVAL      RqdLn1 = 1                                               MD034487
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 MD034487
                                                                                            MD034487
     C                   IF        DifLn1 <= RqdLn1                                         MD034487
     C                   EXSR      SRPrintHdr1                                              MD034487
     C                   EXSR      SRPrintHdr2                                              MD034487
     C                   EXSR      SRPrintHdr3                                              MD034487
     C                   ENDIF                                                              MD034487
                                                                                            MD034487
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

      ** Ensure Audit Spool File recorded by RCF

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

     C                   EVAL      RCOUNT = WRecNo

      ** If there is a DB Error, Output the DB Error Information

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report

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
      *****************************************************************
      *                                                               *
      *  SRDropRecs- Confirm dropping of records.                     *
      *                                                               *
      *****************************************************************
     C     SRDropRecs    BEGSR

     C                   IF        WRecNo > 0

     C/EXEC SQL
     C+ DELETE from SDEERTTD
     C+ where ERDATE < :WRetDate
     C/END-EXEC

     C/EXEC SQL
     C+ DELETE from SDEXRTTD
     C***+*where*ERCUST||ERCCY||ERNOSC||ERTCCY not in                                       MD052296
     C***+*(SELECT*ERCUST||ERCCY||ERNOSC||ERTCCY from SDEERTTD)                             MD052296
     C+ where ERCUST CONCAT ERCCY CONCAT ERNOSC CONCAT ERTCCY not in                        MD052296
     C+ (SELECT ERCUST CONCAT ERCCY CONCAT ERNOSC CONCAT ERTCCY from SDEERTTD)              MD052296
     C/END-EXEC

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
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

     C     *DTAARA       DEFINE                  LDA

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
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   ENDIF

      * Retrieve the system value

     C                   EVAL      SVALK1 = 'EstExchRtRetention'
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10

      ** If the system value is not found then issue a database error

     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF

     C     BJRDNB        SUB       SVAL1_1       WRetDate

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
     C                   EVAL      PRTCD = '*ERROR'

     C                   RETURN

     C                   ENDSR
