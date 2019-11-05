     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - SD')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBSD - Global Updates - SD                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD053583           Date 10Jun19               *
      *  Prev Amend No. MD050212           Date 02Apr18               *
      *                 MD050231           Date 25Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073             Date 10Jul17               *
      *                 CGL052             Date 02Dec15               *
      *                 CGL165             Date 23Feb15               *
      *                 CLE164             Date 18Aug14               *
      *                 MD030467           Date 14Oct14               *
      *                 MD029077           Date 30Jul14               *
      *                 MD027375           Date 05Jun14               *
      *                 CGL155             Date 18Mar14               *
      *                 CGL153             Date 05Feb14               *
      *                 MD025828           Date 05May14               *
      *                 MD026518           Date 30Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024037           Date 18Dec13               *
      *                 MD023837           Date 27Nov13               *
      *                 CGL135A            Date 08Oct13               *
      *                 CGL145A            Date 08Oct13               *
      *                 CMG003             Date 04Oct12               *
      *                 CGP017             Date 06Aug12               *
      *                 262821             Date 09Jan13               *
      *                 AR547326           Date 07Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CFT045             Date 04Aug11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CSD090             Date 06Dec10               *
      *                 AR751852           Date 02May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26779           Date 27Nov09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24717           Date 14Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22529           Date 11Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 BUG27844A          Date 15Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      *                 CAP204             Date 20Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18631           Date 08May08               *
      *                 BUG15946           Date 08Feb08               *
      *                 249077             Date 21Nov07               *
      *                 244057             Date 28Nov06               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11669           Date 30Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11273           Date 28Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7825            Date 29Jul05               *
      *                 BG6438R            Date 23May05               *
      *                 BG6438             Date 05Apr05               *
      *                 CGP010             Date 17Jan05               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3122            Date 09Jul04               *
      *                 BG1904             Date 15Apr03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053583 - Inserted record in CUSD does not appear in the    *
      *             Main List View.                                   *
      *           - Program import not found. Calling pgm GOGLOBSD    *
      *             refers to a procedure or data export from service *
      *             program SP8GP0006 which does not exist.           *
      *           - Recompile.                                        *
      *  MD050212 - Replication processing for PF/SDCUSTXC            *
      *  MD050231 - Failed global replication process during switchon *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *  CGL052 - Amend Washout Processing                            *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD030467 - Incorrect record for zone updated. Read GPMLCSPD  *
      *             and check for correct zone being updated.         *
      *  MD029077 - No customer is returned during Customer search    *
      *             Incomplete deliverable for global replication     *
      *  MD027375 - Group limit details not reflected for all         *
      *             accounts included in the group (Recompile)        *
      *  CGL155 - Forecast Group Limits                               *
      *  CGL153 - Estimated Exchange Rate                             *
      *  MD025828 - [ENGINEERING] Listview of Main Customer           *
      *  MD026518 - Incorrect drop down selection in US indicia       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CSD093 - Document Management                                 *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD024037 - Facility availability Enquiry did not display a   *
      *             future datead charge to CL Balance (Recompile)    *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  CGL135A - Accounting Rules Process                           *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  262821 - Blank zone field in PF/GPMLCSPD when currency is    *
      *           amended.                                            *
      *         - Applied for AR1071057                               *
      *  AR547326 - Prevent CPF4293 error on file GPGLCUSLL1 by doing *
      *             an overide share no before opening it             *
      *             (Child: AR547327)                                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CFT045 - Outgoing Payments - Extended Settlement Instructions*
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CSD090 - Customer Segmentation                               *
      *  AR751852 - No posting made in Account Movement Enquiry and   *
      *             PABE after COB (Child: AR751853)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change request on GSART table                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24717 - Some customers rejected in LDNI transaction:      *
      *             fix already covered by BUG18631                   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22529 - Global Additional Customer Details                *
      *  CER048 - German Features - Taxes                             *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG27844A - Incorrect 'from date' default from SOAP enquiry  *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Retail Account Transfer                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18631 - GPGLCUSL customer status should be updated if     *
      *             deleted date is greater than zero and closure     *
      *             status is 'Y'                                     *
      *  BUG15946 - CLE025 intialization pgm failed                   *
      *  249077   - When a customer was closed, GPGLCUSL should also  *
      *             be updated.                                       *
      *  244057   - Do not update GPGLCUSL if there is a record on    *
      *           - GPCUSTXPD as Global customer data is overwritten  *
      *           - with Zonal customer data.                         *
      *  CRE026 - Consumer Banking                                    *
      *  BUG11669 - Not able to setup customer groups                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11273 - Attempt to write duplicate record in GPGLCUSL.    *
      *             Add GPGLCUSL.CGBRCD as new key(unique).(Recompile)*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7825 - CPF4293 error after setting on modules via SCBEGIN *
      *  BG6438R- Local customer shortname not updated (BUG5404)      *
      *  BG6438 - Remove secondary triggers on consolidated files     *
      *  CGP010 - Global BSPL                                         *
      *  BUG3644 - Serious Error in Collateralised Lending            *
      *  BUG3122 - Amended to add SDSECSPD.                           *
      *  BG1904 - Missing global deliverables                         *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGPGLCUSLL1UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)                         BG6438
O    F                                     USROPN                                             BG6438
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)                                       BG6438
     FGPACOFXL0 IF   E           K DISK    INFSR(*PSSR)                                       BG6438
     FGPINDSXL0 IF   E           K DISK    INFSR(*PSSR)                                       BG6438
     FGPCUSTXL1 IF   E           K DISK    INFSR(*PSSR)                                       244057
     FGPMLCSL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)                         BG6438
     F                                     USROPN                                             BG6438
                                                                                              BG6438
     D Z_SDCURRPD    E DS                  EXTNAME(SDCURRPD)                                  BG6438
                                                                                              BG6438
O    D Z_SDCUSTPD    E DS                  EXTNAME(SDCUSTPD)                                  BG6438
                                                                                              BG6438
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D CMDLEN          S             15P 5                                                   BUG7825
     D CMDSTR          S            100    DIM(2) CTDATA PERRCD(1)                           BUG7825
