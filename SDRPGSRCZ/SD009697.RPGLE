     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Account Review Housekeeping')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009697 - Midas SD Account Review Housekeeping              *
      *                                                               *
      *  Function:  This program will purge records in Account        *
      *             Review file and History of Customer Info          *
      *                                                               *
      *  Called By: SDC009697 - Account Review Housekeeping           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027577           Date 17Jun14               *
      *  Prev Amend No. MD027295           Date 24May14               *
      *                 MD026599           Date 28May14               *
      *                 MD026848           Date 12May14               *
      *                 MD026766           Date 12May14               *
      *                 CGL132             Date 01May13               *
      *                 MD026193           Date 07Apr14               *
      *                 MD026274           Date 10Apr14               *
      *                 CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027577 - History of customer information purge issue       *
      *  MD027295 - SDC009697 COB component run too long              *
      *  MD026599 - FATCA information complete flag is missing in     *
      *             history of customer information (Recompile)       *
      *  MD026848 - History of cust information is not updated when   *
      *             customer's FATCA classification is change         *
      *             manually (Recompile)                              *
      *  MD026766 - Error on ACRV SOAP transactions                   *
      *  MD026193 - History of cust information is not updated        *
      *             (Recompile)                                       *
      *  MD026274 - Previous comment is not recorded in comment       *
      *             history (Recompile)                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
     FSDACRVL5  UF   E           K DISK    INFSR(*PSSR)
      ** SD Account Review File
 
     FSDACEXL0  UF   E           K DISK    INFSR(*PSSR)                                     MD026766
      ** SD Account Review Extension File                                                   MD026766
                                                                                            MD026766
     FSDARCHL0  UF   E           K DISK    INFSR(*PSSR)
      ** SD Account Review Comment History
 
     FSDHCINL0  UF   E           K DISK    INFSR(*PSSR)
      ** SD History of Customer Information
 
     F***SDHCIDL0  UF   E           K DISK    INFSR(*PSSR)                                  MD027295
     FSDHCIDL1  UF   E           K DISK    INFSR(*PSSR)                                     MD027295
      ** SD History of Customer Information Detail
 
     FSDHCILL1  UF   E           K DISK    INFSR(*PSSR)                                     MD027295
      ** SD History of Customer Information Detail 2                                        MD027295
                                                                                            MD027295
     FSD009697P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      ** SD Account Review Housekeeping Report
 
     FSD009697AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
      ** SD Account Review Housekeeping Report - Audit
 
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
      ** File Information Data Structure for SD009697P1
 
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ** File Information Data Structure for SD009697AU
 
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
     D WRetPrd         S              5
     D WRetPrdN        S              5  0
     D WRetCalc        S              5  0
     D WTranRetPrd     S              5  0
     D W2DBAC          S             10
     D W2DBSQ          S              2
     D W2CRAC          S             10
     D W2CRSQ          S              2
     D KSeqNam         S             20
     D WMEnd           S              1A
     D KInputDate      S              5P 0                                                  MD027295
 
      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
     D PDOP01          S             20
     D PDVL01          S            200
     D PDOP02          S             20
     D PDVL02          S            200
     D PDOP03          S             20
     D PDVL03          S            200
     D PDOP04          S             20
     D PDVL04          S            200
     D PDOP05          S             20
     D PDVL05          S            200
     D PDOP06          S             20
     D PDVL06          S            200
     D PDOP07          S             20
     D PDVL07          S            200
     D PDOP08          S             20
     D PDVL08          S            200
     D PDOP09          s             20
     D PDVL09          S            200
     D PDOP10          S             20
     D PDVL10          S            200
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
 
      ** Perform Initialisation
 
     C                   EXSR      SRInit
 
      ** Perform Detail Processing
 
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program
 
     C                   EXSR      SRAudit
 
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
     C                   EVAL      DBMOD = 'SD009697'
     C                   EVAL      DBPGM = 'SD009697'
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
 
      ** Call Access Program for System Value
 
     C**********         EVAL      PDOP01 = 'AccRevNotDaysActRept'                          MD027295
     C                   EVAL      PDOP01 = 'AccountRevRetPeriod'                           MD027295
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PDOP01
     C                   PARM      *BLANKS       PDVL01
     C                   PARM                    PDOP02
     C                   PARM      *BLANKS       PDVL02
     C                   PARM                    PDOP03
     C                   PARM      *BLANKS       PDVL03
     C                   PARM                    PDOP04
     C                   PARM      *BLANKS       PDVL04
     C                   PARM                    PDOP05
     C                   PARM      *BLANKS       PDVL05
     C                   PARM                    PDOP06
     C                   PARM      *BLANKS       PDVL06
     C                   PARM                    PDOP07
     C                   PARM      *BLANKS       PDVL07
     C                   PARM                    PDOP08
     C                   PARM      *BLANKS       PDVL08
     C                   PARM                    PDOP09
     C                   PARM      *BLANKS       PDVL09
     C                   PARM                    PDOP10
     C                   PARM      *BLANKS       PDVL10
 
      ** Handle Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = PDOP01
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PDVL01 <> *BLANKS
     C                   EVALR     WRetPrd =  %TRIM(PDVL01)
     C                   ENDIF
     C                   MOVE      WRetPrd       WRetPrdN
     C                   EVAL      WTranRetPrd = WRetPrdN * 30
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
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : SRPrint, SRWP1END                                 *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Read first record from File
 
     C     *LOVAL        SETLL     SDACRVL5
     C                   READ      SDACRVL5
 
      ** If End of Records, Perform: Audit Reporting (No Records)
 
     C                   EVAL      WMEnd = 'N'
     C                   IF        %EOF(SDACRVL5)
     C                   EVAL      WMEnd = 'Y'
     C                   ENDIF
 
     C                   DOW       NOT %EOF(SDACRVL5)
 
      ** Check if the exec date has fallen beyond the retention period
 
     C                   EVAL      WRetCalc = ARCDAT + WTranRetPrd
     C                   IF        WRetCalc < BJRDNB
 
     C                   EXSR      SRPrint
     C                   DELETE    SDACRVD0
 
     C                   EVAL      KKSCDT =   %EDITC(ARSCDT:'X')                            MD026766
     C                   EVAL      KKSEQN =   %EDITC(ARSEQN:'3')                            MD026766
     C     KACRVEX       CHAIN     SDACEXL0                                                 MD026766
     C                   IF        %FOUND (SDACEXL0)                                        MD026766
     C                   DELETE    TSDACRVD0                                                MD026766
     C                   ENDIF                                                              MD026766
                                                                                            MD026766
      ** Count records read
 
     C                   EVAL      RCOUNT = RCOUNT + 1
     C                   ENDIF
 
     C                   READ      SDACRVL5
 
      ** End of Do Until End of Valid Records
 
     C                   ENDDO
 
     C                   IF        WMEnd = 'N'
 
     C     *LOVAL        SETLL     SDARCHL0
     C                   READ      SDARCHL0
 
     C                   DOW       NOT %EOF(SDARCHL0)
 
     C                   EVAL      WRetCalc = AHINDT + WTranRetPrd
     C                   IF        WRetCalc < BJRDNB
     C                   DELETE    SDARCHD0
     C                   ENDIF
     C                   READ      SDARCHL0
     C                   ENDDO
 
     C     *LOVAL        SETLL     SDHCINL0
     C                   READ      SDHCINL0
 
     C                   DOW       NOT %EOF(SDHCINL0)
 
     C                   EVAL      WRetCalc = HCINDT + WTranRetPrd
     C                   IF        WRetCalc < BJRDNB
     C                   DELETE    SDHCIND0
     C                   ENDIF
     C                   READ      SDHCINL0
     C                   ENDDO
 
     C                   EVAL      KInputDate = BJRDNB - WTranRetPrd                        MD027295
     C     KInputDate    SETGT     SDHCIDL1                                                 MD027295
     C                   READP     SDHCIDL1                               80                MD027295
     C                   IF        *IN80 = *OFF                                             MD027295
     C                   EVAL      KInputDate = HDINDT                                      MD027295
     C     KInputDate    SETLL     SDHCIDL1                                                 MD027295
     C                   READP     SDHCIDL1                               80                MD027295
     C                   DOW       *IN80 = *OFF                                             MD027295
     C                   EVAL      WRetCalc = HDINDT + WTranRetPrd                          MD027577
     C                   IF        WRetCalc < BJRDNB                                        MD027577
     C                   DELETE    SDHCIDD0                                                 MD027295
     C                   ENDIF                                                              MD027577
     C                   READP     SDHCIDL1                               80                MD027295
     C                   ENDDO                                                              MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C     KInputDate    SETGT     SDHCILL1                                                 MD027295
     C                   READP     SDHCILL1                               80                MD027295
     C                   DOW       *IN80 = *OFF                                             MD027295
     C                   EVAL      WRetCalc = HLINDT + WTranRetPrd                          MD027577
     C                   IF        WRetCalc < BJRDNB                                        MD027577
     C                   DELETE    SDHCILD0                                                 MD027295
     C                   ENDIF                                                              MD027577
     C                   READP     SDHCILL1                               80                MD027295
     C                   ENDDO                                                              MD027295
                                                                                            MD027295
     C                   ENDIF                                                              MD027295
     C******LOVAL        SETLL     SDHCIDL0                                                 MD027295
     C**********         READ      SDHCIDL0                                                 MD027295
      **********                                                                            MD027295
     C**********         DOW       NOT %EOF(SDHCIDL0)                                       MD027295
      **********                                                                            MD027295
     C**********         EVAL      WRetCalc = HDINDT + WTranRetPrd                          MD027295
     C**********         IF        WRetCalc < BJRDNB                                        MD027295
     C**********         DELETE    SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                              MD027295
     C**********         READ      SDHCIDL0                                                 MD027295
     C**********         ENDDO                                                              MD027295
      **********                                                                            MD027295
     C**********         ENDIF                                                              MD027295
 
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
      *  Calls    : SRRCFP1, SRWP1REC                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
      ** If first pass or branch is not the same as previous branch
 
     C                   IF        NOT %OPEN(SD009697P1)
 
      ** Do RCF processing
 
     C                   OPEN      SD009697P1
     C                   EXSR      SRRCFP1
 
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Write Details
 
     C                   EVAL      RACUST = ARCUST
     C                   EVAL      RAPUR1 = ARPURP
 
     C                   Z-ADD     ARSCDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        RASCDF
 
     C                   Z-ADD     ARACDT        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        RAACDF
 
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
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : SRRCFAU                                           *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Open Audit Report, Do RCF processing & Print Header
 
     C                   OPEN      SD009697AU
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
 
     C                   IF        %OPEN(SD009697P1)
     C                   CLOSE     SD009697P1
     C                   ENDIF
     C                   IF        %OPEN(SD009697AU)
     C                   CLOSE     SD009697AU
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
      /TITLE SR/SRRCFP1
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by: SrPrint                                           *
      *                                                               *
      *  Calls    : ZSFILE                                            *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILE1
     C                   Z-ADD     SFNUM1        PZSNum
     C                   EVAL      Pseq = *BLANKS
 
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
      *  Called by: SrAudit                                           *
      *                                                               *
      *  Calls    : ZSFILE                                            *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILEU
     C                   EVAL      PZSNum = SFNUMU
     C                   EVAL      Pseq = *BLANKS
 
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
     C     *ENTRY        PLIST
     C                   PARM                    PCompName        10
     C                   PARM                    PCompSeq          5 0
 
     C     KACRVEX       KLIST                                                              MD026766
     C                   KFLD                    ARCUST                                     MD026766
     C                   KFLD                    KKSCDT            6                        MD026766
     C                   KFLD                    KKSEQN            3                        MD026766
                                                                                            MD026766
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
