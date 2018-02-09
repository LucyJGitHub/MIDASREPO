     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Time Zone Report Program')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001105P -  Midas SD Time Zone Report Program               *
      *                                                               *
      *  Function:  This program list all Time Zone Code define in the*
      *             system. This will run in audit mode during COB to *
      *             report the change for the day.                    *
      *                                                               *
      *             It will also run in request to list all records,  *
      *             or for a specific year and/or for a specific time *
      *             zone in input cycle or close of business.         *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG20625           Date 12Aug08               *
      *                 BUG19930           Date 14Jul08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG20625 - Wrong time format                                 *
      *  BUG19930 - After typing "?" the selection screen of time     *
      *             zone did not appear.                              *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for SDTIZOL1                        *
      *    10         Toggle switch, use for Header 1                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRSelPrint    - Select Printing                               *
      * SRPrintAll    - Print All Records                             *
      * SRPrntRecA    - Print Record A                                *
      * SRPrntRecB    - Print Record B                                *
      * SRPriSpRec    - Print Record by Specific                      *
      * SRRecFilter   - Record filter                                 *
      * SRPopuVar     - Populate Variable for printing                *
      * SRHeader1     - Print Header 1                                *
      * SRAudit       - Write Audit Report                            *
      * SREnd         - Write Trailer in Report                       *
      * SRDSTDate     - Convertion of Dates to DDMMMYY or MMMDDYY     *
      * SRInitialise  - Initialise Variables
      * SRWrite2      - Writing of details from SDTZLVPD              *
      * SRInitialise  - Initialise Variables                          *
      * SRWrite       - Writing of details from SDTIZOPD              *
      * SRRecFilter2  - Record filter for SDTZLVPD                    *
      * SRPopuVar2    - Populate Variable from SDTZLVPD               *
      * *INZSR        - Initialise                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD DST Code Retrieval File
     FSDTIZOL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD DST Code Details
     FSD001105P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas SD DST Code Audit
     FSD001105AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas SD Time Zone Level Code Retrieve File
     FSDTZLVL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Time Zone Level Code keyed Time Zone/Year
     FSDTZLVL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTZLVD0:@TZLVL5)
 
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
     D SDTIZO        E DS                  EXTNAME(SDTIZOPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SD001105P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD001105AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PTZCD                  1     10A
     D  PYEAR                 11     14A
     D  PDSCD                 15     24A
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
     D All             C                   CONST('*ALL')
 
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
      *
      ** Parameter for 'AOBANKR0'
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenTabFld      S              3P 0
     D PLenScrFld      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')
     D PResult         S              3P 0
      *
 
      ** Other fields used
     D WOpen           S              1    INZ('N')
     D WRun            S              1A
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D NoDataMatch     S               N   INZ(*OFF)
      *
     D PDateIn         S              5P 0
     D PDateOut        S              7P 0
     D PADateOut       S              7A
      *
     D WTzCdYN         S              1A
     D WYearYN         S              1A
     D WDstCYN         S              1A
      *
     D
     D KTZCD           S             10A
     D KYEAR           S              4A
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
      ** Select the parameters the user entered.
      *
     C                   EXSR      SRInitialise
      *
     C                   EXSR      SRSelPrint
      *
     C                   EXSR      SREnd
      *
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
     C     SRInitialise  BEGSR
      *
     C                   CLEAR                   WTzCdYN
     C                   CLEAR                   WYearYN
     C                   CLEAR                   WDstCYN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSelPrint - Select Printing                                 *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : SRPrintAll, SRPrntRecA, SRPrntRecB, SRPriSpRec   *
      *                                                               *
      *****************************************************************
     C     SRSelPrint    BEGSR
      *
     C                   SELECT
      *
      ** No entry on selection
      *
     C                   WHEN      (%TRIM(PTZCD) = All
     C                             AND %TRIM(PDSCD) = All
     C                             AND PYEAR = All)
     C                   EXSR      SRPrintAll
      *
     C                   WHEN      (PTZCD = *BLANKS AND PDSCD = *BLANKS
     C                             AND PYEAR = All)
     C                             OR (%TRIM(PTZCD) = All AND PDSCD = *BLANKS
     C                             AND PYEAR = All)
     C                             OR (PTZCD = *BLANKS AND %TRIM(PDSCD) = All
     C                             AND PYEAR = All)
     C                   EXSR      SRPrintAll
      *
      ** Selection by Year
      *
     C                   WHEN      (PTZCD = *BLANKS AND PDSCD = *BLANKS
     C                             AND PYEAR <> *BLANKS AND PYEAR <> All)
     C                             OR (%TRIM(PTZCD) = All AND PDSCD = *BLANKS
     C                             AND PYEAR <> *BLANKS AND PYEAR <> All)
     C                             OR (%TRIM(PDSCD) = All AND PTZCD = *BLANKS
     C                             AND PYEAR <> *BLANKS AND PYEAR <> All)
     C                   EXSR      SRPrntRecB
      *
      ** Selection by DST Code
      *
     C                   WHEN      (PTZCD = *BLANKS AND PDSCD <> *BLANKS
     C                             AND PYEAR = All)
     C                             OR (%TRIM(PTZCD) = All AND PDSCD <> *BLANKS
     C                             AND %TRIM(PDSCD) <> All AND PYEAR = All)
     C                   EXSR      SRPrntRecB
      *
      ** Selection by Time Zone
      *
     C                   WHEN      (PTZCD <> *BLANKS AND PDSCD = *BLANKS
     C                             AND PYEAR = All)
     C                             OR (%TRIM(PDSCD) = All AND PTZCD <> *BLANKS
     C                             AND %TRIM(PTZCD) <> All AND PYEAR = All)
     C                   EXSR      SRPrntRecB
      *
      ** Selection by DST Code and Year
      *
     C                   WHEN      PTZCD = *BLANKS AND PDSCD <> *BLANKS
     C                             AND PYEAR <> All
     C                             OR (%TRIM(PTZCD) = All AND PDSCD <> *BLANKS
     C                             AND %TRIM(PDSCD) <> All AND PYEAR <> All)
     C                   EXSR      SRPrntRecA
      *
      ** Selection by Time Zone and Year
      *
     C                   WHEN      PTZCD <> *BLANKS AND PDSCD = *BLANKS
     C                             AND PYEAR <> All
     C                             OR (%TRIM(PDSCD) = All AND PTZCD <> *BLANKS
     C                             AND %TRIM(PTZCD) <> All AND PYEAR <> All)
     C                   EXSR      SRPrntRecA
      *
      ** Selection by Time Zone and DST Code
      *
     C                   WHEN      PTZCD <> *BLANKS AND PDSCD <> *BLANKS
     C                             AND PYEAR = All
     C                   EXSR      SRPrntRecA
      *
      ** Selection by Time Zone, DST Code and Year
      *
     C                   WHEN      PTZCD <> *BLANKS AND PDSCD <> *BLANKS
     C                             AND PYEAR <> All
     C                   EXSR      SRPriSpRec
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintAll - Print All Records                               *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite                      *
      *                                                               *
      *****************************************************************
     C     SRPrintAll    BEGSR
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EXSR      SRHeader1
      *
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRWrite
     C                   ENDDO
     C                   ENDIF
      *
     C     *LOVAL        SETLL     SDTZLVD0
     C                   READ      SDTZLVD0
     C                   DOW       NOT %EOF(SDTZLVL1)
     C                   EXSR      SRWrite2
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPriSpRec - Print record by Time Zone, DST Code and Year    *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite, SRRecFilter         *
      *                                                               *
      *****************************************************************
     C     SRPriSpRec    BEGSR
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
      *
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRRecFilter
     C                   IF        WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y' AND
     C                             WDstCYN = 'Y'
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRHeader1
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRWrite
     C                   EVAL      NoDataMatch = *ON
     C                   ELSE
     C                   READ      SDTIZOD0
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      *IN02 = *OFF
     C                   IF        NoDataMatch = *OFF
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   ENDIF
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *OFF
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRRecFilter
     C                   IF        WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y' AND
     C                             WDstCYN = 'Y'
     C     *LOVAL        SETLL     SDTZLVD0
     C                   READ      SDTZLVD0                               02
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRInitialise
     C                   DOW       NOT %EOF(SDTZLVL1)
     C                   EXSR      SRRecFilter2
     C                   IF        (WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y')
     C                   EXSR      SRWrite2
     C**********         ENDIF                                                              BUG20625
     C                   ELSE                                                               BUG20625
     C                   READ      SDTZLVD0
     C                   ENDIF                                                              BUG20625
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDTIZOD0
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrntRecA -  Print Record by Time Zone and Year or DST Code *
      *                and Year or Time Zone and DST Code             *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite, SRRecFilter         *
      *                                                               *
      *****************************************************************
     C     SRPrntRecA    BEGSR
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
      *
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRRecFilter
     C                   IF        (WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y') OR
     C                             (WTzCdYN = 'Y' AND
     C                             WDstCYN = 'Y') OR
     C                             (WYearYN ='Y') AND
     C                             (WDstCYN = 'Y')
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRHeader1
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRWrite
     C                   EVAL      NoDataMatch = *ON
     C                   ELSE
     C                   READ      SDTIZOD0
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      *IN02 = *OFF
     C                   IF        NoDataMatch = *OFF
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   ENDIF
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *OFF
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRRecFilter
     C                   IF        (WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y') OR
     C                             (WTzCdYN = 'Y' AND
     C                             WDstCYN = 'Y') OR
     C                             (WYearYN ='Y') AND
     C                             (WDstCYN = 'Y')
     C                   EVAL      PTZCD = TZTZCD
     C     *LOVAL        SETLL     SDTZLVD0
     C                   READ      SDTZLVD0                               02
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRInitialise
     C                   DOW       NOT %EOF(SDTZLVL1)
     C                   EXSR      SRRecFilter2
     C                   IF        (WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y') OR
     C                             (WTzCdYN = 'Y' AND
     C                             PYEAR = All)
     C                   EXSR      SRWrite2
     C**********         ENDIF                                                              BUG19930
     C                   ELSE                                                               BUG19930
     C                   READ      SDTZLVD0
     C                   ENDIF                                                              BUG19930
     C                   ENDDO
     C                   EVAL      TZTZCD = All
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDTIZOD0
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrntRecB -  Print Record by Time Zone or Year or DST Code. *
      *                                                               *
      *  Called by : SRSelPrint                                       *
      *                                                               *
      *  Calls     : SRAudit, SRHeader1, SRWrite, SRRecFilter         *
      *                                                               *
      *****************************************************************
     C     SRPrntRecB    BEGSR
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *ON
     C                   EXSR      SRAudit
     C                   ELSE
      *
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRRecFilter
     C                   IF        WTzCdYN = 'Y' OR
     C                             WYearYN = 'Y' OR
     C                             WDstCYN = 'Y'
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRHeader1
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRWrite
     C                   EVAL      NoDataMatch = *ON
     C                   ELSE
     C                   READ      SDTIZOD0
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      *IN02 = *OFF
     C                   IF        NoDataMatch = *OFF
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   ENDIF
      *
     C     *LOVAL        SETLL     SDTIZOD0
     C                   READ      SDTIZOD0                               02
     C                   IF        *IN02 = *OFF
     C                   DOW       NOT %EOF(SDTIZOL1)
     C                   EXSR      SRRecFilter
     C                   IF        WTzCdYN = 'Y' OR
     C                             WYearYN = 'Y' OR
     C                             WDstCYN = 'Y'
     C                   EVAL      PTZCD = TZTZCD
      *
     C     *LOVAL        SETLL     SDTZLVD0
     C                   READ      SDTZLVD0                               02
     C                   IF        *IN02 = *OFF
     C                   EXSR      SRInitialise
     C                   DOW       NOT %EOF(SDTZLVL1)
     C                   EXSR      SRRecFilter2
     C                   IF        (WTzCdYN = 'Y' AND
     C                             WYearYN = 'Y') OR
     C                             (WTzCdYN = 'Y' AND
     C                             PYEAR = All)
     C                   EXSR      SRWrite2
     C**********         ENDIF                                                              BUG19930
     C                   ELSE                                                               BUG19930
     C                   READ      SDTZLVD0
     C                   ENDIF                                                              BUG19930
     C                   ENDDO
     C                   EVAL      TZTZCD = All
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDTIZOD0
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write in Printer                                   *
      *                                                               *
      *  Called by : SRPrintAll, SRPrntRecA, SRPrntRecB, SRPriSpRec   *
      *                                                               *
      *  Calls     : SRPopuVar                                        *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
     C                   EXSR      SRPopuVar
     C                   WRITE     SD001105R1
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   EVAL      RqdLn1 = 12
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     SD001105R0
     C                   ENDIF
      *
     C                   READ      SDTIZOD0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite2 - Write in Printer for SDTZLVL1 Details             *
      *                                                               *
      *  Called by : SRPrintAll, SRPrntRecA, SRPrntRecB, SRPriSpRec   *
      *                                                               *
      *  Calls     : SRPopuVar2                                       *
      *                                                               *
      *****************************************************************
     C     SRWrite2      BEGSR
      *
     C                   EXSR      SRPopuVar2
     C                   WRITE     SD001105R3
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   EVAL      RqdLn1 = 12
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     SD001105R0
     C                   ENDIF
      *
     C                   READ      SDTZLVD0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuVar - Pupulating Variable                              *
      *                                                               *
      *  Called by : SRWrite                                          *
      *                                                               *
      *  Calls     : SRDSTDate                                        *
      *                                                               *
      *****************************************************************
     C     SRPopuVar     BEGSR
      *
      ** Time zone level code
      *
     C                   EVAL      RTZLC = 'Time Zone'
      *
     C                   EVAL      RTZCD = TZTZCD
     C                   EVAL      RTIBM = TZTIBM
     C                   EVAL      RYEAR = TZYEAR
     C                   EVAL      RSDSC = TZSDSC
     C                   EVAL      RDESC = TZDESC
     C**********         EVAL      RGMT = %CHAR(TZGMT)                                      BUG20625
     C                   MOVE      TZGMT         cTZGMT            4                        BUG20625
     C                   EVAL      RGMT = %Subst(cTZGMT:1:2) + ':'+                         BUG20625
     C                                    %Subst(cTZGMT:3:2)                                BUG20625
     C                   EVAL      RGMTS = TZGMTS
     C                   EVAL      RDSTF = TZDSTF
     C                   EVAL      RDSTC = TZDSTC
     C                   EVAL      RUSER = TZUSER
      *
      **  Last Change Date
      *
     C                   EVAL      PDateIn = TZLCD
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RLCD
      *
      **  Last Change Type
      *
     C                   SELECT
     C                   WHEN      TZLCHT = 'I'
     C                   EVAL      RLCHT= 'Insert'
     C                   WHEN      TZLCHT = 'A'
     C                   EVAL      RLCHT= 'Amend'
     C                   WHEN      TZLCHT = 'D'
     C                   EVAL      RLCHT= 'Delete'
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopuVar2 - Pupulating Variable from SDTZLVPD               *
      *                                                               *
      *  Called by :                                                  *
      *                                                               *
      *  Calls     : SRDSTDate                                        *
      *                                                               *
      *****************************************************************
     C     SRPopuVar2    BEGSR
      *
      ** Time zone level code
      *
     C                   SELECT
     C                   WHEN      TLTZLC = 'S'
     C                   EVAL      RTZLC2 = 'System Level'
     C                   WHEN      TLTZLC = 'B'
     C                   EVAL      RTZLC2 = 'Branch Level'
     C                   WHEN      TLTZLC = 'T'
     C                   EVAL      RTZLC2 = 'Time Zone'
     C                   ENDSL
      *
     C                   EVAL      RZONE2 = TLZONE
     C                   EVAL      RBRCA2 = TLBRCA
     C                   EVAL      RYEAR2 = TLYEAR
     C                   EVAL      RTZCD2 = TLTZCD
     C                   EVAL      RDESC2 = TLDESC
     C                   EVAL      RUSER2 = TLUSER
      *
      **  Last Change Date
      *
     C                   EVAL      PDateIn = TLLCD
     C                   EXSR      SRDSTDate
     C                   MOVEL     PADateOut     RLCD
      *
      **  Last Change Type
      *
     C                   SELECT
     C                   WHEN      TLCHTP = 'I'
     C                   EVAL      RLCHT= 'Insert'
     C                   WHEN      TLCHTP = 'A'
     C                   EVAL      RLCHT= 'Amend'
     C                   WHEN      TLCHTP = 'D'
     C                   EVAL      RLCHT= 'Delete'
     C                   ENDSL
     C
      *
      ** Retrieve the values in SDTIZOPD
      *
     C******LOVAL        SETLL     SDTIZOL1                                                 BUG19930
     C*****TLTZCD        CHAIN     SDTIZOL1                                                 BUG19930
     C**********         IF        %FOUND(SDTIZOL1)                                         BUG19930
     C                   EVAL      RSDSC2 = TZSDSC
     C                   EVAL      RTIBM2 = TZTIBM
     C**********         EVAL      RGMT2 = %CHAR(TZGMT)                                     BUG20625
     C                   MOVE      TZGMT         cTZGMT                                     BUG20625
     C                   EVAL      RGMT2 = %Subst(cTZGMT:1:2) + ':'+                        BUG20625
     C                                     %Subst(cTZGMT:3:2)                               BUG20625
     C                   EVAL      RGMTS2 = TZGMTS
     C                   EVAL      RDSTF2 = TZDSTF
     C                   EVAL      RDSTC2 = TZDSTC
     C**********         ENDIF                                                              BUG19930
     C
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
     C     SRDSTDate     BEGSR
     C
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut
     C                   PARM      *BLANKS       PADateOut
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader1 - Print Header 1                                   *
      *                                                               *
      *  Called by : SRPrintAll, SRPrntRecA, SRPrntRecB, SRPriSpRec   *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRHeader1     BEGSR
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD001105P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
 
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
     C                   WRITE     SD001105R0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write Trailer in Report                              *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
      *
     C                   EVAL      RqdLn1 = 12
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
      ** When overflow has occured, print the Header of the report.
      *
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     SD001105R0
     C                   ENDIF
     C                   WRITE     SD001105R2
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write Audit Report                                 *
      *                                                               *
      *  Called by : SRPrintAll, SRPrntRecA, SRPrntRecB, SRPriSpRec   *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
     C                   OPEN      SD001105AU
      *
      ** Ensure No Record Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
      *
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
     C                   WRITE     HEADAU
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecFilter - Filter records based selection criteria        *
      *                                                               *
      *  Called by: SRPrntRecA, SRPrntRecB, SRPriSpRec                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRRecFilter   BEGSR
      *
      ** Time Zone Code is not blanks
      *
     C                   IF        PTZCD <> *BLANKS
     C                             AND %TRIM(PTZCD) <> All
     C                   EVAL      PLenTabFld = %LEN(TZTZCD)
     C                   EVAL      PLenScrFld = %LEN(PTZCD)
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZTZCD
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    PTZCD
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If present and equal
      *
     C                   IF        PResult >= 1 AND PTZCD = TZTZCD
     C                   EVAL      WTzCdYN = 'Y'
     C                   ELSE
     C                   EVAL      WTzCdYN = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Year is not blanks
      *
     C                   IF        PYEAR <> All AND
     C                             PYEAR <> *BLANKS
     C                   EVAL      PLenTabFld = %LEN(%TRIM(TZYEAR))
     C                   EVAL      PLenScrFld = %LEN(%TRIM(PYEAR))
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZYEAR
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
     C                   IF        PResult >= 1 AND PYEAR = TZYEAR
     C                   EVAL      WYearYN = 'Y'
     C                   ELSE
     C                   EVAL      WYearYN = 'N'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   IF        PYEAR = *BLANKS AND
     C                             TZYEAR = *BLANKS
     C                   EVAL      WYearYN = 'Y'
     C                   ENDIF
      *
      ** Daylight Saving Time Code is not blanks
      *
     C                   IF        PDSCD   <> *BLANKS
     C                             AND %TRIM(PDSCD) <> All
     C                   EVAL      PLenTabFld = %LEN(%TRIM(TZDSTC))
     C                   EVAL      PLenScrFld = %LEN(%TRIM(PDSCD))
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZDSTC
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
     C                   IF        PResult >= 1 AND PDSCD = TZDSTC
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
      *  SRRecFilter2 - Filter records for SDTZLVPD                   *
      *                                                               *
      *  Called by: SRPrntRecA, SRPrntRecB, SRPriSpRec                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRRecFilter2  BEGSR
      *
      ** Time Zone Code is not blanks
      *
     C                   IF        PTZCD <> *BLANKS
     C                             AND %TRIM(PTZCD) <> All
     C                   EVAL      PLenTabFld = %LEN(TLTZCD)
     C                   EVAL      PLenScrFld = %LEN(PTZCD)
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TLTZCD
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    PTZCD
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If present and equal
      *
     C                   IF        PResult >= 1 AND PTZCD = TLTZCD
     C                   EVAL      WTzCdYN = 'Y'
     C                   ELSE
     C                   EVAL      WTzCdYN = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Year is not blanks
      *
     C                   IF        PYEAR <> All AND
     C                             PYEAR <> *BLANKS
     C                   EVAL      PLenTabFld = %LEN(%TRIM(TLYEAR))
     C                   EVAL      PLenScrFld = %LEN(%TRIM(PYEAR))
      *
      ** Scan database field with the search argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TLYEAR
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
     C                   IF        PResult >= 1 AND PYEAR = TLYEAR
     C                   EVAL      WYearYN = 'Y'
     C                   ELSE
     C                   EVAL      WYearYN = 'N'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   IF        PYEAR = *BLANKS AND
     C                             TLYEAR = *BLANKS
     C                   EVAL      WYearYN = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
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
     C     Key1          KLIST
     C                   KFLD                    KTZCD
     C                   KFLD                    KYEAR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
