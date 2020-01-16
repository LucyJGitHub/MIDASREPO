     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single Currency IRS Retrieval')               *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSIRSR - Single Currency IRS Retrieval                      *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054906           Date 15Jan20               *
      *  Prev Amend No. MD053400           Date 03Jul19               *
      *                 MD051249           Date 17Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044506           Date 28Mar17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD031775           Date 09Jan15               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CIR017             Date 10Apr14               *
      *                 245692             Date 11Dec13               *
      *                 CSW213             Date 03Jun13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239838             Date 21May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11343           Date 11May06               *
      *                 CIR014             Date 11May06               *
      *                 BUG10815R (Reopen) Date 27Apr06               *
      *                 BUG11254           Date 18Apr06               *
      *                 BUG10815           Date 09Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG9396            Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7784            Date 30Jun05               *
      *                 BUG7621            Date 17Jun05               *
      *                 BUG5871            Date 22May05               *
      *                 BUG6512            Date 18May05               *
      *                 BUG7046            Date 06May05               *
      *                 BUG6671            Date 26Apr05               *
      *                 BUG6472            Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG6544            Date 08Apr05               *
      *                 BUG6386            Date 23Mar05               *
      *                 BUG6233            Date 10Mar05               *
      *                 BUG5861            Date 14Feb05               *
      *                 BUG5357            Date 05Jan05               *
      *                 BUG4646            Date 25Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 222373             Date 31Oct03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054906 - CBS-2882 fix extenstion for Principal Change      *
      *             Schedule                                          *
      *           - Receive ACTRJ from IRSIRSVU to properly initialize*
      *             field for buffer                                  *
      *  MD053400 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Skip      *
      *             validation if action is Reject.                   *
      *  MD051249 - Set APIRetc to '0' after PSSR.                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044506 - MT300 98D trade execution date can not be before  *
      *             value date.                                       *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD031775 - Cannot insert transaction due to errors. Correct  *
      *             mapping to include CDL094 fields.                 *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSF011A- CCR015: Display Order in Confirmation Pages         *
      *  239838 - For Release 1.2 solution is to reverse out BUG9396  *
      *           which was collected in error. Annotated as BUG11343.*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11343 - Reverse out BUG9396.                              *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG10815R - Reverse RPG fix as error can be catered by JAVA  *
      *  BUG11254-Positions of the schedules on the buffer were not   *
      *           changed to cope with impact of CLE031 changes.      *
      *           Also CDL038 changes when rebuilding buffer is wrong *
      *  BUG10815 - Business Day Convetions details disappear         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG9396- Our/their pay/rate change dates incorrectly formatted
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7784 - Pass correct date format indicator to ZDATE2       *
      *  BUG7621 - Retrieve schedules even if related frequency is    *
      *            not 'Z' or 'C' in the case of cashflow schedules   *
      *  BUG5871- Send deal status to MidasPlus                       *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG7046- Retrieve principal change schedules even if         *
      *           next principal change date is blank                 *
      *  BUG6671- Implement Auto Authorisation                        *
      *  BUG6472- Added a sign field to short term rate               *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG6544- Fields converted in SrUpFront are done in CVT       *
      *  BUG5861- Serious Midas Error on edit of deal                 *
      *  BUG6386 - Principal Change schedules not showing for migrated*
      *            deals                                              *
      *  BUG6233- Principle change amount is 0 when plato is off      *
      *  BUG5357- Cash flow/principle change schedule formulae need   *
      *           additional fields                                   *
      *  BUG4646- Completion of SIRS api                              *
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
     FDLDTSCL0  IF   E           K DISK                                         BUG4646
     FDLPCSCL0  IF   E           K DISK                                         BUG4646
     FDLCFSCL0  IF   E           K DISK                                         BUG4646

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
      *  Array for Our rate change date Schedule                                BUG4646
     D ORDATEA         S              8A   DIM(600)                             BUG4646
     D ORDATEAST       S           4800A                                        BUG4646
      *  Array for Our interest payment date Schedule                           BUG4646
     D OPDATEA         S              8A   DIM(600)                             BUG4646
     D OPDATEAST       S           4800A                                        BUG4646
      *  Array for Their rate change date Schedule                              BUG4646
     D TRDATEA         S              8A   DIM(600)                             BUG4646
     D TRDATEAST       S           4800A                                        BUG4646
      *  Array for Their interest payment date Schedule                         BUG4646
     D TPDATEA         S              8A   DIM(600)                             BUG4646
     D TPDATEAST       S           4800A                                        BUG4646
      *  Date schedule                                                          BUG4646
     D DATESCH         DS                                                       BUG4646
     D  DSDATE                        6A                                        BUG4646
     D  DSCHOL                        1A                                        BUG4646
     D  DSPDAT                        1A                                        BUG4646
      *  Array for Our cash flow Schedule                                       BUG4646
     D OCFSA           S             22A   DIM(600)                             BUG4646
     D OCFSAST         S          13200A                                        BUG4646
      *  Array for Their cash flow Schedule                                     BUG4646
     D TCFSA           S             22A   DIM(600)                             BUG4646
     D TCFSAST         S          13200A                                        BUG4646
      *  Cash Flow schedule                                                     BUG4646
     D CASHFSCH        DS                                                       BUG4646
     D  CFDATE                        6A                                        BUG4646
     D  CFCHOL                        1A                                        BUG4646
     D  CFAMT                        14A                                        BUG4646
     D  CFPDAT                        1A                                        BUG4646
      *  Array for Principle change Schedule                                    BUG4646
     D PCSA            S             25A   DIM(600)                             BUG4646
     D PCSAST          S          15000A                                        BUG4646
      *  Principle Change Schedule                                              BUG4646
     D PCHGSCH         DS                                                       BUG4646
     D  PCDATE                        6A                                        BUG4646
     D  PCCHOL                        1A                                        BUG4646
     D  PCAMT                        16A                                        BUG4646
     D  PCIDFLG                       1A                                        BUG4646
     D  PCPDAT                        1A                                        BUG4646
      *  Date schedule formula for generating dates                             BUG4646
     D FORMULAOR       DS                                                       BUG4646
     D  SFREQFOR                      1A                                        BUG4646
     D  SFORMOR                       7A                                        BUG4646
     D FORMULAOP       DS                                                       BUG4646
     D  SFREQFOP                      1A                                        BUG4646
     D  SFORMOP                       7A                                        BUG4646
     D FORMULATR       DS                                                       BUG4646
     D  SFREQFTR                      1A                                        BUG4646
     D  SFORMTR                       7A                                        BUG4646
     D FORMULATP       DS                                                       BUG4646
     D  SFREQFTP                      1A                                        BUG4646
     D  SFORMTP                       7A                                        BUG4646
     D FORMULAOC       DS                                                       BUG4646
     D  SFREQFOC                      1A                                        BUG4646
     D  SFORMOC                       7A                                        BUG4646
     D  SFORMAMTOC                   14A                                        BUG5357
     D FORMULATC       DS                                                       BUG4646
     D  SFREQFTC                      1A                                        BUG4646
     D  SFORMTC                       7A                                        BUG4646
     D  SFORMAMTTC                   14A                                        BUG5357
     D FORMULAOPC      DS                                                       BUG4646
     D  SFREQFOPC                     1A                                        BUG4646
     D  SFORMOPC                      7A                                        BUG4646
     D  SFORMAMTOPC                  16A                                        BUG5357
     D  SFORMPIDFOPC                  1A                                        BUG5357
     D FORMULATPC      DS                                                       BUG4646
     D  SFREQFTPC                     1A                                        BUG4646
     D  SFORMTPC                      7A                                        BUG4646
     D  SFORMAMTTPC                  16A                                        BUG5357
     D  SFORMPIDFTPC                  1A                                        BUG5357

      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------

      ** Single Currency IRS deal
     D SIRSScnFmt    E DS                  EXTNAME(IRSIRSPD)
      ********************                                                      BUG4646
      ***Interest*Rate*Calendars (dummy)                                        BUG4646
     D*OurRatChgD****E*DS*                 EXTNAME(IRDTSCPD)                    BUG4646
     D********************                 PREFIX(OR_)                          BUG4646
     D*OurIntPayD****E*DS*                 EXTNAME(IRDTSCPD)                    BUG4646
     D********************                 PREFIX(OI_)                          BUG4646
     D*ThrRatChgD****E*DS*                 EXTNAME(IRDTSCPD)                    BUG4646
     D********************                 PREFIX(TR_)                          BUG4646
     D*ThrIntPayD****E*DS*                 EXTNAME(IRDTSCPD)                    BUG4646
     D********************                 PREFIX(TI_)                          BUG4646

      ** Receive Settlement Instructions
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)

      ** Pay Settlement Instructions
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)

      ** FRA/IRS Settlement Instructions
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)

      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------

      ** Single Currency IRS deal
     D SIRSFilFmt    E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(RS)
     D SIRSRecIns            716    784
     D SIRSPayIns            785   1343
     D SIRSFraIns           1345   1992
                                                                                BUG4646
     D DealXFilFmt   E DS                  EXTNAME(DLDLDGQD)                    BUG4646
      ** Deal Extension File Format                                             BUG4646

      ** Receive Settlement Instructions
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D   FLREC                 1     69

      ** Pay Settlement Instructions
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D   FLPAY                 1    559

      ** FRA/IRS Settlement Instructions
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
                                                                                             BUG6671
      ** FRA/IRS Interface Non-Screen Data                                                   BUG6671
     D InfData       E DS                  EXTNAME(IRRSIFPD)                                 BUG6671
                                                                                             BUG6671
     D ExtData       E DS                  EXTNAME(IRSSEXPD)                                 BUG6671
      * IR Cross Ccy IRS Extra Data - File (D/B) format                                      BUG6671

      **-----------------------------------------------------------------------
      ** Others
      **-----------------------------------------------------------------------

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Midas Modules Details Accessed via access program                                   BUG6233
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 BUG6233
      ** External DS for Bank Details                                                        BUG6377
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 BUG6377
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
                                                                                              245692
      ** External DS for Dealing Details                                                      245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692

     D/COPY QWINDSRC,IRSIRSGDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Entry parameters
     D AuthComp        S              1A
     D FwdBck          S              1A
     D DDDLNO_In       S              6A
     D Buffer          S           6000A
     D Buffer2         S           3999                                         BUG4646
     D BufferEx2       S           9999                                         BUG4646
     D BufferEx3       S           9999                                         BUG4646
     D BufferEx4       S           9999                                         BUG4646
     D BufferEx5       S           9999                                         BUG4646
     D BufferEx6       S           9999                                         BUG4646
     D BufferEx7       S           9999                                         BUG4646
     D BufferEx8       S           9999                                         BUG4646
     D BufferEx9       S           9999                                         BUG4646
     D APIRetc         S              1A

     D ModeOfOp        S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMs          S              7A
     D PDlNoR          S              6A
     D**********PDlSts          S             24A                                            BUG5871
     D DDSTS           S             24A                                                     BUG5871

     D RespMode        S              1A
     D FOTRID          S             20A
     D FOASID          S             20A
     D OKACTN          S              1A
     D OKDLNO          S              1A
     D OKBRCA          S              1A

     D CAP041          S              1A
     D CIR001          S              1A
     D CIR002          S              1A
     D CIR006          S              1A
     D CIR008          S              1A

     D WDlRed          S              6A
     D WUCDP           S              1P 0
     D WTCDP           S              1P 0
     D WUPDP           S              1P 0
     D WBODP           S              1P 0

     D I#SDLNO         S                   LIKE(SDLNO) INZ(*BLANKS)

     D ZFLD15          S             15P 0
     D ZDECS           S              1P 0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21

     D DealNo          S              6  0                                      BUG4646
     D OTInd           S              1                                         BUG4646
     D RatPay          S              1                                         BUG4646
     D ProcDate        S              5  0                                      BUG4646
      ** Array index                                                            BUG4646
     D X               S              3  0                                      BUG4646
     D WONBDP          S                   LIKE(A6NBDP)                         BUG4646
     D WPNBDP          S                   LIKE(A6NBDP)                         BUG4646
     D WRNBDP          S                   LIKE(A6NBDP)                         BUG4646
     D WRSCY           S              3A                                        BUG4646
     D WPSCY           S              3A                                        BUG4646
     D PZFIELD         S             16A                                        BUG4646
     D PZADEC          S              1  0                                      BUG4646
     D ZDATE           S              6  0                                                   BUG6377
     D ZDAYNO          S              5P 0                                                   BUG6377
     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
                                                                                             CSF011A
      ** for Transaction Currencies (Receipt and Payment Currency)                           CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** Work Variables for DLRPIFR                                                           CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
                                                                                              CSW213
     D CSW213          S              1                                                       CSW213
      ** Action Code Reject                                                                 MD053400
     D ACTRJ           S              1                                                     MD053400
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

     C                   CLEAR                   SIRSFilFmt
     C                   CLEAR                   PDlRILkpd                                    CSW213
     C****************** CLEAR                   OurRatChgD                     BUG4646
     C****************** CLEAR                   OurIntPayD                     BUG4646
     C****************** CLEAR                   ThrRatChgD                     BUG4646
     C****************** CLEAR                   ThrIntPayD                     BUG4646
     C                   CLEAR                   ORDATEA                        BUG4646
     C                   CLEAR                   OPDATEA                        BUG4646
     C                   CLEAR                   TRDATEA                        BUG4646
     C                   CLEAR                   TPDATEA                        BUG4646
     C                   CLEAR                   OCFSA                          BUG4646
     C                   CLEAR                   TCFSA                          BUG4646
     C                   CLEAR                   PCSA                           BUG4646

     C                   IF        SACCD = *BLANKS
     C                   IF        AuthComp = 'X'
     C                   EVAL      SACCD = 'X'
     C                   ELSE
     C                   EVAL      SACCD = 'E'
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      PRdFwd = 'N'
     C                   EVAL      PRdBck = 'N'
     C                   IF        FwdBck = 'F'
     C                   EVAL      PRdFwd = 'Y'
     C                   ELSE
     C                   IF        FwdBck = 'B'
     C                   EVAL      PRdBck = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        PRdFwd = 'Y' OR PRdBck = 'Y'
     C                   EXSR      SrSIRSRED
     C                   ELSE
     C                   EVAL      WDlRed = DDDLNO_In
     C                   EVAL      PErrMs = *BLANKS
     C                   ENDIF

      ** If Single-ccy IRS read and no error message returned,
      ** retrieve deal details and convert to screen format

     C                   IF        PErrMs = *BLANKS AND
     C                             WDlRed <> *BLANKS

     C                   EVAL      SDLNO = WDlRed
     C                   EXSR      SrSIRSRTV

                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
                                                                                             BUG6512
     C                   IF        CAP041 = 'Y' AND Idx = *ZERO
     C/COPY QWINDSRC,IRSIRSMOV1
     C                   ENDIF

     C                   IF        Idx = *ZERO
     C                   EXSR      SrSIRSCVT
     C                   EXSR      SrSETINCVT
      * Calculated Our/Their interest fix dates                                              BUG6377
     C                   EXSR      SrINFDCVT                                                 BUG6377
     C**********         IF        CAP041 = 'Y'                                      BUG5861 BUG6544
     C**********         EXSR      SrUpFront                                                 BUG6544
     C**********         ENDIF                                                       BUG5861 BUG6544
     C                   ENDIF

     C                   ENDIF

     C                   IF        PErrMs <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO'
     C                   EVAL      MsgIDArr(Idx) = PErrMs
     C                   ENDIF
                                                                                BUG4646
      ** If IRCs on in system and no previous errors retrieve IRC dates         BUG4646
                                                                                BUG4646
     C     CIR001        IFEQ      'Y'                                          BUG4646
     C*****Idx           ANDEQ     0                                            BUG4646      BUG7621
     C                   EXSR      RetrieveIC                                   BUG4646
     C                   ENDIF                                                  BUG4646

      ** Build buffer with required output, if no errors occurred

     C                   IF        Idx > *ZERO OR RetCodeOut <> *BLANKS
     C                   EVAL      APIRetc = '0'
     C                   ELSE
     C                   MOVEA     ORDATEA       ORDATEAST                      BUG4646
     C                   MOVEA     OPDATEA       OPDATEAST                      BUG4646
     C                   MOVEA     TRDATEA       TRDATEAST                      BUG4646
     C                   MOVEA     TPDATEA       TPDATEAST                      BUG4646
     C                   MOVEA     OCFSA         OCFSAST                        BUG4646
     C                   MOVEA     TCFSA         TCFSAST                        BUG4646
     C                   MOVEA     PCSA          PCSAST                         BUG4646
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
     C**********         EVAL      %SUBST(SIRSScnFmt:243:64) =                     BUG10815 BUG10815
     C**********                                    %SUBST(Buffer:243:64)          BUG10815 BUG10815
     C                   EVAL      Buffer = SIRSScnFmt +
     C*******************                   OurRatChgD +                        BUG4646
     C*******************                   OurIntPayD +                        BUG4646
     C*******************                   ThrRatChgD +                        BUG4646
     C*******************                   ThrIntPayD +                        BUG4646
     C                                      InRecSttmt +
     C                                      InPaySttmt +
     C*******************                   InFRASttmt                          BUG4646
     C**********                            InFRASttmt +                        BUG4646      BUG6377
     C**********                            InFRASttmt + SUINFD + STINFD +           BUG6377 BUG6671
     C                                      InFRASttmt +                                     BUG6671
     C                                      InfData + ExtData +                              BUG6671
     C                                      SUINFD + STINFD +                                BUG6671
     C                                           CPST     + DSPCP +                          BUG6512
     C                                           BKST     + DSPBK +                          BUG6512
     C                                      DDSTS +                                          BUG5871
     C                                      FORMULAOR + FORMULAOP +             BUG4646
     C                                      FORMULATR + FORMULATP +             BUG4646
     C                                      FORMULAOC + FORMULATC +             BUG4646
     C**********                            FORMULAOPC+ FORMULATPC + ORDATEAST        BUG4646 CSW213
     C                                      FORMULAOPC+ FORMULATPC +                          CSW213
     C**********                            InSwift2013 + ORDATEAST                  CSW213 MD053400
     C                                      InSwift2013 + ACTRJ +                           MD053400
     C                                      ORDATEAST                                       MD053400
     C*******************EVAL      Buffer2=%SUBST(ORDATEAST:4239)+OPDATEAST     BUG4646BUG5357
     C*******************EVAL      BufferEx2=%SUBST(OPDATEAST:3438)+TRDATEAST   BUG4646BUG5357
     C*******************                      +TPDATEAST                       BUG4646BUG5357
     C*******************EVAL      BufferEx3=%SUBST(TPDATEAST:3837)+OCFSAST     BUG4646BUG5357
     C*******************EVAL      BufferEx4=%SUBST(OCFSAST:9036)+TCFSAST       BUG4646BUG5357
     C*******************EVAL      BufferEx5=%SUBST(TCFSAST:5835)+PCSAST        BUG4646BUG5357
     C*******************EVAL      BufferEx6=%SUBST(PCSAST:2634)                BUG4646BUG5357
     C*******************EVAL      BufferEx7=%SUBST(PCSAST:12633)               BUG4646BUG5357
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4177)+OPDATEAST     BUG5357      BUG6377
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3376)+TRDATEAST   BUG5357      BUG6377
     C**********                               +TPDATEAST                       BUG5357      BUG6377
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3775)+OCFSAST     BUG5357      BUG6377
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8974)+TCFSAST       BUG5357      BUG6377
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5773)+PCSAST        BUG5357      BUG6377
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2572)                BUG5357      BUG6377
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12571)               BUG5357      BUG6377
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4165)+OPDATEAST           BUG6377 CDL028
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3364)+TRDATEAST         BUG6377 CDL028
     C**********                               +TPDATEAST                             BUG6377 CDL028
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3763)+OCFSAST           BUG6377 CDL028
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8962)+TCFSAST             BUG6377 CDL028
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5761)+PCSAST              BUG6377 CDL028
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2560)                      BUG6377 CDL028
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12559)                     BUG6377 CDL028
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4077)+OPDATEAST           CDL028 BUG6472
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3276)+TRDATEAST         CDL028 BUG6472
     C**********                               +TPDATEAST                             CDL028 BUG6472
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3675)+OCFSAST           CDL028 BUG6472
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8874)+TCFSAST             CDL028 BUG6472
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5673)+PCSAST              CDL028 BUG6472
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2472)                      CDL028 BUG6472
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12471)                     CDL028 BUG6472
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4075)+OPDATEAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3274)+TRDATEAST        BUG6472 BUG6671
     C**********                               +TPDATEAST                            BUG6472 BUG6671
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3673)+OCFSAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8872)+TCFSAST            BUG6472 BUG6671
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5671)+PCSAST             BUG6472 BUG6671
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2470)                     BUG6472 BUG6671
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12469)                    BUG6472 BUG6671
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4024)+OPDATEAST          BUG6671 BUG6512
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3223)+TRDATEAST        BUG6671 BUG6512
     C**********                               +TPDATEAST                            BUG6671 BUG6512
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3622)+OCFSAST          BUG6671 BUG6512
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8821)+TCFSAST            BUG6671 BUG6512
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5620)+PCSAST             BUG6671 BUG6512
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2419)                     BUG6671 BUG6512
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12418)                    BUG6671 BUG6512
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4018)+OPDATEAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3217)+TRDATEAST        BUG6512 BUG5871
     C**********                               +TPDATEAST                            BUG6512 BUG5871
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3616)+OCFSAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8815)+TCFSAST            BUG6512 BUG5871
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5614)+PCSAST             BUG6512 BUG5871
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2413)                     BUG6512 BUG5871
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12412)                    BUG6512 BUG5871
     C*******************EVAL      Buffer2=%SUBST(ORDATEAST:3994)+OPDATEAST          BUG5871 BUG9396
     C*******************EVAL      BufferEx2=%SUBST(OPDATEAST:3193)+TRDATEAST        BUG5871 BUG9396
     C*******************                      +TPDATEAST                            BUG5871 BUG9396
     C*******************EVAL      BufferEx3=%SUBST(TPDATEAST:3592)+OCFSAST          BUG5871 BUG9396
     C*******************EVAL      BufferEx4=%SUBST(OCFSAST:8791)+TCFSAST            BUG5871 BUG9396
     C*******************EVAL      BufferEx5=%SUBST(TCFSAST:5590)+PCSAST             BUG5871 BUG9396
     C*******************EVAL      BufferEx6=%SUBST(PCSAST:2389)                     BUG5871 BUG9396
     C*******************EVAL      BufferEx7=%SUBST(PCSAST:12388)                    BUG5871 BUG9396
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3998)+OPDATEAST         BUG9396 BUG11254
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3197)+TRDATEAST       BUG9396 BUG11254
     C**********                               +TPDATEAST                           BUG9396 BUG11254
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3596)+OCFSAST         BUG9396 BUG11254
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8795)+TCFSAST           BUG9396 BUG11254
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5594)+PCSAST            BUG9396 BUG11254
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2393)                    BUG9396 BUG11254
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12392)                   BUG9396 BUG11254
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3960)+OPDATEAST        BUG11254 BUG11343
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3159)+TRDATEAST      BUG11254 BUG11343
     C**********                               +TPDATEAST                          BUG11254 BUG11343
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3558)+OCFSAST        BUG11254 BUG11343
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8757)+TCFSAST          BUG11254 BUG11343
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5556)+PCSAST           BUG11254 BUG11343
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2355)                   BUG11254 BUG11343
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12354)                  BUG11254 BUG11254
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3994)+OPDATEAST         BUG11343 CSF011A
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3193)+TRDATEAST       BUG11343 CSF011A
     C**********                               +TPDATEAST                           BUG11343 CSF011A
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3592)+OCFSAST         BUG11343 CSF011A
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8791)+TCFSAST           BUG11343 CSF011A
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5590)+PCSAST            BUG11343 CSF011A
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2389)                    BUG11343 CSF011A
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12388)                   BUG11343 CSF011A
                                                                                             CSF011A
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3296)+OPDATEAST           CSF011A CSW213
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:2495)+TRDATEAST         CSF011A CSW213
     C**********                               +TPDATEAST                             CSF011A CSW213
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2894)+OCFSAST           CSF011A CSW213
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8093)+TCFSAST             CSF011A CSW213
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4892)+PCSAST              CSF011A CSW213
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:1691)                      CSF011A CSW213
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:11690)                     CSF011A CSW213
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:1364)+OPDATEAST            CSW213 CIR017
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:563)+TRDATEAST           CSW213 CIR017
     C**********                               +TPDATEAST                              CSW213 CIR017
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:962)+OCFSAST             CSW213 CIR017
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:6161)+TCFSAST              CSW213 CIR017
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2960)                      CSW213 CIR017
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12959)+PCSAST              CSW213 CIR017
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9758)                       CSW213 CIR017
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:1300)+OPDATEAST            CIR017 CSW214
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:499)+TRDATEAST           CIR017 CSW214
     C**********                               +TPDATEAST                              CIR017 CSW214
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:898)+OCFSAST             CIR017 CSW214
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:6097)+TCFSAST              CIR017 CSW214
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2896)                      CIR017 CSW214
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12895)+PCSAST              CIR017 CSW214
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9694)                       CIR017 CSW214
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:1138)+OPDATEAST          CSW214 MD031775
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:337)+TRDATEAST         CSW214 MD031775
     C**********                               +TPDATEAST                            CSW214 MD031775
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:736)+OCFSAST           CSW214 MD031775
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5935)+TCFSAST            CSW214 MD031775
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2734)                    CSW214 MD031775
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12733)+PCSAST            CSW214 MD031775
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9532)                     CSW214 MD031775
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:928)+OPDATEAST           MD031775 CSW216
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:127)+TRDATEAST         MD031775 CSW216
     C**********                               +TPDATEAST                            MD031775 CSW216
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:526)+OCFSAST           MD031775 CSW216
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5725)+TCFSAST            MD031775 CSW216
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2524)                    MD031775 CSW216
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12523)+PCSAST            MD031775 CSW216
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9322)                     MD031775 CSW216
                                                                                              CSW216
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:888)+OPDATEAST           CSW216 MD053400
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:87)+TRDATEAST          CSW216 MD053400
     C**********                               +TPDATEAST                            CSW216 MD053400
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:486)+OCFSAST           CSW216 MD053400
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5685)+TCFSAST            CSW216 MD053400
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2484)                    CSW216 MD053400
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12483)+PCSAST            CSW216 MD053400
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9282)                     CSW216 MD053400
     C                   EVAL      Buffer2=%SUBST(ORDATEAST:887)+OPDATEAST                  MD053400
     C                   EVAL      BufferEx2=%SUBST(OPDATEAST:86)+TRDATEAST                 MD053400
     C                                         +TPDATEAST                                   MD053400
     C                   EVAL      BufferEx3=%SUBST(TPDATEAST:485)+OCFSAST                  MD053400
     C                   EVAL      BufferEx4=%SUBST(OCFSAST:5684)+TCFSAST                   MD053400
     C                   EVAL      BufferEx5=%SUBST(TCFSAST:2483)                           MD053400
     C                   EVAL      BufferEx6=%SUBST(TCFSAST:12482)+PCSAST                   MD053400
     C                   EVAL      BufferEx7=%SUBST(PCSAST:9281)                            MD053400
     C                   ENDIF

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSIRSRED -  Roll Backwards & Forwards through Deals File    *
      *****************************************************************
     C     SrSIRSRED     BEGSR

     C                   CALLB     'IRSIRSRED'

      ** Input parameters:
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

      ** Output parameters:
      ** Error meassage
     C                   PARM                    PErrMs
      ** Deal number read
     C                   PARM                    PDlNoR

     C     ESrSIRSRED    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSIRSRTV -  Retrieve Deal from File                         *
      *****************************************************************
     C     SrSIRSRTV     BEGSR

     C                   CALLB     'IRSIRSRTV'

      ** Input parameters:
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp
      ** Response mode
     C                   PARM      'S'           RespMode
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
      ** Switchable feature CIR008
     C                   PARM                    CIR008

      ** Output parameters:
      ** (Current) deal in file format
      ** (Current) deal extenstion in file format                               BUG4646
     C                   PARM                    SIRSFilFmt
     C                   PARM                    DealXFilFmt                    BUG4646
                                                                                BUG4646
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
     C                   PARM      *ZERO         Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                      222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIDArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
      ** Array index (3P0) from/to caller                                                     222373
     C                   PARM                    WIdx                                         222373

     C     ESrSIRSRTV    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSIRSCVT -  Conversion of File Fields to Screen Format      *
      *****************************************************************
     C     SrSIRSCVT     BEGSR

     C                   CALLB     'IRSIRSCVT'

      ** Input parameters:
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Deal in file format
     C                   PARM                    SIRSFilFmt
     C                   PARM                    DealXFilFmt                    BUG4646
      ** Switchable feature CIR008
     C                   PARM                    CIR008

      ** Output parameters:
      ** Deal in screen format
     C                   PARM                    SIRSScnFmt
      ** Deal Status
     C**********         PARM                    PDlSts                                      BUG5871
     C                   PARM                    DDSTS                                       BUG5871

     C     ESrSIRSCVT    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSETINCVT - Conversion of SSI File Fields to Screen Format  *
      *****************************************************************
     C     SrSETINCVT    BEGSR

     C*******************EVAL      DBRecSttmt = SIRSRecIns + RSROBR             BUG4646
     C                   EVAL      %SUBST(DBRecSttmt:1:2)=%SUBST(SIRSRecIns:1:2)BUG4646
     C                   EVAL      %SUBST(DBRecSttmt:3:18)=RSRONS               BUG4646
     C                   EVAL      %SUBST(DBRecSttmt:21:55)=                    BUG4646
     C                             %SUBST(SIRSRecIns:15:55)                     BUG4646
     C                   EVAL      FLROBR     = RSROBR                          BUG4646
     C                   EVAL      FLRSCY     = RSRSCY
     C*******************EVAL      DBPaySttmt = SIRSPayIns + RSPOBR + RSCVMR    BUG4646
     C                   EVAL      %SUBST(DBPaySttmt:1:2)=%SUBST(SIRSPayIns:1:2)BUG4646
     C                   EVAL      %SUBST(DBPaySttmt:3:18)=RSPONS               BUG4646
     C                   EVAL      %SUBST(DBPaySttmt:21:545)=                   BUG4646
     C                             %SUBST(SIRSPayIns:15:545)                    BUG4646
     C                   EVAL      FLPOBR     = RSPOBR                          BUG4646
     C                   EVAL      FLCVMR     = RSCVMR                          BUG4646
     C                   EVAL      FLPSCY     = RSPSCY
     C                   EVAL      FLIC72     = RSIC72
     C                   EVAL      DBFraSttmt = SIRSFraIns
     C                   MOVE      RSAGVC        FLAGVC

     C                   CALLB     'ZASETINCVT'

      ** Input parameters:
      ** File payment settlement instructions
     C                   PARM                    DBPaySttmt

      ** File receipt settlement instructions
     C                   PARM                    DBRecSttmt

      ** File FRA/IRS settlement instructions
     C                   PARM                    DBFraSttmt

      ** Output parameters:
      ** Screen payment settlement instructions
     C                   PARM                    InPaySttmt

      ** Screen receipt settlement instructions
     C                   PARM                    InRecSttmt

      ** Screen FRA/IRS settlement instructions
     C                   PARM                    InFRASttmt

     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A
     C     ESrSETINCVT   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG6377
      *  SrINFDCVT  - Conversion of calculated interest fix dates     *                      BUG6377
      *****************************************************************                      BUG6377
     C     SrINFDCVT     BEGSR                                                               BUG6377
                                                                                             BUG6377
     C     RSUINFD       IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  RSUINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE            7                         BUG6377
     C                   MOVEL     ZDATE         SUINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C     RSTINFD       IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  RSTINFD                                         BUG6377
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
                                                                                             BUG6544
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
     C**********         PARM      '*KEY   '     @OPTN                                       BUG6544
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
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      *  RetrieveIC - Retrieve IC dates                               *         BUG4646
      *****************************************************************         BUG4646
     C     RetrieveIC    BEGSR                                                  BUG4646
     C                   MOVEL     SDLNO         DealNo                         BUG4646
     C                   EXSR      CheckCurr                                    BUG4646
                                                                                BUG4646
      ** Our rate change date Schedule                                          BUG4646
     C*****SUICFR        IFEQ      'Z'                                          BUG4646      BUG7621
     C                   EVAL      RatPay = 'R'                                 BUG4646
     C                   EVAL      OTInd = 'U'                                  BUG4646
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KDTSC         SETLL     DLDTSCD0                                     BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      DSCHOL = COHO                                BUG4646
     C                   EVAL      DSPDAT = DTPR                                BUG4646
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         DSDATE                         BUG4646
     C                   EVAL      ORDATEA(X) = DATESCH                         BUG4646
     C                   ADD       1             X                              BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                  BUG4646      BUG7621
                                                                                BUG4646
      ** Our Interest Payment dates                                             BUG4646
     C*****SUIPFR        IFEQ      'Z'                                          BUG4646      BUG7621
     C                   EVAL      RatPay = 'P'                                 BUG4646
     C                   EVAL      OTInd = 'U'                                  BUG4646
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KDTSC         SETLL     DLDTSCD0                                     BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      DSCHOL = COHO                                BUG4646
     C                   EVAL      DSPDAT = DTPR                                BUG4646
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         DSDATE                         BUG4646
     C                   EVAL      OPDATEA(X) = DATESCH                         BUG4646
     C                   ADD       1             X                              BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                  BUG4646      BUG7621
                                                                                BUG4646
      ** Their rate change date Schedule                                        BUG4646
     C*****STICFR        IFEQ      'Z'                                          BUG4646      BUG7621
     C                   EVAL      RatPay = 'R'                                 BUG4646
     C                   EVAL      OTInd = 'T'                                  BUG4646
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KDTSC         SETLL     DLDTSCD0                                     BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      DSCHOL = COHO                                BUG4646
     C                   EVAL      DSPDAT = DTPR                                BUG4646
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         DSDATE                         BUG4646
     C                   EVAL      TRDATEA(X) = DATESCH                         BUG4646
     C                   ADD       1             X                              BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                  BUG4646      BUG7621
                                                                                BUG4646
      ** Their Interest Payment dates                                           BUG4646
     C*****STIPFR        IFEQ      'Z'                                          BUG4646      BUG7621
     C                   EVAL      RatPay = 'P'                                 BUG4646
     C                   EVAL      OTInd = 'T'                                  BUG4646
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KDTSC         SETLL     DLDTSCD0                                     BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      DSCHOL = COHO                                BUG4646
     C                   EVAL      DSPDAT = DTPR                                BUG4646
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         DSDATE                         BUG4646
     C                   EVAL      TPDATEA(X) = DATESCH                         BUG4646
     C                   ADD       1             X                              BUG4646
     C     KDTSCP        READE     DLDTSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                  BUG4646      BUG7621
                                                                                BUG4646
      ** Our cash flow                                                          BUG4646
     C*****SUIPFR        IFEQ      'C'                                          BUG4646      BUG7621
     C                   EVAL      OTInd = 'U'                                  BUG4646
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KCFSC         SETLL     DLCFSCD0                                     BUG4646
     C     KCFSCP        READE     DLCFSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      CFCHOL = COHO                                BUG4646
     C                   EVAL      CFPDAT = DTPR                                BUG4646
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         CFDATE                         BUG4646
     C**********         EVAL      PZFIELD = *BLANK                                   BUG4646 245692
     C**********         MOVE      CFLA          PZFIELD                              BUG4646 245692
     C**********         EVAL      PZADEC = WPNBDP                                    BUG4646 245692
     C**********         EXSR      SRZEdit                                            BUG4646 245692
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
     C**********         MOVE      PZFIELD       CFAMT                                BUG4646 245692
     C                   EVAL      OCFSA(X) = CASHFSCH                          BUG4646
     C                   ADD       1             X                              BUG4646
     C     KCFSCP        READE     DLCFSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                  BUG4646      BUG7621
                                                                                BUG4646
      ** Their cash flow                                                        BUG4646
     C*****STIPFR        IFEQ      'C'                                          BUG4646      BUG7621
     C                   EVAL      OTInd = 'T'                                  BUG4646
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KCFSC         SETLL     DLCFSCD0                                     BUG4646
     C     KCFSCP        READE     DLCFSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      CFCHOL = COHO                                BUG4646
     C                   EVAL      CFPDAT = DTPR                                BUG4646
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         CFDATE                         BUG4646
     C**********         EVAL      PZFIELD = *BLANK                                   BUG4646 245692
     C**********         MOVE      CFLA          PZFIELD                              BUG4646 245692
     C**********         EVAL      PZADEC = WRNBDP                                    BUG4646 245692
     C**********         EXSR      SRZEdit                                            BUG4646 245692
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
     C**********         MOVE      PZFIELD       CFAMT                                BUG4646 245692
     C                   EVAL      TCFSA(X) = CASHFSCH                          BUG4646
     C                   ADD       1             X                              BUG4646
     C     KCFSCP        READE     DLCFSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                  BUG4646      BUG7621
                                                                                BUG4646
      ** Principle change                                                       BUG4646
     C*****SONPCD        IFNE      *BLANKS                                           BUG4646 BUG7046
     C**********         EVAL      OTInd = 'U'                                       BUG4646 BUG6386
     C                   EVAL      OTInd = ' '                                               BUG6386
     C                   EVAL      ProcDate = 0                                 BUG4646
     C                   EVAL      X = 1                                        BUG4646
     C     KCFSC         SETLL     DLPCSCD0                                     BUG4646
     C     KCFSCP        READE     DLPCSCD0                               99    BUG4646
     C                   DOW       *IN99 = *OFF                                 BUG4646
     C                   EVAL      PCCHOL = COHO                                BUG4646
     C                   EVAL      PCPDAT = DTPR                                BUG4646
     C                   Z-ADD     0             WAMT             15 0          BUG5357
                                                                                             BUG6233
     C                   IF        BGN2ST = 'Y'                                              BUG6233
     C                   IF        CAMT > 0                                     BUG4646
     C                   EVAL      PCIDFLG = 'I'                                BUG4646
     C                   Z-ADD     CAMT          WAMT                           BUG5357
     C                   ELSE                                                   BUG4646
     C                   IF        CAMT < 0                                     BUG4646
     C                   EVAL      PCIDFLG = 'D'                                BUG4646
     C                   Z-SUB     CAMT          WAMT                           BUG5357
     C                   ELSE                                                   BUG4646
     C                   EVAL      PCIDFLG = ' '                                BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ELSE                                                                BUG6233
     C                   Z-ADD     PAMT          WAMT                                        BUG6233
     C                   ENDIF                                                               BUG6233
                                                                                             BUG6233
     C                   EVAL      WQ0001 = PRDT                                BUG4646
     C                   EXSR      SRDate2                                      BUG4646
     C                   MOVEL     ZDATE         PCDATE                         BUG4646
     C*******************EVAL      PZFIELD = *BLANK                             BUG4646BUG5357
     C*******************MOVE      CAMT          PZFIELD                        BUG4646BUG5357
     C*******************EVAL      PZADEC = WONBDP                              BUG4646BUG5357
     C*******************EXSR      SRZEdit                                      BUG4646BUG5357
     C                   MOVE      WAMT          ZFLD15                         BUG5357
     C                   Z-ADD     21            @@CRET                                       245692
     C**********         CALLB     'ZSEDITF'                                          BUG5357 245692
     C**********         PARM                    ZFLD15                               BUG5357 245692
     C**********         PARM      WONBDP        ZDECS                                BUG5357 245692
     C**********         PARM      *BLANKS       ZECODE                               BUG5357 245692
     C**********         PARM                    ZECHAR                               BUG5357 245692
     C**********         PARM      *BLANKS       ZOUT21                               BUG5357 245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM      WONBDP        @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
                                                                                BUG5357
     C                   MOVE      ZOUT21        PCAMT                          BUG5357
     C*******************MOVE      PZFIELD       PCAMT                          BUG4646BUG5357
     C                   EVAL      PCSA(X) = PCHGSCH                            BUG4646
     C                   ADD       1             X                              BUG4646
     C     KCFSCP        READE     DLPCSCD0                               99    BUG4646
     C                   ENDDO                                                  BUG4646
     C**********         ENDIF                                                       BUG4646 BUG7046
     C                   ENDSR                                                  BUG4646
      *****************************************************************         BUG4646
      * CheckCurr - Routine to access currency details                *         BUG4646
      *****************************************************************         BUG4646
     C     CheckCurr     BEGSR                                                  BUG4646
                                                                                BUG4646
      ** Access currency details to get the number of decimal places            BUG4646
     C                   CALL      'AOCURRR0'                                   BUG4646
     C                   PARM      *BLANKS       @RTCD                          BUG4646
     C                   PARM      '*KEY   '     @OPTN                          BUG4646
     C**********         PARM      SUCUCY        @CYCD                               BUG4646 BUG6544
     C                   PARM      SUCUCY        @CYCD             3                         BUG6544
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG4646
                                                                                BUG4646
     C                   MOVE      A6NBDP        WONBDP                         BUG4646
      *                                                                         BUG4646
      ** Get decimal places for settlement currencies, if used                  BUG4646
      *                                                                         BUG4646
     C     DDPSCY        IFNE      *BLANK                                       BUG4646
     C                   CALL      'AOCURRR0'                                   BUG4646
     C                   PARM      *BLANKS       @RTCD                          BUG4646
     C                   PARM      '*KEY   '     @OPTN                          BUG4646
     C                   PARM      DDPSCY        @CYCD                          BUG4646
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG4646
                                                                                BUG4646
     C                   MOVE      A6NBDP        WPNBDP                         BUG4646
     C                   MOVE      DDPSCY        WPSCY                          BUG4646
     C                   ELSE                                                   BUG4646
     C                   MOVE      SUCUCY        WPSCY                          BUG4646
     C                   MOVE      WONBDP        WPNBDP                         BUG4646
     C                   ENDIF                                                  BUG4646
      *                                                                         BUG4646
     C     DDRSCY        IFNE      *BLANK                                       BUG4646
     C                   CALL      'AOCURRR0'                                   BUG4646
     C                   PARM      *BLANKS       @RTCD                          BUG4646
     C                   PARM      '*KEY   '     @OPTN                          BUG4646
     C                   PARM      DDRSCY        @CYCD                          BUG4646
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG4646
     C                   MOVE      A6NBDP        WRNBDP                         BUG4646
     C                   MOVE      DDRSCY        WRSCY                          BUG4646
     C                   ELSE                                                   BUG4646
     C                   MOVE      SUCUCY        WRSCY                          BUG4646
     C                   MOVE      WONBDP        WRNBDP                         BUG4646
     C                   ENDIF                                                  BUG4646
      *                                                                         BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      ********************************************************************      BUG4646
      *                                                                  *      BUG4646
      * SRZEdit - Call to ZEDIT module                                   *      BUG4646
      *                                                                  *      BUG4646
      ********************************************************************      BUG4646
                                                                                BUG4646
     C     SRZEdit       BEGSR                                                  BUG4646
                                                                                BUG4646
     C                   CALLB     'ZEDIT'                                      BUG4646
     C                   PARM                    PZFIELD                        BUG4646
     C                   PARM                    PZADEC                         BUG4646
                                                                                BUG4646
     C                   ENDSR                                                  BUG4646

      ********************************************************************
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
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                        BUG4646
     C                   PARM                    BufferEx2                      BUG4646
     C                   PARM                    BufferEx3                      BUG4646
     C                   PARM                    BufferEx4                      BUG4646
     C                   PARM                    BufferEx5                      BUG4646
     C                   PARM                    BufferEx6                      BUG4646
     C                   PARM                    BufferEx7                      BUG4646
     C                   PARM                    BufferEx8                      BUG4646
     C                   PARM                    BufferEx9                      BUG4646
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
     C/COPY WNCPYSRC,IRSIRSM01

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Check if IRS Fees/Buy-Outs, etc. is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP041'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
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
     C                   EVAL      DBASE = 002
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
     C                   EVAL      DBASE = 003
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
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF

      ** Check if FRA/IRS Deals Authorisation is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR008'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF
      *                                                                                      BUG6233
      ** Access Module Details                                                               BUG6233
      *                                                                                      BUG6233
     C                   CALL      'AOMMODR0'                                                BUG6233
     C                   PARM      *BLANKS       @RTCD                                       BUG6233
     C                   PARM      '*FIRST '     @OPTN                                       BUG6233
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG6233
                                                                                             BUG6233
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
      *                                                                                       245692
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
      *                                                                                      BUG6377
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRtCd                                        CSW213
      *                                                                                       CSW213
     C                   IF        PRtCd = 'CSW2013'                                          CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
      **  Key for DLDTSCPD                                                      BUG4646
     C     KDTSC         KLIST                                                  BUG4646
     C                   KFLD                    DealNo                         BUG4646
     C                   KFLD                    OTInd                          BUG4646
     C                   KFLD                    RatPay                         BUG4646
     C                   KFLD                    ProcDate                       BUG4646
      **  Partial Key for DLDTSCPD                                              BUG4646
     C     KDTSCP        KLIST                                                  BUG4646
     C                   KFLD                    DealNo                         BUG4646
     C                   KFLD                    OTInd                          BUG4646
     C                   KFLD                    RatPay                         BUG4646
      **  Key for DLCFSCPD/DLPCSCPD                                             BUG4646
     C     KCFSC         KLIST                                                  BUG4646
     C                   KFLD                    DealNo                         BUG4646
     C                   KFLD                    OTInd                          BUG4646
     C                   KFLD                    ProcDate                       BUG4646
      **  Partial Key for DLCFSCPD/DLPCSCPD                                     BUG4646
     C     KCFSCP        KLIST                                                  BUG4646
     C                   KFLD                    DealNo                         BUG4646
     C                   KFLD                    OTInd                          BUG4646
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
      **********************************************************************                 BUG6512
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      * SRGetRPIF - Set-up Midas DL Transaction Reporting Information *                       CSW213
      *             Link File.                                        *                       CSW213
      *****************************************************************                       CSW213
     C     SRGetRPIF     BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   EVAL      PModeOp = ModeofOp                                         CSW213
     C                   EVAL      RLAPID = 'SIRS'                                            CSW213
                                                                                              CSW213
     C                   IF        SACCD = 'R'                                                CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = SACCD                                             CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLBRCA = SBRCA                                             CSW213
     C                   EVAL      RLTRRF = SDLNO                                             CSW213
     C                   EVAL      RLLTRF = SLNKDN                                            CSW213
     C                   EVAL      RLDTYP = SDTYP                                             CSW213
     C                   EVAL      RLDLST = SDLST                                             CSW213
      *                                                                                     MD044506
      ** Change RLVALD from Value Date to Deal Date                                         MD044506
      *                                                                                     MD044506
     C**********         EVAL      RLVALD = SVDAT                                    CSW213 MD044506
     C                   EVAL      RLVALD = SDDAT                                           MD044506
      *                                                                                     MD044506
     C                   EVAL      RLCNUM = SCNUM                                             CSW213
     C                   EVAL      RLBCCY = SUCUCY                                            CSW213
     C                   EVAL      RLSCCY = SUCUCY                                            CSW213
     C                   EVAL      RLFOID = ARFOTRANID                                        CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFR'                                                  CSW213
                                                                                              CSW213
      ** Return code                                                                          CSW213
     C                   PARM      *BLANKS       PRetCode                                     CSW213
                                                                                              CSW213
      ** Mode of operation                                                                    CSW213
     C                   PARM                    PModeOp                                      CSW213
                                                                                              CSW213
      ** RPIF Set up fields                                                                   CSW213
     C                   PARM                    PDlRILkpd                                    CSW213
                                                                                              CSW213
      ** OUTPUTS                                                                              CSW213
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
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRetc = '0'                                            MD051249
     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
