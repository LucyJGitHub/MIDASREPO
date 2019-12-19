     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Exceptions by CUST/NAHO Report')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000554 - FATCA Exceptions by Customers/NAHOs Report        *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042897           Date 29Nov16               *
      *                 MD039670           Date 26Jul16               *
      *                 MD039196           Date 21Jul16               *
      *                 MD025220           Date 03Feb14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042897 - Customer/Non-Account Holders with FATCA Exceptions*
      *             are not reported in FATCA Exceptions IC Report    *
      *  MD039670 - FATCA Housekeeping program                        *
      *  MD039196 - FATCA/CRS Exceptions Report Cosmetic Issues       *
      *  MD025220 - SD000554P1 and SD000554AU input cycle reports has *
      *             no information if 9 or more exceptions selected   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator SD000554P1                        *
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
      ** FATCA Customers with Exceptions - List
     FSDFTCSL6  IF   E           K DISK

      ** FATCA Non-Account Holders with Exceptions - List
     F***SDFTNHL6  IF   E             DISK                                                  MD039670
     FSDFTNHL6  IF   E           K DISK                                                     MD039670
                                                                                              CGL177
      ** CRS Customers with Exceptions - List                                                 CGL177
     FSDCRSHL2  IF   E           K DISK                                                       CGL177
                                                                                              CGL177
      ** CRS Non-Account Holders with Exceptions - List                                       CGL177
     FSDCRNHL2  IF   E           K DISK                                                       CGL177

      ** Non - Account Holder Details
     FSDNAHOL0  IF   E           K DISK

      ** Customer Details
     FSDCUSTL0  IF   E           K DISK

      ** FATCA Exception Messages File
     FSDEXMAL0  IF   E           K DISK

      ** FATCA Exceptions by Customers/Non-Account Holders Report
     FSD000554P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)

      ** FATCA Exceptions by Customers/Non-Account Holders Audit
     FSD000554AUO    E             PRINTER INFSR(*PSSR)
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
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                MD039670

     DPSDS            SDS

      ** Procedure name
     D PSProcName        *PROC

      ** Job name
     D PSJobName             244    253

      ** User name
     D PSUser                254    263

      ** Input DS
     D POutFlds        DS           100
     D  PExceptions            1     30A

      *
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

     DExcpts           S              1A   DIM(30)
     DSelEx            S              1A   DIM(30)
     D*MsgLines         S             64A   DIM(4)                                            CGL177
     DMsgLines         S             64A   DIM(5)                                             CGL177
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D*WMatch***       S              1  0                                                    CGL177
     D WMatch          S              2  0                                                    CGL177
     D*WIdx*****       S              1  0                                                  MD025220
     D*WIdx2****       S              1  0                                                  MD025220
     D WIdx            S              2  0                                                  MD025220
     D WIdx2           S              2  0                                                  MD025220
     D WExIDs          S             30A   INZ(*Blanks)
     D PRetCode        S              7A
     D POption         S              7A
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A
     D Mode            S              7A
     D Recursive       S              1    INZ('N')
     D WCODE           S             10
     D WNARR           S              1
     D WRUN            S              1
     D WCALC           S              5  0
     D WCALCC          S              5  0
     D WCALCN          S              5  0
     D DRUND           S              5  0
     D WWTMST          S             26A
     D WxEXID          S             30A                                                      CGL177
     D WcEXID          S             30A                                                      CGL177
     D WcheckH         S              5  0                                                    CGL177
     D WcheckI         S              5  0                                                    CGL177
     D WcheckCH        S              5  0                                                    CGL177
     D WcheckCI        S              5  0                                                    CGL177
     D WxCUST          S              6A                                                      CGL177

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

      * ZDATE1  parms
     D ZDATEA          S              6  0
     D ZDATFMT         S              1
     D ErrorFlag       S              1

     D PRTCD           S              7                                                     MD039670
     D POPTN           S              7                                                     MD039670
     D PKEY1           S             10                                                     MD039670
     D WxNAHO          S             10A                                                    MD039670
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
      ** Generate Report
      *
     C                   EXSR      SRREPT
      *
      ** Audit Report
      *
     C                   EXSR      SRFCP
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
      * SRREPT   - Report Processing                                  *
      *            Controls Set-up of SD000554P1 Details              *
      *            Outputs SD000554P1 Details                         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls    : SRHDRD - Prepare Header Data for Printing          *
      *                                                               *
      *****************************************************************
     C     SRREPT        BEGSR

     C                   EVAL      *IN05 = *ON
      *
      ** Loop through all customers with exceptions
      *
     C                   EVAL      RTYPE = '*CUST'
     C*    *LOVAL        SETLL     SDFTCSL6
     C**********         READ      SDFTCSD0                               14                  CGL177
     C                   READ      SDCUSTL0                               14                  CGL177
     C                   DOW       *IN14 <> *ON
     C                   EVAL      WxCUST = BBCUST                                            CGL177
      ** Record(s) found
     C                   IF        *IN50 = *OFF
     C                   OPEN      SD000554P1
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRZSPR
     C                   ENDIF
      *
      ** If overflow indicator fires up, write header format
      *
     C                   IF        *IN05 = *ON
     C                   WRITE     SD000554R0
     C                   ENDIF
      *
      ** Initialize printer fields                                                            CGL177
      *                                                                                       CGL177
     C                   EVAL      XRREFR = *BLANKS                                           CGL177
     C                   EVAL      XRRPNM = *BLANKS                                           CGL177
     C                   EVAL      XRRPTN = *BLANKS                                           CGL177
     C                   EVAL      XRSNAM = *BLANKS                                           CGL177
     C                   MOVEA     *BLANKS       Excpts                                       CGL177
     C                   EVAL      WcheckH = *ZERO                                            CGL177
     C                   EVAL      WcheckCH = *ZERO                                           CGL177
     C                   EVAL      WcheckI = *ZERO                                            CGL177
     C                   EVAL      WcheckCI = *ZERO                                           CGL177
     C                   EVAL      WxEXID = *BLANKS                                           CGL177
     C                   EVAL      WcEXID = *BLANKS                                           CGL177
      *                                                                                       CGL177
      ** Check Customer if there's FATCA Exception                                            CGL177
      *                                                                                       CGL177
     C     WxCUST        CHAIN     SDFTCSD0                                                   CGL177
      *                                                                                       CGL177
     C                   IF        %FOUND(SDFTCSL6)                                           CGL177
     C                   IF        FAEXID <> *BLANKS                                          CGL177
     C                   EVAL      XRREFR = BBCUST                                            CGL177
     C                   EVAL      XRRPNM = BBCRNM                                            CGL177
     C                   EVAL      XRRPTN = BBCRTN                                            CGL177
     C                   EVAL      XRSNAM = BBCSSN                                            CGL177
     C                   EVAL      WxEXID = FAEXID                                            CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Check Customer if there's CRS Exception                                              CGL177
      *                                                                                       CGL177
     C     WxCUST        CHAIN     SDCRSHD0                                                   CGL177
      *                                                                                       CGL177
     C                   IF        %FOUND(SDCRSHL2)                                           CGL177
     C                   IF        CREXMI <> *BLANKS                                          CGL177
     C                   EVAL      XRREFR = BBCUST                                            CGL177
     C                   EVAL      XRRPNM = BBCRNM                                            CGL177
     C                   EVAL      XRRPTN = BBCRTN                                            CGL177
     C                   EVAL      XRSNAM = BBCSSN                                            CGL177
     C                   EVAL      WcEXID = CREXMI                                            CGL177
      *                                                                                       CGL177
      ** Check Customer if there's Exception 'H' in FATCA and CRS record                      CGL177
      *                                                                                       CGL177
     C                   EVAL      WcheckH = %SCAN ('H' : WxEXID)                             CGL177
     C                   IF        WcheckH <> 0                                               CGL177
     C                   EVAL      WcheckCH = %SCAN ('H' : WcEXID)                            CGL177
     C                   IF        WcheckCH <> 0                                              CGL177
     C                   EVAL      WcEXID=%replace(' ':WcEXID:%scan('H':WcEXID))              CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Check Customer if there's Exception 'I' in FATCA and CRS record                      CGL177
      *                                                                                       CGL177
     C                   EVAL      WcheckI = %SCAN ('I' : WxEXID)                             CGL177
     C                   IF        WcheckI <> 0                                               CGL177
     C                   EVAL      WcheckCI = %SCAN ('I' : WcEXID)                            CGL177
     C                   IF        WcheckCI <> 0                                              CGL177
     C                   EVAL      WcEXID=%replace(' ':WcEXID:%scan('I':WcEXID))              CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Check Customer if there's Exception 'L' in FATCA and CRS record                      CGL177
      *                                                                                       CGL177
     C                   EVAL      WcheckI = %SCAN ('L' : WxEXID)                             CGL177
     C                   IF        WcheckI <> 0                                               CGL177
     C                   EVAL      WcheckCI = %SCAN ('L' : WcEXID)                            CGL177
     C                   IF        WcheckCI <> 0                                              CGL177
     C                   EVAL      WcEXID=%replace(' ':WcEXID:%scan('L':WcEXID))              CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      WxEXID = %TRIM(WxEXID) + %TRIM(WcEXID)                     CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Prepare detail data for printing
      *
     C                   EXSR      SRDETAIL
      *
      ** If overflow indicator on, then set it off
      *
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF

     C                   IF        Excpts(1) <> *Blanks
      *
      ** Write detail record to SD000554P1
      *
     C                   WRITE     SD000554R1
     C                   EXSR      SRWREX
      *
      ** Increment count of records output
      *
     C                   ADD       1             WCALC
     C                   ADD       1             WCALCC
     C                   ENDIF
      *
      ** Read next record
      *
     C**********         READ      SDFTCSD0                               14                  CGL177
     C                   READ      SDCUSTL0                               14                  CGL177
     C                   ENDDO

     C                   EVAL      *IN05 = *ON
     C                   IF        *IN50 = *ON
     C                   IF        WCALCC = 0
     C                   WRITE     SD000554R3
     C                   ENDIF
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000554P1
     C                   ENDIF
      *
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN50 = *OFF
      *
      ** Loop through all non-account holders with exceptions
      *
     C                   EVAL      RTYPE = '*NAHO'
     C*    *LOVAL        SETLL     SDFTNHL6
     C**********         READ      SDFTNHD0                               14                  CGL177
     C                   READ      SDNAHOL0                               14                  CGL177
     C                   DOW       *IN14 <> *ON
     C**********         EVAL      WxNAHO = NHNAHO                                 MD040686 MD042897
     C*****NHNAHO        CHAIN     SDFTNHL6                                        MD039670 MD042897
     C                   EVAL      WxNAHO = FNNAHO                                          MD042897
     C     WxNAHO        CHAIN     SDFTNHL6                                                 MD042897
     C                   IF        %FOUND(SDFTNHL6)                                         MD039670
     C                   IF        FNLCTP <> 'D'                                            MD039670
                                                                                            MD039670
     C**********         EVAL      PKEY1 = NHNAHO                                 MD039670  MD042897
     C                   EVAL      PKEY1 = FNNAHO                                           MD042897
     C                   IF        PKEY1 <> *BLANKS                                         MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *Blanks       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PKEY1                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDNAHOL0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD039670
      ** Record(s) found
     C                   IF        *IN50 = *OFF
     C                   OPEN      SD000554P1
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRZSPR
     C                   ENDIF
      *
      ** If overflow indicator fires up, write header format
      *
     C                   IF        *IN05 = *ON
     C                   WRITE     SD000554R0
     C                   ENDIF
      *                                                                                       CGL177
      ** Initialize printer fields                                                            CGL177
      *                                                                                       CGL177
     C                   EVAL      XRREFR = *BLANKS                                           CGL177
     C                   EVAL      XRRPNM = *BLANKS                                           CGL177
     C                   EVAL      XRRPTN = *BLANKS                                           CGL177
     C                   EVAL      XRSNAM = *BLANKS                                           CGL177
     C                   MOVEA     *BLANKS       Excpts                                       CGL177
     C                   EVAL      WcheckH = *ZERO                                            CGL177
     C                   EVAL      WcheckCH = *ZERO                                           CGL177
     C                   EVAL      WcheckI = *ZERO                                            CGL177
     C                   EVAL      WcheckCI = *ZERO                                           CGL177
     C                   EVAL      WxEXID = *BLANKS                                           CGL177
     C                   EVAL      WcEXID = *BLANKS                                           CGL177
      *                                                                                       CGL177
      ** Check Non-account Holder if there's FATCA Exception                                  CGL177
      *                                                                                       CGL177
     C     WxNAHO        CHAIN     SDFTNHD0                                                   CGL177
      *                                                                                       CGL177
     C                   IF        %FOUND(SDFTNHL6)                                           CGL177
     C                   IF        FNEXID <> *BLANKS                                          CGL177
     C                   EVAL      XRREFR = NHNAHO                                            CGL177
     C                   EVAL      XRRPNM = NHNARN                                            CGL177
     C                   EVAL      XRRPTN = NHNATW                                            CGL177
     C                   EVAL      XRSNAM = *BLANKS                                           CGL177
     C                   EVAL      WxEXID = FNEXID                                            CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Check Non-account Holder if there's CRS Exception                                    CGL177
      *                                                                                       CGL177
     C     WxNAHO        CHAIN     SDCRNHD0                                                   CGL177
      *                                                                                       CGL177
     C                   IF        %FOUND(SDCRNHL2)                                           CGL177
     C                   IF        NREXMI <> *BLANKS                                          CGL177
     C                   EVAL      XRREFR = NHNAHO                                            CGL177
     C                   EVAL      XRRPNM = NHNARN                                            CGL177
     C                   EVAL      XRRPTN = NHNATW                                            CGL177
     C                   EVAL      XRSNAM = *BLANKS                                           CGL177
     C                   EVAL      WcEXID = NREXMI                                            CGL177
      *                                                                                       CGL177
      ** Check Non-account Holder if there's Exception 'H' in FATCA and CRS record            CGL177
      *                                                                                       CGL177
     C                   EVAL      WcheckH = %SCAN ('H' : WxEXID)                             CGL177
     C                   IF        WcheckH <> 0                                               CGL177
     C                   EVAL      WcheckCH = %SCAN ('H' : WcEXID)                            CGL177
     C                   IF        WcheckCH <> 0                                              CGL177
     C                   EVAL      WcEXID=%replace(' ':WcEXID:%scan('H':WcEXID))              CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Check Non-account Holder if there's Exception 'I' in FATCA and CRS record            CGL177
      *                                                                                       CGL177
     C                   EVAL      WcheckI = %SCAN ('I' : WxEXID)                             CGL177
     C                   IF        WcheckI <> 0                                               CGL177
     C                   EVAL      WcheckCI = %SCAN ('I' : WcEXID)                            CGL177
     C                   IF        WcheckCI <> 0                                              CGL177
     C                   EVAL      WcEXID=%replace(' ':WcEXID:%scan('I':WcEXID))              CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *                                                                                       CGL177
      ** Check Non-account Holder if there's Exception 'L' in FATCA and CRS record            CGL177
      *                                                                                       CGL177
     C                   EVAL      WcheckH = %SCAN ('L' : WxEXID)                             CGL177
     C                   IF        WcheckH <> 0                                               CGL177
     C                   EVAL      WcheckCH = %SCAN ('L' : WcEXID)                            CGL177
     C                   IF        WcheckCH <> 0                                              CGL177
     C                   EVAL      WcEXID=%replace(' ':WcEXID:%scan('L':WcEXID))              CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      WxEXID = %TRIM(WxEXID) + %TRIM(WcEXID)                     CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
      *
      ** Prepare detail data for printing
      *
     C                   EXSR      SRDETAIL
      *
      ** If overflow indicator on, then set it off
      *
     C                   IF        *IN05 = *ON
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
     C                   IF        Excpts(1) <> *Blanks
      *
      ** Write detail record to SD000554P1
      *
     C                   WRITE     SD000554R1
     C                   EXSR      SRWREX
      *
      ** Increment count of records output
      *
     C                   ADD       1             WCALC
     C                   ADD       1             WCALCN
     C                   ENDIF
      *                                                                                     MD039670
     C                   ENDIF                                                              MD039670
      *                                                                                     MD039670
     C                   ENDIF                                                              MD039670
      *
      ** Read next record
      *
     C**********         READ      SDFTNHD0                               14                  CGL177
     C                   READ      SDNAHOL0                               14                  CGL177
     C                   ENDDO
      *                                                                                       CGL177
     C                   IF        *IN50 = *ON
     C                   IF        WCALCC = 0
     C                   WRITE     SD000554R3
     C                   ENDIF
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000554P1
     C                   ENDIF

     C                   IF        WCALC = 0
     C                   OPEN      SD000554P1
     C                   WRITE     SD000554R0
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRZSPR
     C                   EXSR      SRCLOS
     C                   CLOSE     SD000554P1
     C                   ENDIF

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

     C**********         EVAL      XRREFR = *BLANKS                                           CGL177
     C**********         EVAL      XRRPNM = *BLANKS                                           CGL177
     C**********         EVAL      XRRPTN = *BLANKS                                           CGL177
     C**********         EVAL      XRSNAM = *BLANKS                                           CGL177
     C                   MOVEA     *BLANKS       Excpts
     C                   MOVEA     WxEXID        Excpts                                       CGL177
      * Set Report Details
     C**********         IF        RTYPE = '*CUST'                                            CGL177
     C**********         EVAL      XRREFR = FACUST                                            CGL177
      ** Get customer details
     C*****FACUST        CHAIN     @BBREBG                                                    CGL177
     C**********         IF        %FOUND = '1'                                               CGL177
     C**********         EVAL      XRRPNM = BBCRNM                                            CGL177
     C**********         EVAL      XRRPTN = BBCRTN                                            CGL177
     C**********         EVAL      XRSNAM = BBCSSN                                            CGL177
     C**********         ENDIF                                                                CGL177
     C**********         EVAL      Excpts = *BLANKS                                           CGL177
     C**********         MOVEA     FAEXID        Excpts                                       CGL177
      *
     C**********         ELSEIF    RTYPE = '*NAHO'                                            CGL177
     C**********         EVAL      XRREFR = FNNAHO                                            CGL177
      ** Get non-account holder details
     C*****FNNAHO        CHAIN     SDNAHOD0                                                   CGL177
     C**********         IF        %FOUND = '1'                                               CGL177
     C**********         EVAL      XRRPNM = NHNARN                                            CGL177
     C**********         EVAL      XRRPTN = NHNATW                                            CGL177
     C**********         EVAL      XRSNAM = *BLANKS                                           CGL177
     C**********         ENDIF                                                                CGL177
     C**********         EVAL      Excpts = *BLANKS                                           CGL177
     C**********         MOVEA     FNEXID        Excpts                                       CGL177
     C**********         ENDIF                                                                CGL177
      ** If a selection was made, filter for them
     C                   IF        PExceptions <> *BLANKS
     C                   EVAL      WIdx = 1
     C                   EVAL      WExIDs = *BLANKS
     C                   DOW       %trim(SelEx(WIdx)) <> *BLANKS
     C                   EVAL      WMatch = %LOOKUP(SelEx(WIdx):Excpts)
     C**********         IF        %FOUND = '1' and WMatch > 0                                CGL177
     C                   IF        WMatch > 0                                                 CGL177
     C                   EVAL      WExIDs = %trim(WExIDs) + SelEx(WIdx)
     C                   ENDIF
     C                   EVAL      WIdx += 1
     C                   ENDDO
     C                   MOVEA     *BLANKS       Excpts
     C                   MOVEA     WExIDs        Excpts
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWREX - Write Exceptions for crrent Customer                 *
      *                                                               *
      *****************************************************************
     C     SRWREX        BEGSR
     C                   EVAL      WIdx = 1
     C                   DOW       Excpts(WIdx) <> *BLANKS
     C     Excpts(WIdx)  CHAIN     SDEXMAL0
     C**********         IF        %FOUND = '1'                                               CGL177
     C                   IF        %FOUND(SDEXMAL0)                                           CGL177
      ** Move exception message (256A) to array of 4 elements (64A)
     C                   EVAL      MsgLines = *BLANKS
     C                   MOVEA     FEEXDE        MsgLines
     C                   EVAL      XREXID = FEEXID                                          MD039196
      ** Set on bullet for first line of each message.
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WIdx2 = 1
     C                   DOW       MsgLines(WIdx2) <> *BLANKS
     C                   EVAL      XREXMX = MsgLines(WIdx2)
      *                                                                                       CGL177
      ** If overflow indicator fires up, write header format                                  CGL177
      *                                                                                       CGL177
     C                   IF        *IN05 = *ON                                                CGL177
     C                   WRITE     SD000554R0                                                 CGL177
     C                   WRITE     SD000554R1                                                 CGL177
     C                   EVAL      *IN05 = *OFF                                               CGL177
     C                   ENDIF                                                                CGL177
      ** Append line to exceptions list of current customer
     C                   WRITE     SD000554R2
      ** Move to next exception message line index
     C                   EVAL      WIdx2 += 1
      ** Switch off bullet after first line of each message.
     C                   EVAL      *IN42 = *OFF
     C                   ENDDO
     C                   ENDIF
      ** Move to next exception id index
     C                   EVAL      WIdx += 1
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE1 - Validate & convert date to a day number            *
      *                                                               *
      *****************************************************************
     C     SRDATE1       BEGSR

     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRetCode
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
      * SRZSPR   - Invoke ZS Processing                               *
      *                                                               *
      * Called by: SRREPT                                             *
      *                                                               *
      *****************************************************************
     C     SRZSPR        BEGSR
     C                   Z-ADD     SFNUM         ZSNUM
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSequence
     C*                  PARM      *BLANKS       PEntity
     C**                 PARM                    SFILE
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
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds

     C                   MOVEA     PExceptions   SelEx

      ** access installation control data
      ** access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** if access program fails call SR. *PSSR

     C                   IF        PRetCode <> *BLANK
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
     C                   EVAL      XRTITL = BJURPT                                          MD025220
     C                   EVAL      XRRUNA = BJMRDT                                          MD025220
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

     C*                  Z-ADD     SFNUMU        ZSNUM
     C*                  CALL      'ZSFILE'
     C*                  PARM                    PSequence
     C*                  PARM      *BLANK        PEntity
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


      ** if a database error has occured, bypass further processing

     C     *INU7         CABEQ     *ON           TEND

      ** prints 'END OF REPORT' if *IN50 ON.

     C                   IF        *IN50 = *ON
     C                   WRITE     SD000554R4
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