B    D*#_BR*****       S              3    DIM(99)                                   BG6438 BUG15946
B    D*#_ZN*****       S             10    DIM(99)                                   BG6438 BUG15946
B    D #_BR            S              3    DIM(999)                                         BUG15946
B    D #_ZN            S             10    DIM(999)                                         BUG15946
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
     D CmdArray        S             80A   DIM(2) CTDATA PERRCD(1)                          AR547326
     D Cmd             S             80A                                                    AR547326
     D Len             S             15P 5                                                  AR547326
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
     ISDBRCHD0                                                                                BG6438
     I              QQDFAC                      QQDFAC_X                                      BG6438
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
 
 
      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP
 
      * Determine updates
 
     C                   EXSR      DET_UPDATES
 
     C                   MOVEL     'B'           I#BFAF
     C                   DO        2
 
     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C     PFLNAME       CASEQ     'CLINTSE '    GLOB_CLINTSE
     C     PFLNAME       CASEQ     'SDACODPD'    GLOB_SDACODPD
     C     PFLNAME       CASEQ     'SDACOFPD'    GLOB_SDACOFPD
     C     PFLNAME       CASEQ     'SDATSTPD'    GLOB_SDATSTPD                                CAP204
     C     PFLNAME       CASEQ     'SDBANKPD'    GLOB_SDBANKPD
     C     PFLNAME       CASEQ     'SDBISTPD'    GLOB_SDBISTPD                                CER045
     C     PFLNAME       CASEQ     'SDBOOKPD'    GLOB_SDBOOKPD
     C     PFLNAME       CASEQ     'SDBRCHPD'    GLOB_SDBRCHPD
     C     PFLNAME       CASEQ     'SDBROKPD'    GLOB_SDBROKPD
     C     PFLNAME       CASEQ     'SDBSCCPD'    GLOB_SDBSCCPD                                CER045
     C     PFLNAME       CASEQ     'SDBSRTPD'    GLOB_SDBSRTPD
     C     PFLNAME       CASEQ     'SDBUCLPD'    GLOB_SDBUCLPD                                CER045
     C     PFLNAME       CASEQ     'SDBUSUPD'    GLOB_SDBUSUPD                                CER045
     C     PFLNAME       CASEQ     'SDBUTYPD'    GLOB_SDBUTYPD                              BUG26779
     C     PFLNAME       CASEQ     'SDCOLOPD'    GLOB_SDCOLOPD
     C     PFLNAME       CASEQ     'SDCOMPPD'    GLOB_SDCOMPPD
     C     PFLNAME       CASEQ     'SDCOTPPD'    GLOB_SDCOTPPD
     C     PFLNAME       CASEQ     'SDCUHSPD'    GLOB_SDCUHSPD                                CGP010
     C     PFLNAME       CASEQ     'SDCURRPD'    GLOB_SDCURRPD
     C     PFLNAME       CASEQ     'SDCUSTPD'    GLOB_SDCUSTPD
     C     PFLNAME       CASEQ     'SDDEPTPD'    GLOB_SDDEPTPD
     C     PFLNAME       CASEQ     'SDDLSTPD'    GLOB_SDDLSTPD
     C     PFLNAME       CASEQ     'SDECACPD'    GLOB_SDECACPD                                CER045
     C     PFLNAME       CASEQ     'SDEXEMPD'    GLOB_SDEXEMPD
     C     PFLNAME       CASEQ     'SDFACTPD'    GLOB_SDFACTPD
     C     PFLNAME       CASEQ     'SDFEEPD '    GLOB_SDFEEPD                                 BG1904
     C     PFLNAME       CASEQ     'SDFTFRPD'    GLOB_SDFTFRPD
     C     PFLNAME       CASEQ     'SDINCCPD'    GLOB_SDINCCPD
     C     PFLNAME       CASEQ     'SDINDSPD'    GLOB_SDINDSPD
     C     PFLNAME       CASEQ     'SDLOANPD'    GLOB_SDLOANPD
     C     PFLNAME       CASEQ     'SDLOCNPD'    GLOB_SDLOCNPD
     C     PFLNAME       CASEQ     'SDMMIDPD'    GLOB_SDMMIDPD
     C     PFLNAME       CASEQ     'SDNATUPD'    GLOB_SDNATUPD
     C     PFLNAME       CASEQ     'SDNOSTPD'    GLOB_SDNOSTPD
     C     PFLNAME       CASEQ     'SDNOST2D'    GLOB_SDNOST2D                               CGL135A
     C     PFLNAME       CASEQ     'SDOPESPD'    GLOB_SDOPESPD                                CFT045
     C     PFLNAME       CASEQ     'SDPDWHPD'    GLOB_SDPDWHPD
     C     PFLNAME       CASEQ     'SDPDWNPD'    GLOB_SDPDWNPD
     C     PFLNAME       CASEQ     'SDPLINPD'    GLOB_SDPLINPD
     C     PFLNAME       CASEQ     'SDPRFCPD'    GLOB_SDPRFCPD
     C     PFLNAME       CASEQ     'SDSECSPD'    GLOB_SDSECSPD                               BUG3122
     C     PFLNAME       CASEQ     'SDSTRDPD'    GLOB_SDSTRDPD
     C     PFLNAME       CASEQ     'SDTCLSPD'    GLOB_SDTCLSPD                                CDL038
     C     PFLNAME       CASEQ     'SDYLDCPD'    GLOB_SDYLDCPD
     C     PFLNAME       CASEQ     'SDYLDRPD'    GLOB_SDYLDRPD
     C     PFLNAME       CASEQ     'SDCOCCPD'    GLOB_SDCOCCPD                               BUG3644
     C     PFLNAME       CASEQ     'SDCTRYPD'    GLOB_SDCTRYPD                               BUG3644
     C     PFLNAME       CASEQ     'SDCUWOPD'    GLOB_SDCUWOPD                               BUG3644
     C     PFLNAME       CASEQ     'SDMASTPD'    GLOB_SDMASTPD                               BUG3644
     C     PFLNAME       CASEQ     'SDALTNPD'    GLOB_SDALTNPD                                CRE026
     C     PFLNAME       CASEQ     'SDSVALPD'    GLOB_SDSVALPD                                CAP205
     C     PFLNAME       CASEQ     'SDHOLPD'     GLOB_SDHOLPD                              BUG27844A
     C     PFLNAME       CASEQ     'SDNAHOPD'    GLOB_SDNAHOPD                                CER048
     C     PFLNAME       CASEQ     'SDJACCPD'    GLOB_SDJACCPD                                CER048
     C     PFLNAME       CASEQ     'SDACUSPD'    GLOB_SDACUSPD                              BUG22529
     C     PFLNAME       CASEQ     'SDGESTPD'    GLOB_SDGESTPD                                CER054
     C     PFLNAME       CASEQ     'SDRLAFPD'    GLOB_SDRLAFPD                                CER054
     C     PFLNAME       CASEQ     'SDCUAHPD'    GLOB_SDCUAHPD                                CER059
     C     PFLNAME       CASEQ     'SDACTXPD'    GLOB_SDACTXPD                                CER059
     C     PFLNAME       CASEQ     'SDABCIPD'    GLOB_SDABCIPD                              AR751852
     C     PFLNAME       CASEQ     'SDCSEGPD'    GLOB_SDCSEGPD                                CSD090
     C     PFLNAME       CASEQ     'SDCUSTQD'    GLOB_SDCUSTQD                                CER049
     C     PFLNAME       CASEQ     'SDCMDTPD'    GLOB_SDCMDTPD                                CMG003
     C     PFLNAME       CASEQ     'SDFCSDTD'    GLOB_SDFCSDTD                               CGL145A
     C     PFLNAME       CASEQ     'SDDCMTPD'    GLOB_SDDCMTPD                                CSD093
     C     PFLNAME       CASEQ     'SDDMCHPD'    GLOB_SDDMCHPD                                CSD093
     C     PFLNAME       CASEQ     'SDDOCMPD'    GLOB_SDDOCMPD                                CSD093
     C     PFLNAME       CASEQ     'SDACRVPD'    GLOB_SDACRVPD                                CSD092
     C     PFLNAME       CASEQ     'SDARCHPD'    GLOB_SDARCHPD                                CSD092
     C     PFLNAME       CASEQ     'SDHCIDPD'    GLOB_SDHCIDPD                                CSD092
     C     PFLNAME       CASEQ     'SDHCINPD'    GLOB_SDHCINPD                                CSD092
     C     PFLNAME       CASEQ     'SDFTHAPD'    GLOB_SDFTHAPD                                CGL132
     C     PFLNAME       CASEQ     'SDFTCSPD'    GLOB_SDFTCSPD                                CGL132
     C     PFLNAME       CASEQ     'SDFATCPD'    GLOB_SDFATCPD                              MD026518
     C     PFLNAME       CASEQ     'SDCSSWPD'    GLOB_SDCSSWPD                              MD025828
     C     PFLNAME       CASEQ     'SDEERTTD  '  GLOB_SDEERTTD                                CGL153
     C     PFLNAME       CASEQ     'SDNGLDTD  '  GLOB_SDNGLDTD                                CGL155
     C     PFLNAME       CASEQ     'SDNGLHTD  '  GLOB_SDNGLHTD                                CGL155
     C     PFLNAME       CASEQ     'SDINSTPD  '  GLOB_SDINSTPD                              MD029077
     C     PFLNAME       CASEQ     'SDPRGPTD  '  GLOB_SDPRGPTD                                CLE164
     C     PFLNAME       CASEQ     'SDRPKYTD  '  GLOB_SDRPKYTD                                CLE164
     C     PFLNAME       CASEQ     'SDMTRXTD  '  GLOB_SDMTRXTD                                CLE164
     C     PFLNAME       CASEQ     'SDBRCHX0  '  GLOB_SDBRCHX0                                CGL052
     C     PFLNAME       CASEQ     'SDANACQD  '  GLOB_SDANACQD                                CER073
     C     PFLNAME       CASEQ     'SDCRSDPD  '  GLOB_SDCRSDPD                              MD050231
     C     PFLNAME       CASEQ     'SDCRSHPD  '  GLOB_SDCRSHPD                              MD050231
     C     PFLNAME       CASEQ     'SDCTTXPD  '  GLOB_SDCTTXPD                              MD050231
     C     PFLNAME       CASEQ     'SDCUSTXC  '  GLOB_SDCUSTXC                              MD050212
     C                   ENDCS
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5                                                                               BUG3644
      *****************************************************************                      BUG3644
      * Global Updates - Collateral and Credit Lines ICD                                     BUG3644
      *****************************************************************                      BUG3644
     C     GLOB_SDCOCCPD BEGSR                                                               BUG3644
      /COPY GPCPYSRCG,GPSDCOCCPD                                                             BUG3644
     C                   ENDSR                                                               BUG3644
      *****************************************************************                      BUG3644
      /SPACE 5                                                                               BUG3644
      *****************************************************************                      BUG3644
      * Global Updates - Country Codes                                                       BUG3644
      *****************************************************************                      BUG3644
     C     GLOB_SDCTRYPD BEGSR                                                               BUG3644
      /COPY GPCPYSRCG,GPSDCTRYPD                                                             BUG3644
     C                   ENDSR                                                               BUG3644
      *****************************************************************                      BUG3644
      /SPACE 5                                                                               BUG3644
      *****************************************************************                      BUG3644
      * Global Updates - Customer Weighting Overrides                                        BUG3644
      *****************************************************************                      BUG3644
     C     GLOB_SDCUWOPD BEGSR                                                               BUG3644
      /COPY GPCPYSRCG,GPSDCUWOPD                                                             BUG3644
     C                   ENDSR                                                               BUG3644
      *****************************************************************                      BUG3644
      /SPACE 5                                                                               BUG3644
      *****************************************************************                      BUG3644
      * Global Updates - Margin Schedule Type                                                BUG3644
      *****************************************************************                      BUG3644
     C     GLOB_SDMASTPD BEGSR                                                               BUG3644
      /COPY GPCPYSRCG,GPSDMASTPD                                                             BUG3644
     C                   ENDSR                                                               BUG3644
      *****************************************************************                      BUG3644
     C     GLOB_SDALTNPD BEGSR                                                                CRE026
      /COPY GPCPYSRCG,GPSDALTNPD                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CER048
      *****************************************************************                       CER048
      * Global Updates - Non Account Holder                                                   CER048
      *****************************************************************                       CER048
     C     GLOB_SDNAHOPD BEGSR                                                                CER048
      /COPY GPCPYSRCG,GPSDNAHOPD                                                              CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /SPACE 5                                                                                CER048
      *****************************************************************                       CER048
      * Global Updates - Joint Account Holder                                                 CER048
      *****************************************************************                       CER048
     C     GLOB_SDJACCPD BEGSR                                                                CER048
      /COPY GPCPYSRCG,GPSDJACCPD                                                              CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /SPACE 5                                                                                CER054
      *****************************************************************                       CER054
      * Global Updates - State Codes                                                          CER054
      *****************************************************************                       CER054
     C     GLOB_SDGESTPD BEGSR                                                                CER054
      /COPY GPCPYSRCG,GPSDGESTPD                                                              CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /SPACE 5                                                                                CER054
      *****************************************************************                       CER054
      * Global Updates - Religious Affiliation File                                           CER054
      *****************************************************************                       CER054
     C     GLOB_SDRLAFPD BEGSR                                                                CER054
      /COPY GPCPYSRCG,GPSDRLAFPD                                                              CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /SPACE 5                                                                              BUG22529
      *****************************************************************                     BUG22529
      * Global Updates - Additional Customers                                               BUG22529
      *****************************************************************                     BUG22529
     C     GLOB_SDACUSPD BEGSR                                                              BUG22529
      /COPY GPCPYSRCG,GPSDACUSPD                                                            BUG22529
     C                   ENDSR                                                              BUG22529
      *****************************************************************                     BUG22529
      /SPACE 5                                                                                CER059
      *****************************************************************                       CER059
      * Global Updates - Customer to Authority Holder Link                                    CER059
      *****************************************************************                       CER059
     C     GLOB_SDCUAHPD BEGSR                                                                CER059
      /COPY GPCPYSRCG,GPSDCUAHPD                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /SPACE 5                                                                                CER059
      *****************************************************************                       CER059
      * Global Updates - Customer Details by Country of Tax                                   CER059
      *****************************************************************                       CER059
     C     GLOB_SDACTXPD BEGSR                                                                CER059
      /COPY GPCPYSRCG,GPSDACTXPD                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /SPACE 5                                                                                CSD090
      *****************************************************************                       CSD090
      * Global Updates - Customer Segmentation                                                CSD090
      *****************************************************************                       CSD090
     C     GLOB_SDCSEGPD BEGSR                                                                CSD090
      /COPY GPCPYSRCG,GPSDCSEGPD                                                              CSD090
     C                   ENDSR                                                                CSD090
      *****************************************************************                       CSD090
      /SPACE 5
      *****************************************************************                       CER049
      * Global Updates - Customer Details Extension File                                      CER049
      *****************************************************************                       CER049
     C     GLOB_SDCUSTQD BEGSR                                                                CER049
      /COPY GPCPYSRCG,GPSDCUSTQD                                                              CER049
     C                   ENDSR                                                                CER049
      *****************************************************************                       CER049
     C/SPACE 5                                                                                CER049
     C     GLOB_SDABCIPD BEGSR                                                              AR751852
      /COPY GPCPYSRCG,GPSDABCIPD                                                            AR751852
     C                   ENDSR                                                              AR751852
      *****************************************************************                     AR751852
      /SPACE 5                                                                              AR751852
      *****************************************************************
      * Global Updates - SE Customers
      *****************************************************************
     C     GLOB_CLINTSE  BEGSR
      /COPY GPCPYSRCG,GPCLINTSE
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Account codes
      *****************************************************************
     C     GLOB_SDACODPD BEGSR
      /COPY GPCPYSRCG,GPSDACODPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Account Officers
      *****************************************************************
     C     GLOB_SDACOFPD BEGSR
      /COPY GPCPYSRCG,GPSDACOFPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                       CAP204
      * Global Updates - Account Transfer Type/Sub-Type                                       CAP204
      *****************************************************************                       CAP204
     C     GLOB_SDATSTPD BEGSR                                                                CAP204
      /COPY GPCPYSRCG,GPSDATSTPD                                                              CAP204
     C                   ENDSR                                                                CAP204
      *****************************************************************                       CAP204
      /SPACE 5                                                                                CAP204
      *****************************************************************
      * Global Updates - Bank Details
      *****************************************************************
     C     GLOB_SDBANKPD BEGSR
      /COPY GPCPYSRCG,GPSDBANKPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CER045
      *****************************************************************                       CER045
      * Global Updates - Borrower Sector Classification/BISTA Code                            CER045
      *****************************************************************                       CER045
     C     GLOB_SDBISTPD BEGSR                                                                CER045
      /COPY GPCPYSRCG,GPSDBISTPD                                                              CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /SPACE 5
      *****************************************************************
      * Global Updates - Books
      *****************************************************************
     C     GLOB_SDBOOKPD BEGSR
      /COPY GPCPYSRCG,GPSDBOOKPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Branches
      *****************************************************************
     C     GLOB_SDBRCHPD BEGSR
      /COPY GPCPYSRCG,GPSDBRCHPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Brokers
      *****************************************************************
     C     GLOB_SDBROKPD BEGSR
      /COPY GPCPYSRCG,GPSDBROKPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CER045
      *****************************************************************                       CER045
      * Global Updates - Borrower Sector Classification                                       CER045
      *****************************************************************                       CER045
     C     GLOB_SDBSCCPD BEGSR                                                                CER045
      /COPY GPCPYSRCG,GPSDBSCCPD                                                              CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /SPACE 5
      *****************************************************************
      * Global Updates - Base Rates
      *****************************************************************
     C     GLOB_SDBSRTPD BEGSR
      /COPY GPCPYSRCG,GPSDBSRTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CER045
      *****************************************************************                       CER045
      * Global Updates - Business Classification Class Codes                                  CER045
      *****************************************************************                       CER045
     C     GLOB_SDBUCLPD BEGSR                                                                CER045
      /COPY GPCPYSRCG,GPSDBUCLPD                                                              CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /SPACE 5                                                                                CER045
      *****************************************************************                       CER045
      * Global Updates - Business Classification Sub-Class                                    CER045
      *****************************************************************                       CER045
     C     GLOB_SDBUSUPD BEGSR                                                                CER045
      /COPY GPCPYSRCG,GPSDBUSUPD                                                              CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /SPACE 5                                                                              BUG26779
      *****************************************************************                     BUG26779
      * Global Updates - Business Classification Type Codes                                 BUG26779
      *****************************************************************                     BUG26779
     C     GLOB_SDBUTYPD BEGSR                                                              BUG26779
      /COPY GPCPYSRCG,GPSDBUTYPD                                                            BUG26779
     C                   ENDSR                                                              BUG26779
      *****************************************************************                     BUG26779
      /SPACE 5
      *****************************************************************
      * Global Updates - Collateral Location Codes
      *****************************************************************
     C     GLOB_SDCOLOPD BEGSR
      /COPY GPCPYSRCG,GPSDCOLOPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Companies
      *****************************************************************
     C     GLOB_SDCOMPPD BEGSR
      /COPY GPCPYSRCG,GPSDCOMPPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Collateral Types
      *****************************************************************
     C     GLOB_SDCOTPPD BEGSR
      /COPY GPCPYSRCG,GPSDCOTPPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CGP010
      *****************************************************************                       CGP010
      * Global Updates - Historic Spot Rates                                                  CGP010
      *****************************************************************                       CGP010
     C     GLOB_SDCUHSPD BEGSR                                                                CGP010
      /COPY GPCPYSRCG,GPSDCUHSPD                                                              CGP010
     C                   ENDSR                                                                CGP010
      *****************************************************************                       CGP010
      /SPACE 5                                                                                CFT045
      *****************************************************************                       CFT045
      * Global Updates - Outgoing Payments - Extended Settlement Instructions                 CFT045
      *****************************************************************                       CFT045
     C     GLOB_SDOPESPD BEGSR                                                                CFT045
      /COPY GPCPYSRCG,GPSDOPESPD                                                              CFT045
     C                   ENDSR                                                                CFT045
      *****************************************************************                       CFT045
      /SPACE 5                                                                              MD029077
      *****************************************************************                     MD029077
      * Global Updates - Local Institutions                                                 MD029077
      *****************************************************************                     MD029077
     C     GLOB_SDINSTPD BEGSR                                                              MD029077
      /COPY GPCPYSRCG,GPSDINSTPD                                                            MD029077
     C                   ENDSR                                                              MD029077
      *****************************************************************                     MD029077
      /SPACE 5
      *****************************************************************
      * Global Updates - Currencies
      *****************************************************************
     C     GLOB_SDCURRPD BEGSR
      /COPY GPCPYSRCG,GPSDCURRPD
                                                                                              BG6438
      * Update global currency spot rates                                                     BG6438
     C     I#BFAF        IFEQ      'B'                                                        BG6438
     C                   MOVEL     I#BIMG        Z_SDCURRPD                                   BG6438
     C                   ELSE                                                                 BG6438
     C                   MOVEL     I#AIMG        Z_SDCURRPD                                   BG6438
     C                   ENDIF                                                                BG6438
     C                   MOVEL     I#ZONE        A6ZONE                                       262821
                                                                                              BG6438
     C     I#BFAF        IFEQ      *BLANKS                                                    BG6438
     C     I#BIMG        ANDEQ     *BLANKS                                                    BG6438
                                                                                              BG6438
      * Insert                                                                                BG6438
     C                   EXSR      SDCURR                                                     BG6438
     C                   WRITE     GPMLCSPD                                                   BG6438
     C                   ELSE                                                                 BG6438
                                                                                              BG6438
      * Use A6CYCD from SDCURRPD to get position on GPMLCSL0                                  BG6438
     C     A6CYCD        SETLL     GPMLCSL0                           99                      BG6438
                                                                                              BG6438
     C                   MOVE      '0'           *IN98                                      MD030467
     C     *IN98         DOWEQ     *OFF                                                     MD030467
     C     A6CYCD        READE     GPMLCSL0                               98                  BG6438
     C     *IN98         IFEQ      *OFF                                                     MD030467
     C     A6ZONE        ANDEQ     CCYZONE                                                  MD030467
     C                   LEAVE                                                              MD030467
     C                   ENDIF                                                              MD030467
     C                   ENDDO                                                              MD030467
                                                                                              BG6438
     C     I#BFAF        IFEQ      'B'                                                        BG6438
     C     *IN98         ANDEQ     '0'                                                        BG6438
     C                   DELETE    GPMLCSPD                                                   BG6438
     C                   ELSE                                                                 BG6438
                                                                                              BG6438
      * 'After'                                                                               BG6438
     C                   EXSR      SDCURR                                                     BG6438
                                                                                              BG6438
     C     *IN98         IFEQ      '1'                                                        BG6438
     C                   WRITE     GPMLCSPD                                                   BG6438
     C                   ELSE                                                                 BG6438
      * Update                                                                                BG6438
     C                   UPDATE    GPMLCSPD                                                   BG6438
     C                   ENDIF                                                                BG6438
     C                   ENDIF                                                                BG6438
     C                   ENDIF                                                                BG6438
                                                                                              BG6438
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Customers
      *****************************************************************
     C     GLOB_SDCUSTPD BEGSR
      /COPY GPCPYSRCG,GPSDCUSTPD
