     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross Currency IRS Retrieval')                *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSR - Cross Currency IRS Retrieval                       *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054906           Date 15Jan20               *
      *  Prev Amend No. MD054117           Date 12Sep19               *
      *                 MD053400           Date 03Jul19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044506           Date 28Mar17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD035359           Date 06Aug15               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030454           Date 29Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR1014449          Date 11Feb13               *
      *                 245692             Date 11Dec13               *
      *                 CSW213             Date 03Jun13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 239838             Date 16May06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11254           Date 18Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG9396            Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7784            Date 30Jun05               *
      *                 BUG7620            Date 21Jun05               *
      *                 BUG7621            Date 17Jun05               *
      *                 BUG7619            Date 23Jun05               *
      *                 BUG5871            Date 20May05               *
      *                 BUG6512            Date 17May05               *
      *                 BUG7046            Date 06May05               *
      *                 BUG6671            Date 25Apr05               *
      *                 BUG6472            Date 20Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6419            Date 14Apr05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG6544            Date 08Apr05               *
      *                 BUG6326            Date 18Mar05               *
      *                 BUG6233            Date 10Mar05               *
      *                 BUG5449            Date 04Jan04               *
      *                 BUG5291            Date 30Nov04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 222373             Date 31Oct03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054906 - CBS-2882 fix extenstion for Principal Change      *
      *             Schedule                                          *
      *           - Receive ACTRJ from IRCIRSVU to properly initialize*
      *             field for buffer                                  *
      *  MD054117 - Principal change Increase/Decrease capability     *
      *  MD053400 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Skip      *
      *             validation if action is Reject.                   *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044506 - MT300 98D trade execution date can not be before  *
      *             value date.                                       *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD035359 - Buffer issue in CIRS due to CDL094                *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD030454 - Errors encountered during confirm authorise.      *
      *             Correct mapping to include fields for CDL094.     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  AR1014449 - When currency details are taken from 'Their'     *
      *              currency, need to use WTNBDP. (Child: AR1014450) *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  239838 - For Release 1.2 solution is to reverse out BUG9396  *
      *           which was collected in error.                       *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11254-Positions of the schedules on the buffer were not   *
      *           changed to cope with impact of CLE031 changes.      *
      *           Also CDL038 changes when rebuilding buffer is wrong *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG9396- Our/their pay/rate change dates incorrectly formatted
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7784 - Pass correct date format indicator to ZDATE2       *
      *  BUG7620 - Use correct d.p. field for Their Principle change  *
      *  BUG7621 - Retrieve schedules even if related frequency is    *
      *            not 'Z' or 'C' in the case of cashflow schedules   *
      *  BUG7619 - Prevent decimal data occurrence                    *
      *  BUG5871 - Send deal status to MidasPlus                      *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG7046- Retrieve principal change schedules even if         *
      *           next principal change date is blank                 *
      *  BUG6671 - Implement Auto Authorisation                       *
      *  BUG6419 - Format schedule amounts correctly                  *
      *  BUG6472- Added sign field for short term rate                *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG6544- Fields converted in SrUpFront are done in CVT       *
      *  BUG6326- Return Rec settlement fields correctly              *
      *  BUG6233- Principle change amount is 0 when plato is off      *
      *  BUG5449- Add schedules to CIRS                               *
      *  BUG5291- Various error fixes                                 *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FDLDTSCL0  IF   E           K DISK                                                      BUG5449
     FDLPCSCL0  IF   E           K DISK                                                      BUG5449
     FDLCFSCL0  IF   E           K DISK                                                      BUG5449
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *  Array for Our rate change date Schedule                                             BUG5449
     D ORDATEA         S              8A   DIM(600)                                          BUG5449
     D ORDATEAST       S           4800A                                                     BUG5449
      *  Array for Our interest payment date Schedule                                        BUG5449
     D OPDATEA         S              8A   DIM(600)                                          BUG5449
     D OPDATEAST       S           4800A                                                     BUG5449
      *  Array for Their rate change date Schedule                                           BUG5449
     D TRDATEA         S              8A   DIM(600)                                          BUG5449
     D TRDATEAST       S           4800A                                                     BUG5449
      *  Array for Their interest payment date Schedule                                      BUG5449
     D TPDATEA         S              8A   DIM(600)                                          BUG5449
     D TPDATEAST       S           4800A                                                     BUG5449
      ** for Transaction Currencies (Receipt and Payment Currency)                           CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      *  Date schedule                                                                       BUG5449
     D DATESCH         DS                                                                    BUG5449
     D  DSDATE                        6A                                                     BUG5449
     D  DSCHOL                        1A                                                     BUG5449
     D  DSPDAT                        1A                                                     BUG5449
      *  Array for Our cash flow Schedule                                                    BUG5449
     D OCFSA           S             22A   DIM(600)                                          BUG5449
     D OCFSAST         S          13200A                                                     BUG5449
      *  Array for Their cash flow Schedule                                                  BUG5449
     D TCFSA           S             22A   DIM(600)                                          BUG5449
     D TCFSAST         S          13200A                                                     BUG5449
      *  Cash Flow schedule                                                                  BUG5449
     D CASHFSCH        DS                                                                    BUG5449
     D  CFDATE                        6A                                                     BUG5449
     D  CFCHOL                        1A                                                     BUG5449
     D  CFAMT                        14A                                                     BUG5449
     D  CFPDAT                        1A                                                     BUG5449
      *  Array for Our Principle change Schedule                                             BUG5449
     D OPCSA           S             25A   DIM(600)                                          BUG5449
     D OPCSAST         S          15000A                                                     BUG5449
      *  Array for Their Principle change Schedule                                           BUG5449
     D TPCSA           S             25A   DIM(600)                                          BUG5449
     D TPCSAST         S          15000A                                                     BUG5449
      *  Principle Change Schedule                                                           BUG5449
     D PCHGSCH         DS                                                                    BUG5449
     D  PCDATE                        6A                                                     BUG5449
     D  PCCHOL                        1A                                                     BUG5449
     D  PCAMT                        16A                                                     BUG5449
     D  PCIDFLG                       1A                                                     BUG5449
     D  PCPDAT                        1A                                                     BUG5449
      *  Date schedule formula for generating dates                                          BUG5449
     D FORMULAOR       DS                                                                    BUG5449
     D  SFREQFOR                      1A                                                     BUG5449
     D  SFORMOR                       7A                                                     BUG5449
     D FORMULAOP       DS                                                                    BUG5449
     D  SFREQFOP                      1A                                                     BUG5449
     D  SFORMOP                       7A                                                     BUG5449
     D FORMULATR       DS                                                                    BUG5449
     D  SFREQFTR                      1A                                                     BUG5449
     D  SFORMTR                       7A                                                     BUG5449
     D FORMULATP       DS                                                                    BUG5449
     D  SFREQFTP                      1A                                                     BUG5449
     D  SFORMTP                       7A                                                     BUG5449
     D FORMULAOC       DS                                                                    BUG5449
     D  SFREQFOC                      1A                                                     BUG5449
     D  SFORMOC                       7A                                                     BUG5449
     D  SFORMAMTOC                   14A                                                     BUG5449
     D FORMULATC       DS                                                                    BUG5449
     D  SFREQFTC                      1A                                                     BUG5449
     D  SFORMTC                       7A                                                     BUG5449
     D  SFORMAMTTC                   14A                                                     BUG5449
     D FORMULAOPC      DS                                                                    BUG5449
     D  SFREQFOPC                     1A                                                     BUG5449
     D  SFORMOPC                      7A                                                     BUG5449
     D  SFORMAMTOPC                  16A                                                     BUG5449
     D  SFORMPIDFOPC                  1A                                                     BUG5449
     D FORMULATPC      DS                                                                    BUG5449
     D  SFREQFTPC                     1A                                                     BUG5449
     D  SFORMTPC                      7A                                                     BUG5449
     D  SFORMAMTTPC                  16A                                                     BUG5449
     D  SFORMPIDFTPC                  1A                                                     BUG5449
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
      ** Cross Currency IRS deal
     D CIRSScnFmt    E DS                  EXTNAME(IRCIRSPD)
 
      ***Interest*Rate Calendars (dummy)                                                     BUG5449
     D*OurRatChgD****E*DS*                 EXTNAME(IRDTSCPD)                                 BUG5449
     D********************                 PREFIX(OR_)                                       BUG5449
     D*OurIntPayD****E*DS*                 EXTNAME(IRDTSCPD)                                 BUG5449
     D********************                 PREFIX(OI_)                                       BUG5449
     D*ThrRatChgD****E*DS*                 EXTNAME(IRDTSCPD)                                 BUG5449
     D********************                 PREFIX(TR_)                                       BUG5449
     D*ThrIntPayD****E*DS*                 EXTNAME(IRDTSCPD)                                 BUG5449
     D********************                 PREFIX(TI_)                                       BUG5449
 
      ** Settlement Instructions - Interest                                                  BUG5449
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
     D**********                           PREFIX(A)                                         BUG5449
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
     D**********                           PREFIX(A)                                         BUG5449
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
     D**********                           PREFIX(A)                                         BUG5449
 
      ** Settlement Instructions - Value Date
     D InRecStmtV    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(B)
     D InPayStmtV    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(B)
 
      ** Settlement Instructions - Maturity Date
     D InRecStmtM    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(C)
     D InPayStmtM    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(C)
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      ** Cross Currency IRS deal
     D CIRSFilFmt    E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(RX)
     D CIRSRecIns            716    784
     D CIRSPayIns            785   1343
     D CIRSFraIns           1345   1992
                                                                                             BUG5291
     D DealXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                 BUG5291
      ** Deal Extension File Format                                                          BUG5291
 
      ** Settlement Instructions - File (D/B) format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
 
     D ExtSetV       E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(VD)
     D**ExRValDat*************10     84                                                      BUG5291
     D  ExRValDat             10     90                                                      BUG5291
     D**ExPValDat*************85    653                                                      BUG5291
     D  ExPValDat             91    665                                                      BUG5291
 
     D ExtSetM       E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(MD)
     D**ExRMatDat*************10     84                                                      BUG5291
     D  ExRMatDat             10     90                                                      BUG5291
     D**ExPMatDat*************85    653                                                      BUG5291
     D  ExPMatDat             91    665                                                      BUG5291
 
     D ExtSetI       E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(ID)
 
      ** Settlement Instructions - Current  (Extra)
     D CrRecStmt     E DS                  EXTNAME(SDESSRPD) PREFIX(Cr)
     D CrPayStmt     E DS                  EXTNAME(SDESSPPD) PREFIX(Cr)
     D CrFRAStmt     E DS                  EXTNAME(SDESSFPD) PREFIX(Cr)
                                                                                             BUG6671
      ** FRA/IRS Interface Non-Screen Data                                                   BUG6671
     D InfData       E DS                  EXTNAME(IRRXIFPD)                                 BUG6671
                                                                                             BUG6671
     D ExtData       E DS                  EXTNAME(IRCSEXPD)                                 BUG6671
      * IR Cross Ccy IRS Extra Data - File (D/B) format                                      BUG6671
 
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D PDlRILkpd     E DS                  EXTNAME(DLRILKPD)                                  CSW213
                                                                                              CSW213
      ** Define data structure for InSwift2013                                                CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External DS for Bank Details                                                        BUG6377
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 BUG6377
      ** Midas Modules Details Accessed via access program                      BUG6233
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    BUG6233
                                                                                              245692
      ** External DS for Dealing Details                                                      245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
 
     D/COPY QWINDSRC,IRCIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
     D AuthComp        S              1A
     D FwdBck          S              1A
     D DDDLNO_IN       S              6A
     D Buffer          S           6000A
     D Buffer2         S           3999                                                      BUG5449
     D BufferEx2       S           9999                                                      BUG5449
     D BufferEx3       S           9999                                                      BUG5449
     D BufferEx4       S           9999                                                      BUG5449
     D BufferEx5       S           9999                                                      BUG5449
     D BufferEx6       S           9999                                                      BUG5449
     D BufferEx7       S           9999                                                      BUG5449
     D BufferEx8       S           9999                                                      BUG5449
     D BufferEx9       S           9999                                                      BUG5449
     D APIRetc         S              1A
 
     D WDlRed          S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A
     D CIR003          S              1A
     D CIR008          S              1A
     D CAP041          S              1A
     D CIR001          S              1A
     D CIR002          S              1A
     D CIR006          S              1A
     D CLE025          S              1    INZ('N')                                          BUG5291
 
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMs          S              7A
     D PDlNoR          S              6A
 
     D ModeOfOp        S              6A
     D APRESPMODE      S              1A
     D FOTRID          S             20A
     D FOASID          S             20A
     D OKACTN          S              1A
     D OKDLNO          S              1A
     D OKBRCA          S              1A
 
     D*PDlSts***       S             24A                                                     BUG5871
     D DDSTS           S             24A                                                     BUG5871
 
     D WUCDP           S              1P 0
     D WTCDP           S              1P 0
     D WUPDP           S              1P 0
     D WBODP           S              1P 0
 
     D I#SDLNO         S                   LIKE(SDLNO) INZ(*BLANKS)
 
     D ZFLD15          S             15P 0
     D ZDECS           S              1P 0
     D ZECODE          S              1A
     D ZECHAR          S              1A
     D ZOUT21          S             21A
     D DealNo          S              6  0                                                   BUG5449
     D OTInd           S              1                                                      BUG5449
     D RatPay          S              1                                                      BUG5449
     D ProcDate        S              5  0                                                   BUG5449
      ** Array index                                                                         BUG5449
     D X               S              3  0                                                   BUG5449
     D WONBDP          S                   LIKE(A6NBDP)                                      BUG5449
     D WTNBDP          S                   LIKE(A6NBDP)                                      BUG6419
     D**********WPNBDP          S                   LIKE(A6NBDP)                     BUG5449 BUG6419
     D**********WRNBDP          S                   LIKE(A6NBDP)                     BUG5449 BUG6419
     D WRSCY           S              3A                                                     BUG5449
     D WPSCY           S              3A                                                     BUG5449
     D PZFIELD         S             16A                                                     BUG5449
     D PZADEC          S              1  0                                                   BUG5449
     D ZDAYNO          S              5P 0                                                   BUG6377
     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
 
      ** Work Variables for DLRPIFR                                                           CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
     D CSW213          S              1                                                       CSW213
      ** Action Code Reject                                                                 MD053400
     D ACTRJ           S              1                                                     MD053400
      *                                                                                     MD054117
     D PSYSVAL1        C                   CONST('DspPrinInDecInd')                         MD054117
     D PRETURN         S              7A                                                    MD054117
     D POP01           S             20A                                                    MD054117
     D PVL01           S            200A                                                    MD054117
     D POP02           S             20A                                                    MD054117
     D PVL02           S            200A                                                    MD054117
     D POP03           S             20A                                                    MD054117
     D PVL03           S            200A                                                    MD054117
     D POP04           S             20A                                                    MD054117
     D PVL04           S            200A                                                    MD054117
     D POP05           S             20A                                                    MD054117
     D PVL05           S            200A                                                    MD054117
     D POP06           S             20A                                                    MD054117
     D PVL06           S            200A                                                    MD054117
     D POP07           S             20A                                                    MD054117
     D PVL07           S            200A                                                    MD054117
     D POP08           S             20A                                                    MD054117
     D PVL08           S            200A                                                    MD054117
     D POP09           S             20A                                                    MD054117
     D PVL09           S            200A                                                    MD054117
     D POP10           S             20A                                                    MD054117
     D PVL10           S            200A                                                    MD054117
     D PCIDCF          S              1A                                                    MD054117
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** If the action code is blank, enquire unless authorising
 
     C                   CLEAR                   CIRSFilFmt
     C                   CLEAR                   PDlRILkpd                                    CSW213
     C**********         CLEAR                   OurRatChgD                                  BUG5449
     C**********         CLEAR                   OurIntPayD                                  BUG5449
     C**********         CLEAR                   ThrRatChgD                                  BUG5449
     C**********         CLEAR                   ThrIntPayD                                  BUG5449
     C                   CLEAR                   ORDATEA                                     BUG5449
     C                   CLEAR                   OPDATEA                                     BUG5449
     C                   CLEAR                   TRDATEA                                     BUG5449
     C                   CLEAR                   TPDATEA                                     BUG5449
     C                   CLEAR                   OCFSA                                       BUG5449
     C                   CLEAR                   TCFSA                                       BUG5449
     C                   CLEAR                   OPCSA                                       BUG5449
     C                   CLEAR                   TPCSA                                       BUG5449
                                                                                             BUG7619
      ** Initialize DATA fields to avoid decimal data error                                  BUG7619
                                                                                             BUG7619
     C                   CLEAR                   DATA                                        BUG7619
                                                                                             BUG7619
     C                   IF        CLE025 = 'Y'                                              BUG5291
     C                   CLEAR                   DealXFilFmt                                 BUG5291
     C                   ENDIF                                                               BUG5291
 
     C     SACCD         IFEQ      *BLANKS
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           SACCD
     C                   ELSE
     C                   MOVEL     'E'           SACCD
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     'N'           PRdFwd
     C                   MOVEL     'N'           PRdBck
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           PRdFwd
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'Y'           PRdBck
     C                   ENDIF
     C                   ENDIF
 
     C     PRdFwd        IFEQ      'Y'
     C     PRdBck        OREQ      'Y'
     C                   EXSR      SrCIRSRED
     C                   ELSE
     C                   EVAL      WDlRed = DDDLNO_In
     C                   EVAL      PErrMs = *BLANKS
     C                   ENDIF
 
      ** If Cross Currency IRS read and no error message returned,
      ** retrieve deal details and convert to screen format
 
     C                   IF        RetCodeOut = *BLANKS AND
     C                             WDlRed <> *BLANKS
 
     C                   EVAL      SDLNO = WDlRed
     C                   EXSR      SrCIRSRTV
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
                                                                                             BUG6512
 
     C                   IF        CAP041 = 'Y' AND Idx = *ZERO
     C/COPY QWINDSRC,IRCIRSMOV1
     C                   ENDIF
 
     C     Idx           IFEQ      0
     C                   EXSR      SrCIRSCVT
     C**********         EXSR      SrSETINCVT                                                BUG5291
     C                   EXSR      SrSETTCVT                                                 BUG5291
      * Calculated Our/Their interest fix dates                                              BUG6377
     C                   EXSR      SrINFDCVT                                                 BUG6377
     C**********         EXSR      SrUpFront                                                 BUG6544
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PErrMs <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO'
     C                   EVAL      MsgIDArr(Idx) = PErrMs
     C                   ENDIF
                                                                                             BUG5449
      ** If IRCs on in system and no previous errors retrieve IRC dates                      BUG5449
                                                                                             BUG5449
     C     CIR001        IFEQ      'Y'                                                       BUG5449
     C*****Idx           ANDEQ     0                                                 BUG5449 BUG7621
     C                   EXSR      RetrieveIC                                                BUG5449
     C                   ENDIF                                                               BUG5449
 
      *                                                                                       CSW213
      ** Setup fields in link file if CSW213 is on.                                           CSW213
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SRGetRPIF                                                  CSW213
     C                   EVAL      DLRPIFS1In = DLRPIFScn1Fmt                                 CSW213
     C                   EVAL      DLRPIFS2In = DLRPIFScn2Fmt                                 CSW213
     C                   EVAL      DLRPIFS3In = DLRPIFScn3Fmt                                 CSW213
     C                   EVAL      DLRPIFS4In = DLRPIFScn4Fmt                                 CSW214
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
      ** Build buffer with required output, if no errors occurred
 
     C                   IF        Idx > *ZERO OR RetCodeOut <> *BLANKS
     C                   EVAL      APIRetc = '0'
     C                   ELSE
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3457)                     CSW213 MD030454
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3465)                     CSW213 MD030454
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3473)                     CSW213 MD030454
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3481)                     CSW213 MD030454
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3489)                     CSW213 MD030454
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3511)                     CSW213 MD030454
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3533)                    CSW213 MD030454
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3558)                    CSW213 MD030454
     C                   EVAL      FORMULAOR=%SUBST(Buffer2:79)                             MD030454
     C                   EVAL      FORMULAOP=%SUBST(Buffer2:87)                             MD030454
     C                   EVAL      FORMULATR=%SUBST(Buffer2:95)                             MD030454
     C                   EVAL      FORMULATP=%SUBST(Buffer2:103)                            MD030454
     C                   EVAL      FORMULAOC=%SUBST(Buffer2:111)                            MD030454
     C**********         EVAL      FORMULATC=%SUBST(Buffer2:113)                   MD030454 MD035359
     C                   EVAL      FORMULATC=%SUBST(Buffer2:133)                            MD035359
     C                   EVAL      FORMULAOPC=%SUBST(Buffer2:155)                           MD030454
     C                   EVAL      FORMULATPC=%SUBST(Buffer2:180)                           MD030454
     C                   MOVEA     ORDATEA       ORDATEAST                                   BUG5449
     C                   MOVEA     OPDATEA       OPDATEAST                                   BUG5449
     C                   MOVEA     TRDATEA       TRDATEAST                                   BUG5449
     C                   MOVEA     TPDATEA       TPDATEAST                                   BUG5449
     C                   MOVEA     OCFSA         OCFSAST                                     BUG5449
     C                   MOVEA     TCFSA         TCFSAST                                     BUG5449
     C                   MOVEA     OPCSA         OPCSAST                                     BUG5449
     C                   MOVEA     TPCSA         TPCSAST                                     BUG5449
     C                   EVAL      Buffer = CIRSScnfmt +
     C**********                            OurRatChgD +                                     BUG5291
     C**********                            OurIntPayD +                                     BUG5291
     C**********                            ThrRatChgD +                                     BUG5291
     C**********                            ThrIntPayD +                                     BUG5291
     C                                      InRecSttmt +
     C                                      InPaySttmt +
     C                                      InFRASttmt +
     C                                      InRecStmtV +
     C                                      InPayStmtV +
     C                                      InRecStmtM +
     C***********                           InPayStmtM                                       BUG5449
     C**********                            InPayStmtM +                             BUG5449 BUG6377
     C**********                            InPayStmtM + SUINFD + STINFD +           BUG6377 BUG6671
     C                                      InPayStmtM +                                     BUG6671
     C**********                            InfData + ExtData +                     BUG6671 MD030454
     C**********                            SUINFD + STINFD +                       BUG6671 MD030454
     C**********                            CPST     + DSPCP +                      BUG6512 MD030454
     C**********                            BKST     + DSPBK +                      BUG6512 MD030454
     C**********                            DDSTS  +                                BUG5871 MD030454
     C**********                            FORMULAOR + FORMULAOP +                 BUG5449 MD030454
     C**********                            FORMULATR + FORMULATP +                 BUG5449 MD030454
     C**********                            FORMULAOC + FORMULATC +                 BUG5449 MD030454
     C**********                            FORMULAOPC+ FORMULATPC + ORDATEAST        BUG5449 CSW213
     C**********                            FORMULAOPC+ FORMULATPC +                 CSW213 MD030454
     C**********                            InSwift2013                              CSW213 MD030454
     C                                      InfData                                         MD030454
     C                                       + ExtData                                      MD030454
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2706)+OPDATEAST          BUG5449 BUG6377
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1905)+TRDATEAST        BUG5449 BUG6377
     C**********                               +TPDATEAST                            BUG5449 BUG6377
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2304)+OCFSAST          BUG5449 BUG6377
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7503)+TCFSAST            BUG5449 BUG6377
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4302)+OPCSAST            BUG5449 BUG6377
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:1101)                    BUG5449 BUG6377
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:11100)+TPCSAST           BUG5449 BUG6377
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:6100)                    BUG5449 BUG6377
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2694)+OPDATEAST            BUG6377CDL028
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1893)+TRDATEAST          BUG6377CDL028
     C**********                               +TPDATEAST                              BUG6377CDL028
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2292)+OCFSAST            BUG6377CDL028
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7491)+TCFSAST              BUG6377CDL028
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4290)+OPCSAST              BUG6377CDL028
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:1089)                      BUG6377CDL028
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:11088)+TPCSAST             BUG6377CDL028
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:6087)                      BUG6377CDL028
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2596)+OPDATEAST           CDL028 BUG6472
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1795)+TRDATEAST         CDL028 BUG6472
     C**********                               +TPDATEAST                             CDL028 BUG6472
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2194)+OCFSAST           CDL028 BUG6472
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7393)+TCFSAST             CDL028 BUG6472
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4192)+OPCSAST             CDL028 BUG6472
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:991)                      CDL028 BUG6472
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10990)+TPCSAST            CDL028 BUG6472
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5989)                     CDL028 BUG6472
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2594)+OPDATEAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1793)+TRDATEAST        BUG6472 BUG6671
     C**********                               +TPDATEAST                            BUG6472 BUG6671
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2192)+OCFSAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7391)+TCFSAST            BUG6472 BUG6671
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4190)+OPCSAST            BUG6472 BUG6671
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:989)                     BUG6472 BUG6671
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10988)+TPCSAST           BUG6472 BUG6671
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5987)                    BUG6472 BUG6671
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2543)+OPDATEAST          BUG6671 BUG6671
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1742)+TRDATEAST        BUG6671 BUG6671
     C**********                               +TPDATEAST                            BUG6671 BUG6671
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2141)+OCFSAST          BUG6671 BUG6671
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7340)+TCFSAST            BUG6671 BUG6671
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4139)+OPCSAST            BUG6671 BUG6671
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:938)                     BUG6671 BUG6671
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10937)+TPCSAST           BUG6671 BUG6671
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5936)                    BUG6671 BUG6671
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2537)+OPDATEAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1736)+TRDATEAST        BUG6512 BUG5871
     C**********                               +TPDATEAST                            BUG6512 BUG5871
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2135)+OCFSAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7334)+TCFSAST            BUG6512 BUG5871
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4133)+OPCSAST            BUG6512 BUG5871
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:932)                     BUG6512 BUG5871
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10931)+TPCSAST           BUG6512 BUG5871
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5930)                    BUG6512 BUG5871
     C*******************EVAL      Buffer2=%SUBST(ORDATEAST:2513)+OPDATEAST          BUG5871 BUG9396
     C*******************EVAL      BufferEx2=%SUBST(OPDATEAST:1712)+TRDATEAST        BUG5871 BUG9396
     C*******************                      +TPDATEAST                            BUG5871 BUG9396
     C*******************EVAL      BufferEx3=%SUBST(TPDATEAST:2111)+OCFSAST          BUG5871 BUG9396
     C*******************EVAL      BufferEx4=%SUBST(OCFSAST:7310)+TCFSAST            BUG5871 BUG9396
     C*******************EVAL      BufferEx5=%SUBST(TCFSAST:4109)+OPCSAST            BUG5871 BUG9396
     C*******************EVAL      BufferEx6=%SUBST(OPCSAST:908)                     BUG5871 BUG9396
     C*******************EVAL      BufferEx7=%SUBST(OPCSAST:10907)+TPCSAST           BUG5871 BUG9396
     C*******************EVAL      BufferEx8=%SUBST(TPCSAST:5906)                    BUG5871 BUG9396
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2517)+OPDATEAST         BUG9396 BUG11254
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1716)+TRDATEAST       BUG9396 BUG11254
     C**********                               +TPDATEAST                           BUG9396 BUG11254
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2115)+OCFSAST         BUG9396 BUG11254
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7314)+TCFSAST           BUG9396 BUG11254
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4113)+OPCSAST           BUG9396 BUG11254
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:912)                    BUG9396 BUG11254
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10911)+TPCSAST          BUG9396 BUG11254
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5910)                   BUG9396 BUG11254
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2419)+OPDATEAST          BUG11254 239838
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1618)+TRDATEAST        BUG11254 239838
     C**********                               +TPDATEAST                            BUG11254 239838
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2017)+OCFSAST          BUG11254 239838
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7216)+TCFSAST            BUG11254 239838
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4015)+OPCSAST            BUG11254 239838
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:814)                     BUG11254 239838
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10813)+TPCSAST           BUG11254 239838
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5812)                    BUG11254 239838
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2513)+OPDATEAST           239838 CSF011A
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1712)+TRDATEAST         239838 CSF011A
     C**********                               +TPDATEAST                             239838 CSF011A
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2111)+OCFSAST           239838 CSF011A
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7310)+TCFSAST             239838 CSF011A
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4109)+OPCSAST             239838 CSF011A
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:908)                      239838 CSF011A
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10907)+TPCSAST            239838 CSF011A
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5906)                     239838 CSF011A
      *
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:427)                      CSF011A CSW213
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:4426)+OPDATEAST         CSF011A CSW213
     C**********                               +TRDATEAST+TPDATEAST                   CSF011A CSW213
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:25)+OCFSAST             CSF011A CSW213
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5224)+TCFSAST             CSF011A CSW213
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2023)                     CSF011A CSW213
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12022)+OPCSAST            CSF011A CSW213
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:8821)+TPCSAST             CSF011A CSW213
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:3820)                     CSF011A CSW213
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:13819)                    CSF011A CSW213
     C**********         EVAL      Buffer2 = %SUBST(InSwift2013:427)                 CSW213 MD030454
     C**********                               +ORDATEAST                            CSW213 MD030454
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:2494)+OPDATEAST        CSW213 MD030454
     C**********                               +TRDATEAST                            CSW213 MD030454
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:2893)+TPDATEAST        CSW213 MD030454
     C**********                               +OCFSAST                              CSW213 MD030454
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:3292)+TCFSAST            CSW213 MD030454
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:91)                      CSW213 MD030454
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:10090)+OPCSAST           CSW213 MD030454
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:6889)+TPCSAST            CSW213 MD030454
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:1888)                    CSW213 MD030454
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:11887)                   CSW213 MD030454
     C                   EVAL      Buffer2 = %SUBST(ExtData:15)                             MD030454
     C                                      + SUINFD + STINFD                               MD030454
     C                                      + CPST + DSPCP                                  MD030454
     C                                      + BKST + DSPBK                                  MD030454
     C                                      + DDSTS                                         MD030454
     C                                      + FORMULAOR + FORMULAOP                         MD030454
     C                                      + FORMULATR + FORMULATP                         MD030454
     C                                      + FORMULAOC + FORMULATC                         MD030454
     C                                      + FORMULAOPC+ FORMULATPC                        MD030454
     C                                      + InSwift2013                                   MD030454
     C                                      + ACTRJ                                         MD053400
     C                                      + ORDATEAST                                     MD030454
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:1864)+OPDATEAST        MD030454 CSW214
     C**********                            + TRDATEAST                              MD030454 CSW214
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:2263)+TPDATEAST        MD030454 CSW214
     C**********                               +OCFSAST                              MD030454 CSW214
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:2662)                    MD030454 CSW214
     C**********         EVAL      BufferEx5=%SUBST(OCFSAST:12661)                   MD030454 CSW214
     C**********                            + TCFSAST                                MD030454 CSW214
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:9460)                    MD030454 CSW214
     C**********                            + OPCSAST                                MD030454 CSW214
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:6259)+TPCSAST            MD030454 CSW214
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:1258)                    MD030454 CSW214
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:11257)                   MD030454 CSW214
     C**********                                                                     MD030454 CSW214
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:1164)+OPDATEAST        CSW214 MD035359
     C**********                            + TRDATEAST                              CSW214 MD035359
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:1563)+TPDATEAST        CSW214 MD035359
     C**********                               +OCFSAST                              CSW214 MD035359
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:1962)                    CSW214 MD035359
     C**********         EVAL      BufferEx5=%SUBST(OCFSAST:11961)                   CSW214 MD035359
     C**********                            + TCFSAST                                CSW214 MD035359
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:8760)                    CSW214 MD035359
     C**********                            + OPCSAST                                CSW214 MD035359
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:5559)+TPCSAST            CSW214 MD035359
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:558)                     CSW214 MD035359
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:10557)                   CSW214 MD035359
      *                                                                              MD035359 CSW216
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:1702)+OPDATEAST        MD035359 CSW216
     C**********                            + TRDATEAST                              MD035359 CSW216
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:2101)+TPDATEAST        MD035359 CSW216
     C**********                               +OCFSAST                              MD035359 CSW216
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:2500)                    MD035359 CSW216
     C**********         EVAL      BufferEx5=%SUBST(OCFSAST:12499)                   MD035359 CSW216
     C**********                            + TCFSAST                                MD035359 CSW216
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:9298)                    MD035359 CSW216
     C**********                            + OPCSAST                                MD035359 CSW216
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:6097)+TPCSAST            MD035359 CSW216
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:1096)                    MD035359 CSW216
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:11095)                   MD035359 CSW216
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:1662)+OPDATEAST        CSW216 MD053400
     C**********                            + TRDATEAST                              CSW216 MD053400
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:2061)+TPDATEAST        CSW216 MD053400
     C**********                               +OCFSAST                              CSW216 MD053400
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:2460)                    CSW216 MD053400
     C**********         EVAL      BufferEx5=%SUBST(OCFSAST:12459)                   CSW216 MD053400
     C**********                            + TCFSAST                                CSW216 MD053400
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:9258)                    CSW216 MD053400
     C**********                            + OPCSAST                                CSW216 MD053400
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:6057)+TPCSAST            CSW216 MD053400
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:1056)                    CSW216 MD053400
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:11055)                   CSW216 MD053400
     C                   EVAL      BufferEx2=%SUBST(ORDATEAST:1661)+OPDATEAST               MD053400
     C                                      + TRDATEAST                                     MD053400
     C                   EVAL      BufferEx3=%SUBST(TRDATEAST:2060)+TPDATEAST               MD053400
     C                                         +OCFSAST                                     MD053400
     C                   EVAL      BufferEx4=%SUBST(OCFSAST:2459)                           MD053400
     C                   EVAL      BufferEx5=%SUBST(OCFSAST:12458)                          MD053400
     C                                      + TCFSAST                                       MD053400
     C                   EVAL      BufferEx6=%SUBST(TCFSAST:9257)                           MD053400
     C                                      + OPCSAST                                       MD053400
     C                   EVAL      BufferEx7=%SUBST(OPCSAST:6056)+TPCSAST                   MD053400
     C                   EVAL      BufferEx8=%SUBST(TPCSAST:1055)                           MD053400
     C                   EVAL      BufferEx9=%SUBST(TPCSAST:11054)                          MD053400
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCIRSRED -  Roll Backwards & Forwards through Deals File    *
      *****************************************************************
     C     SrCIRSRED     BEGSR
 
     C                   CALLB     'IRCIRSRED'
      ** Inputs
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      ** Action code
     C                   PARM                    SACCD
      ** Deal number
     C                   PARM      DDDLNO_In     SDLNO
      ** Read forwards
     C                   PARM                    PRdFwd
      ** Read backwards
     C                   PARM                    PRdBck
      ** Switchable feature CIR008
     C                   PARM                    CIR008
      ** Outputs
      ** Error meassage
     C                   PARM      *BLANKS       PErrMs
      ** Deal number read
     C                   PARM      *BLANKS       PDlNoR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCIRSRTV -  Retrieve Deal from File                         *
      *****************************************************************
     C     SrCIRSRTV     BEGSR
 
     C                   CALLB     'IRCIRSRTV'
      ** Inputs
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp
      ** Response mode
     C                   PARM      'S'           APRESPMODE
      ** Action Code
     C                   PARM                    SACCD
      ** Front Office Transaction ID
     C                   PARM                    FOTRID
      ** Front Office Associated Transaction Id
     C                   PARM                    FOASID
      ** (Midas) Deal Number
     C                   PARM                    SDLNO
      ** (Midas) Associated Deal Number
     C                   PARM                    SLNKDN
      ** Booking branch
     C                   PARM                    SBRCA
      **  Switchable feature CIR008
     C                   PARM                    CIR008
      ** Outputs
      ** (Current) deal in file format
     C                   PARM                    CIRSFilFmt
     C                   PARM                    DealXFilFmt                                 BUG5291
      ** OK - Action code
     C                   PARM                    OKACTN
      ** OK - Deal Number
     C                   PARM                    OKDLNO
      ** OK - Booking branch
     C                   PARM                    OKBRCA
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    CIR003
     C                   PARM                    ExtSetV
     C                   PARM                    ExtSetI
     C                   PARM                    ExtSetM
      ** Warning fields/message IDs/message data (arrays) from/to caller                      222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIDArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
      ** Array index (3P0) from/to caller                                                     222373
     C                   PARM                    WIdx                                         222373
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCIRSCVT -  Conversion of File Fields to Screen Format      *
      *****************************************************************
     C     SrCIRSCVT     BEGSR
 
     C                   CALLB     'IRCIRSCVT'
      ** Inputs
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Deal in file format
     C                   PARM                    CIRSFilFmt
     C                   PARM                    DealXFilFmt                                 BUG5291
      ** Switchable feature CIR008
     C                   PARM                    CIR008
      ** Outputs
      ** Deal in screen format
     C                   PARM                    CIRSScnFmt
      ** Deal Status
     C**********         PARM                    PDlSts                                      BUG5871
     C                   PARM                    DDSTS                                       BUG5871
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ***SrSETUP*-*Setup*Fields*for*Conversion*************************                      BUG5291
      *  SrSETTCVT - Setup Fields for Conversion                      *                      BUG5291
      *****************************************************************
     C*****SrSETUP       BEGSR                                                               BUG5291
     C     SrSETTCVT     BEGSR                                                               BUG5291
 
      ** Setup settlement instructions from Cross Currency IRS
      * Setup fields for call to ZASETINCVT for interest settlement details                  BUG5291
      * Receive                                                                              BUG5291
 
     C**********         EVAL      DBRecSttmt = CIRSRecIns + RXROBR                          BUG5291
     C**********         Eval      FLPSTM = RXRSTM                                   BUG5291 BUG6326
     C**********         Eval      FLPONS = RXRONS                                   BUG5291 BUG6326
     C                   Eval      FLRSTM = RXRSTM                                           BUG6326
     C                   Eval      FLRONS = RXRONS                                           BUG6326
     C                   Eval      %SUBST(DBRecSttmt:21:55) =                                BUG5291
     C                               %SUBST(CIRSRecIns:15:55)                                BUG5291
     C                   Eval      FLROBR = RXROBR                                           BUG5291
     C                   EVAL      FLRSCY     = RXRSCY
      * Pay                                                                                  BUG5291
     C**********         EVAL      DBPaySttmt = CIRSPayIns + RXPOBR + RXCVMR                 BUG5291
     C                   Eval      FLPSTM = RXPSTM                                           BUG5291
     C                   Eval      FLPONS = RXPONS                                           BUG5291
     C                   Eval      %SUBST(DBPaySttmt:21:545)=                                BUG5291
     C                                %SUBST(CIRSPayIns:15:545)                              BUG5291
     C**********         Eval      FLPOBR = RXROBR                                   BUG5291 BUG6326
     C                   Eval      FLPOBR = RXPOBR                                           BUG6326
     C                   Eval      FLCVMR = RXCVMR                                           BUG5291
     C                   EVAL      FLPSCY     = RXPSCY
     C                   EVAL      FLIC72     = RXIC72
      * FRA/IRS                                                                              BUG5291
     C                   EVAL      DBFraSttmt = CIRSFraIns
     C                   MOVE      RXAGVC        FLAGVC
 
     C                   EXSR      SrSETINCVT
 
     C                   EVAL      InPaySttmt = CrPayStmt
     C                   EVAL      InRecSttmt = CrRecStmt
     C                   EVAL      InFRASttmt = CrFRAStmt
 
     C                   IF        CIR003 = 'Y'
 
      ** Set up Value Date Settlement Details                                                BUG5291
     C                   EVAL      DBRecSttmt = ExRValDat
     C                   EVAL      DBPaySttmt = ExPValDat
 
     C                   EXSR      SrSETINCVT
 
     C                   EVAL      InPayStmtV = CrPayStmt
     C                   EVAL      InRecStmtV = CrRecStmt
 
      ** Set up Maturity Date Settlement Details                                             BUG5291
     C                   EVAL      DBRecSttmt = ExRMatDat
     C                   EVAL      DBPaySttmt = ExPMatDat
 
     C                   EXSR      SrSETINCVT
 
     C                   EVAL      InPayStmtM = CrPayStmt
     C                   EVAL      InRecStmtM = CrRecStmt
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSETINCVT - Conversion of Settlement File Fields to Screen  *
      *               Format                                          *
      *****************************************************************
     C     SrSETINCVT    BEGSR
 
     C                   CALLB     'ZASETINCVT'
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    DBPaySttmt
      ** File receipt settlement instruction
     C                   PARM                    DBRecSttmt
      ** File FRA/IRS settlement instruction
     C                   PARM                    DBFraSttmt
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM                    CrPayStmt
      ** Screen receipt settlement instruction
     C                   PARM                    CrRecStmt
      ** Screen FRA/IRS settlement instruction
     C                   PARM                    CrFRAStmt
     C                   PARM      STCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG6377
      *  SrINFDCVT  - Conversion of calculated interest fix dates     *                      BUG6377
      *****************************************************************                      BUG6377
     C     SrINFDCVT     BEGSR                                                               BUG6377
                                                                                             BUG6377
     C     RXUINFD       IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  RXUINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE            7                         BUG6377
     C                   MOVEL     ZDATE         SUINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C     RXTINFD       IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  RXTINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE                                      BUG6377
     C                   MOVEL     ZDATE         STINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C                   ENDSR                                                               BUG6377
      *****************************************************************
      ***SrUpFront - Convert Up-front fields                          *                      BUG6544
      *****************************************************************                      BUG6544
     C*****SrUpFront     BEGSR                                                               BUG6544
      **********                                                                             BUG6544
      ***Convert dates to MMDDYY or DDMMYY                                                   BUG6544
      **********                                                                             BUG6544
     C**********         IF        AGDFF = 'M'                                               BUG6544
     C**********         EVAL      *IN98 = *ON                                               BUG6544
     C**********         ELSE                                                                BUG6544
     C**********         EVAL      *IN98 = *OFF                                              BUG6544
     C**********         ENDIF                                                               BUG6544
      **********                                                                             BUG6544
      ***Format*the amounts using the currency decimal places                                BUG6544
      **********                                                                             BUG6544
     C**********         CALL      'AOCURRR0'                                                BUG6544
     C**********         PARM      *BLANKS       @RTCD                                       BUG6544
     C**********         PARM      '*FIRST'      @OPTN                                       BUG6544
     C**********         PARM      #1UCUC        @CYCD             3                         BUG6544
     C*****SDCURR        PARM      SDCURR        DSSDY                                       BUG6544
      **********                                                                             BUG6544
     C**********         Z-ADD     A6NBDP        WUCDP                                       BUG6544
     C**********         Z-ADD     A6NBDP        WTCDP                                       BUG6544
      **********                                                                             BUG6544
      ***Up-Front Fee details                                                                BUG6544
      **********                                                                             BUG6544
     C**********         IF        #1UPVD <> *ZEROS                                          BUG6544
      **********                                                                             BUG6544
     C**********         EVAL      WQ0001 = #1UPVD                                           BUG6544
     C**********         EXSR      SRDate2                                                   BUG6544
     C**********         MOVEL     ZDATE         SUFVD                                       BUG6544
      **********                                                                             BUG6544
     C**********         IF        #1UPPR = 'P'                                              BUG6544
     C**********         Z-ADD     WUCDP         WUPDP                                       BUG6544
     C**********         ELSE                                                                BUG6544
     C**********         Z-ADD     WTCDP         WUPDP                                       BUG6544
     C**********         ENDIF                                                               BUG6544
     C**********         EVAL      SUFPR = #1UPPR                                            BUG6544
      **********                                                                             BUG6544
     C**********         Z-ADD     #1UPFE        ZFLD15                                      BUG6544
     C**********         Z-ADD     WUPDP         ZDECS                                       BUG6544
     C**********         MOVE      *BLANK        ZECODE                                      BUG6544
     C**********         MOVE      *BLANK        ZOUT21                                      BUG6544
      **********                                                                             BUG6544
     C**********         CALLB     'ZSEDITF'                                                 BUG6544
     C**********         PARM                    ZFLD15                                      BUG6544
     C**********         PARM                    ZDECS                                       BUG6544
     C**********         PARM                    ZECODE                                      BUG6544
     C**********         PARM                    ZECHAR                                      BUG6544
     C**********         PARM                    ZOUT21                                      BUG6544
     C**********         MOVE      ZOUT21        SUFEE                                       BUG6544
      **********                                                                             BUG6544
     C**********         ENDIF                                                               BUG6544
      **********                                                                             BUG6544
      ***Buy-Out details                                                                     BUG6544
      **********                                                                             BUG6544
     C**********         IF        #1BOVD <> *ZEROS                                          BUG6544
      **********                                                                             BUG6544
     C**********         EVAL      WQ0001 = #1BOVD                                           BUG6544
     C**********         EXSR      SRDate2                                                   BUG6544
     C**********         MOVEL     ZDATE         SBOVD                                       BUG6544
      **********                                                                             BUG6544
     C**********         IF        #1BAPR = 'P'                                              BUG6544
     C**********         Z-ADD     WUCDP         WBODP                                       BUG6544
     C**********         ELSE                                                                BUG6544
     C**********         Z-ADD     WTCDP         WBODP                                       BUG6544
     C**********         ENDIF                                                               BUG6544
     C**********         EVAL      SBOPR = #1BAPR                                            BUG6544
      **********                                                                             BUG6544
     C**********         Z-ADD     #1BOAM        ZFLD15                                      BUG6544
     C**********         Z-ADD     WBODP         ZDECS                                       BUG6544
     C**********         MOVE      *BLANK        ZECODE                                      BUG6544
     C**********         MOVE      *BLANK        ZOUT21                                      BUG6544
      **********                                                                             BUG6544
     C**********         CALLB     'ZSEDITF'                                                 BUG6544
     C**********         PARM                    ZFLD15                                      BUG6544
     C**********         PARM                    ZDECS                                       BUG6544
     C**********         PARM                    ZECODE                                      BUG6544
     C**********         PARM                    ZECHAR                                      BUG6544
     C**********         PARM                    ZOUT21                                      BUG6544
      **********                                                                             BUG6544
     C**********         MOVE      ZOUT21        SBUYA                                       BUG6544
      **********                                                                             BUG6544
     C**********         ENDIF                                                               BUG6544
      **********                                                                             BUG6544
      ***Our*Next principal change date                                                      BUG6544
      **********                                                                             BUG6544
     C**********         EVAL      WQ0001 = #1UNPC                                           BUG6544
     C**********         IF        WQ0001 <> *ZEROS                                          BUG6544
     C**********         EXSR      SRDate2                                                   BUG6544
     C**********         MOVEL     ZDATE         SONPCD                                      BUG6544
     C**********         ENDIF                                                               BUG6544
      **********                                                                             BUG6544
      ***Their*Next principal change date                                                    BUG6544
      **********                                                                             BUG6544
     C**********         EVAL      WQ0001 = #1TNPC                                           BUG6544
     C**********         IF        WQ0001 <> *ZEROS                                          BUG6544
     C**********         EXSR      SRDate2                                                   BUG6544
     C**********         MOVEL     ZDATE         STNPCD                                      BUG6544
     C**********         ENDIF                                                               BUG6544
      **********                                                                             BUG6544
      ***Our*Interest processing method                                                      BUG6544
      **********                                                                             BUG6544
     C**********         EVAL      SOIPM = #1UINP                                            BUG6544
      **********                                                                             BUG6544
      ***Their*Interest processing method                                                    BUG6544
      **********                                                                             BUG6544
     C**********         EVAL      STIPM = #1TINP                                            BUG6544
      **********                                                                             BUG6544
     C*****ESrUpFront    ENDSR                                                               BUG6544
      *****************************************************************
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      *  RetrieveIC - Retrieve IC dates                               *                      BUG5449
      *****************************************************************                      BUG5449
     C     RetrieveIC    BEGSR                                                               BUG5449
     C                   MOVEL     SDLNO         DealNo                                      BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
                                                                                             BUG5449
      ** Our rate change date Schedule                                                       BUG5449
     C*****SUICFR        IFEQ      'Z'                                               BUG5449 BUG7621
     C                   EVAL      RatPay = 'R'                                              BUG5449
     C                   EVAL      OTInd = 'U'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KDTSC         SETLL     DLDTSCD0                                                  BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      DSCHOL = COHO                                             BUG5449
     C                   EVAL      DSPDAT = DTPR                                             BUG5449
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         DSDATE                                      BUG5449
     C                   EVAL      ORDATEA(X) = DATESCH                                      BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7621
                                                                                             BUG5449
      ** Our Interest Payment dates                                                          BUG5449
     C*****SUIPFR        IFEQ      'Z'                                               BUG5449 BUG7621
     C                   EVAL      RatPay = 'P'                                              BUG5449
     C                   EVAL      OTInd = 'U'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KDTSC         SETLL     DLDTSCD0                                                  BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      DSCHOL = COHO                                             BUG5449
     C                   EVAL      DSPDAT = DTPR                                             BUG5449
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         DSDATE                                      BUG5449
     C                   EVAL      OPDATEA(X) = DATESCH                                      BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7621
                                                                                             BUG5449
      ** Their rate change date Schedule                                                     BUG5449
     C*****STICFR        IFEQ      'Z'                                               BUG5449 BUG7621
     C                   EVAL      RatPay = 'R'                                              BUG5449
     C                   EVAL      OTInd = 'T'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KDTSC         SETLL     DLDTSCD0                                                  BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      DSCHOL = COHO                                             BUG5449
     C                   EVAL      DSPDAT = DTPR                                             BUG5449
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         DSDATE                                      BUG5449
     C                   EVAL      TRDATEA(X) = DATESCH                                      BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7621
                                                                                             BUG5449
      ** Their Interest Payment dates                                                        BUG5449
     C*****STIPFR        IFEQ      'Z'                                               BUG5449 BUG7621
     C                   EVAL      RatPay = 'P'                                              BUG5449
     C                   EVAL      OTInd = 'T'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KDTSC         SETLL     DLDTSCD0                                                  BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      DSCHOL = COHO                                             BUG5449
     C                   EVAL      DSPDAT = DTPR                                             BUG5449
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         DSDATE                                      BUG5449
     C                   EVAL      TPDATEA(X) = DATESCH                                      BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KDTSCP        READE     DLDTSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7621
                                                                                             BUG5449
      ** Our cash flow                                                                       BUG5449
     C*****SUIPFR        IFEQ      'C'                                               BUG5449 BUG7621
     C                   EVAL      OTInd = 'U'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KCFSC         SETLL     DLCFSCD0                                                  BUG5449
     C     KCFSCP        READE     DLCFSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      CFCHOL = COHO                                             BUG5449
     C                   EVAL      CFPDAT = DTPR                                             BUG5449
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         CFDATE                                      BUG5449
     C**********         EVAL      PZFIELD = *BLANK                                   BUG5449 245692
     C**********         MOVE      CFLA          PZFIELD                              BUG5449 245692
     C**********         EVAL      PZADEC = WPNBDP                                   BUG5449 BUG6419
     C**********         EVAL      PZADEC = WONBDP                                    BUG5449 245692
     C**********         EXSR      SRZEdit                                            BUG5449 245692
     C                   Z-ADD     CFLA          WAMT                                         245692
     C                   MOVE      WAMT          ZFLD15                                       245692
     C                   Z-ADD     21            @@CRET                                       245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM      WONBDP        @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
     C                   MOVE      ZOUT21        CFAMT                                        245692
     C**********         MOVE      PZFIELD       CFAMT                                BUG5449 245692
     C                   EVAL      OCFSA(X) = CASHFSCH                                       BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KCFSCP        READE     DLCFSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7621
                                                                                             BUG5449
      ** Their cash flow                                                                     BUG5449
     C*****STIPFR        IFEQ      'C'                                               BUG5449 BUG7621
     C                   EVAL      OTInd = 'T'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KCFSC         SETLL     DLCFSCD0                                                  BUG5449
     C     KCFSCP        READE     DLCFSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      CFCHOL = COHO                                             BUG5449
     C                   EVAL      CFPDAT = DTPR                                             BUG5449
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         CFDATE                                      BUG5449
     C**********         EVAL      PZFIELD = *BLANK                                   BUG5449 245692
     C**********         MOVE      CFLA          PZFIELD                              BUG5449 245692
     C**********         EVAL      PZADEC = WRNBDP                                   BUG5449 BUG6419
     C**********         EVAL      PZADEC = WTNBDP                                    BUG6419 245692
     C**********         EXSR      SRZEdit                                            BUG5449 245692
     C                   Z-ADD     CFLA          WAMT                                         245692
     C                   MOVE      WAMT          ZFLD15                                       245692
     C                   Z-ADD     21            @@CRET                                       245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C**********         PARM      WONBDP        @@CDP             1 0              245692 AR1014449
     C                   PARM      WTNBDP        @@CDP             1 0                     AR1014449
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
     C                   MOVE      ZOUT21        CFAMT                                        245692
     C**********         MOVE      PZFIELD       CFAMT                                BUG5449 245692
     C                   EVAL      TCFSA(X) = CASHFSCH                                       BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KCFSCP        READE     DLCFSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7621
                                                                                             BUG5449
      ** Our Principle change                                                                BUG5449
     C*****SONPCD        IFNE      *BLANKS                                           BUG5449 BUG7046
     C                   EVAL      OTInd = 'U'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KCFSC         SETLL     DLPCSCD0                                                  BUG5449
     C     KCFSCP        READE     DLPCSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      PCCHOL = COHO                                             BUG5449
     C                   EVAL      PCPDAT = DTPR                                             BUG5449
     C                   Z-ADD     0             WAMT             15 0                       BUG5449
                                                                                BUG6233
     C**********         IF        BGN2ST = 'Y'                                     BUG6233 MD054117
     C                   IF        PCIDCF = 'Y'                                             MD054117
     C                   IF        CAMT > 0                                                  BUG5449
     C                   EVAL      PCIDFLG = 'I'                                             BUG5449
     C                   Z-ADD     CAMT          WAMT                                        BUG5449
     C                   ELSE                                                                BUG5449
     C                   IF        CAMT < 0                                                  BUG5449
     C                   EVAL      PCIDFLG = 'D'                                             BUG5449
     C                   Z-SUB     CAMT          WAMT                                        BUG5449
     C                   ELSE                                                                BUG5449
     C                   EVAL      PCIDFLG = ' '                                             BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ELSE                                                   BUG6233
     C                   Z-ADD     PAMT          WAMT                           BUG6233
     C                   ENDIF                                                  BUG6233
                                                                                BUG6233
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         PCDATE                                      BUG5449
     C                   MOVE      WAMT          ZFLD15                                      BUG5449
     C                   Z-ADD     21            @@CRET                                       245692
     C**********         CALLB     'ZSEDITF'                                          BUG5449 245692
     C**********         PARM                    ZFLD15                               BUG5449 245692
     C**********         PARM      WONBDP        ZDECS                                BUG5449 245692
     C**********         PARM      *BLANKS       ZECODE                               BUG5449 245692
     C**********         PARM                    ZECHAR                               BUG5449 245692
     C**********         PARM      *BLANKS       ZOUT21                               BUG5449 245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM      WONBDP        @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
                                                                                             BUG5449
     C                   MOVE      ZOUT21        PCAMT                                       BUG5449
     C                   EVAL      OPCSA(X) = PCHGSCH                                        BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KCFSCP        READE     DLPCSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7046
      ** Their Principle change                                                              BUG5449
     C*****STNPCD        IFNE      *BLANKS                                           BUG5449 BUG7046
     C                   EVAL      OTInd = 'T'                                               BUG5449
     C                   EVAL      ProcDate = 0                                              BUG5449
     C                   EVAL      X = 1                                                     BUG5449
     C     KCFSC         SETLL     DLPCSCD0                                                  BUG5449
     C     KCFSCP        READE     DLPCSCD0                               99                 BUG5449
     C                   DOW       *IN99 = *OFF                                              BUG5449
     C                   EVAL      PCCHOL = COHO                                             BUG5449
     C                   EVAL      PCPDAT = DTPR                                             BUG5449
     C                   Z-ADD     0             WAMT             15 0                       BUG5449
                                                                                BUG6233
     C**********         IF        BGN2ST = 'Y'                                     BUG6233 MD054117
     C                   IF        PCIDCF = 'Y'                                             MD054117
     C                   IF        CAMT > 0                                                  BUG5449
     C                   EVAL      PCIDFLG = 'I'                                             BUG5449
     C                   Z-ADD     CAMT          WAMT                                        BUG5449
     C                   ELSE                                                                BUG5449
     C                   IF        CAMT < 0                                                  BUG5449
     C                   EVAL      PCIDFLG = 'D'                                             BUG5449
     C                   Z-SUB     CAMT          WAMT                                        BUG5449
     C                   ELSE                                                                BUG5449
     C                   EVAL      PCIDFLG = ' '                                             BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ELSE                                                   BUG6233
     C                   Z-ADD     PAMT          WAMT                           BUG6233
     C                   ENDIF                                                  BUG6233
                                                                                BUG6233
     C                   EVAL      WQ0001 = PRDT                                             BUG5449
     C                   EXSR      SRDate2                                                   BUG5449
     C                   MOVEL     ZDATE         PCDATE                                      BUG5449
     C                   MOVE      WAMT          ZFLD15                                      BUG5449
     C                   Z-ADD     21            @@CRET                                       245692
     C**********         CALLB     'ZSEDITF'                                          BUG5449 245692
     C**********         PARM                    ZFLD15                               BUG5449 245692
     C**********         PARM      WONBDP        ZDECS                               BUG5449 BUG7620
     C**********         PARM      WTNBDP        ZDECS                                BUG7620 245692
     C**********         PARM      *BLANKS       ZECODE                               BUG5449 245692
     C**********         PARM                    ZECHAR                               BUG5449 245692
     C**********         PARM      *BLANKS       ZOUT21                               BUG5449 245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C**********         PARM      WONBDP        @@CDP             1 0              245692 AR1014449
     C                   PARM      WTNBDP        @@CDP             1 0                     AR1014449
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
                                                                                             BUG5449
     C                   MOVE      ZOUT21        PCAMT                                       BUG5449
     C                   EVAL      TPCSA(X) = PCHGSCH                                        BUG5449
     C                   ADD       1             X                                           BUG5449
     C     KCFSCP        READE     DLPCSCD0                               99                 BUG5449
     C                   ENDDO                                                               BUG5449
     C**********         ENDIF                                                       BUG5449 BUG7046
     C                   ENDSR                                                               BUG5449
      *****************************************************************                      BUG5449
      * CheckCurr - Routine to access currency details                *                      BUG5449
      *****************************************************************                      BUG5449
     C     CheckCurr     BEGSR                                                               BUG5449
                                                                                             BUG5449
      ** For 'Our' Currency                                                                  BUG6419
      ** Access currency details to get the number of decimal places                         BUG5449
     C                   CALL      'AOCURRR0'                                                BUG5449
     C                   PARM      *BLANKS       @RTCD                                       BUG5449
     C                   PARM      '*KEY   '     @OPTN                                       BUG5449
     C**********         PARM      SUCUCY        @CYCD                               BUG5449 BUG6544
     C                   PARM      SUCUCY        @CYCD             3                         BUG6544
     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG5449
                                                                                             BUG5449
     C                   MOVE      A6NBDP        WONBDP                                      BUG5449
                                                                                             BUG6419
      ** For 'Their' Currency                                                                BUG6419
      ** Access currency details to get the number of decimal places                         BUG6419
     C                   CALL      'AOCURRR0'                                                BUG6419
     C                   PARM      *BLANKS       @RTCD                                       BUG6419
     C                   PARM      '*KEY   '     @OPTN                                       BUG6419
     C                   PARM      STCUCY        @CYCD             3                         BUG6419
     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG6419
                                                                                             BUG6419
     C                   MOVE      A6NBDP        WTNBDP                                      BUG6419
      ***********                                                                    BUG5449 BUG6419
      ***Get*decimal places for settlement currencies, if used                       BUG5449 BUG6419
      **********                                                                     BUG5449 BUG6419
     C*****DDPSCY        IFNE      *BLANK                                            BUG5449 BUG6419
     C**********         CALL      'AOCURRR0'                                        BUG5449 BUG6419
     C**********         PARM      *BLANKS       @RTCD                               BUG5449 BUG6419
     C**********         PARM      '*KEY   '     @OPTN                               BUG5449 BUG6419
     C**********         PARM      DDPSCY        @CYCD                               BUG5449 BUG6419
     C*****SDCURR        PARM      SDCURR        DSSDY                               BUG5449 BUG6419
      **********                                                                     BUG5449 BUG6419
     C**********         MOVE      A6NBDP        WPNBDP                              BUG5449 BUG6419
     C**********         MOVE      DDPSCY        WPSCY                               BUG5449 BUG6419
     C**********         ELSE                                                        BUG5449 BUG6419
     C**********         MOVE      SUCUCY        WPSCY                               BUG5449 BUG6419
     C**********         MOVE      WONBDP        WPNBDP                              BUG5449 BUG6419
     C**********         ENDIF                                                       BUG5449 BUG6419
      **********                                                                     BUG5449 BUG6419
     C*****DDRSCY        IFNE      *BLANK                                            BUG5449 BUG6419
     C**********         CALL      'AOCURRR0'                                        BUG5449 BUG6419
     C**********         PARM      *BLANKS       @RTCD                               BUG5449 BUG6419
     C**********         PARM      '*KEY   '     @OPTN                               BUG5449 BUG6419
     C**********         PARM      DDRSCY        @CYCD                               BUG5449 BUG6419
     C*****SDCURR        PARM      SDCURR        DSSDY                               BUG5449 BUG6419
     C**********         MOVE      A6NBDP        WRNBDP                              BUG5449 BUG6419
     C**********         MOVE      DDRSCY        WRSCY                               BUG5449 BUG6419
     C**********         ELSE                                                        BUG5449 BUG6419
     C**********         MOVE      SUCUCY        WRSCY                               BUG5449 BUG6419
     C**********         MOVE      WONBDP        WRNBDP                              BUG5449 BUG6419
     C**********         ENDIF                                                       BUG5449 BUG6419
      *                                                                              BUG5449 BUG6419
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      ********************************************************************                   BUG5449
      *                                                                  *                   BUG5449
      * SRZEdit - Call to ZEDIT module                                   *                   BUG5449
      *                                                                  *                   BUG5449
      ********************************************************************                   BUG5449
                                                                                             BUG5449
     C     SRZEdit       BEGSR                                                               BUG5449
                                                                                             BUG5449
     C                   CALLB     'ZEDIT'                                                   BUG5449
     C                   PARM                    PZFIELD                                     BUG5449
     C                   PARM                    PZADEC                                      BUG5449
                                                                                             BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT
      *****************************************************************
      *  SRDate2 - Convert date using ZDATE2                          *
      *****************************************************************
     C     SRDate2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    WQ0001            5 0
     C**********         PARM                    ZDATFM            1                         BUG7784
     C                   PARM                    BJDFIN                                      BUG7784
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_IN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG5449
     C                   PARM                    BufferEx2                                   BUG5449
     C                   PARM                    BufferEx3                                   BUG5449
     C                   PARM                    BufferEx4                                   BUG5449
     C                   PARM                    BufferEx5                                   BUG5449
     C                   PARM                    BufferEx6                                   BUG5449
     C                   PARM                    BufferEx7                                   BUG5449
     C                   PARM                    BufferEx8                                   BUG5449
     C                   PARM                    BufferEx9                                   BUG5449
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
     C                   PARM                    ACTRJ                                      MD054906
      * Set up the names of the message files from which the
      * message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,IRCIRSM01
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      **  Check if Additional Pay/Receive Messages for Principal
      **  Exchanges on Cross-Currency IRS is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR003'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR003 = 'Y'
     C                   ELSE
     C                   EVAL      CIR003 = 'N'
     C                   ENDIF
 
      **  Check if FRA/IRS Deals Authorisation is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR008'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF
 
      ** Check if IRS Fees/Buy-Outs, etc. is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP041'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CAP041 = 'Y'
     C                   ELSE
     C                   EVAL      CAP041 = 'N'
     C                   ENDIF
 
      ** Check if Interest Rate Calendars is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR001 = 'Y'
     C                   ELSE
     C                   EVAL      CIR001 = 'N'
     C                   ENDIF
 
      ** Check if CIR002 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR002'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR002 = 'Y'
     C                   ELSE
     C                   EVAL      CIR002 = 'N'
     C                   ENDIF
 
      ** Check if FRA/IRS Amortisation of Caps, Collars, Floors...is on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR006'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
                                                                                             BUG5291
      ** Check if enhancement CLE025 (Credit Lines) is on                                    BUG5291
                                                                                             BUG5291
     C                   CALL      'AOSARDR0'                                                BUG5291
     C                   PARM      *BLANKS       PRtCd                                       BUG5291
     C                   PARM      '*VERIFY'     POptn                                       BUG5291
     C                   PARM      'CLE025'      PSarD                                       BUG5291
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5291
                                                                                             BUG5291
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                   BUG5291
     C     *LOCK         IN        LDA                                                       BUG5291
     C                   EVAL      DBKEY = 'CLE025'                                          BUG5291
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG5291
     C                   EVAL      DBASE = 007                                               BUG5291
     C                   OUT       LDA                                                       BUG5291
     C                   EXSR      *PSSR                                                     BUG5291
     C                   ENDIF                                                               BUG5291
                                                                                             BUG5291
     C                   IF        PRtCd = *BLANKS                                           BUG5291
     C                   EVAL      CLE025 = 'Y'                                              BUG5291
     C                   ELSE                                                                BUG5291
     C                   EVAL      CLE025 = 'N'                                              BUG5291
     C                   ENDIF                                                               BUG5291
      ** Access Bank Details                                                                 BUG6377
                                                                                             BUG6377
     C                   CALLB     'AOBANKR0'                                                BUG6377
     C                   PARM      *BLANKS       ReturnCode                                  BUG6377
     C                   PARM      '*FIRST '     POptn                                       BUG6377
     C     SDBANK        PARM      SDBANK        DSFDY                                       BUG6377
                                                                                             BUG6377
     C                   IF        ReturnCode <> *BLANK                                      BUG6377
     C     *LOCK         IN        LDA                                                       BUG6377
     C                   EVAL      DBFILE = 'SDBANKPD'                                       BUG6377
     C                   EVAL      DBASE  = 8                                                BUG6377
     C                   EVAL      DBKEY  = POptn                                            BUG6377
     C                   OUT       LDA                                                       BUG6377
     C                   EXSR      *PSSR                                                     BUG6377
     C                   ENDIF                                                               BUG6377
      *                                                                                      BUG6377
      *                                                                         BUG6233
      ** Access Module Details                                                  BUG6233
      *                                                                         BUG6233
     C                   CALL      'AOMMODR0'                                   BUG6233
     C                   PARM      *BLANKS       @RTCD                          BUG6233
     C                   PARM      '*FIRST '     @OPTN                          BUG6233
     C     SDMMOD        PARM      SDMMOD        DSFDY                          BUG6233
                                                                                BUG6233
      ** Access Dealing Details                                                               245692
      ** (database error handling done in access program)                                     245692
      *                                                                                       245692
     C                   CALLB     'AODEALR1'                                                 245692
     C                   PARM      *BLANKS       ReturnCode                                   245692
     C                   PARM      '*FIRST '     POptn                                        245692
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        245692
      *                                                                                       245692
     C                   IF        ReturnCode <> *BLANK                                       245692
     C     *LOCK         IN        LDA                                                        245692
     C                   EVAL      DBFILE = 'SDDEALPD'                                        245692
     C                   EVAL      DBASE  = 9                                                 245692
     C                   EVAL      DBKEY  = POptn                                             245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
      **  Key for DLDTSCPD                                                                   BUG5449
     C     KDTSC         KLIST                                                               BUG5449
     C                   KFLD                    DealNo                                      BUG5449
     C                   KFLD                    OTInd                                       BUG5449
     C                   KFLD                    RatPay                                      BUG5449
     C                   KFLD                    ProcDate                                    BUG5449
      **  Partial Key for DLDTSCPD                                                           BUG5449
     C     KDTSCP        KLIST                                                               BUG5449
     C                   KFLD                    DealNo                                      BUG5449
     C                   KFLD                    OTInd                                       BUG5449
     C                   KFLD                    RatPay                                      BUG5449
      **  Key for DLCFSCPD/DLPCSCPD                                                          BUG5449
     C     KCFSC         KLIST                                                               BUG5449
     C                   KFLD                    DealNo                                      BUG5449
     C                   KFLD                    OTInd                                       BUG5449
     C                   KFLD                    ProcDate                                    BUG5449
      **  Partial Key for DLCFSCPD/DLPCSCPD                                                  BUG5449
     C     KCFSCP        KLIST                                                               BUG5449
     C                   KFLD                    DealNo                                      BUG5449
     C                   KFLD                    OTInd                                       BUG5449
      *                                                                                       CSW213
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
      *                                                                                       CSW213
     C                   IF        @RTCD = 'CSW2013'                                          CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
                                                                                            MD054117
     C                   CALL      'AOSVALR0'                                               MD054117
     C                   PARM      *BLANKS       PRETURN                                    MD054117
     C                   PARM      PSYSVAL1      POP01                                      MD054117
     C                   PARM      *BLANKS       PVL01                                      MD054117
     C                   PARM      *BLANKS       POP02                                      MD054117
     C                   PARM      *BLANKS       PVL02                                      MD054117
     C                   PARM      *BLANKS       POP03                                      MD054117
     C                   PARM      *BLANKS       PVL03                                      MD054117
     C                   PARM      *BLANKS       POP04                                      MD054117
     C                   PARM      *BLANKS       PVL04                                      MD054117
     C                   PARM      *BLANKS       POP05                                      MD054117
     C                   PARM      *BLANKS       PVL05                                      MD054117
     C                   PARM      *BLANKS       POP06                                      MD054117
     C                   PARM      *BLANKS       PVL06                                      MD054117
     C                   PARM      *BLANKS       POP07                                      MD054117
     C                   PARM      *BLANKS       PVL07                                      MD054117
     C                   PARM      *BLANKS       POP08                                      MD054117
     C                   PARM      *BLANKS       PVL08                                      MD054117
     C                   PARM      *BLANKS       POP09                                      MD054117
     C                   PARM      *BLANKS       PVL09                                      MD054117
     C                   PARM      *BLANKS       POP10                                      MD054117
     C                   PARM      *BLANKS       PVL10                                      MD054117
      *                                                                                     MD054117
     C                   EVAL      PCIDCF = 'N'                                             MD054117
     C                   IF        PRETURN <> *BLANKS                                       MD054117
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD054117
     C                   EVAL      DBKEY = PSYSVAL1                                         MD054117
     C                   EVAL      DBASE = 18                                               MD054117
     C                   OUT       LDA                                                      MD054117
     C                   EXSR      *PSSR                                                    MD054117
     C                   ENDIF                                                              MD054117
      *                                                                                     MD054117
     C                   MOVEL     PVL01         PCIDCF                                     MD054117
      *                                                                                     MD054117
 
     C                   ENDSR
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    SACCD             1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    SDLNO             6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    BRKC              4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      *****************************************************************
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      * SRGetRPIF - Set-up Midas DL Transaction Reporting Information *                       CSW213
      *             Link File.                                        *                       CSW213
      *****************************************************************                       CSW213
     C     SRGetRPIF     BEGSR                                                                CSW213
      *                                                                                       CSW213
      ** Set-up input fields                                                                  CSW213
      *                                                                                       CSW213
     C                   EVAL      PModeOp = ModeofOp                                         CSW213
                                                                                              CSW213
     C                   IF        SACCD = 'R'                                                CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = SACCD                                             CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLAPID = 'CIRS'                                            CSW213
     C                   EVAL      RLDTYP = SDTYP                                             CSW213
     C                   EVAL      RLDLST = SDLST                                             CSW213
      *                                                                                     MD044506
      ** Change RLVALD from Value Date to Deal Date                                         MD044506
      *                                                                                     MD044506
     C**********         EVAL      RLVALD = SVDAT                                    CSW213 MD044506
     C                   EVAL      RLVALD = SDDAT                                           MD044506
      *                                                                                     MD044506
     C                   EVAL      RLTRRF = SDLNO                                             CSW213
     C                   EVAL      RLFOID = FOTRID                                            CSW213
     C                   EVAL      RLLTRF = SLNKDN                                            CSW213
     C                   EVAL      RLBRCA = SBRCA                                             CSW213
     C                   EVAL      RLBCCY = SUCUCY                                            CSW213
     C                   EVAL      RLSCCY = STCUCY                                            CSW213
     C                   EVAL      RLCNUM = SCNUM                                             CSW213
     C                   CALL      'DLRPIFR'                                                  CSW213
                                                                                              CSW213
      ** Return code                                                                          CSW213
     C                   PARM      *BLANKS       PRetCode                                     CSW213
                                                                                              CSW213
      ** Mode of operation                                                                    CSW213
     C                   PARM                    PModeOp                                      CSW213
                                                                                              CSW213
      ** RPFI Set up fields                                                                   CSW213
     C                   PARM                    PDlRILkpd                                    CSW213
                                                                                              CSW213
      ** OUTPUTS                                                                              CSW213
                                                                                              CSW213
      ** Transaction Reference OK Flag                                                        CSW213
     C                   PARM                    PTranRefOK                                   CSW213
                                                                                              CSW213
      ** Front Office ID OK Flag                                                              CSW213
     C                   PARM                    DFOfcrIDOK                                   CSW213
                                                                                              CSW213
      ** No Report Information flag                                                           CSW213
     C                   PARM                    WNoRepFlag                                   CSW213
                                                                                              CSW213
      ** DLRPIF in File Format                                                                CSW213
     C                   PARM                    DLRPIFFileFmt                                CSW213
                                                                                              CSW213
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW213
     C                   PARM                    FldNameArr                                   CSW213
     C                   PARM                    MsgIdArr                                     CSW213
     C                   PARM                    MsgDtaArr                                    CSW213
                                                                                              CSW213
      ** Array index (3P0) from/to caller                                                     CSW213
     C                   PARM                    Idx                                          CSW213
                                                                                              CSW213
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CSW213
     C                   PARM                    WFldNamArr                                   CSW213
     C                   PARM                    WMsgIdArr                                    CSW213
     C                   PARM                    WMsgDtaArr                                   CSW213
                                                                                              CSW213
      ** Warning array index (3P0) from/to caller                                             CSW213
     C                   PARM                    WIdx                                         CSW213
                                                                                              CSW213
      ** Report Information File - Screen Format                                              CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
