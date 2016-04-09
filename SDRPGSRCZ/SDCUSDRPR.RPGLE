     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid customer details repair')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSDRPR - INVALID CUSTOMER DETAILS REPAIR FUNCTION         *
      *                                                               *
      *  Function:  This function allows invalid Customer details to  *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD030956           Date 09Oct14               *
      *  Prev Amend No. AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26917A          Date 27Jan10               *
      *                 BUG26917           Date 20Jan10               *
      *                 BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 02Aug07               *
      *                 BUG13228           Date 07Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 06Jul07               *
      *                 218591             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG7314            Date 09Jan06               *
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD028             Date 22Aug05               *
      *                 BUG9081            Date 10Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 208558             Date 19Aug02               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5952            Date 25Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4454            Date 08Oct04               *
      *                 BUG3362            Date 28Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 222373             Date 24Oct03               *
      *                 CGP001             Date 23May03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 192916             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 201725             Date 08Jan02               *
      *                 193883             Date 20Nov01               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195255             Date 05Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 189774             Date 13Feb01               *
      *                 175680             Date 08Mar00               *
      *                 185595             Date 30Oct00               *
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP011             Date 21Dec99               *
      *                 CAP013             Date 16Dec99               *
      *                 CAP014             Date 15Dec99               *
      *                 CAP034  *CREATE    Date 14Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,SDH00103                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG26917A - Reverse fix for bug26917                         *
      *  BUG26917 - COB error when customer is declared as taxable    *
      *           w/ German features installed and no additional      *
      *           customers information is set up                     *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  BUG13228 - Need to pass status of ULX004 to SDCUSD2RP        *
      *  218591 - Window processing not performed when PB module is   *
      *           switched off.  Ensure window is displayed when      *
      *           window processing is on and PB module is off.       *
      *           Applied part of 204177.  Also, call updater after   *
      *           validation.  Applied fix 202378.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG7314- Front Office Teller ID is not populated to SD Cust. *
      *           file.  Need to move correct data to field before    *
      *           call to SDCUSDUPD. Applied gems 219261.             *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  BUG9081 - Display correct message for each screen            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL031 - Taxation on Savings Income                          *
      *  208558 - PB3610 no more working due to incorrect upgrade of  *
      *           GEMS 185595 into core product. Call of SR/FURDET    *
      *           must be done BEFORE delete of record from file      *
      *           SDICEXPD (/Copy SDCUSDRC02).                        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5952- Fields in wrong sections of file                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4454 - Database error when inserting a customer with      *
      *           additional customer details                         *
      *  BUG3362 - Added processing for TI(for CSD012).               *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  222373 - Parameter Mismatch                                  *
      *  CGP001 - Global Processing                                   *
      *  CSD012 - Standing Data Authorisation                         *
      *  192916 - Rollback of window updates wrongly managed in Core  *
      *           API's modules RPR and SIN                           *
      *  CSC011 - 24x7 Midas Availability                             *
      *  201725 - Pgm attempting to access wrong ZAFLDNPD members     *
      *  193883 - Recompile over changed SDCUSDUPD.                   *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  195255 - Just before calling SD0014V, COMMIT all the updates.*
      *           At this step, all the relevant informations are     *
      *           already checked and accepted.                       *
      *           Without the COMMIT, when F12 was used in the further*
      *           details screen, the records were deleted from the   *
      *           repai queue but not inserted in Midas               *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  189774 - Window processing for Customer Details API program  *
      *  175680 - PB Customer Maintenance - Wrong Action passed       *
      *             to extension maintenance SD0014V                  *
      *  185595 - Impossible to input "Further Details" during Input  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CSD007 - Customer Closing:                                   *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP014 - Repair function enhancements                        *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSDICUSDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICUSDD0:SDICUSDX0)
     FSDICUSDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FSDICUBRL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICUBRD0:SDICUBRX0)
     FSDICUBRL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
 
     FSDICUPBL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICUPBD0:SDICUPBX0)
     FSDICUPBL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
                                                                                             CSW207A
     FSDISWFDL0 IF   E           K DISK    INFSR(*PSSR)                                      CSW207A
     F                                     RENAME(SDISWFDD0:SDISWFXD0)                       CSW207A
     FSDISWFDL1 UF   E           K DISK    INFSR(*PSSR) COMMIT                               CSW207A
                                                                                              CSC011
      ** API Invalid Log File from Support Database                                           CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUSDR001
      * Invalid Customers Details extra data file                                             CER001
     FSDICEXL1  UF A E           K DISK    INFSR(*pssr) USROPN                                CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FSDCUX2L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SDCUSTF6:RTVIDXA)                           CER001
     F                                     INFSR(*PSSR)                                       CER001
      *                                                                                       CER001
     FSDICULX2L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SDICULXD6:RTVIDX1)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FSDCUX1L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SDCUSTDL:RTVIDXB)                           CER001
     F                                     INFSR(*PSSR)                                       CER001
     FSDICULX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SDICULXDL:RTVIDX2)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
      ** Midas ER Institutions - Economic Sectors                                             CER001
     FSDINX1L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
                                                                                              CER001
      ** Midas ER Country Codes - LU Ext. index                                               CER001
     FSDCTX2L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D @EI             S              1    DIM(60)
 
   41 ** Array of Fields in error, temporary store
   42D TmpFldNmAr      S             10A   DIM(ArrayMax)
   42 ** Array of error message IDs, temporary store
   42D TmpMsgIdAr      S                   DIM(ArrayMax)
   42D                                     LIKE(#MsgID)
 
      * Current Customer in File Format
     D CrCuFilFmt    E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(C_)
      ** SWIFT Details in File Format                                                         CSW207
     D CrSwFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
                                                                                              CER059
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX(TX)                                         CER059
      * Current Customer in File Format - Base Rate Tax Details
     D CrBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
     D                                     PREFIX(C_)
      * Current Customer in File Format - Private Banking Details
     D CrPbFilFmt    E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(C_)
 
     D CrTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
     D                                     PREFIX(C_)                                        BUG3362
                                                                                             BUG3362
      ** Current Customer in File Format (VF)                                                 CER001
     D CrDlFilFmt1   E DS                  EXTNAME(SDCUX2L0)                                  CER001
      ** Current Customer in File Format (VL)                                                 CER001
     D CrDlFilFmt2   E DS                  EXTNAME(SDCUX1L0)                                  CER001
      ** Current Global Customer X-Reference in File Format                                   CGP001
     D GCrCuFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
     D                                     PREFIX(CG_)                                        CGP001
                                                                                              CGP001
      * Current Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@)
      * Current Customer in Screen Format - Swift Extension                                   CSW207
     D CurCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D                                     PREFIX(@)                                          CSW207
      * Current Customer in Screen Format - Base Rate Tax Details
     D CurCuBrt      E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@)
      * Current Customer in Screen Format - Private Banking Details
     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(@)
      * Current TI details Screen Format - TI Details                                        BUG3362
     D CurTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(@)                                         BUG3362
      * Current Customer in Screen Format - Secondary Details
     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@)
      * Current Customer in Screen Format - MT3xx BEI Details                                 CSW024
     D CurCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
     D                                     PREFIX(@)                                          CSW024
      * Current Customer in Screen Format - Message Details
     D CurCuMsg      E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@)
 
      * New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
     D NwSwFilFmt    E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
      * Valid SWIFT Details layout                                                            CSW207
      * New Customer in File Format - Base Rate Tax Details
     D NwBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
      * New Customer in File Format - Private Banking Details
     D NwPbFilFmt    E DS                  EXTNAME(SDVCUPBPD)
      * New TI Details in File Format                                                        BUG3362
     D NwTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
     D                                     PREFIX(V_)                                        BUG3362
 
      ** New Customer extension in File Format (#6LXVF)                                       CER001
     D NwDlFilFmt1   E DS                  EXTNAME(SDVCULX2PD)                                CER001
      ** New Customer extension in File Format (#LLXVL)                                       CER001
     D NwDlFilFmt2   E DS                  EXTNAME(SDVCULX1PD)                                CER001
      * New Customer in Screen Format - Primary Details
     D NewCuPrim     E DS                  EXTNAME(SDCUPRPD)
      * New Customer in Screen Format - Base Rate Tax Details
     D NewCuBrt      E DS                  EXTNAME(SDCUBRPD)
     D   NewCuBrt1             1    500
     D   NewCuBrt2           501    692
      * New Customer in Screen Format - Private Banking Details
     D NewCuPriv     E DS                  EXTNAME(SDCUPBPD)
      * New TI Details in Screen Format - TI Details                                         BUG3362
     D NewTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(N_)                                        BUG3362
      * New Customer in Screen Format - Secondary Details
     D NewCuSeco     E DS                  EXTNAME(SDCUSEPD)
      * New Customer in Screen Format - MT3xx BEI Details                                     CSW024
     D NewCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
      * New Customer in Screen Format - Message Details
     D NewCuMsg      E DS                  EXTNAME(SDCUMRPD)
 
 
 
      * Previous Customer in Screen Format - Primary Details
     D PrvCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@P)
      * Previous Customer in Screen Format - Base Rate Tax Details
     D PrvCuBrt      E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@P)
      * Previous Customer in Screen Format - Private Banking Details
     D PrvCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(@P)
      * Previous TI Details in screen Format - TI Details                                    BUG3362
     D PrvTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(@P)                                        BUG3362
      * Previous Customer in Screen Format - Secondary Details
     D PrvCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@P)
      * Previous Customer in Screen Format - MT3xx BEI Details                                CSW024
     D PrvCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
     D                                     PREFIX(@P)                                         CSW024
      * Previous Customer in Screen Format - Message Details
     D PrvCuMsg      E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@P)
 
 
      * Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuMT3X      E DS                  EXTNAME(SDECUMTPD)                                 CSW024
     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)
     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
 
      ** Swift Extension                                                                      CSW207
     D NewCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
 
      * Further Details Parameter Data Structure
     D***FURDETS          DS           565                                                   BUG3362
     D***FURDETS          DS           701                                           BUG3362 BUG4454
     D***FURDETS          DS           708                                          BUG4454 BUG26917
     D***FURDETS          DS           709                                        BUG26917 BUG26917A
     DFURDETS          DS           708                                                    BUG26917A
     D FDCUST                  1      6
     D FDCSSN                  7     16
     D FDCRTN                157    166
     D FDCRNM                168    187
     D FDLINC                228    229
     D/COPY WNCPYSRC,SDCUSDRD01
     D FDSEDT                230    230                                                       CER001
     D FDPLDT                231    231                                                       CER001
     D FDFFDT                232    232                                                       CER001
     D FDFRNT                233    252                                                       CER001
     D FDTICS                564    564
     D FDCTID                565    700                                                      BUG3362
     D FDCRPC                702    702                                                      BUG4454
     D FDBRCD                703    705                                                      BUG4454
     D FDLICD                706    708                                                      BUG4454
     D***FDTAIN                709    709                                         BUG26917 BUG26917A
 
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)                    222373
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * SD Custom Extra Data - File (D/B) format
     D RegData       E DS                  EXTNAME(SDCURXPD)                                  CER001
      * SD Customer Extension Details  - File (D/B) format                                    CER001
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
     D/COPY QWINDSRC,SDCUSDDTA                                                                189774
                                                                                              189774
     DPDATA            DS          1024                                                       CER001
     D**#1FLD1**               1      6  0                                            CER001 CSD027A
                                                                                              CER001
     D  #1CUST                 1      6                                                       CER001
     D  #1PAIN                 7      7                                                       CER001
     D  #1PCNB                 8     13                                                       CER001
     D  #1COLC                15     16                                                       CER001
     D  #1LINC                17     18                                                       CER001
     D  #1BRCD                19     21                                                       CER001
     D  #1BNBI                22     22                                                       CER001
     D  #2CNCZ                23     24                                                       CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
     D  #1CRNM                91    110                                                       CER001
     D  #1NCOS               111    114                                                       CER001
     D  #1DEXT               115    115                                                       CER001
     D  #2DEXT               116    116                                                       CER001
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
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatC         S             10A   INZ('SDCUSDPD')
     D*FormatP*********S             10A   INZ('SDCUPRPD')                                    201725
     D*FormatS*********S             10A   INZ('SDCUSEPD')                                    201725
     D*FormatF*********S             10A   INZ('SDCUMTPD')                             CSW024 201725
     D*FormatM*********S             10A   INZ('SDCUMRPD')                                    201725
     D*FormatB*********S             10A   INZ('SDCUBRPD')                                    201725
     D*FormatV*********S             10A   INZ('SDCUPBPD')                                    201725
                                                                                              201725
     D FormatP         S             10A   INZ('SDCUSDPD')                                    201725
     D FormatS         S             10A   INZ('SDCUSDPD')                                    201725
     D FormatF         S             10A   INZ('SDCUSDPD')                                    201725
     D FormatM         S             10A   INZ('SDCUSDPD')                                    201725
     D FormatB         S             10A   INZ('SDCUSDPD')                                    201725
     D FormatV         S             10A   INZ('SDCUSDPD')                                    201725
 
     D FieldP          S             10A   INZ('DDACTN')
     D FieldS          S             10A   INZ('DDCSID')
     D FieldF          S             10A   INZ('DDCORP')                                      CSW024
     D FieldM          S             10A   INZ('DDNG01')
     D FieldB          S             10A   INZ('DD1TTL')
     D FieldBF         S             10A   INZ('DD1TTL')
     D***FieldV          S             10A   INZ('DDPRBA')                                   BUG9081
     D FieldV          S             10A   INZ('DDHOLD')                                     BUG9081
     D FieldExt        S             10A   INZ('L6LXPAPS')                                    CER001
 
     D FldOffsetP      S              5P 0
     D FldOffsetS      S              5P 0
     D FldOffsetF      S              5P 0                                                    CSW024
     D FldOffsetM      S              5P 0
     D FldOffsetB      S              5P 0
     D FldOffstBF      S              5P 0
     D FldOffsetV      S              5P 0
     D FldOffsetExt    S              5P 0                                                    CER001
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
 
      ** Fields for getting the ending field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D*FieldPL*********S             10A   INZ('DDMTSC')                                     BUG5952
     D FieldPL         S             10A   INZ('DDDEDT')                                     BUG5952
     D*FieldSL*********S             10A   INZ('DDSSDL')                                     BUG5952
     D FieldSL         S             10A   INZ('DDCSI2')                                     BUG5952
     D*FieldFL*********S             10A   INZ('DDFUND')                               CSW024BUG5952
     D FieldFL         S             10A   INZ('DDFNAC')                                     BUG5952
     D FieldML         S             10A   INZ('DDDNW9')
     D FieldBL         S             10A   INZ('DD5STS')
     D FieldVL         S             10A   INZ('DDPBST')
 
     D FldOffstPL      S              5P 0
     D FldOffstSL      S              5P 0
     D FldOffstFL      S              5P 0                                                    CSW024
     D FldOffstML      S              5P 0
     D FldOffstBL      S              5P 0
     D FldOffstVL      S              5P 0
 
      ** End of fields for getting ending field number
 
     D WKCUST          S                   LIKE(DDCUSN)
     D WeF             S              1A   INZ(*BLANK)                                        CSW024
     D WeB             S              1A   INZ(*BLANK)                                        CSW024
     D WeS             S              1A   INZ(*BLANK)                                        CSW024
     D WeM             S              1A   INZ(*BLANK)                                        CSW024
     D WeV             S              1A   INZ(*BLANK)                                        CSW024
 
                                                                                CAP011
      ** Flags to indicate whether substitution is required in                  CAP011
      ** each of the various parts the transaction                              CAP011
     D RepPrim         S              1A   inz('N')                             CAP011
     D RepSeco         S              1A   inz('N')                             CAP011
     D RepMT3X         S              1A   inz('N')                                           CSW024
     D RepMsrt         S              1A   inz('N')                             CAP011
     D RepBrTx         S              1A   inz('N')                             CAP011
     D RepPriv         S              1A   inz('N')                             CAP011
     D RepSwft         S              1A   inz('N')                                          CSW207A
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KFrntOffID      S                   LIKE(@FOTRANSEL)                                   CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CSC011
     D CGP001          S              1                                                       CGP001
     D V_DDGCUS        S             10                                                       CGP001
     D CSW207          S              1A                                                      CSW207
                                                                                              CGP001
      * Defined Fields for CSD012                                                             CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqCustomerMaint')                      CSD012
                                                                                              CSD012
      ** Override SDAULGL2                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSD012
     D***CER048          S              1                                         BUG26917 BUG26917A
     D CLE025          S              1                                                       CLE025
     D CFX001          S              1                                                       CFX001
     D ULX043          S              1                                                       CER001
     D ULX609          S              1                                                       CER001
     D ULX008          S              1                                                       CER001
     D ULX012          S              1                                                       CER001
     D ULX048          S              1                                                       CER001
     D ULX004          S              1                                                     BUG13228
     D LOOP            S              1                                                       CER001
     D K@CUST          S                   LIKE(VFCUST)                                       CER001
     D BRBKCO          S              2S 0                                                    CER001
      ** Error message fields received as parameters                                          CER001
     D MSG1            S                   LIKE(#MsgID)                                       CER001
     D WFIND1          S              1                                                       CER001
     D WFIND2          S              1                                                       CER001
     D PRV_SCRN        S              1                                                       CER001
     D SVACTN          S                   LIKE(DDACTN)                                       CER001
                                                                                              CLE025
     D PTransType      S              4                                                       CSD028
      ** -------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUSDR002
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SDCUSDR003
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   ROLBK
     C                   END
      *
      /COPY WNCPYSRC,SDCUSDR004
      *
      * DO SCREEN: BROWSE INVALID DEALS
      *
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SCRN@I
     C                   END
      *
      /COPY WNCPYSRC,SDCUSDR005
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDCUSDR006
      *
      ** DO WHILE screen: Primary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      SCRN@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDR007
      *
      ** DO WHILE screen: Base Rate Tax Details
      *
     C                   IF        WeB <> 'Y'                                                 CSW024
     C                   EXSR      SNDM@B
     C                   EVAL      WeB = 'Y'                                                  CSW024
     C                   ENDIF                                                                CSW024
     C                   Z-ADD     *ZERO         WIdx_BVAL         3 0
     C                   Z-ADD     *ZERO         WIdx_TVAL         3 0
     C     @SCRN         DOWEQ     'X'
     C                   EXSR      Scrn@B
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDR008
      *
      ** DO WHILE screen: Secondary Details Screen
      *
     C                   IF        WeS <> 'Y'                                                 CSW024
     C                   EXSR      SNDM@S
     C                   EVAL      WeS = 'Y'                                                  CSW024
     C                   ENDIF                                                                CSW024
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDR009
      *                                                                                       CSW024
      ** If CSW024 and Midas/Swift direct link is installed,                                  CSW024
      ** DO WHILE screen: MT3xx BEI & Fund Details Screen                                     CSW024
      *                                                                                       CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
      *                                                                                       CSW024
     C                   IF        WeF <> 'Y'                                                 CSW024
     C                   EXSR      SNDM@F                                                     CSW024
     C                   EVAL      WeF = 'Y'                                                  CSW024
     C                   ENDIF                                                                CSW024
     C                   Z-ADD     *ZERO         WIdx_FVAL         3 0                        CSW024
     C     @SCRN         DOWEQ     'F'                                                        CSW024
     C                   EXSR      SCRN@F                                                     CSW024
     C                   ENDDO                                                                CSW024
      *                                                                                       CSW024
     C                   ENDIF                                                                CSW024
      *
      ** DO WHILE screen: Message Details Screen
      *
     C                   IF        WeM <> 'Y'                                                 CSW024
     C                   EXSR      SNDM@M
     C                   EVAL      WeM = 'Y'                                                  CSW024
     C                   ENDIF                                                                CSW024
     C                   Z-ADD     *ZERO         WIdx_MVAL         3 0
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
      *
      ** DO WHILE screen: Private Banking Details
      *
      /COPY WNCPYSRC,SDCUSDR010
      *
     C                   IF        WeV <> 'Y'                                                 CSW024
     C                   EXSR      SNDM@V
     C                   EVAL      WeV = 'Y'                                                  CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CER001
     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
      *                                                                                       CER001
     C     @SCRN         DOWEQ     'V'
     C                   EXSR      Scrn@V
     C                   ENDDO
      *                                                                                       CER001
      ** DO WHILE screen: Extension Details                                                   CER001
      *                                                                                       CER001
     C     @SCRN         DOWEQ     'L'                                                        CER001
     C                   EXSR      Scrn@L                                                     CER001
     C                   ENDDO                                                                CER001
      *                                                                                       CER001
     C     @SCRN         DOWEQ     'N'                                                        CER001
     C                   EXSR      Scrn@N                                                     CER001
     C                   ENDDO                                                                CER001
      *
      /COPY WNCPYSRC,SDCUSDR015                                                               189774
      *                                                                                       189774
      ** Do window processing                                                                 189774
      *                                                                                       189774
     C     @SCRN         DOWEQ     'W'                                                        189774
     C                   EXSR      Scrn@W                                                     189774
     C                   ENDDO                                                                189774
      *                                                                                       189774
      /COPY WNCPYSRC,SDCUSDR011
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDCUSDR012
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   ROLBK                                                                192916
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CLOSE     SDCUX1L0                                                   CER001
     C                   CLOSE     SDICULX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX609 = 'Y'                                               CER001
     C                   CLOSE     SDCUX2L0                                                   CER001
     C                   CLOSE     SDICULX2L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PB3610 = 'Y'                                               CER001
     C                   CLOSE     SDICEXL1                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUSDR013
 
      /EJECT
      *****************************************************************
      * SCRN@I - BROWSE INVALID CUSTOMERS
      *****************************************************************
     C     SCRN@I        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SDCUSDRPB'
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
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
                                                                                              CSC011
      ** CSC011 indicator                                                                     CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
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
      * Customer Number
     C                   PARM      *blanks       DDCUSN
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
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
     C                   GOTO      ESCRN@I
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SDCUSDRPB'
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
      * Error in update of previous deal
     C                   PARM                    @ERRUP
                                                                                              CSC011
      ** CSC011 indicator                                                                     CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
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
      * CUSTOMER NUMBER
     C                   PARM      *BLANK        DDCUSN
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID CUSTOMER READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * Clear file formats
     C                   CLEAR                   NwCuFilFmt
     C                   CLEAR                   NwBrFilFmt
     C                   CLEAR                   NwPbFilFmt
     C                   CLEAR                   NwTIFilFmt                                  BUG3362
     C                   CLEAR                   NwSwFilFmt                                  CSW207A
     C                   CLEAR                   CrCuFilFmt
     C                   CLEAR                   CrBrFilFmt
     C                   CLEAR                   CrPbFilFmt
     C                   CLEAR                   CrTIFilFmt                                  BUG3362
     C                   CLEAR                   GCrCuFilFmt                                  CGP001
     C                   CLEAR                   CrSwFilFmt                                  CSW207A
      *
      * BLANK THE SCREENS
      *
     C                   Eval      WKCUST = DDCUSN
     C                   Eval      WeF = *BLANK                                               CSW024
     C                   Eval      WeB = *BLANK                                               CSW024
     C                   Eval      WeS = *BLANK                                               CSW024
     C                   Eval      WeM = *BLANK                                               CSW024
     C                   Eval      WeV = *BLANK                                               CSW024
     C                   CLEAR                   NewCuPrim
     C                   CLEAR                   CurCuBrt
     C                   CLEAR                   NewCuPriv
     C                   CLEAR                   NewCuSeco
     C                   CLEAR                   NewCuMT3X                                    CSW024
     C                   CLEAR                   NewCuMsg
     C                   CLEAR                   NewCuSwft                                   CSW207A
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVE      *ALL'Y'       OKCuPriv
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVE      *ALL'Y'       OKCuMT3X                                     CSW024
     C                   MOVE      *ALL'Y'       OKCuMsg
     C                   MOVE      *ALL'Y'       OKCuSwft                                    CSW207A
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve Customer details
      *
     C                   Eval      DDCUSN =WKCUST
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    CUFRNT
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         163820
      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
      * module for SPF checking .                                               163820
      *                                                                         163820
     C     ZATRNKX0      CHAIN     SDICUSDX0                          99        163820
      *                                                                                       CER001
     C                   EVAL      SVACTN = DDACTN                                            CER001
     C                   IF        ULX609 = 'Y'                                               CER001
     C                   IF        DDACTN <> 'A'                                              CER001
     C                   MOVE      DDCUSN        K@CUST                                       CER001
     C                   EXSR      RTVEXT1                                                    CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      * In case of Amend, do not display screen and delete record                             CER001
      * on Invalid file                                                                       CER001
      *                                                                                       CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                            99                      CER001
     C  N99              DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   IF        DDACTN <> 'A'                                              CER001
     C                   MOVE      DDCUSN        K@CUST                                       CER001
     C                   EXSR      RTVEXT2                                                    CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      * In case of Amend, do not display screen and delete record                             CER001
      * on Invalid file                                                                       CER001
      *                                                                                       CER001
     C     ZATRNKX0      CHAIN     RTVIDX2                            99                      CER001
     C  N99              DELETE    RTVIDX2                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                         163820
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     DDCUSN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVCUS
      *                                                                         CPB002
      * Check if customer is a Portfolio Management customer.                   CPB002
     C                   EXSR      CHKPTFR                                      CPB002
      *
      * If Customer details were retrieved
      * Convert the Customer to screen format.
      *
     C     C_BBCUST      IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      CVTCUS
     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
     C                   MOVEL     CrPbFilFmt    NwPbFilFmt
     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
     C                   EVAL      V_DDGCUS = CG_CUGCUS                                       CGP001
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                              CSW207A
     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                  CSW207A
     C                   ENDIF                                                               CSW207A
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Customers file (except for the Midas Customer
      * reference retrieved above using the front office transaction ID).
      * Access invalid Customer with timestamp and front office transaction ID.
      *
      * Customer details:
     C                   MOVEL     DDCUSN        ##DDCUSN          6
     C     ZATRNKX0      CHAIN     SDICUSDX0                          99
      *
      * Base rate tax details:
     C     *IN99         IFEQ      *OFF
     C     S01383        ANDEQ     'Y'
     C     ZATRNKX0      CHAIN     SDICUBRX0                          98
     C                   ENDIF
      *
      * Private banking details:
     C     *IN99         IFEQ      *OFF
     C     BGN4ST        ANDEQ     'Y'
     C     ZATRNKX0      CHAIN     SDICUPBX0                          99
     C                   ENDIF
      *                                                                                      CSW207A
      * Customer Swift Details:                                                              CSW207A
     C     *IN99         IFEQ      *OFF                                                      CSW207A
     C     BGN4ST        IFEQ      'Y'                                                       CSW207A
     C     CSW207        OREQ      'Y'                                                       CSW207A
     C     ZATRNKX0      CHAIN     SDISWFXD0                          99                     CSW207A
     C                   ENDIF                                                               CSW207A
     C                   ENDIF                                                               CSW207A
      *
      * If private banking indicator on primary details screen is invalid
      * repair cannot proceed
      *
     C                   IF        DDPRBA <> *BLANKS and
     C                             DDPRBA <> 'N' and
     C                             DDPRBA <> 'Y'
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDACTNOK = 'N'
     C                   ENDIF
      *
      * If any non-input fields on private banking screen are invalid
      * repair cannot proceed
      *
     C                   EXSR      VAL@VV
     C     'DDHOLD    '  LOOKUP    FldNameArr                             97
     C                   IF        *IN97 = '0'
     C     'DDNUAC    '  LOOKUP    FldNameArr                             97
     C                   ENDIF
     C                   IF        *IN97 = '0'
     C     'DDAGEN    '  LOOKUP    FldNameArr                             97
     C                   ENDIF
     C                   IF        *IN97 = '0'
     C     'DDPBST    '  LOOKUP    FldNameArr                             97
     C                   ENDIF
 
     C                   IF        *IN97 = '1'
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDACTNOK = 'N'
     C                   ENDIF
      *                                                                         CAP011
      * If Customer details were retrieved and this is an amendment             CAP011
      *                                                                         CAP011
     C     C_BBCUST      IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
                                                                                CAP011
     C     GHSUBS        SCAN      NewCuPrim                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepPrim = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewCuSeco                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepSeco = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewCuMT3X                              99                  CSW024
     C                   if        *in99                                                      CSW024
     C                   eval      RepMT3X = 'Y'                                              CSW024
     C                   endif                                                                CSW024
                                                                                              CSW024
     C     GHSUBS        scan      NewCuMsg                               99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepMsrt = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewCuBrt1                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepBrTx = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewCuBrt2                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepBrTx = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewCuPriv                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepPriv = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                             CSW207A
     C     GHSUBS        SCAN      NewCuPrim                              99                 CSW207A
     C                   if        *in99                                                     CSW207A
     C                   eval      RepPrim = 'Y'                                             CSW207A
     C                   endif                                                               CSW207A
                                                                                CAP011
      ** If any of the flags set above is true, do the data                     CAP011
      ** substution subroutine.                                                 CAP011
     C                   if        (RepPrim = 'Y' OR RepSeco = 'Y' OR           CAP011
     C                              RepMsrt = 'Y' OR RepBrTx = 'Y' OR           CAP011
     C**********                    RepPriv = 'Y')                                     CAP011 CSW024
     C**********                    RepPriv = 'Y' OR RepMT3X = 'Y')                   CSW024 CSW207A
     C                              RepPriv = 'Y' OR RepMT3X = 'Y' OR                        CSW207A
     C                              RepSwft = 'Y')                                           CSW207A
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   END                                                    CAP011
                                                                                CAP011
      * Setup settlement instructions on amend                                  CAP011
                                                                                CAP011
     C***LH              EXSR      SetupAmend                                   CAP011
                                                                                CAP011
      * Data Substitution - Settlement Details                                  CAP011
                                                                                CAP011
     C**LH GHSUBS        ifne      *blank                                       CAP011
     C**LH GHSUBS        SCAN      ##PAYS                                 99    CAP011
     C* N99GHSUBS        SCAN      ##RECS                                 99    CAP011
     C**   *IN99         IFEQ      *ON                                          CAP011
     C**LH               EXSR      SDtDtaSubs                                   CAP011
     C***LH              END                                                    CAP011
     C***LH              END                                                    CAP011
                                                                                CAP011
     C                   END                                                    CAP011
      *
      * If action code, or Customer reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the Customers error messages to the primary details screen
      * and GO TO PRIMARY DETAILS SCREEN
      *
 
     C                   EXSR      SNDM@P
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   MOVE      'P'           @SCRN
 
      * ELSE IF NO INVALID Customer READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'I'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   ADD       1             E
      *
      * Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      * first by the user
      *
     C                   Eval      TmpfldNmAr = *BLANKS
     C                   Eval      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKCuPrim      @EI
      *
      ** Read error messages for Customer
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C/COPY WNCPYSRC,SDCUSDRC03
 
     C**********         CALLB     'ZACGTFLDNO'                                              BUG9081
     C**********         PARM      *BLANK        ReturnCode                                  BUG9081
     C**********         PARM                    FormatP                                     BUG9081
     C**********         PARM                    ABFIELDNAM                                  BUG9081
     C**********         PARM      *ZERO         FieldNo                                     BUG9081
 
     C**********         IF        ReturnCode = *blank                                       BUG9081
     C                   IF        ABFIELDID <=  FldOffsetS                                  BUG9081
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetP    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C     ABFIELDNAM    IFEQ      'DDCDEL'                                     CPB002
     C     ABMSGID       ANDEQ     'USR4592'                                    CPB002
     C                   ELSE                                                   CPB002
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                  CPB002
     C                   ENDIF
     C/COPY WNCPYSRC,SDCUSDRC04
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKCuPrim
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@B - SEND A MESSAGE TO BASE RATE TAX SCREEN
      *****************************************************************
     C     SNDM@B        BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKCuBrt       @EI
      *
      ** Read error messages for Customer
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C**********         CALLB     'ZACGTFLDNO'                                              BUG9081
     C**********         PARM      *BLANK        ReturnCode                                  BUG9081
     C**********         PARM                    FormatB                                     BUG9081
     C**********         PARM                    ABFIELDNAM                                  BUG9081
     C**********         PARM      *ZERO         FieldNo                                     BUG9081
 
     C**********         IF        ReturnCode = *blank                                       BUG9081
     C                   IF        ABFIELDID  >  FldOffsetB And                              BUG9081
     C                             ABFIELDID <=  FldOffsetV                                  BUG9081
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   EVAL      F = F - FldOffstBF
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           OKCuBrt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@V - SEND A MESSAGE TO PRIVATE BANKING DETAILS SCREEN
      *****************************************************************
     C     SNDM@V        BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKCuPriv      @EI
      *
      ** Read error messages for Customer
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C**********         CALLB     'ZACGTFLDNO'                                              BUG9081
     C**********         PARM      *BLANK        ReturnCode                                  BUG9081
     C**********         PARM                    FormatV                                     BUG9081
     C**********         PARM                    ABFIELDNAM                                  BUG9081
     C**********         PARM      *ZERO         FieldNo                                     BUG9081
 
     C**********         IF        ReturnCode = *blank                                       BUG9081
     C                   IF        ABFIELDID  = 52          Or                               BUG9081
     C                             ABFIELDID  >  FldOffsetV                                  BUG9081
     C                             And ABFIELDID <=  FldOffsetExt                             CER001
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C**********         Z-ADD     FieldNo       F                                           BUG9081
     C                   SUB       FldOffsetP    F                                           BUG9081
     C                   EVAL      F = F - FldOffsetV - 1
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           OKCuPriv
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@S - SEND A MESSAGE TO SECONDARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@S        BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKCuSeco      @EI
      *
      ** Read error messages for Customer
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C**********         CALLB     'ZACGTFLDNO'                                              BUG9081
     C**********         PARM      *BLANK        ReturnCode                                  BUG9081
     C**********         PARM                    FormatS                                     BUG9081
     C**********         PARM                    ABFIELDNAM                                  BUG9081
     C**********         PARM      *ZERO         FieldNo                                     BUG9081
 
     C**********         IF        ReturnCode = *blank                                       BUG9081
     C                   IF        ABFIELDID  >  FldOffsetS And                              BUG9081
     C                             ABFIELDID  <  FldOffsetF                                  BUG9081
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   EVAL      F= F - FldOffStPL
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           OKCuSeco
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW024
      * SNDM@F - SEND A MESSAGE TO MESSAGE DETAILS SCREEN                                     CSW024
      *****************************************************************                       CSW024
     C     SNDM@F        BEGSR                                                                CSW024
      *                                                                                       CSW024
      ** Initialize error indicators                                                          CSW024
      *                                                                                       CSW024
     C                   MOVEA     OKCuMT3X      @EI                                          CSW024
      *                                                                                       CSW024
      ** Read error messages for Customer                                                     CSW024
      *                                                                                       CSW024
     C     ZATRNKD0      SETLL     ZATRNERRD0                                                 CSW024
     C     ZATRNKD0      READE     ZATRNERRD0                             99                  CSW024
      *                                                                                       CSW024
      ** Add error message to array passed to detail screen                                   CSW024
      ** and set OK flag for field to 'N'                                                     CSW024
      *                                                                                       CSW024
     C     *IN99         DOWEQ     '0'                                                        CSW024
                                                                                              CSW024
     C                   CALLB     'ZACGTFLDNO'                                               CSW024
     C                   PARM      *BLANK        ReturnCode                                   CSW024
     C                   PARM                    FormatF                                      CSW024
     C                   PARM                    ABFIELDNAM                                   CSW024
     C                   PARM      *ZERO         FieldNo                                      CSW024
                                                                                              CSW024
     C                   IF        ReturnCode = *blank                                        CSW024
     C                   ADD       1             E                                            CSW024
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)                                CSW024
     C                   MOVEL     ABMSGID       MsgIdArr(E)                                  CSW024
     C                   Z-ADD     FieldNo       F                                            CSW024
     C                   EVAL      F = FieldNo - FldOffSetF                                   CSW024
                                                                                              CSW024
     C     F             IFLT      1                                                          CSW024
     C     F             ORGT      60                                                         CSW024
     C                   Z-ADD     1             F                                            CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CSW024
     C                   MOVE      'N'           @EI(F)                                       CSW024
                                                                                              CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CSW024
     C     ZATRNKD0      READE     ZATRNERRD0                             99                  CSW024
                                                                                              CSW024
     C                   ENDDO                                                                CSW024
                                                                                              CSW024
     C                   MOVEA     @EI           OKCuMT3X                                     CSW024
                                                                                              CSW024
     C                   ENDSR                                                                CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MESSAGE DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKCuMsg       @EI
      *
      ** Read error messages for Customer
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C/COPY WNCPYSRC,SDCUSDRC05
     C**********         CALLB     'ZACGTFLDNO'                                              BUG9081
     C**********         PARM      *BLANK        ReturnCode                                  BUG9081
     C**********         PARM                    FormatM                                     BUG9081
     C**********         PARM                    ABFIELDNAM                                  BUG9081
     C**********         PARM      *ZERO         FieldNo                                     BUG9081
 
     C**********         IF        ReturnCode = *blank                                       BUG9081
     C                   IF        ABFIELDID  >  FldOffsetM And                              BUG9081
     C                             ABFIELDID <=  FldOffsetB                                  BUG9081
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F
     C                   EVAL      F= F - FldOffstSL - FldOffstPL + FldOffSetS
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
     C/COPY WNCPYSRC,SDCUSDRC06
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   END
      *
     C                   MOVEA     @EI           OKCuMsg
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
      *****************************************************************
     C     SCRN@P        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & Customer reference; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'E')                         CAP014
      *
     C     DDACTN        IFEQ      'I'                                          CAP014
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     DDACTN        OREQ      'A'                                          CAP014
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD                         CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     'N'           @EDTFD                         CAP014
     C                   END                                                    CAP014
      *                                                                         CAP014
      * KJ = COMMAND KEY 10 = CONFIRM DELETE                                    CAP014
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      * Update 'previous' screen
      ** Update Previous Warning messages                                                     CGP001
     C                   MOVEL     NewCuPrim     PrvCuPrim
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn                                    CGP001
      *
      * Set function key status on PRIMARY screen
     C                   EXSR      SFKEYS
      *                                                                                       CSW024
      ** If action code, or Customer reference were NOT OK                                    CSW024
      ** blank out action code so that the input cannot proceed                               CSW024
      *                                                                                       CSW024
     C     DDACTNOK      IFEQ      'N'                                                        CSW024
     C     DDCUSNOK      OREQ      'N'                                                        CSW024
     C                   MOVEL     *BLANK        DDACTN                                       CSW024
     C                   ENDIF                                                                CSW024
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C                   CALLB     'SDCUSD2DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Customer (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewCuPrim
      *
      * Fields in error
     C                   PARM                    OKCuPrim
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
      *                                                                         CAP014
      * ENABLED KEY & DETAIL FIELDS                                             CAP014
      *                                                                         CAP014
     C                   PARM      'N'           @EKYFD            1            CAP014
     C                   PARM                    @EDTFD            1            CAP014
      *                                                                         CAP014
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE                                                  CSW024
      * KW = COMMAND KEY 22 = CONFIRM CLOSURE/RELEASE                                         CSW024
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM      'N'           @EINKG            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKW            1                          CSW024
     C                   PARM                    @EINKX            1
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
     C                   PARM      *BLANKS       PTransType                                   CSD028
      *                                                                                       CSW207
      * Customer (IN SCREEN FORMAT - Swift Details)                                           CSW207
     C                   PARM                    NewCuSwft                                    CSW207
      *                                                                                       CSW207
      * Fields in error                                                                       CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL
     C/COPY WNCPYSRC,SDH00103
     C                   PARM      '0'           @INKW             1                          CSW024
     C                   PARM      '0'           @INKX             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      * Validate input to Primary screen
     C                   CAS                     VAL@P
     C                   ENDCS
      *
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
      *                                                                                       195255
      * COMMIT here to avoid the loss of records if F12 is used in SD0014V                    195255
      *                                                                                       195255
     C                   COMMIT                                                               195255
      *                                                                                       195255
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      *
      * Retrieve Customer details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVCUS
      *
      * If action code, or Customer reference are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *                                                                         CPB002
      * Check if customer is a Portfolio Management customer.                   CPB002
     C                   EXSR      CHKPTFR                                      CPB002
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C*****DDACTN        IFEQ      'D'                                                        218591
      **********                                                                              218591
      **IF*CK/10*TAKEN,*GO*ONTO*UPDATES********************************                       218591
      **********                                                                              218591
     C*****@EINKJ        IFEQ      'Y'                                                        218591
     C**********         MOVEL     'U'           @SCRN                                        218591
     C**********         END                                                                  218591
     C**********         GOTO      EndVAL@P                                                   218591
     C**********         END                                                                  218591
      *
      *----------------------------------------------------------------
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Customer in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   CLEAR                   NwCuFilFmt
      *
      * Determine whether BRT customer and initialise controls
      *
     C     S01383        IFEQ      'Y'
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'                                                        CRE007
     C                   MOVE      '1'           BRTSCREEN
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   ENDIF
     C                   ENDIF
      *
      * Validate Primary Customer details
      *
     C                   CALLB     'SDCUSD2VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Customer Primary Details
     C                   PARM                    NewCuPrim
 
      * Customer Extra Data file data
     C                   PARM                    ExtData
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
                                                                                              CSW207
      ** Customer SWIFT Extension                                                             CSW207
     C                   PARM                    NewCuSwft                                    CSW207
 
      * OUTPUTS :
 
      ** Customer Primary Details OK inds
     C                   PARM                    OKCuPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_PVAL
      * Valid Customer layout (DS) from/to caller
      ** Valid Global Customer ID                                                             CGP001
     C                   PARM                    NwCuFilFmt
     C                   PARM                    V_DDGCUS                                     CGP001
      ** Customer SWIFT Details OK inds                                                       CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      * Valid Customer SWIFT Details  (DS) from/to caller                                     CSW207
     C                   PARM                    NwSwFilFmt                                   CSW207
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      *
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     NewCuPrim     IFNE      PrvCuPrim
     C     WIdx_PVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * If Further Details has not been selected go the Secondary Screen
     C     @INKX         IFEQ      '0'
      *                                                                                       218591
      ** If delete                                                                            218591
      *                                                                                       218591
     C     @INKJ         IFEQ      '0'                                                        218591
      *
      * If Base Rate Tax is OFF
     C     S01383        IFEQ      'N'
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@P
     C                   ENDIF
      *
      * Display participant details if account holder type I or J
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'                                                        CRE007
     C                   MOVE      'X'           @SCRN
     C                   ELSE
     C                   EXSR      VAL@T
     C                   MOVE      'S'           @SCRN
     C                   ENDIF
      *                                                                                       218591
      ** If delete (F10) has been selected: go onto updates                                   218591
      *                                                                                       218591
     C                   ELSE                                                                 218591
     C                   MOVE      'U'           @SCRN                                        218591
     C                   ENDIF                                                                218591
      *
      * If Further Details (F23) has been selected:
     C                   ELSE
      *
      * Return to Primary Detail Screen after Further Details
     C                   MOVE      'P'           @SCRN
      *
     C                   ENDIF
      *
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - PROCESS BASE RATE TAX DETAILS SCREEN
      *****************************************************************
     C     SCRN@B        BEGSR
 
      * IF ACTION CODE IS DELETE
      * BYPASS SCREEN PROCESSING AND PROCESS BRT DATA
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VAL@T
     C                   MOVE      'U'           @SCRN
     C                   GOTO      EndBDSP
     C                   ENDIF
 
      *                                                                         CAP014
      * If no changes are allowed, protect (but still validate)                 CAP014
      * all instructions by passing action code 'E' to SDCUSD6DP                CAP014
      *                                                                         CAP014
     C     @OPSEL        IFEQ      'N'                                          CAP014
     C                   MOVEL     'E'           ##ACTN            1            CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     DDACTN        ##ACTN                         CAP014
     C                   ENDIF                                                  CAP014
     C                   MOVEL     ##ACTN        DDACTN                         CAP014
 
     C                   CALLB     'SDCUSD6DP'
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Primary Details
      * Base Rate Tax Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuBrt
      *
      * Fields in error
     C                   PARM                    OKCuBrt
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
      * ENABLED FUNCTION KEYS
      * Display first or second page of Base Rate Tax details
     C                   PARM                    BRTSCREEN         1
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKS             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Base Rate Tax Screen
     C     @INKL         CASEQ     '1'           CANC@B
      *
      * Validate name changes and process participant history DS
     C     CHGNAME       CASEQ     '1'           VAL@T
      *
      * Validate Input to Base Rate Tax Screen
     C                   CAS                     VAL@B
      *
     C                   ENDCS
      *
     C     EndBDSP       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@B  - VALIDATE INPUT TO BASE RATE TAX DETAILS
      *****************************************************************
     C     VAL@B         BEGSR
      *
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * From BRT screen 1, go to screen 2 if there are details to view
      * otherwise return to browse screen
      *
     C     BRTSCREEN     IFEQ      '1'
     C     DD3NAM        ANDNE     *BLANKS
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@B
     C                   ENDIF
      *
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** For account holder type I
      ** or  account holder type R                                                            CRE007
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'R'                                                        CRE007
      *
      ** If user has just left screen 1
     C     BRTSCREEN     IFEQ      '1'
      *
      ** If names have been entered for both parties 1 and 2 or
      ** party 3 has a name
     C     DD1NAM        IFNE      *BLANKS
     C     DD2NAM        ANDNE     *BLANKS
     C     DD3NAM        ORNE      *BLANKS
      *
      ** display the second screen before validating
     C                   MOVE      '2'           BRTSCREEN
     C                   GOTO      EndVAL@B
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           BRTSCREEN
     C                   ENDIF
      *
      ** For account holder type J
      *
     C                   ELSE
      *
      ** As long as there are parties on screen 2, toggle between first
      ** and second BRT screens if displaying after validation
      *
     C     DD3NAM        IFNE      *BLANKS
     C     BRTSCREEN     IFEQ      '1'
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVE      '1'           BRTSCREEN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_BVAL
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      *
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuBrt      PrvCuBrt
     C                   Z-ADD     WIdx_BVAL     PrvN_Warn         3 0
      *
      * Validate Base Rate Tax Details
      *
     C                   CALLB     'SDCUSD6VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Customer Number
     C                   PARM                    DDCUSN
      *
      * Account Holder Type
     C                   PARM                    DDTAIN
      *
      ** Customer Base Rate Tax Details
     C                   PARM                    NewCuBrt
      *
      ** Screen validation
     C                   PARM      '1'           SinVal            1
      *
      * OUTPUTS :
      ** Customer Base Rate Tax Details
     C                   PARM                    OKCuBrt
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_BVAL
      *
      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    NwBrFilFmt
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr
      *
      * If any errors redisplay screen
     C     Idx           IFNE      0
     C                   GOTO      ENDVAL@B
     C                   ENDIF
      *
      * If there are any warnings, redisplay screen
     C     WIdx_BVAL     IFNE      PrvN_Warn
      * Delay any new name prompt that may be necessary
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   GOTO      EndVAL@B
     C                   ELSE
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   END
      *
      * Determine whether there are changed/new names among participants
     C                   EXSR      PARNAMES
      *
      * If any changed names, redisplay screen for user to confirm
      * this is a name change or a new participant
      *
     C     DDACTN        IFEQ      'A'
     C     CHGNAME       ANDEQ     '1'
     C                   GOTO      ENDVAL@B
     C                   ENDIF
      *
     C                   EXSR      VAL@T
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Move on to Secondary Screen
     C                   MOVE      'S'           @SCRN
      *
      * End of Insert/Amend condition controlling validation call
     C                   ENDIF
      *
      *
     C     EndVAL@B      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SECOND SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuPrim     PrvCuPrim
     C                   MOVEL     NewCuSeco     PrvCuSeco
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn
      *
      ** WRITE/READ DISPLAY SCREEN - Secondary Details
      *
     C                   CALLB     'SDCUSD3DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Customer (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuSwft                                    CSW207
      *
      *
      * Fields in error
     C                   PARM                    OKCuSeco
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED Function Keys
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM      'N'           @EINKJ
     C                   PARM                    @EINKX
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * Validate Input to Secondary Screen
     C                   CAS                     VAL@S
      *
     C                   ENDCS
      *
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C                   EXSR      FURDET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF F10 TAKEN, GO ON TO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_SVAL
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVE      *ALL'Y'       OKCuSeco
      *
      * Validate Secondary Screen details
      *
     C                   CALLB     'SDCUSD3VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Customer Primary Details
     C                   PARM                    NewCuPrim
      ** Customer Secondary Details
     C                   PARM                    NewCuSeco
      * Customer Extra Data file data
     C                   PARM                    ExtData
      ** SWIFT Detail                                                                         CSW207
     C                   PARM                    NewCuSwft                                    CSW207
      *
      * OUTPUTS :
      *
      ** Customer Secondary Details OK inds
     C                   PARM                    OKCuSeco
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_SVAL
      * Valid Customer layout (DS) from/to caller
     C                   PARM                    NwCuFilFmt
      * Valid SWIFT Details layout (DS) from/to caller                                        CSW207
     C                   PARM                    NwSwFilFmt                                   CSW207
      ** Customer SWIFT Details OK inds                                                       CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewCuSeco     IFNE      PrvCuSeco
     C     WIdx_SVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * If Further Details not selected, go to Message details screen
      *
     C     @INKX         IFEQ      '0'
      *                                                                                       CSW024
      ** If MT3xx BEI enhancement has been installed and                                      CSW024
      ** SWIFT/Direct Link module is on then display                                          CSW024
      ** screen for MT3xx BEI details                                                         CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
     C                   MOVEL     'F'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF                                                                CSW024
                                                                                              CSW024
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       CSW024
      ** For Enquire without update:                                                          CSW024
      ** If MT3xx BEI enhancement has been installed and                                      CSW024
      ** SWIFT/Direct Link module is on then display                                          CSW024
      ** screen for MT3xx BEI details                                                         CSW024
     C                   IF        DDACTN = 'E'                                               CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
     C                   MOVEL     'F'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'M'           @SCRN                                        CSW024
     C                   ENDIF                                                                CSW024
     C                   ENDIF                                                                CSW024
      *
     C     EndVAL@S      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW024
      *                                                               *                       CSW024
      * SCRN@F - Process MT3xx BEI and Fund Details screen            *                       CSW024
      *                                                               *                       CSW024
      *****************************************************************                       CSW024
                                                                                              CSW024
     C     SCRN@F        BEGSR                                                                CSW024
                                                                                              CSW024
      * Update 'previous' screens and previous number of warnings                             CSW024
                                                                                              CSW024
     C                   MOVEL     NewCuMT3X     PrvCuMT3X                                    CSW024
     C                   Z-ADD     WIdx_FVAL     PrvN_Warn                                    CSW024
      *                                                                                       CSW024
      ** Write/read display - MT3xx BEI and Fund details screen                               CSW024
      *                                                                                       CSW024
     C                   CALLB     'SDCUSD8DP'                                                CSW024
      *                  =====================                                                CSW024
      ** INPUT                                                                                CSW024
      *  =====                                                                                CSW024
      *                                                                                       CSW024
      ** Return Code                                                                          CSW024
     C                   PARM      *BLANK        RetCodeOut                                   CSW024
      *                                                                                       CSW024
      ** New Customer in Screen Format - Primary Details                                      CSW024
     C                   PARM                    NewCuPrim                                    CSW024
      *                                                                                       CSW024
      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
     C                   PARM                    NewCuMT3x                                    CSW024
      *                                                                                       CSW024
      ** Fields in error                                                                      CSW024
     C                   PARM                    OKCuMT3x                                     CSW024
      *                                                                                       CSW024
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
     C                   PARM                    FldNameArr                                   CSW024
     C                   PARM                    MsgIdArr                                     CSW024
     C                   PARM                    MsgDtaArr                                    CSW024
      *                                                                                       CSW024
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
     C                   PARM                    WFldNamArr                                   CSW024
     C                   PARM                    WMsgIdArr                                    CSW024
     C                   PARM                    WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** Enabled Function Keys                                                                CSW024
      ** KJ = Command Key 10 = DELETE                                                         CSW024
      ** KX = Command Key 23 = FURTHER DETAILS                                                CSW024
     C                   PARM      'N'           @EINKJ                                       CSW024
     C                   PARM      'Y'           @EINKX                                       CSW024
      *                                                                                       CSW024
      ** Write screen with no read indicator                                                  CSW024
     C                   PARM      'N'           WriteOnly                                    CSW024
      *                                                                                       CSW024
      ** OUTPUT                                                                               CSW024
      ** ======                                                                               CSW024
      *                                                                                       CSW024
      ** Function Keys                                                                        CSW024
     C                   PARM      '0'           @INKC                                        CSW024
     C                   PARM      '0'           @INKJ                                        CSW024
     C                   PARM      '0'           @INKL                                        CSW024
     C                   PARM      '0'           @INKX                                        CSW024
      *                                                                                       CSW024
      ** Reset errors                                                                         CSW024
      *                                                                                       CSW024
     C                   MOVE      *ALL'Y'       OKCuMT3X                                     CSW024
     C                   MOVEL     *BLANK        FldNameArr                                   CSW024
     C                   MOVEL     *BLANK        MsgIdArr                                     CSW024
     C                   MOVEL     *BLANK        MsgDtaArr                                    CSW024
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** F3 - End Program                                                                     CSW024
     C     @INKC         CASEQ     '1'           ENDP                                         CSW024
      *                                                                                       CSW024
      ** F12 - Cancel on Message Details Screen                                               CSW024
     C     @INKL         CASEQ     '1'           CANC@F                                       CSW024
      *                                                                                       CSW024
      ** Validate Input to Message Details Screen                                             CSW024
     C                   CAS                     VAL@F                                        CSW024
      *                                                                                       CSW024
     C                   ENDCS                                                                CSW024
      *                                                                                       CSW024
      ** On F23, go to Further Details, if there are no errors                                CSW024
      *                                                                                       CSW024
     C     DDACTN        IFNE      'I'                                                       BUG3362
     C     @INKX         IFEQ      '1'                                                        CSW024
     C     Idx           ANDEQ     0                                                          CSW024
     C                   EXSR      FURDET                                                     CSW024
     C                   ENDIF                                                                CSW024
     C                   ENDIF                                                               BUG3362
      *                                                                                       CSW024
     C                   ENDSR                                                                CSW024
                                                                                              CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************                       CSW024
      *                                                               *                       CSW024
      * VAL@F - Validate MT3xx BEI and Fund Details screen            *                       CSW024
      *                                                               *                       CSW024
      *****************************************************************                       CSW024
                                                                                              CSW024
     C     VAL@F         BEGSR                                                                CSW024
      *                                                                                       CSW024
      ** Prior to validation, initialize error indicators as 'OK'                             CSW024
      *                                                                                       CSW024
     C                   Z-ADD     *ZERO         Idx                                          CSW024
     C                   Z-ADD     *ZERO         WIdx_Fval                                    CSW024
     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
      *                                                                                       CSW024
      ** If Insert or Amend                                                                   CSW024
      *                                                                                       CSW024
     C     DDACTN        IFEQ      'I'                                                        CSW024
     C     DDACTN        OREQ      'A'                                                        CSW024
      *                                                                                       CSW024
      ** Validate message details screen                                                      CSW024
      *                                                                                       CSW024
     C                   CALLB     'SDCUSD8VL'                                                CSW024
      *                  =====================                                                CSW024
      ** INPUTS                                                                               CSW024
      ** ======                                                                               CSW024
      *                                                                                       CSW024
      ** Return Code                                                                          CSW024
     C                   PARM      *BLANK        RetCodeOut                                   CSW024
      *                                                                                       CSW024
      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
     C                   PARM                    NewCuMT3x                                    CSW024
      *                                                                                       CSW024
      ** Fields in error                                                                      CSW024
     C                   PARM                    OKCuMT3x                                     CSW024
      *                                                                                       CSW024
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
     C                   PARM                    FldNameArr                                   CSW024
     C                   PARM                    MsgIDArr                                     CSW024
     C                   PARM                    MsgDtaArr                                    CSW024
      *                                                                                       CSW024
      ** Array index (3P0) from/to caller                                                     CSW024
     C                   PARM                    Idx                                          CSW024
      *                                                                                       CSW024
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
     C                   PARM                    WFldNamArr                                   CSW024
     C                   PARM                    WMsgIDArr                                    CSW024
     C                   PARM                    WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** Array index (3P0) from/to caller                                                     CSW024
     C                   PARM                    WIdx_Fval                                    CSW024
      *                                                                                       CSW024
      ** Valid Customer layout (DS) from/to caller                                            CSW024
     C                   PARM                    NwCuFilFmt                                   CSW024
      *                                                                                       CSW024
      ** If errors returned                                                                   CSW024
      *                                                                                       CSW024
     C     Idx           IFNE      0                                                          CSW024
     C                   GOTO      EndVAL@F                                                   CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
      ** If the screen has changed in the course of the validation                            CSW024
      ** or if there are warnings which have not been displayed                               CSW024
      ** re-output the screen                                                                 CSW024
      *                                                                                       CSW024
     C     NewCuMT3x     IFNE      PrvCuMT3x                                                  CSW024
     C     WIdx_Fval     ORNE      PrvN_Warn                                                  CSW024
     C                   GOTO      EndVAL@F                                                   CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
      ** Clear any warning messages                                                           CSW024
      *                                                                                       CSW024
     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** If displaying Further Details, return to secondary details screen                    CSW024
      ** otherwise, move to message details screen.                                           CSW024
      *                                                                                       CSW024
     C     @INKX         IFNE      '1'                                                        CSW024
     C                   MOVEL     'M'           @SCRN                                        CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
      ** For Enquire without update:                                                          CSW024
      ** If displaying Further Details, return to secondary details screen                    CSW024
      ** otherwise, move to message details screen.                                           CSW024
      *                                                                                       CSW024
     C     @INKX         IFNE      '1'                                                        CSW024
     C     DDACTN        ANDEQ     'E'                                                        CSW024
     C                   MOVEL     'M'           @SCRN                                        CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C     EndVAL@F      ENDSR                                                                CSW024
                                                                                              CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************
      * SCRN@M - PROCESS MESSAGE DETAILS SCREEN
      *****************************************************************
     C     SCRN@M        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuMsg      PrvCuMsg
     C                   Z-ADD     WIdx_MVAL     PrvN_Warn
      *
      ** WRITE/READ DISPLAY - Message Details Screen
      *
     C                   CALLB     'SDCUSD4DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Customer (IN SCREEN FORMAT) - Primary/Secondary/Other Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuMsg
      *
      *
      * Fields in error
     C                   PARM                    OKCuMsg
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED FUNCTION KEYS
      * KJ = COMMAND KEY 10 = DELETE
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM      'N'           @EINKJ
     C                   PARM                    @EINKX
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuMsg
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Message Details Screen
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * Validate Input to Message Details Screen
     C                   CAS                     VAL@M
      *
     C                   ENDCS
      *
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C                   EXSR      FURDET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MESSAGE DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_MVAL
     C                   MOVE      *ALL'Y'       OKCuMsg
     C                   Z-ADD     WIdx_Mval     PrvN_Warn
      *
      * Validate "Message Details" Screen
      *
     C                   CALLB     'SDCUSD4VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Customer Primary Details
      ** Customer Secondary Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
      ** Customer Message Details
     C                   PARM                    NewCuMsg
      * Customer Extra Data file data
     C                   PARM                    ExtData
 
      ** Message details OK inds
     C                   PARM                    OKCuMsg
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_MVAL
 
      * Valid Customer layout (DS) from/to caller
     C                   PARM                    NwCuFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@M
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewCuMsg      IFNE      PrvCuMsg
     C     WIDx_Mval     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@M
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuMsg
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * If displaying Further Details, return to secondary details screen
      * Otherwise move on to message detail screen
      ** (but if window processing is on but Private Banking is off, display window)          218591
      *
     C     @INKX         IFNE      '1'
     C     BGN4ST        IFEQ      'Y'                                                        218591
     C                   MOVEL     'V'           @SCRN
     C                   ELSE                                                                 218591
     C     BGWDPR        IFEQ      'Y'                                                        218591
     C                   MOVE      'W'           @SCRN                                        218591
     C                   ENDIF                                                                218591
     C                   ENDIF                                                                218591
     C                   END
      *
     C                   ELSE                                                                 CSW024
      *                                                                                       CSW024
      ** For Enquire without update:                                                          CSW024
     C     @INKX         IFNE      '1'                                                        CSW024
     C     BGN4ST        IFEQ      'Y'                                                        218591
     C                   MOVEL     'V'           @SCRN                                        CSW024
     C                   ELSE                                                                 218591
     C     BGWDPR        IFEQ      'Y'                                                        218591
     C                   MOVE      'W'           @SCRN                                        218591
     C                   ENDIF                                                                218591
     C                   ENDIF                                                                218591
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C                   ENDIF
      *
     C     EndVAL@M      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@V - PROCESS Private Banking Details Screen
      *****************************************************************
     C     SCRN@V        BEGSR
 
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuPriv     PrvCuPriv
 
     C                   CALLB     'SDCUSD5DP'
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Primary Details
      * Private Banking Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuPriv
      *
      * Fields in error
     C                   PARM                    OKCuPriv
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * ENABLED FUNCTION KEYS
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKX            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKX
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuPriv
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Base Rate Tax Screen
     C     @INKL         CASEQ     '1'           CANC@V
      *
      * Validate Input to Private Banking Screen
     C                   CAS                     VAL@V
      *
     C                   ENDCS
      *
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C                   EXSR      FURDET
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      * SCRN@L - PROCESS Extension Details Screen                                             CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     SCRN@L        BEGSR                                                                CER001
      *                                                                                       CER001
      ** If ULX609 is not installed go to the next extension screen.                          CER001
      ** Also, do not show extension details for amend action, go to                          CER001
      ** the next extension details.                                                          CER001
      *                                                                                       CER001
     C                   IF        ULX609 <> 'Y' OR                                           CER001
     C                             ULX609 = 'Y' AND DDACTN = 'A'                              CER001
     C                   EVAL      @SCRN    = 'N'                                             CER001
     C                   LEAVESR                                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      DDCUSN        #1CUST                                       CER001
     C                   MOVE      DDPAIN        #1PAIN                                       CER001
     C                   MOVE      DDPCNB        #1PCNB                                       CER001
     C                   MOVE      DDCOLC        #1COLC                                       CER001
     C                   MOVE      DDLINC        #1LINC                                       CER001
     C                   MOVE      DDBRCD        #1BRCD                                       CER001
     C                   MOVE      DDBNBI        #1BNBI                                       CER001
     C                   MOVE      DDCNCZ        #2CNCZ                                       CER001
     C                   MOVE      DDTMESTMP     #1TMST                                       CER001
     C                   MOVE      DDFOTRANID    #1FOTR                                       CER001
     C                   MOVE      DDCRNM        #1CRNM                                       CER001
      *                                                                                       CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      PWAction = 'E'                                             CER001
     C                   EVAL      #1DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      PWAction = DDACTN                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'SDCUSD2RP'                                                CER001
     C                   PARM      *Blanks       RetCodeIn                                    CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM      *Blanks       PWRtn                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    NwDlFilFmt1                                  CER001
     C                   PARM                    ULX008                                       CER001
     C                   PARM                    ULX012                                       CER001
     C                   PARM                    BJMRDT                                       CER001
     C                   PARM                    BGLRIN                                       CER001
     C                   PARM                    ULX004                                     BUG13228
     C                   EVAL      #1DEXT   = *BLANK                                          CER001
      *                                                                                       CER001
      ** If F3 pressed, end program                                                           CER001
      *                                                                                       CER001
     C     PWRtn         IFEQ      'Y2U9999'                                                  CER001
     C                   EXSR      ENDP                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** If Cmd12 pressed, return to initial screen;                                          CER001
      ** otherwise, go to settlements screen                                                  CER001
      *                                                                                       CER001
     C                   IF        PWRtn = 'USR0790'                                          CER001
      *                                                                                       CER001
     C                   IF        @RDNB = 'Y'                                                CER001
     C                   EVAL      DDACTN = SVACTN                                            CER001
     C                   EVAL      @SCRN = 'V'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      INITIAL                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
     C                   EVAL      @SCRN    = 'N'                                             CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      * SCRN@N - PROCESS Extension Details Screen                                             CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     SCRN@N        BEGSR                                                                CER001
      *                                                                                       CER001
      ** If ULX043 is not installed go directly to update processing.                         CER001
      ** Also, do not show extension details for amend action, go to                          CER001
      ** directly to update processing.                                                       CER001
      *                                                                                       CER001
     C                   IF        ULX043 <> 'Y' OR                                           CER001
     C                             ULX043 = 'Y' AND DDACTN = 'A'                              CER001
     C                   EVAL      @SCRN    = 'U'                                             CER001
     C                   LEAVESR                                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      DDCUSN        #1CUST                                       CER001
     C                   MOVE      DDPAIN        #1PAIN                                       CER001
     C                   MOVE      DDPCNB        #1PCNB                                       CER001
     C                   MOVE      DDCOLC        #1COLC                                       CER001
     C                   MOVE      DDLINC        #1LINC                                       CER001
     C                   MOVE      DDBRCD        #1BRCD                                       CER001
     C                   MOVE      DDBNBI        #1BNBI                                       CER001
     C                   MOVE      DDCNCZ        #2CNCZ                                       CER001
     C                   MOVE      DDTMESTMP     #1TMST                                       CER001
     C                   MOVE      DDFOTRANID    #1FOTR                                       CER001
     C                   MOVE      DDCRNM        #1CRNM                                       CER001
      *                                                                                       CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      PWAction = 'E'                                             CER001
     C                   EVAL      #2DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      PWAction = DDACTN                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'SDCUSD3RP'                                                CER001
     C                   PARM      *Blanks       RetCodeIn                                    CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM      *Blanks       PWRtn                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    NwDlFilFmt2                                  CER001
     C                   PARM                    BGNWST                                       CER001
     C                   PARM                    BJMRDT                                       CER001
     C                   EVAL      #2DEXT   = *BLANK                                          CER001
      *                                                                                       CER001
      ** If F3 pressed, end program                                                           CER001
      *                                                                                       CER001
     C     PWRtn         IFEQ      'Y2U9999'                                                  CER001
     C                   EXSR      ENDP                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** If Cmd12 pressed, return to initial screen;                                          CER001
      ** otherwise, go to settlements screen                                                  CER001
      *                                                                                       CER001
     C                   IF        PWRtn = 'USR0790'                                          CER001
      *                                                                                       CER001
     C                   IF        @RDNB = 'Y'                                                CER001
     C                   EVAL      DDACTN = SVACTN                                            CER001
     C                   EVAL      @SCRN = PRV_SCRN                                           CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      INITIAL                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
     C                   EVAL      @SCRN    = 'U'                                             CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      /EJECT                                                                                  189774
      *****************************************************************                       189774
      * SCRN@W - Window Processing                                                            189774
      *****************************************************************                       189774
     C     Scrn@W        BEGSR                                                                189774
     C/COPY WNCPYSRC,SDCUSDRC07
      *                                                                                       218591
     C     BGN4ST        IFEQ      'Y'                                                        218591
      *                                                                                       189774
     C                   CALLB     'SDCUSD5DP'                                                189774
      ** Input parameters                                                                     189774
     C                   PARM      *Blanks       RetCodeIn                                    189774
     C                   PARM                    NewCuPrim                                    189774
     C                   PARM                    NewCuPriv                                    189774
     C                   PARM                    OKCuPriv                                     189774
     C                   PARM                    FldNameArr                                   189774
     C                   PARM                    MsgIdArr                                     189774
     C                   PARM                    MsgDtaArr                                    189774
     C                   PARM                    @EINKX                                       189774
      ** Output parameters                                                                    189774
     C                   PARM                    @INKC                                        189774
     C                   PARM                    @INKL                                        189774
     C                   PARM                    @INKX                                        189774
     C                   PARM      'Y'           WriteOnly                                    189774
      *                                                                                       218591
     C                   ELSE                                                                 218591
      *                                                                                       218591
     C                   CALLB     'SDCUSD4DP'                                                218591
      *                                                                                       218591
      ** Input Parameters:                                                                    218591
     C                   PARM      *BLANK        RetCodeOut                                   218591
     C                   PARM                    NewCuPrim                                    218591
     C                   PARM                    NewCuMsg                                     218591
     C                   PARM                    OKCuMsg                                      218591
     C                   PARM                    FldNameArr                                   218591
     C                   PARM                    MsgIdArr                                     218591
     C                   PARM                    MsgDtaArr                                    218591
     C                   PARM                    WFldNamArr                                   218591
     C                   PARM                    WMsgIdArr                                    218591
     C                   PARM                    WMsgDtaArr                                   218591
     C                   PARM      'N'           @EINKJ                                       218591
     C                   PARM                    @EINKX                                       218591
      *                                                                                       218591
      ** Output Parameters:                                                                   218591
      *                                                                                       218591
     C                   PARM      '0'           @INKC                                        218591
     C                   PARM      '0'           @INKJ                                        218591
     C                   PARM      '0'           @INKL                                        218591
     C                   PARM      '0'           @INKX                                        218591
     C                   PARM      'N'           WriteOnly                                    218591
      *                                                                                       218591
     C                   ENDIF                                                                218591
      *                                                                                       189774
     C/COPY WNCPYSRC,SDCUSDRMV1                                                               189774
      *                                                                                       189774
     C                   CALL      'WN0010'                                                   189774
     C                   PARM      'SDCUSDRPR'   PWPgm            10                          189774
     C                   PARM                    PWKey             2                          189774
     C                   PARM      DDACTN        PWAction          1                          189774
     C                   PARM                    Data                                         189774
     C                   PARM      *Blanks       PWRtn             7                          189774
     C                   PARM                    PWSpare         256                          189774
      *                                                                                       189774
      ** If F3 pressed, end program                                                           189774
      *                                                                                       189774
     C     PWRtn         IFEQ      'Y2U9999'                                                  189774
     C                   EXSR      ENDP                                                       189774
     C                   ELSE                                                                 189774
      *                                                                                       189774
      ** Else if F12 pressed, return to Private Banking details screen                        189774
      *                                                                                       189774
     C     PWRtn         IFEQ      'USR0790'                                                  189774
      *                                                                                       218591
     C     BGN4ST        IFEQ      'Y'                                                        218591
     C                   EVAL      @SCRN = 'V'                                                189774
     C                   ELSE                                                                 218591
     C                   EVAL      @SCRN = 'M'                                                218591
     C                   ENDIF                                                                218591
      *                                                                                       218591
     C                   EVAL      WriteOnly = 'N'                                            189774
     C                   ROLBK                                                                192916
     C                   ELSE                                                                 189774
      *                                                                                       189774
      ** Else if ENTER key was pressed,                                                       189774
      **      if Insert or Delete, do update processing                                       189774
      *                                                                                       189774
     C     DDACTN        IFEQ      'I'                                                        189774
     C     DDACTN        OREQ      'A'                                                        189774
     C/COPY WNCPYSRC,SDCUSDRC08
     C                   EVAL      @SCRN = 'U'                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDSR                                                                189774
      *****************************************************************                       189774
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@V  - VALIDATE INPUT TO Private Banking Details
      *****************************************************************
     C     VAL@V         BEGSR
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
 
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKCuPriv
      *
      *
      * Validate Private Banking Details
      *
     C                   CALLB     'SDCUSD5VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      *
      ** Private Banking Customer Indicator
     C                   PARM                    DDPRBA
      *
      ** Customer Private Banking Details
     C                   PARM                    NewCuPriv
      *                                                                         CPB002
      ** Portfolio Management Customer Indicator                                CPB002
     C                   PARM                    PtfrCust          1            CPB002
      *                                                                         CPB002
      ** Account Officer                                                        CPB002
     C                   PARM                    DDACOC                         CPB002
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
     C                   PARM                    DDCUSN                                       CGL031
      *
      * OUTPUTS :
      ** Customer Base Rate Tax Details
     C                   PARM                    OKCuPriv
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Valid Private Banking layout (DS) from/to caller
     C                   PARM                    NwPBFilFmt
      *
      * If any errors redisplay screen
     C     Idx           IFNE      0
     C                   GOTO      ENDVAL@V
     C                   ENDIF
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewCuPriv     IFNE      PrvCuPriv
     C                   GOTO      EndVAL@V
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuMsg
      *
      * If displaying Further Details, go ahead, otherwise update.
      *
     C     @INKX         IFNE      '1'
      *
      * If Action Code is I or A go to Update
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     ULX043        IFEQ      'Y'                                                        CER001
     C     ULX609        OREQ      'Y'                                                        CER001
     C                   MOVE      'L'           @SCRN                                        CER001
     C                   ELSE                                                                 CER001
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                             AND  LIBR = S1SUPP                                         CSC011
     C                   Z-ADD     *ZERO         Idx                                          CSC011
     C                   MOVE      *ALL'Y'       OKCuPriv                                     CSC011
     C                   EVAL      FldNameArr = *BLANKS                                       CSC011
     C                   EVAL      MsgIdArr = *BLANKS                                         CSC011
     C                   EVAL      MsgDtaArr = *BLANKS                                        CSC011
     C                   ENDIF                                                                CSC011
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF                                                                CER001
     C                   ELSE
     C                   MOVEL     'I'           @SCRN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE                                                                 CSW024
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                             AND LIBR = S1SUPP                                          CSC011
     C                   EVAL      @SCRN = 'V'                                                CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVEL     'I'           @SCRN                                        CSW024
     C                   ENDIF                                                                CSC011
      *
      * End of Insert/Amend condition controlling validation call
     C                   ENDIF
      *
      *
     C     EndVAL@V      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@VV - VALIDATE INPUT TO Private Banking Details
      *          To prevent screen access to non-input fields in error
      *****************************************************************
     C     VAL@VV        BEGSR
      *
      * Validate Private Banking Details
      *
     C                   CALLB     'SDCUSD5VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      *
      ** Private Banking Customer Indicator
     C                   PARM                    DDPRBA
      *
      ** Customer Private Banking Details
     C                   PARM                    NewCuPriv
      *                                                                         CPB002
      ** Portfolio Management Customer Indicator                                CPB002
     C                   PARM                    PtfrCust          1            CPB002
      *                                                                         CPB002
      ** Account Officer                                                        CPB002
     C                   PARM                    DDACOC                         CPB002
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
     C                   PARM                    DDCUSN                                       CGL031
      *
      * OUTPUTS :
      ** Customer Base Rate Tax Details
     C                   PARM                    OKCuPriv
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Valid Private Banking layout (DS) from/to caller
     C                   PARM                    NwPBFilFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVCUS - RETRIEVE Customer
      *****************************************************************
     C     RTVCUS        BEGSR
      *
      * RETRIEVE Customer
      *
     C                   CALLB     'SDCUSDRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM      @ACSEL        DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    CUFRNT
      *
      * (Midas) Customer Reference
     C                   PARM                    DDCUSN
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      * Base Rate Tax option feature is switched on
     C                   PARM                    S01383
      *
      *  Private Banking Customer details is switched on                        154562
     C                   PARM                    BGN4ST            1            154562
      ** Global Data Layout feature is switched on                                            CGP001
     C                   PARM                    CGP001                                       CGP001
      ** KYC: Transaction Type                                                                CSD028
     C                   PARM      *BLANKS       PTransType                                   CSD028
      *
      * OUTPUTS :
      * (Current) Customer in file format
      ** (Current) Global Customer X-Reference in file format                                 CGP001
     C                   PARM                    CrCuFilFmt
     C                   PARM                    CrBrFilFmt
     C                   PARM                    CrPBFilFmt
     C                   PARM                    CrTIFilFmt                                  BUG3362
     C                   PARM                    GCrCuFilFmt                                  CGP001
     C                   PARM                    CrSwFilFmt                                   CSW207
     C                   PARM                    TranInCUAH                                   CER059
     C                   PARM                    TranInCCTX                                   CER059
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Customer Reference
     C                   PARM      *BLANK        DDCUSNOK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *                                                                                     BUG23518
      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIDArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      *                                                                                     BUG23518
      ** Array index (3P0) from/to caller                                                   BUG23518
      *                                                                                     BUG23518
     C                   PARM      *ZEROS        WIdx_PVAL                                  BUG23518
      *
     C     EndRTVCUS     ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      * RTVEXT1 - Retrieve customer extension group 1                                         CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     RTVEXT1       BEGSR                                                                CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C     K@KEY         CHAIN(N)  RTVIDXA                            85                      CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** If record exist                                                                      CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *OFF                                               CER001
      *                                                                                       CER001
     C                   MOVE      'Y'           WFIND1                                       CER001
      *                                                                                       CER001
     C*****VFCGRP        IFEQ      0                                                  CER001 CSD027A
     C                   IF        VFCGRP = *BLANKS                                          CSD027A
     C                   MOVE      *BLANKS       L6LXCGRP                                     CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      VFCGRP        L6LXCGRP                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      **   Use the SR/ZEDIT to format the Provisions Forfaitaires                             CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       ZFIELD           16                          CER001
     C                   MOVE      VFPAPS        ZFIELD                                       CER001
     C                   Z-ADD     2             ZADEC             1 0                        CER001
     C                   CALLB     'ZEDIT'                                                    CER001
     C                   PARM                    ZFIELD                                       CER001
     C                   PARM                    ZADEC                                        CER001
     C                   MOVE      ZFIELD        L6LXPAPS                                     CER001
      *                                                                                       CER001
     C                   MOVE      VFCONS        L6LXCONS                                     CER001
     C                   MOVE      VFECOS        L6LXECOS                                     CER001
     C                   MOVE      VFNCOS        L6LXNCOS                                     CER001
     C                   MOVE      VFINRF        L6LXINRF                                     CER001
     C                   MOVE      VFPERF        L6LXPERF                                     CER001
     C                   MOVE      VFSMRS        L6LXSMRS                                     CER001
      *                                                                                       CER001
     C     ULX012        IFEQ      'Y'                                                        CER001
     C                   MOVE      VFAUTG        L6LXAUTG                                     CER001
     C                   MOVE      VFPROG        L6LXPROG                                     CER001
     C                   MOVE      VFASSP        L6LXASSP                                     CER001
     C                   ENDIF                                                                CER001
     C     ULX008        IFEQ      'Y'                                                        CER001
     C                   MOVE      VFICCD        L6LXICCD                                     CER001
     C                   MOVE      VFMCID        L6LXMCID                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVFFOTR  =  DDFOTRANID                                  CER001
     C                   EVAL      #6LXVFCUST  =  VFCUST                                      CER001
     C                   EVAL      #6LXVFCONS  =  VFCONS                                      CER001
     C                   EVAL      #6LXVFECOS  =  VFECOS                                      CER001
     C                   EVAL      #6LXVFINRF  =  VFINRF                                      CER001
     C                   EVAL      #6LXVFCGRP  =  VFCGRP                                      CER001
     C                   EVAL      #6LXVFCRNM  =  VFCRNM                                      CER001
     C                   EVAL      #6LXVFCOLC  =  VFCOLC                                      CER001
     C                   EVAL      #6LXVFPAPS  =  VFPAPS                                      CER001
     C                   EVAL      #6LXVFPERF  =  VFPERF                                      CER001
     C                   EVAL      #6LXVFNCOS  =  VFNCOS                                      CER001
     C                   EVAL      #6LXVFAUTG  =  VFAUTG                                      CER001
     C                   EVAL      #6LXVFPROG  =  VFPROG                                      CER001
     C                   EVAL      #6LXVFASSP  =  VFASSP                                      CER001
     C                   EVAL      #6LXVFICCD  =  VFICCD                                      CER001
     C                   EVAL      #6LXVFMCID  =  VFMCID                                      CER001
     C                   EVAL      #6LXVFSMRS  =  VFSMRS                                      CER001
     C                   EVAL      #6LXVFTMES  =  DDTMESTMP                                   CER001
      *                                                                                       CER001
      ** If record does not exist                                                             CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *ON                                                CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WFIND1                                       CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       L6LXPAPS                                     CER001
     C                   MOVE      *BLANKS       L6LXCGRP                                     CER001
     C                   MOVE      '0'           L6LXCONS                                     CER001
      *                                                                                       CER001
     C     #1LINC        CHAIN     SDINX1L0                           99                      CER001
     C     *IN99         IFEQ      *ON                                                        CER001
     C                   MOVE      '4000'        L6LXECOS                                     CER001
     C                   MOVE      '9000'        L6LXNCOS                                     CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C     #1COLC        WHENEQ    'LU'                                                       CER001
     C                   MOVE      AOECOL        L6LXECOS                                     CER001
     C     #1COLC        WHENEQ    'BE'                                                       CER001
     C                   MOVE      AOECOB        L6LXECOS                                     CER001
     C                   OTHER                                                                CER001
     C                   MOVE      AOECOO        L6LXECOS                                     CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C     #1COLC        CHAIN     SDCTX2L0                           99                      CER001
     C     *IN99         IFEQ      *ON                                                        CER001
     C                   MOVEL     'SDCTX2L0'    DBFILE                                       CER001
     C                   MOVEL     '003'         DBASE                                        CER001
     C                   MOVEL     *BLANKS       DBKEY                                        CER001
     C                   MOVEL     #1COLC        DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C     #1COLC        WHENEQ    'LU'                                                       CER001
     C                   MOVE      AONCOL        L6LXNCOS                                     CER001
     C     #1COLC        WHENNE    'LU'                                                       CER001
     C     WFEMUM        ANDEQ     'Y'                                                        CER001
     C                   MOVE      AONCOE        L6LXNCOS                                     CER001
     C                   OTHER                                                                CER001
     C                   MOVE      AONCOO        L6LXNCOS                                     CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      '0'           L6LXINRF                                     CER001
     C                   MOVE      *BLANKS       L6LXPERF                                     CER001
     C                   MOVE      *BLANKS       L6LXSMRS                                     CER001
      *                                                                                       CER001
     C     ULX012        IFEQ      'Y'                                                        CER001
     C                   MOVE      *BLANKS       L6LXAUTG                                     CER001
     C                   MOVE      *BLANKS       L6LXPROG                                     CER001
     C                   MOVE      *BLANKS       L6LXASSP                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX008        IFEQ      'Y'                                                        CER001
     C                   MOVE      *BLANKS       L6LXICCD                                     CER001
     C     ULX048        IFEQ      'N'                                                        CER001
     C                   MOVE      'N'           L6LXMCID                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
      ** Now overwrite the fields on the main details screen with those                       CER001
      ** on the invalid extended deals file                                                   CER001
      *                                                                                       CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                            85                      CER001
      *                                                                                       CER001
      ** Move values from invalid file to file format                                         CER001
      *                                                                                       CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   EVAL      L6LXCONS = #6LXCONS                                        CER001
     C                   EVAL      L6LXECOS = #6LXECOS                                        CER001
     C                   EVAL      L6LXINRF = #6LXINRF                                        CER001
     C                   EVAL      L6LXCGRP = #6LXCGRP                                        CER001
     C                   EVAL      L6LXPAPS = #6LXPAPS                                        CER001
     C                   EVAL      L6LXPERF = #6LXPERF                                        CER001
     C                   EVAL      L6LXNCOS = #6LXNCOS                                        CER001
     C                   EVAL      L6LXAUTG = #6LXAUTG                                        CER001
     C                   EVAL      L6LXPROG = #6LXPROG                                        CER001
     C                   EVAL      L6LXASSP = #6LXASSP                                        CER001
     C                   EVAL      L6LXICCD = #6LXICCD                                        CER001
     C                   EVAL      L6LXMCID = #6LXMCID                                        CER001
     C                   EVAL      L6LXSMRS = #6LXSMRS                                        CER001
     C                   ENDIF                                                                CER001
     C                   EVAL      #1DEXT   = 'Y'                                             CER001
     C                   EVAL      #2DEXT   = 'Y'                                             CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      * RTVEXT2 - Retrieve customer extension group 2                                         CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     RTVEXT2       BEGSR                                                                CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C     K@KEY         CHAIN(N)  RTVIDXB                            85                      CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** If record exist                                                                      CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *OFF                                               CER001
      *                                                                                       CER001
     C                   MOVE      'Y'           WFIND2                                       CER001
      *                                                                                       CER001
     C                   MOVE      CUTYPE        #LLXTYPE                                     CER001
     C                   MOVE      CUIDCO        #LLXIDCO                                     CER001
     C                   MOVE      CUIDEN        #LLXIDEN                                     CER001
     C                   MOVE      CUIMCO        #LLXIMCO                                     CER001
     C                   MOVE      CUIMNB        #LLXIMNB                                     CER001
      *                                                                                       CER001
     C                   EVAL      #LLXCUFOTR = DDFOTRANID                                    CER001
     C                   EVAL      #LLXCUCNUM = CUCNUM                                        CER001
     C                   EVAL      #LLXCUTYPE = CUTYPE                                        CER001
     C                   EVAL      #LLXCUIDCO = CUIDCO                                        CER001
     C                   EVAL      #LLXCUIDEN = CUIDEN                                        CER001
     C                   EVAL      #LLXCUIMCO = CUIMCO                                        CER001
     C                   EVAL      #LLXCUIMNB = CUIMNB                                        CER001
     C                   EVAL      #LLXCUTMES = DDTMESTMP                                     CER001
      *                                                                                       CER001
      ** If record does not exist                                                             CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *ON                                                CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WFIND2                                       CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       LLLXTYPE                                     CER001
     C                   MOVE      *BLANKS       LLLXIDCO                                     CER001
     C                   MOVE      *BLANKS       LLLXIDEN                                     CER001
     C                   MOVE      *BLANKS       LLLXIMCO                                     CER001
     C                   MOVE      *BLANKS       LLLXIMNB                                     CER001
      *                                                                                       CER001
     C                   CALLB     'SDVCUTYPE2'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    MSG1                                         CER001
     C                   PARM                    LLLXTYPE                                     CER001
     C                   PARM                    DDCOLC                                       CER001
     C                   PARM                    DDCUSN                                       CER001
     C                   PARM                    DDBNBI                                       CER001
     C                   PARM                    DDBRCD                                       CER001
     C                   PARM                    BRBKCO                                       CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
      ** Now overwrite the fields on the main details screen with those                       CER001
      ** on the invalid extended customer file                                                CER001
      *                                                                                       CER001
     C     ZATRNKX0      CHAIN     RTVIDX2                            85                      CER001
      *                                                                                       CER001
      ** Move values from invalid file to file format                                         CER001
      *                                                                                       CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   EVAL      LLLXTYPE = #LLXTYPE                                        CER001
     C                   EVAL      LLLXIDCO = #LLXIDCO                                        CER001
     C                   EVAL      LLLXIDEN = #LLXIDEN                                        CER001
     C                   EVAL      LLLXIMCO = #LLXIMCO                                        CER001
     C                   EVAL      LLLXIMNB = #LLXIMNB                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************         CPB002
      * CHKPTFR - Check if Portfolio Management Customer.                       CPB002
      *****************************************************************         CPB002
     C     CHKPTFR       BEGSR                                                  CPB002
      *                                                                         CPB002
      ** Initialize Portfolio Management customer indicator.                    CPB002
     C                   MOVE      'N'           PtfrCust                       CPB002
      *                                                                         CPB002
      * Retrieve Portfolio Management customer details.                         CPB002
      *                                                                         CPB002
     C                   CALL      'AOPLCSR0'                                   CPB002
     C                   PARM      *BLANKS       @RTCD                          CPB002
     C                   PARM      '*VERIFY'     @OPTN                          CPB002
     C                   PARM      DDCUSN        P@CUST           10            CPB002
     C     SDPLCS        PARM      SDPLCS        DSFDY                          222373
      *                                                                         CPB002
      ** If Portfolio Management customer details exist, set up                 CPB002
      ** Portfolio Management Customer Indicator.                               CPB002
      *                                                                         CPB002
     C     @RTCD         IFEQ      *BLANKS                                      CPB002
     C                   MOVE      'Y'           PtfrCust                       CPB002
      *                                                                         CPB002
     C                   END                                                    CPB002
                                                                                CPB002
     C                   ENDSR                                                  CPB002
      *****************************************************************         CPB002
      /EJECT                                                                    CPB002
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTCUS - PUT A Customer ON THE SECONDARY SCREEN
      *****************************************************************
     C     CVTCUS        BEGSR
      *
      * Call program to fill screen fields with data from TRADSD
      *
     C                   CALLB     'SDCUSDCVT'
      *
      * INPUTS :
      * Return Code
      * Customer in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrCuFilFmt
     C                   PARM                    CrBrFilFmt
     C                   PARM                    CrPbFilFmt
                                                                                              CGP001
      ** Global Customer X-Reference                                                          CGP001
     C                   PARM                    GCrCuFilFmt                                  CGP001
     C                   PARM                    CrSwFilFmt                                   CSW207
                                                                                              CGP001
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      * OUTPUTS
      * Customer - screen formats
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuMT3X                                    CSW024
     C                   PARM                    NewCuMsg
     C                   PARM                    NewCuBrt
     C                   PARM                    NewCuPriv
     C                   PARM                    NewCuSwft                                    CSW207
 
      *
      * Update 'Current' Customer with Customer in Screen Format
      *
     C                   MOVEL     NewCuPrim     CurCuPrim
     C                   MOVEL     NewCuBrt      CurCuBrt
     C                   MOVEL     NewCuSeco     CurCuSeco
     C                   MOVEL     NewCuMT3X     CurCuMT3X                                    CSW024
     C                   MOVEL     NewCuMsg      CurCuMsg
     C                   MOVEL     NewCuPriv     CurCuPriv
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVEL     NewCuSwft     CurCuSwft                                    CSW027
     C                   ENDIF                                                                CSW207
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SECONDARY SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to BRT tax screen
     C     S01383        IFEQ      'Y'
     C     DDTAIN        ANDEQ     'I'
     C     S01383        OREQ      'Y'
     C     DDTAIN        ANDEQ     'J'
     C     S01383        OREQ      'Y'                                                        CRE007
     C     DDTAIN        ANDEQ     'R'                                                        CRE007
     C                   MOVE      'X'           @SCRN
     C                   ELSE
      * Or return to Primary Details screen
     C                   MOVE      'P'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW024
      * CANC@F - CANCEL ON MESSAGE DETAILS SCREEN                                             CSW024
      *****************************************************************                       CSW024
     C     CANC@F        BEGSR                                                                CSW024
      *                                                                                       CSW024
      * Return to Secondary Screen                                                            CSW024
     C                   MOVEL     'S'           @SCRN                                        CSW024
      *                                                                                       CSW024
     C                   ENDSR                                                                CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************
      * CANC@M - CANCEL ON MESSAGE DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      ** If MT3xx BEI enhancement has been installed and                                      CSW024
      ** SWIFT/Direct Link module is on then display                                          CSW024
      ** screen for MT3xx BEI details.                                                        CSW024
      ** Else,  Return to Secondary Screen                                                    CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
     C                   MOVEL     'F'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
      * Return to Secondary Screen
     C                   MOVEL     'S'           @SCRN
     C                   ENDIF                                                                CSW024
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@V - CANCEL ON Private Banking Scren
      *****************************************************************
     C     CANC@V        BEGSR
      *
      * Return to Messages Screen
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@B - CANCEL ON BASE RATE TAX SCREENS
      *****************************************************************
     C     CANC@B        BEGSR
      *
      * If on BRT screen 2, F12 returns to BRT screen 1
      * otherwise F12 returns to customer Primary Details screen
      *
     C     BRTSCREEN     IFEQ      '2'
     C                   MOVEL     '1'           BRTSCREEN
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
      * Reset errors
      *
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FURDET - Further Details
      *****************************************************************
     C     FURDET        BEGSR
                                                                                              CSC011
      ** Further Details (F23) not available in Support System                                CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                             AND LIBR = S1SUPP                                          CSC011
     C                   IF        DDACTN <> 'I'                                              CSC011
     C                   EVAL      Idx = 1                                                    CSC011
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CSC011
     C                   EVAL      MsgIdArr(Idx) = 'USR9370'                                  CSC011
     C                   ENDIF                                                                CSC011
     C                   ELSE                                                                 CSC011
      *
      ** Call further details screen
      **
     C                   MOVE      DDCUSN        FDCUST
     C                   MOVE      DDCSSN        FDCSSN
     C                   MOVE      DDCRTN        FDCRTN
     C                   MOVE      DDCRNM        FDCRNM
     C                   MOVE      DDLINC        FDLINC
     C                   MOVE      C_BBTICS      FDTICS
     C                   MOVE      DDCRPC        FDCRPC                                      BUG4454
     C                   MOVE      DDBRCD        FDBRCD                                      BUG4454
     C                   MOVE      DDLICD        FDLICD                                      BUG4454
     C/COPY WNCPYSRC,SDCUSDRC01
      *                                                                                       CER001
     C                   If        PB3610 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVEL     DDFOTRANID    WWFRNT           20                          CER001
     C     WWFRNT        CHAIN     SDICEXL1                           89                      CER001
      *                                                                                       CER001
     C                   If        *IN89 = False                                              CER001
     C                   EVAL      FDFRNT = PBFRNT                                            CER001
     C                   EVAL      FDSEDT = PBSEDT                                            CER001
     C                   EVAL      FDPLDT = PBPLDT                                            CER001
     C                   EVAL      FDFFDT = PBFFDT                                            CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      **********                                                                  BUG26917 BUG26917A
     C*****CER048        IFEQ      'Y'                                            BUG26917 BUG26917A
     C*****DDTAIN        IFEQ      'Y'                                            BUG26917 BUG26917A
     C**********         EVAL      FDTAIN = DDTAIN                                BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C**********         EVAL      FDTAIN = *BLANKS                               BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      *
     C                   CALL      'SD0014V'                              90
     C                   PARM                    RTNCDE            7
     C                   PARM                    FURDETS
     C**********         PARM                    @OPSEL                         175680
     C                   PARM                    DDACTN                         178680
     C                   PARM                    DDPAIN
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * After F8, if Insert mode, return to customer prompt screen
      * otherwise go to details screens
      *
     C     @OPSEL        IFEQ      'I'
     C                   MOVE      'I'           @SCRN
     C                   MOVE      *BLANK        DDCUSN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *****                                                                     185595
      **If*action code 'I', maintain Further Details                            185595
      *****                                                                     185595
     C*****DDACTN        IFEQ      'I'                                          185595
     C*****              EXSR      FURDET                                       185595
     C*****              END                                                    185595
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   GOTO      UPDTAG                                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                      BUG3362
      ** If action code 'I', maintain Further Details                                        BUG3362
      *                                                                                      BUG3362
     C     Idx           IFEQ      *ZEROS                                                    BUG3362
     C     DDACTN        IFEQ      'I'                                                       BUG3362
     C                   EXSR      FURDET                                                    BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
      *
      * Update valid customer: customer reference
      *
     C                   MOVEL     DDCUSN        CUCUST
     C                   MOVEL     DDACTN        CUTYLC
     C                   EVAL      CUFRNT =  DDFOTRANID                                       CER001
     C                   EVAL      CUAFRT =  DDFOASOCID                                       CER001
     C                   EVAL      CUREPA =  DDRPRLOCN                                        CER001
      *
      ** Carry forward file data to valid file
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVE      C_BBTXA2      CUTXA2
     C                   MOVE      C_BBTXA3      CUTXA3
     C                   MOVE      C_BBTXA4      CUTXA4
     C                   MOVE      C_BBTXA5      CUTXA5
     C                   MOVE      C_BBLETI      CULETI
     C                   MOVE      C_BBCMTI      CUCMTI
     C                   MOVE      C_BBOGID      CUOGID
     C                   Z-ADD     C_BBORED      CUORED
     C                   MOVE      C_BBNET       CUNET
     C                   MOVE      C_BBNTGP      CUNTGP
     C                   MOVE      C_BBNTCP      CUNTCP
     C                   Z-ADD     C_BBNTND      CUNTND
     C                   MOVE      C_BBNTMM      CUNTMM
     C                   MOVE      C_BBTMST      CUTMST
     C                   MOVE      C_BBFRNT      CUFRNT                                      BUG7314
      *                                                                                      BUG3362
      ** If FDTICS is blanks, this means F23 was not pressed, therefore,                     BUG3362
      ** field must retain its current value else, get the updated value                     BUG3362
      *                                                                                      BUG3362
     C     FDTICS        IFEQ      *BLANKS                                                   BUG3362
     C                   MOVE      C_BBTICS      CUTICS                                      BUG3362
     C                   ELSE                                                                BUG3362
     C                   MOVE      FDTICS        CUTICS                                      BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ELSE
      *
      ** Initialise non-validated valid file fields for Insert
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *BLANKS       CUTXA2
     C                   MOVE      *BLANKS       CUTXA3
     C                   MOVE      *BLANKS       CUTXA4
     C                   MOVE      *BLANKS       CUTXA5
     C                   MOVE      *BLANKS       CULETI
     C                   MOVE      *BLANKS       CUCMTI
     C                   MOVE      *BLANKS       CUOGID
     C                   Z-ADD     BJRDNB        CUORED
     C                   MOVE      'N'           CUNET
     C                   MOVE      *BLANKS       CUNTGP
     C                   MOVE      'N'           CUNTCP
     C                   MOVE      'N'           CUNTMM
     C                   MOVE      DDFOTRANID    CUFRNT                                      BUG7314
      *                                                                                      BUG3362
     C     CUTICS        IFEQ      *BLANK                                                    BUG3362
     C                   MOVE      'N'           CUTICS                                      BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3362
      ** If Further details was accessed, load changed value(FDCTID from                     BUG3362
      ** SD0014V) to NwTIFilfmt if no error                                                  BUG3362
      *                                                                                      BUG3362
     C     FDTICS        IFEQ      'Y'                                                       BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     FDCTID        NwTIfilFmt                                  BUG3362
     C                   EVAL      V_TCLCD = BJRDNB                                          BUG3362
      *                                                                                      BUG3362
     C     DDACTN        IFEQ      'I'                                                       BUG3362
     C                   EVAL      V_TCCSSN=CUCSSN                                           BUG3362
     C                   ENDIF                                                               BUG3362
     C                   EVAL      CUTICS = FDTICS                                           BUG3362
     C                   ELSE                                                                BUG3362
     C     FDTICS        IFEQ      'N'                                                       BUG3362
     C     DDACTN        ANDEQ     'I'                                                       BUG3362
     C     FDTICS        OREQ      ' '                                                       BUG3362
     C     DDACTN        ANDEQ     'I'                                                       BUG3362
      ** case FDTICS = 'N'                                                                   BUG3362
     C                   MOVE      *BLANKS       NwTifilFmt                                  BUG3362
     C                   EVAL      V_TCLCD = 0                                               BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     *BLANK        @RTCD
      *
      * CUSTOMERS UPDATES
      *
     C                   CALLB     'SDCUSDUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwCuFilFmt
     C                   PARM                    NwBrFilFmt
     C                   PARM                    NwPBFilFmt
     C                   PARM                    NwTIFilFmt                                  BUG3362
     C                   PARM                    NwSwFilFmt                                   CSW207
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
     C                   PARM                    V_DDGCUS                                     CGP001
     C                   PARM                    S01383
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CSW024                                       CSW024
     C                   PARM                    CGP001                                       CGP001
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
     C                   PARM                    PTransType                                   CSD028
     C                   PARM                    DACTN             1                          CSD028
     C                   PARM                    CTI006            1                        MD030956
      *
      ** Update extension fields group 1                                                      CER001
      *                                                                                       CER001
     C                   IF        @RTCD  = *BLANKS AND                                       CER001
     C                             ULX609 = 'Y' AND DDACTN <> 'A'                             CER001
     C                   EVAL      #6LXVFCOLC = #1COLC                                        CER001
     C                   EVAL      #6LXVFCRNM = #1CRNM                                        CER001
     C                   CALLB     'SDCUSD2UP'                                                CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    WFIND1                                       CER001
     C                   PARM                    NwDlFilFmt1                                  CER001
     C                   PARM                    CrDlFilFmt1                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Update extension fields group 2                                                      CER001
      *                                                                                       CER001
     C                   IF        @RTCD  = *BLANKS AND                                       CER001
     C                             ULX043 = 'Y' AND DDACTN <> 'A'                             CER001
      *                                                                                       CER001
     C                   CALLB     'SDCUSD3UP'                                                CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    WFIND2                                       CER001
     C                   PARM                    NwDlFilFmt2                                  CER001
     C                   PARM                    CrDlFilFmt2                                  CER001
     C                   ENDIF                                                                CER001
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID Customer ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    6
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CER001
     C                   IF        ULX609 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                            99                      CER001
     C  N99              DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     RTVIDX2                            99                      CER001
     C  N99              DELETE    RTVIDX2                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *                                                                                       208558
      * If action code 'I', maintain Further Details                                          208558
      *                                                                                       208558
     C     DDACTN        IFEQ      'I'                                                        208558
      *                                                                                       208558
      * COMMIT here to avoid the lost of records if F12 is used in SD0014V                    208558
      *                                                                                       208558
     C                   COMMIT                                                               208558
      *                                                                                       208558
     C                   EXSR      FURDET                                                     208558
     C                   END                                                                  208558
      *                                                                                       208558
     C     ZATRNKD0      CHAIN     SDICUSDD0                          99
     C  N99              DELETE    SDICUSDD0
     C     ZATRNKD0      CHAIN     SDICUBRD0                          99
     C  N99              DELETE    SDICUBRD0
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                              CSW207A
     C     ZATRNKD0      CHAIN     SDISWFDD0                          99                     CSW207A
     C  N99              DELETE    SDISWFDD0                                                 CSW207A
     C                   ENDIF                                                               CSW207A
     C     ZATRNKD0      CHAIN     SDICUPBD0                          99
     C  N99              DELETE    SDICUPBD0
     C/COPY WNCPYSRC,SDCUSDRC02
     C                   If        PB3610 = 'Y'                                               CER001
     C                   MOVEL     DDFOTRANID    WWFRNT           20                          CER001
     C     WWFRNT        CHAIN     SDICEXL1                           99                      CER001
     C  N99              DELETE    SDICEXD0                                                   CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SDCUSD'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   COMMIT
      *********************************************************************           185595 BUG3362
      **If*action*code*'I',*maintain*Further*Details***********************           185595 BUG3362
      *********************************************************************           185595 BUG3362
     C*****DDACTN********IFEQ******'I'*************************************           185595 BUG3362
     C*******************EXSR******FURDET**********************************           185595 BUG3362
     C*******************END***********************************************           185595 BUG3362
      *********************************************************************           185595 BUG3362
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
     C     UPDTAG        TAG                                                                  CER001
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS CUSTOMER
      * KH = COMMAND KEY 08 = READ NEXT CUSTOMER
      *
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH            1
      *
      * KX = COMMAND KEY 23 = FURTHER DETAILS
      *
     C     DDACTN        IFNE      'I'
     C                   MOVEL     'Y'           @EINKX
     C                   ELSE
     C                   MOVEL     'N'           @EINKX
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PARNAMES - Flag if there are changed participant names
      *****************************************************************
     C     PARNAMES      BEGSR
      *
      * If any 'P', the user to be prompted to confirm if new party or not
     C     'P'           LOOKUP    ChgNamArr                              99
     C                   MOVE      *IN99         CHGNAME           1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@T - Validate Name Prompt and Process Participant History DS
      *****************************************************************
     C     VAL@T         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_TVAL
     C                   MOVE      *ALL'Y'       OKCuBRT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      ** Call to validate name prompt and process Participant History
      *
     C                   CALLB     'SDCUSD7VL'
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode
      *
      * Action Code
      * Customer Number
      * Account Holder Type
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
     C                   PARM                    DDTAIN
 
      ** Customer Base Rate Tax
     C                   PARM                    NewCuBrt
 
      ** OUTPUTS
 
      ** Customer Base Rate Tax OK indicators
     C                   PARM                    OKCuBrt
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_TVAL
 
      * Changed Party Name Array
     C                   PARM                    ChgNamArr
      *
      * Valid BRT file layout (DS) to/from caller
     C                   PARM                    NwBrFilFmt
      *
      * If there are errors, redisplay Base Rate Tax screen
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@T
     C                   ENDIF
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     BRTSCREEN     IFEQ      '2'
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   MOVE      '0'           CHGNAME
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@T
     C                   ENDIF
      *
     C     ChgNamArr(3)  IFEQ      'P'
     C     ChgNamArr(4)  OREQ      'P'
     C     ChgNamArr(5)  OREQ      'P'
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   MOVE      '0'           CHGNAME
     C                   MOVE      'S'           @SCRN
     C                   ENDIF
 
     C     EndVAL@T      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       189774
      ** Rollback to clear any possible updates in window function                            189774
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   ROLBK                                                                189774
     C                   ENDIF                                                                189774
      *
     C                   MOVEL     'T'           @SCRN
      *
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
      ** Substitute the data for the various parts of the transaction,          CAP011
      ** dependent on the flags that were set earlier.                          CAP011
                                                                                CAP011
     C                   if        RepPrim = 'Y'                                CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuPrim     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuPrim     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuPrim                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepSeco = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuSeco     IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuSeco     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuSeco                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepMT3X = 'Y'                                              CSW024
                                                                                              CSW024
     C                   clear                   IncData                                      CSW024
     C                   clear                   CurData                                      CSW024
     C                   RESET                   ReturnCode                                   CSW024
     C                   CALLB     'APDTASUBS'                                                CSW024
      * Return Code                                                                           CSW024
     C                   PARM                    ReturnCode                                   CSW024
      * Substitution character                                                                CSW024
     C                   PARM                    GHSUBS                                       CSW024
      * Incoming Data                                                                         CSW024
     C                   PARM      NewCuMT3X     IncData                                      CSW024
      * Current Data                                                                          CSW024
     C                   PARM      CurCuMT3X     CurData                                      CSW024
                                                                                              CSW024
     C                   MOVEL     IncDATA       NewCuMT3X                                    CSW024
                                                                                              CSW024
     C                   endif                                                                CSW024
                                                                                              CSW024
     C                   if        RepMsrt = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuMsg      IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuMsg      CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuMsg                       CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepBrTx = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuBrt      IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuBrT      CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuBrt                       CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepPriv = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuPriv     IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuPriv     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuPriv                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                             CSW207A
     C                   if        RepSwft = 'Y'                                             CSW207A
                                                                                             CSW207A
     C                   clear                   IncData                                     CSW207A
     C                   clear                   CurData                                     CSW207A
     C                   RESET                   ReturnCode                                  CSW207A
     C                   CALLB     'APDTASUBS'                                               CSW207A
      * Return Code                                                                          CSW207A
     C                   PARM                    ReturnCode                                  CSW207A
      * Substitution character                                                               CSW207A
     C                   PARM                    GHSUBS                                      CSW207A
      * Incoming Data                                                                        CSW207A
     C                   PARM      NewCuSwft     IncData                                     CSW207A
      * Current Data                                                                         CSW207A
     C                   PARM      CurCuSwft     CurData                                     CSW207A
                                                                                             CSW207A
     C                   MOVEL     IncDATA       NewCuSwft                                   CSW207A
                                                                                             CSW207A
     C                   endif                                                               CSW207A
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * GO TO PRIMARY SCREEN
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL2                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDRPR'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
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
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if S01383
      ** (Base Rate Tax) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     'S01383'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *
      ** Access SAR details file to determine if CAP050
      ** (Midas/ToF Interface) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '909'         DBASE
     C                   MOVEL     'CAP050'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   END
      *
      ** Access SAR details file to determine if CEU005
      ** (EMU SE Settlement Currency Conversion) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '910'         DBASE
     C                   MOVEL     'CEU005'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   END
      *                                                                                       CSW024
      ** Access SAR details file to determine if CSW024                                       CSW024
      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.                                        CSW024
      *                                                                                       CSW024
     C                   CALLB     'AOSARDR0'                                                 CSW024
     C                   PARM      *BLANKS       @RTCD                                        CSW024
     C                   PARM      '*VERIFY'     @OPTN                                        CSW024
     C                   PARM      'CSW024'      @SARD                                        CSW024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW024
      *                                                                                       CSW024
      * DATABASE ERROR                                                                        CSW024
      *                                                                                       CSW024
     C     @RTCD         IFNE      *BLANKS                                                    CSW024
     C     @RTCD         ANDNE     '*NRF   '                                                  CSW024
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW024
     C                   MOVEL     '911'         DBASE                                        CSW024
     C                   MOVEL     'CSW024'      DBKEY                                        CSW024
     C                   EXSR      *PSSR                                                      CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C     @RTCD         IFEQ      *BLANK                                                     CSW024
     C                   MOVEL     'Y'           CSW024            1                          CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'N'           CSW024                                       CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CSC011
      ** Check if switchable feature CSC011 is switched on.                                   CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 911                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSD012
      ** Access SAR details file to determine if CSD012                                       CSD012
      ** (Standing Data Authorisation) is on.                                                 CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @Sard                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If CSD012 is ON, Check if Customer Details Authorisation is ON                       CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     913           DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'SDCUSDRPR'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Customer Details Authorisation is On set to Authorise                             CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
                                                                                              CGP001
      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
                                                                                              CGP001
     C                   EVAL      CGP001 = 'N'                                               CGP001
                                                                                              CGP001
     C                   CALLB     'AOSARDR0'                                                 CGP001
     C                   PARM      *BLANKS       PRtCd                                        CGP001
     C                   PARM      '*VERIFY'     POptn                                        CGP001
     C                   PARM      'CGP001'      PSard                                        CGP001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        PRtCd = *BLANKS                                            CGP001
     C                   EVAL      CGP001 = 'Y'                                               CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
      ** Database error                                                                       CGP001
                                                                                              CGP001
     C                   IF        PRtCd <> *BLANKS and                                       CGP001
     C                             PRtCd <> '*NRF   '                                         CGP001
     C     *LOCK         IN        LDA                                                        CGP001
     C                   EVAL      DBKEY = 'CGP001'                                           CGP001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGP001
     C                   EVAL      DBASE = 913                                                CGP001
     C                   OUT       LDA                                                        CGP001
     C                   EXSR      *PSSR                                                      CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY  = 'CLE025'                                          CLE025
     C                   EVAL      DBASE  = 902                                               CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CFX001
      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
                                                                                              CFX001
     C                   CALLB     'AOSARDR0'                                                 CFX001
     C                   PARM      *BLANKS       PRTCD                                        CFX001
     C                   PARM      '*VERIFY'     POPTN                                        CFX001
     C                   PARM      'CFX001'      PSARD                                        CFX001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFX001
                                                                                              CFX001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFX001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFX001
     C                   EVAL      DBKEY  = 'CFX001'                                          CFX001
     C                   EVAL      DBASE  = 906                                               CFX001
     C                   EXSR      *PSSR                                                      CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C                   IF        PRTCD = *BLANKS                                            CFX001
     C                   EVAL      CFX001 = 'Y'                                               CFX001
     C                   ELSE                                                                 CFX001
     C                   EVAL      CFX001 = 'N'                                               CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CER001
      ** Check if enhancement ULX043 is on                                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX043'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 915                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when IBLC Returns indicator is                  CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGNWST <> 'Y'                                             CER001
     C                   EVAL       ULX043 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX043 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   OPEN      SDCUX1L0                                                   CER001
     C                   OPEN      SDICULX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if enhancement ULX609 is on                                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX609'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
     C                   EVAL      DBASE  = 916                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX609 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX609 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX609 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX609 = 'Y'                                               CER001
     C                   OPEN      SDCUX2L0                                                   CER001
     C                   OPEN      SDICULX2L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if enhancement ULX008 is on                                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX008'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX008'                                          CER001
     C                   EVAL      DBASE  = 917                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX008 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if enhancement ULX012 is on                                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX012'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX012'                                          CER001
     C                   EVAL      DBASE  = 918                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX012 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX012 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if enhancement ULX048 is on                                                    CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX048'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX048'                                          CER001
     C                   EVAL      DBASE  = 919                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX048 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX048 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                     BUG13228
      ** Check if ULX004 in ON                                                              BUG13228
      *                                                                                     BUG13228
     C                   CALLB     'AOSARDR0'                                               BUG13228
     C                   PARM      *BLANKS       PRTCD                                      BUG13228
     C                   PARM      '*VERIFY'     POPTN                                      BUG13228
     C                   PARM      'ULX004'      PSARD                                      BUG13228
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG13228
                                                                                            BUG13228
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                BUG13228
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG13228
     C                   EVAL      DBKEY  = 'ULX004'                                        BUG13228
     C                   EVAL      DBASE  = 920                                             BUG13228
     C                   EXSR      *PSSR                                                    BUG13228
     C                   ENDIF                                                              BUG13228
      *                                                                                     BUG13228
     C                   IF        PRTCD = *BLANKS                                          BUG13228
     C                   EVAL      ULX004 = 'Y'                                             BUG13228
     C                   ELSE                                                               BUG13228
     C                   EVAL      ULX004 = 'N'                                             BUG13228
     C                   ENDIF                                                              BUG13228
      *                                                                         CAP011
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
     C                   MOVEL     '903'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd   = 'CSW2007'                                        CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                                       CER001
      ** Setup key values using transaction data passed from caller                           CER001
      *                                                                                       CER001
      *                                                                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    K@CUST                                       CER001
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    FieldP
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetP = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the SWIFT ID field; the secondary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatS
     C                   PARM                    FieldS
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetS = FieldNo - 1
     C                   ENDIF
      *                                                                                       CSW024
      ** Get the field number for the corporate BEI field; the MT3xx BEI                      CSW024
      ** screen fields start from that number.  Subtract one from it to                       CSW024
      ** give the value to subtract from each field's number.                                 CSW024
     C                   CALLB     'ZACGTFLDNO'                                               CSW024
     C                   PARM                    ReturnCode                                   CSW024
     C                   PARM                    FormatF                                      CSW024
     C                   PARM                    FieldF                                       CSW024
     C                   PARM                    FieldNo                                      CSW024
                                                                                              CSW024
     C                   IF        ReturnCode = *blank                                        CSW024
     C                   EVAL      FldOffsetF = FieldNo -1                                    CSW024
     C                   ENDIF                                                                CSW024
      *
      ** Get the field number for the message type 01 field; the message
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatM
     C                   PARM                    FieldM
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetM = FieldNo - 1
     C                   ENDIF
      *
      ** Get the field number for the party 1 title field; the Base Rate Tax
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatB
     C                   PARM                    FieldB
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetB = FieldNo - 1
     C                   ENDIF
      *
      ** Get the field number for the private banking customer field. The
      ** private banking screen fields start from that number. Subtract 1
      ** to give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatV
     C                   PARM                    FieldV
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetV = FieldNo - 1
     C                   ENDIF
      *
 
      ** Get the field number for the margin type field; the primary
      ** screen fields end at that number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatP
     C                   PARM                    FieldPL
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffstPL = FieldNo
     C                   ENDIF
 
      ** Get the field number for the stop statement download field.
      ** The secondary screen fields end at that number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatS
     C                   PARM                    FieldSL
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffstSL = FieldNo
     C                   ENDIF
                                                                                              CSW024
      ** Get the field number for the fund identification field.                              CSW024
      ** The MT3xx screen fields end at that number.                                          CSW024
                                                                                              CSW024
     C                   CALLB     'ZACGTFLDNO'                                               CSW024
     C                   PARM                    ReturnCode                                   CSW024
     C                   PARM                    FormatF                                      CSW024
     C                   PARM                    FieldFL                                      CSW024
     C                   PARM                    FieldNo                                      CSW024
                                                                                              CSW024
     C                   IF        ReturnCode = *blank                                        CSW024
     C                   EVAL      FldOffstFL = FieldNo                                       CSW024
     C                   ENDIF                                                                CSW024
      *
      ** Get the field number for the default network 9 field. The message
      ** screen fields end at that number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatM
     C                   PARM                    FieldML
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffstML = FieldNo
     C                   ENDIF
      *
      ** Get the field number for the party 1 title field in the all fields
      ** (SDCUSDPD) screen format. The base rate tax fields start from that
      ** number. Subtract 1 to get the value to subtract from each field
      ** number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatC
     C                   PARM                    FieldBF
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffstBF = FieldNo - 1
     C                   ENDIF
      *                                                                                       CER001
      ** Get the field number for the LUX screen field. The                                   CER001
      ** participation percentrage fields start from that number.                             CER001
      ** Substract 1 to give the value to subtract from each field's number.                  CER001
      *                                                                                       CER001
     C                   CALLB     'ZACGTFLDNO'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    FormatV                                      CER001
     C                   PARM                    FieldExt                                     CER001
     C                   PARM                    FieldNo                                      CER001
                                                                                              CER001
     C                   IF        ReturnCode = *blank                                        CER001
     C                   EVAL      FldOffsetExt = FieldNo - 1                                 CER001
     C                   ENDIF                                                                CER001
      *
      *
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'I'           @SCRN             1
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUSDR014
      *                                                                                       CER001
      ** Access SAR details file to check Customer Extended details Default                   CER001
      **  (PB3610) is switched on                                                             CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'PB3610'      @SARD             6                          CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'PB3610'                                          CER001
     C                   EVAL      DBASE  = 914                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           PB3610            1                          CER001
     C                   OPEN      SDICEXL1                                                   CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           PB3610                                       CER001
     C                   ENDIF                                                                CER001
      **********                                                                  BUG26917 BUG26917A
      ***Check*if*CER048*is*ON*                                                   BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         CALLB     'AOSARDR0'                                     BUG26917 BUG26917A
     C**********         PARM      *BLANKS       @RTCD                            BUG26917 BUG26917A
     C**********         PARM      '*VERIFY'     @OPTN                            BUG26917 BUG26917A
     C**********         PARM      'CER048'      @SARD                            BUG26917 BUG26917A
     C*****SCSARD        PARM      SCSARD        DSFDY                            BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '      BUG26917 BUG26917A
     C**********         EVAL      DBFILE = 'SCSARDPD'                            BUG26917 BUG26917A
     C**********         EVAL      DBKEY  = 'CER048'                              BUG26917 BUG26917A
     C**********         EVAL      DBASE  = 915                                   BUG26917 BUG26917A
     C**********         EXSR      *PSSR                                          BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        @RTCD = *BLANKS                                BUG26917 BUG26917A
     C**********         EVAL      CER048 = 'Y'                                   BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C**********         EVAL      CER048 = 'N'                                   BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** CMD
OVRDBF FILE(SDAULGL2) TOFILE(SDAULGL2) SHARE(*NO)