O                                                                                             BG6438
O     * Global customer updates                                                               BG6438
O    C     I#BFAF        IFEQ      'B'                                                        BG6438
O    C                   MOVEL     I#BIMG        Z_SDCUSTPD                                   BG6438
O    C                   ELSE                                                                 BG6438
O    C                   MOVEL     I#AIMG        Z_SDCUSTPD                                   BG6438
O    C                   ENDIF                                                                BG6438
O                                                                                             BG6438
      * Move character customer field to decimal customer field for CHAIN                     BG6438
     C**********         MOVE      BBCUST        SBBCUST           6 0                 BG6438 CSD027
     C                   MOVE      BBCUST        SBBCUST           6                          CSD027
O                                                                                             BG6438
     C                   EXSR      OPENFILE                                                 AR547326
      * Use SDCUSTPD key to chain to GPGLCUSLL1                                               BG6438
O    C     K_SDCUSTL1    CHAIN     GPGLCUSL                           99                      BG6438
O                                                                                             BG6438
O     * 'Before'                                                                              BG6438
O    C     I#BFAF        IFEQ      'B'                                                        BG6438
O    C  N99              DELETE    GPGLCUSL                                                   BG6438
O    C                   ELSE                                                                 BG6438
O                                                                                             BG6438
O     * Check for record in GPCUSTXPD - If yes then donot update GPGLCUSL.                    244057
O    C     GPCUSTXK      CHAIN     GPCUSTXD0                          97                      244057
     C     *IN97         IFEQ      *ON                                                        244057
