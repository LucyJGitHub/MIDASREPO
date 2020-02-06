     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD DST Code Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001106P -  Midas SD Daylight Saving Time Code Report       *
      *                                                               *
      *  Function:  This program list all DST Code define in the      *
      *             system. This will run in audit mode during COB to *
      *             report the change for the day.                    *
      *                                                               *
      *             It will also run in request to list all records,  *
      *             or for a specific year and/or for a specific DST  *
      *             in input cycle or close of business.              *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG20967           Date 03Sep08               *
      *                 BUG20609           Date 11Aug08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG20967 - Start and End Rule in DST Report.                 *
      *  BUG20609 - start time & end time format in SD001106 report   *
      *              is incorrect.                                    *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for SDDSTCD0                        *
      *    10         Toggle switch, use for Header 1                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRSelPrint    - Select Printing                               *
      * SRPrintAll    - Print All Records                             *
      * SRPrintRec    - Print Record by Year or by DST                *
      * SRPriSpRec    - Print Record by Specific                      *
      * SRPopuVar     - Populate Variable for printing                *
      * SRRecFilter   - Filter records based selection criteria       *
      * SRWrite       - Write Details                                 *
      * SRHeader1     - Print Header 1                                *
      * SRAudit       - Write Audit Report                            *
      * SREnd         - Write Trailer in Report                       *
      * SRDSTRule     - Concatenation of the Rules                    *
      * SRDSTDate     - Convertion of Dates to DDMMMYY or MMMDDYY     *
      * *INZSR        - Initialise                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD DST Code Retrieval File
     FSDDSTCL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD DST Code Details
     FSD001106P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas SD DST Code Audit
     FSD001106AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
     D SDDSTC        E DS                  EXTNAME(SDDSTCPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SD001106P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD001106AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PYEAR                  1      4A
     D  PDSCD                  5     14A
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameter list fields
     D PLevel          S              1
     D PCmd            S              1
     D PEnty           S              3
 
      ** Parameter for 'AOBANKR0'
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenTabFld      S              3P 0
     D PLenScrFld      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')
     D PResult         S              3P 0
 
      ** Other fields used
     D WOpen           S              1    INZ('N')
     D DSTWK           S              1  0
     D DSTDY           S              2  0
     D DSTMO           S              2  0
     D WeekNm          S              6A
     D DayNam          S              3A
     D MonNam          S              3A
     D DSTRUL          S             20A
     D WRun            S              1A
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D NoDataMatch     S               N   INZ(*OFF)
     D All             C                   CONST('*ALL')
      *
     D PDateIn         S              5P 0
     D PDateOut        S              7P 0
     D PADateOut       S              7A
      *
     D WYearYN         S              1A
     D WDstCYN         S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Set file pointer to first record and do initial read.
      *
     C                   EXSR      SRSelPrint
      *
     C                   EXSR      SREnd
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitialise - Initizialise Variables                        *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRInitialise  BEGSR
      *
     C                   CLEAR                   WYearYN
     C                   CLEAR                   WDstCYN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSelPrint - Select Printing                                 *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : SRPrintAll, SRPrintRec, SRPriSpRec               *
      *                                                               *
      *****************************************************************
      *
     C     SRSelPrint    BEGSR
      *
     C                   SELECT
      *
      ** No entry on selection
      *
     C                   WHEN      (PDSCD = *BLANKS AND PYEAR = *BLANKS) OR
     C                             (%TRIM(PDSCD) = All AND PYEAR = *BLANKS)
     C                   EXSR      SRPrintAll
      *
     C                   WHEN      (PDSCD = *BLANKS AND PYEAR = All) OR
     C                             (%TRIM(PDSCD) = All AND PYEAR = All)
     C                   EXSR      SRPrintAll
      *
      ** Selection by Year
      *
     C                   WHEN      (PDSCD = *BLANKS AND PYEAR <> *BLANKS
     C                             AND PYEAR <> All) OR
     C                             (%TRIM(PDSCD) = All AND PYEAR <> *BLANKS
     C                             AND PYEAR <> All)
     C                   EXSR      SRPrintRec
      *
     C                   WHEN      %TRIM(PDSCD) = All AND PYEAR = *BLANKS
     C                   EXSR      SRPrintRec
      *
      ** Selection by DST Code
      *
     C                   WHEN      PDSCD <> *BLANKS AND PYEAR <> All
     C                   EXSR      SRPriSpRec
      *
     C                   WHEN      PDSCD <> *BLANKS AND PYEAR = All
     C                   EXSR      SRPrintREc
      *
     C                   EndSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintAll - Print All Record                                *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite                      *
      *                                                               *
      *****************************************************************
      *
     C     SRPrintAll    BEGSR
      *
     C     *LOVAL        SETLL     SDDSTCD0
     C                   READ      SDDSTCD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EXSR      SRHeader1
      *
     C                   DOW       NOT %EOF(SDDSTCL1)
     C                   EXSR      SRWrite
     C                   ENDDO
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPriSpRec - Print record by DST Code and Year               *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite                      *
      *                                                               *
      *****************************************************************
      *
     C     SRPriSpRec    BEGSR
      *
     C     *LOVAL        SETLL     SDDSTCD0
     C                   READ      SDDSTCD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
      *
     C                   DOW       NOT %EOF(SDDSTCL1)
     C                   IF        PYEAR = DSYEAR AND PDSCD = DSDSCD
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRHeader1
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRWrite
     C                   EVAL      NoDataMatch = *ON
     C                   ELSE
     C                   READ      SDDSTCD0
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      *IN02 = *OFF
     C                   IF        NoDataMatch = *OFF
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintRec - Print Record by Year or by DST Code             *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite, SRRecFilter         *
      *                                                               *
      *****************************************************************
      *
     C     SRPrintRec    BEGSR
      *
     C     *LOVAL        SETLL     SDDSTCD0
     C                   READ      SDDSTCD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
      *
     C                   DOW       NOT %EOF(SDDSTCL1)
     C                   EXSR      SRRecFilter
     C                   IF        WYearYN = 'Y' OR
     C                             WDstCYN = 'Y'
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRHeader1
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRWrite
     C                   EVAL      NoDataMatch = *ON
     C                   ELSE
     C                   READ      SDDSTCD0
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      *IN02 = *OFF
     C                   IF        NoDataMatch = *OFF
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecFilter - Filter records based selection criteria        *
      *                                                               *
      *  Called by : SRPrintRec                                       *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     SRRecFilter   BEGSR
      *
      ** Year is not blanks
      *
     C                   IF        PYEAR <> All
     C                   EVAL      PLenTabFld = %LEN(DSYEAR)
     C                   EVAL      PLenScrFld = %LEN(PYEAR)
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    DSYEAR
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    PYEAR
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If present and equal
      *
     C                   IF        PResult >= 1 OR PYEAR = DSYEAR
     C                   EVAL      WYearYN = 'Y'
     C                   ELSE
     C                   EVAL      WYearYN = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Daylight Saving Time Code is not blanks
      *
     C                   IF        PDSCD <> *BLANKS AND %TRIM(PDSCD) <> All
     C                   EVAL      PLenTabFld = %LEN(DSDSCD)
     C                   EVAL      PLenScrFld = %LEN(PDSCD)
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    DSDSCD
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    PDSCD
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If present and equal
      *
     C                   IF        PResult >= 1 OR PDSCD = DSDSCD
     C                   EVAL      WDstCYN = 'Y'
     C                   ELSE
     C                   EVAL      WDstCYN = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuVar - Populating Variable                              *
      *                                                               *
      *  Called by : SRWrite                                          *
      *                                                               *
      *  Calls     : SRDSTDate, SRDSTRule                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPopuVar     BEGSR
      *
      ** Start Rule
      *
     C                   EVAL      DSTWK = DSDSTW
     C                   EVAL      DSTDY = DSDSTD
     C                   EVAL      DSTMO = DSDSTM
     C                   EXSR      SRDSTRule
     C                   EVAL      RSRULE = DSTRUL
      *
      ** End Rule
      *
     C                   EVAL      DSTWK = DSDENW
     C                   EVAL      DSTDY = DSDEND
     C                   EVAL      DSTMO = DSDENM
     C                   EXSR      SRDSTRule
     C                   EVAL      RERULE = DSTRUL
      *
      ** Start Date
      *
     C                   EVAL      PDateIn = DSDSDT
     C                   EXSR      SRDSTDate
     C                   Move      PADateOut     RDSDT
      *
      ** End Date
      *
     C                   EVAL      PDateIn = DSDSED
     C                   EXSR      SRDSTDate
     C                   Move      PADateOut     RDSED
      *
     C                   EVAL      RDSCD = DSDSCD
     C                   EVAL      RYEAR = DSYEAR
     C                   EVAL      RDESC = DSDESC
     C                   EVAL      ROFFS = %CHAR(DSOFFS)
     C**********         EVAL      RDSDH = %CHAR(DSDSDH)                                    BUG20609
     C**********         EVAL      RDENH = %CHAR(DSDENH)                                    BUG20609
     C                   MOVE      DSDSDH        cStartTime        6                        BUG20609
     C                   MOVE      DSDENH        cEndTime          6                        BUG20609
     C                   EVAL      RDSDH = %Subst(cStartTime:1:2) + ':'+                    BUG20609
     C                                     %Subst(cStartTime:3:2) + ':'+                    BUG20609
     C                                     %Subst(cStartTime:5:2)                           BUG20609
     C                   EVAL      RDENH = %Subst(cEndTime:1:2) + ':'+                      BUG20609
     C                                     %Subst(cEndTime:3:2) + ':'+                      BUG20609
     C                                     %Subst(cEndTime:5:2)                             BUG20609
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSTRule - DST Start Rule and End Rule                      *
      *                                                               *
      *  Called by : SRPopuVar                                        *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDSTRule     BEGSR
     C                   CLEAR                   WeekNm
     C                   CLEAR                   DayNam
     C                   CLEAR                   MonNam
     C                   CLEAR                   DSTRUL
     C
     C                   SELECT
     C                   WHEN      DSTWK = 1
     C                   EVAL      WeekNm = 'First'
     C                   WHEN      DSTWK = 2
     C                   EVAL      WeekNm = 'Second'
     C                   WHEN      DSTWK = 3
     C                   EVAL      WeekNm = 'Third'
     C                   WHEN      DSTWK = 4
     C                   EVAL      WeekNm = 'Fourth'
     C                   WHEN      DSTWK = 9
     C                   EVAL      WeekNm = 'Last'
     C                   ENDSL
      *
     C                   SELECT
     C                   WHEN      DSTDY = 1
     C                   EVAL      DayNam = 'Mon'
     C                   WHEN      DSTDY = 2
     C                   EVAL      DayNam = 'Tue'
     C                   WHEN      DSTDY = 3
     C                   EVAL      DayNam = 'Wed'
     C                   WHEN      DSTDY = 4
     C                   EVAL      DayNam = 'Thu'
     C                   WHEN      DSTDY = 5
     C                   EVAL      DayNam = 'Fri'
     C                   WHEN      DSTDY = 6
     C                   EVAL      DayNam = 'Sat'
     C                   WHEN      DSTDY = 7
     C                   EVAL      DayNam = 'Sun'
     C                   ENDSL
      *
     C                   SELECT
     C                   WHEN      DSTMO = 1
     C                   EVAL      MonNam = 'Jan'
     C                   WHEN      DSTMO = 2
     C                   EVAL      MonNam = 'Feb'
     C                   WHEN      DSTMO = 3
     C                   EVAL      MonNam = 'Mar'
     C                   WHEN      DSTMO = 4
     C                   EVAL      MonNam = 'Apr'
     C                   WHEN      DSTMO = 5
     C                   EVAL      MonNam = 'May'
     C                   WHEN      DSTMO = 6
     C                   EVAL      MonNam = 'Jun'
     C                   WHEN      DSTMO = 7
     C                   EVAL      MonNam = 'Jul'
     C                   WHEN      DSTMO = 8
     C                   EVAL      MonNam = 'Aug'
     C                   WHEN      DSTMO = 9
     C                   EVAL      MonNam = 'Sep'
     C                   WHEN      DSTMO = 10
     C                   EVAL      MonNam = 'Oct'
     C                   WHEN      DSTMO = 11
     C                   EVAL      MonNam = 'Nov'
     C                   WHEN      DSTMO = 12
     C                   EVAL      MonNam = 'Dec'
     C                   ENDSL
     C                   IF        DSTWK = 0 Or DSTDY = 0 Or DSTMO = 0                      BUG20967
     C                   EVAL      DSTRUL = *Blanks                                         BUG20967
     C                   ELSE                                                               BUG20967
     C                   EVAL      DSTRUL = %TRIM(WeekNm) +  ' '
     C                             + DayNam + ' ' + 'of' + ' ' + MonNam
     C                   ENDIF                                                              BUG20967
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDSTDate - DST Start Date and End Date                      *
      *                                                               *
      *  Called by : SRPopuVar                                        *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDSTDate     BEGSR
     C
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut
     C                   PARM      *BLANKS       PADateOut
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader1 - Print Header 1                                   *
      *                                                               *
      *  Called by : SRPrintAll, SRPrintRec, SRPriSpRec               *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRHeader1     BEGSR
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD001106P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Print the Header of the report.
      *
     C                   WRITE     SD001106R0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write in Printer                                   *
      *                                                               *
      *  Called by : SRPrintAll, SRPrintRec, SRPriSpRec               *
      *                                                               *
      *  Calls     : SRPopuVar                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
     C                   EXSR      SRPopuVar
     C                   WRITE     SD001106R1
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   EVAL      RqdLn1 = 10
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     SD001106R0
     C                   ENDIF
      *
     C                   READ      SDDSTCD0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write Trailer in Report                              *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
      *
     C     SREnd         BEGSR
      *
     C                   EVAL      RqdLn1 = 6
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     SD001106R0
     C                   ENDIF
     C                   WRITE     SD001106R2
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write Audit Report                                 *
      *                                                               *
      *  Called by : SRPrintAll, SRPrintRec, SRPriSpRec               *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
     C                   OPEN      SD001106AU
      *
      ** Ensure No Record Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANKS       ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   Write     HEADAU
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PData
      *
      ** Call The Access Object - AOBANKR0
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
