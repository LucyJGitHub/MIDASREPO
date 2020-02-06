     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS Housekeeping Program')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000723 - Midas SD CRS Housekeeping Programg                *
      *                                                               *
      *  Function:  This program will purge records in CRS Customer   *
      *             detail and API Format Def files                   *
      *                                                               *
      *  Called By: SDC000723 - CRS Housekeeping Program              *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD039670 *CREATE   Date 26Jul16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039670 - FATCA Housekeeping Program                        *
      *                                                               *
      *****************************************************************
 
     FSDFTNHL0  IF   E           K DISK    INFSR(*PSSR)
      ** SD FATCA Non-Account Holder Details
 
     FSDCRNHL0  UF   E           K DISK    INFSR(*PSSR)
      ** SD CRS Cust Det File
 
     FSDCRSNL0  UF   E           K DISK    INFSR(*PSSR)
      ** SD CRS Cust Det File
 
     FSD000723P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      ** SD CRS Housekeeping Report
 
     FSD000723AUO    E             PRINTER INFSR(*PSSR) USROPN
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
     C                   EVAL      DBMOD = 'SD000723'
     C                   EVAL      DBPGM = 'SD000723'
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
 
     C                   IF        PRTCD = *BLANKS
     C                   ELSE
     C                   IF        PRTCD = '*NRF'
 
     C     PKEY1         CHAIN     SDCRNHL0
     C                   IF        %FOUND(SDCRNHL0)
     C                   EXSR      SRPrint
     C                   DELETE    SDCRNHD0
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   ENDIF
 
      ** Count records read
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
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
 
     C                   IF        NOT %OPEN(SD000723P1)
 
      ** Do RCF processing
 
     C                   OPEN      SD000723P1
 
     C                   WRITE     SD000723H1
     C                   ENDIF
 
      ** Write Details
 
     C                   EVAL      RANAHO = NRNAHO
     C                   EVAL      RATYPE = NRTYPE
     C                   EVAL      RASTYP = NRSTYP
     C                   EVAL      RACTRY = *BLANKS
     C                   EVAL      RAREPT = *BLANKS
 
     C                   EXSR      SRWP1REC
 
     C     PKEY1         CHAIN     SDCRSNL0
     C                   DOW       NOT %EOF(SDCRSNL0)
     C                   EVAL      RANAHO = *BLANKS
     C                   EVAL      RATYPE = *BLANKS
     C                   EVAL      RASTYP = *BLANKS
     C                   EVAL      RACTRY = CNCTRY
     C                   EVAL      RAREPT = CNREPT
     C                   EVAL      RCOUNT2 =+ 1
     C                   EXSR      SRWP1REC
     C                   DELETE    SDCRSND0
     C     PKEY1         READE     SDCRSNL0
     C                   ENDDO
 
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
     C                   WRITE     SD000723H1
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     SD000723D1
 
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
     C                   WRITE     SD000723H1
     C                   ENDIF
 
      ** Write out End Of Report Format
 
     C                   WRITE     SD000723E1
 
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
 
     C                   OPEN      SD000723AU
     C                   WRITE     SD000723A1
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON AND *INU8 = *ON
     C                   WRITE     SD000723B1
     C                   WRITE     SD000723T1
     C                   ELSE
 
     C                   WRITE     SD000723C1
     C                   WRITE     SD000723C2
     C                   WRITE     SD000723T1
     C                   ENDIF
 
      ** End Program and Return
 
     C                   IF        %OPEN(SD000723P1)
     C                   CLOSE     SD000723P1
     C                   ENDIF
     C                   IF        %OPEN(SD000723AU)
     C                   CLOSE     SD000723AU
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
