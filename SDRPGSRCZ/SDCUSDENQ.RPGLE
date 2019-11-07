     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details enquiry')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSDENQ - Customer Details Enquiry                         *
      *                                                               *
      *  Function:  This will allow the user to enquire upon          *
      *             the details of a customer.                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054028           Date 05Sep19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 AR1003366          Date 11May16               *
      *                 AR981842           Date 11May16               *
      *                 LLN022             Date 03Jun15               *
      *                 CER070             Date 19Aug14               *
      *                 CFT050             Date 03Jun13               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26917A          Date 27Jan10               *
      *                 BUG26917           Date 20Jan10               *
      *                 BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 02Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 06Jul07               *
      *                 249076             Date 03Aug07               *
      *                 249102             Date 20Jul07               *
      *                 BUG11722           Date 18Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10643           Date 21Feb06               *
      *                 BUG10443           Date 07Feb06               *
      *                 CSD028             Date 22Aug05               *
      *                 235524             Date 25Aug05               *
      *                 BUG8906            Date 07Oct05               *
      *                 BUG7053            Date 06May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4454            Date 08Oct04               *
      *                 CLE025   *CREATE   Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  AR1003366- Decimal-data error occurred in ILE/SDCUSDCVT.     *
      *             Change parameter lists of called program SDCUSDCVT*
      *             in SR/CVTCUS. (Child: AR1003367)                  *
      *           - Applied for MD034103.                             *
      *  AR981842 - Database error due to parameter mismatch. Match   *
      *             parameters with SDCUSDBRW, SDCUSDRTV and SDCUSDCVT*
      *             (Child: AR981843)                                 *
      *           - Applied for MD034103.                             *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Recompile over changes in /COPY                     *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,SDH00080                                 *
      *             WNCPYSRC,SDH00081                                 *
      *             WNCPYSRC,SDH00082                                 *
      *             WNCPYSRC,SDH00083                                 *
      *             WNCPYSRC,SDH00084                                 *
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
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  249102 - Do not proceed if an error is encountered in        *
      *           validation of action code from SDCUSDRTV.           *
      *  BUG11722 - DB Error on call                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10643 - Parameter mismatch                                *
      *  BUG10443 - Database Error                                    *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  235524 - Show "Message Routing Maintenance" screen on enquiry*
      *  BUG8906- Add missing parm to call to SDCUSDRTV               *
      *  BUG7053- SDCUSDENQ does not show window correctly            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4454- Database error when inserting a customer with       *
      *           additional customer details                         *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
 
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
 
      ** Current Customer in File Format
     D CrCuFilFmt    E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(C_)
      * Current Customer - SWIFT Details  in File Format                                      CSW207
     D CrSwFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
     D                                     PREFIX(C_)                                         CSW207
                                                                                              CER059
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX(TX)                                         CER059
 
                                                                                              258286
      ** Current Customer in File Format - Base Rate Tax Details
     D CrBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
     D                                     PREFIX(C_)
 
      ** Current Customer in File Format - Private Banking Details
     D CrPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(C_)
 
      ** Current Global Customer X-Reference in File Format
     D GCrCuFilFmt   E DS                  EXTNAME(GPCUSTXPD)
     D                                     PREFIX(CG_)
      *                                                                                      BUG8906
     D/COPY WNCPYSRC,SDH00080
     D CrTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG8906
     D                                     PREFIX(C_)                                        BUG8906
                                                                                             BUG8906
 
      ** Current Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@)
 
      ** Current Customer in Screen Format - Base Rate Tax Details
     D CurCuBrt      E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@)
 
      ** Current Customer in Screen Format - Private Banking Details
     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(@)
 
      ** Current Customer in Screen Format - Secondary Details
     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@)
 
      ** Current Customer in Screen Format - Message Details
     D CurCuMsg      E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@)
 
      ** Current Customer in Screen Format - MT3xx BEI Details
     D CurCuMT3x     E DS                  EXTNAME(SDCUMTPD)
     D                                     PREFIX(@)
      ** Current Customer in Screen Format - MT3xx BEI Details                                CFT050
     D CuSW13        E DS                  EXTNAME(SDSW13PD)                                  CFT050
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
 
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
 
      ** New Customer in File Format - Base Rate Tax Details
     D NwBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
 
      ** New Customer in File Format - Private Banking Details
     D NwPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
 
      ** New Customer in Screen Format - Primary Details
     D NewCuPrim     E DS                  EXTNAME(SDCUPRPD)
      ** New Customer in Screen Format - Primary Details                                      CSW207
     D NewCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
 
      ** New Customer in Screen Format - Base Rate Tax Details
     D NewCuBrt      E DS                  EXTNAME(SDCUBRPD)
 
      ** New Customer in Screen Format - Private Banking Details
     D NewCuPriv     E DS                  EXTNAME(SDCUPBPD)
 
      ** New Customer in Screen Format - Secondary Details
     D NewCuSeco     E DS                  EXTNAME(SDCUSEPD)
 
      ** New Customer in Screen Format - Message Details
     D NewCuMsg      E DS                  EXTNAME(SDCUMRPD)
 
      ** New Customer in Screen Format - MT3xx BEI Details
     D NewCuMT3x     E DS                  EXTNAME(SDCUMTPD)
 
      ** Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)
     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
     D OKCuMT3x      E DS                  EXTNAME(SDECUMTPD)
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
 
      ** Further Details Parameter Data Structure
     D**********FURDETS          DS           565                                            BUG4454
     D***FURDETS          DS           708                                          BUG4454 BUG26917
     D***FURDETS          DS           709                                        BUG26917 BUG26917A
     DFURDETS          DS           708                                                    BUG26917A
     D FDCUST                  1      6
     D FDCSSN                  7     16
     D FDCRTN                157    166
     D FDCRNM                168    187
     D FDLINC                228    229
     D FDTICS                564    564
     D FDCRPC                702    702                                                      BUG4454
     D FDBRCD                703    705                                                      BUG4454
     D FDLICD                706    708                                                      BUG4454
     D***FDTAIN                709    709                                         BUG26917 BUG26917A
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** First DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access progrmas, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * SD Custom Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SDCUEXPD)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
                                                                                            AR981842
      ** (Current) Marketing Info Details in file Format                                    AR981842
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                AR981842
                                                                                            AR981842
      ** (Current) Additional Customer Details in file Format                               AR981842
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                AR981842
                                                                                            AR981842
      ** (Current) Service Fees Details in file Format                                      AR981842
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                AR981842
                                                                                            AR981842
      ** (Current) Cheques and Cards Details in file Format                                 AR981842
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                AR981842
                                                                                            AR981842
      ** (Current) Safe Details in file Format                                              AR981842
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                AR981842
                                                                                            AR981842
      ** (Current) Risk weighted assets in file Format                                      AR981842
     D RwanFilFmt    E DS                  EXTNAME(SDCRWAPD)                                AR981842
                                                                                            AR981842
      ** (Current) Future and Option in file Format                                         AR981842
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                AR981842
     D Q1SMAC        E                     EXTFLD(QQSMAC)                                   AR981842
                                                                                            AR981842
      ** (Current) Portfolio Management in file Format                                      AR981842
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                AR981842
                                                                                            AR981842
      ** (Current) Fn in file Format                                                        AR981842
     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                AR981842
                                                                                            AR981842
      ** (Current) Lux(European Reporting) in file format                                   AR981842
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                AR981842
                                                                                            AR981842
      ** (Current) Lux(IBLC - Extended Information) in file format                          AR981842
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                AR981842
                                                                                            AR981842
      ** Valid Marketing Info Details layout                                                AR981842
     D ValidCumi     E DS                  EXTNAME (SDVCUMIPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Additional Customer Details layout                                           AR981842
     D ValidCuad     E DS                  EXTNAME (SDVCUADPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Service Fees Details layout                                                  AR981842
     D ValidSfee     E DS                  EXTNAME (SDVSFEEPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Cheques and Cards Details layout                                             AR981842
     D ValidChec     E DS                  EXTNAME (SDVCHECPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Safe Details layout                                                          AR981842
     D ValidCusf     E DS                  EXTNAME (SDVCUSFPD)                              AR981842
     D                                     PREFIX (V_CF)                                    AR981842
                                                                                            AR981842
      ** Valid Risk weighted assets layout                                                  AR981842
     D ValidRwan     E DS                  EXTNAME (SDVRWANPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Future and Option layout                                                     AR981842
     D ValidCufo     E DS                  EXTNAME (SDVCUFOPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Portfolio Management Details layout                                          AR981842
     D ValidCupm     E DS                  EXTNAME (SDVCUPMPD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Fn Details layout                                                            AR981842
     D ValidCufn     E DS                  EXTNAME (SDVFOX1PD)                              AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Lux(European Reporting) Details file                                         AR981842
     D ValidCulx2    E DS                  EXTNAME (SDVCULX2PD)                             AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** Valid Lux(IBLC - Extended Information) Details file                                AR981842
     D ValidCulx1    E DS                  EXTNAME (SDVCULX1PD)                             AR981842
     D                                     PREFIX (V_)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Service Fees                                 AR981842
     D CurCuSfee     E DS                  EXTNAME (SDSFEEPD)                               AR981842
     D                                     PREFIX (K@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Cheques and Cards                            AR981842
     D CurCuChec     E DS                  EXTNAME (SDCHECPD)                               AR981842
     D                                     PREFIX (L@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Safe Details                                 AR981842
     D CurCuCusf     E DS                  EXTNAME (SDCUSFPD)                               AR981842
     D                                     PREFIX (M@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Fx Netting                                   AR981842
     D CurCuCufx     E DS                  EXTNAME (SDCUFXPD)                               AR981842
     D                                     PREFIX (N@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Fiduciary Details                            AR981842
     D CurCuCufd     E DS                  EXTNAME (SDCUFDPD)                               AR981842
     D                                     PREFIX (O@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Risk weighted assets                         AR981842
     D CurCuRwan     E DS                  EXTNAME (SDRWANPD)                               AR981842
     D                                     PREFIX (P@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Future and Option                            AR981842
     D CurCuCufo     E DS                  EXTNAME (SDCUFOPD)                               AR981842
     D                                     PREFIX (Q@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Portfolio Management                         AR981842
     D CurCuCupm     E DS                  EXTNAME (SDCUPMPD)                               AR981842
     D                                     PREFIX (R@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - TI Details                                   AR981842
     D CurCuTicd     E DS                  EXTNAME (SDTICDPD)                               AR981842
     D                                     PREFIX (S@)                                      AR981842
                                                                                            AR981842
      ** (Current) European Reporting & IBLC  Extended Information                          AR981842
      ** Screen Format - Details                                                            AR981842
     D CurCuCurx     E DS                  EXTNAME (SDCURXPD)                               AR981842
     D                                     PREFIX (X@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Message Routing Details                      AR981842
     D CurCuMsrt     E DS                  EXTNAME(SDCUMRPD)                                AR981842
     D                                     PREFIX(E@)                                       AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Base Rate Tax Details                        AR981842
     D CurCuBrTx     E DS                  EXTNAME(SDCUBRPD)                                AR981842
     D                                     PREFIX(F@)                                       AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Marketing Info Details                       AR981842
     D CurCuCumi     E DS                  EXTNAME (SDCUMIPD)                               AR981842
     D                                     PREFIX (I@)                                      AR981842
                                                                                            AR981842
      ** (Current) Customer in Screen Format - Additional Customer                          AR981842
     D CurCuCuad     E DS                  EXTNAME (SDCUADPD)                               AR981842
     D                                     PREFIX (J@)                                      AR981842
                                                                                            AR981842
      ** Valid TI details layout                                                            AR981842
     D ValidTIcd     E DS                  EXTNAME(SDVTICDPD)                               AR981842
     D                                     PREFIX(V_)                                       AR981842
 
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
     D/COPY QWINDSRC,SDCUSDDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D***CER048          S              1                                         BUG26917 BUG26917A
     D CLE025          S              1
     D CFX001          S              1
     D DDAPRC          S              1                                                     MD054028
     D CSC011          S              1
     D CSW024          S              1
     D S01383          S              1
     D CGP001          S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PMode           S              1
     D WKCUST          S                   LIKE(DDCUSN)
     D WBldSfl         S              1
     D WCustRead       S              6
     D WCustSel        S              6
     D @EDTFD          S              1
     D @EKYFD          S              1
     D @EINKG          S              1
     D @EINKH          S              1
     D @EINKJ          S              1
     D @EINKW          S              1
     D @EINKX          S              1
     D @ERRMS          S              7
     D @data           S             45                                                       249076
     D @INKC           S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKI           S              1
     D @INKJ           S              1
     D @INKL           S              1
     D @INKW           S              1
     D @INKX           S              1
     D @OPSEL          S              1
     D @RDBCK          S              1
     D @RDFWD          S              1
     D @RDNB           S              1
     D WReadSfl        S              1
     D WScreen         S              1
     D Idx             S              3  0
     D WIdx            S              3  0                                                  BUG23518
     D PTFRCUST        S              1
     D RTNCDE          S              7
     D AUTHRQ          S              1
     D AUTHMD          S              1
     D PTransType      S              4                                                       CSD028
     D PUpdYN          S              1                                                     BUG11722
     D PAccMde         S              1                                                     BUG11722
     D WAccMde         S              1                                                     BUG11722
     D CSD037          S              1                                                     BUG11722
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUSDE001
 
      *****************************************************************
      /EJECT                                                           b
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SDCUSDE002
      *
      /COPY WNCPYSRC,SDCUSDE003
 
      ** Build browse subfile record
 
     C                   IF        WScreen = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   IF        WScreen = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDCUSDE004
 
      ** DO WHILE screen: Primary Details Screen
 
     C                   DOW       WScreen = 'P'
     C                   EXSR      Scrn@P
     C                   ENDDO
 
      /COPY WNCPYSRC,SDCUSDE005
 
      ** DO WHILE screen: Base Rate Tax Details
 
     C                   DOW       WScreen = 'X'
     C                   EXSR      Scrn@B
     C                   ENDDO
 
      /COPY WNCPYSRC,SDCUSDE006
 
      ** DO WHILE screen: Secondary Details Screen
 
     C                   DOW       WScreen = 'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
 
      /COPY WNCPYSRC,SDCUSDE007
 
      ** DO WHILE screen: MT3xx BEI Details Screen
 
     C                   DOW       WScreen = 'F'
     C                   EXSR      SCRN@F
     C                   ENDDO
 
      ** DO WHILE screen: Message Details Screen
 
     C                   DOW       WScreen = 'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
 
      /COPY WNCPYSRC,SDCUSDE008
 
      ** DO WHILE screen: Private Banking Details
 
     C     BGN4ST        IFEQ      'Y'
     C                   DOW       WScreen = 'I'
     C                   EXSR      Scrn@R
     C                   ENDDO
     C                   ENDIF
 
      /COPY WNCPYSRC,SDCUSDE009
 
      ** Do window processing
 
     C     BGN4ST        IFEQ      'Y'
     C                   DOW       WScreen = 'W'
     C                   EXSR      Scrn@W
     C                   ENDDO
     C                   ELSE
     C     WScreen       DOWEQ     'W'
     C                   EXSR      Scrn@W2
     C                   ENDDO
     C                   ENDIF
 
      /COPY WNCPYSRC,SDCUSDE010
 
      ** Terminate program
 
     C                   IF        WScreen = 'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUSDS012
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@P - PROCESS PRIMARY SCREEN                              *
      *                                                               *
      *****************************************************************
     C     SCRN@P        BEGSR
 
      ** Set function keys
 
     C                   EXSR      SFKEYS
 
      ** Display screen - Primary Details
 
     C                   CALLB     'SDCUSD2DP'
 
      ** INPUTS
      ** Return code
      ** Primary Customer Details (Screen format)
      ** Fields in error
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NewCuPrim
     C                   PARM                    OKCuPrim
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Disable Key & Detail Fields
 
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
 
      ** Enabled/Disabled Function Keys
      ** KG = Cmd Keys 07/08 = Previous Customer/Next Customer
      ** KJ = Cmd Key 10 = Confirm Delete
      ** KW = Cmd Key 22 = Confirm Closure or Release
      ** KX = Cmd Key 23 = Further Details
 
     C                   PARM                    @EINKG
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKW
     C                   PARM                    @EINKX
 
      ** Switchable features
 
     C                   PARM                    CLE025
     C                   PARM                    CFX001
     C                   PARM      *Blanks       PTransType                                 BUG10443
     C                   PARM                    CSD037                                     BUG11722
      * Customer (IN SCREEN FORMAT - SWIFT Extension)                                         CSW207
     C                   PARM                    NewCuSwft                                    CSW207
      * Fields in error SWIFT Details                                                         CSW207
     C                   PARM                    OKCuSwft                                     CSW207
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKW
     C                   PARM      '0'           @INKX
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F7 - Roll Backwards
 
     C     @INKG         CASEQ     '1'           ROLL
 
      ** F8 - Roll Forwards
 
     C     @INKH         CASEQ     '1'           ROLL
 
      ** F12 - Cancel on Primary Screen
 
     C     @INKL         CASEQ     '1'           CANC@P
 
      ** Validate Input to Primary Screen
 
     C                   CAS                     VAL@P
      *
     C                   ENDCS
 
      ** On F23, go to Further Details, if no errors on this screen
 
     C     @INKX         IFEQ      '1'
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL@P  - VALIDATE INPUT TO PRIMARY SCREEN                    *
      *                                                               *
      *****************************************************************
     C     VAL@P         BEGSR
 
      ** Initialise control fields for Base Rate Tax (BRT) customer
 
     C     S01383        IFEQ      'Y'
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'
     C                   MOVE      '1'           BRTSCREEN
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   ENDIF
     C                   ENDIF
 
     C     DDACTN        IFEQ      'E'
 
      ** Further Details (F23) has not been selected
 
     C     @INKX         IFEQ      '0'
 
      ** BRT is ON
 
     C     S01383        IFEQ      'Y'
 
      ** If account holder type is 'I', 'J' or 'R', display Participant details
 
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'
     C                   MOVE      'X'           WScreen
     C                   ELSE
     C                   MOVE      'S'           WScreen
     C                   ENDIF
 
      ** If BRT is OFF, go to message details screen
 
     C                   ELSE
     C                   MOVE      'S'           WScreen
     C                   ENDIF
 
      ** If Further Details (F23) has been selected,
      ** return to Primary Detail Screen after Further Details
 
     C                   ELSE
     C                   MOVE      'P'           WScreen
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@B - PROCESS BASE RATE TAX DETAILS SCREEN                *
      *                                                               *
      *****************************************************************
     C     SCRN@B        BEGSR
 
      ** If Account Holder Type is 'R', default BRT Tax Ind to 'N'
 
     C     DDTAIN        IFEQ      'R'
     C                   EVAL      DDTXIN = 'N'
     C                   ENDIF
 
     C                   CALLB     'SDCUSD6DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Primary Details
      ** Base Rate Tax Details
 
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuBrt
 
      ** Fields in error
 
     C                   PARM                    OKCuBrt
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Display first or second page of Base Rate Tax details
 
     C                   PARM                    BRTSCREEN         1
 
      ** Changed Party Names Array
 
     C                   PARM                    ChgNamArr         1
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKS             1
 
      ** Write screen with no read indicator
 
     C                   PARM                    WriteOnly
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F12 - Cancel on Base Rate Tax Screen
 
     C     @INKL         CASEQ     '1'           CANC@B
 
      ** Validate Input to Base Rate Tax Screen
 
     C                   CAS                     VAL@B
 
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL@B  - VALIDATE INPUT TO BASE RATE TAX DETAILS             *
      *                                                               *
      *****************************************************************
     C     VAL@B         BEGSR
 
      ** Enquire
 
     C     DDACTN        IFEQ      'E'
 
      ** From BRT screen 1, go to screen 2 if there are details to view
      ** Otherwise, return to browse screen
 
     C     BRTSCREEN     IFEQ      '1'
     C     DD3NAM        ANDNE     *BLANKS
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVE      'S'           WScreen
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@S - PROCESS SECOND SCREEN                               *
      *                                                               *
      *****************************************************************
     C     SCRN@S        BEGSR
 
      ** Set function key status on SECONDARY screen
 
     C                   EXSR      SFKEYS
 
      ** Display Screen - Secondary Details
 
     C                   CALLB     'SDCUSD3DP'
 
      ** INPUTS
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Customer (in screen format - Primary)
      ** Customer (in screen format - Secondary)
 
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuSwft                                    CSW207
 
      ** Fields in error
 
     C                   PARM                    OKCuSeco
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled/Disabled Function Keys
      ** KJ = Cmd Key 10 = Confirm Delete
      ** KX = Cmd Key 23 = Further Details
 
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKX
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F12 - Cancel on Secondary Screen
 
     C     @INKL         CASEQ     '1'           CANC@S
 
      ** Validate Input to Secondary Screen
 
     C                   CAS                     VAL@S
 
     C                   ENDCS
 
      ** On F23, go to Further Details, if there are no errors on this screen
 
     C     @INKX         IFEQ      '1'
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN                  *
      *                                                               *
      *****************************************************************
     C     VAL@S         BEGSR
 
      ** Enquire
 
     C     DDACTN        IFEQ      'E'
 
      ** If F23 is not taken, display Message Details screen
 
     C     @INKX         IFEQ      '0'
 
      ** If MT3xx BEI enhancement has been installed and
      ** SWIFT/Direct Link module is on then display
      ** screen for MT3xx BEI details
 
     C                   IF        CSW024 = 'Y' AND
     C                             BGMSDL = 'Y'
     C                   MOVEL     'F'           WScreen
     C                   ELSE
     C                   MOVEL     'M'           WScreen
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@F - Process MT3xx BEI and Fund Details screen           *
      *                                                               *
      *****************************************************************
 
     C     SCRN@F        BEGSR
 
      ** Set function key status for MT3xx BEI screen
 
     C                   EXSR      SFKEYS
 
      ** Display MT3xx BEI and Fund details screen
 
     C                   CALLB     'SDCUSD8DP'
 
      ** INPUTS
      ** Return Code
      ** New Customer in Screen Format - Primary Details
      ** New Customer in Screen Format - MT3xx BEI details
      ** Fields in error
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuMT3x
     C                   PARM                    OKCuMT3x
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Function Keys
      ** KJ = Command Key 10 = DELETE
      ** KX = Command Key 23 = FURTHER DETAILS
 
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKX
 
      ** Write screen with no read indicator
 
     C                   PARM                    WriteOnly
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F12 - Cancel on Message Details Screen
 
     C     @INKL         CASEQ     '1'           CANC@F
 
      ** Validate Input to Message Details Screen
 
     C                   CAS                     VAL@F
 
     C                   ENDCS
 
      ** If F23 is taken, display Further Details screen
 
     C     @INKX         IFEQ      '1'
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL@F - Validate MT3xx BEI and Fund Details screen           *
      *                                                               *
      *****************************************************************
 
     C     VAL@F         BEGSR
 
      ** Enquire
 
     C     DDACTN        IFEQ      'E'
 
      ** If displaying Further Details, return to message details screen
      ** Otherwise move on to customer subfile display
 
     C     @INKX         IFNE      '1'
     C     @RDNB         IFEQ      'Y'
     C     BGN4ST        ANDEQ     'Y'
     C                   MOVEL     'I'           WScreen
     C                   ELSE
      **If*Window*Processing*on:***************************************               BUG7053 235524
      **********                                                                      BUG7053 235524
     C*****BGWDPR        IFEQ      'Y'                                                BUG7053 235524
     C**********         MOVEL     'W'           WScreen                              BUG7053 235524
     C**********         ELSE                                                         BUG7053 235524
     C**********         EXSR      INITIAL                                                    235524
     C**********         ENDIF                                                        BUG7053 235524
      *                                                                                       235524
     C                   MOVEL     'M'           WScreen                                      235524
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@M - PROCESS MESSAGE DETAILS SCREEN                      *
      *                                                               *
      *****************************************************************
 
     C     SCRN@M        BEGSR
 
      ** Set function key status on Secondary screen
 
     C                   EXSR      SFKEYS
 
      ** Display Message Details Screen
 
     C                   CALLB     'SDCUSD4DP'
 
      ** INPUTS
      ** Return Code
      ** New Customer in screen format - Primary Details
      ** New Customer in screen format - Message Details
      ** Fields in error
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuMsg
     C                   PARM                    OKCuMsg
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Function Keys
      ** KJ = Cmd Key 10 = Confirm Delete
      ** KX = Cmd Key 23 = Further Details
 
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKX
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F12 - Cancel on Message Details Screen
 
     C     @INKL         CASEQ     '1'           CANC@M
 
      ** Validate Input to Message Details Screen
 
     C                   CAS                     VAL@M
     C                   ENDCS
 
      ** F23 - Further Details
 
     C     @INKX         IFEQ      '1'
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL@M  - VALIDATE INPUT TO MESSAGE DETAILS SCREEN            *
      *                                                               *
      *****************************************************************
 
     C     VAL@M         BEGSR
 
      ** Enquire
 
     C     DDACTN        IFEQ      'E'
 
      ** If displaying Further Details, return to message details screen
      ** Otherwise, move on to customer subfile display
 
     C     @INKX         IFNE      '1'
     C     @RDNB         IFEQ      'Y'
     C     BGN4ST        ANDEQ     'Y'
     C                   MOVEL     'I'           WScreen
     C                   ELSE
      * If window processing on                                                              BUG7053
b3   C     BGWDPR        IFEQ      'Y'                                                       BUG7053
     C                   MOVEL     'W'           WScreen                                     BUG7053
x3   C                   ELSE                                                                BUG7053
     C                   EXSR      INITIAL
e3   C                   ENDIF                                                               BUG7053
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@R - PROCESS Private Banking Details Screen              *
      *                                                               *
      *****************************************************************
 
     C     SCRN@R        BEGSR
 
     C                   CALLB     'SDCUSD5DP'
 
      ** INPUTS
      ** Return code
      ** New Customer in Screen Format - Primary Details
      ** New Customer in Screen Format - Private Banking Details
      ** Fields in error
 
     C                   PARM                    RetCodeIn
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuPriv
     C                   PARM                    OKCuPriv
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Enabled Function Key
      ** KX = Cmd Key 23 = Further Details
 
     C                   PARM                    @EINKX
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKX
 
      ** Write screen with no read indicator
 
     C                   PARM                    WriteOnly
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F12 - Cancel on Base Rate Tax Screen
 
     C     @INKL         CASEQ     '1'           CANC@R
 
      ** Validate Input to Private Banking Screen
 
     C                   CAS                     VAL@R
     C                   ENDCS
 
      ** F23 - Further Details
 
     C     @INKX         IFEQ      '1'
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRN@W - Window Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     Scrn@W        BEGSR
 
     C                   CALLB     'SDCUSD5DP'
 
      ** INPUTS
      ** Return code
      ** New Customer in Screen Format - Primary Details
      ** New Customer in Screen Format - Private Banking Details
      ** Fields in error
 
     C                   PARM      *BLANKS       RetCodeIn
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuPriv
     C                   PARM                    OKCuPriv
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Enabled Function Key
      ** KX = Cmd Key 23 = Further Details
 
     C                   PARM                    @EINKX
 
      ** OUTPUTS
      ** Function Keys
 
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKX
 
      ** Write screen with no read indicator
 
     C                   PARM      'Y'           WriteOnly
      *
     C/COPY WNCPYSRC,SDCUSDSMV1
      *
      ** If BOE installed                                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window.                                                             LLN022A
      ** Customer Number:                                                                    LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYCUST = DDCUSN                                           LLN022A
      *                                                                                      LLN022A
      ** Institution and Industry Codes                                                      LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYLINC = CULINC                                           LLN022A
     C                   Eval      BYLICD = CULICD                                           LLN022A
     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALL      'WN0010'
     C                   PARM      'SDCUSDSIN'   PWPgm            10
     C                   PARM                    PWKey             2
     C                   PARM      DDACTN        PWAction          1
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWRtn             7
     C                   PARM                    PWSpare         256
 
      ** F3 - End program
 
     C     PWRtn         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
 
      ** F12 - Return to Private Banking Details screen
 
     C     PWRtn         IFEQ      'USR0790'
     C     BGN4ST        IFEQ      'Y'                                                       BUG7053
     C                   EVAL      WScreen = 'I'
     C                   ELSE                                                                BUG7053
     C                   EVAL      WScreen = 'M'                                             BUG7053
     C                   ENDIF                                                               BUG7053
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
 
      ** ENTER - Go back to browse screen
 
     C     DDACTN        IFEQ      'E'
     C                   EXSR      INITIAL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *****************************************************************
      * SCRN@W2 - Window Processing(non private banking)
      *****************************************************************
     C     Scrn@W2       BEGSR
      *
      *
     C/COPY QWINDSRC,SDCUSDSMV1
      *
      ** If BOE installed                                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window.                                                             LLN022A
      ** Customer Number:                                                                    LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYCUST = DDCUSN                                           LLN022A
      *                                                                                      LLN022A
      ** Institution and Industry Codes                                                      LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYLINC = CULINC                                           LLN022A
     C                   Eval      BYLICD = CULICD                                           LLN022A
     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALL      'WN0010'
     C                   PARM      'SDCUSDSIN'   PWPgm            10
     C                   PARM                    PWKey             2
     C                   PARM      DDACTN        PWAction          1
     C                   PARM                    Data
     C                   PARM      *Blanks       PWRtn             7
     C                   PARM                    PWSpare         256
      *
      ** If F3 pressed, end program
      *
     C     PWRtn         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      ** Else if F12 pressed, return to PROCESS MESSAGE DETAILS SCREEN
      *
     C     PWRtn         IFEQ      'USR0790'
     C     BGN4ST        IFEQ      'Y'
     C                   EVAL      WScreen = 'I'
     C                   ELSE
     C                   EVAL      WScreen = 'M'
     C                   ENDIF
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
      *
      ** Else if ENTER key was pressed,
      **      if action is Enquire, move on to initial subfile display
      *
     C                   EXSR      INITIAL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAL@R  - VALIDATE INPUT TO Private Banking Details           *
      *                                                               *
      *****************************************************************
 
     C     VAL@R         BEGSR
 
      ** Enquire
 
     C     DDACTN        IFEQ      'E'
 
      ** Enquire
 
     C     @INKX         IFNE      '1'
 
      ** Display window
 
     C     BGWDPR        IFEQ      'Y'
     C                   MOVE      'W'           WScreen
 
     C                   IF        CSC011 = 'Y'
     C                             AND LIBR = S1SUPP
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKCuPriv
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
     C                   ENDIF
 
      ** Window processing is off, return to browse screen
 
     C                   ELSE
 
     C     @RDNB         IFEQ      'Y'
     C                   MOVE      'R'           WScreen
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        CSC011 = 'Y'
     C                             AND LIBR = S1SUPP
     C                   EVAL      WScreen = 'I'
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE       *
      *                                                               *
      *****************************************************************
 
     C     ROLL          BEGSR
 
     C                   MOVE      'E'           DDACTN
 
      ** Read Next or Previous record on Customer file
      ** according to command key taken (F7/@INKG OR F8/@INKH)
 
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
 
     C                   CALLB     'SDCUSDRED'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Action Code
      ** Customer
 
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
 
      ** Read Forwards
      ** Read Backwards
 
     C                   PARM                    @RDFWD
     C                   PARM                    @RDBCK
 
      ** OUTPUTS
      ** Error message
      ** Customer reference read
 
     C                   PARM      *BLANKS       @ERRMS
     C                   PARM      *BLANK        @data                                        249076
     C                   PARM      *BLANK        WCustRead
 
      ** If error message returned from read, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
 
     C                   ELSE
 
      ** If Customer is read, retrieve Customer details
 
     C     WCustRead     IFNE      *BLANK
     C                   MOVEL     WCustRead     DDCUSN
     C                   EXSR      RTVCUS
 
      ** Return to browse screen if there is an error on customer number
 
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'B'           WScreen
 
     C                   ELSE
 
      ** Check if customer is a Portfolio Management customer
 
     C                   EXSR      CHKPTFR
 
      ** Convert Customer details from file to screen format
 
     C                   EXSR      CVTCUS
     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
     C                   CLEAR                   NwPbFilFmt
     C                   MOVEL     CrPbFilFmt    NwPbFilFmt
     C                   MOVEL     'P'           WScreen
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build Browse Subfile                              *
      *                                                               *
      *****************************************************************
 
     C     SRBldBrw      BEGSR
 
      ** Reset Read Next Browse subfile record
 
     C                   MOVEL     *BLANK        @RDNB
 
      ** Build Browse subfile
 
     C                   CALLB     'SDCUSDBRW'
 
      ** INPUTS
      ** Return Code
      ** Action Code
      ** Customer Ref. Pointer
      ** Build subfile
      ** Read subfile record
      ** Mode
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
     C                   PARM      'Y'           WBldSfl
     C                   PARM      *BLANK        WReadSfl
     C                   PARM      'E'           PMode
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    CSD037                                     BUG11722
 
      ** OUTPUTS
      ** Error message
      ** Option Selected
      ** Customer Reference Selected
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM                    @data                                      AR981842
     C/COPY WNCPYSRC,SDH00081
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        WCustSel
 
      ** Command Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM                    WAccMde                                    BUG11722
 
      ** If F3 taken, end program
 
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
 
     C                   ELSE
 
      ** If error message returned from browse, send it to detail screen
      ** Otherwise, read next browse subfile record
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   ELSE
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           WScreen
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
      ** Read Next Subfile Record
 
     C                   CALLB     'SDCUSDBRW'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
      ** Customer Ref. Pointer
 
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
 
      ** Build subfile
      ** Read subfile record
      ** Mode
 
     C                   PARM      *BLANK        WBldSfl
     C                   PARM      'Y'           WReadSfl
     C                   PARM      'E'           PMode
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    CSD037                                     BUG11722
 
      ** OUTPUTS
      ** Error message
      ** Option Selected
      ** Customer Reference Selected
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @data                                        249076
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        WCustSel
 
      ** Command Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
     C                   PARM                    WAccMde                                    BUG11722
 
      ** If Customer is read, retrieve customer details
 
     C     WCustSel      IFNE      *BLANK
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     WCustSel      DDCUSN
     C                   EXSR      SRVACTN
 
     C     DDACTNOK      IFEQ      'N'
     C                   MOVEL     'B'           WScreen
     C                   ELSE
     C                   EXSR      RTVCUS
 
      ** Stay on browse screen if there is an error on customer number
 
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'                                                        249102
     C                   MOVEL     'B'           WScreen
 
     C                   ELSE
 
      ** Check if customer is a Portfolio Management customer
 
     C                   EXSR      CHKPTFR
 
      ** Convert Customer details
 
     C                   EXSR      CVTCUS
     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
     C                   MOVEL     CrPBFilFmt    NwPBFilFmt
 
      ** Set Primary Details screen
 
     C     @OPSEL        IFEQ      'E'
     C                   MOVEL     'P'           WScreen
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** No customer read, go back to browse screen
 
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RTVCUS - Retrieve Customer Details                           *
      *                                                               *
      *****************************************************************
 
     C     RTVCUS        BEGSR
 
     C                   CALLB     'SDCUSDRTV'
 
      ** INPUTS
      ** Return code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Mode (Front office/Back office)
      ** Response mode
      * Action Code
 
     C                   PARM      '      '      @@MODE            6
     C                   PARM      'S'           @@RSMD            1
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
      ** Trade Reference
 
     C                   PARM                    C_BBFRNT
     C                   PARM                    DDCUSN
 
      ** Base Rate Auth req
      ** Base Auth mode
 
     C                   PARM                    AUTHRQ
     C                   PARM                    AUTHMD
      ***KYC:*Transaction*Type*****************************************              CSD028 BUG10643
     C**********         PARM      *BLANKS       PTransType                          CSD028 BUG10643
 
      ** Base Rate Tax option feature is switched on
      ** Private Banking Customer module is switched on
      ** Global Data Layout feature is switched on
 
     C                   PARM                    S01383
     C                   PARM                    BGN4ST
     C                   PARM                    CGP001
                                                                                            BUG10643
      ** KYC: Transaction                                                                   BUG10643
                                                                                            BUG10643
     C                   PARM      *BLANKS       PTransType                                 BUG10643
     C                   PARM                    PAccMde                                    BUG11722
     C                   PARM                    PUpdYN                                     BUG11722
 
      ** OUTPUTS
      ** Current Customer in file format - Primary Details
      ** Current Customer in file format - Base Rate Tax Details
      ** Current Customer in file format - Private Banking Details
      ** (Current) Global Customer X-Reference in file format
 
     C                   PARM                    CrCuFilFmt
     C                   PARM                    CrBrFilFmt
     C                   PARM                    CrPBFilFmt
     C                   PARM                    CrTIFilFmt                                  BUG8906
     C                   PARM                    GCrCuFilFmt
     C                   PARM                    CrSwFilFmt                                   CSW207
     C                   PARM                    CuSW13                                       CFT050
     C                   PARM                    CumiFilFmt                                 AR981842
     C                   PARM                    CuadFilFmt                                 AR981842
     C                   PARM                    SfeeFilFmt                                 AR981842
     C                   PARM                    ChecFilFmt                                 AR981842
     C                   PARM                    CusfFilFmt                                 AR981842
     C                   PARM                    RwanFilFmt                                 AR981842
     C                   PARM                    CufoFilFmt                                 AR981842
     C                   PARM                    CufnFilFmt                                 AR981842
     C                   PARM                    CupmFilFmt                                 AR981842
     C                   PARM                    CueuFilFmt                                 AR981842
     C                   PARM                    CuibfFilFmt                                AR981842
     C/COPY WNCPYSRC,SDH00082
     C                   PARM                    TranInCUAH                                   CER059
     C                   PARM                    TranInCCTX                                   CER059
     C                   PARM                    CurCuPrim                                    CFT050
     C                   PARM                    CurCuSeco                                    CFT050
     C                   PARM                    CurCuMT3x                                    CFT050
 
      ** OK - Action code
      ** OK - Customer Reference
 
     C                   PARM      *BLANK        DDACTNOK
     C                   PARM      *BLANK        DDCUSNOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Idx
 
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIdArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      *                                                                                     BUG23518
     C                   PARM      *ZEROS        WIdx                                       BUG23518
      *                                                                                     BUG23518
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVACTN - Validate Action Code                               *
      *                                                               *
      *****************************************************************
 
     C     SRVACTN       BEGSR
 
     C                   EVAL      DDACTNOK = *BLANK
     C                   EVAL      Idx = 0
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
 
     C                   IF        @OPSEL <> *BLANK  AND  @OPSEL <> 'E'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR4022'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKPTFR - Check if Portfolio Management Customer             *
      *                                                               *
      *****************************************************************
 
     C     CHKPTFR       BEGSR
 
      ** Initialize Portfolio Management customer indicator
 
     C                   MOVE      'N'           PtfrCust
 
      ** Retrieve Portfolio Management customer details
 
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPLCSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      DDCUSN        P@CUST           10
     C                   PARM                    DSFDY
 
      ** If Portfolio Management customer details exist, set up
      ** Portfolio Management Customer Indicator.
 
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           PtfrCust
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CVTCUS - Put a Customer on the Primary Details screen        *
      *                                                               *
      *****************************************************************
 
     C     CVTCUS        BEGSR
 
      ** Call module to fill screen fields with data from SDCUSTPD
 
     C                   CALLB     'SDCUSDCVT'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeOut
 
      ** Current Customer in file format - Primary Details
      ** Current Customer in file format - Base Rate Tax Details
      ** Current Customer in file format - Private Banking Details
      ** Global Customer X-Reference
 
     C                   PARM                    CrCuFilFmt
     C                   PARM                    CrBrFilFmt
     C                   PARM                    CrPBFilFmt
     C**********         PARM                    ValidCumi                       AR981842  AR1003366
     C**********         PARM                    ValidCuad                       AR981842  AR1003366
     C**********         PARM                    ValidSfee                       AR981842  AR1003366
     C**********         PARM                    ValidChec                       AR981842  AR1003366
     C**********         PARM                    ValidCusf                       AR981842  AR1003366
     C**********         PARM                    ValidRwan                       AR981842  AR1003366
     C**********         PARM                    ValidCufo                       AR981842  AR1003366
     C**********         PARM                    ValidCufn                       AR981842  AR1003366
     C**********         PARM                    ValidCupm                       AR981842  AR1003366
     C                   PARM                    CumiFilFmt                                AR1003366
     C                   PARM                    CuadFilFmt                                AR1003366
     C                   PARM                    SfeeFilFmt                                AR1003366
     C                   PARM                    ChecFilFmt                                AR1003366
     C                   PARM                    CusfFilFmt                                AR1003366
     C                   PARM                    RwanFilFmt                                AR1003366
     C                   PARM                    CufoFilFmt                                AR1003366
     C                   PARM                    CufnFilFmt                                AR1003366
     C                   PARM                    CupmFilFmt                                AR1003366
     C                   PARM                    ValidTicd                                  AR981842
     C                   PARM                    ValidCulx2                                 AR981842
     C                   PARM                    ValidCulx1                                 AR981842
     C/COPY WNCPYSRC,SDH00083
     C                   PARM                    GCrCuFilFmt
     C                   PARM                    CrSwFilFmt                                   CSW207
 
      ** Switchable features
 
     C                   PARM                    CLE025
     C                   PARM                    CFX001
      *                                                                                     MD054028
     C                   PARM                    DDAPRC                                     MD054028
 
      ** OUTPUTS
      ** Customer Details in screen formats
 
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuMT3x
     C                   PARM                    NewCuMsg
     C                   PARM                    NewCuBrt
     C                   PARM                    NewCuPriv
     C                   PARM                    CurCuCumi                                  AR981842
     C                   PARM                    CurCuCuad                                  AR981842
     C/COPY WNCPYSRC,SDH00084
     C                   PARM                    TranInACU3                                   CER059
     C                   PARM                    TranInACU4                                   CER059
     C                   PARM                    CurCuSfee                                  AR981842
     C                   PARM                    CurCuCufx                                  AR981842
     C                   PARM                    CurCuCufd                                  AR981842
     C                   PARM                    CurCuChec                                  AR981842
     C                   PARM                    CurCuCusf                                  AR981842
     C                   PARM                    CurCuRwan                                  AR981842
     C                   PARM                    CurCuCufo                                  AR981842
     C                   PARM                    CurCuCupm                                  AR981842
     C                   PARM                    CurCuTicd                                  AR981842
     C                   PARM                    CurCuCurx                                  AR981842
     C                   PARM                    NewCuSwft                                    CSW207
 
      ** Update 'Current' Customer with Customer in Screen Format
 
     C                   MOVEL     NewCuPrim     CurCuPrim
     C                   MOVEL     NewCuBrt      CurCuBrt
     C                   MOVEL     NewCuSeco     CurCuSeco
     C                   MOVEL     NewCuMsg      CurCuMsg
     C                   MOVEL     NewCuPriv     CurCuPriv
     C                   MOVEL     NewCuMT3x     CurCuMT3x
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SFKEYS - SET FUNCTION KEY STATUS ON SCREEN                   *
      *                                                               *
      *****************************************************************
 
     C     SFKEYS        BEGSR
 
      ** Enable/disable function keys
 
     C     WScreen       IFEQ      'P'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   ENDIF
 
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKW
     C                   MOVEL     'Y'           @EINKX
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SNDM@P - SEND A MESSAGE TO SCREEN                            *
      *                                                               *
      *****************************************************************
 
     C     SNDM@P        BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
     C                   MOVEL     @data         MsgDtaArr(E)                                 249076
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CANC@P - CANCEL ON PRIMARY SCREEN                            *
      *                                                               *
      *****************************************************************
 
     C     CANC@P        BEGSR
 
      ** Return to 'subfile' screen
 
     C                   MOVEL     'B'           WScreen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CANC@S - CANCEL ON SECONDARY SCREEN                          *
      *                                                               *
      *****************************************************************
 
     C     CANC@S        BEGSR
 
      ** Return to BRT tax screen
 
     C     S01383        IFEQ      'Y'
     C     DDTAIN        ANDEQ     'I'
     C     S01383        OREQ      'Y'
     C     DDTAIN        ANDEQ     'J'
     C     S01383        OREQ      'Y'
     C     DDTAIN        ANDEQ     'R'
     C                   MOVE      'X'           WScreen
 
      ** Or return to Primary Details screen
 
     C                   ELSE
     C                   MOVE      'P'           WScreen
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CANC@F - Cancel on MT3xx BEI and Fund Details screen          *
      *                                                               *
      *****************************************************************
 
     C     CANC@F        BEGSR
 
      ** Go to secondary details screen
 
     C                   MOVEL     'S'           WScreen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CANC@M - CANCEL ON MESSAGE DETAILS SCREEN                    *
      *                                                               *
      *****************************************************************
 
     C     CANC@M        BEGSR
 
      ** If MT3xx BEI enhancement has been installed and
      ** SWIFT/Direct Link module is on, display MT3xx BEI details
 
     C                   IF        CSW024 = 'Y' AND
     C                             BGMSDL = 'Y'
     C                   MOVEL     'F'           WScreen
 
      ** Otherwise, return to secondary screen
 
     C                   ELSE
     C                   MOVEL     'S'           WScreen
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CANC@B - CANCEL ON BASE RATE TAX SCREENS                     *
      *                                                               *
      *****************************************************************
 
     C     CANC@B        BEGSR
 
      ** If on BRT screen 2, F12 returns to BRT screen 1
      ** otherwise F12 returns to customer Primary Details screen
 
     C     BRTSCREEN     IFEQ      '2'
     C                   MOVEL     '1'           BRTSCREEN
     C                   ELSE
     C                   MOVEL     'P'           WScreen
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CANC@R - CANCEL ON Private Banking SCREEN                    *
      *                                                               *
      *****************************************************************
 
     C     CANC@R        BEGSR
 
      ** Return to Messages Screen
 
     C                   MOVEL     'M'           WScreen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FURDET - Further Details                                     *
      *                                                               *
      *****************************************************************
 
     C     FURDET        BEGSR
      **********                                                                  BUG26917 BUG26917A
     C*****CER048        IFEQ      'Y'                                            BUG26917 BUG26917A
     C*****DDTAIN        IFEQ      'Y'                                            BUG26917 BUG26917A
     C**********         EVAL      FDTAIN = DDTAIN                                BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C**********         EVAL      FDTAIN = *BLANKS                               BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
 
      ** Call Further Details
 
     C                   MOVE      DDCUSN        FDCUST
     C                   MOVE      DDCSSN        FDCSSN
     C                   MOVE      DDCRTN        FDCRTN
     C                   MOVE      DDCRNM        FDCRNM
     C                   MOVE      DDLINC        FDLINC
     C                   MOVE      C_BBTICS      FDTICS
     C                   MOVE      DDCRPC        FDCRPC                                      BUG4454
     C                   MOVE      DDBRCD        FDBRCD                                      BUG4454
     C                   MOVE      DDLICD        FDLICD                                      BUG4454
 
     C                   CALL      'SD0014V'                              90
     C                   PARM                    RTNCDE
     C                   PARM                    FURDETS
     C                   PARM                    @OPSEL
     C                   PARM                    DDPAIN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ENDP - End Program                                           *
      *                                                               *
      *****************************************************************
 
     C     ENDP          BEGSR
 
     C                   MOVEL     'T'           WScreen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INITIAL Go To Initial Screen                                 *
      *                                                               *
      *****************************************************************
 
     C     INITIAL       BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   MOVEL     *BLANK        @RDNB
 
      ** Blank the screens
 
     C                   MOVEL     *BLANK        NewCuPrim
     C                   MOVEL     *BLANK        NewCuSeco
     C                   MOVEL     *BLANK        NewCuMsg
     C                   MOVEL     *BLANK        NewCuPriv
     C                   MOVEL     *BLANK        NewCuMT3x
 
      ** Browse Screen
 
     C                   MOVEL     'B'           WScreen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = 'SDCUSDSIN'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if S01383 (Base Rate Tax) is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01383'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'S01383'
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01383 = 'Y'
     C                   ELSE
     C                   EVAL      S01383 = 'N'
     C                   ENDIF
 
      ** Check if CSW024 (S.W.I.F.T. MT3xx Field 82/83/87) is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW024'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSW024'
     C                   EVAL      DBASE  = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSW024 = 'Y'
     C                   ELSE
     C                   EVAL      CSW024 = 'N'
     C                   ENDIF
 
      ** Check if CSC011 (24x7 Midas Availability) is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE  = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ELSE
     C                   EVAL      CSC011 = 'N'                                              BUG7053
     C******             EVAL      CSW024 = 'N'                                              BUG7053
     C                   ENDIF
 
      ** Check if Global Data Layout Enhancement (CGP001) is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGP001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CGP001'
     C                   EVAL      DBASE  = 6
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CGP001 = 'Y'
     C                   ELSE
     C                   EVAL      CGP001 = 'N'
     C                   ENDIF
 
      ** Check if CLE025 is on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE025'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CLE025'
     C                   EVAL      DBASE  = 7
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CLE025 = 'Y'
     C                   EVAL      CFX001 = 'Y'
     C                   ELSE
     C                   EVAL      CLE025 = 'N'
     C                   EVAL      CFX001 = 'N'
     C                   ENDIF
 
      ** Access Switchable Features file to determine whether                                LLN022A
      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN022'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        PRTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ***Check*if*CER048*is*ON*                                                   BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         CALLB     'AOSARDR0'                                     BUG26917 BUG26917A
     C**********         PARM      *BLANKS       PRTCD                            BUG26917 BUG26917A
     C**********         PARM      '*VERIFY'     POPTN                            BUG26917 BUG26917A
     C**********         PARM      'CER048'      PSARD                            BUG26917 BUG26917A
     C*****SCSARD        PARM      SCSARD        DSFDY                            BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '      BUG26917 BUG26917A
     C**********         EVAL      DBFILE = 'SCSARDPD'                            BUG26917 BUG26917A
     C**********         EVAL      DBKEY  = 'CER048'                              BUG26917 BUG26917A
     C**********         EVAL      DBASE  = 008                                   BUG26917 BUG26917A
     C**********         EXSR      *PSSR                                          BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        PRTCD = *BLANKS                                BUG26917 BUG26917A
     C**********         EVAL      CER048 = 'Y'                                   BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C**********         EVAL      CER048 = 'N'                                   BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C                   EXSR      INITIAL
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUSDS013
 
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
(c) Finastra International Limited 2003