O     * 'After'                                                                               BG6438
O    C                   CLEAR                   GPGLCUSL                                     BG6438
                                                                                              BG6438
      * Move SDCUSTPD fields into layout for GPGLCUSLL1                                       BG6438
     C                   EXSR      SET_OUT_CUST                                               BG6438
                                                                                              BG6438
O     * Update                                                                                BG6438
O    C     *IN99         IFEQ      *OFF                                                       BG6438
O    C                   UPDATE    GPGLCUSL                                                   BG6438
O    C                   ELSE                                                                 BG6438
O    C                   WRITE     GPGLCUSL                                                   BG6438
O    C                   ENDIF                                                                BG6438
     C                   ENDIF                                                                244057
O    C                   ENDIF                                                                BG6438
     C                   EXSR      CLOSEFIL                                                 AR547326
O                                                                                             BG6438
O    C                   CALL      'GPSDCUST02'                                             BUG11669
O    C                   PARM                    W#RTCD            7                        BUG11669
O    C                   PARM                    W#ERMS           50                        BUG11669
O    C                   PARM                    I#ZONE           10                        BUG11669
O    C                   PARM                    I#BFAF            1                        BUG11669
O    C                   PARM                    I#TRAP            1                        BUG11669
O    C                   PARM                    I#BIMG         4000                        BUG11669
O    C                   PARM                    I#AIMG         4000                        BUG11669
O                                                                                           BUG11669
O    C     W#RTCD        IFEQ      '*ERROR'                                                 BUG11669
O    C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDCUST02'                   BUG11669
O    C                   EXSR      *PSSR                                                    BUG11669
O    C                   END                                                                BUG11669
O                                                                                           BUG11669
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Departments
      *****************************************************************
     C     GLOB_SDDEPTPD BEGSR
      /COPY GPCPYSRCG,GPSDDEPTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Deal Sub Types
      *****************************************************************
     C     GLOB_SDDLSTPD BEGSR
      /COPY GPCPYSRCG,GPSDDLSTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CER045
      *****************************************************************                       CER045
      * Global Updates - Economic Activity Code                                               CER045
      *****************************************************************                       CER045
     C     GLOB_SDECACPD BEGSR                                                                CER045
      /COPY GPCPYSRCG,GPSDECACPD                                                              CER045
     C                   ENDSR                                                                CER045
      *****************************************************************                       CER045
      /SPACE 5
      *****************************************************************
      * Global Updates - Exemption Code details
      *****************************************************************
     C     GLOB_SDEXEMPD BEGSR
      /COPY GPCPYSRCG,GPSDEXEMPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Facility Types
      *****************************************************************
     C     GLOB_SDFACTPD BEGSR
      /COPY GPCPYSRCG,GPSDFACTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                BG1904
      *****************************************************************                       BG1904
      * Global Updates - Fees                                                                 BG1904
      *****************************************************************                       BG1904
     C     GLOB_SDFEEPD  BEGSR                                                                BG1904
      /COPY GPCPYSRCG,GPSDFEEPD                                                               BG1904
     C                   ENDSR                                                                BG1904
      *****************************************************************                       BG1904
      /SPACE 5
      *****************************************************************
      * Global Updates - Funds Transfer details
      *****************************************************************
     C     GLOB_SDFTFRPD BEGSR
      /COPY GPCPYSRCG,GPSDFTFRPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Income Code details
      *****************************************************************
     C     GLOB_SDINCCPD BEGSR
      /COPY GPCPYSRCG,GPSDINCCPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Industries
      *****************************************************************
     C     GLOB_SDINDSPD BEGSR
      /COPY GPCPYSRCG,GPSDINDSPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Loan Type/Sub Types
      *****************************************************************
     C     GLOB_SDLOANPD BEGSR
      /COPY GPCPYSRCG,GPSDLOANPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Location Codes
      *****************************************************************
     C     GLOB_SDLOCNPD BEGSR
      /COPY GPCPYSRCG,GPSDLOCNPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Midas Modules Information
      *****************************************************************
     C     GLOB_SDMMIDPD BEGSR
      /COPY GPCPYSRCG,GPSDMMIDPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Nature Codes
      *****************************************************************
     C     GLOB_SDNATUPD BEGSR
      /COPY GPCPYSRCG,GPSDNATUPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Nostro Codes
      *****************************************************************
     C     GLOB_SDNOSTPD BEGSR
      /COPY GPCPYSRCG,GPSDNOSTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                               CGL135A
      *****************************************************************                      CGL135A
      * Global Updates - Nostro Codes Extension file                                         CGL135A
      *****************************************************************                      CGL135A
     C     GLOB_SDNOST2D BEGSR                                                               CGL135A
      /COPY GPCPYSRCG,GPSDNOST2D                                                             CGL135A
     C                   ENDSR                                                               CGL135A
      *****************************************************************                      CGL135A
      /SPACE 5
      *****************************************************************
      * Global Updates - Pulldown List Headers
      *****************************************************************
     C     GLOB_SDPDWHPD BEGSR
      /COPY GPCPYSRCG,GPSDPDWHPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Pulldown Lists
      *****************************************************************
     C     GLOB_SDPDWNPD BEGSR
      /COPY GPCPYSRCG,GPSDPDWNPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Instrument Types
      *****************************************************************
     C     GLOB_SDPLINPD BEGSR
      /COPY GPCPYSRCG,GPSDPLINPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Profit Centres
      *****************************************************************
     C     GLOB_SDPRFCPD BEGSR
      /COPY GPCPYSRCG,GPSDPRFCPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                      BUG3122
      * Global Updates - Securities customer details                                         BUG3122
      *****************************************************************                      BUG3122
     C     GLOB_SDSECSPD BEGSR                                                               BUG3122
      /COPY GPCPYSRCG,GPSDSECSPD                                                             BUG3122
     C                   ENDSR                                                               BUG3122
      *****************************************************************                      BUG3122
      /SPACE 5                                                                               BUG3122
      *****************************************************************
      * Global Updates - SE ICD
      *****************************************************************
     C     GLOB_SDSTRDPD BEGSR
      /COPY GPCPYSRCG,GPSDSTRDPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CDL038
      *****************************************************************                       CDL038
      * Global Updates - Transaction Classes                                                  CDL038
      *****************************************************************                       CDL038
     C     GLOB_SDTCLSPD BEGSR                                                                CDL038
      /COPY GPCPYSRCG,GPSDTCLSPD                                                              CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /SPACE 5
      *****************************************************************
      * Global Updates - Yield Curves
      *****************************************************************
     C     GLOB_SDYLDCPD BEGSR
      /COPY GPCPYSRCG,GPSDYLDCPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Yield Rates
      *****************************************************************
     C     GLOB_SDYLDRPD BEGSR
      /COPY GPCPYSRCG,GPSDYLDRPD
     C                   ENDSR
      *****************************************************************                       CAP205
      /SPACE 5                                                                                CAP205
      *****************************************************************                       CAP205
     C     GLOB_SDSVALPD BEGSR                                                                CAP205
      /COPY GPCPYSRCG,GPSDSVALPD                                                              CAP205
     C                   ENDSR                                                                CAP205
      *****************************************************************                    BUG27844A
      /SPACE 5                                                                             BUG27844A
      *****************************************************************                    BUG27844A
     C     GLOB_SDHOLPD  BEGSR                                                             BUG27844A
      /COPY GPCPYSRCG,GPSDHOLPD                                                            BUG27844A
     C                   ENDSR                                                             BUG27844A
      *****************************************************************                       CSD093
      /SPACE 5                                                                                CSD093
      *****************************************************************                       CSD093
      * Global Updates - Document Management                                                  CSD093
      *****************************************************************                       CSD093
     C     GLOB_SDDCMTPD BEGSR                                                                CSD093
      /COPY GPCPYSRCG,GPSDDCMTPD                                                              CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD093
      /SPACE 5                                                                                CSD093
      *****************************************************************                       CSD093
      * Global Updates - Document Management Comment History                                  CSD093
      *****************************************************************                       CSD093
     C     GLOB_SDDMCHPD BEGSR                                                                CSD093
      /COPY GPCPYSRCG,GPSDDMCHPD                                                              CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD093
      /SPACE 5                                                                                CSD093
      *****************************************************************                       CSD093
      * Global Updates - Document Code                                                        CSD093
      *****************************************************************                       CSD093
     C     GLOB_SDDOCMPD BEGSR                                                                CSD093
      /COPY GPCPYSRCG,GPSDDOCMPD                                                              CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD092
      /SPACE 5                                                                                CSD092
      *****************************************************************                       CSD092
      * Global Updates - Account Review Main File                                             CSD092
      *****************************************************************                       CSD092
     C     GLOB_SDACRVPD BEGSR                                                                CSD092
      /COPY GPCPYSRCG,GPSDACRVPD                                                              CSD092
     C                   ENDSR                                                                CSD092
      *****************************************************************                       CSD092
      /SPACE 5                                                                                CSD092
      *****************************************************************                       CSD092
      * Global Updates - Account Review Comment History                                       CSD092
      *****************************************************************                       CSD092
     C     GLOB_SDARCHPD BEGSR                                                                CSD092
      /COPY GPCPYSRCG,GPSDARCHPD                                                              CSD092
     C                   ENDSR                                                                CSD092
      *****************************************************************                       CSD092
      /SPACE 5                                                                                CSD092
      *****************************************************************                       CSD092
      * Global Updates - Accounts Review                                                      CSD092
      *****************************************************************                       CSD092
     C     GLOB_SDHCIDPD BEGSR                                                                CSD092
      /COPY GPCPYSRCG,GPSDHCIDPD                                                              CSD092
     C                   ENDSR                                                                CSD092
      *****************************************************************                       CSD092
      /SPACE 5                                                                                CSD092
      *****************************************************************                       CSD092
      * Global Updates - Accounts Review                                                      CSD092
      *****************************************************************                       CSD092
     C     GLOB_SDHCINPD BEGSR                                                                CSD092
      /COPY GPCPYSRCG,GPSDHCINPD                                                              CSD092
     C                   ENDSR                                                                CSD092
      *****************************************************************
      /SPACE 5                                                                                CGL132
      *****************************************************************                       CGL132
      * Global Updates - FATCA High Value Account Amounts                                     CGL132
      *****************************************************************                       CGL132
     C     GLOB_SDFTHAPD BEGSR                                                                CGL132
      /COPY GPCPYSRCG,GPSDFTHAPD                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /SPACE 5                                                                                CGL132
      *****************************************************************                       CGL132
      * Global Updates - FATCA Customer Details File                                          CGL132
      *****************************************************************                       CGL132
     C     GLOB_SDFTCSPD BEGSR                                                                CGL132
      /COPY GPCPYSRCG,GPSDFTCSPD                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /SPACE 5                                                                              MD026518
      *****************************************************************                     MD026518
      * Global Updates - FATCA classification codes                                         MD026518
      *****************************************************************                     MD026518
     C     GLOB_SDFATCPD BEGSR                                                              MD026518
      /COPY GPCPYSRCG,GPSDFATCPD                                                            MD026518
     C                   ENDSR                                                              MD026518
      *****************************************************************                     MD026518
      /SPACE 5                                                                                CMG003
      *****************************************************************                       CMG003
      * Global Updates - Commodity Details                                                    CMG003
      *****************************************************************                       CMG003
     C     GLOB_SDCMDTPD BEGSR                                                                CMG003
      /COPY GPCPYSRCG,GPSDCMDTPD                                                              CMG003
     C                   ENDSR                                                                CMG003
      *****************************************************************                       CMG003
      /SPACE 5                                                                               CGL145A
      *****************************************************************                      CGL145A
      * Global Updates - Forecast Static Data Table                                          CGL145A
      *****************************************************************                      CGL145A
     C     GLOB_SDFCSDTD BEGSR                                                               CGL145A
      /COPY GPCPYSRCG,GPSDFCSDTD                                                             CGL145A
     C                   ENDSR                                                               CGL145A
      *****************************************************************                      CGL145A
      /SPACE 5                                                                              MD025828
      *****************************************************************                     MD025828
      * Global Updates - Customer Extension SWIFT Details                                   MD025828
      *****************************************************************                     MD025828
     C     GLOB_SDCSSWPD BEGSR                                                              MD025828
      /COPY GPCPYSRCG,GPSDCSSWPD                                                            MD025828
     C                   ENDSR                                                              MD025828
      *****************************************************************                     MD025828
      /SPACE 5                                                                                CGL153
      *****************************************************************                       CGL153
      * Global Updates - Estimated Exchange Rate                                              CGL153
      *****************************************************************                       CGL153
     C     GLOB_SDEERTTD BEGSR                                                                CGL153
      /COPY GPCPYSRCG,GPSDEERTTD                                                              CGL153
     C                   ENDSR                                                                CGL153
      *****************************************************************                       CGL153
      /SPACE 5
      *****************************************************************                       CGL155
      * Global Updates - Nostro Group Codes Detail                                            CGL155
      *****************************************************************                       CGL155
     C     GLOB_SDNGLDTD BEGSR                                                                CGL155
      /COPY GPCPYSRCG,GPSDNGLDTD                                                              CGL155
     C                   ENDSR                                                                CGL155
      *****************************************************************                       CGL155
      /SPACE 5                                                                                CGL155
      *****************************************************************                       CGL155
      * Global Updates - Nostro Group Codes Header                                            CGL155
      *****************************************************************                       CGL155
     C     GLOB_SDNGLHTD BEGSR                                                                CGL155
      /COPY GPCPYSRCG,GPSDNGLHTD                                                              CGL155
     C                   ENDSR                                                                CGL155
      *****************************************************************                       CLE164
      * Global Updates -  PDP Priority Group                                                  CLE164
      *****************************************************************                       CLE164
     C     GLOB_SDPRGPTD BEGSR                                                                CLE164
      /COPY GPCPYSRCG,GPSDPRGPTD                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      * Global Updates -  Repayment Priority Key                                              CLE164
      *****************************************************************                       CLE164
     C     GLOB_SDRPKYTD BEGSR                                                                CLE164
      /COPY GPCPYSRCG,GPSDRPKYTD                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      * Global Updates - PDP Repayment Matrix                                                 CLE164
      *****************************************************************                       CLE164
     C     GLOB_SDMTRXTD BEGSR                                                                CLE164
      /COPY GPCPYSRCG,GPSDMTRXTD                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      * Global Updates - Branch Code Extension Details                                        CGL052
      *****************************************************************                       CGL052
     C     GLOB_SDBRCHX0 BEGSR                                                                CGL052
      /COPY GPCPYSRCG,GPSDBRCHX0                                                              CGL052
     C                   ENDSR                                                                CGL052
      *****************************************************************                       CER073
      * Global Updates - AnaCredit Reporting                                                  CER073
      *****************************************************************                       CER073
     C     GLOB_SDANACQD BEGSR                                                                CER073
      /COPY GPCPYSRCG,GPSDANACQD                                                              CER073
     C                   ENDSR                                                                CER073
      *****************************************************************                     MD050231
      /SPACE 5                                                                              MD050231
      *****************************************************************                     MD050231
      * Global Updates - CRS Customer Details                                               MD050231
      *****************************************************************                     MD050231
     C     GLOB_SDCRSDPD BEGSR                                                              MD050231
      /COPY GPCPYSRCG,GPSDCRSDPD                                                            MD050231
     C                   ENDSR                                                              MD050231
      *****************************************************************                     MD050231
      /SPACE 5                                                                              MD050231
      *****************************************************************                     MD050231
      * Global Updates - CRS Customer Details                                               MD050231
      *****************************************************************                     MD050231
     C     GLOB_SDCRSHPD BEGSR                                                              MD050231
      /COPY GPCPYSRCG,GPSDCRSHPD                                                            MD050231
     C                   ENDSR                                                              MD050231
      *****************************************************************                     MD050231
      /SPACE 5                                                                              MD050231
      *****************************************************************                     MD050231
      * Global Updates - Country of Tax Code                                                MD050231
      *****************************************************************                     MD050231
     C     GLOB_SDCTTXPD BEGSR                                                              MD050231
      /COPY GPCPYSRCG,GPSDCTTXPD                                                            MD050231
     C                   ENDSR                                                              MD050231
      *****************************************************************                     MD050212
      * Global Updates - Customer Extension C Details                                       MD050212
      *****************************************************************                     MD050212
     C     GLOB_SDCUSTXC BEGSR                                                              MD050212
      /COPY GPCPYSRCG,GPSDCUSTXC                                                            MD050212
     C                   ENDSR                                                              MD050212
      *****************************************************************                       CGL155
      /SPACE 5                                                                                CGL155
      *****************************************************************
      * Determine Updates
      *****************************************************************
     C     DET_UPDATES   BEGSR
 
     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************                    BG6438
      * SDCURR - Set up fields                                                                BG6438
      ********************************************************************                    BG6438
     C     SDCURR        BEGSR                                                                BG6438
                                                                                              BG6438
      * Move SDCURRPD fields into layout for GPMLCSPD                                         BG6438
      * Currency                                                                              BG6438
     C                   EVAL      CCYCODE = A6CYCD                                           BG6438
      * Number of decimal places                                                              BG6438
     C                   EVAL      CCYNDEC  = A6NBDP                                          BG6438
      * Zone                                                                                  BG6438
     C                   EVAL      CCYZONE    = A6ZONE                                        BG6438
      * Spot Rate                                                                             BG6438
     C                   IF        A6MDIN = 'D'                                               BG6438
     C     1             DIV       A6SPRT        CCYSRATE                                     BG6438
     C                   ELSE                                                                 BG6438
     C                   Z-ADD     A6SPRT        CCYSRATE                                     BG6438
     C                   ENDIF                                                                BG6438
                                                                                              BG6438
     C                   ENDSR                                                                BG6438
      ********************************************************************                    BG6438
     C/SPACE 5                                                                                BG6438
      ********************************************************************                    BG6438
      * Set output fields for a local customer                                                BG6438
      ********************************************************************                    BG6438
     C     SET_OUT_CUST  BEGSR                                                                BG6438
                                                                                              BG6438
      * Get zone                                                                              BG6438
     C                   Z-ADD     1             #X                                           BG6438
     C     BBBRCD        LOOKUP    #_BR(#X)                               98                  BG6438
     C                   EVAL      Zone_ID  = #_ZN(#X)                                        BG6438
                                                                                              BG6438
