     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Normal Cust/NAHO Classfn Upd and Report')     *
      *****************************************************************
      *  Includes MD025734, MD024817, MD024711                        *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000553 - Normal Customer/NAHO Classification Upd and Rept  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CGL177             Date 11Jan16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD027334A          Date 23Sep14               *
      *                 MD027209B          Date 26Sep14               *
      *                 MD027209           Date 07Aug14               *
      *                 MD027033           Date 29May14               *
      *                 MD026854           Date 29May14               *
      *                 CGL132   *CREATE   Date 01Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027334A- Validation on Mandatory Class Code removed        *
      *  MD027209B - F4-Print Report is not available in USIT and NCUP*
      *  MD027209 - F4-Print Report is not available in USIT and NCUP *
      *  MD027033 - NCUP Tool does not set FATCA Information Complete *
      *             Flag to A even if validations                     *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000553P1                        *
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
      ** FATCA Customers for Classfn Update - List
     FSDNACUL0  IF   E             DISK
 
      ** FATCA Customers for Classfn Update - List
     FSDFTCSL5  UF   E           K DISK
 
      ** FATCA Non-Account Holders for Classfn Update - List
     FSDFTNHL5  UF   E           K DISK
 
      ** FATCA Normal FATCA Customer Classfn Report
     FSD000553P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
 
      ** FATCA Normal FATCA Customer Classfn Report - Audit
     FSD000553AUO    E             PRINTER INFSR(*PSSR)
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
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
     D SDNACU        E DS                  EXTNAME(SDNACUPD)
     D SDFTCS_B      E DS                  EXTNAME(SDFTCSPD)
     D                                     PREFIX(X)
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
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
      **--------------------------------------------------------------------------------------------
 
 
     D SPOOL           DS
      ** SPOOL Information Data Structure for ZSFILE
 
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
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
     D PBefCRSH        S           5000A                                                      CGL177
     D PAftCRSH        S           5000A                                                      CGL177
     D PBefCRSD        S           5000A                                                      CGL177
     D PAftCRSD        S           5000A                                                      CGL177
 
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
      *            Controls Set-up of SD000553P1 Details              *
      *            Outputs SD000553P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
 
 
     C                   EVAL      *IN05 = *ON
 
      ** Loop through the tool driver file
 
     C     1             SETLL     SDNACUL0
     C                   READ      SDNACUL0                               14
 
     C                   DOW       *IN14 <> *ON
 
      ** Record(s) found
      ** (or change spool CUST/NAHO switch)
      ** Driving file always have Customers, if any, before NAHOs
 
     C**********         IF        PMODE = 'P'                                    MD027209 MD027209B
     C                   IF        *IN50 = *OFF
     C                   IF        NCCUST <> *BLANKS
     C                   EVAL      RTYPE = '*CUST'
     C                   EVAL      *IN41 = *OFF
     C                   ELSE
     C                   EVAL      RTYPE = '*NAHO'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
     C                   OPEN      SD000553P1
 
     C                   EVAL      *IN50 = *ON
 
     C                   Z-ADD     SFNUM         ZSNUM
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSEQ
     C*                  PARM      *BLANKS       PENTY
     C*                  PARM                    SFILE
     C*                  PARM                    ZSNUM
     C*                  PARM                    ZSERR
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
     C                   IF        *IN05 = *ON
     C                   WRITE     SD000553R0
     C                   ENDIF
 
      ** prepare detail data for printing
 
     C                   EXSR      SRDETAIL
 
      ** if overflow indicator on, then set it off
 
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
      ** write detail record to SD000553P1
 
     C**********         IF        PMODE = 'U'                                              MD027209
     C**********         EXSR      SRUPDB                                                   MD027209
     C**********         ENDIF                                                              MD027209
     C                   WRITE     SD000553R1
 
      ** increment count of records output
 
     C                   ADD       1             WCALC
     C                   IF        RTYPE = '*CUST'
     C                   ADD       1             WCALCC
     C                   ELSEIF    RTYPE = '*NAHO'
     C                   ADD       1             WCALCN
     C                   ENDIF
                                                                                            MD027209
     C**********         ENDIF                                                    MD027209 MD027209B
                                                                                            MD027209
     C                   IF        PMODE = 'U'                                              MD027209
     C                   EXSR      SRUPDB                                                   MD027209
     C                   ENDIF                                                              MD027209
 
     C                   READ      SDNACUL0                               14
 
     C                   IF        PMODE = 'P'                                              MD027209
     C                   IF        RTYPE = '*CUST' and NCNAHO <> *BLANKS
     C                   EVAL      *IN05 = *ON
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000553P1
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF
     C                   ENDIF                                                              MD027209
 
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
     C                   EVAL      XRCCLS = NCCCLS
     C                   EVAL      XRCCLD = NCCCLD
     C                   EVAL      XRNCLS = NCNCLS
     C                   EVAL      XRNCLD = NCNCLD
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
 
     C                   IF        NCCUST <> *BLANKS                                        MD027209
     C                   EVAL      RTYPE = '*CUST'                                          MD027209
     C                   ELSE                                                               MD027209
     C                   EVAL      RTYPE = '*NAHO'                                          MD027209
     C                   ENDIF                                                              MD027209
                                                                                            MD027209
     C                   SELECT
     C                   WHEN      RTYPE = '*CUST'
     C     NCCUST        CHAIN     SDFTCSD0
     C                   IF        %FOUND = '1'
      ** Capture SDFTCS before-image
     C                   EVAL      SDFTCS_B = SDFTCS
      ** Set details as per tool update results
     C**********         EVAL      FAPCLA = FACLAC                                         MD027334A
     C**********         EVAL      FACLAC = XRNCLS                                         MD027334A
     C                   EVAL      FAPCLA = NCCCLS                                         MD027334A
     C                   EVAL      FACLAC = NCNCLS                                         MD027334A
     C                   EVAL      FACLAD = DRUND
     C                   EVAL      FALCTP = 'A'
     C                   EVAL      FALUSR = PSUser
     C**********         EVAL      FAINFC = XRINFC                                MD027033 MD027334A
     C                   EVAL      FAINFC = NCINFC                                         MD027334A
     C                   EVAL      FATMST = %char(%timestamp())
     C                   UPDATE    SDFTCSD0
 
      ** Log changes in History of Customer Information
     C**********         CALL      'SDC009696'                                              MD026854
     C                   CALL      'SD009696'
     C                   PARM      FACUST        PCustNo           6
     C                   PARM      *BLANKS       PBefCUST       5000
     C                   PARM      *BLANKS       PAftCUST       5000
     C                   PARM      *BLANKS       PBefACUS       5000
     C                   PARM      *BLANKS       PAftACUS       5000
     C                   PARM      SDFTCS_B      PBefFTCS       5000
     C                   PARM      SDFTCS        PAftFTCS       5000
     C                   PARM      *BLANKS       PBefJACC       5000
     C                   PARM      *BLANKS       PAftJACC       5000
     C                   PARM      *BLANKS       PBefCUAH       5000                        MD026854
     C                   PARM      *BLANKS       PAftCUAH       5000                        MD026854
     C                   PARM      *BLANKS       PBefCUXC       5000                        MD026854
     C                   PARM      *BLANKS       PAftCUXC       5000                        MD026854
     C                   PARM      *BLANKS       PACRV             1
     C                   PARM      *BLANKS       PELEC             1
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF
 
     C                   WHEN      RTYPE = '*NAHO'
     C     NCNAHO        CHAIN     SDFTNHL5
     C                   IF        %FOUND = '1'
     C**********         EVAL      FNPCLA = FNCLAC                                         MD027334A
     C**********         EVAL      FNCLAC = XRNCLS                                         MD027334A
     C                   EVAL      FNPCLA = NCCCLS                                         MD027334A
     C                   EVAL      FNCLAC = NCNCLS                                         MD027334A
     C                   EVAL      FNCLAD = DRUND
     C                   EVAL      FNLCTP = 'A'
     C                   EVAL      FNLUSR = PSUser
     C**********         EVAL      FNINFC = XRINFC                                MD027033 MD027334A
     C                   EVAL      FNINFC = NCINFC                                         MD027334A
     C                   EVAL      FNTMST = %char(%timestamp())
     C                   UPDATE    SDFTNHD0
     C                   ENDIF
     C                   ENDSL
 
     C     SRUPDBE       ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHDRD   - Prepare Header Data for Printing                   *
      *                                                               *
      * Called by: SRMAIN - Main Processing                           *
      *                                                               *
      * Calls    : *PSSR  - Error handling subroutine                 *
      *                                                               *
      *****************************************************************
     C     SRHDRD        BEGSR
 
     C     HEND          ENDSR
      *****************************************************************
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
 
     C*                  OPEN      SDFTCSL5
     C*                  OPEN      SDFTNHL5
 
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
 
      ** load printer file fields with date and title
 
     C                   EVAL      RRTITL = BJURPT
     C                   EVAL      RRRUNA = BJMRDT
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
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSEQ
     C*                  PARM      *BLANK        PENTY
     C*                  PARM                    SFILEU
     C*                  PARM                    ZSNUM
     C*                  PARM                    ZSERR
 
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
     C                   WRITE     SD000553R3
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
