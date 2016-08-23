     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL ATU Authorisation Log File Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000579 - Midas GL ATU Authorisation Log File Housekeeping  *
      *                                                               *
      *  Function:  This is a new program that will purge records from*
      *             GLATULPD depending on the retention period defined*
      *             in the system values table.                       *
      *                                                               *
      *  Called By: GLC000579 - Midas GL ATU Authorisation Log File   *
      *                         Housekeeping Control                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *
     FGLATULL0  UF   E           K DISK    INFSR(*PSSR)
      *
     FGL000579P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      *
     FGL000579AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *
      /SPACE 3
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** File Information Data Structure for GL000579P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File Information Data Structure for GL000579AU
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Short data structures for Access Objects
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Long data structures for Access Objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRTCD           S              7
     D POPTN           S              7
     D PSEQ            S              5
     D PENTY           S              3
     D PZSERR          S              1
     D PZSNUM          S              6  0
     D PSFILE          S             10
     D WRUN            S              1
     D WOPEN           S              1
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing
      *
     C                   EXSR      SRPROCESS
      *
      ** Output Audit Report and End Program
      *
     C                   EXSR      SRAUDIT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     AOBANKR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Initialise LDA field
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBPGM  = PSPROCNAME
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = PRTCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** RCF Processing for Audit File
      *
     C                   EXSR      SRRCFAU
      *
      ** Report Work fields
      *
     C                   EVAL      OFLLN1 = *ZEROS
     C                   EVAL      WDIFLN = *ZEROS
     C                   EVAL      RCOUNT = *ZEROS
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrProcess
      *****************************************************************
      *                                                               *
      *  SrProcess - Subroutine to do the Detail Processing           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     SRAUDIT, SRREPORT, SRWP1END                       *
      *                                                               *
      *****************************************************************
      *
     C     SRPROCESS     BEGSR
      *
      ** Read first record from File
      *
     C                   READ      GLATULL0
      *
      ** If End of Records, Perform: Audit Reporting (No Records)
      *
     C                   IF        %EOF(GLATULL0)
     C                   EXSR      SRAUDIT
     C                   ENDIF
      *
      ** Do Until End of File
      *
     C                   DOW       NOT %EOF(GLATULL0)
      *
      ** Process Report Lines
      *
     C                   EXSR      SRREPORT
      *
      ** Delete record physically
      *
     C                   DELETE    GLATULD0
      *
      ** Accomulate qualified record
      *
     C                   EVAL      RCOUNT = RCOUNT + 1
      *
      ** Read next record
      *
     C                   READ      GLATULL0
      *
      ** End of Do Until End of Valid Records
      *
     C                   ENDDO
      *
      ** Write final records and Totals to Report
      *
     C                   IF        RCOUNT <> *ZEROS
     C                   EXSR      SRWP1END
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPORT
      *****************************************************************
      *                                                               *
      *  SRREPORT - Process Report Lines                              *
      *                                                               *
      *  Called By: SRFORMAT, SRRCFP1, SRWP1REC                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRREPORT      BEGSR
      *
     C                   EXSR      SRFORMAT
      *
     C                   IF        WOPEN  <> 'Y'
      *
      ** Do RCF processing
      *
     C                   EXSR      SRRCFP1
     C                   EVAL      WOPEN = 'Y'
      *
      ** Write header
      *
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write Detail
      *
     C                   EXSR      SRWP1REC
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWP1REC
      *****************************************************************
      *                                                               *
      *  SRWP1REC - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *  Called By: SRREPORT                                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRWP1REC      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
      *
     C                   EVAL      WRQDLN = 4
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Detail Record
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWP1END
      *****************************************************************
      *                                                               *
      *  SRWP1END - Subroutine to Write End of Report.                *
      *                                                               *
      *  Called By: SRPROCESS                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRWP1END      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
      *
     C                   EVAL      WRQDLN = 4
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Total Format
      *
     C                   WRITE     TRAILPY
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRAUDIT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *  Called By: Main Processing, SRPROCESS, *PSSR                 *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDIT       BEGSR
      *
      ** Output Report Header
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information
      *
     C                   IF        *INU7 = *ON  AND
     C                             *INU8 = *ON
      *
      ** Write control records if record processed is not zeros
      *
     C                   IF        RCOUNT <> *ZEROS
     C                   WRITE     CONTROL
     C                   ENDIF
      *
     C                   WRITE     DBERROR
      *
     C                   ELSE
      *
      ** If no records read, Output "No Details" message
      ** else, write file control format
      *
     C                   IF        RCOUNT = *ZEROS
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Print End of Report
      *
     C                   WRITE     ENDRPT
      *
      ** End Program and Return
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRFORMAT
      *****************************************************************
      *                                                               *
      *  SRFORMAT - Subroutine to Format Details                      *
      *                                                               *
      *  Called By: SRREPORT                                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRFORMAT      BEGSR
      *
      ** Populate printer file detail fields
      *
     C                   EVAL      RCRTD = ATCRTD
     C                   EVAL      RNARR = ATNARR
     C                   EVAL      RJOBN = ATJOBN
     C                   EVAL      RJOB  = ATJOB
     C                   EVAL      RUSER = ATUSER
     C                   EVAL      RTIME = ATTIME
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRRCFP1
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called By: SRREPORT                                          *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP1       BEGSR
      *
     C                   OPEN      GL000579P1
      *
      ** Ensure Report Spool File recorded by RCF
      *
     C                   Z-ADD     SFNUM1        PZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRRCFAU
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
      *  Called By: SRINIT                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFAU       BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF
      *
     C                   Z-ADD     SFNUMU        PZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
      ** Check to see that *PSSR has not already been called
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   EXSR      SRAUDIT
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2010