B     * Branch                                                                                BG6438
     C                   EVAL      CGBRCD   = BBBRCD                                          BG6438
B     * Customer Number                                                                       BG6438
     C                   EVAL      CGCUST   = BBCUST                                          BG6438
     C                   MOVE      BBCUST        CGCNUM                                       BG6438
B     * Global Customer ID                                                                    BG6438
     C                   EVAL      CGGLOB   = BBBRCD + '-' + BBCUST                           BG6438
B     * Customer Shortname                                                                    BG6438
     C                   EVAL      CGCSSN   = BBCSSN                                          BG6438
B     * Cust. Name & Address 1                                                                BG6438
B     * Cust. Name & Address 2                                                                BG6438
B     * Cust. Name & Address 3                                                                BG6438
B     * Cust. Name & Address 4                                                                BG6438
     C                   EVAL      CGNA1    = BBCNA1                                          BG6438
     C                   EVAL      CGNA2    = BBCNA2                                          BG6438
     C                   EVAL      CGNA3    = BBCNA3                                          BG6438
     C                   EVAL      CGNA4    = BBCNA4                                          BG6438
B     * Customer Report Name                                                                  BG6438
B     * Customer Report Town                                                                  BG6438
     C                   EVAL      CGRNM    = BBCRNM                                          BG6438
     C                   EVAL      CGRTN    = BBCRTN                                          BG6438
