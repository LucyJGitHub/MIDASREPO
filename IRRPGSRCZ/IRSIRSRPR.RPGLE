     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Invalid single ccy IRS maintenance')          *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRSIRSRPR - Invalid Single Currency IRS Maintenance          *
      *                                                               *
      *  Function:  This function allows invalid IRS deals to be      *
      *             'repaired' and applied to the Midas database.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054117           Date 12Sep19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CIR017             Date 10Apr14               *
      *                 CSD095             Date 08Apr14               *
      *                 245692             Date 11Dec13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CIR014             Date 11May06               *
      *                 BUG11376           Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 233467             Date 06Jun05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL038             Date 10May05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG6472            Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211064             Date 08Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 185064             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP041             Date 07Jan02               *
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 192829             Date 08May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185057             Date 23Jan01               *
      *                 184560             Date 23Jan01               *
      *                 CIR006             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      *                 166907             Date 27Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 CAP014             Date 10Dec99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      *                 168444             Date 30Sep99               *
      *                 163820             Date 12Jul99               *
      *                 162497             Date 18Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 16Mar99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP003  *CREATE    Date 24Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD054117 - Principal change Increase/Decrease capability     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSF011A- CCR015: Display Order in Confirmation Pages         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233467 - Add parameter vDLNO for call to IRSFBOVAL           *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG6472- Added a sign field to short term rate (Recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines                                        *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  211064 - Record IRIDTSCPD not deleted when deal has been     *
      *           repaired. This leads to the failing of APCCHKTRNS   *
      *           in CoB.                                             *
      *  185064 - Old up-front fee details should be saved in         *
      *           DLDGUPFE.                                           *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *  CIR008 - FRA/IRS Deals Authorisations                        *
      *  CSC011 - 24X7 Midas Availability                             *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  200400 - Reverse fix 179510.                                 *
      *  192829 - The wrong module name passed to WN0010.             *
      *  185057 - Validate 'Rate fix days' and 'Rate change Date,     *
      *           only if one of them has changed.                    *
      *           Pass the parameters down.                           *
      *  184560 - Validate Maturity date correctly against            *
      *           Our and Their Start/Last Int Pay Date.              *
      *  CIR006 - FRA/IRS Amortisation of Caps/Collars/Floors &       *
      *           Individual Compounding Swaps. Coding done for       *
      *           Individual Compounding Swaps only.                  *
      *  179510 - For Settlement method 04 , fields  RXURACC & RXUPACC*
      *           Our  Receiving/ Payment  Account   respectively  are*
      *           not  correctly  updated .  Introduced  new  coding  *
      *           to  validate these fields before the update &  Data *
      *           Structure  @MORPI  which is used  for that purpose .*
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal .  *
      *  168444 - Enable maintenance of date schedules in IRS repair  *
      *           functions.                                          *
      *  163820 - Transactions Repair Function performs SPF checking  *
      *           to find if user is authorised to the Branch , but   *
      *           does that against User's Default Branch code instead*
      *           of the selected transaction's Booking/Origin branch *
      *  162497 - Errors in processing of settlement instructions     *
      *           (within ZASETINVAL and ZASETINSIN).                 *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*       *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *           Change defn. of MSGTYPE to be based on file field   *
      *  CAP003 - Conversion of transaction inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)

     FIRISIRSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRISIRSD0 : IRISIRSX0)
     FIRISIRSL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CAP041
     FDLDGUPFE  O    E           K DISK    INFSR(*PSSR)                                       CAP041
     F                                     RENAME(DLDGREF:DLDGREFF)                           CAP041
     F                                     COMMIT                                             CAP041
                                                                                              CAP041
     FDLDGUPL1  UF   E           K DISK    INFSR(*PSSR)                                       CAP041
     F                                     COMMIT                                             CAP041
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
     FIRIDTSCL0 UF   E           K DISK    INFSR(*PSSR)                                       211064
     F                                     COMMIT                                             211064
                                                                                              CAP043
     FIRIDTSCL1 IF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRIDTSCD0 : IRIDTSCX0)                      CAP043
     FIRIDTSCL2 UF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRIDTSCD0 : IRIDTSCX2)                      CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRICFSCL0 IF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRICFSCD0 : IRICFSCX0)                      CAP043
     F                                     PREFIX(CI)                                         CAP043
     FIRICFSCL1 UF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     PREFIX(CI)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRIPCSCL0 IF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     RENAME(IRIPCSCD0 : IRIPCSCX0)                      CAP043
     F                                     PREFIX(PI)                                         CAP043
     FIRIPCSCL1 UF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     PREFIX(PI)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              247888
      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRSIRSR009

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the IRS standard declares
     D*/COPY IRCPYSRC,STDDECLARE                                                            BUG11376

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** Array of error message IDs from IRC date schedule screens
     D @ErrAR          S                   DIM(10)
     D                                     LIKE(#MsgID)
     D @WerrAr         S                   DIM(10)
     D                                     LIKE(#MsgID)
                                                                                CIR005
      ** Array of error used by IRSBSDYVAL                                      CIR005
     D MsgIdErr        S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(MsgIdArr)                       CIR005
                                                                                CIR005
      ** Array of field in error used by IRSBSDYVAL                             CIR005
     D FldNameErr      S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(FldNameArr)                     CIR005
      *                                                                         CIR005
      ** Warning array used by IRSBSDYVAL                                       CIR005
     D WMsgIdErr       S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(MsgIdArr)                       CIR005
      *                                                                         CIR005
      ** Array for fields in warning                                            CIR005
     D WFldNamErr      S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(FldNameArr)                     CIR005
      *                                                                                       CAP041
      ** Work array for warning message Ids                                                   CAP041
     D WPrvWarnAr      S                   Dim(ArrayMax)                                      CAP041
     D                                     Like(WMsgIDArr)                                    CAP041
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D*@EI******       S              1    DIM(60)                                            CLE025
     D @EI             S              1    DIM(62)                                            CLE025

     D CrDlFilFmt    E DS                  EXTNAME(DEALSDG)
      * Current Deal in File Format
     D  R_REC                716    784                                         CAP011
     D  R_PAY                785   1343                                         CAP011
     D  R_IRS               1345   1992                                         CAP011

     D CrDlXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                  CLE025
      * Current Deal Extension in File Format                                                 CLE025
                                                                                              CLE025
     D CrDlScnFmt    E DS                  EXTNAME(IRSIRSPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)

     D NwDlFilFmt    E DS                  EXTNAME(IRVSIRSPD)
      * New Deal in File Format
     D  RSREC                716    784
     D  RSPAY                785   1343
     D  RSIRS               1345   1992

     D NwDlXFilFmt   E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      * New Deal Extension in File Format                                                     CLE025
                                                                                              CLE025
     D NwDlScnFmt    E DS                  EXTNAME(IRSIRSPD)
      * New Deal in Screen Format

     D*BsDayConv*************208    271                                                CIR005 218641
      ***Single*Currency*Business*Day*Conventions*layout                               CIR005 218641
     D**RCcy1****************242    271                                                CIR005 218641
     D*BsDayConv*************213    276                                                218641 CAS005
      ***Single*Currency*Business*Day*Conventions*layout                               218641 CAS005
     D**RCcy1****************247    276                                                218641 CAS005
     D*BsDayConv*************228****291***                                             CAS005 CLE025
      ***Single*Currency*Business*Day*Conventions*layout***************                CAS005 CLE025
     D**RCcy1****************262****291***                                             CAS005 CLE025
     D BsDayConv             243    306                                                       CLE025
      ** Single Currency Business Day Conventions layout                                      CLE025
      **                                                                                      CIR017
      ** Single CCY Business Day Conventions layout - Their Side details included             CIR017
     D BsDayConv2            457    520                                                       CIR017
      **                                                                                      CIR017
     D  RCcy1                277    306                                                       CLE025
                                                                                CIR005
     D IRESIRS       E DS                  EXTNAME(IRESIRSPD)
      * Error indicators


     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                  1     75                                                       CGL029

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                  1    565                                                       CGL029

     D ##RSIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
     D**FLIRS******************1    648                                         CSW097
     D  FLIRS                  1    650                                         CSW097

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS

     D ##RSIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
                                                                                CAP004
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
      * Pay Settlement Instructions - Current                                   CAP011
                                                                                CAP011
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
      * Receive Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
      * FRA/IRS Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D ExtData       E DS                  EXTNAME(IRSSEXPD)                    CAP004
      * IR SIRS Extra Data - File (D/B) format                                  CAP004
      *                                                                                       CAP041
      ** Transaction Details in screen format                                                 CAP041
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)                                  CAP041
     D                                     PREFIX(SF)                                         CAP041
      *                                                                                       CAP041
      ** Transaction Details in screen format                                                 CAP041
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)                                  CAP041
     D                                     PREFIX(O)                                          CAP041
      *                                                                                       CAP041
      ** Transaction Details in screen format                                                 CAP041
     D NwFBScnFld    E DS                  EXTNAME(IRFEB1PD)                                  CAP041
     D                                     PREFIX(SF)                                         CAP041
      *                                                                                       CAP041
      ** Transaction Details OK indicators                                                    CAP041
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)                                 CAP041
     D                                     PREFIX(SF)                                         CAP041

     D @SETIN          DS
      ** Receive / Pay Settlement Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D***@@RONS*                6     17                                                      CGL029
     D***@@PSCY*               18     20                                                      CGL029
     D***@@PSTM*               21     22  0                                                   CGL029
     D***@@PONS*               23     34                                                      CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM

      ** External DS for Deal details                                                         245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D W#ACCD        E                     EXTFLD(QQACCD)                                     245692
                                                                                              245692
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D  SCLCD        E                     EXTFLD(LCD)

     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CAP041
      ** Currency details file                                                                CAP041
      *                                                                                       CAP041
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CAP041
      ** External DS for Nostro Details                                                       CAP041
      *                                                                                       CAP041
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAP041
      ** DS for access programs, long data structure                                          CAP041
      *                                                                                       CAP041
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
      ************                                                                     179510 200400
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
     D                                     PREFIX(CS)                                         CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D PInDTSCDS     E DS                  EXTNAME(IRIDTSCPD)                                 CAP043
      ** Invalid DTSC definition file                                                         CAP043
                                                                                              CAP043
     D PInCFSCDS     E DS                  EXTNAME(IRICFSCPD)                                 CAP043
     D                                     PREFIX(CI)                                         CAP043
      ** Invalid CFSC definition file                                                         CAP043
                                                                                              CAP043
     D PInPCSCDS     E DS                  EXTNAME(IRIPCSCPD)                                 CAP043
     D                                     PREFIX(PI)                                         CAP043
      ** Invalid PCSC definition file                                                         CAP043
                                                                                              CAP043
     D PErrorFndPr     DS                                                                     CAP043
     D   OurPrinEr             1      1                                                       CAP043
                                                                                              CAP043
     D PErrorFndCs     DS                                                                     CAP043
     D   OurCashEr             1      1                                                       CAP043
     D   ThrCashEr             2      2                                                       CAP043
                                                                                              CAP043
     D PErrorFndDt     DS                                                                     CAP043
     D   OurRateEr             1      1                                                       CAP043
     D   OurIntPEr             2      2                                                       CAP043
     D   ThrRateEr             3      3                                                       CAP043
     D   ThrIntPEr             4      4                                                       CAP043
                                                                                              CAP043
     D/COPY QWINDSRC,IRSIRSGDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   Timestamp selected
     D @TMESTPSEL      S             26Z

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('IRSIRSPD')

     D Field           S             10A   INZ('SACCD')
                                                                                CIR005
     D FieldB          S             10A   INZ('SC1P1')                         CIR005
                                                                                              CAP041
     D FieldF          S             10A   INZ('SUFVD')                                       CAP041

     D FieldNo         S              5P 0

     D FldOffset       S              5P 0
                                                                                CIR005
     D FldOffsetB      S              5P 0                                      CIR005
                                                                                              CAP041
     D FldOffsetF      S              5P 0                                                    CAP041

      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------

      ** Screen/Server input flag (passed to IRSIRSUPD to indicate              CAP004
      ** source of transaction.                                                 CAP004
     D ScreenInpt      S              1A                                        CAP004

      ** First pass flag                                                        CIR005
     D WFrstPas        S              1A   INZ('Y')                             CIR005
                                                                                CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D WValBDC         S              1A                                        CIR005
                                                                                CIR005
     D WrnFlag         S              1    INZ('N')                             CIR005
                                                                                CIR005
     D WSavRC1         S             30                                         CIR005
                                                                                CIR005
      ** Field to save out the new Business Day Convention parameters                         CIR017
     D WSavBDC2        S            128A                                                      CIR017
     D BsDayConvW      S            128A                                                      CIR017
     D WCallFunc       S                   LIKE(RetCodeIn)                                    CIR017
      **                                                                                      CIR017
      ** Send error message for business day convention screen flag             CIR005
     D WSndScn2        S              1A   INZ('N')                             CIR005
                                                                                CIR005
     D POKFlags        S             25A                                        CIR005
                                                                                CIR005
     D IRESBDY         S             22A                                        CIR005
      ** Expand to include 'Their details' fields                                             CIR017
     D IRESBDY2        S             44A                                                      CIR017
                                                                                CIR005
      ** Message type field for chaining to APIDSETPD; defined in terms         CAP004
      ** of the file field when the file field was changed.                     CAP004
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)                      CAP004
                                                                                CAP004
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CAS001
      ** Variables defined for CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
      *                                                                                       CAP041
      ** Work variables for Fees and Buy-outs processing                                      CAP041
     D PWUCDP          S              1P 0                                                    CAP041
     D PWTCDP          S              1P 0                                                    CAP041
     D PWPSCY          S              3A                                                      CAP041
     D PWRSCY          S              3A                                                      CAP041
     D PWPNLOC         S              3A                                                      CAP041
     D PWRNLOC         S              3A                                                      CAP041
     D WRedisplay      S              1A                                                      CAP041
     D PAmendOK        S              1A                                                      CAP041
     D WIx             S              3P 0                                                    CAP041
     D WRsnd           S              1A                                                      CAP041
                                                                                              CAP041
     D CIR017          S              1A                                                      CIR017
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
     D PRetCode        S              7A                                                      CIR008
     D POption         S              7A                                                      CIR008
                                                                                              CIR008
      ** Work fields used by CAP043                                                           CAP043
     D CAP043          S              1A                                                      CAP043
     D PAction         S              1A                                                      CAP043
     D PPrevDate       S              5P 0                                                    CAP043
     D PCurrency       S              3A                                                      CAP043
     D WOurThr         S              1A                                                      CAP043
     D WRatPay         S              1A                                                      CAP043
     D PUpdate         S              1A                                                      CAP043
     D PCtlDate        S              5P 0                                                    CAP043
     D PPAmt           S             15P 0                                                    CAP043
                                                                                              CAP043
      ** Business Day Convention currencies                                                   CAP043
     D PBDConvtn       S             30A                                                      CAP043
                                                                                              CAP043
     D vDLNO           S              6A   INZ(*BLANKS)                                       233467
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
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

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRSIRSR010

      *****************************************************************
      /EJECT
      *****************************************************************
     C
      /COPY WNCPYSRC,IRSIRSR001                                                 CAP004
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * DO SCREEN: BROWSE INVALID DEALS
      *
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
      *
      /COPY WNCPYSRC,IRSIRSR002                                                 CAP004

      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      /COPY WNCPYSRC,IRSIRSR003                                                 CAP004

      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      *
      * CHECK IF SCHEDULE DATES REQUIRE PROCESSING (FOR IRC FEATURE)
      *
     C     CIR001        IFEQ      'Y'
     C     @SCRN         ANDEQ     'X'
     C                   EXSR      SCHEDULES
     C                   END
      *                                                                                       CAP041
      ** Screen: Fees/Buy-Outs details                                                        CAP041
      *                                                                                       CAP041
     C     @SCRN         DOWEQ     'F'                                                        CAP041
     C                   EXSR      SRFBProc                                                   CAP041
     C                   ENDDO                                                                CAP041
      *
      /COPY WNCPYSRC,IRSIRSR004                                                 CAP004

      * SCREEN: WINDOW
      *
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
      *
      /COPY WNCPYSRC,IRSIRSR005                                                 CAP004

      * DO WHILE SCREEN: SETTLEMENT DETAILS
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      *
      /COPY WNCPYSRC,IRSIRSR006                                                 CAP004

      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      /COPY WNCPYSRC,IRSIRSR007                                                 CAP004

      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      /COPY WNCPYSRC,IRSIRSR008                                                 CAP004

      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRSIRSR011

      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID DEALS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'IRSIRSRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
      ** CSC011 Enhancement is installed                                                      CSC011
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CAP041                                       CAP043
     C                   PARM                    CAP043                                       CAP043
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'IRSIRSRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOASOCSEL
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
      ** CSC011 Enhancement is installed                                                      CSC011
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CAP041                                       222373
     C                   PARM                    CAP043                                       222373
      *                                                                         CAP004
      * If CK/3 taken within invalid transaction deletion function,             CAP004
      * End program                                                             CAP004
      *                                                                         CAP004
     C     @INKC         IFEQ      '1'                                          CAP004
     C                   EXSR      ENDP                                         CAP004
     C                   GOTO      ERDNBRW                                      CAP004
     C                   END                                                    CAP004
      *
      * IF INVALID DEAL READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   MOVEL     *BLANK        @WerrAr
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       IRESIRS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve deal details
      *
     C                   MOVEL     @ACSEL        SACCD
     C                   MOVEL     @FOTRANSEL    FOTRID
     C                   MOVEL     @FOASOCSEL    FOASID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         163820
      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
      * module for SPF checking .                                               163820
     C     ZATRNKX0      CHAIN     IRISIRSX0                          99        163820
      *                                                                         163820
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     SACCD         IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     SDLNO         IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVDEL
                                                                                CIR005
     C                   EVAL      @@MODE = '*RPR  '                            CIR005
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   CLEAR                   BsDayConv                      CIR005
     C                   ELSE                                                                 CIR017
     C                   CLEAR                   BsDayConvW                                   CIR017
     C                   CLEAR                   BsDayConv2                                   CIR017
     C                   ENDIF                                                                CIR017
     C                   ENDIF                                                  CIR005
      *
      * If deal details were retrieved
      * Put the deal on the main details screen
      *
     C     RECI          IFNE      *BLANK
     C     SACCD         ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid deals file (except for the Midas deal number
      * retrieved above using the front office transaction and
      * associated transaction IDs).
      * Access invalid deal with timestamp and front office transaction ID.
      *
     C                   MOVEL     SDLNO         ##SDLNO           6
     C     ZATRNKX0      CHAIN     IRISIRSX0                          99
     C     RECI          IFNE      *BLANK                                       CAP004
     C     SACCD         ANDNE     'I'                                          CAP004
     C                   MOVEL     ##SDLNO       SDLNO
     C                   END                                                    CAP004
      *
      * Access invalid deal settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
      *                                                                         CAP011
      * If deal details were retrieved and this is an amendment                 CAP011
      *                                                                         CAP011
     C     RECI          IFNE      *BLANK                                       CAP011
     C     SACCD         ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        SCAN      NwDlScnFmt                             99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
                                                                                CAP011
      * Setup settlement instructions on amend                                  CAP011
                                                                                CAP011
     C                   EXSR      SetupAmend                                   CAP011
                                                                                CAP011
      * Data Substitution - Settlement Details                                  CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        SCAN      ##PAYS                                 99    CAP011
     C  N99GHSUBS        SCAN      ##RECS                                 99    CAP011
     C  N99GHSUBS        SCAN      ##RSIS                                 99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      SDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
                                                                                CAP011
     C                   END                                                    CAP011
      *
      * If action code, or deal number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     OKACCD        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   MOVEL     *BLANK        SACCD
     C                   END
      *
      * Send the deals error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   EVAL      WSndScn2 = 'N'                               CIR005
     C                   ENDIF                                                  CIR005
     C                   EVAL      WRsnd = 'N'                                                CAP041
      *
     C     ERDNBRW       ENDSR                                                  CAP004
     C*******************ENDSR                                                  CAP004
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR

     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     OKACCD        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     IRESIRS       @EI
      *
      ** Read error messages for deal
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C     CIR005        IFEQ      'N'                                          CIR005
     C     ABFIELDID     ORLE      FldOffsetB                                   CIR005
     C     CIR005        ANDEQ     'Y'                                          CIR005
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                  CIR005
      **********                                                                       CAS001 218641
      ***If*CAS001*is*On,*highlight fields our/their yield curve if in error           CAS001 218641
      **********                                                                       CAS001 218641
     C**********         IF        CAS001 = 'Y'                                        CAS001 218641
      **********                                                                       CAS001 218641
     C**********         IF        ABFIELDID = 86                                      CAS001 218641
     C**********         ADD       1             E                                     CAS001 218641
     C**********         MOVEL     ABFIELDNAM    FldNameArr(E)                         CAS001 218641
     C**********         MOVEL     ABMSGID       MsgIdArr(E)                           CAS001 218641
     C**********         EVAL      OKOYLC = 'N'                                        CAS001 218641
     C**********         ENDIF                                                         CAS001 218641
      **********                                                                       CAS001 218641
     C**********         ENDIF                                                         CAS001 218641
      **********                                                                       CAS001 218641
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           IRESIRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CIR005
      *****************************************************************         CIR005
      *                                                               *         CIR005
      *  SNDM@B - Send error message to Bus. Day Convention screen.   *         CIR005
      *                                                               *         CIR005
      *****************************************************************         CIR005
     C     SNDM@B        BEGSR                                                  CIR005
                                                                                CIR005
     C                   EVAL      E = 0                                        CIR005
                                                                                CIR005
      ** Initialize error indicators                                            CIR005
                                                                                CIR005
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   EVAL      IRESBDY = *ALL'Y'                            CIR005
     C                   MOVEA     IRESBDY       @EI                            CIR005
     C                   ELSE                                                                 CIR017
     C                   EVAL      IRESBDY2 = *ALL'Y'                                         CIR017
     C                   MOVEA     IRESBDY2      @EI                                          CIR017
     C                   END                                                                  CIR017
                                                                                CIR005
      ** Read error messages for deal                                           CIR005
                                                                                CIR005
     C     ZATRNKD0      SETLL     ZATRNERRD0                                   CIR005
     C     ZATRNKD0      READE     ZATRNERRD0                             99    CIR005
                                                                                CIR005
      ** Add error message to array passed to detail screen                     CIR005
      ** and set OK flag for field to 'N'                                       CIR005
                                                                                CIR005
     C                   DOW       *IN99 = *Off                                 CIR005
     C                   IF        ABFIELDID > FldOffSetB                       CIR005
     C**********                   AND ABFIELDID <> 86                                 CAS001 218641
     C                             AND ABFIELDID <= FldOffSetF                                CAP041
     C                   ADD       1             E                              CIR005
     C                   MOVEL     ABFIELDNAM    FldNameErr(E)                  CIR005
     C                   MOVEL     ABMSGID       MsgIdErr(E)                    CIR005
                                                                                CIR005
     C                   Z-ADD     ABFIELDID     F                              CIR005
     C                   SUB       FldOffsetB    F                              CIR005
                                                                                CIR005
     C                   IF        F < 1 or F > 60                              CIR005
     C                   Z-ADD     1             F                              CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   MOVE      'N'           @EI(F)                         CIR005
     C                   ENDIF                                                  CIR005
     C     ZATRNKD0      READE     ZATRNERRD0                             99    CIR005
     C                   ENDDO                                                  CIR005
      *                                                                         CIR005
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   MOVEA     @EI           IRESBDY                        CIR005
     C                   EVAL      POkFlags = %SUBST(IRESBDY:13:10) +           CIR005
     C                                        %SUBST(IRESBDY:1:10) +            CIR005
     C                                        %SUBST(IRESBDY:11:2)              CIR005
                                                                                              CIR017
      ** Set up error flags for both Our and Their details in the correct order:              CIR017
      ** 13:10 -                                                                              CIR017
     C                   ELSE                                                                 CIR017
     C                   MOVEA     @EI           IRESBDY2                                     CIR017
      ** Update error indicators in correct sequence:                                         CIR017
      ** 13:10 Leg1 Rate Fixing Convention Currency                                           CIR017
      **  1:10 Leg1 Payment Convention Currency                                               CIR017
      ** 11:10 Leg1 Amount and Payment Date Convention                                        CIR017
      ** 35:10 Leg2 Rate Fixing Convention Currency                                           CIR017
      ** 23:10 Leg2 Payment Convention Currency                                               CIR017
      ** 33:10 Leg2 Amount and Payment Date Convention                                        CIR017
     C                   EVAL      POkFlags = %SUBST(IRESBDY2:13:10) +                        CIR017
     C                                        %SUBST(IRESBDY2:1:10) +                         CIR017
     C                                        %SUBST(IRESBDY2:11:2) +                         CIR017
     C                                        %SUBST(IRESBDY2:35:10) +                        CIR017
     C                                        %SUBST(IRESBDY2:23:10) +                        CIR017
     C                                        %SUBST(IRESBDY2:33:2)                           CIR017
     C                   END                                                                  CIR017
                                                                                CIR005
     C                   ENDSR                                                  CIR005
      *****************************************************************         CIR005
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SNDM@F - Send error message to Fees and Buy-out details      *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
     C     SNDM@F        BEGSR                                                                CAP041
                                                                                              CAP041
     C                   EVAL      E = 0                                                      CAP041
     C                   EVAL      WRsnd = 'Y'                                                CAP041
      *                                                                                       CAP041
      ** Initialize error indicators                                                          CAP041
                                                                                              CAP041
     C                   EVAL      OKFEBO  = *ALL'Y'                                          CAP041
     C                   MOVEA     OKFEBO        @EI                                          CAP041
     C                   MOVEL     *BLANK        FldNameArr                                   CAP041
     C                   MOVEL     *BLANK        MsgIdArr                                     CAP041
     C                   MOVEL     *BLANK        MsgDtaArr                                    CAP041
     C                   MOVEL     *BLANK        WFldNamArr                                   CAP041
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAP041
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAP041
      *                                                                                       CAP041
      ** Read error messages for deal                                                         CAP041
                                                                                              CAP041
     C     ZATRNKD0      SETLL     ZATRNERRD0                                                 CAP041
     C     ZATRNKD0      READE     ZATRNERRD0                             99                  CAP041
                                                                                              CAP041
      ** Add error message to array passed to detail screen                                   CAP041
      ** and set OK flag for field to 'N'                                                     CAP041
                                                                                              CAP041
     C                   DOW       *IN99 = *Off                                               CAP041
     C                   IF        ABFIELDID > FldOffSetF                                     CAP041
     C                   ADD       1             E                                            CAP041
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)                                CAP041
     C                   MOVEL     ABMSGID       MsgIdArr(E)                                  CAP041
                                                                                              CAP041
     C                   Z-ADD     ABFIELDID     F                                            CAP041
     C                   SUB       FldOffsetF    F                                            CAP041
                                                                                              CAP041
     C                   IF        F < 1 or F > 60                                            CAP041
     C                   Z-ADD     1             F                                            CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   MOVE      'N'           @EI(F)                                       CAP041
     C                   ENDIF                                                                CAP041
     C     ZATRNKD0      READE     ZATRNERRD0                             99                  CAP041
     C                   ENDDO                                                                CAP041
                                                                                              CAP041
     C                   MOVEA     @EI           OKFEBO                                       CAP041
     C                   EVAL      %SUBST(IRESIRS:69:10) = OKFEBO                             CAP041
                                                                                              CAP041
     C                   ENDSR                                                                CAP041
      *****************************************************************                       CAP041
      /EJECT
      *****************************************************************
      * SNDW@M - SEND A WARNING MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDW@M        BEGSR
      *
      * If schedule amendment changes Our/Their Next Rate Change/Int Pay
      * dates, then set relevant field for warning error
      *
     C     @WERRMS       IFEQ      'MMA0600'
     C                   MOVE      'W'           OKUNICD
     C                   END
     C     @WERRMS       IFEQ      'MMA0601'
     C                   MOVE      'W'           OKUNIPD
     C                   END
     C     @WERRMS       IFEQ      'MMA0602'
     C                   MOVE      'W'           OKTNICD
     C                   END
     C     @WERRMS       IFEQ      'MMA0603'
     C                   MOVE      'W'           OKTNIPD
     C                   END
      *
      ** Add warning message to array passed to detail screen
      *
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    WFldNamArr(E)                          99          *
     C                   MOVEL     '*ANY'        WFldNamArr(E)
     C                   MOVEL     @WERRMS       WMsgIdArr(E)
     C                   ADD       1             Widx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   ROLBK
     C                   END
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'X')
      *
     C     SACCD         IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     SACCD         OREQ      'A'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     SACCD         IFEQ      'R'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *                                                                                       CIR017
     C                   IF        CIR017 = 'Y'                                               CIR017
     C                   Eval      BsDayConvW = BsDayConv + BsDayConv2                        CIR017
     C                   EndIf                                                                CIR017
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'IRSIRSDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
      *
      * FIELDS IN ERROR
     C                   PARM                    IRESIRS
     C/COPY WNCPYSRC,IRH00035
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       IRESIRS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deal details
      *
     C***********        MOVEL     '      '      @@MODE                         CIR005
     C                   EXSR      RTVDEL
      *
      * If action code, or deal number are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACCD        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     SACCD         IFEQ      'R'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   MOVEL     FSOYLC        RSOYLC                                       CGL029
     C                   MOVEL     FIUSRI        RSUSRI                                       CGL029
     C                   MOVEL     FIDSTS        RSDSTS                                       CGL029
     C                   MOVEL     FIAUTH        RSAUTH                                       CGL029
     C                   MOVEL     URACC         RSURACC                                      CGL029
     C                   MOVEL     UPACC         RSUPACC                                      CGL029
     C                   MOVEL     RONS          RSRONS                                       CGL029
     C                   MOVEL     PONS          RSPONS                                       CGL029
     C                   MOVEL     CrDlXFilFmt   NwDlXFilFmt                                  CLE025
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE                                                   CIR005
     C                   IF        (CIR005 = 'Y') And (BsDayConv <> *Blank)     CIR005
     C                             OR (CIR005 = 'Y') AND (CIR017 = 'Y')                       CIR017
     C                             AND (BsDayConvW <> *Blank)                                 CIR017
     C                   EXSR      SrBsDyC                                      CIR005
                                                                                CIR005
      ** F12 pressed, back to main screen                                       CIR005
                                                                                CIR005
     C                   IF        WFntKey = '12'                               CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
     C                   EVAL      WFntKey = *Blank                             CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** F3 pressed, end program                                                CIR005
                                                                                CIR005
     C                   IF        WFntKey = '03'                               CIR005
     C                   EXSR      ENDP                                         CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   ENDIF                                                  CIR005
     C                   END
     C                   GOTO      EVAL@M
     C                   END
                                                                                              CIR008
      *----------------------------------------------------------------                       CIR008
      ** If Authorise                                                                         CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND SACCD = 'X'                               CIR008
     C                   EXSR      PUTD@M                                                     CIR008
                                                                                              CIR008
      ** Update Deal in File Format                                                           CIR008
                                                                                              CIR008
     C                   EVAL      NwDlFilFmt = CrDlFilFmt                                    CIR008
     C                   MOVEL     FSOYLC        RSOYLC                                       CGL029
     C                   MOVEL     FIUSRI        RSUSRI                                       CGL029
     C                   MOVEL     FIDSTS        RSDSTS                                       CGL029
     C                   MOVEL     FIAUTH        RSAUTH                                       CGL029
     C                   MOVEL     URACC         RSURACC                                      CGL029
     C                   MOVEL     UPACC         RSUPACC                                      CGL029
     C                   MOVEL     RONS          RSRONS                                       CGL029
     C                   MOVEL     PONS          RSPONS                                       CGL029
     C                   EVAL      NwDlXFilFmt = CrDlXFilFmt                                  CLE025
                                                                                              CIR008
      ** If CIR001 is installed, display the schedules, otherwise,                            CIR008
      ** if windows processing on, call window routine                                        CIR008
      ** otherwise, continue to confirmation screen                                           CIR008
                                                                                              CIR008
     C                   IF        CIR001 = 'Y'                                               CIR008
     C                   EVAL      @SCRN = 'X'                                                CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        BGWDPR = 'Y'                                               CIR008
     C                   EVAL      @SCRN = 'W'                                                CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      @SCRN = 'C'                                                CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        CIR005 = 'Y' AND BsDayConv <> *BLANKS                      CIR008
     C                             OR  (CIR005 = 'Y') AND (CIR017 = 'Y')                      CIR017
     C                             AND (BsDayConvW <> *BLANKS)                                CIR017
     C                   EXSR      SrBsDyC                                                    CIR008
                                                                                              CIR008
      ** F12 pressed, back to main screen                                                     CIR008
                                                                                              CIR008
     C                   IF        WFntKey = '12'                                             CIR008
     C                   EVAL      @SCRN = 'M'                                                CIR008
     C                   EVAL      WFntKey = *BLANK                                           CIR008
     C                   GOTO      EVAL@M                                                     CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** F3 pressed, end program                                                              CIR008
                                                                                              CIR008
     C                   IF        WFntKey = '03'                                             CIR008
     C                   EXSR      ENDP                                                       CIR008
     C                   GOTO      EVAL@M                                                     CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   GOTO      EVAL@M                                                     CIR008
     C                   ENDIF                                                                CIR008
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACCD         IFEQ      'I'
     C     SACCD         OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       IRESIRS
     C                   CLEAR                   NwDlFilFmt
     C                   CLEAR                   NwDlXFilFmt                                  CLE025
     C                   Z-ADD     *ZERO         RSRSTM
     C**********         Z-ADD     *ZERO         RSROBN                                       CSD027
     C**********         Z-ADD     *ZERO         RSROCN                                       CSD027
     C                   EVAL      RSROBN = *BLANKS                                           CSD027
     C                   EVAL      RSROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         RSPSTM
     C**********         Z-ADD     *ZERO         RSPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         RSPOCN                                       CSD027
     C                   EVAL      RSPOBN = *BLANKS                                           CSD027
     C                   EVAL      RSPOCN = *BLANKS                                           CSD027
                                                                                CIR005
      ** If first pass to the main screen and Business Day Conventions          CIR005
      ** enhancement is switched on, skip validation of rate change             CIR005
      ** dates and interest payment dates against the Business Day              CIR005
      ** Convention currencies (WValBDC = 'N').                                 CIR005
                                                                                CIR005
     C                   IF        (CIR005 = 'Y') And (WFrstPas = 'Y')          CIR005
     C                   EVAL      WValBDC = 'N'                                CIR005
     C                   ENDIF                                                  CIR005
      *
      * IF AMEND
      *
     C     SACCD         IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   MOVEL     FSOYLC        RSOYLC                                       CGL029
     C                   MOVEL     FIUSRI        RSUSRI                                       CGL029
     C                   MOVEL     FIDSTS        RSDSTS                                       CGL029
     C                   MOVEL     FIAUTH        RSAUTH                                       CGL029
     C                   MOVEL     URACC         RSURACC                                      CGL029
     C                   MOVEL     UPACC         RSUPACC                                      CGL029
     C                   MOVEL     RONS          RSRONS                                       CGL029
     C                   MOVEL     PONS          RSPONS                                       CGL029
     C                   MOVEL     CrDlXFilFmt   NwDlXFilFmt                                  CLE025
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'IRSIRSAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Current Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    IRESIRS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
                                                                                CIR005
      ** Frenquency being used is 'Z', set validate BDC flag to 'N'             CIR005
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   IF        (SUICFR = 'Z') Or (SUIPFR = 'Z') Or          CIR005
     C                             (STICFR = 'Z') Or (STIPFR = 'Z')             CIR005
     C                   MOVEL     'N'           WValBDC                        CIR005
     C                   MOVEL     'Y'           WFreqZ            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           WFreqZ                         CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
      *
      * Validate deal details
      *
     C                   CALLB     'IRSIRSVAL'
     C                   PARM                    @@MODE                         CIR005
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      RSRSCY        @@RSCY
     C                   PARM      RSRSTM        @@RSTM
     C                   PARM      RSRONS        @@RONS
     C                   PARM      RSPSCY        @@PSCY
     C                   PARM      RSPSTM        @@PSTM
     C                   PARM      RSPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    IRESIRS
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
                                                                                              CLE025
      ** Valid SIRS file                                                                      CLE025
      ** Valid extension SIRS file                                                            CLE025
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlXFilFmt                                  CLE025
      *                                                                                       184560
     C                   PARM                    SACCD                                        184560
     C                   PARM                    USLIP                                        184560
     C                   PARM                    TSLIP                                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    CrDlScnFmt                                   185057
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
                                                                                CIR005
      ** No error on validation, display business day convention input          CIR005
      ** screen.                                                                CIR005
                                                                                CIR005
     C                   IF        (CIR005 = 'Y') And (WFrstPas = 'Y')          CIR005
                                                                                CIR005
      ** Save previous Business Day Convention input                            CIR005
                                                                                CIR005
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   IF        BsDayConv <> *Blanks                         CIR005
     C                   MOVEL     BsDayConv     WSavBDC          64            CIR005
     C                   ENDIF                                                  CIR005
      ** IF CIR017 is ON                                                                      CIR017
     C                   ELSE                                                                 CIR017
     C                   IF        BsDayConvW <> *Blanks                                      CIR017
     C                   MOVEL     BsDayConvW    WSavBDC2                                     CIR017
     C                   ENDIF                                                                CIR017
     C                   ENDIF                                                                CIR017
                                                                                CIR005
      ** If no changes are allowed, protect (but still validate)                CIR005
      ** all business day convetion fields by passing an 'E' to action code     CIR005
                                                                                CIR005
     C                   IF        @OPSEL = 'N'                                 CIR005
     C                   MOVE      SACCD         WACCD             1            CIR005
     C                   MOVE      'E'           SACCD                          CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** First pass, display BDC input screen                                   CIR005
                                                                                CIR005
     C                   EXSR      SrBsDyC                                      CIR005
                                                                                CIR005
      ** Put back original action code when no changes are allowed              CIR005
                                                                                CIR005
     C                   IF        @OPSEL = 'N'                                 CIR005
     C                   MOVE      WACCD         SACCD                          CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   IF        (WFntKey = *Blank) And (WSndScn2 = 'N')      CIR005
     C                   EVAL      WSndScn2 = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** F12 pressed, back to main screen                                       CIR005
                                                                                CIR005
     C                   IF        WFntKey = '12'                               CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
                                                                                CIR005
      ** Put back business day convention details only when the previous        CIR005
      ** detail workfield is not blank                                          CIR005
                                                                                CIR005
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   IF        WSavBDC <> *Blank                            CIR005
     C                   EVAL      BsDayConv = WSavBDC                          CIR005
     C                   ELSE                                                   CIR005
     C                   EVAL      BsDayConv = *Blank                           CIR005
     C                   ENDIF                                                  CIR005
     C                   ELSE                                                                 CIR017
     C                   IF        WSavBDC2 <> *Blank                                         CIR017
     C                   EVAL      BsDayConvW = WSavBDC2                                      CIR017
     C                   ELSE                                                                 CIR017
     C                   EVAL      BsDayConvW = *Blank                                        CIR017
     C                   ENDIF                                                                CIR017
     C                   ENDIF                                                                CIR017
      **                                                                                      CIR017
     C                   EVAL      WFntKey = *Blank                             CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** F3 pressed, end program                                                CIR005
                                                                                CIR005
     C                   IF        WFntKey = '03'                               CIR005
     C                   EXSR      ENDP                                         CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** No error found on call to Business Day Convention                      CIR005
                                                                                CIR005
     C                   SELECT                                                 CIR005
                                                                                CIR005
      ** Enhancement CIR001(Schedule) is off.                                   CIR005
                                                                                CIR005
     C     CIR001        WHENEQ    'N'                                          CIR005
     C     WValBDC       ANDEQ     'N'                                          CIR005
     C     WFreqZ        ANDEQ     'N'                                          CIR005
     C     WFrstPas      ANDEQ     'Y'                                          CIR005
     C                   EVAL      WValBDC = 'Y'                                CIR005
     C                   EVAL      WFrstPas = 'N'                               CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
     C                   GOTO      EVAL@M                                       CIR005
                                                                                CIR005
      ** Enhancement CIR001 is on and the frequencies being used are 'Z'        CIR005
                                                                                CIR005
     C     CIR001        WHENEQ    'Y'                                          CIR005
     C                   IF        WFreqZ = 'Y'                                 CIR005
     C                   EVAL      @SCRN = 'X'                                  CIR005
     C                   ELSE                                                   CIR005
     C                   EVAL      WValBDC = 'Y'                                CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   EVAL      WFrstPas = 'N'                               CIR005
     C                   GOTO      EVAL@M                                       CIR005
                                                                                CIR005
      ** Otherwise, continue as normal                                          CIR005
                                                                                CIR005
     C                   OTHER                                                  CIR005
                                                                                CIR005
     C     BGWDPR        IFEQ      'Y'                                          CIR005
     C                   MOVEL     'W'           @SCRN                          CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'S'           @SCRN                          CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   GOTO      EVAL@M                                       CIR005
                                                                                CIR005
     C                   ENDSL                                                  CIR005
     C                                                                          CIR005
     C                   ENDIF                                                  CIR005
      *
      * If IRC feature is on, then call schedule dates module
      * Else, if feature no on;
      * Check if CAP041 is on, if yes, call Fees and Buy-out                                  CAP041
      * processing. If feature is not on and                                                  CAP041
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     CIR001        IFEQ      'Y'
     C                   MOVEL     'X'           @SCRN
     C                   ELSE
     C     CAP041        IFEQ      'Y'                                                        CAP041
     C                   MOVEL     'F'           @SCRN                                        CAP041
     C                   ELSE                                                                 CAP041
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
     C                   ENDIF                                                                CAP041
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
                                                                                CIR005
      *****************************************************************         CIR005
      *                                                               *         CIR005
      * SR/SrBsDyC: Business Day Convention Processing                *         CIR005
      *                                                               *         CIR005
      * Called By: VAL@M Subroutine                                   *         CIR005
      *                                                               *         CIR005
      * Calls:                                                        *         CIR005
      * IRBSDYDSP - Business Day Convention Single Currency Display   *         CIR005
      *             Module                                            *         CIR005
      * IRBSDYVAL - Business Day Convention Single Currency Valida -  *         CIR005
      *             tion Module                                       *         CIR005
      *                                                               *         CIR005
      *****************************************************************         CIR005
                                                                                CIR005
     C     SrBsDyC       BegSr                                                  CIR005
                                                                                CIR005
     C                   Eval      POkFlags = *All'Y'                           CIR005
     C                   Eval      IRESIRS = *All'Y'                            CIR005
     C                   Eval      FldNameErr = *Blanks                         CIR005
     C                   Eval      MsgIdErr = *Blanks                           CIR005
     C                   Eval      WFldNamErr = *Blanks                         CIR005
     C                   Eval      WMsgIdErr = *Blanks                          CIR005
     C                   Eval      WSavRC1 = *Blanks                            CIR005
                                                                                CIR005
      ** Send error messages to second screen                                   CIR005
                                                                                CIR005
     C                   If        (CIR005 = 'Y') And (WSndScn2 = 'N')          CIR005
     C                   ExSr      SNDM@B                                       CIR005
     C                   EndIf                                                  CIR005
                                                                                CIR005
      ** Do until F3 or F12 is pressed or all screen fields are valid.          CIR005
                                                                                CIR005
     C                   DoU       MsgIdErr(1) = *Blanks and                    CIR005
     C                             WrnFlag = 'N'  or                            CIR005
     C                             WFntKey = '03' or                            CIR005
     C                             WFntKey = '12'                               CIR005
                                                                                CIR005
     C                   Eval      WrnFlag = 'N'                                CIR005
                                                                                CIR005
      ** Initialise parameter WCallFunc with the correct value to make                        CIR017
      ** Call to IRSBDYDSP flexible whether CIR017 is ON or OFF                               CIR017
                                                                                              CIR017
     C                   If        CIR017 = 'Y'                                               CIR017
     C                   Eval      WCallFunc = '*SIRS'                                        CIR017
     C                   ELSE                                                                 CIR017
     C                   Eval      WCallFunc = *Blanks                                        CIR017
     C                   EndIf                                                                CIR017
      *                                                                                       CIR017
      ** Display screen fields                                                  CIR005
                                                                                CIR005
     C                   CallB     'IRSBDYDSP'                                  CIR005
     C**********         Parm      *Blanks       RetCodeOut                            CIR005 CIR017
     C                   Parm                    WCallFunc                                    CIR017
     C                   Parm                    SACCD                          CIR005
     C                   Parm                    SDLNO                          CIR005
     C                   Parm                    POkFlags                       CIR005
     C                   Parm                    MsgIdErr                       CIR005
     C                   Parm                    WMsgIdErr                      CIR005
     C                   Parm                    BJMRDT                         CIR005
     C**********         Parm                    BsDayConv                             CIR005 CIR017
     C                   Parm                    BsDayConvW                                   CIR017
     C                   Parm      *Blanks       WFntKey           2            CIR005
                                                                                CIR005
      ** Error on call, execute std database error program.                     CIR005
                                                                                CIR005
     C                   If        RetCodeOut <> *Blank                         CIR005
     C     *LOCK         In        LDA                                          CIR005
     C                   Movel     'IRCBDYDSP'   DBFILE                         CIR005
     C                   Z-Add     3             DBASE                          CIR005
     C                   Movel     SDLNO         DBKEY                          CIR005
     C                   Out       LDA                                          CIR005
     C                   ExSr      *PSSR                                        CIR005
     C                   EndIf                                                  CIR005
                                                                                CIR005
     C                   If        WFntKey <> '03' and                          CIR005
     C                             WFntKey <> '12' and                          CIR005
     C                             SACCD = 'I'  or                              CIR005
     C                             WFntKey <> '03' and                          CIR005
     C                             WFntKey <> '12' and                          CIR005
     C                             SACCD = 'A'  or                              CIR005
     C                             WFntKey <> '03' and                          CIR005
     C                             WFntKey <> '12' and                          CIR005
     C                             @OPSEL = 'N' and                             CIR005
     C                             SACCD = 'E'                                  CIR005
                                                                                CIR005
      ** Reset WCallFunc as it gets cleared out after Call above                              CIR017
      **                                                                                      CIR017
     C                   If        CIR017 = 'Y'                                               CIR017
     C                   Eval      WCallFunc = '*SIRS'                                        CIR017
     C                   ELSE                                                                 CIR017
     C                   Eval      WCallFunc = *Blanks                                        CIR017
     C                   EndIf                                                                CIR017
                                                                                              CIR017
      ** Validate all screen fields when action code is I or A.                 CIR005
                                                                                CIR005
     C                   CallB     'IRSBDYVAL'                                  CIR005
     C**********         Parm      *Blanks       RetCodeOut                            CIR005 CIR017
     C                   Parm                    WCallFunc                                    CIR017
     C                   Parm                    SACCD                          CIR005
     C                   Parm                    PLCcy             3            CIR005
     C                   Parm                    POkFlags                       CIR005
     C                   Parm      *Blanks       MsgIdErr                       CIR005
     C                   Parm                    FldNameErr                     CIR005
     C                   Parm      *Blanks       WMsgIdErr                      CIR005
     C                   Parm                    WFldNamErr                     CIR005
     C**********         Parm                    BsDayConv                             CIR005 CIR017
     C                   Parm                    BsDayConvW                                   CIR017
                                                                                CIR005
      ** Error on call, execute std database error program.                     CIR005
                                                                                CIR005
     C                   If        RetCodeOut <> *Blank                         CIR005
                                                                                CIR005
     C     *LOCK         In        LDA                                          CIR005
     C                   Movel     'IRCBDYDSP'   DBFILE                         CIR005
     C                   Z-Add     4             DBASE                          CIR005
     C                   Movel     SDLNO         DBKEY                          CIR005
     C                   Out       LDA                                          CIR005
     C                   ExSr      *PSSR                                        CIR005
     C                   EndIf                                                  CIR005
      *                                                                         CIR005
     C                   If        WMsgIdErr(1) <> *Blanks and                  CIR005
     C                             WSavRC1 <> RCcy1                             CIR005
     C                   Eval      WrnFlag = 'Y'                                CIR005
     C                   Endif                                                  CIR005
      *                                                                         CIR005
     C                   Eval      WSavRC1 = RCcy1                              CIR005
                                                                                CIR005
     C                   Endif                                                  CIR005
                                                                                CIR005
     C                   Enddo                                                  CIR005
                                                                                CIR005
     C                   EndSr                                                  CIR005
                                                                                CIR005
     C*****************************************************************
     C*                                                               *
     C*  SCHEDULES - Display Schedule Input                           *
     C*                                                               *
     C*  Called by  : MAIN   - Main Processing Routine                *
     C*                                                               *
     C*  Calls      : IRSIRSCHD - Date schedule controller            *
     C*                                                               *
     C*****************************************************************
     C     SCHEDULES     BEGSR
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     SDLNO         IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1
     C                   PARM                    I#SDLNO
     C                   PARM      *ZERO         RSDLNO
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     SDLNO         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C*                                                                         168444
     C* If this is an insert or amend of a deal                                 168444
     C* Retrieve its 'invalid' date schedule                                    168444
     C*                                                                         168444
     C     SACCD         IFEQ      'I'                                          168444
     C     SACCD         OREQ      'A'                                          168444
                                                                                              CAP043
      ** Do until all corresponding records from IRIDTSCPD have been processed                CAP043
                                                                                              CAP043
     C     ZATRNKD0      SETLL     IRIDTSCL1                                                  CAP043
     C     ZATRNKD0      READE     IRIDTSCL1                                                  CAP043
                                                                                              CAP043
      ** Initialise previous date parameter field                                             CAP043
                                                                                              CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   EVAL      PUpdate = 'N'                                              CAP043
     C                   EVAL      PErrorFndDt = 'NNNN'                                       CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRIDTSCL1)                                        CAP043
                                                                                              CAP043
      ** Set currency parameter and business day convention fields according to               CAP043
      ** our/their indicator                                                                  CAP043
                                                                                              CAP043
     C                   EVAL      PCurrency = SUCUCY                                         CAP043
     C                   EVAL      PBDConvtn = RCCY1                                          CAP043
                                                                                              CAP043
     C                   CALLB     'IRIDTSCRT'                                  168444
     C                   PARM                    ReturnCode                     168444
     C**********         PARM                    @FOTRANSEL                            168444 CAP043
     C**********         PARM                    @TMESTPSEL                            168444 CAP043
     C                   PARM                    SDLNO                          168444
     C                   PARM                    I#SDLNO                        168444
     C                   PARM                    RSVDAT                         168444
     C                   PARM                    RSMDAT                         168444
     C                   PARM                    BJDFIN                         168444
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM                    PUpdate                                      CAP043
     C                   PARM                    PErrorFndDt                                  CAP043
     C                   PARM                    PInDTSCDS                                    CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PBDConvtn                                    CAP043
                                                                                              CAP043
     C                   EVAL      WOurThr = SOURTHR                                          CAP043
     C                   EVAL      WRatPay = SRATPAY                                          CAP043
                                                                                              CAP043
     C     ZATRNKD0      READE     IRIDTSCL1                                                  CAP043
                                                                                              CAP043
      ** Initialise PPrevDate when key fields change                                          CAP043
                                                                                              CAP043
     C                   IF        NOT %EOF(IRIDTSCL1)                                        CAP043
     C                   IF        (WOurThr <> SOURTHR) OR (WRatPay <> SRATPAY)               CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If *EOF or an error occurred upon call to IRIDTSCRT set update                       CAP043
      ** indicator to 'Y'                                                                     CAP043
                                                                                              CAP043
     C                   IF        %EOF(IRIDTSCL1)                                            CAP043
     C                   EVAL      PUpdate = 'Y'                                              CAP043
     C                   EXSR      SRIDTSC                                                    CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Do until all corresponding records from IRICFSCPD have been processed                CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C     ZATRNKD0      SETLL     IRICFSCL0                                                  CAP043
     C     ZATRNKD0      READE     IRICFSCL0                                                  CAP043
                                                                                              CAP043
      ** Initialise previous date parameter field                                             CAP043
                                                                                              CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   EVAL      PUpdate = 'N'                                              CAP043
     C                   EVAL      PErrorFndCs = 'NN'                                         CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRICFSCL0)                                        CAP043
                                                                                              CAP043
      ** Set currency parameter and business day convention fields according to               CAP043
      ** our/their indicator                                                                  CAP043
                                                                                              CAP043
     C                   EVAL      PCurrency = SUCUCY                                         CAP043
     C                   EVAL      PBDConvtn = RCCY1                                          CAP043
                                                                                              CAP043
     C                   EXSR      SRICFSC                                                    CAP043
                                                                                              CAP043
     C                   EVAL      WOurThr = CISOURTHR                                        CAP043
                                                                                              CAP043
     C     ZATRNKD0      READE     IRICFSCL0                                                  CAP043
                                                                                              CAP043
      ** Initialise PPrevDate when key fields change                                          CAP043
                                                                                              CAP043
     C                   IF        NOT %EOF(IRICFSCL0)                                        CAP043
     C                   IF        WOurThr <> CISOURTHR                                       CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If *EOF or an error occurred upon call to IRICFSCRT set update                       CAP043
      ** indicator to 'Y'                                                                     CAP043
                                                                                              CAP043
     C                   IF        %EOF(IRICFSCL0)                                            CAP043
     C                   EVAL      PUpdate = 'Y'                                              CAP043
     C                   EXSR      SRICFSC                                                    CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Do until all corresponding records from IRIPCSCPD have been processed                CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C     ZATRNKD0      SETLL     IRIPCSCL0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCL0                                                  CAP043
                                                                                              CAP043
      ** Initialise previous date parameter field                                             CAP043
                                                                                              CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   EVAL      PUpdate = 'N'                                              CAP043
     C                   EVAL      PErrorFndPr = 'NN'                                         CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRIPCSCL0)                                        CAP043
                                                                                              CAP043
      ** Set currency parameter and business day convention fields according to               CAP043
      ** our/their indicator                                                                  CAP043
                                                                                              CAP043
     C                   EVAL      PCurrency = SUCUCY                                         CAP043
     C                   EVAL      PBDConvtn = RCCY1                                          CAP043
     C                   EVAL      PCtlDate = RSUNPCD                                         CAP043
     C                   EVAL      PPAmt = RSUPAMT                                            CAP043
                                                                                              CAP043
     C                   EXSR      SRIPCSC                                                    CAP043
                                                                                              CAP043
     C                   EVAL      WOurThr = PITOURTHR                                        CAP043
                                                                                              CAP043
     C     ZATRNKD0      READE     IRIPCSCL0                                                  CAP043
                                                                                              CAP043
      ** Initialise PPrevDate when key fields change                                          CAP043
                                                                                              CAP043
     C                   IF        NOT %EOF(IRIPCSCL0)                                        CAP043
     C                   IF        WOurThr <> PITOURTHR                                       CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If *EOF or an error occurred upon call to IRIPCSCRT set update                       CAP043
      ** indicator to 'Y'                                                                     CAP043
                                                                                              CAP043
     C                   IF        %EOF(IRIPCSCL0)                                            CAP043
     C                   EVAL      PUpdate = 'Y'                                              CAP043
     C                   EXSR      SRIPCSC                                                    CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                  168444
     C*
     C* Call schedule controlling module
     C*
     C                   CALLB     'IRSIRSCHD'
     C                   PARM                    RetCodeIn
     C                   PARM                    Mode              1
     C                   PARM                    NwDlScnFmt
     C                   PARM                    I#SDLNO
     C                   PARM                    RSRSCY
     C                   PARM                    RSPSCY
     C                   PARM                    RSMDAT
     C                   PARM                    RSVDAT
     C                   PARM                    BJDFIN
     C                   PARM                    @WerrAr
      *
      * Reset Mode parameter
      *
     C                   EVAL      Mode = *BLANK
     C*
     C* For each warning error code received, set up a message to be
     C* sent to the screen
     C*
     C                   Z-ADD     1             C                 2 0
     C     C             DOWLE     10
     C     @WERRAR(C)    ANDNE     *BLANKS
     C                   MOVEL     @WERRAR(C)    @WERRMS           7
     C                   EXSR      SNDW@M
     C                   ADD       1             C
     C                   END
     C*
     C* Set screen indicator or exit according to return code,
     C* i.e. F3, F12 or enter pressed
     C*
     C     RetCodeIn     IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   END
     C*
     C* If F12, go to main screen or process multiple browse selection
     C*
     C     RetCodeIn     IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
     C                   END
     C                   END
     C*
      ** If enter is pressed and CAP041 is on, call Fees and Buy-out                          CAP041
      ** processing. Otherwise if feature CAP041 is not on and                                CAP041
     C* If enter pressed, call window manager (if window processing set on)
     C* otherwise go to settlements, if not enquiry. If enquiry, call window
     C* and either return to main screen or read next browse subfile record
     C*
     C     RetCodeIn     IFEQ      *BLANKS
     C     CAP041        IFEQ      'Y'                                                        CAP041
     C                   MOVEL     'F'           @SCRN                                        CAP041
     C                   ELSE                                                                 CAP041
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     SACCD         IFNE      'E'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CAP041
     C                   ENDIF
     C*
     C                   ENDSR
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRIDTSC - Call to IRIDTSCRT                                      *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRIDTSC       BEGSR                                                                CAP043
                                                                                              CAP043
     C                   CALLB     'IRIDTSCRT'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    SDLNO                                        CAP043
     C                   PARM                    I#SDLNO                                      CAP043
     C                   PARM                    RSVDAT                                       CAP043
     C                   PARM                    RSMDAT                                       CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM                    PUpdate                                      CAP043
     C                   PARM                    PErrorFndDt                                  CAP043
     C                   PARM                    PInDTSCDS                                    CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PBDConvtn                                    CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRICFSC - Call to IRICFSCRT                                      *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRICFSC       BEGSR                                                                CAP043
                                                                                              CAP043
     C                   CALLB     'IRICFSCRT'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    SDLNO                                        CAP043
     C                   PARM                    I#SDLNO                                      CAP043
     C                   PARM                    RSVDAT                                       CAP043
     C                   PARM                    RSMDAT                                       CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM                    PUpdate                                      CAP043
     C                   PARM                    PErrorFndCs                                  CAP043
     C                   PARM                    PInCFSCDS                                    CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PBDConvtn                                    CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRIPCSC - Call to IRIPCSCRT                                      *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRIPCSC       BEGSR                                                                CAP043
                                                                                              CAP043
     C                   CALLB     'IRIPCSCRT'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    SDLNO                                        CAP043
     C                   PARM                    I#SDLNO                                      CAP043
     C                   PARM                    RSVDAT                                       CAP043
     C                   PARM                    RSMDAT                                       CAP043
     C**********         PARM                    BGN2ST                              CAP043 MD054117
     C                   PARM                    PCIDCF                                     MD054117
     C                   PARM                    PCtlDate                                     CAP043
     C                   PARM                    PPAmt                                        CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM                    PUpdate                                      CAP043
     C                   PARM                    PErrorFndPr                                  CAP043
     C                   PARM                    PInPCSCDS                                    CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PBDConvtn                                    CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRFBProc - Fees and Buy-outs processing                      *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRFBProc      BEGSR                                                                CAP041
      *                                                                                       CAP041
      ** Disable detail fields if action is 'I' or 'A' and option                             CAP041
      ** is not 'U'                                                                           CAP041
     C                   IF        @OPSEL = 'U' AND                                           CAP041
     C                             (SACCD = 'A' OR SACCD = 'I')                               CAP041
     C                   EVAL      @EDTFD = 'Y'                                               CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      @EDTFD = 'N'                                               CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Send error messages to Fees and Buy-outs screen                                      CAP041
                                                                                              CAP041
     C                   IF        WRsnd <> 'Y'                                               CAP041
     C                   EXSR      SNDM@F                                                     CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Convert Fees and Buy-out screen                                                      CAP041
     C                   EXSR      SRFBConv                                                   CAP041
      *                                                                                       CAP041
      ** Display Fees/Buy-Outs screen fields                                                  CAP041
      *                                                                                       CAP041
     C                   CALLB     'IRFEBODSP'                                                CAP041
      *                                                                                       CAP041
      ** INPUTS                                                                               CAP041
      ** ======                                                                               CAP041
     C                   PARM      *BLANKS       RetCodeIn                                    CAP041
      *                                                                                       CAP041
      ** Transaction Details                                                                  CAP041
     C                   PARM                    NwFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** Extra details for screen                                                             CAP041
     C                   PARM                    NwFBScnFld                                   CAP041
      *                                                                                       CAP041
      ** OUTPUTS                                                                              CAP041
      ** =======                                                                              CAP041
      *                                                                                       CAP041
      ** OK Flags                                                                             CAP041
     C                   PARM                    OKFEBO                                       CAP041
      *                                                                                       CAP041
      ** Error messages                                                                       CAP041
     C                   PARM                    FldNameArr                                   CAP041
     C                   PARM                    MsgIdArr                                     CAP041
     C                   PARM                    MsgDtaArr                                    CAP041
      *                                                                                       CAP041
     C                   PARM                    WFldNamArr                                   CAP041
     C                   PARM                    WMsgIDArr                                    CAP041
     C                   PARM                    WMsgDtaArr                                   CAP041
      *                                                                                       CAP041
      ** Enable details fields                                                                CAP041
     C                   PARM                    @EDTFD                                       CAP041
      *                                                                                       CAP041
      ** Enabled Function keys                                                                CAP041
     C                   PARM      '0'           @INKC                                        CAP041
     C                   PARM      '0'           @INKH                                        CAP041
     C                   PARM      '0'           @INKL                                        CAP041
      *                                                                                       CAP041
      ** Deal info passed from calling programs                                               CAP041
     C                   PARM                    DATA                                         CAP041
      *                                                                                       CAP041
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   CAP041
      *                                                                                       CAP041
      ** Reset error fields                                                                   CAP041
      *                                                                                       CAP041
     C                   Z-ADD     0             Idx                                          CAP041
     C                   Z-ADD     0             WIdx                                         CAP041
     C                   EVAL      OKFEBO = *ALL'Y'                                           CAP041
     C                   EVAL      FldNameArr = *BLANKS                                       CAP041
     C                   EVAL      MsgIdArr = *BLANKS                                         CAP041
     C                   EVAL      MsgDtaArr = *BLANKS                                        CAP041
     C                   EVAL      WFldNamArr = *BLANKS                                       CAP041
     C                   EVAL      WMsgIdArr = *BLANKS                                        CAP041
     C                   EVAL      WMsgDtaArr = *BLANKS                                       CAP041
      *                                                                                       CAP041
     C                   SELECT                                                               CAP041
      *                                                                                       CAP041
      ** F3 - End program                                                                     CAP041
     C                   WHEN      @INKC = *ON                                                CAP041
     C                   EXSR      ENDP                                                       CAP041
      *                                                                                       CAP041
      ** F12 - Cancel                                                                         CAP041
     C                   WHEN      @INKL = *ON                                                CAP041
     C                   IF        CIR001 = 'Y'                                               CAP041
     C                   EVAL      @SCRN = 'X'                                                CAP041
     C                   EVAL      Mode = 'B'                                                 CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      @SCRN = 'M'                                                CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   OTHER                                                                CAP041
      *                                                                                       CAP041
      ** Validate if action is Insert or Amend                                                CAP041
     C                   IF        @OPSEL = 'U' AND                                           CAP041
     C                             (SACCD = 'A' OR SACCD = 'I')                               CAP041
     C                   EXSR      SRValF                                                     CAP041
     C                   GOTO      EndFBProc                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Go to window processing if window flag is 'Y'                                        CAP041
     C                   IF        BGWDPR = 'Y'                                               CAP041
     C                   EVAL      @SCRN = 'W'                                                CAP041
     C                   GOTO      EndFBProc                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Go to extended settlement screen if not enquiry                                      CAP041
     C                   IF        SACCD <> 'E'                                               CAP041
     C                   EXSR      SRFileFlds                                                 CAP041
     C                   EVAL      @SCRN = 'S'                                                CAP041
     C                   GOTO      EndFBProc                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** If records are still to be read from the subfile read them                           CAP041
      ** Else return to browse screen                                                         CAP041
     C                   IF        @RDNB = 'Y'                                                CAP041
     C                   EVAL      @SCRN = 'R'                                                CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      @SCRN = 'B'                                                CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDSL                                                                CAP041
      *                                                                                       CAP041
     C     EndFBProc     ENDSR                                                                CAP041
      *                                                                                       CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRFBConv - Convert Fees and Buy-out screen                   *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
     C     SRFBConv      BEGSR                                                                CAP041
      *                                                                                       CAP041
      ** Set up details of DS DATA                                                            CAP041
     C/COPY QWINDSRC,IRSIRSMOV1                                                               CAP041
      *                                                                                       CAP041
      ** Set up Our/Their number of decimal places.                                           CAP041
     C                   CALL      'AOCURRR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd             7                          CAP041
     C                   PARM      '*KEY   '     POptn             7                          CAP041
     C                   PARM      #1UCUC        PCcy              3                          CAP041
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP041
                                                                                              CAP041
     C                   EVAL      PWUCDP = A6NBDP                                            CAP041
                                                                                              CAP041
     C                   IF        #1TCUC <> *BLANKS                                          CAP041
                                                                                              CAP041
     C                   CALL      'AOCURRR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd                                        CAP041
     C                   PARM      '*KEY   '     POptn                                        CAP041
     C                   PARM      #1TCUC        PCcy                                         CAP041
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP041
                                                                                              CAP041
     C                   EVAL      PWTCDP = A6NBDP                                            CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      PWTCDP = A6NBDP                                            CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Set up Settlement & Receivers currency.                                              CAP041
                                                                                              CAP041
     C                   IF        CEU003 = 'Y' AND #1PSCY <> *BLANKS                         CAP041
     C                   MOVEL     #1PSCY        PWPSCY                                       CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     #1UCUC        PWPSCY                                       CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   IF        CEU003 = 'Y' AND #1RSCY <> *BLANKS                         CAP041
     C                   MOVEL     #1RSCY        PWRSCY                                       CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     #1TCUC        PWRSCY                                       CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
      ** Access nostro location for our-effective-settlement-currency                         CAP041
                                                                                              CAP041
     C                   IF        PWPSCY <> *BLANKS                                          CAP041
                                                                                              CAP041
     C                   CALL      'AONOSTR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd                                        CAP041
     C                   PARM      '*KEY   '     POptn                                        CAP041
     C                   PARM      *BLANK        PCust                                        CAP041
     C                   PARM      PWPSCY        PCcy                                         CAP041
     C                   PARM      *BLANKS       PAccd                                        CAP041
     C                   PARM      *BLANKS       PAcsn                                        CAP041
     C                   PARM      #1UNON        PNost                                        CAP041
     C                   PARM      *BLANKS       PBrcd                                        CAP041
     C                   PARM      *BLANKS       PCssn                                        CAP041
     C                   PARM      *BLANKS       Pinoy                                        CAP041
     C     SDNOST        PARM      SDNOST        DSFDY                                        CAP041
                                                                                              CAP041
     C                   IF        PRtcd = *BLANKS                                            CAP041
     C                   MOVE      A7NOSN        PWPNLOC                                      CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVE      *BLANKS       PWPNLOC                                      CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
      ** Access nostro location for their-effective-settlement-currency                       CAP041
                                                                                              CAP041
     C                   IF        PWRSCY <> *BLANKS                                          CAP041
                                                                                              CAP041
     C                   CALL      'AONOSTR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd                                        CAP041
     C                   PARM      '*KEY   '     POptn                                        CAP041
     C                   PARM      *BLANK        PCust             6                          CAP041
     C                   PARM      PWRSCY        PCcy                                         CAP041
     C**********         PARM      *BLANKS       PAccd             4                   CAP041 CGL029
     C                   PARM      *BLANKS       PAccd            10                          CGL029
     C                   PARM      *BLANKS       PAcsn             2                          CAP041
     C                   PARM      #1TNON        PNost             2 0                        CAP041
     C                   PARM      *BLANKS       PBrcd             3                          CAP041
     C                   PARM      *BLANKS       PCssn            10                          CAP041
     C                   PARM      *BLANKS       Pinoy             1                          CAP041
     C     SDNOST        PARM      SDNOST        DSFDY                                        CAP041
                                                                                              CAP041
     C                   IF        PRtcd = *BLANKS                                            CAP041
     C                   MOVE      A7NOSN        PWRNLOC                                      CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVE      A7NOSN        PWRNLOC                                      CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Set up other fields                                                                  CAP041
     C                   EVAL      SFSDLNO  = SDLNO                                           CAP041
     C                   EVAL      SFSACTN  = SACCD                                           CAP041
     C                   EVAL      SFSDTYP  = SDTYP                                           CAP041
     C                   EVAL      SFSDLST  = SDLST                                           CAP041
     C                   EVAL      SFSDDAT  = SDDAT                                           CAP041
     C                   EVAL      SFSBRCA  = SBRCA                                           CAP041
     C                   EVAL      SFSBRKC  = SBRKC                                           CAP041
     C                   EVAL      SFSBAGE  = SBAGE                                           CAP041
     C                   EVAL      SFSLNKDN = SLNKDN                                          CAP041
     C                   EVAL      SFSCNUM  = SCNUM                                           CAP041
     C                   EVAL      SFSVDAT  = SVDAT                                           CAP041
     C                   EVAL      SFSMDAT  = SMDAT                                           CAP041
     C                   EVAL      SFSCDAS  = SCDAS                                           CAP041
     C                   EVAL      SFSUCUCY = SUCUCY                                          CAP041
     C                   EVAL      SFSUPAMT = SUPAMT                                          CAP041
     C                   EVAL      SFSUICF  = UICFR                                           CAP041
     C                   EVAL      SFSTICF  = TICFR                                           CAP041
     C                   EVAL      SFSOREDM = ORED                                            CAP041
     C                   MOVEL     TUSI          SFSTUSI                                      CAP041
     C                   MOVEL     TUSA          SFSTUSA                                      CAP041
     C                   MOVEL     OUSI          SFSOUSI                                      CAP041
     C                   MOVEL     OUSA          SFSOUSA                                      CAP041
      *                                                                                       CAP041
     C                   EVAL      SFSOIPM  = SOIPM                                           CAP041
     C                   EVAL      SFSONPCD = SONPCD                                          CAP041
     C                   EVAL      SFSTIPM  = STIPM                                           CAP041
     C                   EVAL      SFSTNPCD = STNPCD                                          CAP041
     C                   EVAL      SFSUFVD  = SUFVD                                           CAP041
     C                   EVAL      SFSUFEE  = SUFEE                                           CAP041
     C                   EVAL      SFSUFPR  = SUFPR                                           CAP041
     C                   EVAL      SFSBOVD  = SBOVD                                           CAP041
     C                   EVAL      SFSBUYA  = SBUYA                                           CAP041
     C                   EVAL      SFSBOPR  = SBOPR                                           CAP041
      *                                                                                       CAP041
     C                   ENDSR                                                                CAP041
      *                                                                                       CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRValF - Validate Fees and Buy-out details                   *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRValF        BEGSR                                                                CAP041
      *                                                                                       CAP041
      ** Check for amendable fields                                                           CAP041
      *                                                                                       CAP041
                                                                                              CAP041
     C                   CALLB     'IRSFBOAMD'                                                CAP041
      *                                                                                       CAP041
      ** INPUT                                                                                CAP041
      ** =====                                                                                CAP041
      *                                                                                       CAP041
      ** Return Code                                                                          CAP041
     C                   PARM                    ReturnCode                                   CAP041
      *                                                                                       CAP041
      ** Transaction Details                                                                  CAP041
     C                   PARM                    NwFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** Transaction Details retrieved from file - in screen                                  CAP041
     C                   PARM                    CrFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** Deal information details                                                             CAP041
     C                   PARM                    Data                                         CAP041
      *                                                                                       CAP041
      ** Reset of Fields in Error Required (Y/N)                                              CAP041
     C                   PARM      'N'           PResetFld         1                          CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Our)                                   CAP041
     C                   PARM                    PWUCDP                                       CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Their)                                 CAP041
     C                   PARM                    PWTCDP                                       CAP041
      *                                                                                       CAP041
      ** STANDING DATA                                                                        CAP041
      ** =============                                                                        CAP041
      *                                                                                       CAP041
      ** SDBANK - Rundate                                                                     CAP041
     C                   PARM                    BJRDNB                                       CAP041
      *                                                                                       CAP041
      ** SWITCHABLE FEATURES                                                                  CAP041
      ** ===================                                                                  CAP041
      *                                                                                       CAP041
      ** Overnight index swaps                                                                CAP041
     C                   PARM                    CIR007                                       CAP041
      *                                                                                       CAP041
      ** OUTPUT                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      ** Error fields/message Ids/message data (arrays) from/to caller                        CAP041
     C                   PARM                    FldNameArr                                   CAP041
     C                   PARM                    MsgIdArr                                     CAP041
     C                   PARM                    MsgDtaArr                                    CAP041
      *                                                                                       CAP041
      ** Array index (3P0) from/to caller                                                     CAP041
     C                   PARM                    Idx                                          CAP041
      *                                                                                       CAP041
      ** Transaction Details OK inds                                                          CAP041
     C                   PARM                    OKFEBO                                       CAP041
      *                                                                                       CAP041
      ** OK Amendments field                                                                  CAP041
     C                   PARM                    PAmendOk                                     CAP041
     C                   PARM                    BNDCSP                                       245692
                                                                                              CAP041
     C                   CALLB     'IRSFBOVAL'                                                CAP041
      *                                                                                       CAP041
      ** INPUTS                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      * Response mode                                                                         CAP041
     C                   PARM                    RespMode                                     CAP041
      *                                                                                       CAP041
      ** Transaction Details                                                                  CAP041
     C                   PARM                    NwFBScnFmt                                   CAP041
      *                                                                                       233467
      ** Deal Number                                                                          233467
     C                   PARM                    vDLNO                                        233467
      *                                                                                       CAP041
      ** OTHERS                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Our)                                   CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Their)                                 CAP041
     C                   PARM                    PWUCDP                                       CAP041
     C                   PARM                    PWTCDP                                       CAP041
      *                                                                                       CAP041
      ** Settlement currency                                                                  CAP041
      ** Receivers currency                                                                   CAP041
     C                   PARM                    PWPSCY                                       CAP041
     C                   PARM                    PWRSCY                                       CAP041
      *                                                                                       CAP041
      ** Nostro Locations                                                                     CAP041
     C                   PARM                    PWPNLOC                                      CAP041
     C                   PARM                    PWRNLOC                                      CAP041
      *                                                                                       CAP041
      ** OUTPUTS                                                                              CAP041
      ** =======                                                                              CAP041
      *                                                                                       CAP041
      ** Transaction Details OK inds                                                          CAP041
     C                   PARM                    OKFEBO                                       CAP041
                                                                                              CAP041
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP041
     C                   PARM                    FldNameArr                                   CAP041
     C                   PARM                    MsgIDArr                                     CAP041
     C                   PARM                    MsgDtaArr                                    CAP041
                                                                                              CAP041
      * Array index (3P0) from/to caller                                                      CAP041
     C                   PARM                    Idx                                          CAP041
                                                                                              CAP041
      * Warning fields/message IDs/message data (arrays) from/to caller                       CAP041
     C                   PARM                    WFldNamArr                                   CAP041
     C                   PARM                    WMsgIDArr                                    CAP041
     C                   PARM                    WMsgDtaArr                                   CAP041
                                                                                              CAP041
      * Array index (3P0) from/to caller                                                      CAP041
     C                   PARM                    WIdx                                         CAP041
      *                                                                                       CAP041
      ** Deal info passed from calling programs                                               CAP041
     C                   PARM                    DATA                                         CAP041
     C                   PARM                    BNDCSP                                       245692
      *                                                                                       CAP041
      ** If no errors occurred during validation of fields                                    CAP041
      ** check if there are warnings which have not been                                      CAP041
      ** displayed yet.                                                                       CAP041
      *                                                                                       CAP041
     C                   EVAL      WRedisplay = *BLANK                                        CAP041
     C                   IF        IdX = 0                                                    CAP041
     C                   Z-ADD     1             WiX                                          CAP041
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK                        CAP041
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                          CAP041
     C                   EVAL      WRedisplay = 'Y'                                           CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      WiX = WiX + 1                                              CAP041
     C                   ENDIF                                                                CAP041
     C                   ENDDO                                                                CAP041
      *                                                                                       CAP041
      ** Reset errors                                                                         CAP041
     C                   IF        WRedisplay <> 'Y'                                          CAP041
      *                                                                                       CAP041
     C                   Z-ADD     0             Idx                                          CAP041
     C                   Z-ADD     0             WIdx                                         CAP041
     C                   MOVE      *ALL'Y'       OKFEBO                                       CAP041
     C                   MOVEL     *BLANK        FldNameArr                                   CAP041
     C                   MOVEL     *BLANK        MsgIdArr                                     CAP041
     C                   MOVEL     *BLANK        MsgDtaArr                                    CAP041
     C                   MOVEL     *BLANK        WFldNamArr                                   CAP041
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAP041
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAP041
     C                   ENDIF                                                                CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Redisplay Level 1 screen if there are errors or if there                             CAP041
      ** are warnings which have not been displayed yet.                                      CAP041
      *                                                                                       CAP041
     C                   IF        IdX <> 0 OR WRedisplay = 'Y'                               CAP041
     C                   GOTO      ESRValF                                                    CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Process principal rate change schedules if no errors                                 CAP041
      *                                                                                       CAP041
     C                   IF        SFSONPCD <> *BLANKS                                        CAP041
     C                   EXSR      SRPrinSked                                                 CAP041
      *                                                                                       CAP041
      ** F3 - Terminate program                                                               CAP041
     C                   IF        PRTCD = 'Y2U9999'                                          CAP041
     C                   EXSR      ENDP                                                       CAP041
     C                   GOTO      ESRValF                                                    CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** F12 or there are outstanding errors, redisplay screen                                CAP041
     C                   IF        PRTCD = 'USR0790' OR                                       CAP041
     C                             OKONPCD = 'N'                                              CAP041
     C                   GOTO      ESRValF                                                    CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** If no errors, set file fields                                                        CAP041
     C                   EXSR      SRFileFlds                                                 CAP041
     C                   IF        BGWDPR = 'Y'                                               CAP041
     C                   EVAL      @SCRN = 'W'                                                CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      @SCRN = 'S'                                                CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C     ESRValF       ENDSR                                                                CAP041
      *                                                                                       CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRPrinSked - Validate Principal Change Schedules             *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRPrinSked    BEGSR                                                                CAP041
      *                                                                                       CAP041
     C                   CALLB     'IRSPCDSHD'                                                CAP041
      *                                                                                       CAP041
      ** INPUT                                                                                CAP041
      ** =====                                                                                CAP041
      *                                                                                       CAP041
      ** Return Code                                                                          CAP041
     C                   PARM                    PRTCD                                        CAP041
      *                                                                                       CAP041
      ** Transaction Details                                                                  CAP041
     C                   PARM                    NwFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** Settlement currency                                                                  CAP041
     C                   PARM                    PWPSCY                                       CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Our)                                   CAP041
     C                   PARM                    PWUCDP                                       CAP041
      *                                                                                       CAP041
      ** STANDING DATA                                                                        CAP041
      ** =============                                                                        CAP041
     C                   PARM                    BJDFIN                                       CAP041
      *                                                                                       CAP041
      ** SWITCHABLE FEATURES                                                                  CAP041
      ** ===================                                                                  CAP041
      *                                                                                       CAP041
      ** FRA/IRS Amortisation of Caps/Collars/Floors &                                        CAP041
      ** Individual Compounding Swaps                                                         CAP041
     C                   PARM                    CIR006                                       CAP041
      *                                                                                       CAP041
      ** OUTPUT                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      ** Error fields/message Ids/message data (arrays) from/to caller                        CAP041
     C                   PARM                    FldNameArr                                   CAP041
     C                   PARM                    MsgIdArr                                     CAP041
     C                   PARM                    MsgDtaArr                                    CAP041
      *                                                                                       CAP041
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CAP041
     C                   PARM                    WFldNamArr                                   CAP041
     C                   PARM                    WMsgIDArr                                    CAP041
     C                   PARM                    WMsgDtaArr                                   CAP041
      *                                                                                       CAP041
      ** Transaction Details OK inds                                                          CAP041
     C                   PARM                    OKFEBO                                       CAP041
      *                                                                                       CAP041
      ** Deal information details                                                             CAP041
     C                   PARM                    DATA                                         CAP041
      *                                                                                       CAP041
     C                   ENDSR                                                                CAP041
      *                                                                                       CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRFileFlds - Set up file fields                              *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRFileFlds    BEGSR                                                                CAP041
      *                                                                                       CAP041
      ** If any of the Up-front fee details have been                                         CAP041
      ** amended, set Confirmation Required indicator to Y                                    CAP041
      ** otherwise, set to N.                                                                 CAP041
      *                                                                                       CAP041
     C                   IF        #1UPVD <> RSUPVD OR                                        CAP041
     C                             #1UPFE <> RSUPFE OR                                        CAP041
     C                             #1UPPR <> RSUPPR                                           CAP041
     C                   EVAL      #1CNRQ = 'Y'                                               CAP041
     C                   EXSR      SRUpdUpF                                                   CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      #1CNRQ = 'N'                                               CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   EVAL      SOIPM  = SFSOIPM                                           CAP041
     C                   EVAL      SONPCD = SFSONPCD                                          CAP041
     C                   EVAL      STIPM  = SFSTIPM                                           CAP041
     C                   EVAL      STNPCD = SFSTNPCD                                          CAP041
     C                   EVAL      SUFVD  = SFSUFVD                                           CAP041
     C                   EVAL      SUFEE  = SFSUFEE                                           CAP041
     C                   EVAL      SUFPR  = SFSUFPR                                           CAP041
     C                   EVAL      SBOVD  = SFSBOVD                                           CAP041
     C                   EVAL      SBUYA  = SFSBUYA                                           CAP041
     C                   EVAL      SBOPR  = SFSBOPR                                           CAP041
      *                                                                                       CAP041
     C/COPY QWINDSRC,IRSIRSMOV2                                                               CAP041
     C                   ENDSR                                                                CAP041
                                                                                              CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *                       CAP041
      *              value date, fee and P/R indicator                *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRUpdUpF      BEGSR                                                                CAP041
      *                                                                                       CAP041
     C     #1ACTN        IFEQ      'A'                                                        CAP041
     C                   MOVE      #1DLNO        DDLNO             6 0                        CAP041
     C     DDLNO         CHAIN     DLDGUPL1                           01                      CAP041
      *                                                                                       CAP041
     C                   IF        *IN01                                                      CAP041
     C                   MOVE      DDLNO         DLNO                                         CAP041
     C**********         MOVE      #1UPVD        UPVD                                  CAP041 185064
     C**********         MOVE      #1UPFE        UPFE                                  CAP041 185064
     C**********         MOVE      #1UPPR        UPPR                                  CAP041 185064
     C                   MOVE      RSUPVD        UPVD                                         185064
     C                   MOVE      RSUPFE        UPFE                                         185064
     C                   MOVE      RSUPPR        UPPR                                         185064
     C                   WRITE     DLDGREFF                                                   CAP041
     C                   ELSE                                                                 CAP041
     C**********         MOVE      #1UPFE        UPFE                                  CAP041 185064
     C**********         MOVE      #1UPVD        UPVD                                  CAP041 185064
     C**********         MOVE      #1UPPR        UPPR                                  CAP041 185064
     C                   MOVE      RSUPVD        UPVD                                         185064
     C                   MOVE      RSUPFE        UPFE                                         185064
     C                   MOVE      RSUPPR        UPPR                                         185064
     C                   UPDATE    DLDGREF                                                    CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDSR                                                                CAP041
     C*****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       IRESIRS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'IRSIRSDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
      *
      * FIELDS IN ERROR
     C                   PARM                    IRESIRS
     C/COPY WNCPYSRC,IRH00036
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      'Y'           WriteOnly         1
      *
      * If deal number not defined (on insert),
      * get next available deal number
      * This routine will already be called if the Interest Rate
      * Calendar feature is present, therefore condition call on this
      * switch
      *
     C     SDLNO         IFEQ      *BLANK
     C     CIR001        ANDNE     'Y'
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#SDLNO           6
     C                   PARM      *ZERO         RSDLNO
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     SDLNO         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
     C                   IF        CAP041 <> 'Y'                                              CAP041
     C/COPY QWINDSRC,IRSIRSMOV1
     C                   ENDIF                                                                CAP041
      *
      ** If CAP041 is switched on, set window program to 'IRSIRSRPX'                          CAP041
      ** This will bypass the calling of DL1600WC attached to                                 CAP041
      ** 'IRSIRSRPR' in SDMREFPD window file.                                                 CAP041
      *                                                                                       CAP041
     C                   IF        CAP041 = 'Y'                                               CAP041
     C                   MOVEL     'IRSIRSRPX'   #PGM                                         CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'IRSIRSRPR'   #PGM                                         CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   CALL      'WN0010'
     C**********         PARM      'IRSIRSSIN'   #PGM             10                          192829
     C**********         PARM      'IRSIRSRPR'   #PGM             10                   192829 CAP041
     C                   PARM                    #PGM             10                          CAP041
     C                   PARM                    FKEY              2
     C                   PARM      SACCD         ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed AND IRC feature is on, then call
      *  Date Schedule module, with Mode parm set to backwards.
      *  If IRC feature is not on AND Cmd12 pressed, go to main screen or
      *  read next browse record
      *
     C     #RTRN         IFEQ      'USR0790'
     C     CIR001        IFEQ      'Y'
     C                   EVAL      @SCRN = 'X'
     C                   EVAL      Mode = 'B'
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
     C                   END
     C                   END
     C                   ELSE
      *
      *  If Cmd12 not pressed;
      *  If in enquiry mode, go to main screen or read next browse record
      *  otherwise, go to settlements screen
      *
     C     SACCD         IFEQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
      *
     C                   IF        CAP041 <> 'Y'                                              CAP041
     C/COPY QWINDSRC,IRSIRSMOV2
     C                   ENDIF                                                                CAP041
      *
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'IRSIRSRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '*RPR  ' (Repair Function transaction interface)                 CIR005
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    SACCD
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    SDLNO
      *
      * (Midas) Associated Deal Number
     C                   PARM                    SLNKDN
      *
      * Booking branch
     C                   PARM                    SBRCA
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
                                                                                              CLE025
      ** (Current) deal extension in file format                                              CLE025
     C                   PARM                    CrDlXFilFmt                                  CLE025
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACCD
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from DEALSDG
      *
     C                   CALLB     'IRSIRSCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
      * Deal Extension in file format                                                         CLE025
     C                   PARM                    CrDlFilFmt
     C                   PARM                    CrDlXFilFmt                                  CLE025
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      * or Fed Funds Ind repaired                                               162497
      **Or*Value*Date*or*Fed*Funds*Ind*repaired                                 162497
      *
     C     SACCD         IFNE      ##ACCD
     C     SDLNO         ORNE      ##DLNO
     C     SUCUCY        ORNE      ##PCCY
     C     SCNUM         ORNE      ##CSNM
     C*****RSVDAT********ORNE      ##DATR                                       162497
     C*****RSVDAT********ORNE      ##DATP                                       162497
     C     SUFFI         ORNE      ##FFND
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
      *                                                                         CAP014
      * If no changes are allowed, protect (but still validate)                 CAP014
      * all instructions by passing action code 'X' to ZASETINSIN               CAP014
      *                                                                         CAP014
     C     @OPSEL        IFEQ      'N'                                          CAP014
     C                   MOVEL     'X'           ##ACCD                         CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     SACCD         ##ACCD                         CAP014
     C                   ENDIF                                                  CAP014
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM                    ##ACCD            1            CAP014
     C*******************PARM      SACCD         ##ACCD            1            CAP014
      *
      * Deal number
     C                   PARM      SDLNO         ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'SIRS'        ##CALP            4
      *
      * Payment currency
     C                   PARM      SUCUCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      SUCUCY        ##RCCY            3
      *
      * Customer shortname
     C                   PARM      SCNUM         ##CSNM           10
      *
      * Transaction Type
     C                   PARM      SDTYP         ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      SUFFI         ##FFND            1
      *
      * Booking branch
     C                   PARM      SBRCA         ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      * FRA/IRS instructions
     C                   PARM                    ##RSIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##RSIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      *
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      **PROTECT*PAYMENT/RECEIVE INSTRUCTIONS IF DATES                           162497
      **ARE*IN*THE*PAST*AND THE DEAL WAS NOT DONE TODAY                         162497
      *******************                                                       162497
     C*****RSVDAT********IFLT      BJRDNB                                       162497
     C*****RSORED********ANDNE     BJRDNB                                       162497
     C*****RSORED********ANDNE     *ZERO                                        162497
     C*******************MOVEL     'Y'           ##PPAY                         162497
     C*******************MOVEL     'Y'           ##PREC                         162497
     C*******************ELSE                                                   162497
     C*******************MOVEL     'N'           ##PPAY                         162497
     C*******************MOVEL     'N'           ##PREC                         162497
     C*******************END                                                    162497
      *******************                                                       162497
      **SET*PAY/RECEIVE*DATES*FOR*NOSTRO*BACK-VALUE*CHECK                       162497
      *******************                                                       162497
     C*******************EVAL      ##DATP = RSVDAT                              162497
     C*******************EVAL      ##DATR = RSVDAT                              162497
      *                                                                         162497
      * SET PAY/RECEIVE PROTECTION INDICATORS & DATES                           162497
      *                                                                         162497
     C                   MOVEL     'N'           ##PPAY                         162497
     C                   MOVEL     'N'           ##PREC                         162497
     C                   EVAL      ##DATP = BJRDNB                              162497
     C                   EVAL      ##DATR = BJRDNB                              162497
      *
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C     CIR008        OREQ      'Y'                                                        CIR008
     C     SACCD         ANDEQ     'X'                                                        CIR008
     C                   GOTO      EDETP@S
     C                   END
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     RSPAY         FLPAY                                        CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(RSPAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = RSPONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(RSPAY:15:545)                CGL029
     C                   MOVEL     RSPOBR        FLPOBR
     C                   MOVEL     RSCVMR        FLCVMR
     C                   MOVEL     RSPSCY        FLPSCY
     C                   MOVEL     RSIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     RSREC         FLREC                                        CGL029
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(RSREC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = RSRONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(RSREC:15:55)                  CGL029
     C                   MOVEL     RSROBR        FLROBR
     C                   MOVEL     RSRSCY        FLRSCY
      *
      * SET UP FRA/IRS SPECIFIC DATA
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     RSIRS         FLIRS
     C                   MOVE      RSAGVC        FLAGVC                         CSW097
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     CIR008        ANDEQ     'N'                                                        CIR008
     C     FLPSTM        OREQ      *ZERO                                                      CIR008
     C     ##PPAY        ANDNE     'Y'                                                        CIR008
     C     FLRSTM        ANDEQ     *ZERO                                                      CIR008
     C     ##PREC        ANDNE     'Y'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C     SACCD         ANDNE     'X'                                                        CIR008
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'SIRS'        ##CALP            4
      *
      * Payment currency
     C                   PARM      SUCUCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      SUCUCY        ##RCCY            3
      *
      * Customer shortname
     C                   PARM      SCNUM         ##CSNM           10
      *
      * Transaction Type
     C                   PARM      SDTYP         ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      SUFFI         ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
                                                                                CSW097
      ** Version of ISDA Agreement century                                      CSW097
     C                   PARM                    BQAGVC            2            CSW097
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##RSIF
      *
     C                   END
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM                    ##RSIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##RSIS
      *
      ** Receive currency                                                                    CSF011A
     C                   PARM      SUCUCY        ##RCCY                                      CSF011A
      ** Payment currency                                                                    CSF011A
     C                   PARM      SUCUCY        ##PCCY                                      CSF011A
      *
      ** Set screen numeric fields to blank, if zero on file
      *
     C     SACCD         IFNE      'I'
     C     AGDT          IFEQ      *ZERO
     C                   MOVE      *BLANK        DDAGDT
     C                   ENDIF
     C     AGVV          IFEQ      *ZERO
     C     AGVC          ANDEQ     *ZERO                                        CSW097
     C                   MOVE      *BLANK        DDAGVV
     C                   ENDIF
     C                   ENDIF
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
                                                                                CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *                                                                                       CAP041
      ** If option selected is 'N' then go check if records are                               CAP041
      ** still to be read from the subfile. Read them else                                    CAP041
      ** return to browse screen.                                                             CAP041
     C                   IF        @OPSEL = 'N'                                               CAP041
     C                   IF        @RDNB = 'Y'                                                CAP041
     C                   EVAL      @SCRN = 'R'                                                CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      @SCRN = 'B'                                                CAP041
     C                   ENDIF                                                                CAP041
     C                   GOTO      EndExit@S                                                  CAP041
     C                   ENDIF                                                                CAP041
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
      *
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLPAY         RSPAY                                        CGL029
     C                   EVAL      %SUBST(RSPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      RSPONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(RSPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C                   MOVEL     FLPOBR        RSPOBR
     C                   MOVEL     FLCVMR        RSCVMR
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        RSUPACC                               179510 200400
     C************       ENDIF                                                         179510 200400
      *
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLREC         RSREC                                        CGL029
     C                   EVAL      %SUBST(RSREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      RSRONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(RSREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C                   MOVEL     FLROBR        RSROBR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        RSURACC                               179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLRSCY        RSRSCY
     C                   MOVEL     FLPSCY        RSPSCY
     C                   MOVEL     FLIC72        RSIC72
      *
      * UPDATE VALID DEAL: FRA/IRS DETAILS
      *
     C                   MOVEL     FLIRS         RSIRS
     C                   MOVE      FLAGVC        RSAGVC                         CSW097
      *
      * Zeroise numeric fields in RSIRS for update (these fields may be
      * blank if type is OTHER)
      *
     C     FLAGDT        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         RSAGDT
     C                   ENDIF
     C     FLAGVV        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         RSAGVV
     C                   ENDIF
     C     FLAGVC        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         RSAGVC                         CSW097
     C                   ENDIF                                                  CSW097
     C                   END
      *
     C**********         ENDSR
     C     EndExit@S     ENDSR                                                                CAP041
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       IRESIRS
      *
      * Validate deal details
      *
     C                   CALLB     'IRSIRSVAL'
     C                   PARM                    @@MODE                         CIR005
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      RSRSCY        @@RSCY
     C                   PARM      RSRSTM        @@RSTM
     C                   PARM      RSRONS        @@RONS
     C                   PARM      RSPSCY        @@PSCY
     C                   PARM      RSPSTM        @@PSTM
     C                   PARM      RSPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    IRESIRS
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlXFilFmt                                  CLE025
      *                                                                                       184560
     C                   PARM                    SACCD                                        184560
     C                   PARM                    USLIP                                        184560
     C                   PARM                    TSLIP                                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    CrDlScnFmt                                   185057
     C*
     C* For each warning error code set up in IRC schedule screens,
     C* set up message to be sent to the screen
     C*
     C                   Z-ADD     1             C
     C     C             DOWLE     10
     C     @WERRAR(C)    ANDNE     *BLANKS
     C                   MOVEL     @WERRAR(C)    @WERRMS
     C                   EXSR      SNDW@M
     C                   ADD       1             C
     C                   END
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'IRSIRSDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
      *
      * FIELDS IN ERROR
     C                   PARM                    IRESIRS
     C/COPY WNCPYSRC,IRH00037
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       IRESIRS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
     C/COPY WNCPYSRC,IRSIRSRC02
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     SDLNO         IFEQ      *BLANK
      *
     C     I#SDLNO       IFNE      *BLANK
     C                   MOVEL     I#SDLNO       SDLNO
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    SDLNO
     C                   PARM      *ZERO         RSDLNO
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     SDLNO         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C                   MOVEL     SDLNO         @SIDN
     C                   END
      *
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     SDLNO         RSDLNO
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     SACCD         RSCHTP
      *
      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
      *
     C                   MOVEL     @FOTRANSEL    RSFRNT
                                                                                              CAP056
      ** If Automatic deal authorisation is installed, move value of                          CAP056
      ** Automatic authorisation from Invalids file to Valids file                            CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      RSAUTH = SAUTH                                             CAP056
     C                   ENDIF                                                                CAP056
      *
      * DEALS FILE UPDATES
      * (Interest rate calender parameters must be zero as IRC dates            CAP004
      *  are not set up by IRSIRSUPP when input is via the screen)              CAP004
      *
     C                   CALLB     'IRSIRSUPD'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    @@MODE                                       CAP056
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlXFilFmt                                  CLE025
     C**********         PARM      *ZEROS        OurRatChgs      294                   CAP004 CAP043
     C**********         PARM      *ZEROS        OurPayDats      294                   CAP004 CAP043
     C**********         PARM      *ZEROS        ThrRatChgs      294                   CAP004 CAP043
     C**********         PARM      *ZEROS        ThrPayDats      294                   CAP004 CAP043
     C                   PARM      'Y'           ScreenInpt                     CAP004
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTION, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID IRS DEAL ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
     C                   ROLBK
     C     @RTCD         IFNE      '*RECUPD'                                    168345
     C                   EXSR      *PSSR
     C                   ENDIF                                                  168345
     C                                                                          CAP006
     C                   ELSE
                                                                                              247888
      ** Insert DLDLDGQD record for CLE025 processing                                         247888
     C                   IF        #1ACTN = 'I' AND CLE025 = 'Y'                              247888
     C     SDLNO         CHAIN     DLDLDGD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = SDLNO                                          247888
     C                   EVAL      DX_F1BRCA = SBRCA                                          247888
     C                   WRITE     DLDLDGD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C     ZATRNKD0      CHAIN     IRISIRSD0                          99
     C  N99              DELETE    IRISIRSD0
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
      *                                                                                       211064
      ** Delete IRIDTSCPD records                                                             211064
      *                                                                                       211064
     C     ZATRNKD0      SETLL     IRIDTSCD0                                                  211064
     C     ZATRNKD0      READE     IRIDTSCD0                              99                  211064
      *                                                                                       211064
     C     *IN99         DOWEQ     '0'                                                        211064
     C                   DELETE    IRIDTSCD0                                                  211064
     C     ZATRNKD0      READE     IRIDTSCD0                              99                  211064
     C                   ENDDO                                                                211064
      *                                                                                       211064
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = CSLIBR)                       CSC011
                                                                                              CSC011
     C                   MOVEL     @MSGTYPE      KMsgType                                     CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAP043
      ** Delete invalid records from the invalids file                                        CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   EXSR      SRDelInIRC                                                 CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
      ** DTSC invalid file                                                                    CAP043
                                                                                              CAP043
     C     ZATRNKD0      SETLL     IRIDTSCX2                                                  CAP043
     C     ZATRNKD0      READE     IRIDTSCX2                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRIDTSCX2                                                  CAP043
     C     ZATRNKD0      READE     IRIDTSCX2                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CSC011
     C                   COMMIT
     C/COPY WNCPYSRC,IRSIRSRC01
     C                   END
      *
      * If error occurred in updating last transaction set on flag to           CAP006
      * display message on 'browse' screen.                                     CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                   MOVE      'Y'           @ERRUP                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      'N'           @ERRUP                         CAP006
     C                   END                                                    CAP006
                                                                                CIR005
      ** Blank the Business Day Currency Convention fields                      CIR005
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   IF        CIR017 = 'N'                                               CIR017
     C                   MOVEL     *Blank        BsDayConv                      CIR005
     C                   ELSE                                                                 CIR017
     C                   MOVEL     *Blank        BsDayConvW                                   CIR017
     C                   MOVEL     *Blank        BsDayConv2                                   CIR017
     C                   ENDIF                                                                CIR017
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
     C                                                                          CAP006
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRDelInIRC - Delete invalid Interest Rate Calendar records       *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRDelInIRC    BEGSR                                                                CAP043
                                                                                              CAP043
      ** Delete records from the invalid log file                                             CAP043
                                                                                              CAP043
     C                   IF        CSC011 = 'Y'                                               CAP043
     C                   MOVEL     'IRSIRI'      KMsgType                                     CAP043
     C     KAPILOGL0     SETLL     APILOGL0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    APILOGD0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   MOVEL     'IRSICF'      KMsgType                                     CAP043
     C     KAPILOGL0     SETLL     APILOGL0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    APILOGD0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   MOVEL     'IRSIPC'      KMsgType                                     CAP043
     C     KAPILOGL0     SETLL     APILOGL0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    APILOGD0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVEL     'IRSITR'      KMsgType                                     CAP043
     C     KAPILOGL0     SETLL     APILOGL0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    APILOGD0                                                   CAP043
     C     KAPILOGL0     READE     APILOGL0                                                   CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** DTSC invalid file                                                                    CAP043
                                                                                              CAP043
     C     ZATRNKD0      SETLL     IRIDTSCX2                                                  CAP043
     C     ZATRNKD0      READE     IRIDTSCX2                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRIDTSCX2                                                  CAP043
     C     ZATRNKD0      READE     IRIDTSCX2                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** CFSC invalid file                                                                    CAP043
                                                                                              CAP043
     C     ZATRNKD0      SETLL     IRICFSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRICFSCD0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRICFSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRICFSCD0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** PCSC invalid file                                                                    CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C     ZATRNKD0      SETLL     IRIPCSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCD0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRIPCSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCD0                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   ROLBK
     C                   END
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NwDlScnFmt    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrDlScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NwDlScnFmt                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SetupAmend - Setup Settlement Instructions on Amendment       *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SetupAmend    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
     C**********         MOVEL     R_REC         FLREC                                 CAP011 CGL029
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(R_REC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = RONS                                  CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(R_REC:15:55)                  CGL029
     C                   MOVEL     ROBR          FLROBR                         CAP011
     C                   MOVEL     RSCY          FLRSCY                         CAP011
     C                   MOVEL     R_IRS         FLIRS                          CAP011
     C                   MOVEL     AGVC          FLAGVC                         CSW097
     C**********         MOVEL     R_PAY         FLPAY                                 CAP011 CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(R_PAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = PONS                                  CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(R_PAY:15:545)                CGL029
     C                   MOVEL     POBR          FLPOBR                         CAP011
     C                   MOVEL     CVMR          FLCVMR                         CAP011
     C                   MOVEL     PSCY          FLPSCY                         CAP011
     C                   MOVEL     IC72          FLIC72                         CAP011
                                                                                CAP011
     C                   CALLB     'ZASETINCVT'                                 CAP011
                                                                                CAP011
      ** Deal Settlement Instructions in file format                            CAP011
     C                   PARM                    ##PAYF                         CAP011
     C                   PARM                    ##RECF                         CAP011
     C                   PARM                    ##RSIF                         CAP011
                                                                                CAP011
      ** Current Settlement Instruction in input format                         CAP011
     C                   PARM      *BLANK        CrPaySttmt                     CAP011
     C                   PARM      *BLANK        CrRecSttmt                     CAP011
     C                   PARM      *BLANK        CrFRASttmt                     CAP011
                                                                                CAP011
      * Receive currency                                                                     CSF011A
     C                   PARM      SUCUCY        ##RCCY                                      CSF011A
      * Payment currency                                                                     CSF011A
     C                   PARM      SUCUCY        ##PCCY                                      CSF011A
      *  If no Payment or Receive instructions have been supplied               CAP011
      *  Default them to those currently on the deal.                           CAP011
                                                                                CAP011
     C                   IF            (##PAYS = *blank)                        CAP011
     C                   EVAL      ##PAYS = CrPaySttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (##RECS = *blank)                        CAP011
     C                   EVAL      ##RECS = CrRecSttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (##RSIS = *blank)                        CAP011
     C                   EVAL      ##RSIS = CrFRASttmt                          CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** PAYMENT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##PAYS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrPaySttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##PAYS                         CAP011
                                                                                CAP011
      ** RECEIPT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##RECS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrRecSttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##RECS                         CAP011
                                                                                CAP011
      ** FRA/IRS INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      ##RSIS        IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrFRASttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       ##RSIS                         CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'IRSIRSRPR'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              245692
      ** Access Dealing details                                                               245692
                                                                                              245692
     C                   CALL      'AODEALR1'                                                 245692
     C                   PARM      '*DBERR '     @RTCD                                        245692
     C                   PARM      '*FIRST '     @OPTN                                        245692
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        245692
                                                                                              245692
     C     @RTCD         IFNE      *BLANKS                                                    245692
     C     *LOCK         IN        LDA                                                        245692
     C                   EVAL      DBFILE = 'SDDEALPD'                                        245692
     C                   EVAL      DBASE = 913                                                245692
     C                   EVAL      DBKEY = @OPTN                                              245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
                                                                                              245692
                                                                                              CIR017
      ** Check if CIR017 - Separate Business Day Convention for SIRS                          CIR017
                                                                                              CIR017
     C                   CALL      'AOSARDR0'                                                 CIR017
     C                   PARM      *BLANKS       PRTCD                                        CIR017
     C                   PARM      '*VERIFY'     POPTN                                        CIR017
     C                   PARM      'CIR017'      PSARD                                        CIR017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR017
                                                                                              CIR017
     C                   IF        PRTCD <> *BLANKS AND                                       CIR017
     C                             PRTCD <> '*NRF   '                                         CIR017
     C     *LOCK         IN        LDA                                                        CIR017
     C                   EVAL      DBASE = 913                                                CIR017
     C                   EVAL      DBKEY = 'CIR017'                                           CIR017
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR017
     C                   OUT       LDA                                                        CIR017
     C                   EXSR      *PSSR                                                      CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C                   IF        PRTCD = *BLANKS                                            CIR017
     C                   EVAL      CIR017 = 'Y'                                               CIR017
     C                   ELSE                                                                 CIR017
     C                   EVAL      CIR017 = 'N'                                               CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
      *
      **  Access SAR details file to determine if IRC feature is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   MOVEL     'CIR001'      DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR001            1
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   END
      *
      **  Access SAR details file to determine if Compounding of Interest
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 903 *
     C                   MOVEL     'CIR002'      DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR002            1
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   END
      *                                                                         CIR005
      ** Access SAR details file to determine if FRA/IRS Business Day           CIR005
      ** Day Convention is switched on.                                         CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')  CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   MOVEL     '906'         DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                                       CIR006
      **  Access SAR details file to determine if CIR006 feature is on                        CIR006
      *                                                                                       CIR006
     C                   CALL      'AOSARDR0'                                                 CIR006
     C                   PARM      *BLANKS       @RTCD                                        CIR006
     C                   PARM      '*VERIFY'     @OPTN                                        CIR006
     C                   PARM      'CIR006'      @SARD             6                          CIR006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR006
      *                                                                                       CIR006
     C     @RTCD         IFNE      *BLANKS                                                    CIR006
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR006
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CIR006
     C                   MOVEL     '907'         DBASE                          * DBERR 907 * CIR006
     C                   MOVEL     'CIR006'      DBKEY                          ************* CIR006
     C                   EXSR      *PSSR                                                      CIR006
     C                   END                                                                  CIR006
      *                                                                                       CIR006
     C     @RTCD         IFEQ      *BLANKS                                                    CIR006
     C                   MOVEL     'Y'           CIR006            1                          CIR006
     C                   ELSE                                                                 CIR006
     C                   MOVEL     'N'           CIR006                                       CIR006
     C                   END                                                                  CIR006
                                                                                              CAS001
      **  Access SAR details file to determine if NPV Accounting feature is on                CAS001
                                                                                              CAS001
     C                   CALL      'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
      *                                                                                       CAS001
     C     PRTCD         IFNE      *BLANKS                                                    CAS001
     C     PRTCD         ANDNE     '*NRF   '                                                  CAS001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS001
     C                   MOVEL     '908'         DBASE                                        CAS001
     C                   MOVEL     'CAS001'      DBKEY                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   END                                                                  CAS001
      *                                                                                       CAS001
     C     PRTCD         IFEQ      *BLANKS                                                    CAS001
     C                   MOVEL     'Y'           CAS001                                       CAS001
     C                   ELSE                                                                 CAS001
     C                   MOVEL     'N'           CAS001                                       CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAP041
      ** Determine if CAP041 is installed.                                                    CAP041
                                                                                              CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CAP041'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     908           DBASE                                        CAP041
     C                   MOVEL     'CAP041'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CAP041            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CAP041                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      **  Access SAR details file to determine if CEU003 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CEU003'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     909           DBASE                                        CAP041
     C                   MOVEL     'CEU003'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CEU003            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CEU003                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      **  Access SAR details file to determine if CIR007 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CIR007'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     910           DBASE                                        CAP041
     C                   MOVEL     'CIR007'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CIR007            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CIR007                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                         CAP011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE =  908                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAP043
      ** Check if CAP043 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 910                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CSC011
      ** Check if FRA/IRS Deals Authorisations is installed                                   CIR008
                                                                                              CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSard                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *Blanks                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        PRetCode <> '*NRF   '                                      CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 911                                                CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Check if Automatic Authorisation of Interface deals is installed                     CAP056
                                                                                              CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRetCode                                     CAP056
     C                   PARM      '*VERIFY'     POption                                      CAP056
     C                   PARM      'CAP056'      PSard                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRetCode = *Blanks                                         CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   IF        PRetCode <> '*NRF   '                                      CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 912                                                CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      ** Access API ICD Details                                                 CAP011
      *                                                                         CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      *BLANKS       @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *                                                                         CAP011
      * DATABASE ERROR                                                          CAP011
      *                                                                         CAP011
     C     @RTCD         IFNE      *BLANKS                                      CAP011
     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
     C                   MOVEL     '905'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011

      ** Message Type

     C*******************MOVEL     'IRSIRS'      @MSGTYPE          8            CAP004
     C                   MOVEL     'IRSIRS'      @MSGTYPE                       CAP004

      ** Get the field number for the deal number field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo

     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1

      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
                                                                                CIR005
      ** Get the field number for the first field in bus. day screen.           CIR005
      ** Subtract one from it to give the value to subtract from each           CIR005
      ** field's number.                                                        CIR005
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   CALLB     'ZACGTFLDNO'                                 CIR005
     C                   PARM                    ReturnCode                     CIR005
     C                   PARM                    Format                         CIR005
     C                   PARM                    FieldB                         CIR005
     C                   PARM                    FieldNo                        CIR005
      *                                                                         CIR005
     C                   IF        ReturnCode = *blank                          CIR005
     C                   EVAL      FldOffsetB = FieldNo - 1                     CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
                                                                                              CAP041
      ** Get the field number for the first field in Fees/Buy-outs scrn.                      CAP041
      ** Subtract one from it to give the value to subtract from each                         CAP041
      ** field's number.                                                                      CAP041
                                                                                              CAP041
     C                   IF        CAP041 = 'Y'                                               CAP041
     C                   CALLB     'ZACGTFLDNO'                                               CAP041
     C                   PARM                    ReturnCode                                   CAP041
     C                   PARM                    Format                                       CAP041
     C                   PARM                    FieldF                                       CAP041
     C                   PARM                    FieldNo                                      CAP041
      *                                                                                       CAP041
     C                   IF        ReturnCode = *BLANK                                        CAP041
     C                   EVAL      FldOffsetF = FieldNo - 1                                   CAP041
     C                   ENDIF                                                                CAP041
     C                   ENDIF                                                                CAP041
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
     C                   EVAL      DBASE = 914                                              MD054117
     C                   OUT       LDA                                                      MD054117
     C                   EXSR      *PSSR                                                    MD054117
     C                   ENDIF                                                              MD054117
      *                                                                                     MD054117
     C                   MOVEL     PVL01         PCIDCF                                     MD054117
      *                                                                                     MD054117
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
     C                   EVAL      @@MODE = '*RPR  '                            CIR005
     C                   EVAL      PLCcy = BJLCCY                               CIR005
      *

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRSIRSR012

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
