     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS Normal Cust/NAHO Classfn Report')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000317 - CRS Normal Customer/NAHO Classification Rept      *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054604 - Deliverable Data Split for SDSVALPD               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000317P1                        *
      *    06  - Change of                                            *
      *    14  - End of File                                          *
      *    15  - Chain Fail on File                                   *
      *    50  - At least one set of details output - used for        *
      *          printer file conditioning                            *
      *    80  - Data Base Error Indicator                            *
      *                                                               *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *  SRHDRD - Prepare Header Data for Printing                    *
      *  SRINIT - Initial Processing                                  *
      *  SRCLOS - Printer File Closure                                *
      *  SRFCP  - File Control Processing                             *
      *  *PSSR  - Error Handling Subroutine                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
      ** CRS Customers for Classfn Update - List
     FSDCRNAL0  IF   E             DISK

      ** CRS Customers for Classfn Update - List
     FSDCRSHL0  UF   E           K DISK

      ** CRS Non-Account Holders for Classfn Update - List
     FSDCRNHL0  UF   E           K DISK

      ** CRS Normal FATCA Customer Classfn Report
     FSD000317P1O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL)

      ** CRS Normal FATCA Customer Classfn Report - Audit
     FSD000317AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*SDSVAL***     E DS                  EXTNAME(SDSVALPD)                                MD054605
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D Mode            S              7A
     D ReturnDS        DS
     D RetCode                        7A
     D ClsCode                        5A
     D ClsDesc                       50A
      *
     D DetMode         S              1A
     D DetRetCode      S              7A
     D DetClsCode      S              5A

     D PClsCode1       S              5A
     D PClsDesc1       S             50A
     D PClsCode2       S              5A
     D PClsDesc2       S             50A
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------


     D SPOOL           DS
      ** SPOOL Information Data Structure for ZSFILE
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

     D SPOOLU          DS
      ** SPOOL Information Data Structure for ZSFILE - AU Report
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D WCOMM           DS
     D  WCOM1                  1     64
     D  WCOM2                 65    128
     D  WCOM3                129    192
     D  WCOM4                193    256


     D WDTMST          DS
     D  WWMn                   1      2
     D  WWDy                   3      4
     D  WWYr                   5      6

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Recursive       S              1    INZ('N')
     D WCODE           S             10
     D WNARR           S              1
     D WRUN            S              1
     D WCALC           S              5  0
     D WCALCC          S              5  0
     D WCALCN          S              5  0
     D DRUND           S              5  0
     D WWTMST          S             26A
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WIntHr          S              1A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A
     D PAftFTCS        S           5000A
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUXC        S           5000A
     D PAftCUXC        S           5000A
     D PBefCRSH        S           5000A
     D PBefCRSH2       S           5000A
     D PAftCRSH        S           5000A
     D PBefCRSD        S           5000A
     D PAftCRSD        S           5000A
     D PACRV           S              1A
     D PELEC           S              1A
     D PCustN2         S              6A
     D CSD092          S              1A
     D PSard           S              6A

     ** ZSFILE Parameters
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D KCUST           S              6

     ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

     ** PLIST Parameters
     D PMODE           S              1

     D RTYPE           S              5

     ** AOCTRY Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
     D PCTRY           S              2

      * ZDATE1  parms
     D ZDATEA          S              6  0
     D ZDATFMT         S              1
     D ErrorFlag       S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial Processing
      *
     C                   EXSR      SRINIT
      *
      ** Main Processing
      *
     C                   EXSR      SRMAIN
      *
      ** Termination Processing
      *
     C                   EXSR      SRCLOS
      *
      ** End Program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E S                                         *
      *                                                               *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN   - Main Processing                                    *
      *            Controls Set-up of SD000317P1 Details              *
      *            Outputs SD000317P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR


     C                   EVAL      WIntHr = '1'

      ** Loop through the tool driver file

     C     1             SETLL     SDCRNAL0
     C                   READ      SDCRNAL0                               14

     C                   DOW       *IN14 <> *ON

      ** Record(s) found
      ** (or change spool CUST/NAHO switch)
      ** Driving file always have Customers, if any, before NAHOs

     C                   IF        *IN50 = *OFF
     C                   IF        NCCUST <> *BLANKS
     C                   EVAL      RTYPE = '*CUST'
     C                   EVAL      *IN41 = *OFF
     C                   ELSE
     C                   EVAL      RTYPE = '*NAHO'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF

     C                   OPEN      SD000317P1

     C                   EVAL      *IN50 = *ON

     C                   Z-ADD     SFNUM         ZSNUM
      *
      ** error during ZSFILE processing, return to calling program
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF
      *
      ** If overflow indicator fires up, write header format
      *
     C                   IF        WIntHr = '1'
     C                   WRITE     SD000317R0
     C                   ENDIF
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     SD000317R0
     C                   ENDIF

      ** prepare detail data for printing

     C                   EXSR      SRDETAIL

      ** if overflow indicator on, then set it off

     C                   IF        WIntHr = '1'
     C                   EVAL      WIntHr = '0'
     C                   ENDIF

      ** write detail record to SD000317P1

     C                   IF        PMODE = 'U'
     C                   EXSR      SRUPDB
     C                   ENDIF
     C                   WRITE     SD000317R1

      ** increment count of records output

     C                   ADD       1             WCALC
     C                   IF        RTYPE = '*CUST'
     C                   ADD       1             WCALCC
     C                   ELSEIF    RTYPE = '*NAHO'
     C                   ADD       1             WCALCN
     C                   ENDIF

     C                   READ      SDCRNAL0                               14

     C                   IF        RTYPE = '*CUST' and NCNAHO <> *BLANKS
     C                   EVAL      WIntHr = '1'
     C                   CLOSE     SD000317P1
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON

     C     MEND          ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETAIL - Prepare Details for Printing                       *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRDETAIL      BEGSR

      * Set Report Details

     C                   SELECT
     C                   WHEN      RTYPE = '*CUST'
     C                   EVAL      XRREFR = NCCUST
     C                   WHEN      RTYPE = '*NAHO'
     C                   EVAL      XRREFR = NCNAHO
     C                   ENDSL

     C                   EVAL      XRRPNM = NCRPNM
     C                   EVAL      XRRPTN = NCRPTN
     C                   EVAL      XRHVAC = NCHVAC
     C                   EVAL      XRINFC = NCINFC
      *
     C                   SELECT
     C                   WHEN      NCHVAC = 'L'
     C                   EVAL      XRHVAC = 'Low'
     C                   WHEN      NCHVAC = 'M'
     C                   EVAL      XRHVAC = 'Medium'
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDB   - Update Main Database Files                         *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRUPDB        BEGSR

     C                   SELECT

      ** Update Customers
     C                   WHEN      RTYPE = '*CUST'

     C     NCCUST        CHAIN     SDCRSHD0
     C                   IF        %FOUND = '1'
     C                   EVAL      PBefCRSH = SDCRSH

      ** Check if CRS Info Complete Flag is changed
     C                   IF        CRINFO <> NCINFC
     C                   EVAL      CRINFO = NCINFC
     C                   ENDIF
     C                   EVAL      PAftCRSH = SDCRSH

     C                   UPDATE    SDCRSHD0

      ** Write to the History of Customer Information
     C                   IF        CSD092 = 'Y'
     C                             AND PBefCRSH <> PAftCRSH

     C                   CALL      'SD009696'
     C                   PARM      CRCUST        PCustN2
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      *BLANKS       PBefFTCS
     C                   PARM      *BLANKS       PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUXC
     C                   PARM      *BLANKS       PAftCUXC
     C                   PARM      *BLANKS       PACRV
     C                   PARM      *BLANKS       PELEC
     C                   PARM                    PBefCRSH
     C                   PARM                    PAftCRSH
     C                   PARM      *BLANKS       PBefCRSD
     C                   PARM      *BLANKS       PAftCRSD
     C                   ENDIF

     C                   ENDIF

      ** Update Non-Account Holders
     C                   WHEN      RTYPE = '*NAHO'

     C     NCNAHO        CHAIN     SDCRNHL0
     C                   IF        %FOUND = '1'

      ** Check if CRS Info Complete Flag is changed
     C                   IF        NRINFO <> NCINFC
     C                   EVAL      NRINFO = NCINFC
     C                   ENDIF

     C                   UPDATE    SDCRNHD0
     C                   ENDIF

     C                   ENDSL

     C     SRUPDBE       ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE1 - Validate & convert date to a day number            *
      *                                                               *
      *****************************************************************
     C     SRDATE1       BEGSR

     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    ZDATEA
     C                   PARM                    ZDATFMT
     C                   PARM                    ZDAYNO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE2  - Convert Date to Printer Date                       *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
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
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT   - Initial processing                                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMODE

     C                   IF        PMODE = 'U'
     C                   EVAL      *IN40 = *ON
     C                   ELSE
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF

      ** access installation control data
      ** access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** if access program fails call SR. *PSSR

     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** if fails goto END

     C                   IF        *IN80 = *ON
     C                   GOTO      IEND
     C                   ENDIF

      ** Check whether CSD092 is available
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD092'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtcd <> *Blanks
     C                   IF        PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = PSard
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'SD000317'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CSD092 = 'N'
     C                   ELSE
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF

      ** load printer file fields with date and title

     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      XRTITL = BJURPT
     C                   EVAL      XRRUNA = BJMRDT
     C                   EVAL      DRUND  = BJRDNB

      ** set number of records read to Zero

     C                   Z-ADD     0             WCALC
     C                   Z-ADD     0             WCALCC
     C                   Z-ADD     0             WCALCN

     C     IEND          ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOS   - Printer File Closure                               *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRFCP - File Control Processing                    *
      *                                                               *
      *****************************************************************
     C     SRCLOS        BEGSR

      ** call ZSFILE for audit report

     C                   Z-ADD     SFNUMU        ZSNUM

      ** if error code = 'Y', then terminare the program

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** if database error has occured, output total report headings;
      ** print error message and exit program.

     C                   IF        *IN80 = *ON
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
     C                   GOTO      TEND
     C                   ENDIF

      ** produce standard totals report

     C                   EXSR      SRFCP

      ** if a database error has occured, bypass further processing

     C     *INU7         CABEQ     *ON           TEND

      ** prints 'END OF REPORT' if *IN50 ON.

     C                   IF        *IN50 = *ON
     C                   WRITE     SD000317R3
     C                   ENDIF

     C     TEND          ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * SRFCP    - Produces Standard Totals Report                    *
      *                                                               *
      * Called by: SRCLOS - Termination Processing                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRFCP         BEGSR

      ** set-up calculated number of records fields

     C                   Z-ADD     WCALC         RRCALC
     C                   Z-ADD     WCALCC        RRCALCC
     C                   Z-ADD     WCALCN        RRCALCN

      ** print standard totals report

     C                   WRITE     CONTROL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