B     * Bank/non-bank Indicator                                                               BG6438
     C                   EVAL      CGNBI    = BBBNBI                                          BG6438
B     * Global Industry Code                                                                  BG6438
     C     GPINDSXK      CHAIN     GPINDSXL0                          98                      BG6438
     C                   EVAL      CGICD    = IDGIND                                          BG6438
B     * Global Account Officer Code                                                           BG6438
     C     GPACOFXK      CHAIN     GPACOFXL0                          98                      BG6438
     C                   EVAL      CGACO    = ACGACO                                          BG6438
B     * Country of Citizenship                                                                BG6438
B     * Country of Location                                                                   BG6438
     C                   EVAL      CGCNCZ   = BBCNCZ                                          BG6438
     C                   EVAL      CGCOLC   = BBCOLC                                          BG6438
B     * Date Deleted                                                                          BG6438
     C                   EVAL      CGDTDL   = BBDTDL                                          BG6438
B     * Zone                                                                                  BG6438
     C                   EVAL      CGZONE   = Zone_ID                                         BG6438
B     * SWIFT Financial Inst Ind                                                              BG6438
     C                   IF        BBSWFI = 'Y'                                               BG6438
     C                   EVAL      CGSWFI   = 'Y'                                             BG6438
     C                   ELSE                                                                 BG6438
     C                   EVAL      CGSWFI   = 'N'                                             BG6438
     C                   ENDIF                                                                BG6438
