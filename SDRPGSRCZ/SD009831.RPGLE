     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Account Transfer Type/Sub-Type Housekeep')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  SD009831 - SD Account Transfer Type/Sub-Type Housekeeping    *
      *                                                               *
      *  Function:  This program will purge all records in Account    *
      *             Transfer Type/Sub-Type file                       *
      *                                                               *
      *  Called By: SDC009831 - Account Transfer Type/Sub-Type        *
      *             Housekeeping                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27394*CREATE    Date 26Apr10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27394 - Add new field Record ID to allow logical deletion *
      *             of this file                                      *
      *                                                               *
      *****************************************************************
 
     FSDATSTL0  UF   E           K DISK    INFSR(*PSSR)
      ** SD Account Transfer Type/Sub-Type File
 
     FSD009831P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      ** SD Account Transfer Type/Sub-Type Housekeeping Report
 
     FSD009831AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
      ** SD Account Transfer Type/Sub-Type Housekeeping Report - Audit
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInit   - Program Initialisation                            *
      *  SRProces - Detail Processing                                 *
      *  SRPrint  - Process Report Lines                              *
      *  SRAudit  - Produce Audit Report and End Program              *
      *                                                               *
      *  SRWP1REC - Write a Detail Record to the Report               *
      *  SRWP1END - Write End of Report                               *
      *                                                               *
      *  *PSSR    - Program Error Processing Subroutine               *
      *  SRRCFP1  - RCF Processing for P1 Report                      *
      *  SRRCFAU  - RCF Processing for Audit Report                   *
      *                                                               *
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
      ** File Information Data Structure for GL003000P1
 
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ** File Information Data Structure for GL003000AU
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structures for Access Objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7
     D POptn           S              7
     D PSeq            S              5
     D PEnty           S              3
     D PZSErr          S              1
     D PZSNum          S              6  0
     D PSFile          S             10
     D WRun            S              1
     D WRqdln          S              3  0
     D WDifln          S              3  0
     D W2DBAC          S             10
     D W2DBSQ          S              2
     D W2CRAC          S             10
     D W2CRSQ          S              2
     D K_SeqNam        S             20
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Initialisation
 
     C                   EXSR      SRInit
 
      ** Perform Detail Processing
 
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program
 
     C                   EXSR      SRAudit
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation             *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Initialise LDA field
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = 'SD009831'
     C                   EVAL      DBPGM = 'SD009831'
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
 
      ** Report Work fields
 
     C                   EVAL      OFLLN1 = *ZEROS
     C                   EVAL      WDifln = *ZEROS
     C                   EVAL      RCOUNT = *ZEROS
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRProcess
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to do the Detail Processing           *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Read first record from File
 
     C     *LOVAL        SETLL     SDATSTL0
     C                   READ      SDATSTL0
 
      ** If End of Records, Perform: Audit Reporting (No Records)
 
     C                   IF        %EOF(SDATSTL0)
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOW       NOT %EOF(SDATSTL0)
 
     C                   IF        ATRECI = 'R'
     C                   EXSR      SRPrint
     C                   DELETE    SDATSTD0
 
      ** Count records read
 
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   ENDIF
 
     C                   READ      SDATSTL0
 
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
      *****************************************************************
 
     C     SRPrint       BEGSR
 
      ** If first pass or branch is not the same as previous branch
 
     C                   IF        NOT %OPEN(SD009831P1)
     C                   OPEN      SD009831P1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Do RCF processing
 
     C                   EXSR      SRRCFP1
 
      ** Write Details
      ** Trans Type, Trans Subtype, Trans Desc
 
     C                   EVAL      RATRTY = ATTRTY
     C                   EVAL      RATRST = ATTRST
     C                   EVAL      RATRSD = ATTRSD
 
      ** DB Account
 
     C                   MOVE      ATDBAC        W2DBAC
     C                   MOVE      ATCRSQ        W2CRSQ
     C                   EVAL      RADBAC = ATDBBR + ATDBCU + ATDBCY +
     C                                      W2DBAC + W2DBSQ
 
      ** CR Account
 
     C                   MOVE      ATCRAC        W2CRAC
     C                   MOVE      ATCRSQ        W2CRSQ
     C                   EVAL      RACRAC = ATCRBR + ATCRCU + ATCRCY +
     C                                      W2CRAC + W2CRSQ
 
     C                   EXSR      SRWP1REC
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWP1REC
      *****************************************************************
      *                                                               *
      *  SRWP1REC - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *****************************************************************
 
     C     SRWP1REC      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = 1
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWP1END
      *****************************************************************
      *                                                               *
      *  SRWP1END - Subroutine to Write End of Report                 *
      *                                                               *
      *****************************************************************
 
     C     SRWP1END      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = 4
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Write out Trailer Format
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRAudit
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Open Audit Report, Do RCF processing & Print Header
 
     C                   OPEN      SD009831AU
     C                   EXSR      SRRCFAU
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON AND *INU8 = *ON
     C                   WRITE     DBERROR
     C                   WRITE     TRAILAU
     C                   ELSE
 
      ** If no records read, Output "No Details" message
      ** else, write file control format
 
     C                   IF        RCOUNT = *ZEROS
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   WRITE     TRAILAU
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   IF        %OPEN(SD009831P1)
     C                   CLOSE     SD009831P1
     C                   ENDIF
     C                   IF        %OPEN(SD009831AU)
     C                   CLOSE     SD009831AU
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
      /TITLE SR/SRRCFP1
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILE1
     C                   Z-ADD     SFNUM1        PZSNum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRRCFAU
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILEU
     C                   EVAL      PZSNum = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
