     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Interface Password Report')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  PRTF/SD000406 - Midas SD Interface Password Report           *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053487  *CREATE  Date 28May19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053487 - Audit Report should be available for Interface    *
      *             Password Maintenance                              *
      *                                                               *
      *****************************************************************

     FSDFACXI0  IF   E           K DISK    INFSR(*PSSR)
      ** SD FATCA Non-Account Holder Details

     FSD000406P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      ** SD CRS Housekeeping Report

     FSD000406AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
      ** SD CRS Housekeeping Report - Audit

      *****************************************************************
      /SPACE 3
      *****************************************************************
     D/EJECT
      ** Array containing Copyright statement

      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D SPOOL1          DS
      ** File Information Data Structure for SD000723P1

     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D SPOOLU          DS
      ** File Information Data Structure for SD000723AU

     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structures for Access Objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structures for Access Objects

     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      ** Data Structure for Non-A/C Holder

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S             10
     D WRun            S              1
     D WRqdln          S              3  0
     D WDifln          S              3  0
     D WMEnd           S              1A
     D PrintNew        S              1A
     D WWINTF          S             20A
     D WWLCTP          S              6A
     D WWLCDT          S             10A
     D WWTMST          S             26A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************

      ** Perform Initialisation
     C                   EXSR      SRInit

      ** Perform Detail Processing 1
     C                   EXSR      SRProcess

      ** Output Audit Report and End Program
     C                   EXSR      SRAudit

     C                   EVAL      *INLR = *ON

     C                   RETURN

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : AOBANKR0, AOSVALR0                                *
      *                                                               *
      *****************************************************************

     C     SRInit        BEGSR

     C                   EVAL      RCOUNT1 = 0
     C                   EVAL      RCOUNT2 = 0
     C                   EVAL      RCOUNT3 = 0
     C                   EVAL      RCOUNT4 = 0
     C                   EVAL      RCOUNT5 = 0
     C                   EVAL      RCOUNT6 = 0
     C                   EVAL      RCOUNT7 = 0
     C                   EVAL      RCOUNT8 = 0
     C                   EVAL      RCOUNT  = 0
     C                   EVAL      PrintNew = 'N'
     C                   EVAL      WWINTF = *Blanks

     C                   ENDSR

      *****************************************************************
      /TITLE SR/SRProcess
      *****************************************************************
      *                                                               *
      *  SRProcess  - Subroutine to do the Detail Processing          *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : SRPrint , SRWP1END                                *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

      ** Report Work fields

     C                   EVAL      OFLLN1 = *ZEROS
     C                   EVAL      WDifln = *ZEROS

      ** Read first record from SDFTNHPD File

     C     *LOVAL        SETLL     SDFACXI0
     C                   READ      SDFACXI0

      ** If End of Records, Perform: Audit Reporting (No Records)

     C                   EVAL      WMEnd = 'N'
     C                   IF        %EOF(SDFACXI0)
     C                   EVAL      WMEnd = 'Y'
     C                   ENDIF

     C                   DOW       NOT %EOF(SDFACXI0)

     C                   IF        NOT %OPEN(SD000406P1)

      ** Do RCF processing

     C                   OPEN      SD000406P1

     C                   WRITE     SD000406H1
     C                   ENDIF

     C                   IF        ININTF <> WWINTF
     C                   EVAL      PrintNew = 'Y'
     C                   ENDIF

     C                   IF        INTYLC = 'I'
     C                   EVAL      WWLCTP = 'Insert'
     C                   ENDIF

     C                   IF        INTYLC = 'A'
     C                   EVAL      WWLCTP = 'Amend'
     C                   ENDIF

     C                   MOVEL     INTMST        WWTMST
     C                   MOVEL     WWTMST        WWLCDT
     C                   IF        WWLCDT = '0001-01-01'
     C                   EVAL      WWLCDT = *Blanks
     C                   ENDIF

      ** Write Details

     C                   EVAL      RAUSER = INUSER
     C                   EVAL      RAUSRD = INUSRD
     C                   EVAL      RALCTP = WWLCTP
     C                   EVAL      RALCDT = WWLCDT
     C                   EVAL      RALCUS = INLCUS
     C                   EVAL      RCOUNT = RCOUNT + 1

     C                   SELECT
     C                   WHEN      ININTF = 'BANKFUSION'
     C                   EVAL      RCOUNT1 = RCOUNT1 + 1
     C                   EVAL      RAINTF = 'BankFusion'

     C                   WHEN      ININTF = 'COMPLKYC'
     C                   EVAL      RCOUNT2 = RCOUNT2 + 1
     C                   EVAL      RAINTF = 'Compliance Alert KYC'

     C                   WHEN      ININTF = 'COMPLWATCH'
     C                   EVAL      RCOUNT3 = RCOUNT3 + 1
     C                   EVAL      RAINTF = 'Compliance Watch'

     C                   WHEN      ININTF = 'CORRMANAGER'
     C                   EVAL      RCOUNT4 = RCOUNT4 + 1
     C                   EVAL      RAINTF = 'Correspondence Manager'

     C                   WHEN      ININTF = 'FONTIS'
     C                   EVAL      RCOUNT5 = RCOUNT5 + 1
     C                   EVAL      RAINTF = 'Fontis Interface'

     C                   WHEN      ININTF = 'FRSREGULATORY'
     C                   EVAL      RCOUNT6 = RCOUNT6 + 1
     C                   EVAL      RAINTF = 'FRS Regulatory'

     C                   WHEN      ININTF = 'PEA'
     C                   EVAL      RCOUNT7 = RCOUNT7 + 1
     C                   EVAL      RAINTF = 'PEA System'

     C                   WHEN      ININTF = 'SWIFTALLIANCE'
     C                   EVAL      RCOUNT8 = RCOUNT8 + 1
     C                   EVAL      RAINTF = 'SWIFT Alliance'

     C                   ENDSL


     C                   EXSR      SRWP1REC

     C                   EVAL      WWINTF = ININTF

     C                   READ      SDFACXI0

      ** End of Do Until End of Valid Records

     C                   ENDDO

      ** Write End of Report

     C                   IF        RCOUNT <> *ZEROS
     C                   EXSR      SRWP1END
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /TITLE SR/SRWP1REC
      *****************************************************************
      *                                                               *
      *  SRWP1REC - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *  Called by: SrPrint                                           *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************

     C     SRWP1REC      BEGSR

     C                   IF        PrintNew = 'Y'
     C                   EVAL      PrintNew = 'N'
     C                   EVAL      WRqdln = 4
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     SD000406H1
     C                   ENDIF
     C                   WRITE     SD000406H2
     C                   ENDIF

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page

     C                   EVAL      WRqdln = 1
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     SD000406H1
     C                   WRITE     SD000406H2
     C                   ENDIF

      ** Write out Detail Record

     C                   WRITE     SD000406D1

     C                   ENDSR

      *
      *****************************************************************
      /TITLE SR/SRWP1END
      *****************************************************************
      *                                                               *
      *  SRWP1END - Subroutine to Write End of Report                 *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************

     C     SRWP1END      BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page

     C                   EVAL      WRqdln = 4
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     SD000406H1
     C                   ENDIF

      ** Write out End Of Report Format

     C                   WRITE     SD000406E1

     C                   ENDSR

      *****************************************************************
      /TITLE SR/SRAudit
      *****************************************************************
      *                                                               *
      *  SRAudit1- Subroutine to Output Audit report and End Program  *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

      ** Open Audit Report, Do RCF processing & Print Header

     C                   OPEN      SD000406AU
     C                   WRITE     SD000406A1

      ** If there is a DB Error, Output the DB Error Information

     C                   IF        *INU7 = *ON AND *INU8 = *ON
     C                   WRITE     SD000406B1
     C                   WRITE     SD000406T1
     C                   ELSE

     C                   WRITE     SD000406C1
     C                   WRITE     SD000406T1
     C                   ENDIF

      ** End Program and Return

     C                   IF        %OPEN(SD000406P1)
     C                   CLOSE     SD000406P1
     C                   ENDIF
     C                   IF        %OPEN(SD000406AU)
     C                   CLOSE     SD000406AU
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *  Called by : Start of the program                             *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialise LDA field

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = 'SD000406'
     C                   EVAL      DBPGM = 'SD000406'
     C                   OUT       LDA

      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number

     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Handle Database Error

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = PRtCd
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