B     * Status                                                                                BG6438
     C**********         IF        BBDTDL > 0                                          BG6438 249077
     C**********         IF        BBCLST = 'Y'                                      249077 BUG18631
     C                   IF        BBDTDL > 0  OR BBCLST = 'Y'                              BUG18631
     C                   EVAL      STATUS   = 'C'                                             BG6438
     C                   ELSE                                                                 BG6438
     C                   EVAL      STATUS   = 'L'                                             BG6438
     C                   ENDIF                                                                BG6438
B     * Local Customer Shortname                                                             BG6438R
     C                   EVAL      CGLCSSN = BBCSSN                                          BG6438R
B                                                                                            BG6438R
      *                                                                                       CER043
      ** Local Customer Report Name                                                           CER043
      *                                                                                       CER043
     C                   EVAL      CGLRNM = BBCRNM                                            CER043
      *                                                                                       CER043
      ** Local Customer Report Town                                                           CER043
      *                                                                                       CER043
     C                   EVAL      CGLRTN = BBCRTN                                            CER043
      *                                                                                       CSF011
      ** Local Customer SWIFT Id                                                              CSF011
      *                                                                                       CSF011
     C                   EVAL      CGCSID = BBCSID                                            CSF011
      *                                                                                       CER043
     C                   ENDSR                                                                BG6438
      ********************************************************************                    BG6438
     C/SPACE 5                                                                                BG6438
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
                                                                                             BUG7825
      * Override SDBRCHL0 SHARE(*NO)                                                         BUG7825
                                                                                             BUG7825
     C                   CALL      'QCMDEXC'                            9999                 BUG7825
     C                   PARM                    CMDSTR(1)                                   BUG7825
     C                   PARM      32            CMDLEN                                      BUG7825
                                                                                             BUG7825
     C                   IF        *IN99 = *ON                                               BUG7825
     C                   EXSR      *PSSR                                                     BUG7825
     C                   ENDIF                                                               BUG7825
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
                                                                                              BG6438
      * Delete Override SDBRCHL0                                                             BUG7825
                                                                                             BUG7825
     C                   CALL      'QCMDEXC'                            9999                 BUG7825
     C                   PARM                    CMDSTR(2)                                   BUG7825
     C                   PARM      21            CMDLEN                                      BUG7825
                                                                                             BUG7825
     C                   IF        *IN99 = *ON                                               BUG7825
     C                   EXSR      *PSSR                                                     BUG7825
     C                   ENDIF                                                               BUG7825
                                                                                             BUG7825
      * Open for commit?                                                                      BG6438
     C                   CALL      'GPCOPN4COM'                                               BG6438
     C                   PARM                    D_COM             1                          BG6438
     C                   OPEN      GPMLCSL0                                                   BG6438
