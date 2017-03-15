     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Housekeeping Program')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000722 - Midas SD FATCA Housekeeping Programg              *
      *                                                               *
      *  Function:  This program will purge records in FATCA non-     *
      *             account holder details and FATCA customer details *
      *                                                               *
      *  Called By: SDC000722 - FATCA Housekeeping Program            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD039670 *CREATE   Date 26Jul16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD039670 - FATCA Housekeeping Program                        *
      *                                                               *
      *****************************************************************

     FSDFTNHL0  UF   E           K DISK    INFSR(*PSSR)
      ** SD FATCA Non-Account Holder Details

     FSD000722P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      ** SD FATCA Housekeeping Report - SDFTNHPD

     FSD000722AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
      ** SD FATCA Housekeeping Report - Audit

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
      ** File Information Data Structure for SD000722P1

     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D SPOOLU          DS
      ** File Information Data Structure for SD000722AU

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
     D PSeq            S              5                                          MD041294
     D SEnty           S              3                                          MD041294
                                                                                 MD041294
      ** ZSFILE Parameters                                                       MD041294
     D ZSERR           S              1                                          MD041294
     D ZSNUM           S              6  0                                       MD041294
     D KCUST           S              6                                          MD041294

      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

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

      ** Initialise LDA field

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = 'SD000722'
     C                   EVAL      DBPGM = 'SD000722'
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
     C                   EVAL      RCOUNT = *ZEROS
      ** Read first record from SDFTNHPD File

     C     *LOVAL        SETLL     SDFTNHL0
     C                   READ      SDFTNHL0

      ** If End of Records, Perform: Audit Reporting (No Records)

     C                   EVAL      WMEnd = 'N'
     C                   IF        %EOF(SDFTNHL0)
     C                   EVAL      WMEnd = 'Y'
     C                   ENDIF

     C                   DOW       NOT %EOF(SDFTNHL0)

      ** Check if Non-Account holder exists

     C                   EVAL      PKEY1  = FNNAHO
     C                   IF        PKEY1  <> *BLANKS

     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C     SDNAHO        PARM      SDNAHO        DSSDY

     C**********         IF        PRTCD = *BLANKS                                MD041294
     C**********         ELSE                                                     MD041294
     C**********         IF        PRTCD = '*NRF'                                 MD041294
     C                   IF        PRTCD = '*NRF' or                              MD041294
     C                             (PRTCD = *BLANKS and                           MD041294
     C                              NHCHTP = 'D')                                 MD041294


     C                   EXSR      SRPrint
     C                   DELETE    SDFTNHD0

      ** Count records read

     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   ENDIF
     C                   ENDIF
     C**********         ENDIF                                                    MD041294

     C                   READ      SDFTNHL0

      ** End of Do Until End of Valid Records

     C                   ENDDO

      ** Write End of Report

     C                   IF        RCOUNT <> *ZEROS
     C                   EXSR      SRWP1END
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /TITLE SR/SRPrint
      *****************************************************************
      *                                                               *
      *  SRPrint  - Process Report Lines                              *
      *                                                               *
      *  Called by: SrProcess                                         *
      *                                                               *
      *  Calls    : SRWP1REC                                          *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

      ** If first pass

     C                   IF        NOT %OPEN(SD000722P1)

      ** Do RCF processing

     C                   OPEN      SD000722P1

     C                   Z-ADD     SFNUM1        ZSNUM                           MD041294
     C                   CALL      'ZSFILE'                                      MD041294
     C                   PARM                    PSEQ                            MD041294
     C                   PARM      *BLANKS       SENTY                           MD041294
     C                   PARM                    SFILE1                          MD041294
     C                   PARM                    ZSNUM                           MD041294
     C                   PARM                    ZSERR                           MD041294
                                                                                 MD041294
      ** error during ZSFILE processing, return to calling program               MD041294
                                                                                 MD041294
     C                   IF        ZSERR = 'Y'                                   MD041294
     C                   EVAL      *INU7 = *ON                                   MD041294
     C                   EVAL      *INU8 = *ON                                   MD041294
     C                   EVAL      *INLR = *ON                                   MD041294
     C                   RETURN                                                  MD041294
     C                   ENDIF                                                   MD041294

     C                   WRITE     SD000722H1
     C                   ENDIF

      ** Write Details

     C                   EVAL      RANAHO = FNNAHO
     C                   EVAL      RANHTY = FNNHTY                               MD041294
     C                   EVAL      RANHST = FNNHST                               MD041294
     C                   EVAL      RACLAC = FNCLAC
     C                   EVAL      RAREPT = FNREPT                               MD041294
     C                   EVAL      RAINFC = FNINFC                               MD041294

     C**********         Z-ADD     FNCLAD        ZDAYNO                          MD041294
     C**********         EXSR      SRDATE2                                       MD041294
     C**********         MOVEL     ZADATE        RACLAD                          MD041294

     C**********         EVAL      RAPCLA = FNPCLA                               MD041294

     C                   EXSR      SRWP1REC

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

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page

     C                   EVAL      WRqdln = 1
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     SD000722H1
     C                   ENDIF

      ** Write out Detail Record

     C                   WRITE     SD000722D1

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
     C                   WRITE     SD000722H1
     C                   ENDIF

      ** Write out End Of Report Format

     C                   WRITE     SD000722E1

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

     C                   IF        NOT %OPEN(SD000722AU)                         MD041294
     C                   OPEN      SD000722AU
     C                   WRITE     SD000722A1
     C                   ENDIF                                                   MD041294

      ** If there is a DB Error, Output the DB Error Information

     C                   IF        *INU7 = *ON AND *INU8 = *ON
     C                   WRITE     SD000722B1
     C                   WRITE     SD000722T1
     C                   ELSE

     C                   WRITE     SD000722C1
     C                   WRITE     SD000722T1
     C                   ENDIF

      ** End Program and Return

     C                   IF        %OPEN(SD000722P1)
     C                   CLOSE     SD000722P1
     C                   ENDIF
     C                   IF        %OPEN(SD000722AU)
     C                   CLOSE     SD000722AU
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE2  - Convert Date to Printer Date                       *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls    : ZDATE2                                             *
      *                                                               *
      *****************************************************************

     C     SRDATE2       BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
