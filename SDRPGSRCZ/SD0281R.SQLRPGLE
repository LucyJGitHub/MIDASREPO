     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*OVR *  OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0)                      *                       CGP001
/*OVR *  OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0)                      *                       CGP001
/*OVR *: OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                   : *                       CSD031
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas SD Edit loan type (Fr) (backup copy - orig)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0281R - Loan Type/Subtype Maintenance.                     *
      *                                                               *
      *  Function:  This program allows users to Maintain the         *
      *             loan types/subtypes defined to the system.        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 250590             Date 02Aug22               *
      *  Prev Amend No. 250113             Date 24Jun22               *
      *                 250391             Date 22Jun22               *
      *                 MD059608           Date 18Feb22               *
      *                 AR635013           Date 17Feb22               *
      *                 260748             Date 17Feb22               *
      *                 MD056555           Date 31Aug20               *
      *                 MD057859           Date 07Apr21               *
      *                 CSD103             Date 10Aug20               *
      *                 MD055496           Date 18Mar20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD031376           Date 21Nov14               *
      *                 MD031375           Date 21Nov14               *
      *                 CLE164             Date 18Aug14               *
      *                 MD022352           Date 16Sep13               *
      *                 AR1090451          Date 05Mar13               *
      *                 AR826996           Date 09Nov12               *
      *                 AR1022007          Date 23Aug12               *
      *                 AR467421           Date 02Aug12               *
      *                 263077             Date 02Aug12               *
      *                 262383             Date 02Aug12               *
      *                 CLE134             Date 02Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR795973           Date 06Jul11               *
      *                 AR690841           Date 28Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24706           Date 01Jul09               *
      *                 CER047             Date 19May08               *
      *                 CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG21948           Date 11Dec08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13768           Date 23Apr07               *
      *                 BUG7817A           Date 11Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243349             Date 13Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12876           Date 07Nov06               *
      *                 242069             Date 18Sep06               *
      *                 240953             Date 13Sep06               *
      *                 BUG12557           Date 07Nov06               *
      *                 BUG11799           Date 30Jul06               *
      *                 BUG11758           Date 27Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG7817R           Date 17Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10606           Date 17Feb06               *
      *                 BUG10601           Date 16Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG7817            Date 29Jul05               *
      *                 CER001             Date 25Apr05               *
      *                 231566             Date 10Jan05               *
      *                 CAS009             Date 04May04               *
      *                 BUG6307            Date 18Mar05               *
      *                 228390             Date 14Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL014             Date 20Oct03               *
      *                 CAAA03             Date 24Mar04               *
      *                 BG1346             Date 01Mar04               *
      *                 CGP001             Date 23May03               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184197             Date 14Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 127056             Date 27Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             DATE 28Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 133794             Date 30Apr98               *
      *                 CPL002             Date 08Mar99               *
      *                 CLE005             Date 22May97               *
      *                 CSD003             Date 27OCT97               *
      *                 CLE004             DATE 17FEB97               *
      *                 CAC001 (2)         DATE 23JAN96               *
      *                 080769 (2)         DATE 28APR95               *
      *                 S01486 (2)         DATE 22DEC94               *
      *                 S01505             DATE 08JUL94               *
      *                 S01486             DATE 08JUL94               *
      *                 S01459             DATE 08JUL94               *
      *                 031807             DATE 22SEP92               *
      *                 S01117             DATE 10AUG90               *
      *                 S01212             DATE 14SEP90               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  250590 - System does not accept valid loan no. range when    *
      *           entering loan type/subtype.                         *
      *  250113 - Condition Internal Loan Participation Class (CLE042)*
      *           on Syndications being switched on as well           *
      *           Recompile because of changes to SD0281R#            *
      *  250391 - Loan class should be used as a key so that same     *
      *           loan type and subtype but with different classes    *
      *           are allowed to be inserted.                         *
      *  MD059608 - Set numeric field AYEACC to zero if CSD042 is     *
      *             off to prevent decimal data error.                *
      *  AR635013 - Cannot enter Loan type/subtype for processing 70, *
      *             71 and 72. Allow blank value for processing type  *
      *             70-72.                                            *
      *  260748 - Default the "Amortised Cost Accounting Ind" to 'N'  *
      *           if CAS009 is on.                                    *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD057859 - Allow alphanumeric base rate code in the input    *
      *             of default principal and interest base rate.      *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD055496 - Use a new message id USS1001/USS1002. ILP Type/   *
      *             subtype is mandatory for types 61,62,63,70 and    *
      *             when CLE106 is switched on.                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031376 - Fix the validation of PDCL loan type/sub-type.    *
      *  MD031375 - Prevent showing the screen twice.                 *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD022352 - Error message encountered when Spread Indicator is*
      *             not blank and Base Rate & Spread Rate are not both*
      *             entered. Also, display issue encountered due to   *
      *             reused indicators 62 and 63.                      *
      *             Amended the validation so if Spread Indicator is  *
      *             not blank and either 1 of Base Rate or Spread rate*
      *             is entered, the system will accept it. Also       *
      *             changed the reused indicators 62 and 63 to 65 and *
      *             67 respectively.                                  *
      *  AR1090451 - Default Rate Indicator should be prompted or     *
      *              must have values only if Base Rate Code & Spread *
      *              Rate (Contractual Spread) OR Base Rate & Spread  *
      *              Rate (Contractual Spread) are non-zero; if       *
      *              Spread Indicator is not specified by the user,   *
      *              it is always defaulted to 'A'                    *
      *  AR826996 - Validate Base Rate Code + Currency in SDBSRTPD    *
      *             (Child: AR826997)                                 *
      *  AR1022007 - [PDP] CC001 - Incorporate SM007 in PDP           *
      *  AR467421 - AYPRSP & AYPRSI mandatory if other PDCL fields    *
      *             have been entered. Also they must be 'A', 'S' or  *
      *             'P', not 'A' or 'D'. (Child: AR467422)            *
      *  263077 - Fields not initialised correctly on insert.         *
      *           CLE134 / SWIFT                                      *
      *  262383 - (CLE134) Past Due Loan Type/subtype shoudn't be     *
      *           mandatory.                                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR795973 - Change §24c to plain 24c (Recompile)              *
      *  AR690841 - Check if Loan Class exist in SDTCLSPD.            *
      *             (Child: AR690842)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT042 Cannot amend loan type sub-type.              *
      *  BUG24706 - Subject to 24c KWG Reporting field is not present *
      *           and does not store any value                        *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CSC043 - MidasPlus IASP Enablement                           *
      *  BUG21948 - Loan type subtype deletion error                  *
      *  BUG13768 - External field name entry is longer than six(6)   *
      *             characters                                        *
      *  BUG7817A - Rename LELOAML9 to LELOAMLE                       *
      *  243349 - Do not allow deletion of loan type/sub-type if      *
      *           attached to a loan.                                 *
      *         - Patterned after fix 241827                          *
      *  BUG12876 - Amortization Cost Account Indicator not reflected *
      *             if zonal layer.                                   *
      *  242069 - Loan Class should be part of key field for TABLET6  *
      *  240953 - Record updated by another workstation due to #1DBRC *
      *           Verify length of SDLOANL0 first. (99 for MP1.2)     *
      *           (108 for MP1.2.1)                                   *
      *  BUG12557 - Amortization Cost Account Indicator not reflected *
      *             if global to zone layer.                          *
      *  BUG11799 - DB error on amend and delete mode                 *
      *  BUG11758 - Indicator conflict on screen fields               *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG7817R - Do not allow loan type/subtype deletion if a loan *
      *             amendment also uses the record. (Reopen)          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10606 - Indicator used by CAS009 is in conflict with      *
      *             CGP001                                            *
      *  BUG10601 - Class should only be processed if CLE042 is       *
      *             enabled                                           *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG7817 - WEBFACE: LOAN TYPE SUBTYPE - able to delete        *
      *            loan type/subtype even if still in use.            *
      *            Provided validation for active loan type/subtype   *
      *            during Delete Mode.                                *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  231566 - Additional Validation For ACAI in Loan type MNT     *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  BUG6307- Global Product and Instrument should be non-manda-  *
      *           tory.                                               *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CLE025 - Credit Lines                                        *
      *  CGL014 - Collateral Processing                               *
      *  CAAA03 - Webfacing changes. F10 button appears during amend  *
      *           mode on webfaced screen.                            *
      *  BG1346 - Global instrument and product code not displayed    *
      *           (Display file changed and overrides changed)        *
      *  CGP001 - Global Processing                                   *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  184197 - Rename error messages for Plato fields              *
      *  127056 - If CLE004 is not on, WULE06 must be 'N' not blank.  *
      *  CPB001 - 'Private Banking' Module                            *
      *  133794 - MSGID USR5613 is missing in GBSDUSRMSG file         *
      *  CPL002 - Midas-Plato Interface                               *
      *           Addition of Plato details to PF/SDLOANPD.           *
      *  CLE005 - Customer Lending Enhancements - Tranche 3           *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CLE004 - Lending Enhancements:                               *
      *           Addition of 3 new fields.                           *
      *  CAC001 - Profit Centre Accounting.                           *
      *           S01505 changes removed.
      *  080769 - Instrument code should be mandatory.                *
      *  S01486 - (2) change control.                                 *
      *           Use only one Instrument Type for PM and PL modules, *
      *           Make (PM Instrument Code 'BWR') redundant.          *
      *  S01505 - Profit Centre Accounting Development:               *
      *           - Amend to display new 'Default Product Code' field.*
      *  S01486 - Private Banking Development:                        *
      *           - Amend to display new portfolio management fields. *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  031807 - The Return Code should be specified in Factor 1     *
      *           of the parameter field, else the program will not   *
      *           detect an error in the Background Update program.   *
      *  S01117 - Release 10 changes.                                 *
      *  S01212 - Local Returns /COPY incorporation.                  *
      *                                                               *
      *****************************************************************
     F*
     F/COPY WNCPYSRC,SD0281RFPG
     F*
     FSD0281R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Loan type/subtype maintenance
      *
     FSDLOANL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Loan types/sub-types retrieval
      *
     FSDLENOL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Loan Number Ranges        Retrieval index
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     FSDLOANL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Loan types/sub-types update
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
      *
     FGPPRDXL0  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(GPPRODXD0:GPPRDXD0)
     F                                     COMMIT
      ** Midas GP Global Products X-Reference                                                 CGP001
     FGZSDBANK  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      ** Bank ICD Keyed on DNWD                                                               CSD031
      *                                                                                       CSD031
     FGPZONEL0  IF   E           K DISK
      ** Zone Files                                                                           CSD031
     FGPLOANL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      * UPD : Midas GP Loan types/sub-types update                                            CSD031
     FGPLOANL1  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:GPLOAND1)
      * UPD : Midas GP Loan types/sub-types update                                            CSD031
     FGPLENOL1  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      * RTV : Midas GP Loan Number Ranges        Retrieval index                              CSD031
     FSDALTSL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:SDALTSD0)
      * RTV : Midas SD Loan types/sub-types acceptance                                        CSD031
      *                                                                                       CGP001
     FGPINSXL0  UF A E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F                                     RENAME(GPINSTXD0:GPINSXD0)
     F                                     COMMIT
      ** Midas GP Global Instruments X-Reference                                              CGP001
      *                                                                                       CGP001
     F*CLOANL8*IF  E           K        DISK                                           CAS009 250391
      ***Customer*Loans*keyed*by*loan*type*and*sub-type***************                 CAS009 250391
      ****************************************************************                 CAS009 250391
     FCLOANL10  IF   E           K DISK                                                       250391
      ** Customer Loans keyed by loan type and sub-type and class (CLE042)                    250391
      *                                                                                       250391
     F*SCSARPL1* IF   E           K DISK                                                    MD056555
      ** Midas SC Switchable Feature Initialisation PGM index                                 231566
      *                                                                                       231566
     FCLOANML1  IF   E           K DISK                                                            B
     F                                     INFSR(*PSSR)                                            B
     F                                     RENAME(CLOANCLF:CLOANMLF)                               B
      *                                                                                      BUG7817
      ** Midas LE Customer Loans                                                             BUG7817
      *                                                                                      BUG7817
     F***LELOAML9IF  E        K        DISK                                         BUG7817 BUG7817A
     FLELOAMLE  IF   E           K DISK                                                           BU
     F                                     INFSR(*PSSR)                                            B
      *                                                                                      BUG7817
      ** Midas LE Customer Loans                                                             BUG7817
      *                                                                                      BUG7817
     FSDLNX1PD  UF   E           K DISK    USROPN                                                 BU
     F                                     INFSR(*PSSR)                                           BU
     F                                     COMMIT                                                 BU
      *                                                                                     BUG11799
      ** Extended Loan Type/Sub-type     Retrieval index       Prefix VI.                   BUG11799
      *                                                                                     BUG11799
     FCLOANBCL  IF   E           K DISK
     F                                     RENAME(CLOANCLF:CLLONCLF)
     FCLOANBMC  IF   E           K DISK
     F                                     RENAME(CLOANCLF:MCLONCLF)
     FCLOANL19  IF   E           K DISK                                                           AR
     F                                     RENAME(CLOANCLF:CLOAN19)                               AR
     FSDBSRTL2  IF   E           K DISK                                                           AR
      *                                                                                     AR690841
      ** Midas SD Transaction Classes                                                       AR690841
      *                                                                                     AR690841
     FSDTCLSL1  IF   E           K DISK                                                           AR
     F* Description     : Copyright notice for inclusion in all programs
     FSDPRGPI0  IF   E           K DISK
      ** Midas PDP Priority Group                                                             CLE164
     D*
     D********************************************************************
     D*
     D/COPY WNCPYSRC,SD0281REPG
     D*
     D**********          OVRC    1   2 80                                             CGP001 CSD031
     D OVRC            S             80    DIM(3) CTDATA PERRCD(1)
      ** Override Command Array                                                               CGP001
      *                                                                                       CGP001
      ** Loan Processing types, original/past due; valid combinations                         CLE134
      *                                                                                       CLE134
     D LNPTYP          S              4    DIM(7) CTDATA PERRCD(7)
      *                                                                                    AR1022007
      ** Arrays for calls to validation modules                                            AR1022007
      *                                                                                    AR1022007
     D AFLDNM          S             10    DIM(72)
     D AMSGID          S              7    DIM(72)
     D AMGDTA          S             45    DIM(72)
     D*
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D****/COPY QWINDSRC,QPE1DTA                                          S01229
     D/COPY QWINDSRC,SD0280GDTA                                           S01229
     D*
     D/COPY WNCPYSRC,SD0281RIPG
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D LDA             DS           256
      ** Local data area for database error details                                           CAS001
      *                                                                                       CAS001
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Dummy record format for access to Switchable Features Details                        CAS001
      *                                                                                       CAS001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure                                   CAS001
      *                                                                                       CAS001
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
     D  FYLDCA       E                     EXTFLD(FSYLDCA)                                        BU
      *                                                                                     BUG13768
      ** Dummy record format for access to Yield Curve files                                  CAS001
      *                                                                                       CAS001
     D @1DBRC        E DS                  EXTNAME(SDLOANL0)
      * UPD : Midas SD Loan types/sub-types update
      * Current/previous master file format fields for change control
      *
     D*#1DBRC******DS                             60                      CPL002
     D*#1DBRC******DS                             77                                   CPL002 CAS001
     D*#1DBRC***   DS                             88                                   CAS001 CAS005
     D*#1DBRC***      DS                             89                                CAS005 CAS009
     D*#1DBRC******DS                             90                                   CAS009 CLE042
     D*#1DBRC******DS                            108                                   CLE042 CSD031
     D***#1DBRC*     DS                            153                                 CSD031 CER047
     D***#1DBRC*     DS                            109                                 CER047 CER059
     D***#1DBRC*     DS                            144                                 CER059 CLE134
     D***#1DBRC*     DS                            200                              CLE134 AR1022007
     D #1DBRC          DS           236                                                          AR1
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D UUSDY         E DS                  EXTNAME(DSSDY)
     D*
     D* 800 byte DS for incoming data from Access Program
     D*
     D GPPROD        E DS                  EXTNAME(GPPRODPD)
     D  PDGLCD       E                     EXTFLD(PDLCD)
     D  PDGCHT       E                     EXTFLD(PDCHTP)
      ** Global Product Code Details Data Structure                                           CGP001
      *                                                                                       CGP001
     D GPINST        E DS                  EXTNAME(GPINSTPD)
      ** Global Instrument Code Details Data Structure                                        CGP001
      *                                                                                       CGP001
     D SDLOAN          DS
     D  A#LNPT                39     40
      ** Past Due Loan Types/Subtypes                                                         CLE134
      *                                                                                       CLE134
     D D@PLIN        E DS                  EXTNAME(SDPLINPD)
     D*
     D* DS TO HOLD DATA READ FROM FILE TO BE USED WITHIN THE PROGRAM
     D*
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YBRDCS          DS            22
     D*YCRDCS*****DS                             60                       CPL002
     D***YCRDCS******DS                             77                                 CPL002 240953
     D***YCRDCS******DS                         108                                    240953 CLE134
     D YCRDCS          DS           187
     D YDRDCS          DS            22
     D WUDSTT          DS
     D  WUPOS1                 1      1
     D  WUPOS2                 2      2
     D WUTDST          DS
     D  WULOC1                 1      1
     D  WULOC2                 2      2
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D PDQMSG          DS          4040
     D WDATED          DS
     D  WDD                    1      2
     D  WMM                    3      4
     D  WYY                    5      6
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *                                                                                       CSD031
      ** Bank details file                                                                    CSD031
      *                                                                                       CSD031
     D WDTQ            DS
     D  WPFNAM                 1     10
     D  WKEYS                 11     40
     D  WDATA                 41    296
     D                 DS
     D  DDATEC                 1      6
     D  DDATEN                 1      6  0
     D/COPY WNCPYSRC,SD0281RI01
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D YRSW0A          DS          9999
     D YRSW0B          DS          9999
     D YRSW0C          DS          9999
     D YRSW0D          DS          9999
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
     D ID0004          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS             8
     D*P1PARM*****DS******************************4                                           CLE042
      * KEY: Midas SD Loan types/sub-types retrieval
      * I : MAP Loan Type
     D  P1LNTY                 1      2
      * I : MAP Loan Sub-type
     D  P1LNST                 3      4
      * I : MAP Loan Class                                                                    CLE042
     D  P1LNCL                 5      8
      *                                                                                       CER001
     D DATALX          DS          1024
     D  #LNTY                  1      2
     D  #LNST                  3      4
     D  #LNCL                  5      8
      *                                                                                       CER001
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Key Field
     D  ZA0003                 2     11
      * Message data for 'Loan Type no Blanks'
      * Loan Type
     D  ZA0004                 1      2
      * Message data for 'Loan Type no Blanks'
      * Loan Type
     D  ZA0005                 1      2
      * Message data for 'Invalid Loan Type'
      * Loan Type
     D  ZA0006                 1      2
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0007                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0008                 1      1
      * Key Field
     D  ZA0009                 2     11
      * Message data for 'Loan Sub-Type no blanks'
      * Loan Sub-type
     D  ZA0010                 1      2
      * Message data for 'Loan Sub-Type no blanks'
      * Loan Sub-type
     D  ZA0011                 1      2
      * Message data for 'Description required'
      * Loan Type Description
     D  ZA0012                 1     30
      * Message data for 'loan processing type req'
      * Loan processing fun field
     D  ZA0013                 1      2
      * Message data for 'loan processing type num'
      * Loan processing fun field
     D  ZA0014                 1      2
      * Message data for 'Loan Processing Type'
      * Loan processing fun field
     D  ZA0015                 1      2
      * Message data for 'Instrument code is req'
      * PM Instrument Code (Lndr)
     D  ZA0016                 1      3
      * Message data for 'Instrument Code invald'
      * PM Instrument Code (Lndr)
     D  ZA0017                 1      3
      * Message data for 'Loan to be Valued Ind Inv'
      * Loan to be Valued Ind
     D  ZA0018                 1      1
      * Message data for 'Range No. (LT/ST)     INV'
      * Range Number (LT/ST)
     D  ZA0019                 1      2
      * Message data for 'Range No. (LT/ST)     INV'
      * Range Number (LT/ST)
     D  ZA0020                 1      2
      * Message data for 'Loan PTyp must be 62/63'
      * Internal Loan Part. Type
     D  ZA0021                 1      2
      * Internal Loan Part SubTyp
     D  ZA0022                 3      4
      * Internal Loan Part Class                                                              CLE042
     D  ZA0122                 5      8
      * Message data for 'Int Loan Pts Typ/Styp INV'
      * Internal Loan Part. Type
     D  ZA0023                 1      2
      * Internal Loan Part SubTyp
     D  ZA0024                 3      4
      * Internal Loan Part Class                                                              CLE042
     D  ZA0124                 5      8
      * Currency                                                                            AR826996
     D  ZA0125                 1      3                                                           AR
      * Base Rate Code                                                                      AR826996
     D  ZA0126                 4      5                                                           AR
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0025                 1     10
      *                                                                                     AR690841
      ** Message data for 'Loan Class not found'                                            AR690841
      *                                                                                     AR690841
     D  ZA0026                 1      4                                                           AR
     D GOPGM           C                   CONST('GOGETZONE')
     D GOMSG           C                   CONST('ERROR IN GOGETZONE')
      ** Global Processing Constants                                                          CGP001
      *                                                                                       CGP001
     D DTAQNM          C                   CONST('SDACCPDTQ')
     D**********    'XLIB/SDCSNDDTQ'      C         PGMB                               CSD031 CSC043
     D PGMB            C                   CONST('XPLIB/SDCSNDDTQ')
     D DIGITS          C                   CONST('0123456789')
     D ALPHAN          C                   CONST('0123456789ABCDEFGHI-
     D                                     JKLMNOPQRSTUVWXYZ*')
      *                                                                                       CLE134
     D P#LTST          DS
     D  #2PPLT                 1      2
     D  #2PPL1                 1      1
     D  #2PPLS                 3      4
     D  #2PPL2                 3      3                                                           MD
     D  #2PPLC                 5      8
     D  #2PPL3                 5      5                                                           MD
     D I#LTST          DS
     D  #2IPLT                 1      2
     D  #2IPL1                 1      1
     D  #2IPLS                 3      4
     D  #2IPL2                 3      3                                                           MD
     D  #2IPLC                 5      8
     D  #2IPL3                 5      5                                                           MD
      *                                                                                    AR1022007
     D YPLST           DS                                                                        AR1
     D  #YPCSP                 1     11                                                          AR1
     D  #YPCSG                12     12                                                          AR1
     D  #YPRMT                13     19                                                          AR1
     D  #YPRFD                20     23                                                          AR1
     D YILST           DS                                                                        AR1
     D  #YICSP                 1     11                                                          AR1
     D  #YICSG                12     12                                                          AR1
     D  #YIRMT                13     19                                                          AR1
     D  #YIRFD                20     23                                                          AR1
     D VALST           DS                                                                        AR1
     D  VALCSP                 1     11                                                          AR1
     D  VALCSG                12     12                                                          AR1
     D  VALRMT                13     19                                                          AR1
     D  VALRFD                20     23                                                          AR1
     D SCSARP        E DS                  EXTNAME(SCSRPJW0)                                MD056555
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Loan Types
     C     P2ANCD        PARM                    WP0001            1            Action Code
     C                   PARM                    P1MODE            1
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1LNTY        IFEQ      *BLANK                                       Loan Type
     C     #1LNST        OREQ      *BLANK                                       Loan Sub-type
     C     #1LNCL        OREQ      *BLANK                                       Loan Class
     C     CLE042        ANDEQ     'Y'
      * One or more key fields is blank
     C     *IN05         OREQ      '1'
      * HOME: Reset screen fields
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Switch between *ADD/*CHANGE modes
     C   09              CAS                     BCCHMD
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C                   EXSR      MAIZ#2
     C                   ENDIF
      *                                                                                       CLE134
     C     CRE073        IFEQ      'Y'
     C                   EXSR      MAIZ#3
     C                   ENDIF
      *                                                                                    AR1022007
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    AYLNTY                         Loan Type
     C                   KFLD                    AYLNST                         Loan Sub-type
     C                   KFLD                    AYLNCL                         Loan Class
      * Setup key
     C                   MOVEL     #1LNTY        AYLNTY                         Loan Type
     C                   MOVEL     #1LNST        AYLNST                         Loan Sub-type
     C                   MOVEL     #1LNCL        AYLNCL                         Loan Class
     C********** KRTV      CHAIN@AYRECL              9091  *                                  CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KRTV          CHAIN     GPLOANL1                           9091
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C     KRTV          CHAIN     SDLOANL1                           9091
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C     KRTV          CHAIN     SDALTSL0                           9091
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     KRTV          CHAIN     SDLOANL1                           9091
     C                   ENDIF
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * Verify record existence against program mode
     C     W0PMD         IFNE      'ADD'
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        993132    *
      * Send message 'Loan Types/Sub-types   NF'
     C                   MOVEL     'USR0055'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RSFF - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RSFF
     C*
     C                   END                                                    *FI
      * USER: Initialize detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RISE - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RISE
     C*
     C                   END                                                    *FI
      * Start of Fix S01117
     C                   MOVEL     AYLNPT        #DLPFF                         Loan processing
      * End of Fix S01117
      * Start CLE004
      * Set Display flag for Int. Loan Participation Type/subtype fields.
      * CASE: WRK.Switchable Feature CLE006 is Present
     C     WULE06        IFEQ      'Y'                                          *IF
      * CASE:
      *  - c1 AND c2
      *   |- c1    : DTL.Loan Processing Type is Not Equal 62
      *   |- c2    : DTL.Loan Processing Type is Not Equal 63
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1LNPT        IFNE      62                                           *IF
     C     #1LNPT        IFNE      63                                           *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     WULE05        IFEQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     61                                                          CLE00
     C     WULE05        OREQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     70                                                          CLE00
     C                   MOVEL     '0'           Y0CX01                                        CLE00
     C                   ENDIF                                                                 CLE00
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'N'           WUDILP                         Display Int Loa
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'Y'           WUDILP                         Display Int Loa
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUDILP                         Display Int Loa
     C                   END                                                    *FI
      * End CLE004
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        993132    *
      * Send message 'Loan Types/Sub-types   EX'
     C                   MOVEL     'USR0056'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * USER: Initialize detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RISN - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RISN
     C*
     C                   END                                                    *FI
      * Start CLE004
      * Set Display flag for Int. Loan Participation Type/subtype.
      * CASE: WRK.Switchable Feature CLE006 is Not Present
     C     WULE06        IFEQ      'N'                                          *IF
     C                   MOVEL     'N'           WUDILP                         Display Int Loa
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'Y'           WUDILP                         Display Int Loa
     C                   END                                                    *FI
      * End CLE004
     C                   END
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
     C     P2ANCD        IFEQ      'I'
     C     P2ANCD        OREQ      'A'
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C     #1K24C        ANDEQ     *BLANKS
      *                                                                                       CER047
     C                   MOVE      'Y'           #1K24C
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
     C                   ENDIF
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Start of Fix S01117
      * Loan Type
      * CASE: KEY.Loan Type is entered
     C     #1LNTY        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1LNTY        WUDSTT                         data structure
     C                   MOVEL     #1LNTY        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1LNTY        WUIVKF                         If value in key
     C                   MOVEL     #1LNTY        WUCLDG                         Check Loan Digi
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1LNTY        ZA0001                         Loan Type
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1LNTY        ZA0003                         Loan Type
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.Position One is Blank
     C     WUPOS1        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1LNTY        ZA0004                         Loan Type
      * Send message 'Loan Type no Blanks'
     C                   MOVEL     'USR0208'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.Position Two is Blank
     C     WUPOS2        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1LNTY        ZA0005                         Loan Type
      * Send message 'Loan Type no Blanks'
     C                   MOVEL     'USR0208'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.Check Loan Digit is Not H
     C     WUCLDG        IFNE      'H'                                          *IF
      * CASE: WRK.Check Loan Digit is Not J
     C     WUCLDG        IFNE      'J'                                          *IF
      * CASE: WRK.Check Loan Digit is Not K
     C     WUCLDG        IFNE      'K'                                          *IF
      *                                                                                       CLE134
     C     CLE134        IFEQ      'N'
      * Setup message data for message
     C                   MOVEL     #1LNTY        ZA0006                         Loan Type
      * Send message 'Invalid Loan Type'
     C                   MOVEL     'USR0089'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   MOVEL     '**ERR**'     W0RTN                          *Return code
     C                   ELSE
     C     WUCLDG        IFNE      'X'
     C     WUCLDG        ANDNE     'Y'
     C     WUCLDG        ANDNE     'Z'
     C                   MOVEL     #1LNTY        ZA0006
     C                   MOVEL     'USR5408'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931
     C                   MOVEL     '**ERR**'     W0RTN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Loan Sub-Type validation
      * CASE: KEY.Loan Sub-type is entered
     C     #1LNST        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1LNST        WUTDST                         Test data struc
     C                   MOVEL     #1LNST        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1LNST        WUIVKF                         If value in key
     C                   MOVEL     #1LNST        WUCLDG                         Check Loan Digi
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1LNST        ZA0007                         Loan Sub-type
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     WUIVKF        ZA0008                         If value in key
     C                   MOVEL     #1LNST        ZA0009                         Loan Sub-type
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.Location one is blank
     C     WULOC1        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1LNST        ZA0010                         Loan Sub-type
      * Send message 'Loan Sub-Type no blanks'
     C                   MOVEL     'USR0210'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.Location two is blank
     C     WULOC2        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1LNST        ZA0011                         Loan Sub-type
      * Send message 'Loan Sub-Type no blanks'
     C                   MOVEL     'USR0210'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Loan Class validation                                                                 CLE042
      * CASE: KEY.Loan Sub-type is entered                                                    CLE042
     C     CLE042        IFEQ      'Y'
     C     #1LNCL        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1LNCL        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark                                        CLE042
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message                                                        CLE042
     C                   MOVEL     #1LNCL        ZA0007                         Loan Sub-type
      * Send message 'Question Mark Invalid'                                                  CLE042
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *                                                                                     AR690841
     C                   ELSE
      *                                                                                     AR690841
      ** Check If Loan Class exists                                                         AR690841
      *                                                                                     AR690841
     C     #1LNCL        CHAIN     SDTCLSL1                           85
      *                                                                                     AR690841
     C     *IN85         IFEQ      '1'
      *                                                                                     AR690841
      ** Send Error Message If Loan Class not found                                         AR690841
      *                                                                                     AR690841
     C                   MOVEL     #1LNCL        ZA0026
     C                   MOVEL     'USR4930'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933
     C                   ENDIF
      *                                                                                     AR690841
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ENDIF
      * End of Fix S01117
      * Retrieve Loan Types/Subs - Loan Types/Sub-types  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Send message '*Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RVKS - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RVKS
     C*
     C                   END                                                    *FI
      * Loan Type required
     C     #1LNTY        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Loan Sub-type required
     C     #1LNST        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Loan Class required                                                                   CLE042
     C     CLE042        IFEQ      'Y'
     C     #1LNCL        IFEQ      *BLANK                                       IF
     C                   SETON                                        9933      *
      * Send message '*Value required'                                                        CLE042
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C                   ENDIF
     C/COPY WNCPYSRC,SD0281RC01
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
     C                   MOVE      '0'           *IN11
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   EXSR      MAIZ#1
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C                   EXSR      MAIZ#2
     C                   ENDIF
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C     CSD042        IFEQ      'Y'
     C                   SETOFF                                           86    *
     C                   ENDIF
     C                   MOVE      *IN89         CBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C     CSD042        IFEQ      'Y'
     C                   MOVE      'N'           WERR01
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   ENDIF
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RPKR - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RPKR
     C*
     C                   END                                                    *FI
      * Start of Fix S01117
      * Exit Previous Screen Processing
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of Fix S01117
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C  N10              CAS                     DCVLDL
      *                                                                                      BUG7817
      ** Validate Loan Type/Sub Type                                                         BUG7817
      *                                                                                      BUG7817
     C   10              CAS                     DDVLTP
     C                   END
      *                                                                                       CLE134
      ** Validate Detail Screen 2.                                                            CLE134
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     *IN10         ANDEQ     *OFF
     C     *IN11         ANDEQ     *OFF
     C                   EXSR      CFPRS2
      *                                                                                       CLE134
     C     *IN12         IFEQ      *ON
     C                   GOTO      CFEXIT
     C                   ENDIF
     C                   ENDIF
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  CFPRS2 - Process Detail Screen 2                             *                       CLE134
      *****************************************************************                       CLE134
     C     CFPRS2        BEGSR
      *                                                                                       CLE134
      ** Save indicators 31-50                                                                CLE134
      *                                                                                       CLE134
     C                   MOVEA     *IN(31)       INSV20           20
     C                   MOVE      *ZEROS        ZERO20           20
     C                   MOVEA     ZERO20        *IN(31)
     C                   MOVE      *OFF          *IN71
      *                                                                                       CLE134
      ** Set Protect Ind based on Loan Type Prefix/Processing Type.                           CLE134
      *                                                                                       CLE134
     C                   MOVEL     #1LNTY        #1LNT1            1
     C     #1LNT1        IFEQ      'H'
     C     #1LNT1        OREQ      'J'
     C     #1LNT1        OREQ      'K'
     C     #1LNPT        IFEQ      61
     C     #1LNPT        OREQ      62
     C     #1LNPT        OREQ      64
     C     #1LNPT        OREQ      66
     C     #1LNPT        OREQ      68
     C     #1LNPT        OREQ      69
     C     #1LNPT        OREQ      80
     C                   MOVE      *ON           *IN71
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Display/Process Screen 2 Until F12 Taken.                                            CLE134
      *                                                                                       CLE134
     C     *IN99         IFEQ      *OFF
      *                                                                                    AR1022007
     C     *IN12         DOUEQ     *ON
     C     *IN98         OREQ      *OFF
     C     W0DEF         ANDEQ     'N'
      *                                                                                       CLE134
     C                   WRITE     #MSGCTL
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C                   EXFMT     #RCDDTL3
     C                   ELSE
     C                   EXFMT     #RCDDTL2
     C                   ENDIF
      *                                                                                       CLE134
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *                                                                                       CLE134
     C     *IN12         IFEQ      *OFF
     C                   EXSR      DCVL21
      *                                                                                       CLE134
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     'N'           W0DEF
     C                   EXSR      DCVL22
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                       CLE134
      ** Restore indicators 31-50                                                             CLE134
      *                                                                                       CLE134
     C                   MOVEA     INSV20        *IN(31)
      *                                                                                       CLE134
     C                   ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * Validate Loan to be Valued Ind
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1LVLD        W0NSRQ            1            Loan to be Valu
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1180452       Y2LSNO            7 0
     C     #1LVLD        PARM      #1LVLD        W0EXVL           20            Loan to be Valu
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate detail screen fields
      * Delete processing.
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10 Only Valid Options'
     C                   MOVEL     'USR0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      *                                                                                       CSD031
      *                                                                                       CSD031
     C     CSD042        IFEQ      'Y'
      *                                                                                       CSD031
      ** Accept to Zone should be 'Y' or 'N'                                                  CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
     C     #1ACZN        IFEQ      *BLANK
     C                   MOVE      'N'           #1ACZN
     C                   ENDIF
      *                                                                                       CSD031
     C     #1ACZN        IFNE      'Y'
     C     #1ACZN        ANDNE     'N'
     C     P2ANCD        ANDNE     'D'
     C                   MOVE      *ON           *IN52
     C                   MOVE      *ON           *IN99
     C                   MOVE      'Y'           WERR01
     C                   MOVEL     'SCC0015'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      DCEXIT
     C                   ENDIF
      *                                                                                       CSD031
      ** Effective date may only be entered if accept to zone in 'N'                          CSD031
      *                                                                                       CSD031
     C     #1ACZN        IFNE      'N'
     C     #1EFDT        ANDNE     *BLANKS
     C     P2ANCD        ANDNE     'D'
     C     P2ANCD        ANDNE     'E'
     C                   MOVE      *ON           *IN53
     C                   MOVE      *ON           *IN99
     C                   MOVE      'Y'           WERR01
     C                   MOVEL     'CSD0001'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      DCEXIT
     C                   ENDIF
      *                                                                                       CSD031
      ** Test Numeric value                                                                   CSD031
      *                                                                                       CSD031
     C     #1EFDT        IFNE      *BLANKS
     C     P2ANCD        ANDNE     'D'
     C     P2ANCD        ANDNE     'E'
     C     DIGITS        CHECK     #1EFDT        WPOS
     C     WPOS          IFGT      0
     C                   MOVE      *ON           *IN53
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'ASM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      DCEXIT
     C                   ELSE
      *
     C                   MOVE      #1EFDT        ZDATE
     C                   EXSR      SRDATE
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      *ON           *IN53
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'ASM0045'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      DCEXIT
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
      * Start of Fix S01117
      * Loan Type Description is required
      * CASE: DTL.Loan Type Description is equal to blank
     C     #1LNTD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1LNTD        ZA0012                         Loan Type Descr
      * Send message 'Description required'
     C                   MOVEL     'USR0252'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Loan Processing Type
      * CASE: DTL.Loan processing fun field is blank
     C     #DLPFF        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DLPFF        ZA0013                         Loan processing
      * Send message 'loan processing type req'
     C                   MOVEL     'USR1422'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DLPFF        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0003            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0004           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0005            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0006            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0007           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0008           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0009            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DLPFF        ZA0014                         Loan processing
      * Send message 'loan processing type num'
     C                   MOVEL     'USR1421'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1LNPT                         Loan Processing
      * CASE: DTL.Loan Processing Type is Valid Type
     C     #1LNPT        IFGE      61                                           *IF
     C     #1LNPT        ANDLE     67
     C                   ELSE
      * CASE: DTL.Loan Processing Type is Valid Type 70
     C     #1LNPT        IFEQ      70                                           *IF
     C                   ELSE
      *                                                                                       CLE028
      ** If Flat Rate Personal Loans (Rule of 78s) is installed,                              CLE028
      ** Loan Processing Type 80 for Flat Rate Personal Loans                                 CLE028
      ** will be accepted.                                                                    CLE028
      *                                                                                       CLE028
     C     CLE028        IFEQ      'Y'
     C     #1LNPT        ANDEQ     80
     C                   ELSE
     C     WULE05        IFEQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     68                                                          CLE00
     C     WULE05        OREQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     69                                                          CLE00
     C     WULE05        OREQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     71                                                          CLE00
     C     WULE05        OREQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     72                                                          CLE00
     C                   ELSE                                                                  CLE00
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DLPFF        ZA0015                         Loan processing
      * Send message 'Loan Processing Type'
     C     WULE05        IFEQ      'Y'                                                         CLE00
     C     CLE028        IFEQ      'Y'
     C                   MOVEL     'USR9392'     ZAMSID
     C                   ELSE
     C                   MOVEL     'USR5613'     ZAMSID                                        CLE00
     C                   ENDIF
     C                   EXSR      ZASNMS                                                      13379
     C                   ELSE                                                                  CLE00
     C     CLE028        IFEQ      'Y'
     C                   MOVEL     'USR9393'     ZAMSID
     C                   ELSE
     C                   MOVEL     'USR0207'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   ENDIF                                                                 CLE00
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   ENDIF
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ENDIF                                                                 CLE00
      *                                                                                     AR635013
      ** If no error in Loan processing type, and if                                        AR635013
      ** amortised cost accounting indicator is blank,                                      AR635013
      ** default to 'N' if Loan proc type not equal to 70-72                                AR635013
      *                                                                                     AR635013
     C     *IN99         IFEQ      '0'                                                      AR635013
     C     *IN32         ANDEQ     '0'                                                      AR635013
     C     #1ACAI        IFEQ      ' '                                                      AR635013
     C     #1LNPT        IFNE      70                                                       AR635013
     C     #1LNPT        ANDNE     71                                                       AR635013
     C     #1LNPT        ANDNE     72                                                       AR635013
     C                   MOVEL     'N'           #1ACAI                                     AR635013
     C                   ENDIF                                                              AR635013
     C                   ENDIF                                                              AR635013
     C                   ENDIF                                                              AR635013
      * End of Fix S01117
      *                                                                                       CLE134
     C                   MOVEL     #1LNTY        #1LNT1
     C     #1LNT1        IFEQ      'X'
     C     #1LNT1        OREQ      'Y'
     C     #1LNPT        IFNE      61
     C     #1LNPT        ANDNE     68
     C                   MOVEL     'USR5409'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN99
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C     #1LNT1        IFEQ      'Z'
     C     #1LNPT        IFNE      61
     C                   MOVEL     'USR5411'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN99
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      * Start of change S01486.
      * Start of S01486 (2)
      * CASE: WRK.Display Instrument Code is Display
     C     WUDINT        IFEQ      'Y'                                          *IF
      * Validate Instrument Code
      * CASE: DTL.PM Instrument Code (Lndr) is Blank
     C     #1INNR        IFEQ      *BLANK                                       *IF
      * Start of fix 080769
      * Setup message data for message
     C                   MOVEL     #1INNR        ZA0016                         PM Instrument C
      * Send message 'Instrument code is req'
     C                   MOVEL     'USR2835'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
      * End of fix 080769
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1INNR        WUTQKF                         Test ? in Key F
      * ? processing / validation of entry.
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVE      '1'           *IN11
     C                   MOVEL     #1INNR        WUINNR                         PM Instrument C
     C                   MOVEL     *BLANK        WUAPOP                         Access Pgm Opti
     C                   MOVEL     '*KEY'        WUAPOP                         Access Pgm Opti
      * Access SDPLINPD (INNR) - Standard Functions  *     *KEY
     C*
     C                   CALL      'AOPLINR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7            RETURN CDE
     C                   PARM      WUAPOP        UUAPOP            7            OPTION
     C                   PARM      WUINNR        UUINNR            3            INS TYPE
     C     D@PLIN        PARM      *BLANK        UUSDY                          FORMAT
     C*
      * No selection was made, send an information message.
      * CASE: WRK.Access Pgm Return Code is No selection
     C     WUAPRC        IFEQ      '*NOSEL'                                     *IF
      * Send message 'Ins code not selected'
     C                   MOVEL     'USR2364'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   SETON                                        9933
     C                   MOVE      *BLANKS       #1INNR
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
      * Move PM Ins Ldr to Screen - Loan Types/Sub-types  *
     C*
     C     WUAPRC        IFNE      '*NOSEL'
     C                   MOVE      PDINNR        #1INNR
     C                   ENDIF
     C*
     C                   MOVEL     *BLANK        WUAPOP                         Access Pgm Opti
     C                   MOVEL     '*FREE'       WUAPOP                         Access Pgm Opti
      * Access SDPLINPD (INNR) - Standard Functions  *     *FREE
     C*
     C                   CALL      'AOPLINR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7            RETURN CDE
     C                   PARM      WUAPOP        UUAPOP            7            OPTION
     C                   PARM      WUINNR        UUINNR            3            INS TYPE
     C     D@PLIN        PARM      *BLANK        UUSDY                          FORMAT
     C*
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1INNR        WUINNR                         PM Instrument C
     C                   MOVEL     '*VERIFY'     WUAPOP                         Access Pgm Opti
      * Access SDPLINPD (INNR) - Standard Functions  *     *VERIFY
     C*
     C                   CALL      'AOPLINR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7            RETURN CDE
     C                   PARM      WUAPOP        UUAPOP            7            OPTION
     C                   PARM      WUINNR        UUINNR            3            INS TYPE
     C     D@PLIN        PARM      *BLANK        UUSDY                          FORMAT
     C*
      * Check access object return code
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1INNR        ZA0017                         PM Instrument C
      * Send message 'Instrument Code invald'
     C                   MOVEL     'USR2358'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUTQKF                         Test ? in Key F
     C                   END                                                    *FI
      * Validate Loan to be valued indicator
      * CASE: DTL.Loan to be Valued Ind is Blank
     C     #1LVLD        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Check that a valid value has been entered.
      * CASE: DTL.Loan to be Valued Ind is Valid values
     C     #1LVLD        IFEQ      'N'                                          *IF
     C     #1LVLD        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1LVLD        ZA0018                         Loan to be Valu
      * Send message 'Loan to be Valued Ind Inv'
     C                   MOVEL     'USR2396'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of S01486 (2)
      * End of change S01486.
      * Start CLE004
      * CASE: WRK.Switchable Feature CLE004 is Present
     C     WULE04        IFEQ      'Y'                                          *IF
      * Range Number
      * CASE: DTL.Range Number (LT/ST) is Blank
     C     #1RANG        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1RANG        ZA0019                         Range Number (L
      * Send message 'Range No. (LT/ST)     INV'
     C                   MOVEL     'USR3239'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Range Number (LT/ST) is Question Mark
     C     #1RANG        IFEQ      '?'                                          *IF
      * Select Loan Number Ranges - Loan Number Ranges  *
     C                   CALL      'SD1330S'                            90      Select Loan Num
     C                   PARM      *BLANK        W0RTN             7
     C     #1RANG        PARM      #1RANG        WQ0010            2            Range Number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD1330S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   MOVE      '1'           *IN11
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9935      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
      * CASE: DTL.Range Number (LT/ST) is Question Mark
     C     #1RANG        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        #1RANG                         Range Number (L
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1RANG        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0011            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0012           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0013            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0014            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0015           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0016           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0017            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * Zalign Loan range Number - Loan Number Ranges  *
     C*
     C**********         MOVE      WUZASF        WURGNB                                       250590
     C                   MOVE      #1RANG        WURGNB                                       250590
     C*
     C*
      * Check Loan Number Range - Loan Number Ranges  *
     C                   EXSR      SBRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1RANG        ZA0020                         Range Number (L
      * Send message 'Range No. (LT/ST)     INV'
     C                   MOVEL     'USR3239'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     WURGNB        #1RANG                         Range Number (L
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Internal Loan Participation Type/Subtype
      * CASE: WRK.Display Int Loan Part Typ is Display
     C     WUDILP        IFEQ      'Y'                                          *IF
      *                                                                                     MD055496
      ** Internal Loan Part. Type / SubType is mandatory                                    MD055496
      ** for Proc. types 61,62,63,70                                                        MD055496
      ** and when CLE106 is switched ON                                                     MD055496
      *                                                                                     MD055496
     C     CLE106        IFEQ      'Y'
     C     #1ILTY        IFEQ      *BLANK
     C     #1ILST        ANDEQ     *BLANK
     C     #1LNPT        ANDEQ     61
     C     #1ILTY        OREQ      *BLANK
     C     #1ILST        ANDEQ     *BLANK
     C     #1LNPT        ANDEQ     62
     C     #1ILTY        OREQ      *BLANK
     C     #1ILST        ANDEQ     *BLANK
     C     #1LNPT        ANDEQ     63
     C     #1ILTY        OREQ      *BLANK
     C     #1ILST        ANDEQ     *BLANK
     C     #1LNPT        ANDEQ     70
      *                                                                                     MD055496
      ** Send message 'Internal Loan Participation Type/Subtype must be entered             MD055496
      ** for processing types 61, 62, 53 and 70                                             MD055496
      *                                                                                     MD055496
     C                   MOVEL     'USS1003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993637    *
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD055496
      * CASE:
      *  - c1 OR c2
      *   |- c1    : DTL.Internal Loan Part. Type is Not Blank
      *   |- c2    : DTL.Internal Loan Part SubTyp is Not Blank
      *   |- c3    : DTL.Internal Loan Part Class is Not Blank                                CLE042
      *   '-
     C     #1ILTY        IFNE      *BLANK                                       *IF
     C     #1ILST        ORNE      *BLANK                                       *OR
     C     #1ILCL        ORNE      *BLANK                                       *OR
     C     CLE042        ANDEQ     'Y'
      * CASE:
      *  - c1 AND c2
      *   |- c1    : DTL.Loan Processing Type is Not Equal 62
      *   |- c2    : DTL.Loan Processing Type is Not Equal 63
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1LNPT        IFNE      62                                           *IF
     C     #1LNPT        IFNE      63                                           *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     WULE05        IFEQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     61                                                          CLE00
     C     WULE05        OREQ      'Y'                                                         CLE00
     C     #1LNPT        ANDEQ     70                                                          CLE00
     C                   MOVE      '0'           Y0CX01                                        CLE00
     C                   ENDIF                                                                 CLE00
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ILTY        ZA0021                         Internal Loan P
     C                   MOVEL     #1ILST        ZA0022                         Internal Loan P
     C                   MOVEL     #1ILCL        ZA0122                         Internal Loan P
      * Send message 'Loan PTyp must be 62/63'
     C     WULE05        IFEQ      'Y'                                                         CLE00
     C**********           MOVEL'USR5614' ZAMSID                                     CLE005 MD055496
     C                   MOVEL     'USS1002'     ZAMSID
     C                   ELSE                                                                  CLE00
     C                   MOVEL     'USR3244'     ZAMSID
     C                   ENDIF                                                                 CLE00
     C                   EXSR      ZASNMS
     C                   SETON                                        993637    *
     C                   SETON                                        38
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE:
      *  - c1 OR c2
      *   |- c1    : DTL.Internal Loan Part. Type is Question Mark
      *   |- c2    : DTL.Internal Loan Part SubTyp is Question Mark
      *   |- c3    : DTL.Internal Loan Part Class is Question Mark                            CLE042
      *   '-
     C     #1ILTY        IFEQ      '?'                                          *IF
     C     #1ILST        OREQ      '?'                                          *OR
     C     #1ILCL        OREQ      '?'                                          *OR
     C     CLE042        ANDEQ     'Y'
      * Select Loan Types/Sub - Loan Types/Sub-types  *
     C                   CALL      'SD0280S'                            90      Select Loan Typ
     C                   PARM      *BLANK        W0RTN             7
     C     #1ILTY        PARM      #1ILTY        WQ0018            2            Loan Type
     C     #1ILST        PARM      #1ILST        WQ0019            2            Loan Sub-type
     C     #1ILCL        PARM      #1ILCL        WQ0077            4            Loan Class
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0280S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        993637    *
     C                   SETON                                        38
     C                   END
      * CASE:
      *  - c1 OR c2
      *   |- c1    : DTL.Internal Loan Part. Type is Question Mark
      *   |- c2    : DTL.Internal Loan Part SubTyp is Question Mark
      *   |- c3    : DTL.Internal Loan Part Class is Question Mark                            CLE042
      *   '-
     C     #1ILTY        IFEQ      '?'                                          *IF
     C     #1ILST        OREQ      '?'                                          *OR
     C     #1ILCL        OREQ      '?'                                          *OR
     C     CLE042        ANDEQ     'Y'
     C                   MOVEL     *BLANK        #1ILTY                         Internal Loan P
     C                   MOVEL     *BLANK        #1ILST                         Internal Loan P
     C                   MOVEL     *BLANK        #1ILCL                         Internal Loan P
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Rtrv Loan Typ/styp IntLn - Loan Types/Sub-types  *
     C                   EXSR      SCRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1ILTY        ZA0023                         Internal Loan P
     C                   MOVEL     #1ILST        ZA0024                         Internal Loan P
     C                   MOVEL     #1ILCL        ZA0124                         Internal Loan P
      * Send message 'Int Loan Pts Typ/Styp INV'
     C                   MOVEL     'USR3240'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993637    *
     C                   SETON                                        38
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CLE004
      * /COPY.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RVSF - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RVSF
     C*
     C                   END                                                    *FI
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RSFF - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RSFF
     C*
     C                   END                                                    *FI
      * USER: Validate detail screen relations
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RVSR - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RVSR
     C*
     C                   END                                                    *FI
      *                                                                   CPL002
      ** Midas-Plato Interface Details                                    CPL002
      *                                                                   CPL002
     C     WUN2ST        IFEQ      'Y'                                          *IF            CPL00
      *                                                                   CPL002
      ** If Pricing Group is blank - Error                                CPL002
      *                                                                   CPL002
     C     #1DPCD        IFEQ      *BLANK                                       *IF            CPL00
      * Setup message data for message                                    CPL002
     C                   MOVEL     #1DPCD        ZA0012                         Pricing Group  CPL00
      * Send message 'Plato Pricing Group Required'                       CPL002
     C********             MOVEL'USR4272' ZAMSID                   CPL002 184197
     C                   MOVEL     'USR4278'     ZAMSID                                        18419
     C                   EXSR      ZASNMS                                                      CPL00
     C                   SETON                                        9981      *              CPL00
      *                                                                   CPL002
     C                   ELSE                                                                  CPL00
     C                   SETOFF                                         81      *              CPL00
     C                   ENDIF                                                                 CPL00
      *                                                                   CPL002
      ** If Report Group is blank - Error                                 CPL002
      *                                                                   CPL002
     C     #1DRCD        IFEQ      *BLANK                                       *IF            CPL00
      * Setup message data for message                                    CPL002
     C                   MOVEL     #1DRCD        ZA0012                         Report Group   CPL00
      * Send message 'Plato Report Group Required'                        CPL002
     C********             MOVEL'USR4273' ZAMSID                   CPL002 184197
     C                   MOVEL     'USR4279'     ZAMSID                                        18419
     C                   EXSR      ZASNMS                                                      CPL00
     C                   SETON                                        9982      *              CPL00
      *                                                                   CPL002
     C                   ELSE                                                                  CPL00
     C                   SETOFF                                         82      *              CPL00
     C                   ENDIF                                                                 CPL00
      *                                                                   CPL002
      ** If Credit Rating is blank - Error                                CPL002
      *                                                                   CPL002
     C     #1CRED        IFEQ      *BLANK                                       *IF            CPL00
      * Setup message data for message                                    CPL002
     C                   MOVEL     #1CRED        ZA0012                         Credit Rating  CPL00
      **Send message*'Plato*Report*Group*Required'                 CPL002 184197
      * Send message 'Plato Credit Rating Required'                       184197
     C                   MOVEL     'USR4274'     ZAMSID                                        CPL00
     C                   EXSR      ZASNMS                                                      CPL00
     C                   SETON                                        9983      *              CPL00
      *                                                                   CPL002
     C                   ELSE                                                                  CPL00
     C                   SETOFF                                         83      *              CPL00
     C                   ENDIF                                                                 CPL00
      *                                                                   CPL002
     C                   ENDIF                                                                 CPL00
     C/COPY WNCPYSRC,SD0281RC02
      *                                                                                       CAS001
      ** If CAS001 enhancement is installed, validate Yield Curve,                            CAS001
      ** Forward Yield Curve and Yield Curve Mandatory                                        CAS001
      *                                                                                       CAS001
     C     CAS001        IFEQ      'Y'
      *                                                                                       CAS001
      ** Yield Curve                                                                          CAS001
      *                                                                                       CAS001
     C     #1YLDC        IFEQ      *BLANK
     C                   ELSE
      *                                                                                       CAS001
      ** Yield Curve must be blank if Processing Type is 70,71,72                             CAS001
      *                                                                                       CAS001
     C     #1LNPT        IFEQ      70
     C     #1LNPT        OREQ      71
     C     #1LNPT        OREQ      72
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9170'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *                                                                                       CAS001
      ** check if valid Yield Curve                                                           CAS001
      *                                                                                       CAS001
     C                   CALL      'AOYLDCR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1YLDC        PYLDC             5
     C     SDYLDC        PARM      SDYLDC        UUSDY
      *                                                                                       CAS001
     C                   MOVEL     PYLDC         #1YLDC
      *                                                                                       CAS001
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9200'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS001
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** Forward Yield Curve                                                                  CAS001
      *                                                                                       CAS001
     C     #1FYLD        IFEQ      *BLANK
     C                   ELSE
      *                                                                                       CAS001
      ** Forward Yield Curve must be blank if                                                 CAS001
      ** Processing Type is 70, 71 or 72                                                      CAS001
      *                                                                                       CAS001
     C     #1LNPT        IFEQ      70
     C     #1LNPT        OREQ      71
     C     #1LNPT        OREQ      72
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9178'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *                                                                                       CAS001
      ** check if valid Forward Yield Curve                                                   CAS001
      *                                                                                       CAS001
     C                   CALL      'AOYLDCR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1FYLD        PYLDC
     C     SDYLDC        PARM      SDYLDC        UUSDY
      *                                                                                       CAS001
     C                   MOVEL     PYLDC         #1FYLD
      *                                                                                       CAS001
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9200'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS001
      ** If CAS005 is installed, checking for Zero Coupon Yield Curve                         CAS005
      ** and Interpolation Method should not be done                                          CAS005
      ** check if Zero-coupon Yield Curve                                                     CAS001
      *                                                                                       CAS001
     C     CAS005        IFNE      'Y'
     C     FSYLDT        IFNE      'Z'
     C     FSYLDT        ANDNE     'S'
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9171'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS001
      ** check if Interpolation Method is 'Y' or 'R'                                          CAS001
      *                                                                                       CAS001
     C     FSINTP        IFNE      'Y'
     C     FSINTP        ANDNE     'R'
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9172'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CAS005
     C                   ENDIF
      *                                                                                       CAS001
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** Yield Curve Mandatory                                                                CAS001
      *                                                                                       CAS001
     C     #1YLDM        IFEQ      *BLANK
     C                   ELSE
      *                                                                                       CAS001
      ** Yield Curve Mandatory must be blank if                                               CAS001
      ** Processing Type is 70, 71 or 72                                                      CAS001
      *                                                                                       CAS001
     C     #1LNPT        IFEQ      70
     C     #1LNPT        OREQ      71
     C     #1LNPT        OREQ      72
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9179'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CAS001
     C                   ELSE
      *                                                                                       CAS001
     C     #1YLDM        IFEQ      'Y'
     C     #1YLDM        OREQ      'N'
      *                                                                                       CAS001
     C                   ELSE
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** Forward Yield Curve Mandatory                                                        CAS005
      *                                                                                       CAS005
     C     #1FYCM        IFEQ      *BLANK
     C                   ELSE
      *                                                                                       CAS005
      ** Forward Yield Curve Mandatory must be blank if                                       CAS005
      ** Processing Type is 70, 71 or 72                                                      CAS005
      *                                                                                       CAS005
     C     #1LNPT        IFEQ      70
     C     #1LNPT        OREQ      71
     C     #1LNPT        OREQ      72
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9179'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CAS005
     C                   ELSE
      *                                                                                       CAS005
     C     #1FYCM        IFEQ      'Y'
     C     #1FYCM        OREQ      'N'
      *                                                                                       CAS005
     C                   ELSE
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS005
     C                   ENDIF
      *                                                                                       CGP001
      ** If CGP001 is enabled, validate the Global Product and                                CGP001
      ** Global Instrument Codes.                                                             CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRVGPC
     C                   EXSR      SRVGIC
     C                   ENDIF
      *                                                                                       CGP001
      *                                                                                       CAS009
      ** Validate Amortised Cost Accounting Indicator                                         CAS009
      *                                                                                       CAS009
     C     CAS009        IFEQ      'Y'
      *                                                                                       CAS009
     C                   MOVE      *OFF          *IN38
      *                                                                                       CAS009
      ** Check if the Adjustment to Yield value has been changed from file                    CAS009
      ** additional validation.                                                               CAS009
      *                                                                                       CAS009
     C     KLTST         KLIST
     C                   KFLD                    KYLTYP            2
     C                   KFLD                    KYSUTP            2
     C                   KFLD                    KYCLAS            4                          250391
      *                                                                                       CAS009
      ** Move values to the keyed list fields.                                                CAS009
      *                                                                                       CAS009
     C                   MOVE      #1LNTY        KYLTYP
     C                   MOVE      #1LNST        KYSUTP
     C                   MOVE      #1LNCL        KYCLAS                                       250391
      *                                                                                       CAS009
     C     #1ACAI        IFNE      AYACAI
     C     AYACAI        ANDNE     ' '                                                        260748
      *                                                                                       CAS009
     C*****KLTST         CHAIN     CLOANL8                            92               CAS009 250391
     C     KLTST         CHAIN     CLOANL10                           92                      250391
      *                                                                                       CAS009
      ** Only Validate when the initialisation program has ran                                231566
     C     *IN92         IFEQ      '0'
     C     WCAS9I        ANDEQ     'Y'
      *                                                                                       CAS009
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9428'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C     #1ACAI        IFNE      'Y'
     C     #1ACAI        ANDNE     'N'
     C*****#1ACAI        ANDNE     ' '                                                        260748
      *                                                                                       CAS009
      ** Blank value for processing types 70-72 is accepted.                                AR635013
      *                                                                                     AR635013
     C     #DLPFF        IFNE      '70'                                                     AR635013
     C     #DLPFF        ANDNE     '71'                                                     AR635013
     C     #DLPFF        ANDNE     '72'                                                     AR635013
      *                                                                                     AR635013
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9426'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF                                                              AR635013
      *                                                                                     AR635013
     C                   ELSE
     C                   MOVE      *OFF          *IN37
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C     #DLPFF        IFEQ      '70'
     C     #1ACAI        ANDNE     ' '
     C     #DLPFF        OREQ      '71'
     C     #1ACAI        ANDNE     ' '
     C     #DLPFF        OREQ      '72'
     C     #1ACAI        ANDNE     ' '
      *                                                                                       CAS009
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'USR9429'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      *OFF          *IN37
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C     #1K24C        ANDEQ     *BLANKS
     C                   MOVE      'Y'           #1K24C
     C                   ENDIF
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C     #1K24C        IFNE      'Y'
     C     #1K24C        ANDNE     'N'
     C**********           SETON                     9948                              CER047 CER059
     C                   SETON                                        9963
      *                                                                                       CER047
      ** Send Message                                                                         CER047
      *                                                                                       CER047
     C                   MOVEL     'USR3973'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
     C                   ENDIF
      *                                                                                       CER047
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  DCVL21 - Validate Details 2 - Part 1                         *                       CLE134
      *****************************************************************                       CLE134
     C     DCVL21        BEGSR
      *                                                                                       CLE134
      ** Capitalised Interest Indicator                                                       CLE134
      *                                                                                       CLE134
     C     #2CAPI        IFEQ      *BLANK
     C                   MOVE      'N'           #2CAPI
     C                   ENDIF
      *                                                                                       CLE134
     C     #2CAPI        IFNE      'Y'
     C     #2CAPI        ANDNE     'N'
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Separate Interest Indicator                                                          CLE134
      *                                                                                       CLE134
     C     #2SIIN        IFEQ      *BLANK
     C     I#LTST        IFEQ      *BLANKS
     C                   MOVE      'N'           #2SIIN
      *                                                                                CLE134 262383
     C                   ELSE
     C                   MOVE      'Y'           #2SIIN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C     #2SIIN        IFNE      'Y'
     C     #2SIIN        ANDNE     'N'
     C                   MOVE      *ON           *IN36
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Facility Amount Utlisation                                                           CLE134
      *                                                                                       CLE134
     C     #2FAMU        IFEQ      *BLANK
     C                   MOVE      'N'           #2FAMU
     C                   ENDIF
      *                                                                                       CLE134
     C     #2FAMU        IFNE      'Y'
     C     #2FAMU        ANDNE     'N'
     C                   MOVE      *ON           *IN37
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Cross-validation for Capitalised Interest, Separate Interest,                        CLE134
      ** Facility Amount Utilisation indicators: some settings conflict.                      CLE134
      *                                                                                       CLE134
     C     #2CAPI        IFEQ      'Y'
     C     #2SIIN        ANDEQ     'N'
     C     #2FAMU        ANDEQ     'N'
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN36
     C                   MOVE      *ON           *IN37
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5421'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2CAPI        IFEQ      'Y'
     C     #2SIIN        ANDEQ     'Y'
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN36
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5428'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDSR
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  DCVL22 - Validate Details 2 - Part 2                         *                       CLE134
      *****************************************************************                       CLE134
     C     DCVL22        BEGSR
      *                                                                                       CLE134
      ** Principal Past Due Loan Type/Subtype.                                                CLE134
      *                                                                                       CLE134
     C     *IN71         IFEQ      *ON
      *                                                                                       CLE134
     C                   SELECT
     C     P#LTST        WHENEQ    *BLANKS
     C     #2POPR        IFEQ      'Y'
     C     #2OVRD        OREQ      'Y'
     C     #2CAPI        OREQ      'Y'
     C     #2SIIN        OREQ      'Y'
     C     #2FAMU        OREQ      'Y'
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C********** KCLON     CHAINCLOAN19              62                            AR826996 MD022352
     C     KCLON         CHAIN     CLOAN19                            65
     C********** *IN62     IFEQ '0'                                                AR826996 MD022352
     C     *IN65         IFEQ      '0'
     C     I#LTST        ORNE      *BLANKS
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C********** #2PPL1    WHNE 'X'                                                  CLE134 MD031376
     C**********           MOVE *ON       *IN31                                      CLE134 MD031376
     C**********           MOVE *ON       *IN98                                      CLE134 MD031376
     C**********           MOVEL'USR5412' ZAMSID                                     CLE134 MD031376
     C**********           EXSR ZASNMS                                               CLE134 MD031376
      **********                                                                     CLE134 MD031376
     C********** CLE042    WHEQ 'Y'                                                  CLE134 MD031376
     C********** #2PPLC    ANDEQ*BLANKS                                              CLE134 MD031376
     C**********           MOVE *ON       *IN49                                      CLE134 MD031376
     C**********           MOVE *ON       *IN98                                      CLE134 MD031376
     C**********           MOVEL'USR5439' ZAMSID                                     CLE134 MD031376
     C**********           EXSR ZASNMS                                               CLE134 MD031376
      *                                                                                       CLE134
      ** Get Past due Type/Subtype                                                            CLE134
      *                                                                                       CLE134
     C**********           OTHER                                                     CLE134 MD031376
     C     #2PPL1        WHENEQ    '?'
     C     #2PPL2        OREQ      '?'
     C     P#LTST        ORNE      *BLANKS
      *                                                                                     MD031376
     C     #2PPL1        IFEQ      '?'
     C     #2PPL2        OREQ      '?'
     C                   MOVE      'X '          #2PPLT
     C                   MOVE      '? '          #2PPLS
     C                   MOVE      '    '        #2PPLC
     C                   SETON                                        98
     C                   ENDIF
     C     #2PPL3        IFEQ      '?'
     C                   SETON                                        98
     C                   ENDIF
      *                                                                                     MD031376
     C     CLE042        IFEQ      'Y'
     C     #2PPLC        ANDEQ     *BLANKS
     C     P#LTST        ANDNE     *BLANKS
     C     #2PPL2        ANDNE     '?'
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5439'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     MD031376
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #2PPLT        P@LNTY            2
     C                   PARM      #2PPLS        P@LNST            2
     C                   PARM      #2PPLC        P@LNCL            4
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
      *                                                                                       CLE134
     C     CLE042        IFEQ      'Y'
     C                   MOVE      *ON           *IN49
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5413'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                     MD031376
     C     PRTCD         WHENEQ    '*NOSEL'
     C                   MOVE      *BLANKS       P#LTST
     C                   MOVE      *ON           *IN98
     C     #2POPR        IFEQ      'Y'
     C     #2OVRD        OREQ      'Y'
     C     #2CAPI        OREQ      'Y'
     C     #2SIIN        OREQ      'Y'
     C     #2FAMU        OREQ      'Y'
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     KCLON         CHAIN     CLOAN19                            65
     C     *IN65         IFEQ      '0'
     C     I#LTST        ORNE      *BLANKS
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C     PRTCD         WHENNE    *BLANKS
     C                   MOVEL     'SDLOANPD'    DBFILE
     C                   MOVEL     P#LTST        DBKEY
     C                   Z-ADD     10            DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
      *                                                                                       CLE134
      ** Look up 'origin' Processing Type and 'past due' Processing Type                      CLE134
      ** in the array of valid combinations.                                                  CLE134
      *                                                                                       CLE134
     C                   OTHER
     C                   MOVEL     #1LNPT        PT1PT2            4
     C                   MOVE      A#LNPT        PT1PT2
     C     PT1PT2        LOOKUP    LNPTYP                                 97
      *                                                                                       CLE134
     C     *IN97         IFEQ      *OFF
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
      *                                                                                       CLE134
     C     CLE042        IFEQ      'Y'
     C                   MOVE      *ON           *IN49
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5414'     ZAMSID
     C                   MOVEL     PT1PT2        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      P@LNTY        #2PPLT
     C                   MOVE      P@LNST        #2PPLS
     C                   MOVE      P@LNCL        #2PPLC
     C                   ENDIF
     C                   ENDSL
      *                                                                                       CLE134
     C                   ENDSL
      *                                                                                       CLE134
      ** Principal Past Due - Default Base Rate                                               CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#PBRT           11 7
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     P#LTST        IFEQ      *BLANKS
     C     #2PBSR        IFNE      *BLANKS
     C     #2PBRT        ORNE      *BLANKS
     C     #2PBSR        COMP      *BLANKS                            38
     C     #2PBRT        COMP      *BLANKS                            58
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5489'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2PBSR        IFEQ      *BLANKS
     C     #2PBRT        ANDEQ     *BLANKS
     C     #2PRSP        ANDEQ     *BLANKS
     C     #YPCSP        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN58
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5488'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** Must be a valid value.                                                               CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2PBSR        IFNE      *BLANKS
     C     #2PBSR        ANDNE     *ZEROS
     C     #2PBRT        ANDNE     *BLANKS
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN58
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5498'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C     #2PBSR        IFNE      *BLANKS
     C********** DIGITS    CHECK#2PBSR    WPOS                                       CLE134 MD057859
      *                                                                              CLE134 MD057859
     C********** WPOS      IFGT 0                                                    CLE134 MD057859
     C**********           MOVE *ON       *IN38                                      CLE134 MD057859
     C**********           MOVE *ON       *IN98                                      CLE134 MD057859
     C**********           MOVEL'USR5419' ZAMSID                                     CLE134 MD057859
     C**********           EXSR ZASNMS                                               CLE134 MD057859
     C**********           ELSE                                                    AR826996 MD057859
     C                   MOVE      *BLANK        @PBSR             2
     C                   MOVE      #2PBSR        @PBSR
     C                   EXSR      SRVBRC
     C     *IN64         IFEQ      *ON
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN98
     C**********           MOVEL'USR5446' ZAMSID                                   AR826996 MD057859
     C                   MOVEL     'USR0079'     ZAMSID
     C                   MOVEL     CCY           ZA0125
     C                   MOVEL     @PBSR         ZA0126
     C                   EXSR      ZASNMS
     C                   ENDIF
     C**********           ENDIF                                                     CLE134 MD057859
     C                   ENDIF
     C     #2PBRT        IFNE      *BLANKS
     C     *IN72         ANDEQ     '1'
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0003
     C                   PARM      #2PBRT        WQ0004
     C                   PARM      7             WQ0005
     C                   PARM      4             WQ0006
     C                   PARM      *BLANKS       WQ0007
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0007        N#PBRT
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0007        WQ0008
     C                   PARM      7             WQ0009
      *                                                                                       CLE134
     C                   MOVE      WQ0008        #2PBRT
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN58
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Principal Past Due - Default Rate/Spread                                             CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#PRSP
      *                                                                                    AR1022007
      ** Calculate Rate/Spread and Spread ind only if SM007/CRE073 is off.                 AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'N'
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     P#LTST        IFEQ      *BLANKS
     C     #2PRSP        IFNE      *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5494'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2PRSP        IFEQ      *BLANKS
     C     #2PBSR        ANDEQ     *BLANKS
     C     #2PBRT        ANDEQ     *BLANKS
     C     #2PRSP        OREQ      *BLANKS
     C     #2PBSR        ANDEQ     *ZEROS
     C     #2PBRT        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5424'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2PRSP        IFNE      *BLANKS
     C                   MOVE(P)   #2PRSP        WQ0004
      *                                                                                       CLE134
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0003            7
     C                   PARM                    WQ0004           16
     C                   PARM      7             WQ0005            1 0
     C                   PARM      4             WQ0006            2 0
     C                   PARM      *BLANKS       WQ0007           16
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0007        N#PRSP           11 7
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0007        WQ0008           16
     C                   PARM      7             WQ0009            1 0
      *                                                                                       CLE134
     C                   MOVE      WQ0008        #2PRSP
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Principal Past Due - Default Spread Indicator                                        CLE134
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     P#LTST        IFEQ      *BLANKS
     C     #2PRSI        IFNE      *BLANKS
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5491'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      **Else*Past*Due*Loan*Type*entered;*******************************              CLE134 AR467421
      **-*If*Base*Rate*and*Spread/Rate*not*entered;********************              CLE134 AR467421
      ****-*Input*not*allowed.*****************************************              CLE134 AR467421
      **********                                                                     CLE134 AR467421
     C**********           ELSE                                                      CLE134 AR467421
     C********** #2PRSI    IFNE *BLANK                                               CLE134 AR467421
     C********** #2PBSR    ANDEQ*BLANKS                                              CLE134 AR467421
     C********** #2PRSI    ORNE *BLANK                                               CLE134 AR467421
     C********** #2PRSP    ANDEQ*BLANKS                                              CLE134 AR467421
     C**********           MOVE *ON       *IN40                                      CLE134 AR467421
     C**********           MOVE *ON       *IN98                                      CLE134 AR467421
     C**********           MOVEL'USR5420' ZAMSID                                     CLE134 AR467421
     C**********           EXSR ZASNMS                                               CLE134 AR467421
      *                                                                                    AR1090451
      ** Else Past Due Loan Type Entered;                                                  AR1090451
      ** - If Base Rate And Spread/Rate Not Entered;                                       AR1090451
      **  - Input Not Allowed.                                                             AR1090451
      *                                                                                    AR1090451
     C                   ELSE
     C     #2PRSI        IFNE      *BLANK
     C     #2PBSR        ANDEQ     *BLANK
     C     #2PBRT        ANDEQ     *BLANK
     C********** #2PRSI    ORNE *BLANK                                            AR1090451 MD022352
     C     #2PRSP        ANDEQ     *BLANK
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5420'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      * Else Past Due Loan Type entered;                                                    AR467421
      **-*If*both*Base*Rate*and*Spread/Rate*entered;*******************              CLE134 AR467421
      *   - Input mandatory.                                                                  CLE134
      *                                                                                       CLE134
     C**********           ELSE                                                     CLE134 AR1090451
     C********** #2PRSI    IFEQ *BLANK                                              CLE134 AR1090451
     C********** #2PBSR    ANDNE*BLANKS                                              CLE134 AR467421
     C********** #2PRSP    ANDNE*BLANKS                                              CLE134 AR467421
     C**********           MOVE *ON       *IN40                                     CLE134 AR1090451
     C**********           MOVE *ON       *IN98                                     CLE134 AR1090451
     C**********           MOVEL'USR5490' ZAMSID                                    CLE134 AR1090451
     C**********           EXSR ZASNMS                                              CLE134 AR1090451
      *                                                                                       CLE134
      ** Must be a valid value.                                                               CLE134
      *                                                                                       CLE134
     C                   ELSE
     C********** #2PRSI    IFNE *BLANK                                               CLE134 AR467421
     C     #2PRSI        IFNE      *BLANK
     C     #2PRSI        IFNE      'S'
     C     #2PRSI        ANDNE     'A'
     C********** #2PRSI    ANDNE'D'                                                  CLE134 AR467421
     C     #2PRSI        ANDNE     'P'
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5425'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C     #2PBSR        IFNE      *BLANK
     C     #2PRSP        ANDNE     *BLANK
     C     #2PBRT        ORNE      *BLANK
     C     #2PRSP        ANDNE     *BLANK
     C                   MOVE      'A'           #2PRSI
     C                   ENDIF
     C**********           ENDIF                                                     CLE134 AR467421
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                       CLE134
      ** Principal Past Due - Interest Calculation Basis                                      CLE134
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     P#LTST        IFEQ      *BLANKS
     C     #2PICB        IFNE      *BLANKS
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2PICB        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5426'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** Must be a valid value.                                                               CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2PICB        IFLT      '1'
     C     #2PICB        ORGT      '6'
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5426'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
      ** Validate Principal Past Due SM007/CRE073 fields                                   AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C                   MOVE      'P'           WVSM7             1
     C                   EXSR      SMVAL
     C                   ENDIF
      *                                                                                       CLE134
      ** Interest Past Due Loan Type/Subtype                                                  CLE134
      *                                                                                       CLE134
     C                   SELECT
     C     I#LTST        WHENEQ    *BLANKS
     C     #2SIIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     #2CAPI        IFNE      'Y'
     C********** KCLON     CHAINCLOAN19              62                            AR826996 MD022352
     C     KCLON         CHAIN     CLOAN19                            65
     C********** *IN62     IFEQ '0'                                                AR826996 MD022352
     C     *IN65         IFEQ      '0'
     C     P#LTST        ORNE      *BLANKS
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C     I#LTST        WHENNE    *BLANKS
     C     #2CAPI        ANDEQ     'Y'
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5483'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C********** #2IPL1    WHNE 'Y'                                                  CLE134 MD031376
     C**********           MOVE *ON       *IN33                                      CLE134 MD031376
     C**********           MOVE *ON       *IN98                                      CLE134 MD031376
     C**********           MOVEL'USR5415' ZAMSID                                     CLE134 MD031376
     C**********           EXSR ZASNMS                                               CLE134 MD031376
      **********                                                                     CLE134 MD031376
     C********** CLE042    WHEQ 'Y'                                                  CLE134 MD031376
     C********** #2IPLC    ANDEQ*BLANKS                                              CLE134 MD031376
     C**********           MOVE *ON       *IN50                                      CLE134 MD031376
     C**********           MOVE *ON       *IN98                                      CLE134 MD031376
     C**********           MOVEL'USR5439' ZAMSID                                     CLE134 MD031376
     C**********           EXSR ZASNMS                                               CLE134 MD031376
      *                                                                                       CLE134
      ** Get Past due Type/Subtype                                                            CLE134
      *                                                                                       CLE134
     C**********           OTHER                                                     CLE134 MD031376
     C     #2IPL1        WHENEQ    '?'
     C     #2IPL2        OREQ      '?'
     C     I#LTST        ORNE      *BLANKS
      *                                                                                     MD031376
     C     #2IPL1        IFEQ      '?'
     C     #2IPL2        OREQ      '?'
     C                   MOVE      'Y '          #2IPLT
     C                   MOVE      '? '          #2IPLS
     C                   MOVE      '    '        #2IPLC
     C                   SETON                                        98
     C                   ENDIF
     C     #2IPL3        IFEQ      '?'
     C                   SETON                                        98
     C                   ENDIF
      *                                                                                     MD031376
     C     CLE042        IFEQ      'Y'
     C     #2IPLC        ANDEQ     *BLANKS
     C     I#LTST        ANDNE     *BLANKS
     C     #2IPL2        ANDNE     '?'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5439'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     MD031376
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #2IPLT        P@LNTY            2
     C                   PARM      #2IPLS        P@LNST            2
     C                   PARM      #2IPLC        P@LNCL            4
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
      *                                                                                       CLE134
     C     CLE042        IFEQ      'Y'
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5413'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C     PRTCD         WHENEQ    '*NOSEL'
     C                   MOVE      *BLANKS       I#LTST
     C                   MOVE      *ON           *IN98
     C     #2SIIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     #2CAPI        IFNE      'Y'
     C     KCLON         CHAIN     CLOAN19                            65
     C     *IN65         IFEQ      '0'
     C     P#LTST        ORNE      *BLANKS
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5482'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD031376
     C     PRTCD         WHENNE    *BLANKS
     C                   MOVEL     'SDLOANPD'    DBFILE
     C                   MOVEL     I#LTST        DBKEY
     C                   Z-ADD     11            DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
      *                                                                                       CLE134
      ** Look up 'origin' Processing Type and 'past due' Processing Type                      CLE134
      ** in the array of valid combinations.                                                  CLE134
      *                                                                                       CLE134
     C                   OTHER
     C                   MOVEL     #1LNPT        PT1PT2            4
     C                   MOVE      A#LNPT        PT1PT2
      *                                                                                       CLE134
     C     PT1PT2        LOOKUP    LNPTYP                                 97
      *                                                                                       CLE134
     C     *IN97         IFEQ      *OFF
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
      *                                                                                       CLE134
     C     CLE042        IFEQ      'Y'
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5414'     ZAMSID
     C                   MOVEL     PT1PT2        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      P@LNTY        #2IPLT
     C                   MOVE      P@LNST        #2IPLS
     C                   MOVE      P@LNCL        #2IPLC
     C                   ENDIF
     C                   ENDSL
      *                                                                                       CLE134
     C                   ENDSL
      *                                                                                       CLE134
      ** Interest Past Due - Default Base Rate                                                CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#IBRT           11 7
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     I#LTST        IFEQ      *BLANKS
     C     #2IBSR        IFNE      *BLANKS
     C     #2IBRT        ORNE      *BLANKS
     C     #2IBSR        COMP      *BLANKS                            42
     C     #2IBRT        COMP      *BLANKS                            59
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5489'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2IBSR        IFEQ      *BLANKS
     C     #2IBRT        ANDEQ     *BLANKS
     C     #2IRSP        ANDEQ     *BLANKS
     C     #YICSP        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN59
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5488'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** Must be a valid value.                                                               CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2IBSR        IFNE      *BLANKS
     C     #2IBSR        ANDNE     *ZEROS
     C     #2IBRT        ANDNE     *BLANKS
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN59
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5498'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C     #2IBSR        IFNE      *BLANKS
     C********** DIGITS    CHECK#2IBSR    WPOS                                       CLE134 MD057859
      *                                                                              CLE134 MD057859
     C********** WPOS      IFGT 0                                                    CLE134 MD057859
     C**********           MOVE *ON       *IN42                                      CLE134 MD057859
     C**********           MOVE *ON       *IN98                                      CLE134 MD057859
     C**********           MOVEL'USR5419' ZAMSID                                     CLE134 MD057859
     C**********           EXSR ZASNMS                                               CLE134 MD057859
     C**********           ELSE                                                    AR826996 MD057859
     C                   MOVE      *BLANK        @PBSR             2
     C                   MOVE      #2IBSR        @PBSR
     C                   EXSR      SRVBRC
     C     *IN64         IFEQ      *ON
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN98
     C**********           MOVEL'USR5446' ZAMSID                                   AR826996 MD057859
     C                   MOVEL     'USR0079'     ZAMSID
     C                   MOVEL     CCY           ZA0125
     C                   MOVEL     @PBSR         ZA0126
     C                   EXSR      ZASNMS
     C                   ENDIF
     C**********           ENDIF                                                     CLE134 MD057859
     C                   ENDIF
     C     #2IBRT        IFNE      *BLANKS
     C     *IN72         ANDEQ     '1'
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0003
     C                   PARM      #2IBRT        WQ0004
     C                   PARM      7             WQ0005
     C                   PARM      4             WQ0006
     C                   PARM      *BLANKS       WQ0007
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0007        N#IBRT
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0007        WQ0008
     C                   PARM      7             WQ0009
      *                                                                                       CLE134
     C                   MOVE      WQ0008        #2IBRT
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN58
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Interest Past Due - Default Rate/Spread                                              CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#IRSP
      *                                                                                    AR1022007
      ** Calculate Rate/Spread and Spread ind only if SM007/CRE073 is off.                 AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'N'
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     I#LTST        IFEQ      *BLANKS
     C     #2IRSP        IFNE      *BLANKS
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5494'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2IRSP        IFEQ      *BLANKS
     C     #2IBSR        ANDEQ     *BLANKS
     C     #2IBRT        ANDEQ     *BLANKS
     C     #2IRSP        OREQ      *BLANKS
     C     #2IBSR        ANDEQ     *ZEROS
     C     #2IBRT        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5424'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2IRSP        IFNE      *BLANKS
     C                   MOVE(P)   #2IRSP        WQ0004
      *                                                                                       CLE134
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0003            7
     C                   PARM                    WQ0004           16
     C                   PARM      7             WQ0005            1 0
     C                   PARM      4             WQ0006            2 0
     C                   PARM      *BLANKS       WQ0007           16
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0007        N#IRSP           11 7
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0007        WQ0008           16
     C                   PARM      7             WQ0009            1 0
     C                   MOVE      WQ0008        #2IRSP
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Interest Past Due - Default Spread Indicator                                         CLE134
      *                                                                                       CLE134
      ** Else no Past Due Loan Type entered;                                                  CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     I#LTST        IFEQ      *BLANKS
     C     #2IRSI        IFNE      *BLANKS
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5491'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      **Else*Past*Due*Loan*Type*entered;*******************************              CLE134 AR467421
      **-*If*Base*Rate*and*Spread/Rate*not*entered;********************              CLE134 AR467421
      ****-*Input*not*allowed.*****************************************              CLE134 AR467421
      **********                                                                     CLE134 AR467421
     C**********           ELSE                                                      CLE134 AR467421
     C********** #2IRSI    IFNE *BLANK                                               CLE134 AR467421
     C********** #2IBSR    ANDEQ*BLANKS                                              CLE134 AR467421
     C********** #2IRSI    ORNE *BLANK                                               CLE134 AR467421
     C********** #2IRSP    ANDEQ*BLANKS                                              CLE134 AR467421
     C**********           MOVE *ON       *IN44                                      CLE134 AR467421
     C**********           MOVE *ON       *IN98                                      CLE134 AR467421
     C**********           MOVEL'USR5420' ZAMSID                                     CLE134 AR467421
     C**********           EXSR ZASNMS                                               CLE134 AR467421
      *                                                                                    AR1090451
      ** Else Past Due Loan Type Entered;                                                  AR1090451
      ** - If Base Rate And Spread/Rate Not Entered;                                       AR1090451
      **  - Input Not Allowed.                                                             AR1090451
      *                                                                                    AR1090451
     C                   ELSE
     C     #2IRSI        IFNE      *BLANK
     C     #2IBSR        ANDEQ     *BLANK
     C     #2IBRT        ANDEQ     *BLANK
     C********** #2IRSI    ORNE *BLANK                                            AR1090451 MD022352
     C     #2IRSP        ANDEQ     *BLANK
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5420'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                   AR467421
      **-*If*both*Base*Rate*and*Spread/Rate*entered;*******************              CLE134 AR467421
      **  - Input mandatory.                                                                  CLE134
      *                                                                                       CLE134
     C**********           ELSE                                                     CLE134 AR1090451
     C********** #2IRSI    IFEQ *BLANK                                              CLE134 AR1090451
     C********** #2IBSR    ANDNE*BLANKS                                              CLE134 AR467421
     C********** #2IRSP    ANDNE*BLANKS                                              CLE134 AR467421
     C**********           MOVE *ON       *IN44                                     CLE134 AR1090451
     C**********           MOVE *ON       *IN98                                     CLE134 AR1090451
     C**********           MOVEL'USR5490' ZAMSID                                    CLE134 AR1090451
     C**********           EXSR ZASNMS                                              CLE134 AR1090451
      *                                                                                       CLE134
      ** - Must be a valid value.                                                             CLE134
      *                                                                                       CLE134
     C                   ELSE
     C********** #2IRSI    IFNE *BLANK                                               CLE134 AR467421
     C     #2IRSI        IFNE      *BLANK
     C     #2IRSI        IFNE      'S'
     C     #2IRSI        ANDNE     'A'
     C********** #2IRSI    ANDNE'D'                                                  CLE134 AR467421
     C     #2IRSI        ANDNE     'P'
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5425'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C     #2IBSR        IFNE      *BLANK
     C     #2IRSP        ANDNE     *BLANK
     C     #2IBRT        ORNE      *BLANK
     C     #2IRSP        ANDNE     *BLANK
     C                   MOVE      'A'           #2IRSI
     C                   ENDIF
     C**********           ENDIF                                                     CLE134 AR467421
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                       CLE134
      ** Interest Past Due - Interest Calculation Basis                                       CLE134
      **                                                                                      CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     I#LTST        IFEQ      *BLANKS
     C     #2IICB        IFNE      *BLANKS
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** If Past Due Loan Type entered;                                                       CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2IICB        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5426'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** - Must be a valid value.                                                             CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2IICB        IFLT      '1'
     C     #2IICB        ORGT      '6'
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5426'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
      ** Validate Interest Past Due SM007/CRE073 fields                                    AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C                   MOVE      'I'           WVSM7             1
     C                   EXSR      SMVAL
     C                   ENDIF
      *                                                                                       CLE134
      ** Past Due Rate for Outstanding Principal                                              CLE134
      *                                                                                       CLE134
     C     #2POPR        IFEQ      *BLANK
     C                   MOVE      'N'           #2POPR
     C                   ENDIF
      *                                                                                       CLE134
     C     #2POPR        IFNE      'Y'
     C     #2POPR        ANDNE     'N'
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Overdraft Allowed                                                                    CLE134
      *                                                                                       CLE134
     C     #2OVRD        IFEQ      *BLANK
     C                   MOVE      'N'           #2OVRD
     C                   ENDIF
      *                                                                                       CLE134
     C     #2OVRD        IFNE      'Y'
     C     #2OVRD        ANDNE     'N'
     C                   MOVE      *ON           *IN47
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDIF
      ********************************************************************             CLE134 CLE164
      ***Pre-checking*Order***********************************************             CLE134 CLE164
      ********************************************************************             CLE134 CLE164
     C********** #2PCKO    IFNE *BLANKS                                                CLE134 CLE164
     C********** DIGITS    CHECK#2PCKO    WPOS                                         CLE134 CLE164
      *                                                                                       CLE134
     C********** WPOS      IFGT 0                                                      CLE134 CLE164
     C**********           MOVE *ON       *IN68                                        CLE134 CLE164
     C**********           MOVE *ON       *IN98                                        CLE134 CLE164
     C**********           MOVEL'USR5427' ZAMSID                                       CLE134 CLE164
     C**********           EXSR ZASNMS                                                 CLE134 CLE164
     C**********           ENDIF                                                       CLE134 CLE164
     C**********           ENDIF                                                       CLE134 CLE164
      *                                                                                       CLE134
      ** PDP Priority Group ID                                                                CLE164
      *                                                                                       CLE164
     C                   MOVEL     *BLANKS       PGERR             1
      *                                                                                       CLE164
     C                   MOVEL     #1LNTY        NPDCL             1
      *                                                                                       CLE164
     C     #2PGID        IFEQ      *BLANKS
      *                                                                                       CLE164
     C     NPDCL         IFEQ      'X'
     C     NPDCL         OREQ      'Y'
     C     NPDCL         OREQ      'Z'
     C                   MOVEL     'USR5418'     ZAMSID
     C                   MOVE      'Y'           PGERR
     C                   EXSR      ZASNMS
     C                   SETON                                          6898
      *                                                                                       CLE164
     C                   ELSE
      *                                                                                       CLE164
     C     #2IPLT        IFNE      *BLANKS
     C     #2PPLT        ORNE      *BLANKS
     C                   MOVEL     'USR9718'     ZAMSID
     C                   MOVE      'Y'           PGERR
     C                   EXSR      ZASNMS
     C                   SETON                                          6898
     C                   ENDIF
      *                                                                                       CLE164
     C                   ENDIF
      *                                                                                       CLE164
     C                   ELSE
      *                                                                                       CLE164
     C     #2PGID        IFNE      *BLANKS
     C     #2PGID        IFEQ      '?'
     C                   EXSR      SLPGID
     C                   ENDIF
     C     ALPHAN        CHECK     #2PGID        NUM               1 0    70
      *                                                                                       CLE164
     C     *IN70         IFEQ      '1'
     C                   MOVEL     'USR5417'     ZAMSID
     C                   MOVEL     'Y'           PGERR
     C                   EXSR      ZASNMS
     C                   SETON                                          6898
     C                   ENDIF
      *                                                                                       CLE164
     C     PGERR         IFEQ      *BLANKS
     C     #2PGID        CHAIN     SDPRGPI0                           70
     C     *IN70         IFEQ      '1'
     C                   MOVEL     'USR9717'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          6898
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE164
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDIF
      *                                                                                       CLE164
     C                   ENDSR
      *                                                                                       CLE134
     C/EJECT                                                                               AR1022007
      *****************************************************************                    AR1022007
      *  SMVAL - Validate and prepare SM007/CRE073 fields             *                    AR1022007
      *****************************************************************                    AR1022007
     C     SMVAL         BEGSR
     C                   MOVE      *BLANKS       VALBSR            2
     C                   MOVE      *BLANKS       VALBRT           12
      *                                                                                    AR1022007
     C     WVSM7         IFEQ      'P'
     C                   MOVE      P#LTST        VALTST            8
     C                   MOVE      #2PBSR        VALBSR
     C                   MOVE      #2PBRT        VALBRT
     C                   MOVE      YPLST         VALST
     C                   EXSR      RSIVAL
      *                                                                                    AR1022007
     C     *IN98         IFEQ      *OFF
     C     YPLST         IFNE      *BLANKS
     C                   MOVE      N#CSP         WYPCSP           11 7
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
     C     WVSM7         IFEQ      'I'
     C                   MOVE      I#LTST        VALTST            8
     C                   MOVE      #2IBSR        VALBSR
     C                   MOVE      #2IBRT        VALBRT
     C                   MOVE      YILST         VALST
     C                   EXSR      RSIVAL
      *                                                                                    AR1022007
     C     *IN98         IFEQ      *OFF
     C     YILST         IFNE      *BLANKS
     C                   MOVE      N#CSP         WYICSP           11 7
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDSR
     C/EJECT                                                                               AR1022007
      *****************************************************************                    AR1022007
      *  RSIVAL - Validate details for SM007/CRE073 fields            *                    AR1022007
      *****************************************************************                    AR1022007
     C     RSIVAL        BEGSR
      *                                                                                    AR1022007
      ** If no Past Due Loan Type entered;                                                 AR1022007
      ** - Input not allowed - Contr. spread                                               AR1022007
      *                                                                                    AR1022007
     C     VALTST        IFEQ      *BLANKS
      *                                                                                    AR1022007
     C     VALCSP        IFNE      *BLANKS
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN26
     C                   ELSE
     C                   MOVE      *ON           *IN93
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** - Input not allowed - Contr. spread ind.                                          AR1022007
      *                                                                                    AR1022007
     C     VALCSG        IFNE      *BLANKS
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN27
     C                   ELSE
     C                   MOVE      *ON           *IN95
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** - Input not allowed - rounding method                                             AR1022007
      *                                                                                    AR1022007
     C     VALRMT        IFNE      *BLANKS
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN28
     C                   ELSE
     C                   MOVE      *ON           *IN96
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** - Input not allowed - rounding fraction                                           AR1022007
      *                                                                                    AR1022007
     C     VALRFD        IFNE      *BLANKS
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN29
     C                   ELSE
     C                   MOVE      *ON           *IN69
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** ELSE Past Due Loan Type entered;                                                  AR1022007
      ** - Input mandatory.                                                                AR1022007
      *                                                                                    AR1022007
     C                   ELSE
      *                                                                                    AR1022007
      ** Validate contr. spread/spread ind input                                           AR1022007
      *                                                                                    AR1022007
     C                   CALL      'ZAVCSPSG'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    VALBRT
     C                   PARM                    VALBSR
     C                   PARM      *BLANKS       VALFRT           12
     C                   PARM      VALCSP        PRMCSP           12
     C                   PARM                    VALCSG
     C                   PARM      0             TMCNSP           11 7
     C                   PARM      'LOAN'        PMOD              6
     C                   PARM      0             PCUR              2 0
     C                   PARM      *BLANKS       AFLDNM
     C                   PARM      *BLANKS       AMSGID
     C                   PARM      *BLANKS       AMGDTA
     C                   PARM      0             AR1               3 0
     C                   PARM                    WCSPOK            1
     C                   PARM                    WCSGOK            1
      *                                                                                    AR1022007
     C     WCSPOK        IFNE      'Y'
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN26
     C                   ELSE
     C                   MOVE      *ON           *IN93
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                    AR1022007
     C     WCSGOK        IFNE      'Y'
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN27
     C                   ELSE
     C                   MOVE      *ON           *IN95
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                    AR1022007
      ** Set spread rate for storing                                                       AR1022007
      *                                                                                    AR1022007
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE(P)   VALCSP        WQ0004
      *                                                                                    AR1022007
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0003            7
     C                   PARM                    WQ0004           16
     C                   PARM      7             WQ0005            1 0
     C                   PARM      4             WQ0006            2 0
     C                   PARM      *BLANKS       WQ0007           16
      *                                                                                    AR1022007
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0007        N#CSP            11 7
      *                                                                                    AR1022007
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0007        WQ0008           16
     C                   PARM      7             WQ0009            1 0
      *                                                                                    AR1022007
     C                   MOVE      WQ0008        VALCSP
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
      ** Rounding method must be of valid value                                            AR1022007
      *                                                                                    AR1022007
     C                   CALL      'ZAVRNDMT'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    VALRMT
     C                   PARM      VALCSP        PRMCSP           12
     C                   PARM                    VALRFD
     C                   PARM      *BLANKS       PMOD              6
     C                   PARM      0             PCUR              2 0
     C                   PARM                    AFLDNM
     C                   PARM                    AMSGID
     C                   PARM                    AMGDTA
     C                   PARM                    AR1
     C                   PARM                    WDRMOK            1
      *                                                                                    AR1022007
      ** Set indicators of invalid rounding method input                                   AR1022007
      *                                                                                    AR1022007
     C     WDRMOK        IFNE      'Y'
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN28
     C                   ELSE
     C                   MOVE      *ON           *IN96
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                    AR1022007
      ** Rounding fraction/decimal must be of valid value                                  AR1022007
      *                                                                                    AR1022007
     C                   CALL      'ZAVRNDFD'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    VALRFD
     C                   PARM      VALCSP        PRMCSP           12
     C                   PARM                    VALRMT
     C                   PARM      *BLANKS       PMOD              6
     C                   PARM      0             PCUR              2 0
     C                   PARM                    AFLDNM
     C                   PARM                    AMSGID
     C                   PARM                    AMGDTA
     C                   PARM                    AR1               3 0
     C                   PARM                    WDRDOK            1
      *                                                                                    AR1022007
      ** Set indicators of invalid rounding fraction input                                 AR1022007
      *                                                                                    AR1022007
     C     WDRDOK        IFNE      'Y'
     C     WVSM7         IFEQ      'P'
     C                   MOVE      *ON           *IN29
     C                   ELSE
     C                   MOVE      *ON           *IN69
     C                   ENDIF
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                    AR1022007
      ** Set error messages for invalid SM007/CRE073 fields                                AR1022007
      *                                                                                    AR1022007
     C                   Z-ADD     1             AR1
     C     AMSGID(AR1)   DOWNE     *BLANKS
     C                   MOVEL     AMSGID(AR1)   ZAMSID
     C                   ADD       1             AR1
      *                                                                                    AR1022007
      ** Set more appropriate error msg for particular SM007/CRE073 error                  AR1022007
      ** - Invalid spread indicator msg                                                    AR1022007
      *                                                                                    AR1022007
     C     ZAMSID        IFEQ      'USR9026'
     C                   MOVEL     'USR5425'     ZAMSID
     C                   ENDIF
      *                                                                                    AR1022007
     C                   EXSR      ZASNMS
     C                   ENDDO
      *                                                                                    AR1022007
     C                   ENDIF
     C                   ENDSR
      /EJECT
     CSR   DDVLTP        BEGSR
      *================================================================                      BUG7817
      * Validate Loan Type/Sub Type                                                          BUG7817
      *================================================================                      BUG7817
      ** Set Key List                                                                        BUG7817
     C                   MOVEL     #1LNTY        KCLNTY
     C                   MOVEL     #1LNST        KCLNST
     C     CLE042        IFEQ      'Y'
     C     KLDLSF        CHAIN     CLLONCLF                           85
     C                   ELSE
     C     KCLOAN        CHAIN     CLOANMLF                           85
     C                   ENDIF
     C     *IN85         IFEQ      *OFF
     C     CLE042        ANDNE     'Y'
     C     *IN85         OREQ      *OFF
     C     CLE042        ANDEQ     'Y'
     C     RECI          ANDNE     'R'
      ** If record found, Loan Type/Sub Type is in use                                       BUG7817
     C                   MOVEL     'USR0217'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
      ** Defer Confirm                                                                       BUG7817
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      ** Also check for a loan amendment if no loan uses it                                  BUG7817
     C     *IN85         IFEQ      *ON
      *                                                                                     BUG21948
     C     CLE042        IFEQ      'Y'
     C     KLDLSF        CHAIN     MCLONCLF                           85
     C                   ELSE
     C     KCLOAN        CHAIN     LOAMSDKF                           85
     C                   ENDIF
     C     *IN85         IFEQ      *OFF
      ** If record found, Loan Type/Sub Type is in use                                       BUG7817
     C                   MOVEL     'USR0219'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
      ** Defer Confirm                                                                       BUG7817
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
      *================================================================                      BUG7817
     CSR   DDEXIT        ENDSR
      /EJECT                                                                                 BUG7817
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * CASE: DTL.*CMD key is *Key screen
     C     *IN12         IFEQ      '1'                                          *IF
      * Insert processing.
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   END                                                    *FI
      * /COPY.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RPCK - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RPCK
     C*
     C                   END                                                    *FI
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Loan Ty/Sub(Fr) - Loan Types/Sub-types  *
     C                   EXSR      SDCRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Loan Ty/Sub(Fr) - Loan Types/Sub-types  *
     C                   EXSR      SFDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Loan Ty/Sub(Fr) - Loan Types/Sub-types  *
     C                   EXSR      SHCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P1LNTY        IFEQ      *BLANK                                       Loan Type
     C     P1LNST        OREQ      *BLANK                                       Loan Sub-type
     C     P1LNCL        OREQ      *BLANK                                       Loan Class
     C     CLE042        ANDEQ     'Y'
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *                                                                                       CAAA03
      ** Delete button appears dureing amendment on webfaced screen                           CAAA03
      *                                                                                       CAAA03
     C     *IN89         IFEQ      '0'
     C     P2ANCD        ANDEQ     'A'
     C                   MOVE      '1'           *IN89
     C                   ENDIF
      *                                                                                       CAAA03
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C     WUAMAL        IFEQ      'N'                                          *IF
     C     CSD042        OREQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     '0'           *IN78
     C                   MOVEL     '0'           *IN40                                         CPB00
     C********** WUDINT    IFEQ 'N'                        *IF            CPB001
     C**********           MOVEL'1'       *IN77                           CPB001
     C**********           MOVEL'1'       *IN78                           CPB001
     C**********           END                             *FI            CPB001
     C     WUPFMG        IFNE      'Y'                                          *IF            CPB00
     C     WULMCR        ANDNE     'Y'                                          *OR            CPB00
     C                   MOVEL     '1'           *IN77                                         CPB00
     C                   MOVEL     '1'           *IN78                                         CPB00
     C                   ENDIF                                                  *IF            CPB00
     C     WUN4ST        IFNE      'Y'                                          *IF            CPB00
     C                   MOVEL     '1'           *IN40                                         CPB00
     C                   ENDIF                                                  *IF            CPB00
     C                   MOVEL     '0'           *IN76
     C                   MOVEL     '0'           *IN74
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C                   MOVEL     '1'           *IN76
     C                   ENDIF
     C     WULE04        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN76
     C                   MOVEL     '1'           *IN74
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN75
     C     WUDILP        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN75
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN80                                         CPL00
     C     WUN2ST        IFEQ      'N'                                          *IF            CPL00
     C                   MOVEL     '1'           *IN80                                         CPL00
     C                   END                                                    *FI            CPL00
     C**********           MOVEL'0'       *IN38                                      CSD031 BUG11768
     C                   MOVEL     '0'           *IN39
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C**********           MOVEL'1'       *IN38                                      CSD031 BUG11758
     C                   MOVEL     '1'           *IN39
     C                   ENDIF
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1DPRC                         Default Product
     C                   Z-ADD     *ZERO         #1LNPT                         Loan Processing
     C                   Z-ADD     *ZERO         #1EXPC                         Exposure Percen
     C                   MOVEL     *BLANK        #1INN1                         PM Instrument C
     C                   MOVEL     *BLANK        #1LNTD                         Loan Type Descr
     C                   MOVEL     *BLANK        #DLPFF                         Loan processing
     C                   MOVEL     *BLANK        #1INNR                         PM Instrument C
     C                   MOVEL     *BLANK        #1LVLD                         Loan to be Valu
     C                   MOVEL     *BLANK        #1RANG                         Range Number (L
     C                   MOVEL     *BLANK        #1ILTY                         Internal Loan P
     C                   MOVEL     *BLANK        #1ILST                         Internal Loan P
     C                   MOVEL     *BLANK        #1ILCL                         Internal Loan P
     C                   MOVEL     *BLANK        #1DPCD                         Pricing Group  CPL00
     C                   MOVEL     *BLANK        #1DRCD                         Report Group   CPL00
     C                   MOVEL     *BLANK        #1CRED                         Credit Rating  CPL00
     C                   MOVEL     *BLANK        #1YLDC
     C                   MOVEL     *BLANK        #1FYLD
     C                   MOVEL     *BLANK        #1YLDM
     C                   MOVEL     *BLANK        #1FYCM
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
     C     CAS009        IFEQ      'Y'
     C**********         MOVEL     *BLANK        #1ACAI                                       260748
     C**********         MOVEL     'N'           #1ACAI                              260748 AR635013
     C                   MOVEL     *BLANK        #1ACAI                                     AR635013
     C                   ENDIF
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     *BLANKS       #1K24C
     C                   ENDIF
      *                                                                                       CER047
     C/COPY WNCPYSRC,SD0281RC03
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  MAIZ#2 - Initialise Detail Screen 2                          *                       CLE134
      *****************************************************************                       CLE134
     C     MAIZ#2        BEGSR
     C                   MOVE      *BLANKS       #2PPLT
     C                   MOVE      *BLANKS       #2PPLS
     C                   MOVE      *BLANKS       #2PPLC
     C                   MOVE      *BLANKS       #2IPLT
     C                   MOVE      *BLANKS       #2IPLS
     C                   MOVE      *BLANKS       #2IPLC
     C                   MOVE      *BLANKS       #2CAPI
     C                   MOVE      *BLANKS       #2SIIN
     C                   MOVE      *BLANKS       #2FAMU
     C                   MOVE      *BLANKS       #2PBSR
     C                   MOVE      *BLANKS       #2PBRT
     C                   MOVE      *BLANKS       #2PRSP
     C                   MOVE      *BLANKS       #2PRSI
     C                   MOVE      *BLANKS       #2PICB
     C                   MOVE      *BLANKS       #2IBSR
     C                   MOVE      *BLANKS       #2IBRT
     C                   MOVE      *BLANKS       #2IRSP
     C                   MOVE      *BLANKS       #2IRSI
     C                   MOVE      *BLANKS       #2IICB
     C                   MOVE      *BLANKS       #2POPR
     C                   MOVE      *BLANKS       #2OVRD
     C**********           MOVE *BLANKS   #2PCKO                                       CLE134 CLE164
     C                   MOVE      *BLANKS       #2PGID
     C                   ENDSR
      *                                                                                       CLE134
     C/EJECT                                                                               AR1022007
      *****************************************************************                    AR1022007
      *  MAIZ#3 - Initialise SM007/CRE073 Detail Screen               *                    AR1022007
      *****************************************************************                    AR1022007
     C     MAIZ#3        BEGSR
     C                   CLEAR                   YPLST
     C                   CLEAR                   YILST
     C                   ENDSR
      *                                                                                    AR1022007
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @AYRECL fields to screen
      *================================================================
     C     WERR01        IFEQ      'Y'
     C     CSD042        ANDEQ     'Y'
     C                   GOTO      MBEXIT
     C                   ENDIF
     C                   Z-ADD     AYLCD         #1LCD                          Last Change Dat
     C                   MOVEL     AYTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     AYDPRC        #1DPRC                         Default Product
     C                   Z-ADD     AYLNPT        #1LNPT                         Loan Processing
     C                   Z-ADD     AYEXPC        #1EXPC                         Exposure Percen
     C                   MOVEL     AYINN1        #1INN1                         PM Instrument C
     C                   MOVEL     AYLNTY        #1LNTY                         Loan Type
     C                   MOVEL     AYLNST        #1LNST                         Loan Sub-type
     C     CLE042        IFEQ      'Y'
     C                   MOVEL     AYLNCL        #1LNCL                         Loan Class
     C                   ENDIF
     C                   MOVEL     AYLNTD        #1LNTD                         Loan Type Descr
     C                   MOVEL     AYINNR        #1INNR                         PM Instrument C
     C                   MOVEL     AYLVLD        #1LVLD                         Loan to be Valu
     C                   MOVEL     AYRANG        #1RANG                         Range Number (L
     C                   MOVEL     AYILTY        #1ILTY                         Internal Loan P
     C                   MOVEL     AYILST        #1ILST                         Internal Loan P
     C     CLE042        IFEQ      'Y'
     C                   MOVEL     AYILCL        #1ILCL                         Internal Loan P
     C                   ENDIF
     C                   MOVEL     PLDPCD        #1DPCD                         Pricing Group  CPL00
     C                   MOVEL     PLDRCD        #1DRCD                         Report Group   CPL00
     C                   MOVEL     PLCRED        #1CRED                         Credit Rating  CPL00
     C                   MOVEL     AYYLDC        #1YLDC
     C                   MOVEL     AYFYLD        #1FYLD
     C                   MOVEL     AYYLDM        #1YLDM
     C                   MOVEL     AYFYCM        #1FYCM
     C     CSD042        IFEQ      'Y'
     C                   MOVE      AYEACC        WVLDTE
     C                   EXSR      ZDATE2
     C                   MOVE      WZDATE        DDATEN
     C                   MOVEL     DDATEC        #1EFDT
     C     #1EFDT        IFEQ      '000000'
     C                   MOVEL     *BLANKS       #1EFDT
     C                   ENDIF
     C     *INU1         IFEQ      *ON
     C                   MOVEL     AYAACC        #1ACZN
     C                   ELSE
     C                   MOVEL     AYGPDT        #1ACZN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGP001
      ** Move the Global Product and Instrument Codes to screen fields                        CGP001
      ** if CGP001 is enabled.                                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPPI
     C                   ENDIF
     C     CAS009        IFEQ      'Y'
     C                   MOVE      AYACAI        #1ACAI
      *                                                                                       260748
     C     #1ACAI        IFEQ      ' '                                                        260748
      *                                                                                     AR635013
     C     #1LNPT        IFNE      70                                                       AR635013
     C     #1LNPT        ANDNE     71                                                       AR635013
     C     #1LNPT        ANDNE     72                                                       AR635013
     C                   MOVE      'N'           #1ACAI                                       260748
     C                   ENDIF                                                              AR635013
     C                   ENDIF                                                                260748
     C                   ENDIF
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     AYK24C        #1K24C
     C                   ENDIF
      *                                                                                       CER047
     C     CLE134        IFEQ      'Y'
     C                   MOVE      AYPPLT        #2PPLT
     C                   MOVE      AYPPLS        #2PPLS
     C                   MOVE      AYPPLC        #2PPLC
     C                   MOVE      AYIPLT        #2IPLT
     C                   MOVE      AYIPLS        #2IPLS
     C                   MOVE      AYIPLC        #2IPLC
     C                   MOVE      AYCAPI        #2CAPI
     C                   MOVE      AYSIIN        #2SIIN
     C                   MOVE      AYFAMU        #2FAMU
      *                                                                                       CLE134
     C********** AYPBSR    IFEQ *ZEROS                                                 CLE134 CSD103
     C     AYPBSR        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       #2PBSR
     C                   ELSE
     C                   MOVE      AYPBSR        #2PBSR
     C                   ENDIF
      *                                                                                       CLE134
     C     AYPBRT        IFEQ      0
     C     *IN72         OREQ      '0'
     C                   MOVE      *BLANKS       #2PBRT
     C                   ELSE
     C                   Z-ADD     0             W#NUMB
     C                   MOVE      AYPBRT        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2PBRT
     C                   Z-ADD     0             W#NUMB
     C                   ENDIF
      *                                                                                       CLE134
     C     AYPRSP        IFEQ      0
     C                   MOVE      *BLANKS       #2PRSP
     C                   ELSE
     C                   MOVE      AYPRSP        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2PRSP
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AYPRSI        #2PRSI
      *                                                                                       CLE134
     C     AYPICB        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #2PICB
     C                   ELSE
     C                   MOVE      AYPICB        #2PICB
     C                   ENDIF
      *                                                                                       CLE134
     C********** AYIBSR    IFEQ *ZEROS                                                 CLE134 CSD103
     C     AYIBSR        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       #2IBSR
     C                   ELSE
     C                   MOVE      AYIBSR        #2IBSR
     C                   ENDIF
      *                                                                                       CLE134
     C     AYIBRT        IFEQ      0
     C     *IN72         OREQ      '0'
     C                   MOVE      *BLANKS       #2IBRT
     C                   ELSE
     C                   Z-ADD     0             W#NUMB
     C                   MOVE      AYIBRT        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2IBRT
     C                   Z-ADD     0             W#NUMB
     C                   ENDIF
      *                                                                                       CLE134
     C     AYIRSP        IFEQ      0
     C                   MOVE      *BLANKS       #2IRSP
     C                   ELSE
     C                   MOVE      AYIRSP        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2IRSP
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AYIRSI        #2IRSI
      *                                                                                       CLE134
     C     AYIICB        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #2IICB
     C                   ELSE
     C                   MOVE      AYIICB        #2IICB
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AYPOPR        #2POPR
     C                   MOVE      AYOVRD        #2OVRD
      *                                                                                       CLE134
     C********** AYPCKO    IFEQ *ZERO                                                  CLE134 CLE164
     C**********           MOVE *BLANKS   #2PCKO                                       CLE134 CLE164
     C**********           ELSE                                                        CLE134 CLE164
     C**********           MOVE AYPCKO    #2PCKO                                       CLE134 CLE164
     C**********           ENDIF                                                       CLE134 CLE164
     C                   MOVE      AYPGID        #2PGID
     C                   MOVE      PGDESC        #2PDES
      *                                                                                       CLE134
     C                   ENDIF
      *                                                                                       CLE134
     C     CRE073        IFEQ      'Y'
     C                   MOVE      AYPCSG        #YPCSG
     C                   MOVE      AYPFMT        #YPRMT
     C                   MOVE      AYPRFD        #YPRFD
     C                   MOVE      AIPCSG        #YICSG
     C                   MOVE      AIPFMT        #YIRMT
     C                   MOVE      AIPRFD        #YIRFD
      *                                                                                    AR1022007
     C     AYPCSP        IFEQ      0
     C                   MOVE      *BLANKS       #YPCSP
     C                   ELSE
     C                   MOVE      AYPCSP        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #YPCSP
     C                   ENDIF
      *                                                                                    AR1022007
     C     AIPCSP        IFEQ      0
     C                   MOVE      *BLANKS       #YICSP
     C                   ELSE
     C                   MOVE      AIPCSP        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #YICSP
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
     C/COPY WNCPYSRC,SD0281RC04
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1LNTY        #1LNTY                         Loan Type
     C                   MOVEL     P1LNST        #1LNST                         Loan Sub-type
     C     CLE042        IFEQ      'Y'
     C                   MOVEL     P1LNCL        #1LNCL                         Loan Class
     C                   ENDIF
      * USER: Initialize key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RIKS - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RIKS
     C*
     C                   END                                                    *FI
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Loan Types/Subs - Loan Types/Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    AYLNTY                         Loan Type
     C                   KFLD                    AYLNST                         Loan Sub-type
     C                   KFLD                    AYLNCL                         Loan Class
      * Move fields to key list
     C                   MOVEL     #1LNTY        AYLNTY                         Loan Type
     C                   MOVEL     #1LNST        AYLNST                         Loan Sub-type
     C                   MOVEL     #1LNCL        AYLNCL                         Loan Class
     C********** KRSSA     CHAIN@AYRECL              90    *                                  CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KRSSA         CHAIN     GPLOANL1                           90
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C     KRSSA         CHAIN     SDLOANL1                           90
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C     KRSSA         CHAIN     SDALTSL0                           90
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     KRSSA         CHAIN     SDLOANL1                           90
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0055'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Check Loan Number Range - Loan Number Ranges  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    F9RGNB                         Range Number
      * Move fields to key list
     C/COPY WNCPYSRC,SD0281RC12
     C                   MOVEL     WURGNB        F9RGNB                         Range Number
     C/COPY WNCPYSRC,SD0281RC13
     C********** KRSSB     CHAIN@LENOL1              90    *                                  CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KRSSB         CHAIN     GPLENOL1                           90
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C     KRSSB         CHAIN     SDLENOL1                           90
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C     KRSSB         CHAIN     SDALTSL0                           90
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     KRSSB         CHAIN     SDLENOL1                           90
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR3200'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Rtrv Loan Typ/styp IntLn - Loan Types/Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    AYLNTY                         Loan Type
     C                   KFLD                    AYLNST                         Loan Sub-type
     C                   KFLD                    AYLNCL                         Loan Class
      * Move fields to key list
     C                   MOVEL     #1ILTY        AYLNTY                         Loan Type
     C                   MOVEL     #1ILST        AYLNST                         Loan Sub-type
     C                   MOVEL     #1ILCL        AYLNCL                         Loan Class
     C********** KRSSC     CHAIN@AYRECL              90    *                                  CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KRSSC         CHAIN     GPLOANL1                           90
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C     KRSSC         CHAIN     SDLOANL1                           90
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C     KRSSC         CHAIN     SDALTSL0                           90
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     KRSSC         CHAIN     SDLOANL1                           90
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0055'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Loan Processing Type is Term Loan
      *   |- c2    : DB1.Loan Processing Type is Term Participations Purc
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1LNPT        IFEQ      62                                           *IF
     C     AYLNPT        IFEQ      64                                           *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   ELSE
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Loan Processing Type is Discount Loan
      *   |- c2    : DB1.Loan Processing Type is Disc Participations Purc
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1LNPT        IFEQ      63                                           *IF
     C     AYLNPT        IFEQ      65                                           *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   ELSE
     C                   MOVEL     '0'           Y0CX01            1                           CLE00
     C     #1LNPT        IFEQ      61                                           *IF            CLE00
     C     AYLNPT        ANDEQ     68                                           *IF            CLE00
     C     #1LNPT        OREQ      70                                           *IF            CLE00
     C     AYLNPT        ANDEQ     71                                           *IF            CLE00
     C                   MOVEL     '1'           Y0CX01                                        CLE00
     C                   END                                                    *FI            CLE00
     C     Y0CX01        IFEQ      '1'                                          *IF            CLE00
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code   CLE00
     C                   ELSE                                                                  CLE00
      * CASE: *OTHERWISE
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END
     C                   END                                                                   CLE00
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCRRC        BEGSR
      *================================================================
      * Create Loan Ty/Sub(Fr) - Loan Types/Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @AYRECK
     C                   MOVEL     #1LNTY        AYLNTY                         Loan Type
     C                   MOVEL     #1LNST        AYLNST                         Loan Sub-type
     C     CLE042        IFEQ      'Y'
     C                   MOVEL     #1LNCL        AYLNCL                         Loan Class
     C                   ENDIF
     C                   Z-ADD     WURDNB        AYLCD                          Last Change Dat
     C                   MOVEL     'I'           AYTYLC                         Type of Last Ch
     C                   MOVEL     #1LNTD        AYLNTD                         Loan Type Descr
     C                   Z-ADD     #1LNPT        AYLNPT                         Loan Processing
     C                   Z-ADD     #1EXPC        AYEXPC                         Exposure Percen
     C                   MOVEL     #1INN1        AYINN1                         PM Instrument C
     C                   MOVEL     #1INNR        AYINNR                         PM Instrument C
     C                   MOVEL     #1LVLD        AYLVLD                         Loan to be Valu
     C                   MOVEL     #1DPRC        AYDPRC                         Default Product
     C                   MOVEL     #1RANG        AYRANG                         Range Number (L
     C                   MOVEL     #1ILTY        AYILTY                         Internal Loan P
     C                   MOVEL     #1ILST        AYILST                         Internal Loan P
     C     CLE042        IFEQ      'Y'
     C                   MOVEL     #1ILCL        AYILCL                         Internal Loan P
     C                   ENDIF
     C                   MOVEL     #1DPCD        PLDPCD                         Pricing Group  CPL00
     C                   MOVEL     #1DRCD        PLDRCD                         Report Group   CPL00
     C                   MOVEL     #1CRED        PLCRED                         Credit Rating  CPL00
     C/COPY WNCPYSRC,SD0281RC14
     C                   MOVEL     #1YLDC        AYYLDC
     C                   MOVEL     #1FYLD        AYFYLD
     C                   MOVEL     #1YLDM        AYYLDM
     C                   MOVEL     #1FYCM        AYFYCM
      *                                                                                     BUG12876
     C     CAS009        IFEQ      'Y'
     C                   MOVEL     #1ACAI        AYACAI
     C                   ENDIF
      *                                                                                       CLE134
      ** Initialise database fields irrespecive of whether CLE134 is active.                  CLE134
      *                                                                                       CLE134
     C                   MOVE      *BLANKS       AYPPLT
     C                   MOVE      *BLANKS       AYPPLS
     C                   MOVE      *BLANKS       AYPPLC
     C                   MOVE      *BLANKS       AYIPLT
     C                   MOVE      *BLANKS       AYIPLS
     C                   MOVE      *BLANKS       AYIPLC
     C                   MOVE      *BLANKS       AYCAPI
     C                   MOVE      *BLANKS       AYSIIN
     C                   MOVE      *BLANKS       AYFAMU
     C**********           MOVE 0         AYPBSR                                       CLE134 263077
     C**********           MOVE 0         AYPRSP                                       CLE134 263077
     C                   MOVE      *BLANKS       AYPRSI
     C**********           MOVE 0         AYPICB                                       CLE134 263077
     C**********           MOVE 0         AYIBSR                                       CLE134 263077
     C**********           MOVE 0         AYIRSP                                       CLE134 263077
     C                   MOVE      *BLANKS       AYIRSI
     C**********           MOVE 0         AYIICB                                       CLE134 263077
     C                   MOVE      *BLANKS       AYPOPR
     C                   MOVE      *BLANKS       AYOVRD
     C**********           MOVE 0         AYPCKO                                       CLE134 263077
     C                   MOVE      *BLANKS       AYPGID
      *                                                                                       CLE134
     C**********           Z-ADD0         AYPBSR                                       263077 CSD103
     C                   MOVE      *BLANKS       AYPBSR
     C                   Z-ADD     0             AYPBRT
     C                   Z-ADD     0             AYPRSP
     C                   Z-ADD     0             AYPICB
     C**********           Z-ADD0         AYIBSR                                       263077 CSD103
     C                   MOVE      *BLANKS       AYIBSR
     C                   Z-ADD     0             AYIBRT
     C                   Z-ADD     0             AYIRSP
     C                   Z-ADD     0             AYIICB
     C**********           Z-ADD0         AYPCKO                                       263077 CLE164
     C                   MOVEL     *BLANKS       AYPGID
      *                                                                                    AR1022007
      ** Initialise SM007/CRE073 added DB fields whether or not active.                    AR1022007
      *                                                                                    AR1022007
     C                   MOVE      *BLANKS       AYPCSG
     C                   MOVE      *BLANKS       AYPFMT
     C                   MOVE      *BLANKS       AYPRFD
     C                   MOVE      *BLANKS       AIPCSG
     C                   MOVE      *BLANKS       AIPFMT
     C                   MOVE      *BLANKS       AIPRFD
      *                                                                                    AR1022007
     C                   Z-ADD     0             AYPCSP
     C                   Z-ADD     0             AIPCSP
      *                                                                                       CLE134
      ** If CLE134 (PDCL) active, set database values.                                        CLE134
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     *IN71         IFEQ      *ON
     C                   MOVE      #2PPLT        AYPPLT
     C                   MOVE      #2PPLS        AYPPLS
     C                   MOVE      #2PPLC        AYPPLC
     C                   MOVE      #2IPLT        AYIPLT
     C                   MOVE      #2IPLS        AYIPLS
     C                   MOVE      #2IPLC        AYIPLC
     C                   MOVE      #2CAPI        AYCAPI
     C                   MOVE      #2SIIN        AYSIIN
     C                   MOVE      #2FAMU        AYFAMU
     C                   MOVE      #2PBSR        AYPBSR
     C     *IN72         IFEQ      '1'
     C                   MOVE      N#PBRT        AYPBRT
     C                   ENDIF
     C                   MOVE      N#PRSP        AYPRSP
     C                   MOVE      #2PRSI        AYPRSI
     C                   MOVE      #2PICB        AYPICB
     C                   MOVE      #2IBSR        AYIBSR
     C     *IN72         IFEQ      '1'
     C                   MOVE      N#IBRT        AYIBRT
     C                   ENDIF
     C                   MOVE      N#IRSP        AYIRSP
     C                   MOVE      #2IRSI        AYIRSI
     C                   MOVE      #2IICB        AYIICB
     C                   MOVE      #2POPR        AYPOPR
     C                   MOVE      #2OVRD        AYOVRD
     C                   ENDIF
      *                                                                                       CLE134
     C**********           MOVE #2PCKO    AYPCKO                                       CLE134 CLE164
     C                   MOVE      #2PGID        AYPGID
     C                   ENDIF
      *                                                                                    AR1022007
      ** Set db fields if SM007/CRE073 is activated.                                       AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      #YPCSG        AYPCSG
     C                   MOVE      #YPRMT        AYPFMT
     C                   MOVE      #YPRFD        AYPRFD
     C                   MOVE      #YICSG        AIPCSG
     C                   MOVE      #YIRMT        AIPFMT
     C                   MOVE      #YIRFD        AIPRFD
     C                   Z-ADD     WYPCSP        AYPCSP
     C                   Z-ADD     WYICSP        AIPCSP
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVE      'Y'           AYGPDT
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     #1K24C        AYK24C
     C                   ENDIF
      *                                                                                       CER047
     C                   MOVE      #1ACZN        AYAACC
     C                   MOVEL     #1EFDT        DDATEC
     C                   MOVE      DDATEN        ZDATE
     C                   EXSR      SRDATE
     C                   MOVE      ZDAYNO        AYEACC
     C********** CAS009    IFEQ 'Y'                                                BUG12557 BUG12876
     C**********           MOVEL#1ACAI    AYACAI                                   BUG12557 BUG12876
     C**********           ENDIF                                                   BUG12557 BUG12876
     C                   EXSR      SRSEND
      *                                                                                       CSD031
     C                   ELSE
     C                   MOVE      #1ACZN        AYGPDT
     C                   MOVEL     #1EFDT        DDATEC
     C                   MOVE      DDATEN        ZDATE
     C                   EXSR      SRDATE
     C                   MOVE      ZDAYNO        AYEACC
      *                                                                                       CSD031
     C                   ENDIF
     C                   ELSE
     C**********         MOVE      *BLANKS       AYEACC                                     MD059608
     C                   Z-ADD     0             AYEACC                                     MD059608
     C                   ENDIF
     C********** CAS009    IFEQ 'Y'                                                  CAS009 BUG12557
     C**********           MOVEL#1ACAI    AYACAI                                     CAS009 BUG12557
     C**********           ENDIF                                                     CAS009 BUG12557
      *
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0281RC08
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C                   MOVE      'I'           ACTION            1
      *                                                                                     BUG11799
      ** Remove calling of LUX and move to SD0280D                                          BUG11799
      *                                                                                     BUG11799
     C**********           EXSR SR0282                                               CER001 BUG11799
      *                                                                                       CER001
     C                   ELSE
      *                                                                                       CER001
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'I'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
     C                   ENDIF
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0281RCBW - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RCBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RCBU - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RCBU
     C*
     C                   END                                                    *FI
     C     KLCRSD        KLIST
     C                   KFLD                    AYLNTY                         Loan Type
     C                   KFLD                    AYLNST                         Loan Sub-type
     C                   KFLD                    AYLNCL                         Loan Class
      * Check for duplicate primary key
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KLCRSD        SETLL     SDLOAND0                               90
     C                   ELSE
     C     KLCRSD        SETLL     @AYRECK                                90    *
     C                   ENDIF
     C                   ELSE
     C     KLCRSD        SETLL     @AYRECK                                90
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0056'     W0RTN             7
      * Send message 'Loan Types/Sub-types   EX'
     C                   MOVEL     'USR0056'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   WRITE     SDLOAND0                             91
     C                   ELSE
     C                   WRITE     @AYRECK                              91      *
     C                   ENDIF
     C                   ELSE
     C                   WRITE     @AYRECK                              91
     C                   ENDIF
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Save the Global Product and Instrument Codes to the Cross-                           CGP001
      ** Reference Files if CGP001 is enabled.                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   ENDIF
     C/COPY WNCPYSRC,SD0281RC05
      * USER: Processing after Data update
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     CSD042        OREQ      'N'
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * Start of SAR S01117
      * Change code to filename LOANTS - SDLOANPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SECHRC
      * End of SAR S01117
      * Start of 031807
      * Update TABLET6 - Loan Types/Sub-types  *
     C                   CALL      'TABLET6'                            90      Update TABLET6
     C     W0RTN         PARM      W0RTN         WQ0020            7            *Return code
     C                   PARM      AYLNTY        WQ0021            2            Loan Type
     C                   PARM      AYLNST        WQ0022            2            Loan Sub-type
     C                   PARM                    AYLNCL
     C                   PARM      AYLNTD        WQ0023           30            Loan Type Descr
     C                   PARM      AYLNPT        WQ0024            2 0          Loan Processing
     C                   PARM      AYTYLC        WQ0025            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0026            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLET6'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      *                                                                                       CSD031
     C                   ENDIF
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RCAU - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RCAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDLOANPD'    AHFLNM                         Filename
      *
     C     KLCHSE        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSE        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFDLRC        BEGSR
      *================================================================
      * Delete Loan Ty/Sub(Fr) - Loan Types/Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     W0RTN         W0DCF                          *Defer confirm
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0281RC09
      * CASE: WRK.Window required is Yes
     C     WUD2DD        IFEQ      *BLANK                                       *IF
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C                   MOVE      'D'           ACTION
      *                                                                                     BUG11799
      ** Remove calling of LUX, deletion of record is in SD0280D                            BUG11799
      *                                                                                     BUG11799
     C**********           EXSR SR0282                                               CER001 BUG11799
     C     P1MODE        IFEQ      '1'
     C     KRTV          CHAIN     SDLNX1PD                           90
     C     *IN90         IFEQ      '0'
     C                   DELETE    SDLOANF6
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER001
     C                   ELSE
      *                                                                                       CER001
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'D'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
     C                   ENDIF
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0281RDBW - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RDBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RDBU - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RDBU
     C*
     C                   END                                                    *FI
      * Move key fields to @AYRECK
     C                   MOVEL     #1LNTY        AYLNTY                         Loan Type
     C                   MOVEL     #1LNST        AYLNST                         Loan Sub-type
     C                   MOVEL     #1LNCL        AYLNCL                         Loan Class
      *
     C     KLDLSF        KLIST
     C                   KFLD                    AYLNTY                         Loan Type
     C                   KFLD                    AYLNST                         Loan Sub-type
     C                   KFLD                    AYLNCL                         Loan Class
      *
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KLDLSF        CHAIN     SDLOAND0                           9091
     C                   ELSE
     C     P1MODE        IFEQ      '1'
      *                                                                                       243349
      ** Check if being used by loan                                                          243349
      *                                                                                       243349
     C     KLDLSF        CHAIN     CLLONCLF                           85
     C     *IN85         IFEQ      '0'
     C     RECI          ANDNE     'R'
     C                   MOVEL     'USR0004'     W0RTN
     C                   MOVEL     'USR0004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   ELSE
     C     KLDLSF        CHAIN     MCLONCLF                           85
     C     *IN85         IFEQ      '0'
     C                   MOVEL     'USR0004'     W0RTN
     C                   MOVEL     'USR0004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       243349
     C     KLDLSF        CHAIN     @AYRECK                            9091      *
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C     KLDLSF        CHAIN     SDALTSD0                           9091
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     KLDLSF        CHAIN     @AYRECK                            9091
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KLDLSF        SETLL     SDLOAND0                           9091
     C                   ELSE
     C     KLDLSF        SETLL     @AYRECK                            9091      *
     C                   ENDIF
     C                   ELSE
     C     KLDLSF        SETLL     @AYRECK                            9091
     C                   ENDIF
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVEL     'D'           ZOCHTP
     C                   DELETE    SDLOAND0                             91
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C                   DELETE    @AYRECK                              91      *
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C                   DELETE    SDALTSD0                             91
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   DELETE    @AYRECK                              91
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   MOVE      'D'           AYTYLC
     C                   EXSR      SRSEND
     C                   ENDIF
      *                                                                                       CSD031
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Enforce referential integrity if CGP001 is enabled.                                  CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXD
     C                   ENDIF
     C/COPY WNCPYSRC,SD0281RC06
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Concat the two part key into one field
     C     #1LNTY        CAT(P)    #1LNST        WULKEY                         Long Key
     C                   CAT(P)    #1LNCL        WULKEY                         Long Key
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDLOANPD'    PAFNME                         File name
     C                   MOVEL     WULKEY        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     P1MODE        ANDEQ     '1'
     C     CSD042        OREQ      'N'
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     1             WUNODL                         No. of Deletes
      * Start of SAR S01117
      * Change code to filename LOANTS - SDLOANPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SGCHRC
      * End of SAR S01117
     C                   MOVEL     'D'           WUTYLC                         Type of Last Ch
      * Start of 031807
      * Update TABLET6 - Loan Types/Sub-types  *
     C                   CALL      'TABLET6'                            90      Update TABLET6
     C     W0RTN         PARM      W0RTN         WQ0027            7            *Return code
     C                   PARM      AYLNTY        WQ0028            2            Loan Type
     C                   PARM      AYLNST        WQ0029            2            Loan Sub-type
     C                   PARM                    AYLNCL
     C                   PARM      AYLNTD        WQ0030           30            Loan Type Descr
     C                   PARM      AYLNPT        WQ0031            2 0          Loan Processing
     C                   PARM      WUTYLC        WQ0032            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0033            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLET6'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      *                                                                                       CSD031
     C                   ENDIF
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RDAU - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RDAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDLOANPD'    AHFLNM                         Filename
      *
     C     KLCHSG        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSG        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SGEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHCHRC        BEGSR
      *================================================================
      * Change Loan Ty/Sub(Fr) - Loan Types/Sub-types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @AYRECK
     C                   MOVEL     #1LNTY        AYLNTY                         Loan Type
     C                   MOVEL     #1LNST        AYLNST                         Loan Sub-type
     C                   MOVEL     #1LNCL        AYLNCL                         Loan Class
      *
     C     KLCHSH        KLIST
     C                   KFLD                    AYLNTY                         Loan Type
     C                   KFLD                    AYLNST                         Loan Sub-type
     C                   KFLD                    AYLNCL                         Loan Class
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C     KLCHSH        CHAIN     SDLOAND0                           9091
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C     KLCHSH        CHAIN     @AYRECK                            9091      *
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C     KLCHSH        CHAIN     SDALTSD0                           9091
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     KLCHSH        CHAIN     @AYRECK                            9091
     C                   ENDIF
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SHEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   UNLOCK    GPLOANL0                             91
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C                   UNLOCK    SDLOANL0                             91      *
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C                   UNLOCK    SDALTSL0                             91
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   UNLOCK    SDLOANL0                             91
     C                   ENDIF
      *                                                                                       CSD031
     C                   GOTO      SHEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @AYRECK
     C                   Z-ADD     WURDNB        AYLCD                          Last Change Dat
     C                   MOVEL     'A'           AYTYLC                         Type of Last Ch
     C                   MOVEL     #1LNTD        AYLNTD                         Loan Type Descr
     C                   Z-ADD     #1LNPT        AYLNPT                         Loan Processing
     C                   Z-ADD     #1EXPC        AYEXPC                         Exposure Percen
     C                   MOVEL     #1INN1        AYINN1                         PM Instrument C
     C                   MOVEL     #1INNR        AYINNR                         PM Instrument C
     C                   MOVEL     #1LVLD        AYLVLD                         Loan to be Valu
     C                   MOVEL     #1DPRC        AYDPRC                         Default Product
     C                   MOVEL     #1RANG        AYRANG                         Range Number (L
     C                   MOVEL     #1ILTY        AYILTY                         Internal Loan P
     C                   MOVEL     #1ILST        AYILST                         Internal Loan P
     C     CLE042        IFEQ      'Y'
     C                   MOVEL     #1ILCL        AYILCL                         Internal Loan P
     C                   ENDIF
     C                   MOVEL     #1DPCD        PLDPCD                         Pricing Group  CPL00
     C                   MOVEL     #1DRCD        PLDRCD                         Report Group   CPL00
     C                   MOVEL     #1CRED        PLCRED                         Credit Rating  CPL00
     C/COPY WNCPYSRC,SD0281RC15
     C                   MOVEL     #1YLDC        AYYLDC
     C                   MOVEL     #1FYLD        AYFYLD
     C                   MOVEL     #1YLDM        AYYLDM
     C                   MOVEL     #1FYCM        AYFYCM
      *                                                                                     BUG12876
     C     CAS009        IFEQ      'Y'
     C                   MOVEL     #1ACAI        AYACAI
     C                   ENDIF
      *                                                                                       CER047
     C     CER047        IFEQ      'Y'
     C                   MOVEL     #1K24C        AYK24C
     C                   ENDIF
      *                                                                                       CLE134
      ** Initialise database fields irrespecive of whether CLE134 is active.                  CLE134
      *                                                                                       CLE134
     C                   MOVE      *BLANKS       AYPPLT
     C                   MOVE      *BLANKS       AYPPLS
     C                   MOVE      *BLANKS       AYPPLC
     C                   MOVE      *BLANKS       AYIPLT
     C                   MOVE      *BLANKS       AYIPLS
     C                   MOVE      *BLANKS       AYIPLC
     C                   MOVE      *BLANKS       AYCAPI
     C                   MOVE      *BLANKS       AYSIIN
     C                   MOVE      *BLANKS       AYFAMU
     C**********           MOVE 0         AYPBSR                                       CLE134 CSD103
     C                   MOVE      *BLANKS       AYPBSR
     C                   MOVE      0             AYPBRT
     C                   MOVE      0             AYPRSP
     C                   MOVE      *BLANKS       AYPRSI
     C                   MOVE      0             AYPICB
     C**********           MOVE 0         AYIBSR                                       CLE134 CSD103
     C                   MOVE      *BLANKS       AYIBSR
     C                   MOVE      0             AYIBRT
     C                   MOVE      0             AYIRSP
     C                   MOVE      *BLANKS       AYIRSI
     C                   MOVE      0             AYIICB
     C                   MOVE      *BLANKS       AYPOPR
     C                   MOVE      *BLANKS       AYOVRD
     C**********           MOVE 0         AYPCKO                                       CLE134 CLE164
     C                   MOVE      *BLANKS       AYPGID
      *                                                                                    AR1022007
      ** Initialise SM007/CRE073 added DB fields whether or not active.                    AR1022007
      *                                                                                    AR1022007
     C                   MOVE      *BLANKS       AYPCSG
     C                   MOVE      *BLANKS       AYPFMT
     C                   MOVE      *BLANKS       AYPRFD
     C                   MOVE      *BLANKS       AIPCSG
     C                   MOVE      *BLANKS       AIPFMT
     C                   MOVE      *BLANKS       AIPRFD
      *                                                                                    AR1022007
     C                   Z-ADD     0             AYPCSP
     C                   Z-ADD     0             AIPCSP
      *                                                                                       CLE134
      ** If CLE134 (PDCL) active, set database values.                                        CLE134
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     *IN71         IFEQ      *ON
     C                   MOVE      #2PPLT        AYPPLT
     C                   MOVE      #2PPLS        AYPPLS
     C                   MOVE      #2PPLC        AYPPLC
     C                   MOVE      #2IPLT        AYIPLT
     C                   MOVE      #2IPLS        AYIPLS
     C                   MOVE      #2IPLC        AYIPLC
     C                   MOVE      #2CAPI        AYCAPI
     C                   MOVE      #2SIIN        AYSIIN
     C                   MOVE      #2FAMU        AYFAMU
     C                   MOVE      #2PBSR        AYPBSR
     C     *IN72         IFEQ      '1'
     C                   MOVE      N#PBRT        AYPBRT
     C                   ENDIF
     C                   MOVE      N#PRSP        AYPRSP
     C                   MOVE      #2PRSI        AYPRSI
     C                   MOVE      #2PICB        AYPICB
     C                   MOVE      #2IBSR        AYIBSR
     C     *IN72         IFEQ      '1'
     C                   MOVE      N#IBRT        AYIBRT
     C                   ENDIF
     C                   MOVE      N#IRSP        AYIRSP
     C                   MOVE      #2IRSI        AYIRSI
     C                   MOVE      #2IICB        AYIICB
     C                   MOVE      #2POPR        AYPOPR
     C                   MOVE      #2OVRD        AYOVRD
     C                   ENDIF
      *                                                                                       CLE134
     C**********           MOVE #2PCKO    AYPCKO                                       CLE134 CLE164
     C                   MOVE      #2PGID        AYPGID
     C                   ENDIF
      *                                                                                    AR1022007
      ** Set db fields if SM007/CRE073 is activated.                                       AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C     *IN98         ANDEQ     *OFF
     C                   MOVE      #YPCSG        AYPCSG
     C                   MOVE      #YPRMT        AYPFMT
     C                   MOVE      #YPRFD        AYPRFD
     C                   MOVE      #YICSG        AIPCSG
     C                   MOVE      #YIRMT        AIPFMT
     C                   MOVE      #YIRFD        AIPRFD
     C                   Z-ADD     WYPCSP        AYPCSP
     C                   Z-ADD     WYICSP        AIPCSP
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C     P2ANCD        IFEQ      'I'
     C                   MOVE      'Y'           AYGPDT
     C                   MOVE      #1ACZN        AYAACC
     C                   ENDIF
     C     P2ANCD        IFEQ      'A'
     C                   MOVE      #1ACZN        AYAACC
     C                   ENDIF
     C                   MOVEL     #1EFDT        DDATEC
     C                   MOVE      DDATEN        ZDATE
     C                   EXSR      SRDATE
     C                   MOVE      ZDAYNO        AYEACC
     C********** CAS009    IFEQ 'Y'                                                BUG12557 BUG12876
     C**********           MOVEL#1ACAI    AYACAI                                   BUG12557 BUG12876
     C**********           ENDIF                                                   BUG12557 BUG12876
     C                   EXSR      SRSEND
      *                                                                                       CSD031
     C                   ELSE
     C                   MOVE      #1ACZN        AYGPDT
     C**********         MOVEL     #1EFDT        DDATEC                                     MD059608
     C**********         MOVE      DDATEN        ZDATE                                      MD059608
     C**********         EXSR      SRDATE                                                   MD059608
     C**********         MOVE      ZDAYNO        AYEACC                                     MD059608
     C                   Z-ADD     0             AYEACC                                     MD059608
     C                   ENDIF
     C********** CAS009    IFEQ 'Y'                                                  CAS009 BUG12557
     C**********           MOVEL#1ACAI    AYACAI                                     CAS009 BUG12557
     C**********           ENDIF                                                     CAS009 BUG12557
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0281RC10
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'
     C                   MOVE      'A'           ACTION
      *                                                                                     BUG11799
      ** Call LUX in Zonal screen                                                           BUG11799
      *                                                                                     BUG11799
     C     P1MODE        IFEQ      '1'
     C                   EXSR      SR0282
     C                   ENDIF
      *                                                                                       CER001
     C                   ELSE
      *                                                                                       CER001
      * Start of SAR S01117
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'A'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * End of SAR S01117
     C                   ENDIF
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SHEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SHEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SHEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0281RBUW - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RBUW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RBDU - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RBDU
     C*
     C                   END                                                    *FI
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
      *                                                                                       CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   UPDATE    SDLOAND0                             91
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C                   UPDATE    @AYRECK                              91      *
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C                   UPDATE    SDALTSD0                             91
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   UPDATE    @AYRECK                              91
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      * Release record lock
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   UNLOCK    GPLOANL0                             91
     C                   ELSE
     C     P1MODE        IFEQ      '1'
     C                   UNLOCK    SDLOANL0                             91      *
     C                   ENDIF
     C     P1MODE        IFEQ      '2'
     C                   UNLOCK    SDALTSL0                             91
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   UNLOCK    SDLOANL0                             91
     C                   ENDIF
      *                                                                                       CSD031
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       CGP001
      ** Save the Global Product and Instrument Codes to the Cross-                           CGP001
      ** Reference Files if CGP001 is enabled.                                                CGP001
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   EXSR      SRGPXU
     C                   ENDIF
      *
     C/COPY WNCPYSRC,SD0281RC07
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C     CSD042        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C     CSD042        OREQ      'N'
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change code to filename LOANTS - SDLOANPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SICHRC
      * End of SAR S01117
      * Start of 031807
      * Update TABLET6 - Loan Types/Sub-types  *
     C                   CALL      'TABLET6'                            90      Update TABLET6
     C     W0RTN         PARM      W0RTN         WQ0034            7            *Return code
     C                   PARM      AYLNTY        WQ0035            2            Loan Type
     C                   PARM      AYLNST        WQ0036            2            Loan Sub-type
     C                   PARM                    AYLNCL
     C                   PARM      AYLNTD        WQ0037           30            Loan Type Descr
     C                   PARM      AYLNPT        WQ0038            2 0          Loan Processing
     C                   PARM      AYTYLC        WQ0039            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0040            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLET6'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      *                                                                                       CSD031
     C                   ENDIF
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RADU - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RADU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SICHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDLOANPD'    AHFLNM                         Filename
      *
     C     KLCHSI        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSI        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SIEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJRVGN        BEGSR
      *================================================================
      * Get all Midas Modules - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSJ         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSJ         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0025                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SJEXIT                                       *QUIT
     C                   GOTO      SJEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     BGMTMI        WUMTMI                         Midas/Telex Mod
     C                   MOVEL     BGSWFT        WUSWFT                         SWIFT Funds Tra
     C                   MOVEL     BGSWST        WUSWST                         SWIFT Securitie
     C                   MOVEL     BGSWCL        WUSWCL                         SWIFT Customer
     C                   MOVEL     BGSWSL        WUSWSL                         SWIFT Synd Loan
     C                   MOVEL     BGSWSM        WUSWSM                         SWIFT Statement
     C                   MOVEL     BGSWDL        WUSWDL                         SWIFT Dealing
     C                   MOVEL     BGSDGL        WUSDGL                         Standing data/G
     C                   MOVEL     BGDLFX        WUDLFX                         Dealing: FX
     C                   MOVEL     BGSYLN        WUSYLN                         Syndicated Loan
     C                   MOVEL     BGEXMG        WUEXMG                         Exposure Manage
     C                   MOVEL     BGFNMO        WUFNMO                         Financial Model
     C                   MOVEL     BGSTRT        WUSTRT                         Statutory Retur
     C                   MOVEL     BGCSLN        WUCSLN                         Customer Lendin
     C                   MOVEL     BGRTBN        WURTBN                         Retail Banking
     C                   MOVEL     BGMSDL        WUMSDL                         Midas/Swift dir
     C                   MOVEL     BGSECS        WUSECS                         Securities
     C                   MOVEL     BGAURC        WUAURC                         Auto-reconcilia
     C                   MOVEL     BGBDLI        WUBDLI                         Bond Dealers In
     C                   MOVEL     BGDRSD        WUDRSD                         DRS Standing Da
     C                   MOVEL     BGDRCM        WUDRCM                         DRS Control mod
     C                   MOVEL     BGDRFE        WUDRFE                         DRS Foreign Exc
     C                   MOVEL     BGDRMM        WUDRMM                         DRS Money Marke
     C                   MOVEL     BGDRAR        WUDRAR                         DRS Arbitrage
     C                   MOVEL     BGFDTR        WUFDTR                         Funds Transfer
     C                   MOVEL     BGDRCA        WUDRCA                         DRS Common Appl
     C                   MOVEL     BGFUOP        WUFUOP                         Futures & Optio
     C                   MOVEL     BGMTSL        WUMTSL                         Midas/Telex Syn
     C                   MOVEL     BGMTDL        WUMTDL                         Midas/Telex Dea
     C                   MOVEL     BGMTGL        WUMTGL                         Midas/Telex Gen
     C                   MOVEL     BGMTCL        WUMTCL                         Midas/Telex Cus
     C                   MOVEL     BGNWMI        WUNWMI                         Message Managem
     C                   MOVEL     BGFIIN        WUFIIN                         FRA/IRS Indicat
     C                   MOVEL     BGDLMM        WUDLMM                         Dealing: MM
     C                   MOVEL     BGINCN        WUINCN                         Internal Contra
     C                   MOVEL     BGTRMG        WUTRMG                         Treasury Manage
     C                   MOVEL     BGRKMG        WURKMG                         Interest Risk M
     C                   MOVEL     BGTSKY        WUTSKY                         Testkey
     C                   MOVEL     BGMIDQ        WUMIDQ                         Midas/Q
     C                   MOVEL     BGMFIC        WUMFIC                         Microfiche
     C                   MOVEL     BGIOAC        WUIOAC                         Interest on acc
     C                   MOVEL     BGWDPR        WUWDPR                         Window processi
     C                   MOVEL     BGSARP        WUSARP                         SAR's processin
     C                   MOVEL     BGFRIN        WUFRIN                         French return i
     C                   MOVEL     BGLRIN        WULRIN                         Lux return indi
     C                   MOVEL     BGDRIN        WUDRIN                         Dutch return in
     C                   MOVEL     BGGRIN        WUGRIN                         German return i
     C                   MOVEL     BGBRIN        WUBRIN                         Belgian return
     C                   MOVEL     BGIRIN        WUIRIN                         Italian return
     C                   MOVEL     BGSWEI        WUSWEI                         Swift External
     C                   MOVEL     BGPFMG        WUPFMG                         Portfolio Manag
     C                   MOVEL     BGCRMG        WUCRMG                         Credit Manageme
     C                   MOVEL     BGHORP        WUHORP                         Head Office Rep
     C                   MOVEL     BGAVBL        WUAVBL                         Average Balance
     C                   MOVEL     BGMARG        WUMARG                         Margins
     C                   MOVEL     BGCFMT        WUCFMT                         Confirmation Ma
     C                   MOVEL     BGMIMX        WUMIMX                         Mimix
     C                   MOVEL     BGRCFI        WURCFI                         Report Control
     C                   MOVEL     BGAMIN        WUAMIN                         Amps Int
     C                   MOVEL     BGSWRT        WUSWRT                         Swiss Returns
     C                   MOVEL     BGFLND        WUFLND                         Fiduciary Loans
     C                   MOVEL     BGLMCR        WULMCR                         Portfolio Lendi
     C                   MOVEL     BGCNTX        WUCNTX                         Cantonal Tax
     C                   MOVEL     BGSTDU        WUSTDU                         Stamp Duty
     C                   MOVEL     BGUDRS        WUUDRS                         Use DRS Shortna
     C                   MOVEL     BGCHDL        WUCHDL                         Chips Dealing
     C                   MOVEL     BGCHLN        WUCHLN                         Chips Lending
     C                   MOVEL     BGCHOB        WUCHOB                         Chips Opening B
     C                   MOVEL     BGCHIP        WUCHIP                         CHIPS
     C                   MOVEL     BGCHDI        WUCHDI                         Chips Direct Li
     C                   MOVEL     BGOPDK        WUOPDK                         Optical Disk
     C                   MOVEL     BGMBIN        WUMBIN                         Multi-branching
     C                   MOVEL     BGNNST        WUNNST                         Leo Data Nucleu
     C                   MOVEL     BGNOST        WUNOST                         Leo Letters of
     C                   MOVEL     BGNPST        WUNPST                         Leo Collections
     C                   MOVEL     BGNQST        WUNQST                         Leo Bills/Finan
     C                   MOVEL     BGNRST        WUNRST                         Leo Bankers Acc
     C                   MOVEL     BGNSST        WUNSST                         Leo Reimburseme
     C                   MOVEL     BGNTST        WUNTST                         Taxes
     C                   MOVEL     BGNUST        WUNUST                         History & Audit
     C                   MOVEL     BGNVST        WUNVST                         Management Acco
     C                   MOVEL     BGNWST        WUNWST                         IBLC Returns
     C                   MOVEL     BGNXST        WUNXST                         Retail 3
     C                   MOVEL     BGNYST        WUNYST                         Interest on Acc
     C                   MOVEL     BGNZST        WUNZST                         Midas Export Da
     C                   MOVEL     BGN0ST        WUN0ST                         Analytical Acco
     C                   MOVEL     BGN1ST        WUN1ST                         User Defined Co
     C                   MOVEL     BGN2ST        WUN2ST                         Midas-Plato Int
     C                   MOVEL     BGN3ST        WUN3ST                         Midas-Trade Inn
     C                   MOVEL     BGN4ST        WUN4ST                         PB Module      CPB00
     C                   MOVEL     BGN5ST        WUN5ST                         Reserved for La
     C                   MOVEL     BGN6ST        WUN6ST                         Reserved for La
     C                   MOVEL     BGN7ST        WUN7ST                         Reserved for La
     C                   MOVEL     BGN8ST        WUN8ST                         Reserved for La
     C                   MOVEL     BGN9ST        WUN9ST                         Reserved for La
     C                   MOVEL     BGOAST        WUOAST                         Reserved for La
     C                   MOVEL     BGOBST        WUOBST                         Reserved for La
     C                   MOVEL     BGOCST        WUOCST                         Reserved for La
     C                   MOVEL     BGODST        WUODST                         Reserved for La
     C                   MOVEL     BGOEST        WUOEST                         Reserved for La
     C                   MOVEL     BGOFST        WUOFST                         Reserved for La
     C                   MOVEL     BGOGST        WUOGST                         Reserved for La
     C                   MOVEL     BGOHST        WUOHST                         Reserved for La
     C                   MOVEL     BGOIST        WUOIST                         Reserved for La
     C                   MOVEL     BGOJST        WUOJST                         Reserved for La
     C                   MOVEL     BGOKST        WUOKST                         Reserved for La
     C                   MOVEL     BGOLST        WUOLST                         Reserved for La
     C                   MOVEL     BGOMST        WUOMST                         Reserved for La
     C                   MOVEL     BGONST        WUONST                         Reserved for La
     C                   MOVEL     BGOOST        WUOOST                         Reserved for La
     C                   MOVEL     BGOPST        WUOPST                         Reserved for La
     C                   MOVEL     BGOQST        WUOQST                         Reserved for La
     C                   MOVEL     BGORST        WUORST                         Reserved for La
     C                   MOVEL     BGOSST        WUOSST                         Reserved for La
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSK         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   SLRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSL         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSL         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SLEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1LNTY        WK1X01            1
     C                   MOVEL     #1LNST        WK1X02            1
     C                   MOVEL     #1LNCL        WK1X03            1
     C     WK1X01        IFEQ      '?'                                          Loan Type
     C     WK1X02        OREQ      '?'                                          Loan Sub-type
     C     WK1X03        OREQ      '?'                                          Loan Class
     C     CLE042        ANDEQ     'Y'
     C                   CALL      'SD0280S'                            90      Select Loan Typ
     C                   PARM      *BLANK        W0RTN             7
     C     #1LNTY        PARM      #1LNTY        WQ0001            2            Loan Type
     C     #1LNST        PARM      #1LNST        WQ0002            2            Loan Sub-type
     C     #1LNCL        PARM      #1LNCL        WQ0066            4            Loan Class
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0280S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        993132    *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y1SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y1EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C     @#DFMT        IFEQ      '#RCDKEY'
      * KEY Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
     C     @#DFMT        IFEQ      '#RCDDTL1'
      * DETAIL Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGPC - Validates the Global Product Code.                  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGPC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Product Code must be entered.                                                        CGP001
      *                                                                                       CGP001
     C********** #1PRDC    IFEQ *BLANKS                                               CGP001 BUG6307
     C**********           MOVEL'GPM0004' ZAMSID                                      CGP001 BUG6307
     C**********           ELSE                                                       CGP001 BUG6307
      *                                                                                      BUG6307
     C     #1PRDC        IFNE      *BLANKS
      *                                                                                       CGP001
     C                   CALL      'AOGPRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1PRDC        PGPRD            10
     C     GPPROD        PARM      GPPROD        DSFDY
      *                                                                                     MD031375
     C     #1PRDC        IFEQ      '?'
     C                   MOVE      '1'           *IN11
     C                   ENDIF
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CGP001
     C     '?'           SCAN      #1PRDC        WPOS              2 0
     C     WPOS          IFNE      *ZERO
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CGP001
     C                   MOVE      PGPRD         #1PRDC
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C**********           MOVE 'GPM0004' ZAMSID                                     CGP001 MD031375
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      'Y'           W0DCF
      *                                                                                       CGP001
      ** Invalid Product Code.                                                                CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'GPM0005'     ZAMSID
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'GPPRODPD'    DBFILE
     C                   MOVEL     PGPRD         DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRVGIC - Validates the Global Instrument Code.               *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRVGIC        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
      *                                                                                       CGP001
      ** Instrument Code must be entered.                                                     CGP001
      *                                                                                       CGP001
     C********** #1INSC    IFEQ *BLANKS                                               CGP001 BUG6307
     C**********           MOVE 'GPM0006' ZAMSID                                      CGP001 BUG6307
     C**********           ELSE                                                       CGP001 BUG6307
      *                                                                                      BUG6307
     C     #1INSC        IFNE      *BLANKS
      *                                                                                       CGP001
     C                   CALL      'AOGINSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1INSC        PGINS            10
     C     GPINST        PARM      GPINST        DSFDY
      *                                                                                     MD031375
     C     #1INSC        IFEQ      '?'
     C                   MOVE      '1'           *IN11
     C                   ENDIF
      *                                                                                       CGP001
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CGP001
     C     '?'           SCAN      #1INSC        WPOS
     C     WPOS          IFNE      *ZERO
     C                   MOVE      'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CGP001
     C                   MOVE      PGINS         #1INSC
     C                   ELSE
      *                                                                                       CGP001
     C                   SELECT
     C     PRTCD         WHENEQ    '*NOSEL '
     C**********           MOVE 'GPM0006' ZAMSID                                     CGP001 MD031375
     C                   MOVE      *BLANKS       #1INSC
     C                   MOVE      'Y'           W0DCF
      *                                                                                       CGP001
      ** Invalid Instrument Code.                                                             CGP001
      *                                                                                       CGP001
     C     PRTCD         WHENEQ    '*NRF   '
     C                   MOVE      'GPM0007'     ZAMSID
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'GPPRODPD'    DBFILE
     C                   MOVEL     PGPRD         DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C     ZAMSID        IFNE      *BLANKS
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPPI - Gets the Global Product and Instrument Codes.       *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPPI        BEGSR
      *                                                                                       CGP001
     C                   MOVE      *BLANKS       #1PRDC
     C                   MOVE      *BLANKS       #1INSC
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'LE'          KMOD
     C                   MOVEL     AYLNTY        KTRTP
     C                   MOVEL     AYLNST        KTRST
      *                                                                                       CGP001
     C     KGPXR         CHAIN(N)  GPPRDXL0                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *OFF
     C                   MOVE      PDGPRD        #1PRDC
     C                   ENDIF
      *                                                                                       CGP001
     C     KGPXR         CHAIN(N)  GPINSXL0                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *OFF
     C                   MOVE      INGINS        #1INSC
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPOF - Opens the Global Processing Cross-Reference Files.  *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPOF        BEGSR
      *                                                                                       CGP001
     C                   Z-ADD     80            PLEN             15 5
      *                                                                                       CGP001
     C                   DO        2             WIDX              1 0
      *                                                                                       CGP001
     C                   MOVE      OVRC(WIDX)    PCMD             80
      *                                                                                       CGP001
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                       CGP001
     C                   ENDDO
      *                                                                                       CGP001
     C                   OPEN      GPPRDXL0
     C                   OPEN      GPINSXL0
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPGZ - Gets the Zone via GOGETZONE.                        *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPGZ        BEGSR
      *                                                                                       CGP001
     C                   CALL      GOPGM
     C                   PARM      *BLANKS       PZRTCD            7
     C                   PARM      *BLANKS       PZERMS           50
     C                   PARM      'N'           PZFCHK            1
     C                   PARM      *BLANKS       PZZONE           10
     C                   PARM      *BLANKS       PZSHTC            4
     C                   PARM      *ZERO         PZRDNB            5 0
     C                   PARM      *ZERO         PZDNWD            5 0
     C                   PARM      *BLANKS       PZBCCY            3
     C                   PARM      *ZERO         PZNJOB            1 0
      *                                                                                       CGP001
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE            10
     C                   ELSE
      *                                                                                       CGP001
     C     PZRTCD        IFEQ      '*ERROR'
     C                   MOVEL     GOMSG         PZERMS
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPXU - Writes and updates records on the Global            *                       CGP001
      *           Processing Cross-Reference Files.                   *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPXU        BEGSR
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'LE'          KMOD
     C                   MOVEL     AYLNTY        KTRTP
     C                   MOVEL     AYLNST        KTRST
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPPRDXL0                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *ON
     C                   MOVE      KZONE         PDZONE
     C                   MOVE      KMOD          PDMOD
     C                   MOVE      KTRTP         PDTRTP
     C                   MOVE      KTRST         PDTRST
     C                   MOVE      #1PRDC        PDGPRD
     C                   WRITE     GPPRDXD0
     C                   ELSE
     C                   MOVE      #1PRDC        PDGPRD
     C                   UPDATE    GPPRDXD0
     C                   ENDIF
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPINSXL0                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *ON
     C                   MOVE      KZONE         INZONE
     C                   MOVE      KMOD          INMOD
     C                   MOVE      KTRTP         INTRTP
     C                   MOVE      KTRST         INTRST
     C                   MOVE      #1INSC        INGINS
     C                   WRITE     GPINSXD0
     C                   ELSE
     C                   MOVE      #1INSC        INGINS
     C                   UPDATE    GPINSXD0
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                               *                       CGP001
      *  SRGPXD - Deletes records on the Global Processing Cross-     *                       CGP001
      *           Reference Files.                                    *                       CGP001
      *                                                               *                       CGP001
      *****************************************************************                       CGP001
     C     SRGPXD        BEGSR
      *                                                                                       CGP001
     C                   MOVE      WZONE         KZONE
     C                   MOVE      'LE'          KMOD
     C                   MOVEL     AYLNTY        KTRTP
     C                   MOVEL     AYLNST        KTRST
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPPRDXL0                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *OFF
     C                   DELETE    GPPRDXD0
     C                   ENDIF
      *                                                                                       CGP001
     C     KGPXR         CHAIN     GPINSXL0                           46
      *                                                                                       CGP001
     C     *IN46         IFEQ      *OFF
     C                   DELETE    GPINSXD0
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      *  SR0282 - Call SD0282 instead of WN0010 when ULX004 is ON.                            CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     SR0282        BEGSR
     C                   MOVE      #1LNTY        #LNTY
     C                   MOVE      #1LNST        #LNST
     C     CLE042        IFEQ      'Y'
     C                   MOVE      #1LNCL        #LNCL
     C                   ENDIF
     C                   CALL      'SD0282'
     C                   PARM                    ACTION            1
     C                   PARM                    DATALX
     C                   PARM      *BLANKS       W0RTN
     C                   ENDSR
      *****************************************************************                       CER001
      *****************************************************************                       CGP001
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      *                                                                                     AR826996
      *  SRVBRC - Validate Base Rate + Currency                                             AR826996
      *                                                                                     AR826996
      *****************************************************************                     AR826996
     C     SRVBRC        BEGSR
      *                                                                                     AR826996
     C     KCYBR         KLIST
     C                   KFLD                    @PBSR
     C                   KFLD                    CCY
      *                                                                                     AR826996
     C     KCLON         KLIST
     C                   KFLD                    #1LNTY
     C                   KFLD                    #1LNST
      *                                                                                     AR826996
     C**********           MOVE *OFF      *IN62                                    AR826996 MD022352
     C                   MOVE      *OFF          *IN65
     C**********           MOVE *OFF      *IN63                                    AR826996 MD022352
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *BLANKS       @CCY              3
      *                                                                                     AR826996
     C     KCLON         SETLL     CLOAN19
     C********** KCLON     READECLOAN19                  62                        AR826996 MD022352
     C     KCLON         READE     CLOAN19                                65
     C********** *IN62     DOWEQ*OFF                                               AR826996 MD022352
     C     *IN65         DOWEQ     *OFF
     C**********           MOVE *ON       *IN63                                    AR826996 MD022352
     C                   MOVE      *ON           *IN67
     C     CCY           IFNE      @CCY
      *                                                                                     AR826996
      ** Search Base Rate Code + Currency in SDBSRTPD                                       AR826996
      *                                                                                     AR826996
     C     KCYBR         CHAIN     SDBSRTL2                           64
      *                                                                                     AR826996
     C     *IN64         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
      *                                                                                     AR826996
     C                   MOVEL     CCY           @CCY
      *                                                                                     AR826996
     C                   ENDIF
     C********** KCLON     READECLOAN19                  62                        AR826996 MD022352
     C     KCLON         READE     CLOAN19                                65
     C                   ENDDO
      *                                                                                     AR826996
      ** If Type/Subtype not found in CLOAN, just make sure that                            AR826996
      ** Base Rate is exists in SDBSRTPD                                                    AR826996
      *                                                                                     AR826996
     C********** *IN63     IFEQ *OFF                                               AR826996 MD022352
     C     *IN67         IFEQ      *OFF
     C     @PBSR         CHAIN     SDBSRTL2                           64
      *                                                                                     AR826996
      ** If Base Rate still not found, prompt error message without CCY                     AR826996
      *                                                                                     AR826996
     C     *IN64         IFEQ      *ON
     C                   MOVE      *BLANK        CCY
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR826996
     C                   ENDSR
      *****************************************************************                     AR826996
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      1             YYLGCT            5 0          # of grps
     C                   PARM      W0GRP         YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281REPP - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281REPP
     C*
     C                   END                                                    *FI
      * Start of Fix S01117
      * Fast Exit Processing
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of Fix S01117
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *                                                                                       CGP001
     C     CGP001        IFEQ      'Y'
     C                   CLOSE     GPPRDXL0
     C                   CLOSE     GPINSXL0
     C                   ENDIF
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
      *                                                                                       CGP001
      ** Global Processing X-Reference Key List                                               CGP001
      *                                                                                       CGP001
     C     KGPXR         KLIST
     C                   KFLD                    KZONE            10
     C                   KFLD                    KMOD              2
     C                   KFLD                    KTRTP             5
     C                   KFLD                    KTRST             5
      *                                                                                       CGP001
      ** LE Customer Loans Key List                                                          BUG7817
      *                                                                                      BUG7817
     C     KCLOAN        KLIST
     C                   KFLD                    KCLNTY            2
     C                   KFLD                    KCLNST            2
      *                                                                                      BUG7817
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Switchable Feature CLE006
     C                   MOVEL     *BLANK        WULE06            1
      * Define work field Switchable Feature CLE005                       CLE005
     C                   MOVEL     *BLANK        WULE05            1                           CLE00
      * Define work field Display Int Loan Part Typ
     C                   MOVEL     *BLANK        WUDILP            1
      * Define work field data structure local Inst
     C                   MOVEL     *BLANK        WUDSTT            2
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field Check Loan Digit
     C                   MOVEL     *BLANK        WUCLDG            1
      * Define work field Position One
     C                   MOVEL     *BLANK        WUPOS1            1
      * Define work field Position Two
     C                   MOVEL     *BLANK        WUPOS2            1
      * Define work field Test data structure
     C                   MOVEL     *BLANK        WUTDST            2
      * Define work field Location one
     C                   MOVEL     *BLANK        WULOC1            1
      * Define work field Location two
     C                   MOVEL     *BLANK        WULOC2            1
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Display Instrument Code
     C                   MOVEL     *BLANK        WUDINT            1
      * Define work field PM Instrument Code (Lndr)
     C                   MOVEL     *BLANK        WUINNR            3
      * Define work field Access Pgm Option
     C                   MOVEL     *BLANK        WUAPOP            7
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Switchable Feature CLE004
     C                   MOVEL     *BLANK        WULE04            1
      * Define work field Range Number
     C                   MOVEL     *BLANK        WURGNB            2
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field Window required
     C                   MOVEL     *BLANK        WUD2DD            1
      * Define work field Long Key
     C                   MOVEL     *BLANK        WULKEY           50
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Amend allowed
     C                   MOVEL     *BLANK        WUAMAL            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Midas/Telex Module Ind.
     C                   MOVEL     *BLANK        WUMTMI            1
      * Define work field SWIFT Funds Transfer
     C                   MOVEL     *BLANK        WUSWFT            1
      * Define work field SWIFT Securities Trading
     C                   MOVEL     *BLANK        WUSWST            1
      * Define work field SWIFT Customer Lending
     C                   MOVEL     *BLANK        WUSWCL            1
      * Define work field SWIFT Synd Loans (REDUN)
     C                   MOVEL     *BLANK        WUSWSL            1
      * Define work field SWIFT Statements
     C                   MOVEL     *BLANK        WUSWSM            1
      * Define work field SWIFT Dealing
     C                   MOVEL     *BLANK        WUSWDL            1
      * Define work field Standing data/Gen.Ledger
     C                   MOVEL     *BLANK        WUSDGL            1
      * Define work field Dealing: FX
     C                   MOVEL     *BLANK        WUDLFX            1
      * Define work field Syndicated Loans (REDUN)
     C                   MOVEL     *BLANK        WUSYLN            1
      * Define work field Exposure Management
     C                   MOVEL     *BLANK        WUEXMG            1
      * Define work field Financial Modeller
     C                   MOVEL     *BLANK        WUFNMO            1
      * Define work field Statutory Returns
     C                   MOVEL     *BLANK        WUSTRT            1
      * Define work field Customer Lending
     C                   MOVEL     *BLANK        WUCSLN            1
      * Define work field Retail Banking
     C                   MOVEL     *BLANK        WURTBN            1
      * Define work field Midas/Swift direct link
     C                   MOVEL     *BLANK        WUMSDL            1
      * Define work field Securities
     C                   MOVEL     *BLANK        WUSECS            1
      * Define work field Auto-reconciliations
     C                   MOVEL     *BLANK        WUAURC            1
      * Define work field Bond Dealers Interface
     C                   MOVEL     *BLANK        WUBDLI            1
      * Define work field DRS Standing Data
     C                   MOVEL     *BLANK        WUDRSD            1
      * Define work field DRS Control module
     C                   MOVEL     *BLANK        WUDRCM            1
      * Define work field DRS Foreign Exchange
     C                   MOVEL     *BLANK        WUDRFE            1
      * Define work field DRS Money Market
     C                   MOVEL     *BLANK        WUDRMM            1
      * Define work field DRS Arbitrage
     C                   MOVEL     *BLANK        WUDRAR            1
      * Define work field Funds Transfer
     C                   MOVEL     *BLANK        WUFDTR            1
      * Define work field DRS Common Applications
     C                   MOVEL     *BLANK        WUDRCA            1
      * Define work field Futures & Options
     C                   MOVEL     *BLANK        WUFUOP            1
      * Define work field Midas/Telex Synd. Loans
     C                   MOVEL     *BLANK        WUMTSL            1
      * Define work field Midas/Telex Dealing
     C                   MOVEL     *BLANK        WUMTDL            1
      * Define work field Midas/Telex Gen. Ledger
     C                   MOVEL     *BLANK        WUMTGL            1
      * Define work field Midas/Telex Cust. Lending
     C                   MOVEL     *BLANK        WUMTCL            1
      * Define work field Message Management
     C                   MOVEL     *BLANK        WUNWMI            1
      * Define work field FRA/IRS Indicator
     C                   MOVEL     *BLANK        WUFIIN            1
      * Define work field Dealing: MM
     C                   MOVEL     *BLANK        WUDLMM            1
      * Define work field Internal Contracts
     C                   MOVEL     *BLANK        WUINCN            1
      * Define work field Treasury Management
     C                   MOVEL     *BLANK        WUTRMG            1
      * Define work field Interest Risk Management
     C                   MOVEL     *BLANK        WURKMG            1
      * Define work field Testkey
     C                   MOVEL     *BLANK        WUTSKY            1
      * Define work field Midas/Q
     C                   MOVEL     *BLANK        WUMIDQ            1
      * Define work field Microfiche
     C                   MOVEL     *BLANK        WUMFIC            1
      * Define work field Interest on accounts
     C                   MOVEL     *BLANK        WUIOAC            1
      * Define work field SAR's processing required
     C                   MOVEL     *BLANK        WUSARP            1
      * Define work field French return indicator
     C                   MOVEL     *BLANK        WUFRIN            1
      * Define work field Lux return indicator
     C                   MOVEL     *BLANK        WULRIN            1
      * Define work field Dutch return indicator
     C                   MOVEL     *BLANK        WUDRIN            1
      * Define work field German return indicator
     C                   MOVEL     *BLANK        WUGRIN            1
      * Define work field Belgian return indicator
     C                   MOVEL     *BLANK        WUBRIN            1
      * Define work field Italian return indicator
     C                   MOVEL     *BLANK        WUIRIN            1
      * Define work field Swift External Interface
     C                   MOVEL     *BLANK        WUSWEI            1
      * Define work field Portfolio Management
     C                   MOVEL     *BLANK        WUPFMG            1
      * Define work field Credit Management.
     C                   MOVEL     *BLANK        WUCRMG            1
      * Define work field Head Office Reporting
     C                   MOVEL     *BLANK        WUHORP            1
      * Define work field Average Balances
     C                   MOVEL     *BLANK        WUAVBL            1
      * Define work field Margins
     C                   MOVEL     *BLANK        WUMARG            1
      * Define work field Confirmation Matching
     C                   MOVEL     *BLANK        WUCFMT            1
      * Define work field Mimix
     C                   MOVEL     *BLANK        WUMIMX            1
      * Define work field Report Control Facility
     C                   MOVEL     *BLANK        WURCFI            1
      * Define work field Amps Int
     C                   MOVEL     *BLANK        WUAMIN            1
      * Define work field Swiss Returns
     C                   MOVEL     *BLANK        WUSWRT            1
      * Define work field Fiduciary Loans & Deposit
     C                   MOVEL     *BLANK        WUFLND            1
      * Define work field Portfolio Lending
     C                   MOVEL     *BLANK        WULMCR            1
      * Define work field Cantonal Tax
     C                   MOVEL     *BLANK        WUCNTX            1
      * Define work field Stamp Duty
     C                   MOVEL     *BLANK        WUSTDU            1
      * Define work field Use DRS Shortnames
     C                   MOVEL     *BLANK        WUUDRS            1
      * Define work field Chips Dealing
     C                   MOVEL     *BLANK        WUCHDL            1
      * Define work field Chips Lending
     C                   MOVEL     *BLANK        WUCHLN            1
      * Define work field Chips Opening Balance
     C                   MOVEL     *BLANK        WUCHOB            1
      * Define work field CHIPS
     C                   MOVEL     *BLANK        WUCHIP            1
      * Define work field Chips Direct Link
     C                   MOVEL     *BLANK        WUCHDI            1
      * Define work field Optical Disk
     C                   MOVEL     *BLANK        WUOPDK            1
      * Define work field Leo Data Nucleus
     C                   MOVEL     *BLANK        WUNNST            1
      * Define work field Leo Letters of Credit
     C                   MOVEL     *BLANK        WUNOST            1
      * Define work field Leo Collections
     C                   MOVEL     *BLANK        WUNPST            1
      * Define work field Leo Bills/Financing
     C                   MOVEL     *BLANK        WUNQST            1
      * Define work field Leo Bankers Acceptances
     C                   MOVEL     *BLANK        WUNRST            1
      * Define work field Leo Reimbursements
     C                   MOVEL     *BLANK        WUNSST            1
      * Define work field Taxes
     C                   MOVEL     *BLANK        WUNTST            1
      * Define work field History & Audit Facility
     C                   MOVEL     *BLANK        WUNUST            1
      * Define work field Management Accounts
     C                   MOVEL     *BLANK        WUNVST            1
      * Define work field IBLC Returns
     C                   MOVEL     *BLANK        WUNWST            1
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
      * Define work field Interest on Accounts 3
     C                   MOVEL     *BLANK        WUNYST            1
      * Define work field Midas Export Data Module
     C                   MOVEL     *BLANK        WUNZST            1
      * Define work field Analytical Accounting
     C                   MOVEL     *BLANK        WUN0ST            1
      * Define work field User Defined Correspondnc
     C                   MOVEL     *BLANK        WUN1ST            1
      * Define work field Midas-Plato Interface
     C                   MOVEL     *BLANK        WUN2ST            1
      * Define work field Midas-Trade Innovation If
     C                   MOVEL     *BLANK        WUN3ST            1
      * Define work field PB Module                                       CPB001
     C                   MOVEL     *BLANK        WUN4ST            1
      * Define work field Reserved for Later Use 42
     C                   MOVEL     *BLANK        WUN5ST            1
      * Define work field Reserved for Later Use 43
     C                   MOVEL     *BLANK        WUN6ST            1
      * Define work field Reserved for Later Use 44
     C                   MOVEL     *BLANK        WUN7ST            1
      * Define work field Reserved for Later Use 45
     C                   MOVEL     *BLANK        WUN8ST            1
      * Define work field Reserved for Later Use 46
     C                   MOVEL     *BLANK        WUN9ST            1
      * Define work field Reserved for Later Use 47
     C                   MOVEL     *BLANK        WUOAST            1
      * Define work field Reserved for Later Use 48
     C                   MOVEL     *BLANK        WUOBST            1
      * Define work field Reserved for Later Use 49
     C                   MOVEL     *BLANK        WUOCST            1
      * Define work field Reserved for Later Use 50
     C                   MOVEL     *BLANK        WUODST            1
      * Define work field Reserved for Later Use 51
     C                   MOVEL     *BLANK        WUOEST            1
      * Define work field Reserved for Later Use 52
     C                   MOVEL     *BLANK        WUOFST            1
      * Define work field Reserved for Later Use 53
     C                   MOVEL     *BLANK        WUOGST            1
      * Define work field Reserved for Later Use 54
     C                   MOVEL     *BLANK        WUOHST            1
      * Define work field Reserved for Later Use 55
     C                   MOVEL     *BLANK        WUOIST            1
      * Define work field Reserved for Later Use 56
     C                   MOVEL     *BLANK        WUOJST            1
      * Define work field Reserved for Later Use 57
     C                   MOVEL     *BLANK        WUOKST            1
      * Define work field Reserved for Later Use 58
     C                   MOVEL     *BLANK        WUOLST            1
      * Define work field Reserved for Later Use 59
     C                   MOVEL     *BLANK        WUOMST            1
      * Define work field Reserved for Later Use 60
     C                   MOVEL     *BLANK        WUONST            1
      * Define work field Reserved for Later Use 61
     C                   MOVEL     *BLANK        WUOOST            1
      * Define work field Reserved for Later Use 62
     C                   MOVEL     *BLANK        WUOPST            1
      * Define work field Reserved for Later Use 63
     C                   MOVEL     *BLANK        WUOQST            1
      * Define work field Reserved for Later Use 64
     C                   MOVEL     *BLANK        WUORST            1
      * Define work field Reserved for Later Use 65
     C                   MOVEL     *BLANK        WUOSST            1
      * Define work field SAR number field
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access obj dummy DS (76)
     C                   MOVEL     *BLANK        WUFDY            76
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Define *Synon program work fields
     C                   Z-ADD     *ZEROS        YRSW00            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW01            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW02            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW03            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW04            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW05            5 0          *Synon (5,0) wo
     C                   MOVEL     *BLANKS       YRSW06            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW07            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW08            7            *Return code
     C                   MOVEL     *BLANKS       YRSW09            1            *String work fi
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0A                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0B                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0C                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0D                         *Synon (9999) w
     C                   MOVEL     *BLANKS       YRSW0E            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW0F            1            *String work fi
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
     C                   OPEN      SD0281R#
     C**********           OPEN SDLOANL1                                                      CSD031
     C**********           OPEN SDLENOL1                                                      CSD031
     C                   OPEN      SDMMODL1
     C**********           OPEN SDLOANL0                                                      CSD031
     C                   OPEN      SDFCTLL0
     C                   OPEN      SDLNX1PD
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * SD0281R Precompiler - Loan Types/Sub-types  *
      * Remove Last Amend Box and Creation Parameters functions.
      * End of change S01459.
      * Start of Fix S01117
      * define data structure - Loan Types/Sub-types  *
      * test define data struct. - Loan Types/Sub-types  *
      * End of Fix S01117
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      *                                                                                       CGP001
      ** Check if CGP001 is enabled.                                                          CGP001
      *                                                                                       CGP001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGP001
     C                   MOVE      'N'           CGP001            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGP001
     C                   MOVE      *ON           *IN57
      *                                                                                       CGP001
      ** Open the Global Processing Files.                                                    CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPOF
      *                                                                                       CGP001
      ** Get the Zone.                                                                        CGP001
      *                                                                                       CGP001
     C                   EXSR      SRGPGZ
     C                   ELSE
      *                                                                                       CGP001
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CGP001'      DBKEY
     C                   MOVEL     '07'          DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGP001
     C                   ENDIF
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Start of change S01486.
      * Determine which modules have been installed.
      * Get all Midas Modules - MIDAS Modules  *
     C                   EXSR      SJRVGN
      * End of change S01486.
      *                                                                                       CGL014
     C                   MOVE      'N'           CGL014            1
      *                                                                                       CGL014
      ** Access SAR details to see if CGL014 is switched on                                   CGL014
      *                                                                                       CGL014
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL014
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281E '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     'CGL014'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CGL014
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL014
     C                   ENDIF
      *                                                                                       CLE025
     C                   MOVE      'N'           CLE025            1
      *                                                                                       CLE025
      ** Access SAR details to see if CLE025 is switched on                                   CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE025
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281E '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVEL     'CLE025'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE025
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   ENDIF
      *                                                                                       CLE025
     C                   MOVE      *OFF          *IN60
      *                                                                                       CGL014
     C     CGL014        IFEQ      'Y'
     C     CLE025        OREQ      'Y'
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *                                                                                       CGL014
      * Start of S01486 (2)
     C                   MOVEL     'N'           WUDINT                         Display Instrum
      * Display or hide Instrument code
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Portfolio Management is Yes
      *   |- c2    : WRK.Portfolio Lending is Yes
      *   '-
     C     WUPFMG        IFEQ      'Y'                                          *IF
     C     WULMCR        OREQ      'Y'                                          *OR
     C     WUN4ST        OREQ      'Y'                                          *OR            CPB00
     C     CGL014        OREQ      'Y'
     C     CLE025        OREQ      'Y'
     C                   MOVEL     'Y'           WUDINT                         Display Instrum
     C                   END                                                    *FI
      * End of S01486 (2)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C                   MOVE      *ON           *IN54
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SKRVGN
     C                   MOVEL     'Y'           WUMFTS                         S01212
      * Window processing.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SLRVGN
      * Data Structure Loan type - Loan Types/Sub-types  *
     C                   END                                                    *FI
      * Insert/Change flag processing.
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * Start of Fix S01117
     C                   MOVEL     'Y'           WUAMAL                         Amend allowed
      * Setup complete processing.
      * CASE: WRK.Set Up Complete is Yes
     C     WUSUC         IFEQ      'Y'                                          *IF
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     'N'           WUAMAL                         Amend allowed
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of Fix S01117
      * Start CLE004
      * Is Lending Enhancements - CLE004 switched On ?
     C                   MOVEL     'N'           WULE04                         Switchable Feat
     C                   MOVEL     *BLANK        WUAPRC                         Access Pgm Retu
     C                   MOVEL     'CLE004'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0041            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0042            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0043            6            SAR number fiel
     C                   PARM      WUFDY         WQ0044           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Is CLE004 switched on ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WULE04                         Switchable Feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WULE04                         Switchable Feat
     C                   END                                                    *FI
      * If CLE004 is 'on' - check for CLE006
      * CASE: WRK.Switchable Feature CLE004 is Present
     C                   MOVEL     'N'           WULE06                         Switchable Feat12705
     C     WULE04        IFEQ      'Y'                                          *IF
     C***********          MOVEL'N'       WULE06           Switchable Feat127056
     C                   MOVEL     *BLANK        WUAPRC                         Access Pgm Retu
     C                   MOVEL     'CLE006'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0045            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0046            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0047            6            SAR number fiel
     C                   PARM      WUFDY         WQ0048           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Is CLE006 switched on ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WULE06                         Switchable Feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WULE06                         Switchable Feat
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CLE004
      *                                                                   CLE005
      ** Start CLE005                                                     CLE005
      *                                                                   CLE005
     C                   MOVEL     'N'           WULE05                         Switchable FeatCLE00
     C                   MOVEL     *BLANK        WUAPRC                         Access Pgm RetuCLE00
     C                   MOVEL     'CLE005'      WUSARN                         SAR number fielCLE00
      * SAR switched on check - Standard Functions  *                     CLE005
     C                   CALL      'AOSARDR0'                           90      SAR switched onCLE00
     C     WUAPRC        PARM      WUAPRC        WQ0049            7            Access Pgm RetuCLE00
     C                   PARM      '*VERIFY'     WQ0050            7            Option for ACCOCLE00
     C     WUSARN        PARM      WUSARN        WQ0051            6            SAR number fielCLE00
     C                   PARM      WUFDY         WQ0052           76            Access obj dummCLE00
      *                                                                   CLE005
     C     *IN90         IFEQ      '1'                                                         CLE00
      * Call to program ended in error                                    CLE005
     C                   MOVEL     'Y2U0032'     W0RTN                                         CLE00
     C                   MOVEL     *BLANKS       W0CLPG           10                           CLE00
     C                   MOVEL     'AOSARDR0'    W0CLPG                                        CLE00
      * Send message '*Error occured on CALL...'                          CLE005
     C                   MOVEL     'Y2U0032'     ZAMSID                                        CLE00
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        CLE00
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data   CLE00
     C                   EXSR      ZASNMS                                                      CLE00
     C                   END                                                                   CLE00
      *                                                                   CLE005
      * Is CLE005 switched on ?                                           CLE005
      * CASE: WRK.Access Pgm Return Code is *Normal                       CLE005
     C     WUAPRC        IFEQ      *BLANK                                       *IF            CLE00
     C                   MOVEL     'Y'           WULE05                         Switchable FeatCLE00
     C                   ELSE                                                                  CLE00
      * CASE: *OTHERWISE                                                  CLE005
     C                   MOVEL     'N'           WULE05                         Switchable FeatCLE00
     C                   END                                                    *FI            CLE00
      * End CLE005                                                        CLE005
      *                                                                                       CLE028
      ** Check if Flat Rate Personal Loans (Rule of 78s) is installed                         CLE028
      *                                                                                       CLE028
     C                   MOVEL     'N'           CLE028            1
     C                   MOVEL     *BLANK        WUAPRC
     C                   MOVEL     'CLE028'      WUSARN
      *                                                                                       CLE028
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      WUAPRC        PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C     WUSARN        PARM      WUSARN        PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE028
     C     *IN90         IFEQ      '1'
      *                                                                                       CLE028
      ** Call to program ended in error                                                       CLE028
      *                                                                                       CLE028
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
      *                                                                                       CLE028
      ** Send message '*Error occured on CALL...'                                             CLE028
      *                                                                                       CLE028
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE028
      ** If Flat Rate Personal Loans (Rule of 78s) is installed...                            CLE028
      *                                                                                       CLE028
     C     WUAPRC        IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE028
     C                   ELSE
      *                                                                                       CLE028
     C                   MOVEL     'N'           CLE028
     C                   ENDIF
      *                                                                                       CLE028
      * /COPYs.
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0281RFPG - Loan Types/Sub-types  *
      * 00/Copy member SD0281REPG - Loan Types/Sub-types  *
      * 00/Copy member SD0281RIPG - Loan Types/Sub-types  *
      * 00/Copy member SD0281RCPG - Loan Types/Sub-types  *
     C*
     C/COPY WNCPYSRC,SD0281RCPG
     C*
      * 00/Copy member SD0281ROPG - Loan Types/Sub-types  *
     C                   END                                                    *FI
     C/COPY WNCPYSRC,SD0281RC11
      *                                                                                       CAS001
      ** Determine if CAS001 is installed                                                     CAS001
      *                                                                                       CAS001
     C     *DTAARA       DEFINE                  LDA
      *                                                                                       CAS001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CAS001'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS001
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281R '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CAS001'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001            1
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVE      'N'           CAS001
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
      *                                                                                       CAS005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS005
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281R '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CAS005'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS005
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS005            1
     C                   MOVE      *ON           *IN56
     C                   ELSE
     C                   MOVE      'N'           CAS005
     C                   MOVE      *OFF          *IN56
     C                   ENDIF
      *                                                                                       CLE042
      ** Access SAR details to see if CLE042 is switched on                                   CLE042
      *                                                                                       CLE042
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE042
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE042            1
     C                   MOVE      *ON           *IN66
     C                   ENDIF
      *                                                                                       CER001
      ** Access SAR details to see if ULX004 is switched on                                   CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX004            1
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'ULX004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER001
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281R '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'ULX004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX004
     C                   ENDIF
      *                                                                                       CAS005
      ** Check if CAS009 is installed.                                                        CAS009
      *                                                                                       CAS009
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS009
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281R '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CAS009'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS009
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS009            1
     C***********          MOVE *ON       *IN57                                      CAS009 BUG10606
     C                   MOVE      *ON           *IN54
      **********                                                                     CER047 BUG24706
      ***Call*AOSARDR0 to check for CER047                                           CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C**********           CALL 'AOSARDR0'                                           CER047 BUG24706
     C**********           PARM *BLANKS   PRTCD                                      CER047 BUG24706
     C**********           PARM '*VERIFY 'POPTN                                      CER047 BUG24706
     C**********           PARM 'CER047'  PSARD                                      CER047 BUG24706
     C********** SCSARD    PARM SCSARD    DSFDY                                      CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C********** PRTCD     IFNE *BLANKS                                              CER047 BUG24706
     C********** PRTCD     ANDNE'*NRF   '                                            CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C********** *LOCK     IN   LDA                                                  CER047 BUG24706
     C**********           MOVEL'SD0281R 'DBPGM                                      CER047 BUG24706
     C**********           MOVEL'SCSARDPD'DBFILE                                     CER047 BUG24706
     C**********           MOVEL'10'      DBASE                                      CER047 BUG24706
     C**********           MOVEL'CER047'  DBKEY                                      CER047 BUG24706
     C**********           OUT  LDA                                                  CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C**********           EXSR *PSSR                                                CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C**********           ENDIF                                                     CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C********** PRTCD     IFEQ *BLANKS                                              CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C**********           MOVE 'Y'       CER047  1                                  CER047 BUG24706
     C**********           MOVE *ON       *IN47                                      CER047 BUG24706
     C**********           ELSE                                                      CER047 BUG24706
     C**********           MOVE 'N'       CER047                                     CER047 BUG24706
     C**********           MOVE *OFF      *IN47                                      CER047 BUG24706
      **********                                                                     CER047 BUG24706
     C**********           ENDIF                                                     CER047 BUG24706
      *                                                                                       231566
     C     KSARP         KLIST
     C                   KFLD                    KSARN             6
     C                   KFLD                    KPNAM            10
      *                                                                                       231566
     C                   MOVE      'CAS009'      KSARN
     C     'LEC'         CAT       '000018'      KPNAM
      *                                                                                       231566
     C*****KSARP         CHAIN     SCSARPL1                           58                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARP                                                                        MD056555
     C+ from SCSRPJW0                                                                       MD056555
     C+ where AKSARN = :KSARN and AKPNAM = :KPNAM                                           MD056555
     C/END-EXEC                                                                             MD056555
      *                                                                                       231566
     C******IN58         IFEQ      *ON                                                      MD056555
     C                   IF        SQLCODE = 100                                            MD056555
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281R '    DBPGM
     C                   MOVEL     'SCSARPPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'CAS009'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       231566
      ** Check if Initialisation Program for CAS009 Fee Codes has run                         231566
      *                                                                                       231566
     C     AKPRVC        IFEQ      'Y'
      *                                                                                       231566
      ** Set CAS009 Initialised Flag to Yes                                                   231566
      *                                                                                       231566
     C                   MOVE      'Y'           WCAS9I            1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       231566
     C                   ELSE
     C                   MOVE      'N'           CAS009
     C***********          MOVE *OFF      *IN57                                      CAS009 BUG10606
     C                   MOVE      *OFF          *IN54
     C                   ENDIF
      *                                                                                     BUG24706
      ** Transfer checking of CER047 outside of CAS009 call                                 BUG24706
      ** Call AOSARDR0 to check for CER047                                                  BUG24706
      *                                                                                     BUG24706
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CER047'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     BUG24706
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
      *                                                                                     BUG24706
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0281R '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '10'          DBASE
     C                   MOVEL     'CER047'      DBKEY
     C                   OUT       LDA
      *                                                                                     BUG24706
     C                   EXSR      *PSSR
      *                                                                                     BUG24706
     C                   ENDIF
      *                                                                                     BUG24706
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                     BUG24706
     C                   MOVE      'Y'           CER047            1
     C**********           MOVE *ON       *IN47                                      BUG24706 CER059
     C                   MOVE      *ON           *IN62
     C                   ELSE
     C                   MOVE      'N'           CER047
     C**********           MOVE *OFF      *IN47                                      BUG24706 CER059
     C                   MOVE      *OFF          *IN62
      *                                                                                     BUG24706
     C                   ENDIF
      *
     C                   MOVE      'N'           WERR01            1
     C                   MOVE      *ON           *IN46
      *                                                                                       CSD031
      ** Check for switchable feature                                                         CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD042            1
     C                   MOVE      *ON           *IN50
     C                   MOVE      *OFF          *IN48
      *                                                                                       CSD031
      ** If Central (U1=on)                                                                   CSD031
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   MOVE      *ON           *IN51
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *ON           *IN47
      *                                                                                       CSD031
     C                   Z-ADD     80            PLEN             15 5
     C                   MOVE      OVRC(3)       PCMD             80
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PLEN
      *                                                                                       CSD031
     C                   OPEN      GZSDBANK
     C     BJDNWD        CHAIN     GZSDBANK                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      BJDNWD        WGDNWD            5 0
     C                   MOVE      BJDFIN        WGDFIN            1
     C                   ENDIF
     C                   CLOSE     GZSDBANK
      *                                                                                       CSD031
     C                   ELSE
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN61
     C                   MOVE      *OFF          *IN47
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
     C                   MOVE      'N'           CSD042
     C                   MOVE      *ON           *IN48
     C                   MOVE      *ON           *IN61
     C                   MOVE      *BLANKS       #1EFDT
     C                   MOVE      *BLANKS       #2PBSR
     C                   MOVE      *BLANKS       #2PBRT
     C                   MOVE      *BLANKS       #2PRSP
     C                   MOVE      *BLANKS       #2PICB
     C                   MOVE      *BLANKS       #2IBSR
     C                   MOVE      *BLANKS       #2IBRT
     C                   MOVE      *BLANKS       #2IRSP
     C                   MOVE      *BLANKS       #2IICB
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD042        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   OPEN      GPLOANL0
     C                   OPEN      GPLOANL1
     C                   OPEN      GPLENOL1
     C                   ELSE
     C                   OPEN      SDLOANL0
     C                   OPEN      SDLOANL1
     C                   OPEN      SDLENOL1
     C                   OPEN      SDALTSL0
     C                   ENDIF
     C                   ELSE
     C                   OPEN      SDLOANL0
     C                   OPEN      SDLOANL1
     C                   OPEN      SDLENOL1
     C                   ENDIF
      *                                                                                       CSD031
     C     P2ANCD        IFEQ      'A'
     C     CSD042        IFEQ      'Y'
     C                   MOVE      *ON           *IN54
     C     *INU1         IFEQ      *OFF
     C                   MOVE      *ON           *IN46
     C                   ENDIF
     C     P1MODE        IFEQ      '1'
     C     *INU1         ANDEQ     *OFF
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE134'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    *BLANKS
     C                   MOVE      'Y'           CLE134            1
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      'N'           CLE134
     C                   OTHER
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE134'      DBKEY
     C                   Z-ADD     6             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE036'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    *BLANKS
     C                   MOVE      'Y'           CLE036            1
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      'N'           CLE036
     C                   OTHER
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE036'      DBKEY
     C                   Z-ADD     6             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     CLE036        ANDEQ     'Y'
     C                   MOVE      *ON           *IN72
     C                   ELSE
     C                   MOVE      *OFF          *IN72
     C                   ENDIF
      *                                                                                    AR1022007
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE073'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                    AR1022007
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CRE073            1
     C                   ELSE
     C                   MOVE      'N'           CRE073
     C                   ENDIF
      ** Access SAR details to see if CLE106 is switched on                                 MD055496
      *                                                                                     MD055496
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE106'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                     MD055496
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE106            1
     C                   ENDIF
      *                                                                                     MD055496
      *
     C/COPY WNCPYSRC,SD0281RC16
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT                                                                                  CSD031
      ********************************************************************                    CSD031
      ** SRDATE - Validate Effective Date                                *                    CSD031
      ********************************************************************                    CSD031
     C     SRDATE        BEGSR
      *                                                                                       CSD031
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
      *                                                                                       CSD031
     C                   ENDSR
      *================================================================                       CSD031
      /EJECT                                                                                  CSD031
     CSR   SRSEND        BEGSR
      *================================================================                       CSD031
      *  Send detail to data Queue                                                            CSD031
      *================================================================                       CSD031
      *                                                                                       CSD031
     C                   MOVEL     'GPLOANPD'    WPFNAM
     C                   MOVEL     P1PARM        WKEYS
     C                   MOVEL     @1DBRC        WDATA
     C                   MOVEL     WDTQ          PDQMSG
     C     'SD'          CAT       'ACCPDTQ'     PDQNAM           10
      *                                                                                       CSD031
     C     *LOVAL        SETLL     GPZONEL0
     C                   READ      GPZONEL0                               90
     C     *IN90         DOWEQ     *OFF
     C     ZOMSYS        CAT       'DPLIB'       PDQLIB
     C********** ZOMSYS    CAT  PGMB      PGMNAM 16                                    CSD031 CSC043
     C     ZOMSYS        CAT       PGMB          PGMNAM           17
     C                   CALL      PGMNAM
     C                   PARM                    PDQNAM
     C                   PARM                    PDQLIB           10
     C                   PARM                    PDQMSG
     C                   READ      GPZONEL0                               90
     C                   ENDDO
      *                                                                                       CSD031
      *================================================================                       CSD031
     CSR                 ENDSR
      /EJECT                                                                                  CSD031
     CSR   ZDATE2        BEGSR
      *================================================================                       CSD031
      * Convert Date                                                                          CSD031
      *================================================================                       CSD031
      *                                                                                       CSD031
     C                   CALL      'ZDATE2'
     C                   PARM                    WVLDTE            5 0
     C                   PARM                    WDTFMT            1
     C                   PARM                    WZDATE            6 0
     C                   PARM                    WRNDTE            7
      *                                                                                       CSD031
      *================================================================                       CSD031
     CSR                 ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0281RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0281RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056555
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056555
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0281RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      *  SLPGID - Select Priority Group ID                                                    CLE164
      *                                                               *                       CLE164
      *================================================================                       CLE164
     C     SLPGID        BEGSR
      *                                                                                       CLE164
     C                   MOVEL     #2PGID        PGIDSL            1
     C     PGIDSL        IFEQ      '?'
     C                   CALL      'SD00321S'                           90
     C                   PARM                    W0RTN             7
     C     #2PGID        PARM      #2PGID        WVAR01            3
     C     *IN90         IFEQ      '1'
      *                                                                                       CLE164
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      * Defer confirm                                                                         CLE164
     C                   MOVEL     'Y'           W0DEF             1
     C                   END
     C                   ENDSR
     O*
     O/COPY WNCPYSRC,SD0281ROPG
     O*
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA OVRC
OVRDBF FILE(GPPRDXL0) TOFILE(GPPRODXL0) SHARE(*NO)                                            BG1346
OVRDBF FILE(GPINSXL0) TOFILE(GPINSTXL0) SHARE(*NO)                                            BG1346
OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                                                      CSD031
**CTDATA LNPTYP
6161626164686669686869698061                                                                  CLE134