O    C**********         OPEN      GPGLCUSLL1                                        BG6438 AR547326
                                                                                              BG6438
     C                   Z-ADD     0             #X                3 0                        BG6438
                                                                                              BG6438
      * Read all branches                                                                     BG6438
     C     *LOVAL        SETLL     SDBRCHD0                                                   BG6438
     C                   READ      SDBRCHD0                               98                  BG6438
                                                                                              BG6438
      * For each branch                                                                       BG6438
     C     *IN98         DOWEQ     *OFF                                                       BG6438
                                                                                              BG6438
      * Add branch & zone to arrays                                                           BG6438
     C                   ADD       1             #X                                           BG6438
     C                   MOVEL     A8BRCD        #_BR(#X)                                     BG6438
     C                   MOVEL     A8ZONE        #_ZN(#X)                                     BG6438
                                                                                              BG6438
      * Read next branch                                                                      BG6438
     C                   READ      SDBRCHD0                               98                  BG6438
     C                   ENDDO                                                                BG6438
O                                                                                             BG6438
O     * Key lists                                                                             BG6438
O    C     K_SDCUSTL1    KLIST                                                                BG6438
O    C                   KFLD                    BBBRCD                                       BG6438
O    C                   KFLD                    SBBCUST                                      BG6438
     C     GPACOFXK      KLIST                                                                BG6438
     C                   KFLD                    Zone_ID                                      BG6438
     C                   KFLD                    BBACOC                                       BG6438
     C     GPINDSXK      KLIST                                                                BG6438
     C                   KFLD                    Zone_ID                                      BG6438
     C                   KFLD                    BBLICD                                       BG6438
     C     GPCUSTXK      KLIST                                                                244057
     C                   KFLD                    BBBRCD                                       244057
     C                   KFLD                    BBCUST                                       244057
                                                                                              BG6438
     C                   MOVE      *BLANK        Zone_ID          10                          BG6438
 
     C                   ENDSR
      *****************************************************************                     AR547326
      * OPENFILE - Put override, no share and open input files        *                     AR547326
      *****************************************************************                     AR547326
     C     OPENFILE      BEGSR                                                              AR547326
     C                   MOVEA     CmdArray(1)   Cmd                                        AR547326
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPGLCUSLL1'                         AR547326
     C                   Z-ADD     80            Len                                        AR547326
     C                   CALL      'QCMDEXC'                                                AR547326
     C                   PARM                    Cmd                                        AR547326
     C                   PARM                    Len                                        AR547326
                                                                                            AR547326
     C                   OPEN      GPGLCUSLL1                                               AR547326
                                                                                            AR547326
     C                   ENDSR                                                              AR547326
     C/SPACE 5                                                                              AR547326
      *****************************************************************                     AR547326
      * CLOSEFIL - Delete overrides and close input files             *                     AR547326
      *****************************************************************                     AR547326
     C     CLOSEFIL      BEGSR                                                              AR547326
     C                   CLOSE     GPGLCUSLL1                                               AR547326
                                                                                            AR547326
     C                   MOVEA     CmdArray(2)   Cmd                                        AR547326
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPGLCUSLL1'                         AR547326
     C                   Z-ADD     80            Len                                        AR547326
     C                   CALL      'QCMDEXC'                                                AR547326
     C                   PARM                    Cmd                                        AR547326
     C                   PARM                    Len                                        AR547326
     C                   ENDSR                                                              AR547326
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
**  CMDSTR                                                                                   BUG7825
OVRDBF FILE(SDBRCHL0) SHARE(*NO)                                                             BUG7825
DLTOVR FILE(SDBRCHL0)                                                                        BUG7825
** CmdArray
OVRDBF FILE(          ) SHARE(*NO)                                                          AR547326
DLTOVR FILE(          )                                                                     AR547326
