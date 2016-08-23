     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Outgoing Message Field Management Report')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1751   - ME Outgoing Message Field Management Report       *
      *                                                               *
      *  Function:  This program will generate a report of all        *
      *             data input in the outgoing message field          *
      *             management file.                                  *
      *                                                               *
      *  Called By: ME1751 - ME Outgoing Message Field Management     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14042           Date 24May07               *
      *  Prev Amend No. CSW207             Date 07Jul07               *
      *                 BUG13798           Date 24Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032  *CREATE    Date 11Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14042 - CFT032 errors ; applied fix 13798 (Recompile)     *
      *  CSW207 - SWIFT 2007 Standard Changes                         *
      *  BUG13978 - CFT032 errors (Recompile)                         *
      *  CFT032 - Account line in field 50X in MT103                  *
      *                                                               *
      *****************************************************************
     FMEOUFML1  IF   E           K DISK    INFSR(*PSSR)
 
     FME1751AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
 
     FME1751P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D/COPY ZACPYSRC,PSDS
 
     D LDA           E DS           256    EXTNAME(LDA)
 
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** External data structures for Branch Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data Structures for Access Objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PETTY           S              3
     D PSEQ            S              5
     D PRTCD           S              7
     D POPTN           S              7
     D PZSERR          S              1
     D PZSNUM          S              6  0
     D PSFILE          S             10
     D WRUN            S              1
     D WOPEN           S              1
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
     D WNWRK           S                   Like(OMNWRK)
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
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameter Entry
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    PETTY
      *
      ** Initialise LDA field
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = *BLANKS
     C                   EVAL      DBPGM = 'ME1751'
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
     C                   EVAL      WDIFLN = *ZEROS
     C                   EVAL      RCOUNT = *ZEROS
      *                                                                                       CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRTCD                                        CSW207
     C                   IF        PRTCD = 'CSW2007'                                          CSW207
     C                   EVAL      *IN50 = *ON                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN50 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROCESS
      *****************************************************************
      *                                                               *
      *  SRPROCESS - Subroutine to do the Detail Processing           *
      *                                                               *
      *****************************************************************
      *
     C     SRPROCESS     BEGSR
      *
      ** Read first record from file
      *
     C                   READ      MEOUFML1
      *
      ** If End of Records, Perform: Audit Reporting (No Records)
      *
     C                   IF        %EOF(MEOUFML1)
     C                   EXSR      SRAUDIT
     C                   ENDIF
      *
      ** Do Until End of File
      *
     C                   DOW       NOT %EOF(MEOUFML1)
      *
      ** Process Report Lines
      *
     C                   EXSR      SRREPORT
      *
      ** Accumulate qualified record
      *
     C                   EVAL      RCOUNT = RCOUNT + 1
      *
      ** Read next record
      *
     C                   READ      MEOUFML1
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
      *****************************************************************
      *
     C     SRREPORT      BEGSR
      *
     C                   EXSR      SRFORMAT
      *
      ** Do RCF processing
      *
     C                   IF        WOPEN <> 'Y'
     C                   EXSR      SRRCFP1
     C                   EVAL      WOPEN = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WNWRK = OMNWRK
     C                   ENDIF
      *
      ** If network is not the same as previous netowrk, new page
      *
     C                   IF        WNWRK <> OMNWRK
     C                   WRITE     HEADP1
     C                   EVAL      WNWRK = OMNWRK
     C                   ENDIF
      *
      ** Write Detail
      *
     C                   EXSR      SRWP1REC
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRFORMAT
      *****************************************************************
      *                                                               *
      *  SRFORMAT - Subroutine to Format Details                      *
      *                                                               *
      *****************************************************************
      *
     C     SRFORMAT      BEGSR
      *
      ** Populate printer file detail fields
      *
     C                   EVAL      RNWRK = OMNWRK
     C                   EVAL      RMTYP = OMMTPY
     C                   EVAL      RMTAG = OMMTAG
     C                   EVAL      RSBRC = OMSBRC
     C                   EVAL      RCTRY = OMCTRY
     C                   EVAL      RCURR = OMCURR
     C                   EVAL      RNOST = OMNOST
     C                   EVAL      RACTI = OMACTI
     C                   EVAL      RFLAG = OMFLAG
     C                   IF        *IN50 = *ON                                                CSW207
     C                   EVAL      R50F1 = OM50F1                                             CSW207
     C                   EVAL      R50F2 = OM50F2                                             CSW207
     C                   EVAL      R50F3 = OM50F3                                             CSW207
     C                   EVAL      R50F4 = OM50F4                                             CSW207
     C                   EVAL      R50F5 = OM50F5                                             CSW207
     C                   ENDIF                                                                CSW207
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWP1REC
      *****************************************************************
      *                                                               *
      *  SRWP1REC - Subroutine to Write a Detail Record to the Report *
      *                                                               *
      *****************************************************************
      *
     C     SRWP1REC      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
      *
     C                   IF        *IN50 = *OFF                                               CSW207
     C                   EVAL      WRqdln = 2
     C                   ELSE                                                                 CSW207
     C                   EVAL      WRqdln = 6                                                 CSW207
     C                   ENDIF                                                                CSW207
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln < WRqdln
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Detail Record
      *
     C                   WRITE     DTLP1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWP1END
      *****************************************************************
      *                                                               *
      *  SRWP1END - Subroutine to Write End of Report.                *
      *                                                               *
      *****************************************************************
      *
     C     SRWP1END      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
      *
     C                   EVAL      WRqdln = 4
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln < WRqdln
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRAUDIT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
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
     C                   IF        *INU7 = *ON
     C                             AND *INU8 = *ON
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
      ** End Program and Return
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
      /TITLE SR/SRRCFP1
      *****************************************************************
      *                                                               *
      *  SRRCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP1       BEGSR
      *
     C                   OPEN      ME1751P1
      *
      ** Ensure Report Spool File recorded by RCF
      *
     C                   Z-ADD     SFNUM1        PZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PETTY
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
     C                   PARM                    PETTY
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
