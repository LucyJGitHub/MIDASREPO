     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Generation criteria table maintenance')       *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1540 - Generation Criteria Table Maintenance               *
      *                                                               *
      *  Function:  This program controls the display and update of   *
      *             Generation Criteria Table.                        *
      *                                                               *
      *  Called By: On Request                                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD059365           Date 01Dec22               *
      *  Prev Amend No. CFT046             Date 01Dec22               *
      *                 UUC104             Date 01Dec22               *
      *                 AR857777           Date 01Dec22               *      
      *                 MD060968           Date 25Jan23               *
      *                 MD060008           Date 11May21               *
      *                 MD058830           Date 01Oct21               *
      *                 MD058081           Date 11May21               *
      *                 MD058890           Date 21Sep21               *
      *                 MD056560           Date 31Aug20               *
      *                 CSD103             Date 10Aug20               *
      *                 CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD030371           Date 10Sep14               *
      *                 MD030369           Date 10Sep14               *
      *                 MD028110           Date 10Sep14               *
      *                 MD020057           Date 16Apr13               *
      *                 CFT135             Date 20Feb13               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26046           Date 16Sep09               *
      *                 BUG26047           Date 16Sep09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008             Date 10Apr02               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 02JUN00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177947             Date 19APR00               *
      *                 CFT006             Date 09NOV99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT005             Date 07JUL99               *
      *                 162075             Date 25AUG99               *
      *                 165414             Date 31AUG99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 162675             Date 18JUN99               *
      *                 162428             Date 17JUN99               *
      *                 162233             Date 14JUN99               *
      *                 162078             Date 09JUN99               *
      *                 162073             Date 08JUN99               *
      *                 CFT002  *Create    Date 23Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059365 - Mis-aligned ME1540 copy sources                   *
      *  CFT046 - Upgrade CFT046 to FBM 2.1 SP23                      *
      *           RE Transaction Type for FT payments                 *
      *  UUC104 - MPM Integration (Upgrade of 1.4.11.06 CAR UUC069)   *
      *           Use copy hook ME1540C005                            *
      *           Add copy hook UUC104_14, UUC104_015, UUC014_16      *
      *                         UUC104_017                            *
      *  AR857777 - Apply 243390. DR Override Ac = Nostro = Err Msg   *
      *             Ac *NF.  (Child: AR860490)                        *      
      *  MD060968 - Re-deliver correct source                         *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD058890 - Decimal-data error occurred when inserting new    *
      *             record in Generation Criteria Table Maintenance   *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030371 - Update not accepted. Change length of #1GNCR data *
      *             structure from 268 to 316. Applied for MD028110.  *
      *  MD030369 - No network name selected after prompt. Move       *
      *             network name to screen field.                     *
      *             Applied for MD028110.                             *
      *  MD028110 - Prompt (?) field does not work. Move customer to  *
      *             screen field.                                     *
      *  MD020057 - Issues on Message Criteria Rules for CFT148 STP   *
      *             set up                                            *
      *  CFT135 - MT100 MultiCash Interface                           *
      *           Added hooks:                                        *
      *           OFCPYSRCZ,CFT135_015                                *
      *           OFCPYSRCZ,CFT135_016                                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG26046 - Auto authorize tag is missing.                    *
      *  BUG26047 - You cannot recheck STP Charges in CRIT            *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *           Allow "CM" as payment type if a 103 or 101          *
      *           If "CM", disable F8 and clearing type               *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *  CFT009 - FT Fees and Charges                                 *
      *  CFT014 - Straight-through processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  177947 - The auto-authorise field when CFT005 is on is only  *
      *           displaying when first input is made as the ind for  *
      *           CFT005 is blanked out after this.                   *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *  CFT005 - Straight Through Processing Phase 2                 *
      *           Auto-authorisation of STP payments                  *
      *  162075 - Correct cursor positioning                          *
      *  165414 - Recompile over ME1540DF                             *
      *  162675 - No repair functions can be entered for payment type *
      *           ++, **                                              *
      *  162428 - Locking  record                                     *
      *  162233 - Recompile over ME1540DF                             *
      *  162078 - Error fix : ISO eq  fields not reinitialized        *
      *  162073 - Error fix : F12 behaves as F3                       *
      *  CFT002 - Straight Through Processing Phase 1                 *
      *           Based on MEH037 original references                 *
      *           HUB001/DBF091/IMP010/IMP011/DBF142/S01482           *
      *         - Message Repair Details                              *
      *                                                               *
      *****************************************************************
      *
     FME1540DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD1:##RR1)
     F                                     SFILE(#SFLRCD2:##RR2)
     F                                     INFDS(INFDS#)
     F** DSP: Midas ME Generation Criteria Display File
     F*
     F*
     F*SDSMTHV0IF  E           K        DISK
     F** RTV: Midas Settlement Method Definition
     F*
     FMEGNCRL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F** UPD : Midas ME Generation Criteria Header Update
     F*
     FMEGNDTL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F** UPD : Midas ME Generation Criteria Details Update
     F*
     FFDDTSTL1  IF   E           K DISK
     F** RD  : Midas Deal Deal sub-type
     F*
     FMEURPRL0  UF A E           K DISK
     F                                     COMMIT                               162428
     F** ME User Repair
     F*SDMTAGL1* IF   E           K DISK    INFSR(SRFILE)                                   MD056560
     F**********                           RENAME(@EFREJ5:@MTAGL1)                          MD056560
     F*MEINMVL2* IF   E           K DISK                                           MD020057 MD058081
     F** Midas Incoming Valid Messages by Message Type                                      MD020057
     F*                                                                                       CFT046
     FMEGNCRX0  UF A E           K DISK    USROPN                                             CFT046
     F                                     COMMIT                                             CFT046
     F** UPD : Midas ME Generation Criteria Header (Extension file) Update                    CFT046
     F*                                                                                       CFT046
     F/EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   03  -  Exit program  (Command 3)                            *
      *   05  -  Refresh screen (Command 5)                           *
      *   06  -  Detail screen (Command 6)                            *
      *   07  -  Message Repair Details screen (Command 7)            *
      *   09  -  Add mode (Command 9)                                 *
      *   10  -  Delete function (Command 10)                         *
      *   12  -  Previous screen (Command 12)                         *
      *   27  -  Display next subfile page                            *
      *   28  -  Hide and protect clearing type and flag header tag   *   CFT006
      *                                                               *
      *   30  -  Invalid: #2HDTG                                      *   CFT006
      *   31  -  Invalid: #1ACTC, #1NWRK, #2ACTC                      *
      *   32  -  Invalid: #1MTPY, #1PYTP, #2MSEQ                      *
      *   33  -  Invalid: #1MSET, #1SETT, #2MTAG                      *
      *   34  -  Invalid: #2MTPY, #1EXCP, #2OPER                      *
      *   35  -  Invalid: #2MSET                                      *
      *   40  -  Invalid: #2REPT                                      *                       CRE008
      *                                                               *
      *   53  -  Protect and hide function key F7 (Repair functions)  *   162675
      *   54  -  Invalid Auto-authorise field                         *   CFT005
      *   55  -  Position cursor on booking branch field              *   162075
      *   56  -  Position cursor on payment subtype field             *   162075
      *   57  -  Position cursor on book code field                   *   162075
      *   58  -  Position cursor on Cr override field                 *   162075
      *   59  -  Position cursor on Dr override field                 *   162075
      *   60  -  Chain fail on MEGNCRL0/MEGNDTL0                      *
      *   61  -  Read fail on MEGNDTL0                                *
      *   62  -  Read fail on MEURPRL0                                *
      *   63  -  Protect and hide auto-authorise field                *   CFT005
      *   64  -  Enable/Disable 'Header Tag' flag field               *   CFT006
      *   67  -  Position cursor on network field                     *   162075
      *   68  -  CFT009 on, display F8=STP Charges                    *   CFT009
      *   69  -  #1MTPY not defined to be processed via STP           *                     MD020057
      *   70  -  #1MTPY, #1NWRK not defined to be processed via STP   *                     MD020057
      *                                                               *
      *   74  -  Enquiry function                                     *
      *   75  -  Delete function                                      *
      *   76  -  Amend function                                       *
      *   77  -  Insert function                                      *
      *   78  -  Copy function                                        *
      *   79  -  Protect fields                                       *
      *   80  -  Successful lookup indicator                          *
      *   81  -  Nonnumeric character indicator                       *
      *                                                               *
      *   82  -  Clear subfile 2                                      *
      *   83  -  Display subfile 2                                    *
      *   84  -  End of subfile/end of file indicator (MEGNDTL0)      *
      *   85  -  Clear subfile 1                                      *
      *   86  -  Display subfile 1                                    *
      *   87  -  End of subfile/end of file indicator (MEGNCRL0)      *
      *   89  -  Subfile next change                                  *
      *                                                               *
      *   90  -  End of file indicator                                *
      *   91  -  Chain fail in #SFLRCD1                               *
      *   92  -  Modified subfile record indicator                    *
      *   98  -  Force input format                                   *
      *   99  -  General error indicator                              *
      *   U7  -  Database error                                       *
      *   U8  -  Database error                                       *
      *                                                               *
      *****************************************************************
     F/EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #HINIT  -  Initialisation                                    *
      *  #HLDSF  -  Initialise and load subfile page                  *
      *  #HLOAD  -  Load subfile header page                          *
      *  #HDSPK  -  Display key screen                                *
      *  #HPRKY  -  Process key screen                                *
      *  #HPRSF  -  Process subfile header record                     *
      *  #HVACT  -  Validate action code                              *
      *  #HMBAC  -  Check multi-branch actions                        *
      *  #HVMTP  -  Validate message type                             *
      *  #HVNUM  -  Check if field is numeric                         *
      *  #HVHDR  -  Validate header record                            *
      *  #HPRHD  -  Process remaining header details                  *
      *  #HENQY  -  Process enquiry option in header screen           *
      *  #HDLTP  -  Process delete option in header screen            *
      *  #HCOPY  -  Process copy option in header screen              *
      *  #HAMIN  -  Process amend/insert option in header screen      *
      *  #HSFLP  -  Detail subfile processing                         *
      *  #HINLD  -  Initialise and load detail subfile                *
      *  #HLDET  -  Load subfile page of detail records               *
      *  #HDSPD  -  Display detail subfile records                    *
      *  #HVNWK  -  Validate network field                            *
      *  #HVPTP  -  Validate payment type field                       *
      *  #HVSTT  -  Validate settlement type field                    *
      *  #HVEXC  -  Validate exception report req. field              *
      *  #HVAUT  -  Validate auto-authorise field                     *   CFT005
      *  #HPRDK  -  Process detail key screen                         *
      *  #HVDTR  -  Validate detail record                            *
      *  #HPRDT  -  Process remaining detail record fields            *
      *  #HENQ2  -  Process enquiry option in detail screen           *
      *  #HDLT2  -  Process delete option in detail screen            *
      *  #HAMI2  -  Process amend/insert option in detail screen      *
      *  #HVTAG  -  Validate message tag field                        *
      *  #HVTGH  -  Validate flag header tag                          *   CFT006
      *  #HVOPR  -  Validate operator field                           *
      *  #HVF7   -  Validate function key F7 (Repair Functions)       *   162675
      *  #HCLHD  -  Clear header detail fields                        *
      *  #HCLDT  -  Clear detail record fields                        *
      *  #HMVHD  -  Move header details to output fields              *
      *  #HMVDT  -  Move detail fields to output fields               *
      *  #HMVH2  -  Move correct values to remaining header fields    *
      *             for update                                        *
      *  #HMVD2  -  Move correct values to remaining detail fields    *
      *             for update                                        *
      *  #HRLCM  -  Rollback or comit changes                         *
      *  ZASNMS  -  Send message to program's message queue           *
      *  ZXEXPG  -  Cancel and exit program                           *
      *  ZYEXPG  -  Exit program (direct)                             *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
     D*
     D*  Copysource for error processing
     D*
     D**  Array containing Copyright statement
     D HKST            S              2    DIM(7) CTDATA PERRCD(7)
     D**  Array containing valid existing settlement methods
     D HKVN            S              1    DIM(11) CTDATA PERRCD(11)
     D**  Array for set number and sequence number validation
     D HKOP            S              2    DIM(6) CTDATA PERRCD(6)
     D**  Array for set number and sequence number validation
     D HKN             S              1    DIM(3)
     D**  Work array for set number and sequence number
     D**  Work array for set number and sequence number (valid)
     D/COPY WNCPYSRC,ME1540E001
     D*
     D/EJECT
     D**  Data structures:
     D JBDTTM          DS
     D**  Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D                 DS
     D**  Data structure for set/seq number validation
     D  HKV                    1      3  0
     D                                     DIM(3)
     D  @HNUMB                 1      3  0
     D RUNDAT          DS
     D**  Data area RUNDAT
     D  MRDT                   1      7
     D  RDNO                   8     10P 0
     D  SUCP                  11     11
     D  DTFF                  12     12
     D  MBIN                  13     13
     D*
     D ZMUSER          DS
     D  USID                   1     10
     D  UDBC                  11     13
     D  UDDP                  14     16
     D  UBLA                  17     17
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
     D**  Display file information data structure
     D*
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
     D**  File information data structure
     D*
     D*DSNWRK***     E DS                  EXTNAME(SDNWRKPD)                                MD058830
     D DSNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830
     D**  Data Structures for Network Definition
     D*
     D DSBRCA        E DS                  EXTNAME(SDBRCHPD)
     D**  Data Structures for Branch Definition
     D*
     D*DSMTPY***     E DS                  EXTNAME(SDMTPYPD)                                MD060008
     D DSMTPY        E DS                  EXTNAME(SDMTYJW0)                                MD060008
     D**  Data Structures for Message Type Definition
     D*
     D*DSMTAG***     E DS                  EXTNAME(SDMTAGPD)                                MD056560
     D DSMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D**  Data Structures for Message Tag Definition
     D MEINMV        E DS                  EXTNAME(MEIVMJW0)                                MD058081
     D*
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
     D**  Data Structures for Message Tag Definition
     D*
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
     D**  Data Structures for Book codes
     D*                                                                                       CFT046
     DSDRETR         E DS                  EXTNAME(SDRETRPD)                                  CFT046
     D**  Data Structure for Retail Transaction Types Details                                 CFT046
     D*
     D P@ACCT        E DS                  EXTNAME(ACCNTAB)
      * ACCNTABF - Account details record format data structure
     D  @ACCK1                 2     16
      *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
      * @CUST - Customer record format data structure
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      * Data Structures for Nostro Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CFT005
     D* External data structure for SAR file details                      CFT005
     D  SCLCD        E                     EXTFLD(LCD)                          CFT005
     D*                                                                   CFT005
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Data Structures used by Access Programs, Short Data Structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Data Structures used by Access Programs, Long Data Structure
     D*
      *
      * Data Structure redefining Address fields
      *
     D                 DS
     D  ADDRSS                 1    210
     D  ADCHK1                 1     35
     D  ADCHK2                36     70
     D  ADCHK3                71    105
     D  ADCHK4               106    140
     D  ADCHK5               141    175
     D  ADCHK6               176    210
      *
      * Blank Line Analysis data structure
      *
     D  ADCH26                36    210
     D  ADCH36                71    210
      *
      * SWIFT Address Analysis data structure
      *
     D  ADSLSH                 1      1
     D  ADSWFT                 1     11
     D  ADEXSW                12     35
     D  ADSLS2                36     36
     D  ADSWF2                36     46
     D  ADEXS2                47     70
      *
      * Customer Analysis data structure
      *
     D  ADCUST                 1     10
     D  ADEXCS                11     35
     D  ADCNUM                 1      6
     D  ADEXCN                 7     35
     D  ADCUS2                36     45
     D  ADXCS2                46     70
     D  ADCNM2                36     41
     D  ADXCN2                42     70
      *
      * Account Analysis data structure FULL Account
      *
     D  ADGCNM                 1      6
     D  ADGCCY                 7      9
     D**********                             10  13 ADGACD                                    CGL029
     D**********                             14  15 ADGASQ                                    CGL029
     D**********                             16  18 ADGBRC                                    CGL029
     D**********                             16  35 ADEXG1                                    CGL029
     D**********                             19  35 ADEXGL                                    CGL029
     D  ADGACD                10     19
     D  ADGASQ                20     21
     D  ADGBRC                22     24
     D  ADEXG1                22     35
     D  ADEXGL                25     35
      *
      * Partial Account Analysis data structure
      *
     D  ADPCNM                 1      6
     D**********                              7  10 ADPACD                                    CGL029
     D**********                             11  12 ADPASQ                                    CGL029
     D**********                             13  15 ADPBRC                                    CGL029
     D**********                             13  35 ADEXP1                                    CGL029
     D**********                             16  35 ADEXPA                                    CGL029
     D  ADPACD                 7     16
     D  ADPASQ                17     18
     D  ADPBRC                19     21
     D  ADEXP1                19     35
     D  ADEXPA                22     35
      *
      * Nostro Number Account Analysis data structure
      *
     D  ADNOSN                 1      2
     D  ADEXNN                 3     35
      *
      * Nostro Account Analysis data structure
      *
     D  ADFNOS                 1      5
     D  ADFCCY                 1      3
     D  ADFNNB                 4      5
     D  ADFNEX                 6     35
      *
      * Retail Account Analysis data structure
      *
     D  ADACNO                 1     10
     D  ADEXAC                11     35
     D                 DS
      *
      * Data Structure redefining Partial Account
      *
     D**********                              1  12 PTACCT                                    CGL029
     D  PTACCT                 1     18
     D  PTCNUM                 1      6
     D**********                              7  10 PTACOD                                    CGL029
     D**********                             11  12 PTACSQ                                    CGL029
     D  PTACOD                 7     16
     D  PTACSQ                17     18
      *
      *  Defined Constants
      *
      *
     D DIGITS          C                   CONST('0123456789')
     D #PRIME          C                   CONST('PRIME NOSTRO       ')
      *
     D W0DATA          DS           256
     D*
     D**  Define data structure used to pass parameters
     D*
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *                                                                   162428
     D @1GNCR        E DS                  EXTNAME(MEGNCRPD)                    162428
      * Current/previous master file format fields for change control     162428
      *                                                                   162428
     D***********#1GNCR      DS                            167      162428CFT005
     D***********#1GNCR      DS                            168      CFT005CFT009
     D**********#1GNCR      DS                            268                        CFT009 MD030371
     D #1GNCR          DS           316                                                           MD
      * Stored master file format fields                                  162428
      *                                                                   162428
     D @1GNDT        E DS                  EXTNAME(MEGNDTPD)                    162428
      * Current/previous master file format fields for change control     162428
      *                                                                   162428
     D******#1GNDT      DS                            226           162428CFT006
     D***#1GNDT*     DS                            227                                 CFT006 CRE008
     D***#1GNDT*     DS                            228                                 CRE008 CSW209
     D #1GNDT          DS           231
      * Stored master file format fields                                  162428
      *                                                                   162428
     C/EJECT
     C*================================================================
     C*  P R O G R A M   S T A R T
     C*================================================================
     C** Initialise
     C                   EXSR      #HINIT
     C*
     C**  Perform the following until Command 3 is pressed
     C     *IN03         DOUEQ     '1'
     C*
     C**  Initialise and load subfile page
     C     W0RSF1        IFNE      'N'
     C                   EXSR      #HLDSF
     C                   MOVEL     'N'           W0RSF1            1
     C                   END
     C*
     C**  Display key screen
     C                   EXSR      #HDSPK
     C*
     C**  Process screen input
     C     *IN03         IFNE      '1'
     C*
     C**  If Command 5 is pressed, request subfile reload
     C     *IN05         IFEQ      '1'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   CALL      'ZA0250'
     C                   MOVEL     'Y'           W0RSF1
     C                   END
     C*
     C**  Display next subfile page
     C     *IN27         IFEQ      '1'
     C                   EXSR      #HLOAD
     C                   END
     C*
     C**  Process key screen
     C     *IN05         IFNE      '1'
     C     *IN27         ANDNE     '1'
     C                   EXSR      #HPRKY
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C**  Terminate program
     C                   EXSR      ZXEXPG
     C*================================================================
     C*  P R O G R A M   E N D
     C*================================================================
     C/EJECT
     C*****************************************************************
     C**  #HINIT  Subroutine to perform initialisation                *
     C**                                                              *
     C**  Called by   S T A R T                                       *
     C**  Calls       ZYEXPG                                          *
     C**                                                              *
     C*****************************************************************
     C     #HINIT        BEGSR
     C*
     C**  Key list for header file
     C     #HHKEY        KLIST
     C                   KFLD                    #KMTPY
     C                   KFLD                    #KMSET
     C*
     C**  Key list for details file
     C     #HDKEY        KLIST
     C                   KFLD                    #KMTPY            3
     C                   KFLD                    #KMSET            3 0
     C                   KFLD                    #KMSEQ            3 0
     C*
     C**  Key list for deal deal sub-type
     C     #HDSTK        KLIST
     C                   KFLD                    #1PYTP
     C                   KFLD                    #1PYST
      *                                                                                       CSW209
     C     KLVDEF        KLIST
     C                   KFLD                    EFMTAG
     C                   KFLD                    EFMTPY
     C                   KFLD                    EFMSEQ
     C*                                                                                     MD020057
     C**  Key list for Message Type                                                         MD020057
     C*                                                                                     MD020057
     C     #MTKEY        KLIST
     C                   KFLD                    #1MTPY
     C                   KFLD                    #1NWRK
     C*
     C*
     C**  Set up copyright parameter
     C                   MOVEA     CPY@          BIS@             80
     C*
     C**  Setup job date/time
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
     C*
     C**  Update screen time
     C                   TIME                    ##TME             6 0
     C*
     C**  Access MIDAS Rundate from data-area RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7
     C*
     C**  Access data-area ZMUSER
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C*
     C**  Obtain default message file
     C                   MOVEL     'GB'          ZADFMF
     C                   MOVE      'XXUSRMSG'    ZADFMF           10
     C*
     C**  Initialise all indicators
     C*
     C                   MOVEA     *ALL'0'       *IN(1)
     C**  Open files
     C**  Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      MEGNCRL0
     C                   OPEN      MEGNDTL0
     C*
     C**  Maximum record number
     C*
     C                   Z-ADD     *ZERO         ##RMX1            5 0
     C                   Z-ADD     *ZERO         ##RMX2            5 0
     C                   Z-ADD     14            ##SFP1            3 0          SFLPAG1
     C                   Z-ADD     11            ##SFP2            3 0          SFLPAG2
     C                   Z-ADD     1             ##SFR1
     C                   Z-ADD     1             ##SFR2
     C*
     C     *LIKE         DEFINE    GDCMP2        @2CMP2
     C     *LIKE         DEFINE    GDCMP3        @2CMP3
     C     *LIKE         DEFINE    GDCMP4        @2CMP4
     C     *LIKE         DEFINE    GDCMP5        @2CMP5
     C     *LIKE         DEFINE    GDCMP6        @2CMP6
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C*
     C** Access SAR details file to see if CFT005 is installed.           CFT005
     C*                                                                   CFT005
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       P@RTCD            7                           CFT00
     C                   PARM      '*VERIFY'     P@OPTN            7                           CFT00
     C                   PARM      'CFT005'      P@SARD            6                           CFT00
     C     SCSARD        PARM      *BLANKS       DSFDY                                         CFT00
     C*                                                                   CFT005
     C** Allow Auto-authorising                                           CFT005
     C*                                                                   CFT005
     C     P@RTCD        IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT005            1                           CFT00
     C                   SETON                                        63                       CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      'N'           CFT005                                        CFT00
     C                   END                                                                   CFT00
      *                                                                   CFT005
     C** Access SAR details file to see if CFT006 is installed.           CFT006
      *                                                                   CFT006
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       @RTCD             7                           CFT00
     C                   PARM      '*VERIFY'     @OPTN             7                           CFT00
     C                   PARM      'CFT006'      @SARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CFT00
      *                                                                   CFT006
      ** If CFT006 is switched ON                                         CFT006
      *                                                                   CFT006
     C     @RTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT006            1                           CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      'N'           CFT006                                        CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
      ** Access SAR details file to see if CFT009 is installed.           CFT009
     C/COPY WNCPYSRC,ME1540C005
      *                                                                   CFT009
     C                   CALL      'AOSARDR0'                                                  CFT00
     C                   PARM      *BLANKS       @RTCD             7                           CFT00
     C                   PARM      '*VERIFY'     @OPTN             7                           CFT00
     C                   PARM      'CFT009'      @SARD             6                           CFT00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CFT00
      *                                                                   CFT009
      ** If CFT009 is switched ON                                         CFT009
      *                                                                   CFT009
     C     @RTCD         IFEQ      *BLANKS                                                     CFT00
     C                   MOVE      'Y'           CFT009            1                           CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ELSE                                                                  CFT00
     C                   MOVE      'N'           CFT009                                        CFT00
     C                   MOVE      *OFF          *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      *                                                                   CRE008
     C** Access SAR details file to see if CRE008 is installed.           CRE008
      *                                                                   CRE008
     C                   CALL      'AOSARDR0'                                                  CRE00
     C                   PARM      *BLANKS       @RTCD             7                           CRE00
     C                   PARM      '*VERIFY'     @OPTN             7                           CRE00
     C                   PARM      'CRE008'      @SARD             6                           CRE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CRE00
      *                                                                   CRE008
      ** If CFT006 is switched ON                                         CRE008
      *                                                                   CRE008
     C     @RTCD         IFEQ      *BLANKS                                                     CRE00
     C                   MOVE      'Y'           CRE008            1                           CRE00
     C                   ELSE                                                                  CRE00
     C                   MOVE      'N'           CRE008                                        CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                                       CFT046
     C** Access SAR details file to see if CFT046 is installed.                               CFT046
      *                                                                                       CFT046
     C                   CALL      'AOSARDR0'                                                 CFT046
     C                   PARM      *BLANKS       @RTCD                                        CFT046
     C                   PARM      '*VERIFY'     @OPTN                                        CFT046
     C                   PARM      'CFT046'      @SARD                                        CFT046
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT046
      *                                                                                       CFT046
      ** If CFT046 is switched ON                                                             CFT046
      *                                                                                       CFT046
     C     @RTCD         IFEQ      *BLANKS                                                    CFT046
     C                   MOVE      'Y'           CFT046            1                          CFT046
     C                   OPEN      MEGNCRX0                                                   CFT046
     C                   ELSE                                                                 CFT046
     C                   MOVE      'N'           CFT046                                       CFT046
     C                   ENDIF                                                                CFT046
      *                                                                                       CSW209
      ** Check if SWIFT 2009 is installed                                                     CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'
     C                   PARM                    @RTCD
     C     @RTCD         IFEQ      'CSW2009'
     C                   MOVE      'Y'           CSW209            1
     C                   MOVE      *OFF          *IN71
     C     #1MTPY        IFEQ      '101'
     C     #1MTPY        OREQ      '102'
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSW209
     C                   MOVE      *ON           *IN71
     C                   ENDIF
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HLDSF  Subroutine to initialise and load subfile page      *
     C**                                                              *
     C**  Called by   S T A R T                                       *
     C**  Calls       #HLOAD                                          *
     C**                                                              *
     C*****************************************************************
     C     #HLDSF        BEGSR
     C*
     C**  Clear subfile
     C*
     C                   MOVE      '1'           *IN85
     C                   WRITE     #SFLCTL1
     C                   MOVE      '0'           *IN85
     C*
     C**  Reset number of records in subfile
     C*
     C                   Z-ADD     *ZERO         ##RMX1            5 0
     C                   MOVE      '0'           *IN86
     C*
     C**  Clear messages from program message queue
     C*
     C                   CALL      'ZA0250'
     C*
     C**  Position file cursor at the beginning of header file
     C*
     C     *LOVAL        SETLL     MEGNCRL0
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C     *LOVAL        SETLL     MEGNCRX0                                                   CFT046
     C                   ENDIF                                                                CFT046
     C*
     C**  Load subfile page
     C*
     C                   Z-ADD     *ZERO         ##ROK1            5 0
     C                   EXSR      #HLOAD
     C/COPY WNCPYSRC,ME1540C011
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HLOAD  Subroutine to load subfile header page              *
     C**                                                              *
     C**  Called by   #HLDSF                                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HLOAD        BEGSR
     C*
     C**  Setof record error indicators
     C                   MOVE      '0'           *IN31
     C*
     C**  Start at previous highest record in SFL
     C                   Z-ADD     ##RMX1        ##RR1             5 0
     C*
     C**  Load next SFL page until SFL page full
     C     *IN87         DOUEQ     '1'
     C     ##ROK1        OREQ      ##SFP1
     C*
     C                   READ(N)   MEGNCRL0                               87    *87=EOF
     C                   UNLOCK    MEGNCRL0                                                    16242
     C*
     C**  Load SFL fields
     C     *IN87         IFEQ      '0'
     C                   MOVEL     *BLANK        #1ACTC
     C                   MOVEL     GNMTPY        #1MTPY
     C                   MOVEL     GNMSET        #1MSET
     C                   MOVEL     GNNWRK        #1NWRK
     C                   MOVEL     GNSETT        #1SETT
     C                   MOVEL     GNBOKC        #1BOKC
     C                   MOVEL     GNPYST        #1PYST
     C                   MOVEL     GNCSET        #1CSET
     C                   MOVEL     GNDSET        #1DSET
     C                   MOVEL     GNCLRT        #1CLRT
     C                   MOVEL     GNCSND        #1CSND
     C                   MOVEL     GNC50         #1C50
     C                   MOVEL     GNC52         #1C52
     C                   MOVEL     GNC53         #1C53
     C                   MOVEL     GNC54         #1C54
     C                   MOVEL     GNC56         #1C56
     C                   MOVEL     GNC57         #1C57
     C                   MOVEL     GNC58         #1C58
     C                   MOVEL     GNC70         #1C70
     C                   MOVEL     GNC72         #1C72
     C                   MOVEL     GNDESC        #1DESC
     C                   MOVEL     GNDES2        #1DES2
     C                   MOVEL     GNBRCA        #1BRCA
     C                   MOVEL     GNAUTO        #1AUTO                                        CFT00
     C/COPY WNCPYSRC,ME1540C006
     C*                                                                                       CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C                   MOVEL     #1MTPY        #KMTPY                                       CFT046
     C                   MOVE      #1MSET        #KMSET                                       CFT046
     C     #HHKEY        CHAIN     MEGNCRX0                           88                      CFT046
     C                   UNLOCK    MEGNCRX0                                                   CFT046
     C     *IN88         IFEQ      '0'                                                        CFT046
     C                   MOVEL     X0TRAT        #1TRAT                                       CFT046
     C                   ELSE                                                                 CFT046
     C                   MOVE      *BLANKS       #1TRAT                                       CFT046
     C                   ENDIF                                                                CFT046
     C                   ENDIF                                                                CFT046
     C*
     C**  Output to subfile
     C                   ADD       1             ##RR1                86
     C                   ADD       1             ##ROK1
     C                   WRITE     #SFLRCD1
     C*
     C                   END
     C*
     C                   END
     C*
     C**  If no DBF records found, display error message
     C     ##RR1         IFEQ      *ZERO
     C     *IN87         ANDEQ     '1'
     C*
     C**  Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C* Save highest SFL record load can continue at end point
     C     ##RR1         IFGT      ##RMX1
     C     ##RMX1        ADD       1             ##SFR1
     C                   Z-ADD     ##RR1         ##RMX1
     C                   END
     C*
     C                   Z-ADD     0             ##ROK1
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HDSPK  Subroutine to display key screen                    *
     C**                                                              *
     C**  Called by   S T A R T                                       *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HDSPK        BEGSR
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display key screen
     C                   SETON                                        62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXTK
     C                   EXFMT     #SFLCTL1
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C* Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C* Reset global error indicator
     C                   MOVE      '0'           *IN99
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HPRKY  Subroutine to process key screen                    *
     C**                                                              *
     C**  Called by   S T A R T                                       *
     C**  Calls       #HPRSF, #HVMTP, #HVNUM, #HVHDR                  *
     C**                                                              *
     C*****************************************************************
     C     #HPRKY        BEGSR
     C*
     C**  Confirm/update is not deferred
     C*
     C                   MOVEL     'N'           W0DCF             1
     C                   MOVE      '0'           *IN12
     C*
     C     *IN86         IFEQ      '1'
     C*
     C**  Process subfile records
     C                   EXSR      #HPRSF
     C                   END
     C*
     C**  Process add request
     C     *IN09         IFEQ      '1'
     C     W0DCF         ANDEQ     'N'
     C*
     C****Validate action code
     C                   MOVEL     'I'           #HACTC            1
     C                   EXSR      #HVACT
     C*
     C     *IN31         IFEQ      '0'
     C*
     C                   MOVEL     'I'           #1ACTC
     C                   MOVE      '1'           *IN77
     C                   MOVEL     *BLANKS       #1MTPY
     C                   MOVEL     *BLANKS       #1MSET
     C*
     C**  Display and process screen for add request
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** To test if any ? are entered in screen fields
     C*
     C                   MOVEL     'N'           W0PMT             1
     C                   SETON                                        62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXTK
     C                   EXFMT     #RCDKEY
     C*
     C     *IN12         IFNE      '1'
     C     *IN05         ANDNE     '1'
     C     *IN03         ANDNE     '1'
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  Validate message type
     C                   MOVEL     #1MTPY        #HMTPY            3
     C                   EXSR      #HVMTP
     C     *IN32         IFEQ      '0'
     C                   MOVE      #HMTPY        #1MTPY
     C                   END
     C*
     C**  Validate set number
     C                   MOVEL     #1MSET        #HNUM             3
     C                   EXSR      #HVNUM
     C*
     C**  If no error, validate header record
     C     *IN99         IFEQ      '0'
     C                   MOVE      @HNUMB        #1MSET
     C                   EXSR      #HVHDR
     C                   END
     C*
     C                   END
     C*
     C**  If Command 5 is pressed, refresh screen
     C     *IN05         IFEQ      '1'
     C                   MOVE      *BLANKS       #1MTPY
     C                   MOVE      *BLANKS       #1MSET
     C                   MOVEA     '00'          *IN(32)
     C                   CALL      'ZA0250'
     C                   END
     C*
     C**  If Command 12 is pressed, refresh screen
     C     *IN12         IFEQ      '1'
     C                   MOVE      *BLANKS       #1MTPY
     C                   MOVE      *BLANKS       #1MSET
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN(12)
     C                   CALL      'ZA0250'
     C                   MOVEL     'Y'           W0RSF1
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HPRSF  Subroutine to process subfile header record         *
     C**                                                              *
     C**  Called by   #HPRKY                                          *
     C**  Calls       #HVHDR                                          *
     C**                                                              *
     C*****************************************************************
     C     #HPRSF        BEGSR
     C*
     C**  Read first changed subfile record
     C                   READC     #SFLRCD1                               92
     C*
     C     *IN92         DOWEQ     '0'
     C*
     C**  Setof error indicator and SFLNXTCHG
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN98
     C*
     C     #1ACTC        IFNE      *BLANK
     C                   Z-ADD     ##RR1         #HRR1             5 0
     C*
     C****Validate action code
     C                   MOVEL     #1ACTC        #HACTC            1
     C                   EXSR      #HVACT
     C*
     C     *IN31         IFEQ      '1'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C*
     C                   EXSR      #HVHDR
     C*
     C                   END
     C*
     C     *IN92         IFEQ      '0'
     C*
     C**  If there is an error, seton SFLNXTCHG indicator
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   END
     C*
     C**  Save current field values before chaining to subfile
     C     *LIKE         DEFINE    #1NWRK        #HNETW
     C                   MOVEL     #1NWRK        #HNETW
     C     *LIKE         DEFINE    #1SETT        #HSETL
     C                   MOVEL     #1SETT        #HSETL
     C     *LIKE         DEFINE    #1BOKC        #HBOKC
     C                   MOVEL     #1BOKC        #HBOKC
     C     *LIKE         DEFINE    #1TRAT        #HTRAT                                       CFT046
     C                   MOVEL     #1TRAT        #HTRAT                                       CFT046
     C     *LIKE         DEFINE    #1PYST        #HPYST
     C                   MOVEL     #1PYST        #HPYST
     C     *LIKE         DEFINE    #1CSET        #HCSET
     C                   MOVEL     #1CSET        #HCSET
     C     *LIKE         DEFINE    #1DSET        #HDSET
     C                   MOVEL     #1DSET        #HDSET
     C     *LIKE         DEFINE    #1CLRT        #HCLRT
     C                   MOVEL     #1CLRT        #HCLRT
     C     *LIKE         DEFINE    #1CSND        #HCSND
     C                   MOVEL     #1CSND        #HCSND
     C     *LIKE         DEFINE    #1C50         #HC50
     C                   MOVEL     #1C50         #HC50
     C     *LIKE         DEFINE    #1C52         #HC52
     C                   MOVEL     #1C52         #HC52
     C     *LIKE         DEFINE    #1C53         #HC53
     C                   MOVEL     #1C53         #HC53
     C     *LIKE         DEFINE    #1C54         #HC54
     C                   MOVEL     #1C54         #HC54
     C     *LIKE         DEFINE    #1C56         #HC56
     C                   MOVEL     #1C56         #HC56
     C     *LIKE         DEFINE    #1C57         #HC57
     C                   MOVEL     #1C57         #HC57
     C     *LIKE         DEFINE    #1C58         #HC58
     C                   MOVEL     #1C58         #HC58
     C     *LIKE         DEFINE    #1C70         #HC70
     C                   MOVEL     #1C70         #HC70
     C     *LIKE         DEFINE    #1C72         #HC72
     C                   MOVEL     #1C72         #HC72
     C     *LIKE         DEFINE    #1DESC        #HDESC
     C                   MOVEL     #1DESC        #HDESC
     C     *LIKE         DEFINE    #1DES2        #HDES2
     C                   MOVEL     #1DES2        #HDES2
     C     *LIKE         DEFINE    #1BRCA        #HBRCA
     C                   MOVEL     #1BRCA        #HBRCA
     C     *LIKE         DEFINE    #1AUTO        #HAUTO                                        CFT00
     C                   MOVEL     #1AUTO        #HAUTO                                        CFT00
     C*
     C     #HRR1         CHAIN     #SFLRCD1                           91
     C*
     C**  Move current field values before subfile update
     C                   MOVEL     #HNETW        #1NWRK
     C                   MOVEL     #HSETL        #1SETT
     C                   MOVEL     #HBOKC        #1BOKC
     C                   MOVEL     #HTRAT        #1TRAT                                       CFT046
     C                   MOVEL     #HPYST        #1PYST
     C                   MOVEL     #HCSET        #1CSET
     C                   MOVEL     #HDSET        #1DSET
     C                   MOVEL     #HCLRT        #1CLRT
     C                   MOVEL     #HCSND        #1CSND
     C                   MOVEL     #HC50         #1C50
     C                   MOVEL     #HC52         #1C52
     C                   MOVEL     #HC53         #1C53
     C                   MOVEL     #HC54         #1C54
     C                   MOVEL     #HC56         #1C56
     C                   MOVEL     #HC57         #1C57
     C                   MOVEL     #HC58         #1C58
     C                   MOVEL     #HC70         #1C70
     C                   MOVEL     #HC72         #1C72
     C                   MOVEL     #HDESC        #1DESC
     C                   MOVEL     #HDES2        #1DES2
     C                   MOVEL     #HBRCA        #1BRCA
     C                   MOVEL     #HAUTO        #1AUTO                                        CFT00
     C                   END
     C*
     C                   END
     C*
     C*
     C     *IN92         IFEQ      '0'
     C                   UPDATE    #SFLRCD1
     C                   READC     #SFLRCD1                               92
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVACT  Subroutine to validate action code                  *
     C**                                                              *
     C**  Called by   #HPRKY, #HPRDR                                  *
     C**  Calls       #HMBAC, ZASNMS                                  *
     C**                                                              *
     C*****************************************************************
     C*
     C     #HVACT        BEGSR
     C*
     C                   MOVE      '0'           *IN31
     C*
     C*   Check*all valid action codes
     C     #HACTC        IFNE      'I'
     C     #HACTC        ANDNE     'A'
     C     #HACTC        ANDNE     'D'
     C     #HACTC        ANDNE     'E'
     C     #HACTC        ANDNE     'C'
     C*
     C*   Send*message 'Invalid Action code'
     C                   MOVEL     'MIN0008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN99
     C*
     C                   END
     C*
     C*   Check multi-branch actions
     C*
     C     *IN31         IFNE      '1'
     C                   EXSR      #HMBAC
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HMBAC  Subroutine to check multi-branch action codes.      *
     C**                                                              *
     C**  Called by   #HVACT                                          *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HMBAC        BEGSR
     C*
     C**  Set up parameters
     C*
     C                   CLEAR                   W0DATA
     C                   MOVEL     *BLANKS       B#BRCA
     C                   MOVEL     #HACTC        O#ACTD
     C                   MOVEL     ##PGM         O#CPGM
     C*
     C**  Check all valid actions
     C*
     C                   CALL      'ME1190'                             9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      '*ACTCODE'    W0ACT             8
     C                   PARM                    W0DATA
     C*
     C**  Option ended in error
     C*
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'MIN0019'     P0RTN
     C                   SETON                                        9831      *
     C                   END
     C*
     C**  Invalid action
     C*
     C     P0RTN         IFNE      *BLANKS
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN99
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVMTP  Subroutine to validate message type                 *
     C**                                                              *
     C**  Called by   #HPRKY, #HCOPY                                  *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVMTP        BEGSR
     C*
     C                   MOVE      '0'           *IN32
     C                   MOVE      '0'           *IN34
      *
     C                   MOVEL     #HMTPY        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #HMTPY
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   END
      *
     C*
     C**  Access message type file
     C*
     C                   CALL      'AOMTPYR0'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #HMTPY        P@MTPY            3            I:Key field
     C                   PARM      *BLANKS       DSFDY                          O:Format
     C*
     C**  Analyse return code
     C*
     C     P@RTCD        IFNE      *BLANKS
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        323499
     C*
     C* Send message 'Message type not found'
     C                   MOVEL     'MIN0058'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
     C*****#HMTPY        SETLL     MEINMVL2                               69                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVMTPY = :#HMTPY                                                              MD058081
     C+   and MVACPT = '*AUTO'                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETON                                        69                    MD058081
     C                   IF        SQLCODE = 100                                            MD058081
     C                   SETOFF                                       69                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
     C     *IN69         IFEQ      '1'
     C                   MOVEL     'Y'           OKSTP             1
     C                   ENDIF
     C*                                                                                     MD020057
     C**  Send message 'The Message type &1 is not defined to be processed                  MD020057
     C**  via STP for any network'                                                          MD020057
     C*                                                                                     MD020057
     C     OKSTP         IFNE      'Y'
     C                   SETON                                        323399
     C                   MOVEL     #1MTPY        ZAMSDA
     C                   MOVEL     'MIN0610'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      P@MTPY        #HMTPY
     C                   ENDIF
     C                   END
     C*
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVNUM  Subroutine to validate set number and sequence no.  *
     C**                                                              *
     C**  Called by   #HPRKY, #HCOPY, #HPRDK                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVNUM        BEGSR
     C*
     C                   MOVE      '0'           *IN33
     C                   MOVE      '0'           *IN35
     C*
     C                   MOVEA     *BLANKS       HKN(1)
     C                   MOVEA     #HNUM         HKN(1)
     C                   Z-ADD     0             @HNUMB            3 0
     C                   Z-ADD     0             @X                1 0
     C                   MOVE      '0'           *IN81
     C*
     C**  Check each array element
     C     1             DO        3             @X
     C                   MOVE      HKN(@X)       @CHAR             1
     C     @CHAR         LOOKUP    HKVN                                   80
     C     *IN80         IFEQ      '0'
     C                   MOVE      '1'           *IN81
     C                   END
     C                   END
     C*
     C     *IN81         IFEQ      '1'
     C     #HNUM         OREQ      *BLANK
     C     #HNUM         OREQ      *ZEROS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        333599
     C*
     C**  Send message 'Number is invalid'
     C                   MOVEL     'MIN0264'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
     C*
     C                   Z-ADD     3             @Y                1 0
     C                   Z-ADD     3             @X
     C                   Z-ADD     *ZEROS        HKV(1)
     C     @X            DOUEQ     0
     C                   MOVE      HKN(@X)       @CHAR
     C*
     C**  Remove leading, trailing and embedded blanks
     C     @CHAR         IFNE      ' '
     C                   MOVE      @CHAR         HKV(@Y)
     C                   SUB       1             @Y
     C                   END
     C*
     C                   SUB       1             @X
     C                   END
     C*
     C                   END
     C                   MOVEL     *BLANKS       #HNUM
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVHDR  Subroutine to validate header record                *
     C**                                                              *
     C**  Called by   #HPRSF                                          *
     C**  Calls       #HPRHD, ZASNMS                                  *
     C**                                                              *
     C*****************************************************************
     C     #HVHDR        BEGSR
     C*
     C**  Check if header record exists
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C                   CLEAR                   @GNCRPD                                    MD058890
     C     #HHKEY        CHAIN     MEGNCRL0                           6099
     C                   UNLOCK    MEGNCRL0                                                    16242
     C** Hold existing image                                              162428
     C                   MOVEL     @1GNCR        #1GNCR                                        16242
     C*
     C     *IN99         IFEQ      '1'
     C                   SETON                                        3233
     C* Send message 'Record is already in use'
     C                   MOVEL     'MIN0272'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   MOVEL     'Y'           W0DCF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C     *IN60         IFEQ      '1'
     C*
     C     #1ACTC        IFNE      'I'
     C                   SETON                                        323399
     C* Send message 'Record does not exist'
     C                   MOVEL     'MIN0271'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   MOVEL     'Y'           W0DCF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
     C*
     C     #1ACTC        IFEQ      'I'
     C                   SETON                                        323399
     C* Send message 'Record already exists'
     C                   MOVEL     'MIN0270'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   MOVEL     'Y'           W0DCF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   END
     C*
     C     *IN99         IFEQ      '0'
     C*
     C**  Process remaining header details
     C                   EXSR      #HPRHD
     C*
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HPRHD  Subroutine to process remaining header details      *
     C**                                                              *
     C**  Called by   #HVHDR                                          *
     C**  Calls       #HCLHD, #HMVHD, #HENQY, #HDLTP, #HAMIN,         *
     C**              #HCOPY, #HRLCM                                  *
     C**                                                              *
     C*****************************************************************
     C     #HPRHD        BEGSR
     C*
     C                   MOVE      *BLANK        #HOK              1
     C*
     C**  Clear header detail fields
     C                   EXSR      #HCLHD
     C*
     C**  Set up remaining header detail fields for output
     C                   EXSR      #HMVHD
     C*
     C** If action code is 'E'
     C     #1ACTC        CASEQ     'E'           #HENQY
     C*
     C** If action code is 'D'
     C     #1ACTC        CASEQ     'D'           #HDLTP
     C*
     C** If action code is 'C'
     C     #1ACTC        CASEQ     'C'           #HCOPY
     C*
     C** If action code is 'A'
     C     #1ACTC        CASEQ     'A'           #HAMIN
     C*
     C** If action code is 'I'
     C     #1ACTC        CASEQ     'I'           #HAMIN
     C                   END
     C*
     C**  Rollback or comit any changes
     C**  Applicable only in copy, delete . Other cases handle their      162428
     C**  own commitement                                                 162428
     C     #HACTC        IFEQ      'C'                                                         16242
     C     #HACTC        OREQ      'D'                                                         16242
     C                   EXSR      #HRLCM
     C                   END                                                                   16242
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HENQY  Subroutine to perform enquiry option                *
     C**                                                              *
     C**  Called by   #HPRHD                                          *
     C**  Calls       #HPRDK                                          *
     C**                                                              *
     C*****************************************************************
     C     #HENQY        BEGSR
     C*
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C*
     C                   MOVE      '1'           *IN79
     C                   MOVE      '1'           *IN74
     C*                                                                   162675
     C** Repair Function works only for payment type IN OP                162675
     C** Hide function key F7 if its not the case                         162675
     C     #1PYTP        IFEQ      '**'                                                        16267
     C     #1PYTP        OREQ      '++'                                                        16267
     C                   SETON                                        53                       16267
     C                   ENDIF                                                                 16267
     C*                                                                   CRE008
     C* supress F8 if 'CM'                                                CRE008
     C     #1PYTP        IFEQ      'CM'                                                        CRE00
     C                   MOVE      *OFF          *IN68                                         CRE00
     C                   ENDIF                                                                 CRE00
     C*                                                                   CRE008
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display header detail screen
     C                   SETON                                        62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C                   EXFMT     #RCDDTL4                                                   CFT046
     C                   ELSE                                                                 CFT046
     C                   EXFMT     #RCDDTL1
     C                   ENDIF                                                                CFT046
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  If Command 12 is pressed, go back to key screen
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN12
     C                   SETON                                        92
     C                   END
     C*
     C  N12
     CANN03
     CANN06              SETON                                        12
     C   05              SETOFF                                       12
      *
     C     *IN07         IFEQ      *OFF
     C                   MOVE      *ON           *IN12
     C                   ENDIF
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C     *IN08         ANDEQ     *OFF                                                        CFT00
     C                   MOVE      *ON           *IN12                                         CFT00
     C                   ENDIF                                                                 CFT00
     C*
     C**  If Cmd 06 is pressed, display and process detail key screen
     C     *IN06         IFEQ      '1'
     C                   EXSR      #HSFLP
     C                   SETOFF                                       92
     C                   END
      *
      *** If Cmd 07 is pressed, display and process message repair scn
      *
     C     *IN07         IFEQ      *ON
     C                   CALL      'ME1600'
     C                   PARM      #1MTPY        WMTPY             3
     C                   PARM      #1MSET        WMSET             3
     C                   PARM                    WFKEY             3                           16207
     C     WFKEY         IFEQ      'F03'                                                       16207
     C                   SETON                                        03                       16207
     C                   ENDIF                                                                 16207
     C     WFKEY         IFEQ      'F12'                                                       16207
     C                   SETOFF                                       12                       16207
     C                   ENDIF                                                                 16207
     C                   MOVE      *OFF          *IN92
     C                   ENDIF
      *                                                                   CFT009
      *** If Cmd 08 is pressed, display and process STP charges screen    CFT009
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C     *IN08         ANDEQ     *ON                                                         CFT00
     C                   CALL      'ME1570'                                                    CFT00
     C                   PARM      #1ACTC        WACTC             1                           CFT00
     C                   PARM      #1MTPY        WMTPY             3                           CFT00
     C                   PARM      #1MSET        WMSET             3                           CFT00
     C                   PARM                    WFKEY             3                           CFT00
     C                   PARM                    #1GNCR                                        CFT00
     C     WFKEY         IFEQ      'F03'                                                       CFT00
     C                   MOVE      *ON           *IN03                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     WFKEY         IFEQ      'F12'                                                       CFT00
     C                   MOVE      *OFF          *IN12                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   MOVE      *OFF          *IN92                                         CFT00
     C                   ENDIF                                                                 CFT00
     C*
     C   03              SETON                                        92
     C*
     C                   END
     C                   MOVEL     'Y'           W0RSF1
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HDLTP  Subroutine to perform deletion                      *
     C**                                                              *
     C**  Called by    #HPRHD                                         *
     C**  Calls        Nothing                                        *
     C**                                                              *
     C*****************************************************************
     C     #HDLTP        BEGSR
     C                   MOVE      *BLANK        #HOK
     C*
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C     *IN99         OREQ      '1'
     C     #HOK          OREQ      'Y'
     C                   MOVE      '1'           *IN75
     C                   MOVE      '0'           *IN74
     C                   MOVE      '0'           *IN76
     C                   MOVE      '0'           *IN77
     C                   MOVE      '1'           *IN79
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display header detail screen
     C                   SETON                                        62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C                   EXFMT     #RCDDTL4                                                   CFT046
     C                   ELSE                                                                 CFT046
     C                   EXFMT     #RCDDTL1
     C                   ENDIF                                                                CFT046
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  If Cmd 10 is pressed
     C     *IN10         IFEQ      '1'
     C*
     C**  Delete header record
     C*
     C**  Position to detail records to be deleted
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C     #HHKEY        SETLL     MEGNDTL0
     C                   READ      @GNDTPD                              9961
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           #HOK
     C* Send message 'Record is in use by other'
     C                   MOVEL     'MIN0272'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C*
     C**  Delete header record
     C                   MOVEL     #1MTPY        #KMTPY                                        16242
     C                   MOVE      #1MSET        #KMSET                                        16242
     C     #HHKEY        CHAIN     MEGNCRL0                           99                       16242
     C     *IN99         IFEQ      '0'                                                         16242
     C                   DELETE    @GNCRPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNCRL0                                                    16242
     C                   GOTO      ENDDEL                                                      16242
     C                   END                                                                   16242
     C                   END                                                                   16242
      *                                                                                       CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C     #HHKEY        CHAIN     MEGNCRX0                           88                      CFT046
     C     *IN88         IFEQ      '0'                                                        CFT046
     C                   DELETE    MEGNCRD0                             88                    CFT046
     C     *IN88         IFEQ      '1'                                                        CFT046
      * Change error detected                                                                 CFT046
     C                   MOVEL     'Y2U0004'     ZAMSID                                       CFT046
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                       CFT046
     C                   EXSR      ZASNMS                                                     CFT046
     C                   SETON                                        99                      CFT046
     C                   UNLOCK    MEGNCRX0                                                   CFT046
     C                   GOTO      ENDDEL                                                     CFT046
     C                   ENDIF                                                                CFT046
     C                   ENDIF                                                                CFT046
     C                   ENDIF                                                                CFT046
     C*
     C**  Delete corresponding detail records
     C     #KMTPY        DOWEQ     GDMTPY
     C     #KMSET        ANDEQ     GDMSET
     C     *IN61         ANDEQ     '0'
     C                   DELETE    @GNDTPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   GOTO      ENDDEL                                                      16242
     C                   END                                                                   16242
     C                   READ      @GNDTPD                                61
     C                   END
     C*
     C**  Position repair records to be deleted
     C     #HHKEY        SETLL     MEURPRL0
     C                   READ      MEURPRL0                             9962
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #HOK
     C*
     C* Send message 'Record is in use by other'
     C*
     C                   MOVEL     'MIN0272'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C*
     C**  Delete corresponding repair details
     C*
     C     #KMTPY        DOWEQ     RPMTPY
     C     #KMSET        ANDEQ     RPMSET
     C     *IN62         ANDEQ     *OFF
     C*********************DELET@URPRPD                                   162428
     C                   DELETE    @URPRPD                              99                     16242
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   GOTO      ENDDEL                                                      16242
     C                   END                                                                   16242
     C                   READ      MEURPRL0                               62
     C                   ENDDO
     C                   MOVE      'Y'           #HOK
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   END
     C*                                                                   162428
     C     ENDDEL        TAG                                                                   16242
     C*
     C**  If Cmd 12 is pressed
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN12
     C                   SETON                                        92
     C                   MOVEL     'Y'           W0RSF1
     C                   END
     C*
     C   03              SETON                                        92
     C*
     C                   END
     C*
     C**  If deletion is successful
     C     #HOK          IFEQ      'Y'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      *BLANKS       #1ACTC
     C                   MOVEL     'Y'           W0RSF1
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HCOPY  Subroutine to copy a header record                  *
     C**                                                              *
     C**  Called by   #HPRHD                                          *
     C**  Calls       #HVMTP, #HVNUM                                  *
     C**                                                              *
     C*****************************************************************
     C     #HCOPY        BEGSR
     C*
     C                   MOVE      *BLANKS       #2MTPY
     C                   MOVE      *BLANKS       #2MSET
     C                   MOVE      *BLANK        #HOK
     C*
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C     #HOK          OREQ      'Y'
     C*
     C** To test if any ? are entered in screen fields
     C*
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVE      '1'           *IN78
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display key screen
     C                   SETON                                        62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXTK
     C                   EXFMT     #RCDKEY
     C*
     C* If Cmd3 or Cmd12 pressed, then leave the loop
     C*
     C     *IN03         IFEQ      '1'
     C     *IN12         OREQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(4)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   SETON                                        92
     C                   MOVEL     'Y'           W0RSF1
     C                   LEAVE
     C                   END
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  Reset global error indicator
     C                   MOVE      '0'           *IN99
     C*
     C**  Validate "TO" message type field
     C                   MOVEL     #2MTPY        #HMTPY
     C                   EXSR      #HVMTP
     C     *IN34         IFEQ      '0'
     C                   MOVE      #HMTPY        #2MTPY
     C                   END
     C*
     C**  Validate "TO" set number field
     C                   MOVEL     #2MSET        #HNUM
     C                   EXSR      #HVNUM
     C*
     C**  Check if "TO" header record does not exist
     C     *IN99         IFEQ      '0'
     C     *IN05         ANDNE     '1'
     C     *IN03         ANDNE     '1'
     C                   MOVE      @HNUMB        #2MSET
     C                   MOVEL     #2MTPY        #KMTPY
     C                   MOVE      #2MSET        #KMSET
     C     #HHKEY        CHAIN(N)  MEGNCRL0                           60
     C                   UNLOCK    MEGNCRL0                                                    16242
     C*
     C     *IN60         IFEQ      '0'
     C                   SETON                                        343599
     C*
     C* Send message 'Record already exists'
     C                   MOVEL     'MIN0270'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C*
     C**  Set up header fields and write a new record
     C                   ELSE
     C                   MOVEL     #2MTPY        GNMTPY
     C                   MOVE      #2MSET        GNMSET
     C                   MOVEL     ##JOB         GNAJOB                         Job name
     C                   MOVEL     ##USR         GNAUSR                         User name
     C                   TIME                    ##JTM
     C                   Z-ADD     ##JTM         GNATIM                         Action Time
     C                   MOVEL     WUMRDT        GNARDT                         Action Date
     C                   MOVEL     'I'           GNAACT                         Action Type
     C                   Z-ADD     WURDNB        GNRDNB                         Run day number
     C                   WRITE     @GNCRPD                              99
      *                                                                                       CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C     #HHKEY        CHAIN     MEGNCRX0                           88                      CFT046
      *                                                                                       CFT046
     C                   MOVEL     #1TRAT        X0TRAT                                       CFT046
      *                                                                                       CFT046
     C     *IN88         IFEQ      '0'                                                        CFT046
     C                   UPDATE    MEGNCRD0                             88                    CFT046
     C                   ELSE                                                                 CFT046
     C                   MOVEL     #2MTPY        X0MTPY                                       CFT046
     C                   MOVE      #2MSET        X0MSET                                       CFT046
     C                   WRITE     MEGNCRD0                             88                    CFT046
     C                   ENDIF                                                                CFT046
     C                   ENDIF                                                                CFT046
     C*
     C**  Position to detail records to be copied
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C     #HHKEY        SETLL     MEGNDTL0
     C                   READ(N)   MEGNDTL0                               61
     C                   UNLOCK    MEGNDTL0                                                    16242
     C*
     C**  Copy detail records
     C     #KMTPY        DOWEQ     GDMTPY
     C     #KMSET        ANDEQ     GDMSET
     C     *IN61         ANDEQ     '0'
     C                   MOVEL     #2MTPY        GDMTPY
     C                   MOVE      #2MSET        GDMSET
     C                   WRITE     @GNDTPD                              99
     C                   READ(N)   MEGNDTL0                               61
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   END
     C*
     C**  Position repair details to be copied
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C     #HHKEY        SETLL     MEURPRL0
     C                   READ      MEURPRL0                               62
     C                   UNLOCK    MEURPRL0                                                    16242
     C*
     C**  Copy repair details
     C     #KMTPY        DOWEQ     RPMTPY
     C     #KMSET        ANDEQ     RPMSET
     C     *IN62         ANDEQ     *OFF
     C                   MOVEL     #2MTPY        RPMTPY
     C                   MOVE      #2MSET        RPMSET
     C                   WRITE     @URPRPD                              99
     C                   READ      MEURPRL0                               62
     C                   UNLOCK    MEURPRL0                                                    16242
     C                   ENDDO
     C*
     C                   MOVE      'Y'           #HOK
     C*
     C                   END
     C*
     C                   ELSE
     C                   SETOFF                                       3233
     C                   END
     C*
     C**  If Command 5 is pressed, refresh the "copy to" screen
     C     *IN05         IFEQ      '1'
     C                   MOVE      *BLANKS       #2MTPY
     C                   MOVE      *BLANKS       #2MSET
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   CALL      'ZA0250'
     C                   END
     C*
     C                   END
     C*
     C**  If copy is successful
     C     #HOK          IFEQ      'Y'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVEL     'C'           #HACTC                                        16242
     C                   MOVE      *BLANKS       #1ACTC
     C                   MOVEL     'Y'           W0RSF1
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HAMIN  Subroutine to process amend and insert option       *
     C**                                                              *
     C**  Called by   #HPRHD                                          *
     C**  Calls       #HCLHD, #HVNWK, #HVPTP, #HVSTT, #HVEXC,         *
     C**              #HMVHD, #HMVH2, #HPRDK                          *
     C**                                                              *
     C*****************************************************************
     C     #HAMIN        BEGSR
     C*
     C                   MOVE      *OFF          *IN79
     C*
     C**  If action code is 'I', display blank header fields
     C     #1ACTC        IFEQ      'I'
     C                   EXSR      #HCLHD
     C**  Set up default values for header fields
     C                   MOVEL     'Y'           #1EXCP
     C                   END
     C*
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C*                                                                   CRE008
     C* supress F8 if 'CM'                                                CRE008
     C     #1PYTP        IFEQ      'CM'                                                        CRE00
     C                   MOVE      *OFF          *IN68                                         CRE00
     C                   ENDIF                                                                 CRE00
     C*
     C** To test if any ? are entered in screen fields
     C*
     C                   MOVEL     'N'           W0PMT             1
     C*
     C**  Set up indicators for 'I' or 'A' option
     C     #1ACTC        IFEQ      'I'
     C                   MOVE      '1'           *IN77
     C                   ELSE
     C                   MOVE      '1'           *IN76
     C                   END
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display header detail screen
     C                   SETON                                        62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C                   EXFMT     #RCDDTL4                                                   CFT046
     C                   ELSE                                                                 CFT046
     C                   EXFMT     #RCDDTL1
     C                   ENDIF                                                                CFT046
     C*
     C     *IN03         IFNE      '1'
     C     *IN05         ANDNE     '1'
     C************IN07     ANDNE*ON                                       162675
     C     *IN12         ANDNE     '1'
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  Validate network
     C                   EXSR      #HVNWK
     C*
     C**  Validate branch
     C                   EXSR      #HVBRC
     C*
     C**  Validate Payment type
     C                   EXSR      #HVPTP
     C*
     C**  Validate Payment Sub-type
     C                   EXSR      #HVPST
     C*
     C**  Validate Settlement type
     C                   EXSR      #HVSTT
     C*
     C**  Validate Exception Report Req.
     C                   EXSR      #HVEXC
     C*
     C**  Validate Clearing Type
     C                   EXSR      #HVCLR
     C*
     C**  Validate Book Code
     C                   EXSR      #HVBOK
     C*                                                                   CFT005
     C**  Validate Auto-authorise field                                   CFT005
     C     CFT005        IFEQ      'Y'                                                         CFT00
     C                   EXSR      #HVAUT                                                      CFT00
     C                   END                                                                   CFT00
     C*                                                                                       CFT046
     C**  Validate Transaction Type                                                           CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C                   EXSR      #HVTRT                                                     CFT046
     C                   END                                                                  CFT046
     C*
     C**  Validate Credit Account
     C     #1CSET        IFNE      *BLANKS
     C     #1CSET        ANDNE     #PRIME
     C                   EXSR      #HVCRA
     C                   ENDIF
     C*
     C**  Validate Debit Account
     C     #1DSET        IFNE      *BLANKS
     C     #1DSET        ANDNE     #PRIME
     C                   EXSR      #HVDRA
     C                   ENDIF
     C*
     C**  Validate Clear Options
     C                   EXSR      #HVCLO
     C*                                                                   162675
     C**  Validate Key F7                                                 162675
     C     *IN07         IFEQ      '1'                                                         16267
     C                   EXSR      #HVF7                                                       16267
     C                   ENDIF                                                                 16267
     C*                                                                   CRE008
     C**  Validate Key F8                                                 CRE008
     C     *IN08         IFEQ      '1'                                                         CRE00
     C                   EXSR      #HVF8                                                       CRE00
     C                   ENDIF                                                                 CRE00
     C*
     C**  If no error, update header file
     C     *IN99         IFEQ      '0'
     C*
     C     #1ACTC        IFEQ      'A'                                                         16242
     C                   MOVEL     #1MTPY        #KMTPY                                        16242
     C                   MOVE      #1MSET        #KMSET                                        16242
     C     #HHKEY        CHAIN     MEGNCRL0                           99                       16242
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNCRL0                                                    16242
     C                   ELSE                                                                  16242
      *                                                                   162428
      ** Check for changed record                                         162428
     C     #1GNCR        IFNE      @1GNCR                                                      16242
      ** Send message '*Update not accepted'                              162428
     C                   MOVEL     'Y2U0007'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   UNLOCK    MEGNCRL0                                                    16242
     C                   SETON                                        99                       16242
     C                   END                                                                   16242
     C                   END                                                                   16242
     C                   END                                                                   16242
     C*
     C     *IN99         IFEQ      '0'                                                         16242
     C*
     C**  Move correct values to remaining header details for update
     C                   EXSR      #HMVH2
     C                   MOVEL     ##JOB         GNAJOB                         Job name
     C                   MOVEL     ##USR         GNAUSR                         User name
     C                   TIME                    ##JTM
     C                   Z-ADD     ##JTM         GNATIM                         Action Time
     C                   MOVEL     WUMRDT        GNARDT                         Action Date
     C                   MOVEL     'I'           GNAACT                         Action Type
     C                   Z-ADD     WURDNB        GNRDNB                         Run day number
     C     #1ACTC        IFEQ      'A'
     C                   MOVEL     'A'           GNAACT                         Action Type
     C                   UPDATE    @GNCRPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   UNLOCK    MEGNCRL0                                                    16242
     C                   SETON                                        99                       16242
     C                   ROLBK                                                                 16242
     C                   UNLOCK    MEGNCRL0                                                    16242
     C                   ELSE                                                                  16242
     C** Update saved record image                                        162428
     C                   MOVEL     @1GNCR        #1GNCR                                        16242
      *                                                                                       CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C     #HHKEY        CHAIN     MEGNCRX0                           88                      CFT046
      *                                                                                       CFT046
     C                   MOVEL     #1TRAT        X0TRAT                                       CFT046
      *                                                                                       CFT046
     C     *IN88         IFEQ      '0'                                                        CFT046
     C                   UPDATE    MEGNCRD0                             88                    CFT046
     C                   ELSE                                                                 CFT046
     C                   MOVEL     #1MTPY        X0MTPY                                       CFT046
     C                   MOVE      #1MSET        X0MSET                                       CFT046
     C                   WRITE     MEGNCRD0                             88                    CFT046
     C                   ENDIF                                                                CFT046
      *                                                                                       CFT046
     C                   ENDIF                                                                CFT046
      *                                                                                       CFT046
     C                   COMMIT                                                                16242
     C                   END                                                                   16242
     C                   ELSE
     C                   WRITE     @GNCRPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   ROLBK                                                                 16242
     C                   ELSE                                                                  16242
      *                                                                                       CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C     #HHKEY        CHAIN     MEGNCRX0                           88                      CFT046
      *                                                                                       CFT046
     C                   MOVEL     #1TRAT        X0TRAT                                       CFT046
      *                                                                                       CFT046
     C     *IN88         IFEQ      '0'                                                        CFT046
     C                   UPDATE    MEGNCRD0                             88                    CFT046
     C                   ELSE                                                                 CFT046
     C                   MOVEL     #1MTPY        X0MTPY                                       CFT046
     C                   MOVE      #1MSET        X0MSET                                       CFT046
     C                   WRITE     MEGNCRD0                             88                    CFT046
     C                   ENDIF                                                                CFT046
      *                                                                                       CFT046
     C                   ENDIF                                                                CFT046
      *                                                                                       CFT046
     C                   COMMIT                                                                16242
     C                   END                                                                   16242
     C                   END
     C*
     C**  Only if function key F7 not pressed                             162675
     C**  Or if function key F8 not pressed (CFT009 is on)                CFT009
     C**  => We will call ME1600 then                                     162675
     C     *IN07         IFEQ      *OFF                                                        16267
     C     *IN08         ANDEQ     *OFF                                                        CFT00
     C     *IN99         IFEQ      '0'                                                         16242
     C     #1ACTC        IFEQ      'I'
     C**  Display and process detail key screen
     C                   MOVE      '1'           *IN09
     C                   MOVE      '0'           *IN83
     C                   EXSR      #HPRDK
     C                   ELSE
     C                   EXSR      #HSFLP
     C                   END
     C                   END                                                                   16242
     C                   ENDIF                                                                 16267
     C*
     C                   END
     C*
     C                   END
     C*                                                                   162428
     C                   END                                                                   16242
     C*
     C**  If Command 12 is pressed, go back to key screen
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C********** CFT005    IFEQ 'Y'                                                  177947 BUG26046
     C**********           SETON                     63                              177947 BUG26046
     C**********           ENDIF                                                     177947 BUG26046
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'
     C                   SETON                                        63
     C                   ENDIF
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN12
     C                   MOVEL     'Y'           W0RSF1
     C                   SETON                                        92
     C                   END
     C*
     C   03              SETON                                        92
     C*
     C**  If Command 5 is pressed, refresh screen
     C     *IN05         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   EXSR      #HCLHD
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C     #1ACTC        IFEQ      'A'
     C                   EXSR      #HMVHD
     C                   ELSE
     C**  Set up default values for header fields
     C                   MOVEL     'Y'           #1EXCP
     C                   END
     C                   END
     C*
      *
      *** If Cmd 07 is pressed, display and process message repair scn
      *** Only if no errors                                               162675
      *
     C     *IN99         IFEQ      *OFF                                                        16267
     C     *IN07         IFEQ      *ON
     C                   CALL      'ME1600'
     C                   PARM      #1MTPY        WMTPY             3
     C                   PARM      #1MSET        WMSET             3
     C                   PARM                    WFKEY             3                           16207
     C     WFKEY         IFEQ      'F03'                                                       16207
     C                   SETON                                        03                       16207
     C                   ENDIF                                                                 16207
     C     WFKEY         IFEQ      'F12'                                                       16207
     C                   SETOFF                                       12                       16207
     C                   ENDIF                                                                 16207
     C                   ENDIF
     C                   ENDIF                                                                 16267
      *                                                                   CFT009
      *** If Cmd 08 is pressed, display and process STP Charges screen    CFT009
      *** Only if no errors                                               CFT009
      *                                                                   CFT009
     C     *IN99         IFEQ      *OFF                                                        CFT00
     C     *IN08         IFEQ      *ON                                                         CFT00
     C                   CALL      'ME1570'                                                    CFT00
     C                   PARM      #1ACTC        WACTC             1                           CFT00
     C                   PARM      #1MTPY        WMTPY             3                           CFT00
     C                   PARM      #1MSET        WMSET             3                           CFT00
     C                   PARM                    WFKEY             3                           CFT00
     C                   PARM                    #1GNCR                                        CFT00
     C     WFKEY         IFEQ      'F03'                                                       CFT00
     C                   MOVE      *ON           *IN03                                         CFT00
     C                   ENDIF                                                                 CFT00
     C     WFKEY         IFEQ      'F12'                                                       CFT00
     C                   MOVE      *OFF          *IN12                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HSFLP  Subroutine for detail subfile processing            *
     C**                                                              *
     C**  Called by   #HENQY, #HAMIN                                  *
     C**  Calls       #HINLD, #HDSPD, #HLDET, #HPRDK                  *
     C**                                                              *
     C*****************************************************************
     C     #HSFLP        BEGSR
     C*
     C     #1MTPY        IFEQ      '101'
     C     #1MTPY        OREQ      '102'
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
     C                   MOVEL     'Y'           W0RSF2
     C*
     C**  Perform the following until Command 3 is pressed
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C*
     C**  Initialise and load subfile page
     C     W0RSF2        IFNE      'N'
     C                   EXSR      #HINLD
     C                   MOVEL     'N'           W0RSF2            1
     C                   END
     C*
     C**  Display detail key screen
     C                   EXSR      #HDSPD
     C*
     C**  Process screen input
     C     *IN03         IFNE      '1'
     C     *IN12         ANDNE     '1'
     C*
     C**  If Command 5 is pressed, request subfile reload
     C     *IN05         IFEQ      '1'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   CALL      'ZA0250'
     C                   MOVEL     'Y'           W0RSF2
     C                   END
     C*
     C**  Display next subfile page
     C     *IN27         IFEQ      '1'
     C                   EXSR      #HLDET
     C                   END
     C*
     C**  Process key screen
     C     *IN05         IFNE      '1'
     C     *IN27         ANDNE     '1'
     C                   EXSR      #HPRDK
     C   12              SETOFF                                       12
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C   12              SETOFF                                       12
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HINLD  Subroutine to initialise and load subfile page of   *
     C**          detail key screen                                   *
     C**                                                              *
     C**  Called by   #HSFLP                                          *
     C**  Calls       #HLDET                                          *
     C**                                                              *
     C*****************************************************************
     C     #HINLD        BEGSR
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVE      *OFF          *IN71
     C     #1MTPY        IFEQ      '101'
     C     #1MTPY        OREQ      '102'
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN71
     C                   ENDIF
     C*
     C**  Clear subfile
     C*
     C                   MOVE      '1'           *IN82
     C                   WRITE     #SFLCTL2
     C                   MOVE      '0'           *IN82
     C*
     C**  Reset number of records in subfile
     C*
     C                   Z-ADD     *ZERO         ##RMX2            5 0
     C                   MOVE      '0'           *IN83
     C*
     C**  Clear messages from program message queue
     C*
     C                   CALL      'ZA0250'
     C*
     C**  Position file cursor at the beginning of header file
     C*
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C     #HHKEY        SETLL     MEGNDTL0
     C*
     C**  Load subfile page
     C*
     C                   MOVEL     *BLANKS       @2CMP2
     C                   MOVEL     *BLANKS       @2CMP3
     C                   MOVEL     *BLANKS       @2CMP4
     C                   MOVEL     *BLANKS       @2CMP5
     C                   MOVEL     *BLANKS       @2CMP6
     C                   Z-ADD     *ZERO         ##ROK2            5 0
     C                   EXSR      #HLDET
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HLDET  Subroutine to load subfile page of detail screen    *
     C**                                                              *
     C**  Called by   #HINLD                                          *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HLDET        BEGSR
     C*
     C**  Setof record error indicators
     C                   MOVE      '0'           *IN31
     C*
     C**  Start at previous highest record in SFL
     C                   Z-ADD     ##RMX2        ##RR2             5 0
     C*
     C**  Load next SFL page until SFL page full
     C     *IN84         DOUEQ     '1'
     C     ##ROK2        OREQ      ##SFP2
     C     GDMTPY        ORNE      #KMTPY
     C     GDMSET        ORNE      #KMSET
     C*
     C                   READ(N)   MEGNDTL0                               84    *84=EOF
     C                   UNLOCK    MEGNDTL0                                                    16242
     C*
     C**  Load SFL fields
     C     *IN84         IFEQ      '0'
     C     GDMTPY        ANDEQ     #KMTPY
     C     GDMSET        ANDEQ     #KMSET
     C*
     C**  Output previous comparison values if any
     C                   EXSR      #HDSPC
     C*
     C                   MOVEL     *BLANK        #2ACTC
     C                   MOVEL     GDCSEQ        #2MSEQ
     C                   MOVEL     GDMTAG        #1MTAG
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     GDMSEQ        #1TSEQ
     C                   ENDIF
     C                   MOVEL     GDOPER        #2OPER
     C                   MOVEL     GDCMP1        #2CMP1
     C                   MOVEL     GDCMP2        @2CMP2
     C                   MOVEL     GDCMP3        @2CMP3
     C                   MOVEL     GDCMP4        @2CMP4
     C                   MOVEL     GDCMP5        @2CMP5
     C                   MOVEL     GDCMP6        @2CMP6
     C                   MOVEL     GDHDTG        #2HDTG                                 CFT006
     C*
     C**  Output to subfile
     C                   ADD       1             ##RR2                83
     C                   ADD       1             ##ROK2
     C                   WRITE     #SFLRCD2
     C*
     C**  Output all comparison values
     C                   EXSR      #HDSPC
     C*
     C                   END
     C*
     C                   END
     C*
     C**  Output previous comparison values if any
     C                   EXSR      #HDSPC
     C*
     C*
     C**  If no DBF records found, display error message
     C     ##RR2         IFEQ      *ZERO
     C*
     C**  Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C* Save highest SFL record load can continue at end point
     C     ##RR2         IFGT      ##RMX2
     C     ##RMX2        ADD       1             ##SFR2
     C                   Z-ADD     ##RR2         ##RMX2
     C                   END
     C*
     C* If no more matching record, seton subfile end indicator
     C     *IN84         IFEQ      '0'
     C     GDMTPY        IFNE      #KMTPY
     C     GDMSET        ORNE      #KMSET
     C                   MOVE      '1'           *IN84
     C                   END
     C                   END
     C*
     C                   Z-ADD     0             ##ROK2
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HDSPC  Subroutine to display subfile detail comparison val *
     C**                                                              *
     C**  Called by                                                   *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HDSPC        BEGSR
     C*
     C     @2CMP2        IFNE      *BLANKS
     C     ##ROK2        ANDLT     ##SFP2
     C                   SETON                                        51
     C                   MOVEL     @2CMP2        #2CMP1
     C                   ADD       1             ##RR2                83
     C                   ADD       1             ##ROK2
     C                   WRITE     #SFLRCD2
     C                   MOVEL     *BLANKS       @2CMP2
     C                   END
     C*
     C     @2CMP3        IFNE      *BLANKS
     C     ##ROK2        ANDLT     ##SFP2
     C                   SETON                                        51
     C                   MOVEL     @2CMP3        #2CMP1
     C                   ADD       1             ##RR2                83
     C                   ADD       1             ##ROK2
     C                   WRITE     #SFLRCD2
     C                   MOVEL     *BLANKS       @2CMP3
     C                   END
     C*
     C     @2CMP4        IFNE      *BLANKS
     C     ##ROK2        ANDLT     ##SFP2
     C                   SETON                                        51
     C                   MOVEL     @2CMP4        #2CMP1
     C                   ADD       1             ##RR2                83
     C                   ADD       1             ##ROK2
     C                   WRITE     #SFLRCD2
     C                   MOVEL     *BLANKS       @2CMP4
     C                   END
     C*
     C     @2CMP5        IFNE      *BLANKS
     C     ##ROK2        ANDLT     ##SFP2
     C                   SETON                                        51
     C                   MOVEL     @2CMP5        #2CMP1
     C                   ADD       1             ##RR2                83
     C                   ADD       1             ##ROK2
     C                   WRITE     #SFLRCD2
     C                   MOVEL     *BLANKS       @2CMP5
     C                   END
     C*
     C     @2CMP6        IFNE      *BLANKS
     C     ##ROK2        ANDLT     ##SFP2
     C                   SETON                                        51
     C                   MOVEL     @2CMP6        #2CMP1
     C                   ADD       1             ##RR2                83
     C                   ADD       1             ##ROK2
     C                   WRITE     #SFLRCD2
     C                   MOVEL     *BLANKS       @2CMP6
     C                   END
     C*
     C                   SETOFF                                       51
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HDSPD  Subroutine to display subfile detail key screen     *
     C**                                                              *
     C**  Called by   #HSFLP                                          *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HDSPD        BEGSR
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display key screen
     C                   SETOFF                                       62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #SFLCTL2
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C* Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C* Reset global error indicator
     C                   MOVE      '0'           *IN99
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVNWK  Subroutine to validate network field                *
     C**                                                              *
     C**  Called by   #HAMIN                                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVNWK        BEGSR
     C*
     C                   MOVE      '0'           *IN31
     C/COPY WNCPYSRC,ME1540C001
     C                   MOVE      *OFF          *IN67                                         16207
     C/COPY WNCPYSRC,ME1540C004
     C***/COPY OFCPYSRCZ,CFT135_015                                                  CFT135 MD020057
      *
      * If ?  then defer confirm
      *
     C                   MOVEL     #1NWRK        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1NWRK
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN67                                         16207
     C                   END
      *
     C*
     C                   CALL      'AONWRKR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1NWRK        P@NWRK            6
     C                   PARM      DSNWRK        DSFDY
     C*
     C**  Analyse return code
     C     P@RTCD        IFNE      *BLANK
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Network is invalid'
     C                   MOVEL     'MIN0265'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN99
     C                   END
     C*
     C                   ELSE
     C*                                                                                     MD030369
     C                   MOVE      P@NWRK        #1NWRK
     C*                                                                                     MD030369
     C*****#MTKEY        SETLL     MEINMVL2                               70                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVMTPY = :#1MTPY and MVNWRK = #1NWRK                                          MD058081
     C+   and MVACPT = '*AUTO'                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETON                                        70                    MD058081
     C                   IF        SQLCODE = 100                                            MD058081
     C                   SETOFF                                       70                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
     C     *IN70         IFEQ      '0'
     C                   SETON                                        3199
     C                   MOVEL     #1MTPY        ZAMSDA
     C     ZAMSDA        CAT       #1NWRK:0      ZAMSDA
     C                   MOVEL     'MIN0611'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C**********           ELSE                                                    MD020057 MD030369
     C**********           MOVE P@NWRK    #1NWRK                                            MD030369
     C                   ENDIF
     C                   END
     C*
     C/COPY WNCPYSRC,ME1540C003
     C***/COPY OFCPYSRCZ,CFT135_016                                                  CFT135 MD020057
     C                   ENDSR
     C/COPY WNCPYSRC,ME1540C002
     C/EJECT
     C*****************************************************************
     C**  #HVBRC  Subroutine to validate branch field                 *
     C**                                                              *
     C**  Called by   #HAMIN                                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVBRC        BEGSR
     C*
     C                   MOVE      '0'           *IN42
     C                   MOVE      *OFF          *IN55                                         16207
      *
      * If blanks exit
      *
     C     #1BRCA        IFEQ      *BLANKS
     C                   GOTO      EXBRCA
     C                   ENDIF
      *
      * If ?  then defer confirm
      *
      *
     C                   MOVEL     #1BRCA        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1BRCA
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN55                                         16207
     C                   END
     C*
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1BRCA        P@BRCA            3
     C**********           PARM DSBRCA    DSFDY                                               CGL029
     C                   PARM      DSBRCA        DSSDY
     C*
     C**  Analyse return code
     C     P@RTCD        IFNE      *BLANK
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Branch is invalid'
     C                   MOVEL     'MIN0273'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN42
     C                   MOVE      '1'           *IN99
     C                   END
     C*
     C                   ELSE
     C                   MOVE      P@BRCA        #1BRCA
     C                   END
     C*
     C     EXBRCA        ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVPTP  Subroutine to validate payment type                 *
     C**                                                              *
     C**  Called by  #HAMIN                                           *
     C**  Calls      ZASNMS                                           *
     C**                                                              *
     C*****************************************************************
     C     #HVPTP        BEGSR
     C*
     C                   MOVE      '0'           *IN32
     C*
      *                                                                   CFT006
      ** Payment type must be for RI, for 101                             CFT006
      *                                                                   CFT006
     C     #1MTPY        IFEQ      '101'                                                       CFT00
     C     #1PYTP        ANDNE     'RI'                                                        CFT00
     C     #1PYTP        ANDNE     '++'                                                        CFT00
     C     #1PYTP        ANDNE     '**'                                                        CFT00
     C     CRE008        ANDNE     'Y'                                                         CRE00
     C/COPY WNCPYSRC,UUC104_014                                                               UUC104
     C     W0PMT         IFEQ      'N'                                                         CFT00
      *                                                                   CFT006
      **  Send message 'Payment type is invalid'                          CFT006
      *                                                                   CFT006
     C                   MOVEL     'MIN0398'     ZAMSID                                        CFT00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CFT00
     C                   MOVEL     'RI'          ZAMSDA                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   MOVE      *ON           *IN32                                         CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   ENDIF                                                                 CFT00
     C/COPY WNCPYSRC,UUC104_015                                                               UUC104
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CRE008
      ** Payment type must be for RI, for 101                             CRE008
      *                                                                   CRE008
     C     #1MTPY        IFEQ      '101'                                                       CRE00
     C     #1PYTP        ANDNE     'CM'                                                        CRE00
     C     #1PYTP        ANDNE     'RI'                                                        CRE00
     C     #1PYTP        ANDNE     '++'                                                        CRE00
     C     #1PYTP        ANDNE     '**'                                                        CRE00
     C     CRE008        ANDEQ     'Y'                                                         CRE00
     C/COPY WNCPYSRC,UUC104_016                                                               UUC104
     C     W0PMT         IFEQ      'N'                                                         CRE00
      *                                                                   CRE008
      **  Send message 'Payment type is invalid'                          CRE008
      *                                                                   CRE008
     C                   MOVEL     'MIN0501'     ZAMSID                                        CRE00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CRE00
     C                   EXSR      ZASNMS                                                      CRE00
     C                   MOVE      *ON           *IN32                                         CRE00
     C                   MOVE      *ON           *IN99                                         CRE00
     C                   ENDIF                                                                 CRE00
     C/COPY WNCPYSRC,UUC104_017                                                               UUC104
      *                                                                   CRE008
     C                   ENDIF                                                                 CRE00
      *                                                                   CFT006
      ** Payment type must be for BI, for 102                             CFT006
      *                                                                   CFT006
     C     #1MTPY        IFEQ      '102'                                                       CFT00
     C     #1PYTP        ANDNE     'BI'                                                        CFT00
     C     #1PYTP        ANDNE     '++'                                                        CFT00
     C     #1PYTP        ANDNE     '**'                                                        CFT00
     C     W0PMT         IFEQ      'N'                                                         CFT00
      *                                                                   CFT006
      **  Send message 'Payment type is invalid'                          CFT006
      *                                                                   CFT006
     C                   MOVEL     'MIN0398'     ZAMSID                                        CFT00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CFT00
     C                   MOVEL     'BI'          ZAMSDA                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   MOVE      *ON           *IN32                                         CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
      ** When ? is entered we perform no validity checks                  CFT006
      ** Payment type must be CM, IN, OP for 103                          CRE008
      *                                                                   CRE008
     C     CRE008        IFEQ      'Y'                                                         CRE00
     C     #1MTPY        IFEQ      '103'                                                       CRE00
     C     #1PYTP        ANDNE     'IN'                                                        CRE00
     C     #1PYTP        ANDNE     'OP'                                                        CRE00
     C     #1PYTP        ANDNE     'CM'                                                        CRE00
     C     #1PYTP        ANDNE     '++'                                                        CRE00
     C     #1PYTP        ANDNE     '**'                                                        CRE00
     C     W0PMT         IFEQ      'N'                                                         CRE00
      *                                                                   CRE008
      **  Send message 'Payment type is invalid'                          CRE008
      *                                                                   CRE008
     C                   MOVEL     'MIN0500'     ZAMSID                                        CRE00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CRE00
     C                   MOVEL     'RI'          ZAMSDA                                        CRE00
     C                   EXSR      ZASNMS                                                      CRE00
     C                   MOVE      *ON           *IN32                                         CRE00
     C                   MOVE      *ON           *IN99                                         CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CRE008
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
      *                                                                   CFT006
     C*
     C**  Valid values are 'IN' for incoming payment and 'OP' for
     C**  outgoing payment
     C     #1PYTP        IFNE      'IN'
     C     #1PYTP        ANDNE     'OP'
     C     #1PYTP        ANDNE     '**'
     C     #1PYTP        ANDNE     '++'
     C     #1MTPY        ANDNE     '101'                                                       CFT00
     C     #1MTPY        ANDNE     '102'                                                       CFT00
     C     #1MTPY        ANDNE     '103'                                                       CRE00
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Payment type is invalid'
     C                   MOVEL     'MIN0266'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C     #1PYTP        IFEQ      '**'                                                        16267
     C     #1PYTP        OREQ      '++'                                                        16267
     C     #HHKEY        SETLL     MEURPRL0                               32                   16267
      * When ? is entered we perform no validity checks                   162675
     C     *IN32         IFEQ      '1'                                                         16267
     C     W0PMT         IFEQ      'N'                                                         16267
     C**  Send message '++ ** are not allowed when there are '            162675
     C**  'outstanding repair functions '                                 162675
     C                   MOVEL     'MIN0327'     ZAMSID                                        16267
     C                   MOVEL     'GBMEMSG'     ZAMSGF                                        16267
     C                   EXSR      ZASNMS                                                      16267
     C                   MOVE      '1'           *IN99                                         16267
     C                   END                                                                   16267
     C                   END                                                                   16267
     C                   END                                                                   16267
     C*                                                                   CRE008
     C********** *IN32     IFEQ '0'                                                  CRE008 BUG26047
     C**********           MOVE *OFF      *IN68                                      CRE008 BUG26047
     C**********           ENDIF                                                     CRE008 BUG26047
     C*                                                                   CRE008
     C/COPY WNCPYSRC,ME1540C007
     C*                                                                   162675
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVPST  Subroutine to validate payment sub-type             *
     C**                                                              *
     C**  Called by  #HAMIN                                           *
     C**  Calls      ZASNMS                                           *
     C**                                                              *
     C*****************************************************************
     C     #HVPST        BEGSR
     C*
     C                   MOVE      '0'           *IN33
     C                   MOVE      *OFF          *IN56                                         16207
      *
      * If ?  then defer confirm
      *
     C                   MOVEL     #1PYST        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1PYST
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN56                                         16207
     C                   END
     C*
     C**  For manual processing or choice to ignore incoming msg
     C**  this field is useless
     C     #1PYTP        IFEQ      '**'
     C     #1PYTP        OREQ      '++'
     C     #1PYST        IFNE      *BLANK
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'This field must no be entered'
     C                   MOVEL     'MIN0322'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN99
     C                   ELSE
     C*
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #1PYST        @DSTC             2
     C     SDDLST        PARM      SDDLST        DSFDY
      *
      * if selection made move value to screen field
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     ASDSTC        #1PYST
     C                   END
     C                   END
     C                   END
     C*
     C** End of #1PYTP = '**' '++'
     C                   END
     C*
     C     #1PYTP        IFNE      '**'
     C     #1PYTP        ANDNE     '++'
     C*
     C**  If not blank use access object to verify
     C**  outgoing payment
     C     #1PYST        IFEQ      *BLANKS
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Payment sub-type is invalid'
     C                   MOVEL     'MIN0275'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN99
     C                   END
     C                   ELSE
     C*
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #1PYST        @DSTC             2
     C     SDDLST        PARM      SDDLST        DSFDY
      *
      * if selection made move value to screen field
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     ASDSTC        #1PYST
     C*
     C     #HDSTK        CHAIN     FDDTSTL1                           33
     C     *IN33         IFEQ      '0'
     C     RCID11        ANDEQ     '*'
     C                   SETON                                        33
     C                   END
     C     *IN33         IFEQ      '1'
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Invalid combinaison Paiement/Paiemt sub-type'
     C                   MOVEL     'MIN0321'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN99
     C                   ELSE
     C                   SETOFF                                       33
     C                   END
     C                   END
     C*
     C                   ELSE
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Payment sub-type not found '
     C                   MOVEL     'MIN0276'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C                   END
     C*
     C** End of #1PYTP <> '**' '++'
     C                   END
     C*                                                                   CRE008
     C**  If CM, subtype must be MT, MR, MS                               CRE008
     C     #1PYTP        IFEQ      'CM'                                                        CRE00
     C     #1PYST        IFNE      'MR'                                                        CRE00
     C     #1PYST        ANDNE     'MT'                                                        CRE00
     C     #1PYST        ANDNE     'MS'                                                        CRE00
     C     W0PMT         IFEQ      'N'                                                         CRE00
     C**  Send message 'Payment sub-type is invalid'                      CRE008
     C                   MOVEL     'MIN0503'     ZAMSID                                        CRE00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CRE00
     C                   EXSR      ZASNMS                                                      CRE00
     C                   MOVE      '1'           *IN33                                         CRE00
     C                   MOVE      '1'           *IN99                                         CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDIF                                                                 CRE00
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVSTT  Subroutine to validate settlement type              *
     C**                                                              *
     C**  Called by   #HAMIN                                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVSTT        BEGSR
     C*
     C                   MOVE      '0'           *IN34
      *
     C*
     C     #1SETT        IFNE      *BLANKS
     C*
     C**  Check if it is an existing settlement method
     C     #1SETT        LOOKUP    HKST                                   65
     C/COPY WNCPYSRC,ME1540C008
     C     *IN65         IFEQ      '0'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C*
     C**  Send message 'Settlement type is invalid'
     C                   MOVEL     'MIN0267'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN99
     C*
     C                   END
     C                   END
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVEXC  Subroutine to validate exception report req.        *
     C**                                                              *
     C**  Called by    #HAMIN                                         *
     C**  Calls        ZASNMS                                         *
     C**                                                              *
     C*****************************************************************
     C     #HVEXC        BEGSR
     C*
     C                   MOVE      '0'           *IN35
     C*
     C**  Valid values are 'Y' or blank
     C     #1EXCP        IFNE      'Y'
     C     #1EXCP        ANDNE     *BLANK
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Exception report is invalid'
     C                   MOVEL     'MIN0268'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN35
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C                   ENDSR
     C/EJECT                                                              CFT005
     C*****************************************************************   CFT005
     C**  #HVAUT  Subroutine to validate auto-authorise field         *   CFT005
     C**                                                              *   CFT005
     C**  Called by    #HAMIN                                         *   CFT005
     C**  Calls        ZASNMS                                         *   CFT005
     C**                                                              *   CFT005
     C*****************************************************************   CFT005
     C     #HVAUT        BEGSR                                                                 CFT00
     C*                                                                   CFT005
     C                   MOVE      *OFF          *IN54                                         CFT00
     C*                                                                   CFT005
     C**  For manual processing or choice to ignore incoming msg          CFT005
     C**  this field is useless                                           CFT005
     C     #1PYTP        IFEQ      '**'                                                        CFT00
     C     #1PYTP        OREQ      '++'                                                        CFT00
     C     #1AUTO        IFNE      *BLANK                                                      CFT00
      * When ? is entered we perform no validity checks                   CFT005
     C     W0PMT         IFEQ      'N'                                                         CFT00
     C**  Send message 'This field must not be entered'                   CFT005
     C                   MOVEL     'MIN0322'     ZAMSID                                        CFT00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   MOVE      *ON           *IN54                                         CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C*                                                                   CFT005
     C     #1PYTP        IFNE      '++'                                                        CFT00
     C     #1PYTP        ANDNE     '**'                                                        CFT00
     C*                                                                   CFT005
     C**  Valid values are 'Y' or blank                                   CFT005
     C     #1AUTO        IFNE      'Y'                                                         CFT00
     C     #1AUTO        ANDNE     *BLANKS                                                     CFT00
      * When ? is entered we perform no validity checks                   CFT005
     C     W0PMT         IFEQ      'N'                                                         CFT00
     C**  Send message 'Auto-authorise field is invalid'                  CFT005
     C                   MOVEL     'MIN0332'     ZAMSID                                        CFT00
     C                   MOVEL     'MEMSG'       ZAMSGF                                        CFT00
     C                   EXSR      ZASNMS                                                      CFT00
     C                   MOVE      *ON           *IN54                                         CFT00
     C                   MOVE      *ON           *IN99                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C                   ENDIF                                                                 CFT00
     C*                                                                   CFT005
     C                   ENDSR                                                                 CFT00
     C/EJECT
     C*****************************************************************
     C**  #HVCLR  Subroutine to validate clearing type                *
     C**                                                              *
     C**  Called by    #HAMIN                                         *
     C**  Calls        ZASNMS                                         *
     C**                                                              *
     C*****************************************************************
     C     #HVCLR        BEGSR
     C*
     C                   MOVE      '0'           *IN36
     C*                                                                   CFT006
     C** No need to validate if the field is protected and hidden         CFT006
     C     *IN28         IFEQ      *ON                                                         CFT00
     C                   GOTO      EVCLR                                                       CFT00
     C                   ENDIF                                                                 CFT00
     C*
     C**  For manual processing or choice to ignore incoming msg
     C**  this field is useless
     C     #1PYTP        IFEQ      '**'
     C     #1PYTP        OREQ      '++'
     C     #1PYTP        OREQ      'RI'                                                        CFT00
     C     #1PYTP        OREQ      'BI'                                                        CFT00
     C     #1PYTP        OREQ      'CM'                                                        CRE00
     C     #1CLRT        IFNE      *BLANK
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'This field must no be entered'
     C                   MOVEL     'MIN0322'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C     CRE008        IFEQ      'Y'
     C                   MOVEL     'CM'          ZAMSDA
     C                   ENDIF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN36
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C                   END
     C*
     C     #1PYTP        IFNE      '++'
     C     #1PYTP        ANDNE     '**'
     C     #1PYTP        ANDNE     'RI'                                                        CFT00
     C     #1PYTP        ANDNE     'BI'                                                        CFT00
     C     #1PYTP        ANDNE     'CM'                                                        CRE00
     C*
     C**  Valid values are 'T' or 'C'
     C     #1CLRT        IFNE      'T'
     C     #1CLRT        ANDNE     'C'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Exception report is invalid'
     C                   MOVEL     'MIN0277'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN36
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C** End of #1PYTP <> '**' '++'
     C                   END
     C*
     C*********************ENDSR                                          CFT006
     C     EVCLR         ENDSR                                                                 CFT00
     C/EJECT
     C*****************************************************************
     C**  #HVBOK  Subroutine to validate Book codes                   *
     C**                                                              *
     C**  Called by  #HAMIN                                           *
     C**  Calls      ZASNMS                                           *
     C**                                                              *
     C*****************************************************************
     C     #HVBOK        BEGSR
     C*
     C                   MOVE      '0'           *IN37
     C                   MOVE      *OFF          *IN57                                         16207
      *
      * If ?  then defer confirm
      *
     C                   MOVEL     #1BOKC        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1BOKC
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN57                                         16207
     C                   END
     C*
     C**  For manual processing or choice to ignore incoming msg
     C**  this field is useless
     C     #1PYTP        IFEQ      '**'
     C     #1PYTP        OREQ      '++'
     C     #1BOKC        IFNE      *BLANK
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'This field must no be entered'
     C                   MOVEL     'MIN0322'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN37
     C                   MOVE      '1'           *IN99
     C                   ELSE
     C*
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #1BOKC        @BOKC             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      * if selection made move value to screen field
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     BDBKCD        #1BOKC
     C                   END
     C                   END
     C                   END
     C*
     C** End of #1PYTP = '**' '++'
     C                   END
     C*
     C     #1PYTP        IFNE      '**'
     C     #1PYTP        ANDNE     '++'
     C*
     C**  If not blank use access object to verify
     C**  outgoing payment
     C     #1BOKC        IFEQ      *BLANKS
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Payment sub-type is invalid'
     C                   MOVEL     'MIN0278'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN37
     C                   MOVE      '1'           *IN99
     C                   END
     C                   ELSE
     C*
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #1BOKC        @BOKC             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      * if selection made move value to screen field
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     BDBKCD        #1BOKC
     C                   ELSE
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Payment sub-type not found '
     C                   MOVEL     'MIN0279'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN37
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C                   END
     C*
     C** End of #1PYTP <> '**' '++'
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************                       CFT046
     C**  #HVTRT  Subroutine to validate Transaction Type             *                       CFT046
     C**                                                              *                       CFT046
     C**  Called by  #HAMIN                                           *                       CFT046
     C**  Calls      ZASNMS                                           *                       CFT046
     C**                                                              *                       CFT046
     C*****************************************************************                       CFT046
     C     #HVTRT        BEGSR                                                                CFT046
     C*                                                                                       CFT046
     C                   MOVE      '0'           *IN69                                        CFT046
     C                   MOVE      *OFF          *IN70                                        CFT046
      *                                                                                       CFT046
      * If ?  then defer confirm                                                              CFT046
      *                                                                                       CFT046
     C                   MOVEL     #1TRAT        WQM               1                          CFT046
     C     WQM           IFEQ      '?'                                                        CFT046
     C                   MOVEL(P)  '?'           #1TRAT                                       CFT046
     C                   MOVEL     'Y'           W0PMT                                        CFT046
     C                   MOVEL     '1'           *IN99                                        CFT046
     C                   MOVE      *ON           *IN70                                        CFT046
     C                   END                                                                  CFT046
     C*                                                                                       CFT046
     C**  For manual processing or choice to ignore incoming msg                              CFT046
     C**  this field is useless                                                               CFT046
     C     #1PYTP        IFEQ      '**'                                                       CFT046
     C     #1PYTP        OREQ      '++'                                                       CFT046
     C     #1TRAT        IFNE      *BLANK                                                     CFT046
      * When ? is entered we perform no validity checks                                       CFT046
     C     W0PMT         IFEQ      'N'                                                        CFT046
     C**  Send message 'This field must no be entered'                                        CFT046
     C                   MOVEL     'MIN0322'     ZAMSID                                       CFT046
     C                   MOVEL     'MEMSG'       ZAMSGF                                       CFT046
     C                   EXSR      ZASNMS                                                     CFT046
     C                   MOVE      '1'           *IN69                                        CFT046
     C                   MOVE      '1'           *IN99                                        CFT046
     C                   ELSE                                                                 CFT046
     C*                                                                                       CFT046
     C                   CALL      'AORETRR0'                                                 CFT046
     C                   PARM      *BLANKS       P@RTCD                                       CFT046
     C                   PARM      '*KEY   '     P@OPTN                                       CFT046
     C                   PARM      #1TRAT        @TRAT             5                          CFT046
     C     SDRETR        PARM      SDRETR        DSFDY                                        CFT046
      *                                                                                       CFT046
      * if selection made move value to screen field                                          CFT046
     C     P@RTCD        IFEQ      *BLANKS                                                    CFT046
     C                   MOVEL     A1RTTY        #1TRAT                                       CFT046
     C                   END                                                                  CFT046
     C                   END                                                                  CFT046
     C                   END                                                                  CFT046
     C*                                                                                       CFT046
     C** End of #1PYTP = '**' '++'                                                            CFT046
     C                   END                                                                  CFT046
     C*                                                                                       CFT046
     C     #1PYTP        IFNE      '**'                                                       CFT046
     C     #1PYTP        ANDNE     '++'                                                       CFT046
     C*                                                                                       CFT046
     C**  If not blank use access object to verify RE Transaction Type                        CFT046
     C     #1TRAT        IFNE      *BLANKS                                                    CFT046
     C                   CALL      'AORETRR0'                                                 CFT046
     C                   PARM      *BLANKS       P@RTCD                                       CFT046
     C                   PARM      '*KEY   '     P@OPTN                                       CFT046
     C                   PARM      #1TRAT        @TRAT                                        CFT046
     C     SDRETR        PARM      SDRETR        DSFDY                                        CFT046
      *                                                                                       CFT046
      * if selection made move value to screen field                                          CFT046
     C     P@RTCD        IFEQ      *BLANKS                                                    CFT046
     C                   MOVEL     A1RTTY        #1TRAT                                       CFT046
     C                   ELSE                                                                 CFT046
     C     W0PMT         IFEQ      'N'                                                        CFT046
     C**  Send message 'Transaction Type not found '                                          CFT046
     C                   MOVEL     'FTM5055'     ZAMSID                                       CFT046
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       CFT046
     C                   EXSR      ZASNMS                                                     CFT046
     C                   MOVE      '1'           *IN69                                        CFT046
     C                   MOVE      '1'           *IN99                                        CFT046
     C                   END                                                                  CFT046
     C                   END                                                                  CFT046
     C*                                                                                       CFT046
     C                   END                                                                  CFT046
     C*                                                                                       CFT046
     C** End of #1PYTP <> '**' '++'                                                           CFT046
     C                   END                                                                  CFT046
     C*                                                                                       CFT046
     C                   ENDSR                                                                CFT046
     C/EJECT                                                                                  CFT046
     CSR   #HVCRA        BEGSR
      *================================================================
      * Check MIDAS equivalent (A/C or Cust No)
      *================================================================
      *
      * Set valid Midas equivalent flag
      *
     C                   MOVE      '0'           *IN38
     C                   MOVE      *OFF          *IN58                                         16207
     C                   MOVEL     *BLANKS       #1MDID            1
      *
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     #1CSET        ADDRSS
      *
     C                   MOVEL     ADDRSS        WQM               1
     C                   MOVEL     ADDRSS        WQM2              2
     C     WQM           IFEQ      '?'
     C     WQM2          IFEQ      '??'
     C                   MOVEL(P)  '??'          ADDRSS
     C                   MOVEL(P)  '??'          #1CSET
     C                   ELSE
     C                   MOVEL(P)  '?'           ADDRSS
     C                   MOVEL(P)  '?'           #1CSET
     C                   END
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN58                                         16207
     C                   END
      *
      *  If first 5 Character are not blank but rest is blank
      *  validate as a full nostro
      *
     C     ADFNOS        IFNE      *BLANKS
     C     ADFNEX        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     ADDRSS        OREQ      '??'
     C     ADEXNN        ANDEQ     *BLANKS
      *
      * Look up Nostro via Access Object
      *
     C     ADDRSS        IFEQ      '??'
     C                   MOVEL     '?  '         ADFCCY
     C                   MOVEL     '? '          ADFNNB
     C                   END
      *
      * Look up Nostro via Access Object
      *
     C                   CALL      'AONOSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM      ADFCCY        P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM      ADFNNB        P@NONB            2
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN           10
     C                   PARM      *BLANKS       P@PNOI            1
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Nostro found mark as full nostro and get GL information
      *
     C     P@RTCD        IFEQ      *BLANKS
      *
      * If selected then defer confirm
      *
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     A7CUST        ADGCNM
     C                   MOVEL     A7CYCD        ADGCCY
     C                   MOVEL     A7ACCD        ADGACD
     C                   MOVEL     A7ACSN        ADGASQ
     C                   MOVEL     A7BRCD        ADGBRC
     C                   MOVEL     ADDRSS        #1CSET
      *
     C                   END
      *
     C                   END
      *
      *  If first 6 Characters are numeric but rest is blank
      *  validate as a customer reference
      *
      *  Only validate if #1MDID is blank
      *
     C     ADCNUM        IFNE      *BLANKS
     C     ADEXCN        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
     C     ADDRSS        ANDNE     '??'
      *
      *  Check first 6 characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     ADDRSS        I#FLD            35
     C********** DIGITS    CHECKI#FLD     Y#      30     90                                   CSD027
      *
      *  6 digits allowed
      *
     C********** *IN90     IFEQ '1'                                                           CSD027
     C********** Y#        ANDEQ7                                                             CSD027
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ADCNUM        P@KEY1           10
     C                   PARM      *BLANKS       P@KYST            7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Customer not found
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@KYST        ORNE      '*CNUM  '
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3899
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1CSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Customer found mark as Customer
      *
     C                   MOVEL     'C'           #1MDID
     C                   MOVEL     *BLANKS       #1CSET
     C                   MOVEL     BBCUST        #1CSET
      *
     C**********           END                                                                CSD027
      *
     C                   END
      *
      *  If first 10 Characters are numeric but rest is blank
      *  validate as a retail account
      *
      *  Only validate if #1MDID is blank
      *
     C     ADACNO        IFNE      *BLANKS
     C     ADEXAC        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
      *
      *  Check first 10 characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     ADDRSS        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      *  10 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C     Y#            ANDEQ     11
      *
      *  Check account is on ACCNTAB
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD                         B:Return code
     C                   PARM      '*KEY   '     P@OPTN                         I:Option
     C                   PARM      ADACNO        P@RETL                         I:Retail key
     C                   PARM      *BLANKS       P@CUST                         I:Key field 1
     C                   PARM      *BLANKS       P@CYCD                         I:Key field 2
     C                   PARM      *BLANKS       P@ACCD                         I:Key field 3
     C                   PARM      *BLANKS       P@ACSN                         I:Key field 4
     C                   PARM      *BLANKS       P@BRCD                         I:Key field 5
     C                   PARM                    P@ACCT                         O:OUTPUT
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Account not found
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
     C     RECI          ORNE      'D'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3899
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1CSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Retail Account found mark as GL Account
      *
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     CNUM          ADGCNM
     C                   MOVEL     CCY           ADGCCY
     C                   MOVEL     ACOD          ADGACD
     C                   MOVEL     ACSQ          ADGASQ
     C                   MOVEL     BRCA          ADGBRC
     C                   MOVEL     ADDRSS        #1CSET
      *
     C                   END
      *
     C                   END
      *
      *  If first 10 Characters are non blank but rest is blank
      *  validate as a customer shortname
      *
      *  Only validate if #1MDID is blank
      *
     C     ADCUST        IFNE      *BLANKS
     C     ADEXCS        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
      *
      * Check if name exists
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ADCUST        P@KEY1
     C                   PARM      *BLANKS       P@KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@KYST        OREQ      '*CNUM  '
     C     *IN99         ANDEQ     '0'
     C     P@KYST        ORNE      '*CSHT  '
     C     *IN99         ANDEQ     '0'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3899
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1CSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END                                                    X001
      *
      *  Customer found mark as Customer
      *
     C                   MOVEL     'C'           #1MDID
     C                   MOVEL     *BLANKS       #1CSET
     C                   MOVEL     BBCUST        #1CSET
      *
     C                   END
      *
      *  If 18 chars have been entered and multi branched , or
      *  15 long and single branch , is a full account.
      *
     C     ADCHK1        IFNE      *BLANKS
     C     ADEXGL        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDNE     'C'
      *
      *  Customer number, account code and account sequence must be
      *  numeric
      *
     C                   MOVEL     ADGCNM        PTCNUM
     C                   MOVEL     ADGACD        PTACOD
     C                   MOVEL     ADGASQ        PTACSQ
      *
      *  Check first 12 characters are numeric
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     PTACCT        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      *  12 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C*****Y#***         ANDNE     13                                                       AR857777
     C     Y#            ANDNE     19                                                       AR857777
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3899
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1CSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      *BLANKS       P@RETL           10            I:Retail key
     C                   PARM      ADGCNM        P@CUST            6            I:Key field 1
     C                   PARM      ADGCCY        P@CYCD            3            I:Key field 2
     C**********           PARM ADGACD    P@ACCD  4        I:Key field 3                      CGL029
     C                   PARM      ADGACD        P@ACCD           10
     C                   PARM      ADGASQ        P@ACSN            2            I:Key field 4
     C                   PARM      ADGBRC        P@BRCD            3            I:Key field 5
     C                   PARM                    P@ACCT                         O:OUTPUT
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Account not found
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
     C     RECI          ORNE      'D'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3899
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1CSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Retail Account found mark as GL Account
      *
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     CNUM          ADGCNM
     C                   MOVEL     CCY           ADGCCY
     C                   MOVEL     ACOD          ADGACD
     C                   MOVEL     ACSQ          ADGASQ
     C                   MOVEL     BRCA          ADGBRC
     C                   MOVEL     ADDRSS        #1CSET
      *
     C                   END
      *
      * If still not valid report error
      *
     C     #1MDID        IFEQ      *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3899
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1CSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   END
      *================================================================
     CSR   VFEXIT        ENDSR
     C/EJECT
     CSR   #HVDRA        BEGSR
      *================================================================
      * Check MIDAS equivalent (A/C or Cust No)
      *================================================================
      *
      * Set valid Midas equivalent flag
      *
     C                   MOVE      '0'           *IN39
     C                   MOVE      *OFF          *IN59                                         16207
     C                   MOVEL     *BLANKS       #1MDID            1
      *
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     #1DSET        ADDRSS
      *
     C                   MOVEL     ADDRSS        WQM               1
     C                   MOVEL     ADDRSS        WQM2              2
     C     WQM           IFEQ      '?'
     C     WQM2          IFEQ      '??'
     C                   MOVEL(P)  '??'          ADDRSS
     C                   MOVEL(P)  '??'          #1DSET
     C                   ELSE
     C                   MOVEL(P)  '?'           ADDRSS
     C                   MOVEL(P)  '?'           #1DSET
     C                   END
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN59                                         16207
     C                   END
      *
      *  If first 5 Character are not blank but rest is blank
      *  validate as a full nostro
      *
     C     ADFNOS        IFNE      *BLANKS
     C     ADFNEX        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     ADDRSS        OREQ      '??'
     C     ADEXNN        ANDEQ     *BLANKS
      *
      * Look up Nostro via Access Object
      *
     C     ADDRSS        IFEQ      '??'
     C                   MOVEL     '?  '         ADFCCY
     C                   MOVEL     '? '          ADFNNB
     C                   END
      *
      * Look up Nostro via Access Object
      *
     C                   CALL      'AONOSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM      ADFCCY        P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM      ADFNNB        P@NONB            2
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN           10
     C                   PARM      *BLANKS       P@PNOI            1
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Nostro found mark as full nostro and get GL information
      *
     C     P@RTCD        IFEQ      *BLANKS
      *
      * If selected then defer confirm
      *
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     A7CUST        ADGCNM
     C                   MOVEL     A7CYCD        ADGCCY
     C                   MOVEL     A7ACCD        ADGACD
     C                   MOVEL     A7ACSN        ADGASQ
     C                   MOVEL     A7BRCD        ADGBRC
     C                   MOVEL     ADDRSS        #1DSET
      *
     C                   END
      *
     C                   END
      *
      *  If first 6 Characters are numeric but rest is blank
      *  validate as a customer reference
      *
      *  Only validate if #1MDID is blank
      *
     C     ADCNUM        IFNE      *BLANKS
     C     ADEXCN        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
     C     ADDRSS        ANDNE     '??'
      *
      *  Check first 6 characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     ADDRSS        I#FLD            35
     C********** DIGITS    CHECKI#FLD     Y#      30     90                                   CSD027
      *
      *  6 digits allowed
      *
     C********** *IN90     IFEQ '1'                                                           CSD027
     C********** Y#        ANDEQ7                                                             CSD027
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ADCNUM        P@KEY1           10
     C                   PARM      *BLANKS       P@KYST            7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Customer not found
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@KYST        ORNE      '*CNUM  '
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3999
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1DSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   GOTO      VGEXIT
     C                   END
      *
      *  Customer found mark as Customer
      *
     C                   MOVEL     'C'           #1MDID
     C                   MOVEL     *BLANKS       #1DSET
     C                   MOVEL     BBCUST        #1DSET
      *
     C**********           END                                                                CSD027
      *
     C                   END
      *
      *  If first 10 Characters are numeric but rest is blank
      *  validate as a retail account
      *
      *  Only validate if #1MDID is blank
      *
     C     ADACNO        IFNE      *BLANKS
     C     ADEXAC        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
      *
      *  Check first 10 characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     ADDRSS        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      *  10 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C     Y#            ANDEQ     11
      *
      *  Check account is on ACCNTAB
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD                         B:Return code
     C                   PARM      '*KEY   '     P@OPTN                         I:Option
     C                   PARM      ADACNO        P@RETL                         I:Retail key
     C                   PARM      *BLANKS       P@CUST                         I:Key field 1
     C                   PARM      *BLANKS       P@CYCD                         I:Key field 2
     C                   PARM      *BLANKS       P@ACCD                         I:Key field 3
     C                   PARM      *BLANKS       P@ACSN                         I:Key field 4
     C                   PARM      *BLANKS       P@BRCD                         I:Key field 5
     C                   PARM                    P@ACCT                         O:OUTPUT
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Account not found
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
     C     RECI          ORNE      'D'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3999
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1DSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VGEXIT
     C                   END
      *
      *  Retail Account found mark as GL Account
      *
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     CNUM          ADGCNM
     C                   MOVEL     CCY           ADGCCY
     C                   MOVEL     ACOD          ADGACD
     C                   MOVEL     ACSQ          ADGASQ
     C                   MOVEL     BRCA          ADGBRC
     C                   MOVEL     ADDRSS        #1DSET
      *
     C                   END
      *
     C                   END
      *
      *  If first 10 Characters are non blank but rest is blank
      *  validate as a customer shortname
      *
      *  Only validate if #1MDID is blank
      *
     C     ADCUST        IFNE      *BLANKS
     C     ADEXCS        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
      *
      * Check if name exists
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ADCUST        P@KEY1
     C                   PARM      *BLANKS       P@KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * If customer changed then defer confirm
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@KYST        OREQ      '*CNUM  '
     C     *IN99         ANDEQ     '0'
     C     P@KYST        ORNE      '*CSHT  '
     C     *IN99         ANDEQ     '0'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3999
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1DSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   GOTO      VGEXIT
     C                   END                                                    X001
      *
      *  Customer found mark as Customer
      *
     C                   MOVEL     'C'           #1MDID
     C                   MOVEL     *BLANKS       #1DSET
     C                   MOVEL     BBCUST        #1DSET
      *
     C                   END
      *
      *  If 18 chars have been entered and multi branched , or
      *  15 long and single branch , is a full account.
      *
     C     ADCHK1        IFNE      *BLANKS
     C     ADEXGL        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDNE     'C'
      *
      *  Customer number, account code and account sequence must be
      *  numeric
      *
     C                   MOVEL     ADGCNM        PTCNUM
     C                   MOVEL     ADGACD        PTACOD
     C                   MOVEL     ADGASQ        PTACSQ
      *
      *  Check first 12 characters are numeric
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     PTACCT        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      *  12 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C*****Y#***         ANDNE     13                                                       AR857777
     C     Y#            ANDNE     19                                                       AR857777
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3999
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1DSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VGEXIT
     C                   END
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      *BLANKS       P@RETL           10            I:Retail key
     C                   PARM      ADGCNM        P@CUST            6            I:Key field 1
     C                   PARM      ADGCCY        P@CYCD            3            I:Key field 2
     C**********           PARM ADGACD    P@ACCD  4        I:Key field 3                      CGL029
     C                   PARM      ADGACD        P@ACCD
     C                   PARM      ADGASQ        P@ACSN            2            I:Key field 4
     C                   PARM      ADGBRC        P@BRCD            3            I:Key field 5
     C                   PARM                    P@ACCT                         O:OUTPUT
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Account not found
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
     C     RECI          ORNE      'D'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3999
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1DSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VGEXIT
     C                   END
      *
      *  Retail Account found mark as GL Account
      *
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     CNUM          ADGCNM
     C                   MOVEL     CCY           ADGCCY
     C                   MOVEL     ACOD          ADGACD
     C                   MOVEL     ACSQ          ADGASQ
     C                   MOVEL     BRCA          ADGBRC
     C                   MOVEL     ADDRSS        #1DSET
      *
     C                   END
      *
      * If still not valid report error
      *
     C     #1MDID        IFEQ      *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3999
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1DSET        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   END
      *================================================================
     CSR   VGEXIT        ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVCLO  Subroutine to validate Clearing Options             *
     C**                                                              *
     C**  Called by    #HAMIN                                         *
     C**  Calls        ZASNMS                                         *
     C**                                                              *
     C*****************************************************************
     C     #HVCLO        BEGSR
     C*
     C                   MOVEA     '00000000'    *IN(43)
     C                   MOVEA     '00'          *IN(51)
     C*
     C**  Valid values are 'Y' or blank
     C     #1CSND        IFNE      'Y'
     C     #1CSND        ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN43
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C50         IFNE      'Y'
     C     #1C50         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C52         IFNE      'Y'
     C     #1C52         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN45
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C53         IFNE      'Y'
     C     #1C53         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN46
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C54         IFNE      'Y'
     C     #1C54         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN47
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C56         IFNE      'Y'
     C     #1C56         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN48
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C57         IFNE      'Y'
     C     #1C57         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN49
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C58         IFNE      'Y'
     C     #1C58         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C70         IFNE      'Y'
     C     #1C70         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN51
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C**  Valid values are 'Y' or blank
     C     #1C72         IFNE      'Y'
     C     #1C72         ANDNE     *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Field invalid. must be Y or blank'
     C                   MOVEL     'MIN0274'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN52
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C                   ENDSR
      /EJECT
     C*****************************************************************   162675
     C**  #HVF7   Subroutine to validate F7 (Repair Functions)        *   162675
     C**                                                              *   162675
     C**  Called by    #HAMIN                                         *   162675
     C**  Calls        ZASNMS                                         *   162675
     C**                                                              *   162675
     C*****************************************************************   162675
     C     #HVF7         BEGSR                                                                 16267
     C** Repair Function works only for payment type IN OP                162675
     C     #1PYTP        IFEQ      '**'                                                        16267
     C     #1PYTP        OREQ      '++'                                                        16267
      * When ? is entered we perform no validity checks                   162675
     C     W0PMT         IFEQ      'N'                                                         16267
     C** Send message 'F7 is allowed only for payments IN OP'             162675
     C                   MOVEL     'MIN0328'     ZAMSID                                        16267
     C                   MOVEL     'GBMEMSG'     ZAMSGF                                        16267
     C                   EXSR      ZASNMS                                                      16267
     C                   MOVE      '1'           *IN32                                         16267
     C                   MOVE      '1'           *IN99                                         16267
     C                   END                                                                   16267
     C                   ENDIF                                                                 16267
     C                   ENDSR                                                                 16267
      /EJECT                                                              162675
     C*****************************************************************   CRE008
     C**  #HVF8   Subroutine to validate F8 (STP Charges)             *   CRE008
     C**                                                              *   CRE008
     C**  Called by    #HAMIN                                         *   CRE008
     C**  Calls        ZASNMS                                         *   CRE008
     C**                                                              *   CRE008
     C*****************************************************************   CRE008
     C     #HVF8         BEGSR                                                                 CRE00
     C** Repair Function works only for payment type IN OP                CRE008
     C     #1PYTP        IFEQ      'CM'                                                        CRE00
      * When ? is entered we perform no validity checks                   CRE008
     C     W0PMT         IFEQ      'N'                                                         CRE00
     C** Send message 'F8 not allowed  for CM                             CRE008
     C                   MOVEL     'MIN0502'     ZAMSID                                        CRE00
     C                   MOVEL     'GBMEMSG'     ZAMSGF                                        CRE00
     C                   EXSR      ZASNMS                                                      CRE00
     C                   MOVE      '1'           *IN32                                         CRE00
     C                   MOVE      '1'           *IN99                                         CRE00
     C                   END                                                                   CRE00
     C                   ENDIF                                                                 CRE00
     C                   ENDSR                                                                 CRE00
      /EJECT                                                              CRE008
     C*****************************************************************
     C**  #HPRDK  Subroutine to display and process detail key screen *
     C**                                                              *
     C**  Called by   #HAMIN, #HENQY                                  *
     C**  Calls       #HVACT, #HVNUM, #HVDTR                          *
     C**                                                              *
     C*****************************************************************
     C     #HPRDK        BEGSR
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVE      *OFF          *IN71
     C     #1MTPY        IFEQ      '101'
     C     #1MTPY        OREQ      '102'
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN71
     C                   ENDIF
     C*
     C**  Confirm/update is not deferred
     C*
     C                   MOVEL     'N'           W0DCF             1
     C                   MOVEA     '0000'        *IN(74)
     C                   MOVEA     '00'          *IN(78)
     C*                                                                    CFT006
     C** For MT101 and MT102 enable header tag flag                        CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
     C                   MOVE      *ON           *IN64                                          CFT0
     C                   ELSE                                                                   CFT0
     C                   MOVE      *OFF          *IN64                                          CFT0
     C                   ENDIF                                                                  CFT0
     C*
     C     *IN83         IFEQ      '1'
     C*
     C**  Process detail subfile records
     C                   EXSR      #HSFRC
     C                   END
     C*
     C**  Process add request
     C     *IN09         IFEQ      '1'
     C     W0DCF         ANDEQ     'N'
     C*
     C****Validate action code
     C                   MOVEL     'I'           #HACTC
     C                   EXSR      #HVACT
     C*
     C     *IN31         IFEQ      '0'
     C*
     C                   MOVEL     'I'           #2ACTC
     C                   MOVE      *BLANKS       #2MSEQ
     C**
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C*                                                                    CFT006
     C** For MT101 and MT102 enable header tag flag                        CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
     C                   MOVE      *ON           *IN64                                          CFT0
     C                   ELSE                                                                   CFT0
     C                   MOVE      *OFF          *IN64                                          CFT0
     C                   ENDIF                                                                  CFT0
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Set up command line text
     C                   MOVE      '1'           *IN77
     C*
     C**  Display detail key screen
     C                   SETOFF                                       62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL2
     C*
     C     *IN03         IFNE      '1'
     C     *IN05         ANDNE     '1'
     C     *IN12         ANDNE     '1'
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  Validate sequence number
     C                   MOVEL     #2MSEQ        #HNUM
     C                   EXSR      #HVNUM
     C*
     C**  If no error, validate detail record
     C     *IN99         IFEQ      '0'
     C                   MOVE      @HNUMB        #2MSEQ
     C                   EXSR      #HVDTR
     C                   END
     C*
     C**  If insert is successful, blank out sequence number field
     C     #HOK          IFEQ      'Y'
     C                   MOVE      *BLANKS       #2MSEQ
     C                   END
     C                   MOVEL     'I'           #2ACTC
     C*
     C                   END
     C*
     C**  If Command 5 is pressed, set fields to blank
     C     *IN05         IFEQ      '1'
     C                   MOVE      *BLANKS       #2MSEQ
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN77
     C                   CALL      'ZA0250'
     C                   END
     C*
     C**  If Command 12 is pressed
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN12
     C                   END
     C*
     C   03              SETON                                        92
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C  N31              MOVEL     'Y'           W0RSF2
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HSFRC  Subroutine to process subfile record                *
     C**                                                              *
     C**  Called by   #HPRDK                                          *
     C**  Calls                                                       *
     C**                                                              *
     C*****************************************************************
     C     #HSFRC        BEGSR
     C*
     C**  Read first changed subfile record
     C                   READC     #SFLRCD2                               92
     C*
     C     *IN92         DOWEQ     '0'
     C*
     C**  Setof error indicator and SFLNXTCHG
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN98
     C*
     C     #2ACTC        IFNE      *BLANKS
     C*
     C****Validate action code
     C                   MOVEL     #2ACTC        #HACTC
     C                   EXSR      #HVACT
     C*
     C     *IN31         IFEQ      '1'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   EXSR      #HVDTR
     C                   END
     C*
     C     *IN92         IFEQ      '1'
     C                   SETOFF                                       12
     C                   ELSE
     C*
     C**  If there is an error, seton SFLNXTCHG indicator
     C*
     C     *IN98         IFEQ      '1'
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   END
     C*
     C                   ENDIF
     C*
     C                   END
     C*
     C     *IN92         IFNE      '1'
     C                   UPDATE    #SFLRCD2
     C                   READC     #SFLRCD2                               92
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVDTR  Subroutine to validate detail record                *
     C**                                                              *
     C**  Called by  #HPRDK                                           *
     C**  Calls      #HPRDT, ZASNMS                                   *
     C**                                                              *
     C*****************************************************************
     C     #HVDTR        BEGSR
     C*
     C**  Check if detail record exists
     C                   MOVEL     #1MTPY        #KMTPY
     C                   MOVE      #1MSET        #KMSET
     C                   MOVE      #2MSEQ        #KMSEQ
     C     #HDKEY        CHAIN     MEGNDTL0                           6099
     C                   UNLOCK    MEGNDTL0                                                    16242
     C** Hold existing image                                              162428
     C                   MOVEL     @1GNDT        #1GNDT                                        16242
     C*
     C     *IN99         IFEQ      '1'
     C                   SETON                                        313599
     C* Send message 'Record is already in use'
     C                   MOVEL     'MIN0272'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   MOVEL     'Y'           W0DCF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C     *IN60         IFEQ      '1'
     C*
     C     #2ACTC        IFNE      'I'
     C                   SETON                                        313599
     C* Send message 'Record does not exist'
     C                   MOVEL     'MIN0271'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
     C*
     C     #2ACTC        IFEQ      'I'
     C                   SETON                                        313599
     C* Send message 'Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   END
     C*
     C     *IN99         IFEQ      '0'
     C*
     C**  Process remaining detail record fields
     C                   EXSR      #HPRDT
     C*
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HPRDT  Subroutine to process remaining detail fields       *
     C**                                                              *
     C**  Called by   #HVDTR                                          *
     C**  Calls       #HCLDT, #HMVDT, #HENQ2, #HDLT2, #HAMI2, #HRLCM  *
     C**                                                              *
     C*****************************************************************
     C     #HPRDT        BEGSR
     C*
     C                   MOVE      *BLANK        #HOK              1
     C*
     C**  Clear detail fields
     C                   EXSR      #HCLDT
     C*
     C**  Set up remaining detail fields for output
     C                   EXSR      #HMVDT
     C*
     C** If action code is 'E'
     C     #2ACTC        CASEQ     'E'           #HENQ2
     C*
     C** If action code is 'D'
     C     #2ACTC        CASEQ     'D'           #HDLT2
     C*
     C** If action code is 'A'
     C     #2ACTC        CASEQ     'A'           #HAMI2
     C*
     C** If action code is 'I'
     C     #2ACTC        CASEQ     'I'           #HAMI2
     C                   END
     C*
     C****Rollback*or*comit*any*changes                                   162428
     C**  Applicable only in copy. Other cases handle their               162428
     C**  own commitement                                                 162428
     C*********************EXSR #HRLCM                                    162428
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HENQ2  Subroutine to enquire a criteria detail record      *
     C**                                                              *
     C**  Called by   #HPRDT                                          *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HENQ2        BEGSR
     C*
     C                   MOVE      '1'           *IN79
     C                   MOVE      '1'           *IN74
     C*                                                                    CFT006
     C** For MT101 and MT102 enable header tag flag                        CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
     C                   MOVE      *ON           *IN64                                          CFT0
     C                   ELSE                                                                   CFT0
     C                   MOVE      *OFF          *IN64                                          CFT0
     C                   ENDIF                                                                  CFT0
     C*                                                                    CFT006
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display header detail screen
     C                   SETOFF                                       62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL3
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  If command 12 or ENTER is pressed, go back to key screen
     C*
     C     *IN03         IFNE      '1'
     C     *IN12         ANDNE     '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   END
     C*
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   SETON                                        92
     C                   END
     C*
     C   03              SETON                                        92
     C*
     C                   MOVEL     'Y'           W0RSF2
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HDLT2  Subroutine to perform deletion of a detail record   *
     C**                                                              *
     C**  Called by   #HPRDT                                          *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HDLT2        BEGSR
     C                   MOVE      *BLANK        #HOK
     C*
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C     #HOK          OREQ      'Y'
     C*                                                                    CFT006
     C** For MT101 and MT102 enable header tag flag                        CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
     C                   MOVE      *ON           *IN64                                          CFT0
     C                   ELSE                                                                   CFT0
     C                   MOVE      *OFF          *IN64                                          CFT0
     C                   ENDIF                                                                  CFT0
     C*
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display header detail screen
     C                   SETOFF                                       62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL3
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  If Cmd 10 is pressed, delete detail record
     C     *IN10         IFEQ      '1'
     C                   MOVEL     #1MTPY        #KMTPY                                        16242
     C                   MOVE      #1MSET        #KMSET                                        16242
     C                   MOVE      #2MSEQ        #KMSEQ                                        16242
     C     #HDKEY        CHAIN     MEGNDTL0                           99                       16242
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   ELSE                                                                  16242
     C                   DELETE    @GNDTPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   ROLBK                                                                 16242
     C                   ELSE                                                                  16242
     C                   COMMIT                                                                16242
     C                   MOVE      'Y'           #HOK
     C                   END                                                                   16242
     C                   END                                                                   16242
     C                   END
     C*
     C**  If Cmd 12 is pressed
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      '1'           *IN12
     C                   SETON                                        92
     C                   END
     C*
     C   03              SETON                                        92
     C*
     C                   END
     C*
     C**  If deletion is successful
     C     #HOK          IFEQ      'Y'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      *BLANKS       #2ACTC
     C                   END
     C                   MOVEL     'Y'           W0RSF2
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HAMI2  Subroutine to amend or insert a detail record       *
     C**                                                              *
     C**  Called by   #HPRDT                                          *
     C**  Calls       #HVTAG, #HVOPR, #HCLDT, #HMVDT, #HMVD2          *
     C**                                                              *
     C*****************************************************************
     C     #HAMI2        BEGSR
     C                   MOVE      *BLANK        #HOK
     C*
     C**  If action code is 'I', display blank detail fields
     C     #2ACTC        IFEQ      'I'
     C                   EXSR      #HCLDT
     C                   END
     C*
     C**  If action code is 'A', display original details
     C     #2ACTC        IFEQ      'A'
     C                   EXSR      #HMVFD
     C                   END
     C*
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C     #HOK          OREQ      'Y'
     C*
     C** To test if any ? are entered in screen fields
     C*
     C                   MOVEL     'N'           W0PMT             1
     C*
     C**  Set up indicators depending on action code
     C     #2ACTC        IFEQ      'I'
     C                   MOVE      '1'           *IN77
     C                   ELSE
     C                   MOVE      '1'           *IN76
     C                   END
     C*                                                                    CFT006
     C** For MT101 and MT102 enable header tag flag                        CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
     C                   MOVE      *ON           *IN64                                          CFT0
     C                   ELSE                                                                   CFT0
     C                   MOVE      *OFF          *IN64                                          CFT0
     C                   ENDIF                                                                  CFT0
     C*
     C**  Update screen time
     C                   TIME                    ##TME
     C*
     C**  Display header detail screen
     C                   SETOFF                                       62
     C                   WRITE     #HEADER
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL3
     C*
     C     *IN12         IFNE      '1'
     C     *IN03         ANDNE     '1'
     C     *IN05         ANDNE     '1'
     C*
     C**  Update job time
     C                   TIME                    ##JTM
     C*
     C**  Clear messages from program message queue
     C                   CALL      'ZA0250'
     C*
     C**  Validate Message tag
     C                   EXSR      #HVTAG
     C*                                                                   CFT006
     C**  Validate flag header tag                                        CFT006
     C                   EXSR      #HVTGH                                                      CFT00
     C*
     C**  Validate Operator
     C                   EXSR      #HVOPR
      *                                                                                       CRE008
      ** Validate Report Test Results                                                         CRE008
      *                                                                                       CRE008
     C                   EXSR      #HVRTR
     C*                                                                   162428
     C     *IN99         IFEQ      '0'                                                         16242
     C*                                                                   162428
     C     #2ACTC        IFEQ      'A'                                                         16242
     C*                                                                   162428
     C                   MOVEL     #1MTPY        #KMTPY                                        16242
     C                   MOVE      #1MSET        #KMSET                                        16242
     C                   MOVE      #2MSEQ        #KMSEQ                                        16242
     C     #HDKEY        CHAIN     MEGNDTL0                           99                       16242
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   ELSE                                                                  16242
      *                                                                   162428
      ** Check for changed record                                         162428
     C     #1GNDT        IFNE      @1GNDT                                                      16242
      ** Send message '*Update not accepted'                              162428
     C                   MOVEL     'Y2U0007'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   SETON                                        99                       16242
     C                   END                                                                   16242
     C                   END                                                                   16242
     C                   END                                                                   16242
      *                                                                   162428
      * Check header record has not been deleted by another user          162428
     C     #HHKEY        SETLL     MEGNCRL0                               99                   16242
     C     *IN99         IFEQ      '0'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   SETON                                        99                       16242
     C                   ELSE                                                                  16242
     C                   SETOFF                                       99                       16242
     C                   END                                                                   16242
     C                   END                                                                   16242
     C*
     C**  If no error, update details file
     C     *IN99         IFEQ      '0'
     C*
     C**  Move correct values to remaining header details for update
     C                   EXSR      #HMVD2
     C     #2ACTC        IFEQ      'A'
     C                   UPDATE    @GNDTPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   UNLOCK    MEGNDTL0                                                    16242
     C                   ROLBK                                                                 16242
     C                   ELSE                                                                  16242
     C** Update saved record image                                        162428
     C                   MOVEL     @1GNDT        #1GNDT                                        16242
     C                   COMMIT                                                                16242
     C                   END                                                                   16242
     C                   ELSE
     C                   WRITE     @GNDTPD                              99
     C     *IN99         IFEQ      '1'                                                         16242
      * Change error detected                                             162428
     C                   MOVEL     'Y2U0004'     ZAMSID                                        16242
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                        16242
     C                   EXSR      ZASNMS                                                      16242
     C                   SETON                                        99                       16242
     C                   ROLBK                                                                 16242
     C                   ELSE                                                                  16242
     C                   COMMIT                                                                16242
     C                   END                                                                   16242
     C                   END
     C     *IN99         IFEQ      '0'                                                         16242
     C                   MOVE      'Y'           #HOK
     C                   END                                                                   16242
     C*
     C                   END
     C*
     C                   END
     C*
     C**  If Command 12 is pressed, go back to key screen
     C     *IN12         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
     C*
     C                   MOVE      '1'           *IN12
     C                   SETON                                        92
     C                   END
     C*
     C   03              SETON                                        92
     C*
     C**  If Command 5 is pressed, refresh screen
     C     *IN05         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   EXSR      #HCLDT
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C     #2ACTC        IFEQ      'A'
     C                   EXSR      #HMVDT
     C                   END
     C                   END
     C*
     C                   END
     C                   MOVE      '0'           *IN12
     C*
     C**  If amend or insert is successful
     C     #HOK          IFEQ      'Y'
     C                   CALL      'ZA0250'
     C                   MOVEA     *ALL'0'       *IN(1)
     C     CFT005        IFEQ      'Y'                                                         17794
     C                   SETON                                        63                       17794
     C                   ENDIF                                                                 17794
      *                                                                   CFT009
     C     CFT009        IFEQ      'Y'                                                         CFT00
     C                   MOVE      *ON           *IN68                                         CFT00
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT009
     C                   MOVE      *BLANKS       #2ACTC
     C                   END
     C                   MOVEL     'Y'           W0RSF2
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HVTAG  Subroutine to validate message tag                  *
     C**                                                              *
     C**  Called by   #HAMI2                                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVTAG        BEGSR
      *
      * If ?  then defer confirm
      *
     C                   MOVEL     #2MTAG        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #2MTAG
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   END
     C*
     C**  Access message tag file
     C                   CALL      'AOMTAGR0'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #2MTAG        P@MTAG            5            I:Key field
     C                   PARM      'ALL'         P@MTPY            3            I:Key field
     C                   PARM      *BLANKS       DSFDY                          O:Format
      *                                                                   CFT006
     C     P@RTCD        IFNE      *BLANKS                                                     CFT00
      *                                                                   CFT006
      ** For message types 101 or 102                                     CFT006
      ** or 103                                                           CFT014
      *                                                                   CFT006
     C     #1MTPY        IFEQ      '101'                                                       CFT00
     C     #1MTPY        OREQ      '102'                                                       CFT00
     C     #1MTPY        OREQ      '103'                                                       CFT01
     C*                                                                   CFT006
     C**  Access message tag file                                         CFT006
     C                   CALL      'AOMTAGR0'                                                  CFT00
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code  CFT00
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option       CFT00
     C                   PARM      #2MTAG        P@MTAG            5            I:Key field    CFT00
     C                   PARM      #1MTPY        P@MTPY            3            I:Key field    CFT00
     C                   PARM      *BLANKS       DSFDY                          O:Format       CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
     C*
     C**  Analyse return code
     C*
     C     P@RTCD        IFNE      *BLANKS
     C     W0PMT         IFEQ      'N'
     C*
     C* Send message 'Message tag not found'
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN99
     C                   END
     C*
     C                   ELSE
     C                   MOVE      P@MTAG        #2MTAG
     C                   END
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C     #1MTPY        ANDNE     '101'
     C     #1MTPY        ANDNE     '102'
      *                                                                                       CSW209
      * If all low order keys not entered, exit                                               CSW209
      *                                                                                       CSW209
     C                   MOVEL     #1MTPY        EFMTPY
     C                   MOVEL     #2MTAG        EFMTAG
     C                   MOVEL     #2TSEQ        EFMSEQ
      *                                                                                       CSW209
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     #1MTPY        EFMTPY
     C                   MOVEL     *BLANKS       EFMSEQ
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C******IN90         IFNE      '0'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Send message 'Midas Message  NF'                                                      CSW209
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        3399
     C                   ENDIF
      *                                                                                       CSW209
     C                   ENDIF
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************    CFT006
     C**  #HVTGH  Subroutine to validate the header tag               *    CFT006
     C**                                                              *    CFT006
     C**  Called by   #HAMI2                                          *    CFT006
     C**  Calls       ZASNMS                                          *    CFT006
     C**                                                              *    CFT006
     C*****************************************************************    CFT006
     C     #HVTGH        BEGSR                                                                  CFT0
      *                                                                    CFT006
      ** For message types 101 or 102                                      CFT006
      *                                                                    CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
      *                                                                    CFT006
     C     #2HDTG        IFNE      'Y'                                                          CFT0
     C     #2HDTG        ANDNE     'N'                                                          CFT0
      * When ? is entered we perform no validity checks                    CFT006
     C     W0PMT         IFEQ      'N'                                                          CFT0
     C**  Send message value required Y or N                               CFT006
     C                   MOVEL     'MIN0330'     ZAMSID                                         CFT0
     C                   MOVEL     'MEMSG'       ZAMSGF                                         CFT0
     C                   EXSR      ZASNMS                                                       CFT0
     C                   MOVE      '1'           *IN30                                          CFT0
     C                   END                                                                    CFT0
     C*                                                                    CFT006
     C                   END                                                                    CFT0
     C*                                                                    CFT006
     C                   ELSE                                                                   CFT0
     C*                                                                    CFT006
     C                   MOVE      'N'           #2HDTG                                         CFT0
     C*                                                                    CFT006
     C                   END                                                                    CFT0
     C*                                                                    CFT006
     C                   ENDSR                                                                  CFT0
     C/EJECT
     C*****************************************************************
     C**  #HVOPR  Subroutine to validate operator field               *
     C**                                                              *
     C**  Called by   #HAMI2                                          *
     C**  Calls       ZASNMS                                          *
     C**                                                              *
     C*****************************************************************
     C     #HVOPR        BEGSR
     C*
     C**  Perform table lookup for valid operator values
     C     #2OPER        LOOKUP    HKOP                                   66
     C*
     C     *IN66         IFNE      '1'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C**  Send message 'Operator is invalid'
     C                   MOVEL     'MIN0269'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN99
     C                   END
     C                   END
     C*
     C                   ENDSR
      *****************************************************************                       CRE008
      /EJECT                                                                                  CRE008
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      *  #HVRTR - Subroutine to validate the Report Test Results      *                       CRE008
      *                                                               *                       CRE008
      *  Called by: #HAMI2                                            *                       CRE008
      *                                                               *                       CRE008
      *  Calls: ZASNMS                                                *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
      *                                                                                       CRE008
     C     #HVRTR        BEGSR
      *                                                                                       CRE008
     C     #2REPT        IFNE      'Y'
     C     #2REPT        ANDNE     'N'
     C                   MOVEL     'MIN0330'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *                                                                                       CRE008
     C                   ENDSR
      *                                                                                       CRE008
      *****************************************************************                       CRE008
     C/EJECT
     C*****************************************************************
     C**  #HCLHD  Subroutine to clear header detail fields            *
     C**                                                              *
     C**  Called by  #HAMIN, #HPRHD                                   *
     C**  Calls      Nothing                                          *
     C**                                                              *
     C*****************************************************************
     C     #HCLHD        BEGSR
     C*
     C                   MOVEL     *BLANKS       #1BRCA
     C                   MOVEL     *BLANKS       #1NWRK
     C                   MOVEL     *BLANKS       #1PYTP
     C                   MOVEL     *BLANKS       #1SETT
     C                   MOVEL     *BLANKS       #1EXCP
     C                   MOVEL     *BLANKS       #1BOKC
     C                   MOVEL     *BLANKS       #1TRAT                                       CFT046
     C                   MOVEL     *BLANKS       #1PYST
     C                   MOVEL     *BLANKS       #1CSET
     C                   MOVEL     *BLANKS       #1DSET
     C                   MOVEL     *BLANKS       #1CLRT
     C                   MOVEL     *BLANKS       #1DESC
     C                   MOVEL     *BLANKS       #1DES2
     C                   MOVEL     *BLANKS       #1CSND                                        16207
     C                   MOVEL     *BLANKS       #1C50                                         16207
     C                   MOVEL     *BLANKS       #1C52                                         16207
     C                   MOVEL     *BLANKS       #1C53                                         16207
     C                   MOVEL     *BLANKS       #1C54                                         16207
     C                   MOVEL     *BLANKS       #1C56                                         16207
     C                   MOVEL     *BLANKS       #1C57                                         16207
     C                   MOVEL     *BLANKS       #1C58                                         16207
     C                   MOVEL     *BLANKS       #1C70                                         16207
     C                   MOVEL     *BLANKS       #1C72                                         16207
     C                   MOVEL     *BLANKS       #1AUTO                                        CFT00
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HCLDT  Subroutine to clear detail fields                   *
     C**                                                              *
     C**  Called by   #HPRDT, #HAMI2                                  *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HCLDT        BEGSR
     C*
     C                   MOVEL     *BLANKS       #2MTAG
     C                   MOVEL     *BLANKS       #2OPER
     C                   MOVEL     *BLANKS       #2TSEQ
     C                   MOVEL     *BLANKS       #2CMP1
     C                   MOVEL     *BLANKS       #2CMP2
     C                   MOVEL     *BLANKS       #2CMP3
     C                   MOVEL     *BLANKS       #2CMP4
     C                   MOVEL     *BLANKS       #2CMP5
     C                   MOVEL     *BLANKS       #2CMP6
     C                   MOVEL     'N'           #2HDTG
     C                   MOVEL     'N'           #2REPT
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HMVHD  Subroutine to move header details to output fields  *
     C**                                                              *
     C**  Called by   #HPRHD, #HAMIN                                  *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HMVHD        BEGSR
     C*
     C                   MOVEL     GNNWRK        #1NWRK
     C                   MOVEL     GNPYTP        #1PYTP
     C                   MOVEL     GNSETT        #1SETT
     C                   MOVEL     GNEXCP        #1EXCP
     C                   MOVEL     GNBOKC        #1BOKC
     C                   MOVEL     GNPYST        #1PYST
     C                   MOVEL     GNCSET        #1CSET
     C                   MOVEL     GNDSET        #1DSET
     C                   MOVEL     GNCLRT        #1CLRT
     C                   MOVEL     GNCSND        #1CSND
     C                   MOVEL     GNC50         #1C50
     C                   MOVEL     GNC52         #1C52
     C                   MOVEL     GNC53         #1C53
     C                   MOVEL     GNC54         #1C54
     C                   MOVEL     GNC56         #1C56
     C                   MOVEL     GNC57         #1C57
     C                   MOVEL     GNC58         #1C58
     C                   MOVEL     GNC70         #1C70
     C                   MOVEL     GNC72         #1C72
     C                   MOVEL     GNDESC        #1DESC
     C                   MOVEL     GNDES2        #1DES2
     C                   MOVEL     GNBRCA        #1BRCA
     C                   MOVEL     GNAUTO        #1AUTO                                        CFT00
     C/COPY WNCPYSRC,ME1540C009
     C*                                                                    CFT006
     C** For MT101 and MT102 hide clearing type                            CFT006
     C     #1MTPY        IFEQ      '101'                                                        CFT0
     C     #1MTPY        OREQ      '102'                                                        CFT0
     C                   MOVE      *ON           *IN28                                          CFT0
     C                   ELSE                                                                   CFT0
     C                   MOVE      *OFF          *IN28                                          CFT0
     C                   ENDIF                                                                  CFT0
     C*                                                                                       CFT046
     C     CFT046        IFEQ      'Y'                                                        CFT046
     C     #HHKEY        CHAIN     MEGNCRX0                             88                    CFT046
     C                   UNLOCK    MEGNCRX0                                                   CFT046
     C     *IN88         IFEQ      '0'                                                        CFT046
     C                   MOVEL     X0TRAT        #1TRAT                                       CFT046
     C                   ELSE                                                                 CFT046
     C                   MOVE      *BLANKS       #1TRAT                                       CFT046
     C                   ENDIF                                                                CFT046
     C                   ENDIF                                                                CFT046
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HMVDT  Subroutine to move detail fields to output fields   *
     C**                                                              *
     C**  Called by   #HPRDT, #HAMI2                                  *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HMVDT        BEGSR
     C*
     C                   MOVEL     GDMTAG        #2MTAG
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     GDMSEQ        #2TSEQ
     C                   ENDIF
     C                   MOVEL     GDOPER        #2OPER
     C                   MOVEL     GDCMP1        #2CMP1
     C                   MOVEL     GDCMP2        #2CMP2
     C                   MOVEL     GDCMP3        #2CMP3
     C                   MOVEL     GDCMP4        #2CMP4
     C                   MOVEL     GDCMP5        #2CMP5
     C                   MOVEL     GDCMP6        #2CMP6
     C                   MOVEL     GDHDTG        #2HDTG
     C                   MOVEL     GDREPT        #2REPT
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HMVH2  Subroutine to move correct values to remaining      *
     C**          header fields for update.                           *
     C**                                                              *
     C**  Called by   #HAMIN                                          *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HMVH2        BEGSR
     C*
     C                   MOVEL     #1MTPY        GNMTPY
     C                   MOVE      #1MSET        GNMSET
     C                   MOVEL     #1NWRK        GNNWRK
     C                   MOVEL     #1PYTP        GNPYTP
     C                   MOVE      #1SETT        GNSETT
     C                   MOVEL     #1EXCP        GNEXCP
     C                   MOVEL     #1BOKC        GNBOKC
     C                   MOVEL     #1PYST        GNPYST
     C                   MOVEL     #1CSET        GNCSET
     C                   MOVEL     #1DSET        GNDSET
     C                   MOVEL     #1CLRT        GNCLRT
     C                   MOVEL     #1CSND        GNCSND
     C                   MOVEL     #1C50         GNC50
     C                   MOVEL     #1C52         GNC52
     C                   MOVEL     #1C53         GNC53
     C                   MOVEL     #1C54         GNC54
     C                   MOVEL     #1C56         GNC56
     C                   MOVEL     #1C57         GNC57
     C                   MOVEL     #1C58         GNC58
     C                   MOVEL     #1C70         GNC70
     C                   MOVEL     #1C72         GNC72
     C                   MOVEL     #1DESC        GNDESC
     C                   MOVEL     #1DES2        GNDES2
     C                   MOVEL     #1BRCA        GNBRCA
     C                   MOVEL     #1AUTO        GNAUTO                                        CFT00
     C*
     C     #1ACTC        IFEQ      'I'                                                         CFT00
     C/COPY WNCPYSRC,ME1540C010
     C                   MOVEL     *BLANKS       PDTOCD                                        CFT00
     C                   MOVEL     *BLANKS       FXSPRS                                        CFT00
     C                   MOVEL     *BLANKS       SWSTRC                                        CFT00
     C                   MOVEL     *BLANKS       ADVICH                                        CFT00
     C                   MOVEL     *BLANKS       SWPCHG                                        CFT00
     C                   MOVEL     *BLANKS       CABCCO                                        CFT00
     C                   MOVEL     *BLANKS       TXCODE                                        CFT00
     C                   MOVEL     *BLANKS       CHEQCG                                        CFT00
     C                   MOVEL     *BLANKS       TELPCH                                        CFT00
     C                   MOVEL     *BLANKS       MISCCH                                        CFT00
     C                   MOVEL     *BLANKS       COLLCH                                        CFT00
     C                   MOVEL     *BLANKS       MICHG1                                        CFT00
     C                   MOVEL     *BLANKS       CORRCH                                        CFT00
     C                   MOVEL     *BLANKS       MICHG2                                        CFT00
     C                   MOVEL     *BLANKS       DEDUCH                                        CFT00
     C                   MOVEL     *BLANKS       MICHG3                                        CFT00
     C                   MOVEL     *BLANKS       FXCCCH                                        CFT00
     C                   MOVEL     *BLANKS       MICHG4                                        CFT00
     C                   MOVEL     *BLANKS       TFCOCH                                        CFT00
     C                   MOVEL     *BLANKS       MICHG5                                        CFT00
     C                   ENDIF                                                                 CFT00
      *
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HMVD2  Subroutine to move correct values to remaining      *
     C**          detail fields for update.                           *
     C**                                                              *
     C**  Called by  #HAMI2                                           *
     C**  Calls      Nothing                                          *
     C**                                                              *
     C*****************************************************************
     C     #HMVD2        BEGSR
     C*
     C                   MOVEL     #1MTPY        GDMTPY
     C                   MOVE      #1MSET        GDMSET
     C                   MOVE      #2MSEQ        GDCSEQ
     C                   MOVEL     #2MTAG        GDMTAG
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     #2TSEQ        GDMSEQ
     C                   ENDIF
     C                   MOVEL     #2OPER        GDOPER
     C                   MOVEL     #2CMP1        GDCMP1
     C                   MOVEL     #2CMP2        GDCMP2
     C                   MOVEL     #2CMP3        GDCMP3
     C                   MOVEL     #2CMP4        GDCMP4
     C                   MOVEL     #2CMP5        GDCMP5
     C                   MOVEL     #2CMP6        GDCMP6
     C                   MOVEL     #2HDTG        GDHDTG
     C                   MOVEL     #2REPT        GDREPT
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HMVFD  Subroutine to move file values to screen fields     *
     C**                                                              *
     C**  Called by                                                   *
     C**  Calls      Nothing                                          *
     C**                                                              *
     C*****************************************************************
     C     #HMVFD        BEGSR
     C*
     C                   MOVEL     GDMTPY        #1MTPY
     C                   MOVE      GDMSET        #1MSET
     C                   MOVE      GDCSEQ        #2MSEQ
     C                   MOVEL     GDMTAG        #2MTAG
     C                   MOVEL     GDOPER        #2OPER
     C                   MOVEL     GDCMP1        #2CMP1
     C                   MOVEL     GDCMP2        #2CMP2
     C                   MOVEL     GDCMP3        #2CMP3
     C                   MOVEL     GDCMP4        #2CMP4
     C                   MOVEL     GDCMP5        #2CMP5
     C                   MOVEL     GDCMP6        #2CMP6
     C                   MOVEL     GDHDTG        #2HDTG
     C                   MOVEL     GDREPT        #2REPT
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  #HRLCM  Subroutine to rollback or commit any changes        *
     C**                                                              *
     C**  Called by   #HPRHD, #HPRDT                                  *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     #HRLCM        BEGSR
     C*
     C     *IN99         IFEQ      '1'
     C     *IN92         ANDNE     '1'
     C*
     C**  Error: ROLLBACK any DBF changes
     C                   ROLBK
     C*
     C                   ELSE
     C*
     C**  Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C**  ZASNMS  Subroutine to send message to program's message     *
     C**          queue.                                              *
     C**                                                              *
     C**  Called by   #HMBAC, #HVACT, #HVMTP, #HVNUM, #HVHDR,         *
     C**              #HVNWK, #HVPTP, #HVSTT, #HVEXC, #HVDTR,         *
     C**              #HVTAG, #HVOPR                                  *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
      /EJECT
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
     C/EJECT
     C*****************************************************************
     C**  ZXEXPG  Subroutine to cancel and exit program               *
     C**                                                              *
     C**  Called by   S T A R T                                       *
     C**  Calls       ZYEXIT                                          *
     C**                                                              *
     C*****************************************************************
     C     ZXEXPG        BEGSR
     C*
     C**  CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   CALL      'ZA0250'
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
     C*
     C**  CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   CALL      'ZA0250'
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
     C*
     C                   EXSR      ZYEXPG
     C*
     C                   ENDSR
      /EJECT
     C*****************************************************************
     C**  ZYEXPG  Subroutine to exit program (direct)                 *
     C**                                                              *
     C**  Called by   ZXEXIT, #HINIT                                  *
     C**  Calls       Nothing                                         *
     C**                                                              *
     C*****************************************************************
     C     ZYEXPG        BEGSR
     C*
     C* Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
     C*
     C* Terminate program
     C                   SETON                                        LR
     C*
     C                   ENDSR
      /EJECT
     C*
     C* File and Program Error Processing
     C*
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
** CPY@
(c) Finastra International Limited 2001
** HKST  - Valid existing settlement methods
00010208101213
** HKVN  - Numeric field validation table
0123456789
** HKOP  - Valid operator values
EQNEGEGTLELT
