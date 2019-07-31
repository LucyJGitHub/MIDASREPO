     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details interface controller')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDCTL - SD Customer Details Maintenance.                 *
      *                                                               *
      *  Function: This Program Validates SD Customer Details for     *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Customer details fields           *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Customer and bypass the rest        *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD029805           Date 05Sep14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 258286             Date 24Dec08               *
      *                 256351A            Date 03Dec08               *
      *                 256564             Date 17Sep08               *
      *                 BUG15052A          Date 25Oct07               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 06Jul07               *
      *                 BUG13228           Date 07Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 29Aug06               *
      *                 240665             Date 29Jan06               *
      *                 BUG7356            Date 06Jan06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9070            Date 24Jul05               *
      *                 CSD028             Date 22Aug05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3362            Date 28Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 23May03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 201011             Date 28Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 CPB002             Date 08Mar00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP013             Date 22Nov99               *
      *                 CAP034  *CREATE    Date 26Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  258286  - Missing parameter for SDCUSDCVT                    *
      *  256351A - Missing parameter for SDCUSDRTV                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15052A - Missing record on SDCUSWPD                       *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  BUG13228-Need to pass ULX004 parameter to SDCUSD9VL          *
      *  CPK025 - Reverse out BUG7356 as it is a copy of BUG9070.     *
      *  240665 - Complete fix for BUG3362.                           *
      *  BUG7356 - Missing parameter CuTIFilFmt between SDCUSDCTL and *
      *            SDCUSDRTV                                          *
      *            Part of fix already done by BUG9070.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPLus                            *
      *  BUG9070 - Missing parameter for SDCUSDRTV                    *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3362 - Added processing for TI details.                   *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *  CSD012 - Standing Data Authorisation                         *
      *  201011 - Not able to insert/amend customer details when      *
      *           account holder type is not I, J or R.               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CSD007 - Customer Closing                                    *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP034 - Midas / ToF Interface                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      * Valid Customers
     FSDVCUSDPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Customers - Private Banking file
     FSDVCUPBPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Customers - BRT Details file
     FSDVCUBRPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Customers - Swift Extension File                                               CSW207A
     FSDVSWSDPD UF A E             DISK    INFSR(*pssr)                                      CSW207A
     F                                     PREFIX(V_)                                        CSW207A
     F                                     COMMIT                                            CSW207A
      * Invalid Customers
     FSDICUSDPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
                                                                                             CSW207A
      * Invalid Swift Extension                                                              CSW207A
     FSDISWSDPD UF A E             DISK    INFSR(*pssr)                                      CSW207A
     F                                     COMMIT                                            CSW207A

      * Invalid Private Banking Fields
     FSDICUPBPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Invalid Base Rate Tax details
     FSDICUBRPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

     FSDVCUSDL1 IF   E           K DISK    RENAME(SDVCUSDD0:SDVCUSDCHK)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUSDC001
     FSDVCULX2PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSDICULX2PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSDVCULX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSDICULX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
      * Invalid Customers Details extra data file                                             CER001
     FSDICEXL1  UF A E           K DISK    INFSR(*pssr) USROPN                                CER001
     F                                     COMMIT                                             CER001

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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(SDCUPRPD)
     D TranInSwft    E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D TranInSeco    E DS                  EXTNAME(SDCUSEPD)
     D TranInMT3X    E DS                  EXTNAME(SDCUMTPD)                                  CSW024
     D TranInMsrt    E DS                  EXTNAME(SDCUMRPD)
     D TranInBrTx    E DS                  EXTNAME(SDCUBRPD)
     D   TranInBrT1            1    500
     D***TranInBrT2**********501    692                                         CRE007
     D   TranInBrT2          501    693                                         CRE007
     D TranInPriv    E DS                  EXTNAME(SDCUPBPD)

      * Valid Customer layout
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
     D                                     PREFIX(V_)
      * Valid SWIFT Detail in File Format                                                     CSW207
     D ValidSwft     E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
     D                                     PREFIX(V_)                                         CSW207
      * Valid Customer Private Banking details layout
     D ValidPriv     E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(V_)
      * Valid Customer BRT details layout
     D ValidCuBr     E DS                  EXTNAME(SDVCUBRPD)
     D                                     PREFIX(V_)

     D ValidTIcd     E DS                  EXTNAME(SDVTICDPD)                                 240665
     D                                     PREFIX(V_)                                         240665
                                                                                              240665

      * (Current) Customer record in file Format
     D CustFilFmt    E DS                  EXTNAME(SDCUSTPD)
      * (Current) Customer Private Banking details record in file Format
      * Current Customer - SWIFT Details  in File Format                                      CSW207
     D SwftFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
                                                                                              CSW207
     D PrivFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(A_)
      * (Current) Customer BRT details record in file Format
     D BrtxFilFmt    E DS                  EXTNAME(SDCBRTPD)
      * (Current) BRT Participator history record in file Format
     D BrptFilFmt    E DS                  EXTNAME(PTYHSTPD)
     D                                     PREFIX(P)
      ** TI Customer Details in File Format                                                  BUG9070
     D CuTIFilFmt    E DS                  EXTNAME(SDTICSPD)                                 BUG9070
     D                                     PREFIX(A_)                                        BUG9070
      ** Current Global Customer X-Reference in File Format                                   CGP001
     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
     D                                     PREFIX(CG_)                                        CGP001
      ** Marketing Information Details in File Format                                        256351A
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                 256351A
                                                                                             256351A
      ** Additional Customer details in File Format                                          256351A
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                 256351A
                                                                                             256351A
      ** Service Fees Details in File Format                                                 256351A
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                 256351A
     D Q_QQSMAC      E                     EXTFLD(QQSMAC)                                    256351A
                                                                                             256351A
      ** Cheques and Cards Details in File Format                                            256351A
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                 256351A
                                                                                             256351A
      ** Safe details in File Format                                                         256351A
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                 256351A
                                                                                             256351A
      ** Risk weighted assets in Valid File Format                                           256351A
     D RwanFilFmt    E DS                  EXTNAME(SDVRWANPD)                                256351A
                                                                                             256351A
      ** Future and option Detail in File Format                                             256351A
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                 256351A
                                                                                             256351A
      ** Future & options European reporting in File Format                                  256351A
     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                 256351A
                                                                                             256351A
      ** Fiduciary Details in File Format                                                    256351A
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                 256351A
                                                                                             256351A
     ** Lux(European Reporting) in file format                                               256351A
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                 256351A
                                                                                             256351A
     ** Lux(IBLC - Extended Information) in file format                                      256351A
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                 256351A
                                                                                              258286
      ** TI Customer Details in File Format                                                   258286
     D TICDFILFMT    E DS                  EXTNAME(SDTICSPD)                                  258286


      * (Current) Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@)
      * Current Customer in Screen Format - Swift Extension                                   CSW207
     D CurCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D                                     PREFIX(@)                                          CSW207
      * (Current) Customer in Screen Format - Secondary Details
     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@)
      * (Current) Customer in Screen Format - MT3xx BEI Details                               CSW024
     D CurCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
     D                                     PREFIX(@)                                          CSW024
      * (Current) Customer in Screen Format - Message Routing Details
     D CurCuMsrt     E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@)
      * (Current) Customer in Screen Format - Base Rate Tax Details
     D CurCuBrTx     E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@)
      * (Current) Customer in Screen Format - Private Banking Details
     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(@)
      ** Marketing Information                                                                258286
     D TranInCumi    E DS                  EXTNAME (SDCUMIPD)                                 258286
     D A9_DDACTN     E                     EXTFLD(DDACTN)                                     258286
                                                                                              258286
      ** Additional Customer                                                                  258286
     D TranInCuad    E DS                  EXTNAME (SDCUADPD)                                 258286
     D B1_DDACTN     E                     EXTFLD(DDACTN)                                     258286
     D A2_DDCNA1     E                     EXTFLD(DDCNA1)                                     258286
     D A3_DDCNA2     E                     EXTFLD(DDCNA2)                                     258286
     D A4_DDCNA3     E                     EXTFLD(DDCNA3)                                     258286
     D A8_DDCNA4     E                     EXTFLD(DDCNA4)                                     258286
     D A2_DDCSSN     E                     EXTFLD(DDCSSN)                                     258286
                                                                                              CER059
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
                                                                                              258286
      ** Service Fees                                                                         258286
     D TranInSfee    E DS                  EXTNAME (SDSFEEPD)                                 258286
     D A1_DDACTN     E                     EXTFLD(DDACTN)                                     258286
                                                                                              258286
      ** Cheques and Card Details                                                             258286
     D TranInChec    E DS                  EXTNAME (SDCHECPD)                                 258286
     D A2_DDACTN     E                     EXTFLD(DDACTN)                                     258286
                                                                                              258286
      ** Safe Details                                                                         258286
     D TranInCusf    E DS                  EXTNAME (SDCUSFPD)                                 258286
     D A3_DDACTN     E                     EXTFLD(DDACTN)                                     258286
                                                                                              258286
      ** FX netting Details                                                                   258286
     D TranInCufx    E DS                  EXTNAME (SDCUFXPD)                                 258286
     D A4_DDACTN     E                     EXTFLD(DDACTN)                                     258286
      ** Fiduciary Details                                                                    258286
     D TranInCufd    E DS                  EXTNAME (SDCUFDPD)                                 258286
     D A5_DDACTN     E                     EXTFLD(DDACTN)                                     258286
                                                                                              258286
      ** Risk Weighted Assets                                                                 258286
     D TranInRwan    E DS                  EXTNAME (SDRWANPD)                                 258286
     D A6_DDACTN     E                     EXTFLD(DDACTN)                                     258286
     D A1_DDCSSN     E                     EXTFLD(DDCSSN)                                     258286
     D A1_DDCRNM     E                     EXTFLD(DDCRNM)                                     258286
     D A1_DDCNA2     E                     EXTFLD(DDCNA2)                                     258286
                                                                                              258286
      ** Future and Options                                                                   258286
     D TranInCufo    E DS                  EXTNAME (SDCUFOPD)                                 258286
     D A7_DDACTN     E                     EXTFLD(DDACTN)                                     258286
     D A1_DDSMAC     E                     EXTFLD(DDSMAC)                                     258286
                                                                                              258286
      ** Portfolio Management                                                                 258286
     D TranInCupm    E DS                  EXTNAME (SDCUPMPD)                                 258286
     D A8_DDACTN     E                     EXTFLD(DDACTN)                                     258286
                                                                                              258286
      ** TI Details                                                                           258286
     D TranInTicd    E DS                  EXTNAME (SDTICDPD)                                 258286
     D B2_DDACTN     E                     EXTFLD(DDACTN)                                     258286
      ** Lux European & IBLC - Extended Information                                           258286
     D TranInCurx    E DS                  EXTNAME (SDCURXPD)                                 258286
     D                                     PREFIX(T1_)                                        258286
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX(TX)                                         CER059


      * Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuMT3X      E DS                  EXTNAME(SDECUMTPD)                                 CSW024
     D OKCuMsrt      E DS                  EXTNAME(SDECUMRPD)
     D OKCuBrtx      E DS                  EXTNAME(SDECUBRPD)
     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
     D/COPY WNCPYSRC,SDH00681
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File

     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D SCA_LCD       E                     EXTFLD(LCD)

     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * SD Customer details Extra Data - File (D/B) format
     D RegData       E DS                  EXTNAME(SDCURXPD)                                  CER001
      * SD Customer Extension Details  - File (D/B) format                                    CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     *****                                                                            BUG7356 CPK025
     ****TI*Customer*Details*in*File*Format*                                          BUG7356 CPK025
     D*CuTIFilFmt*   E DS                  EXTNAME(SDTICSPD)                          BUG7356 CPK025
     D****                                 PREFIX(B_)                                 BUG7356 CPK025
     *****                                                                            BUG7356 CPK025
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans5007       S            500A                                                      CSW024
     D Trans5008       S            500A                                                      CSW207

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Field (500A) to receive the incoming Extra Data                                      CER001
     D RegData500      S            500A                                                      CER001
                                                                                              CER001
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0



      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D Object          S             10A   INZ('SDCUSDUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX2           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX3           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX4           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX5           S              1    DIM(50) CTDATA PERRCD(50)                         BUG3362
     D ##OX6           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D ##OX7           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D ##OX8           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D ##OX9           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D #OX10           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D #OX11           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D #OX12           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D #OX13           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D #OX14           S              1    DIM(50) CTDATA PERRCD(50)                         256351A
     D #OX15           S              1    DIM(50) CTDATA PERRCD(50)                         256351A

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
     D RepSeco         S              1A   inz('N')
     D RepMT3X         S              1A   inz('N')                                           CSW024
     D RepMsrt         S              1A   inz('N')
     D RepBrTx         S              1A   inz('N')
     D RepPriv         S              1A   inz('N')
     D RepSWFT         S              1A   inz('N')                                          CSW207A

      ** Fields defined for CSC011                                                            CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PCustNum        S             18A                                                      CSC011
     D PACustNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
     D CGP001          S              1                                                       CGP001
     D V_DDGCUS        S             10                                                       CGP001
                                                                                              CGP001
      * Defined Fields for CSD012                                                             CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqCustomerMaint')                      CSD012
                                                                                              CSD012
      ** Override SDAULGL2                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSD012
     D CLE025          S              1                                                       CLE025
     D CFX001          S              1                                                       CFX001
                                                                                              CLE025
     D PTransType      S              4                                                       CSD028
     D PDATA           DS          1024                                                       CER001
     D**#1FLD1****             1      6  0                                            CER001 CSD027A
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
                                                                                              CER001
      ** Swift installed flag                                                                CSW207A
     D CSW207          S              1A                                                     CSW207A
                                                                                             CSW207A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUSDC002
                                                                                              CER001
      ** Valid Extended Customer in File Format                                               CER001
     D ValidFilExt   E DS                  EXTNAME(SDVCULX2PD)                                CER001
                                                                                              CER001
      ** Errors Indicators Extended Fields                                                    CER001
     D OkFlagsExt    E DS                  EXTNAME(SDECULX2PD)                                CER001
      *                                                                                       CER001
      ** Valid Extended Customer in File Format                                               CER001
     D ValidFilExtL  E DS                  EXTNAME(SDVCULX1PD)                                CER001
                                                                                              CER001
      ** Errors Indicators Extended Fields                                                    CER001
     D OkFlagsExtL   E DS                  EXTNAME(SDECULX1PD)                                CER001

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,SDCUSDC003

      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C**********         MOVEL     Trans5003     TranInMsrt                                   CSW024
     C**********         MOVEL     Trans5004     TranInBrT1                                   CSW024
     C**********         MOVEL     Trans5005     TranInBrT2                                   CSW024
     C**********         MOVEL     Trans5006     TranInPriv                                   CSW024
     C                   MOVEL     Trans5003     TranInMT3X                                   CSW024
     C                   MOVEL     Trans5004     TranInMsrt                                   CSW024
     C                   MOVEL     Trans5005     TranInBrT1                                   CSW024
     C                   MOVEL     Trans5006     TranInBrT2                                   CSW024
     C                   MOVEL     Trans5007     TranInPriv                                   CSW024
     C                   MOVEL     Trans5008     TranInSwft                                   CSW207
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
     C/COPY WNCPYSRC,SDCUSDCC04

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,SDCUSDC004

      *  Check if valid Customer details exists

     C                   EXSR      ChkValCusd
      *
      *  If valid Cust.det. does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid Customer exists for Midas Customer Number               CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiCu                                   CAP013
      *                                                                         CAP013
      *  If valid Customer does exist (even after delay), fail this input       CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013

      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Customer details file.

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,SDCUSDC005

      *  Validate Action Code

     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,SDCUSDC006

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,SDCUSDC007
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SDCUSDC008

     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,SDCUSDC009

      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank

     C     GHSUBS        scan      TranInPrim                             99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInSeco                             99
     C                   if        *in99
     C                   eval      RepSeco = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInMT3X                             99                  CSW024
     C                   if        *in99                                                      CSW024
     C                   eval      RepMT3X = 'Y'                                              CSW024
     C                   endif                                                                CSW024
                                                                                              CSW024
     C     GHSUBS        scan      TranInMsrt                             99
     C                   if        *in99
     C                   eval      RepMsrt = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInBrT1                             99
     C                   if        *in99
     C                   eval      RepBrTx = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInBrT2                             99
     C                   if        *in99
     C                   eval      RepBrTx = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInPriv                             99
     C                   if        *in99
     C                   eval      RepPriv = 'Y'
     C                   endif
                                                                                             CSW207A
     C     GHSUBS        scan      TranInSwft                             99                 CSW207A
     C                   if        *in99                                                     CSW207A
     C                   eval      RepSWFT = 'Y'                                             CSW207A
     C                   endif                                                               CSW207A

      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        (RepPrim = 'Y' OR RepSeco = 'Y' OR
     C                              RepMsrt = 'Y' OR RepBrTx = 'Y' OR
     C**********                    RepPriv = 'Y')                                            CSW024
     C**********                    RepPriv = 'Y' OR RepMT3X = 'Y')                   CSW024 CSW207A
     C                              RepPriv = 'Y' OR RepMT3X = 'Y' OR                 CSW024 CSW207A
     C                              RepSWFT = 'Y')                                           CSW207A
     C                   EXSR      DtaSubs
     C                   endif

     C                   endif
      **                 (End of "if DDACTN = 'A' and GHSUBS <> *blank")

     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,SDCUSDC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SDCUSDC011
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,SDCUSDC012

      ** Processing for Closure or Release                                                    CSD007
                                                                                              CSD007
     C                   WHEN         DDACTN = 'C'                                            CSD007
     C                             OR DDACTN = 'R'                                            CSD007
                                                                                              CSD007
     C                   EXSR      SetupAmd                                                   CSD007
     C                   EXSR      ValidateTr                                                 CSD007
                                                                                              CSD007
     C                   ENDSL
      *
     C     INVALID       TAG

      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,SDCUSDC013

     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN

     C                   ELSE

      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,SDCUSDC014
      *                                                                                       CER001
      ** ULX609 - API Luxembourg - Function SDCUSD                                            CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C     DDACTN        ANDEQ     'I'                                                        CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
     C                   MOVE      *ALL'Y'       OkFlagsExtL                                  CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   MOVE      DDPAIN        #1PAIN                                       CER001
     C                   MOVE      DDPCNB        #1PCNB                                       CER001
     C                   MOVE      DDCUSN        #1CUST                                       CER001
     C                   MOVE      DDLINC        #1LINC                                       CER001
     C                   MOVE      DDCOLC        #1COLC                                       CER001
     C                   MOVE      DDCNCZ        #2CNCZ                                       CER001
     C                   MOVE      DDBNBI        #1BNBI                                       CER001
     C                   MOVEL     DDCRNM        #1CRNM                                       CER001
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'                                                        CER001
     C     #6LXMCID      IFEQ      ' '                                                        CER001
     C                   EVAL      #6LXMCID = '4'                                             CER001
     C                   ENDIF                                                                CER001
     C                   CALLB     'SDCUSD9VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    Regdata                                      CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
     C                   PARM                    ULX008                                       CER001
     C                   PARM                    ULX012                                       CER001
     C**********         PARM                    ULX032                              CER001 BUG13228
     C                   PARM                    ULX004                                     BUG13228
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C                   EVAL      #6LXVFCUST = CUCUST                                        CER001
     C                   EVAL      #6LXVFFOTR = APFOTranID                                    CER001
     C                   EVAL      #6LXVFTMES = TimeStamp                                     CER001
     C                   EVAL      #6LXVFCRNM = #1CRNM                                        CER001
     C                   EVAL      #6LXVFCOLC = #1COLC                                        CER001
     C     DDACTN        IFNE      'I'                                                        CER001
     C                   EVAL      #6LXVFCONS = 0                                             CER001
     C                   EVAL      #6LXVFECOS = 0                                             CER001
     C                   EVAL      #6LXVFINRF = 0                                             CER001
     C**********         EVAL      #6LXVFCGRP = 0                                     CER001 CSD027A
     C                   EVAL      #6LXVFCGRP = *Blanks                                      CSD027A
     C                   EVAL      #6LXVFPAPS = 0                                             CER001
     C                   EVAL      #6LXVFNCOS = 0                                             CER001
     C                   ENDIF                                                                CER001
     C                   WRITE     SDVCULXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C     Idx           IFGT      0                                                          CER001
     C     APRprLocn     ANDEQ     'B'                                                        CER001
      *                                                                                       CER001
     C     ULX609        IFEQ      'Y'                                                        CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXTMES = TimeStamp                                       CER001
      *                                                                                       CER001
      ** Populate extension fields                                                            CER001
      *                                                                                       CER001
     C                   EVAL      #6LXCONS = L6LXCONS                                        CER001
     C                   EVAL      #6LXECOS = L6LXECOS                                        CER001
     C                   EVAL      #6LXINRF = L6LXINRF                                        CER001
     C                   EVAL      #6LXCGRP = L6LXCGRP                                        CER001
     C                   EVAL      #6LXPAPS = L6LXPAPS                                        CER001
     C                   EVAL      #6LXPERF = L6LXPERF                                        CER001
     C                   EVAL      #6LXNCOS = L6LXNCOS                                        CER001
     C                   EVAL      #6LXAUTG = L6LXAUTG                                        CER001
     C                   EVAL      #6LXPROG = L6LXPROG                                        CER001
     C                   EVAL      #6LXASSP = L6LXASSP                                        CER001
     C                   EVAL      #6LXICCD = L6LXICCD                                        CER001
     C                   EVAL      #6LXMCID = L6LXMCID                                        CER001
     C                   EVAL      #6LXSMRS = L6LXSMRS                                        CER001
      *                                                                                       CER001
     C                   WRITE     SDICULXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C     DDACTN        ANDEQ     'I'                                                        CER001
     C                   CALLB     'SDCUS10VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    Regdata                                      CER001
     C                   PARM                    OkFlagsExtL                                  CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExtL                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   EVAL      #LLXCUCNUM = CUCUST                                        CER001
     C                   EVAL      #LLXCUFOTR = APFOTranID                                    CER001
     C                   EVAL      #LLXCUTMES = TimeStamp                                     CER001
     C                   WRITE     SDVCULXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C     Idx           IFGT      0                                                          CER001
     C     APRprLocn     ANDEQ     'B'                                                        CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   EVAL      #LLXFOTR = APFOTranID                                      CER001
     C                   EVAL      #LLXTMES = TimeStamp                                       CER001
      *                                                                                       CER001
      ** Populate extension file                                                              CER001
      *                                                                                       CER001
     C                   EVAL      #LLXTYPE = LLLXTYPE                                        CER001
     C                   EVAL      #LLXIDCO = LLLXIDCO                                        CER001
     C                   EVAL      #LLXIDEN = LLLXIDEN                                        CER001
     C                   EVAL      #LLXIMCO = LLLXIMCO                                        CER001
     C                   EVAL      #LLXIMNB = LLLXIMNB                                        CER001
      *                                                                                       CER001
     C                   WRITE     SDICULXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,SDCUSDC015

      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return

     C     Return        IFEQ      *BLANK

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUSDC016

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValCusd - Routine to check if valid Customer details exist *
      *                                                               *
      *****************************************************************
     C     ChkValCusd    BEGSR

      * Check for Customer on Valid file
     C                   MOVEL     DDCUSN        CUCUST
     C     CUCUST        CHAIN     SDVCUSDL1                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     CUCUST        CHAIN     SDVCUSDL1                          99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'CUCUST'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiCu - Routine to check if valid Customer exists for    *         CAP013
      *    Midas Customer Number                                      *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiCu    BEGSR                                                  CAP013
                                                                                CAP013
      ** Key list for file SDVCUSDL1                                            CAP013
     C     KMICus        KLIST                                                  CAP013
     C                   KFLD                    KCUST             6            CAP013
      *                                                                         CAP013
      * If (numeric) Midas Customer number supplied                             CAP013
                                                                                CAP013
     C**********         TESTN                   DDCUSN               9898             CAP013 CSD027
     C**********                                                                       CAP013 CSD027
     C     DDCUSN        IFNE      *BLANKS                                      CAP013
     C******IN98         ANDEQ     '1'                                                 CAP013 CSD027
                                                                                CAP013
      * Check for Customer on Valid file                                        CAP013
     C                   MOVEL     DDCUSN        KCUST                          CAP013
     C     KMICus        CHAIN     SDVCUSDL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     KMICus        CHAIN     SDVCUSDL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDCUSN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Customer number supplied                                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDCUSN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013

      * Validate action code versus transaction IDs supplied
      * The Customer in file format from the SD database is retrieved
      * as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'SDCUSDRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C**********         PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Customer Number
     C                   PARM                    DDCUSN            6
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *                                                                         154562
      *  Base Rate Tax option feature is switched on                            154562
     C                   PARM                    S01383                         154562
      *
      *  Private Banking Customer module is switched on                         154562
     C                   PARM                    BGN4ST                         154562
      ** Global Data Layout feature is switched on                                            CGP001
     C                   PARM                    CGP001                                       CGP001
      ** KYC: Transaction Type                                                                CSD028
     C                   PARM                    PTransType                                   CSD028
      *  Acceptance Mode                                                                     256351A
     C                   PARM                    PAccMde           1                         256351A
      *  Update (Y/N)                                                                        256351A
     C                   PARM                    PUpdYN            1                         256351A
      *
      * OUTPUTS
      *
      * (Current) Customer in file format
     C                   PARM                    CustFilFmt
      *
      * (Current) Base Rate Tax details in file format
     C                   PARM                    BrtxFilFmt
      *
      * (Current) Private Banking details in file format
     C                   PARM                    PrivFilFmt
     C                   PARM                    CuTIFilFMt                                  BUG9070
      ** (Current) Global Customer X-Reference in file format                                 CGP001
     C                   PARM                    GCustFilFmt                                  CGP001
     C                   PARM                    SwftFilFmt                                   CSW207
     C                   PARM                    CumiFilFmt                                  256351A
     C                   PARM                    CuadFilFmt                                  256351A
     C                   PARM                    SfeeFilFmt                                  256351A
     C                   PARM                    ChecFilFmt                                  256351A
     C                   PARM                    CusfFilFmt                                  256351A
     C                   PARM                    RwanFilFmt                                  256351A
     C                   PARM                    CufoFilFmt                                  256351A
     C                   PARM                    CufnFilFmt                                  256351A
     C                   PARM                    CupmFilFmt                                  256351A
     C                   PARM                    CueuFilFmt                                  256351A
     C                   PARM                    CuibfFilFmt                                 256351A
     C                   PARM                    TranInCUAH                                   CER059
     C                   PARM                    TranInCCTX                                   CER059
     C/COPY WNCPYSRC,SDH00682
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Customer Number
     C                   PARM                    DDCUSNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *                                                                                     BUG23518
      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIDArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      *                                                                                     BUG23518
      ** Array index (3P0) from/to caller                                                   BUG23518
      *                                                                                     BUG23518
     C                   PARM      *ZEROS        WIdx                                       BUG23518

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For Amends, put the complete (pre-existing) Customer into the Valid
      *  file record - fields in this will be updated during processing

     C                   MOVE      CustFilFmt    ValidCusd
     C***********        MOVE      BrtxFilFmt    ValidCuBr                                    CSW024
     C                   MOVEL     BrtxFilFmt    ValidCuBr                                    CSW024
     C                   MOVE      PrivFilFmt    ValidPriv
     C                   MOVE      SwftFilFmt    ValidSwft                                   CSW207A
     C                   MOVE      CuTIFilFmt    ValidTiCd                                    240665
     C/COPY WNCPYSRC,SDH00683
      ** If Global Data Layer enhancement is on, put the retrieve global                      CGP001
      ** customer x-reference record into the valid file record, get the                      CGP001
      ** front office id, repair location, and timestamp value from  CustFilFmt.              CGP001
                                                                                              CGP001
     C                   IF        CGP001 = 'Y'                                               CGP001
     C                   EVAL      V_DDGCUS = CG_CUGCUS                                       CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
      * For Amends, convert the Customer to screen format

     C                   CALLB     'SDCUSDCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Customer - file formats
      ** Global Customer X-Reference                                                          CGP001
     C                   PARM                    ValidCusd
     C/COPY WNCPYSRC,SDH00684
     C                   PARM                    ValidCuBr
     C                   PARM                    ValidPriv
     C                   PARM                    CumiFilFmt                                   258286
     C                   PARM                    CuadFilFmt                                   258286
     C                   PARM                    SfeeFilFmt                                   258286
     C                   PARM                    ChecFilFmt                                   258286
     C                   PARM                    CusfFilFmt                                   258286
     C                   PARM                    RwanFilFmt                                   258286
     C                   PARM                    CufoFilFmt                                   258286
     C                   PARM                    CufnFilFmt                                   258286
     C                   PARM                    CupmFilFmt                                   258286
     C                   PARM                    TicdFilFmt                                   258286
     C                   PARM                    CueuFilFmt                                   258286
     C                   PARM                    CuibfFilFmt                                  258286
                                                                                              258286
     C                   PARM                    GCustFilFmt                                  CGP001
     C                   PARM                    ValidSwft                                    CSW207
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      *
      * Output parameters
      *
      * Customer Details - screen formats
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCuSeco
     C                   PARM                    CurCuMT3X                                    CSW024
     C                   PARM                    CurCuMsrt
     C                   PARM                    CurCuBrTx
     C                   PARM                    CurCuPriv
     C                   PARM                    TranInCumi                                   258286
     C                   PARM                    TranInCuad                                   258286
     C                   PARM                    TranInACU3                                   CER059
     C                   PARM                    TranInACU4                                   CER059
     C                   PARM                    TranInSfee                                   258286
     C                   PARM                    TranInCufx                                   258286
     C                   PARM                    TranInCufd                                   258286
     C                   PARM                    TranInChec                                   258286
     C                   PARM                    TranInCusf                                   258286
     C                   PARM                    TranInRwan                                   258286
     C                   PARM                    TranInCufo                                   258286
     C                   PARM                    TranInCupm                                   258286
     C                   PARM                    TranInTicd                                   258286
     C                   PARM                    TranInCurx                                   258286
     C                   PARM                    CurCuSwft                                    CSW207
     C/COPY WNCPYSRC,SDH00685
      ** Customer Details

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      * Validate Customer Primary details

     C                   EXSR      ValdCuPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Base Rate Tax Details

     C     S01383        IFEQ      'Y'
     C     DDTAIN        IFEQ      'I'                                                        201011
     C     DDTAIN        OREQ      'R'                                                        201011
     C     DDTAIN        OREQ      'J'                                                        201011

     C                   EXSR      ValdCuBrtx
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
     C                   ENDIF                                                                201011
     C                   EXSR      ValdCuBrtt

     C                   ENDIF

      * Validate Customer Private Banking Details

     C     BGN4ST        IFEQ      'Y'
     C                   EXSR      ValdCuPriv
     C                   ENDIF
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Secondary details

     C                   EXSR      ValdCuSeco
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
                                                                                              CSW024
      * If CSW024 is installed perform MT3X validation routine                                CSW024
                                                                                              CSW024
     C                   IF        CSW024 = 'Y'                                               CSW024
                                                                                              CSW024
      * Validate MT3X BEI & Fund Information details                                          CSW024
                                                                                              CSW024
     C                   EXSR      ValdCuMT3X                                                 CSW024
      *                                                                                       CSW024
      *  If error in validation, fail this input                                              CSW024
      *                                                                                       CSW024
     C     Idx           IFNE      0                                                          CSW024
     C                   GOTO      EValidTr                                                   CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CSW024
     C                   ENDIF                                                                CSW024

      * Validate Message Routing details

     C                   EXSR      ValdCuMsrt

      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuPrim - Validate Customer Primary details                *
      *                                                               *
      *****************************************************************
     C     ValdCuPrim    BEGSR

     C                   CALLB     'SDCUSD2VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

      ** Customer Primary Details
     C                   PARM                    TranInPrim
      * Customer Extra Data file data                                           CAP004
     C                   PARM                    ExtData                        CAP004
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
                                                                                             CSW207A
      * Customer SWIFT Extension                                                             CSW207A
     C                   PARM                    TranInSwft                                  CSW207A
      * OUTPUTS

      *
      ** Customer Primary Details OK inds
     C                   PARM                    OKCuPrim
     C/COPY WNCPYSRC,SDH00686
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
     C                   PARM                    WIdx

      * Valid Customer layout (DS) from/to caller
     C                   PARM                    ValidCusd
     C                   PARM                    V_DDGCUS                                     CGP001
                                                                                             CSW207A
      ** Valid Swift Details OK Inds                                                         CSW207A
     C                   PARM                    OKCuSwft                                    CSW207A
      * Valid Swift Details from/to caller                                                   CSW207A
     C                   PARM                    ValidSwft                                   CSW207A
     C/COPY WNCPYSRC,SDH00687
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuBrTx - Validate Customer Base Rate Tax details          *
      *                                                               *
      *****************************************************************
     C     ValdCuBrtx    BEGSR

     C                   CALLB     'SDCUSD6VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

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
     C                   PARM                    TranInBrtx
      *
      ** Screen validation
     C                   PARM      '0'           SinVal            1
      *

      *
      * OUTPUTS
      *
      ** Customer Base Rate Tax Details OK inds
     C                   PARM                    OKCuBrtx

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
     C                   PARM                    WIdx

      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidCuBr
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         5

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuBrTt - Validate Customer Base Rate Tax details 2ND      *
      *                                                               *
      *****************************************************************
     C     ValdCuBrtt    BEGSR

     C                   CALLB     'SDCUSD7VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

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
     C                   PARM                    TranInBrtx
      *
      * OUTPUTS
      *
      ** Customer Base Rate Tax Details OK inds
     C                   PARM                    OKCuBrtx

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
     C                   PARM                    WIdx
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         5

      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidCuBr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuPriv - Validate Customer Private Banking Deteils        *
      *                                                               *
      *****************************************************************
     C     ValdCuPriv    BEGSR

     C                   CALLB     'SDCUSD5VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Private Banking Customer Indicator
     C                   PARM                    V_CUPRBA
      *
      ** Customer Private Banking Details
     C                   PARM                    TranInPriv
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
      * OUTPUTS
      *
      ** Customer Private Banking Details OK inds
     C                   PARM                    OKCuPriv

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Valid Private Banking layout (DS) from/to caller
     C                   PARM                    ValidPriv

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuSeco - Validate Customer Secondary details              *
      *                                                               *
      *****************************************************************
     C     ValdCuSeco    BEGSR

     C                   CALLB     'SDCUSD3VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

      ** Customer Primary Details
     C                   PARM                    TranInPrim
      ** Customer Secondary Details
     C                   PARM                    TranInSeco
      * Customer Extra Data file data                                           CAP004
     C                   PARM                    ExtData                        CAP004
      ** SWIFT Detail                                                                         CSW207
     C                   PARM                    TranInSwft                                   CSW207
      *
      * OUTPUTS
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
     C                   PARM                    WIdx

      * Valid Customer layout (DS) from/to caller
     C                   PARM                    ValidCusd
      * Valid SWIFT Layout (DS) from/to caller                                                CSW207
     C                   PARM                    ValidSwft                                    CSW207
      * Customer SWIFT Details OK Indicator                                                   CSW207
     C                   PARM                    OkCuSwft                                     CSW207

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW024
      *                                                               *                       CSW024
      * ValdCuMT3X - Validate MT3xx BEI & Fund Details                *                       CSW024
      *                                                               *                       CSW024
      *****************************************************************                       CSW024
     C     ValdCuMT3X    BEGSR                                                                CSW024
                                                                                              CSW024
     C                   CALLB     'SDCUSD8VL'                                                CSW024
                                                                                              CSW024
      * INPUTS                                                                                CSW024
                                                                                              CSW024
      * Response mode                                                                         CSW024
     C                   PARM                    RespMode                                     CSW024
      ** MT3xx BEI & Fund Details                                                             CSW024
     C                   PARM                    TranInMT3X                                   CSW024
      *                                                                                       CSW024
      * OUTPUTS                                                                               CSW024
      *                                                                                       CSW024
      *  MT3xx BEI details screen error indicators                                            CSW024
     C                   PARM                    OKCuMT3x                                     CSW024
                                                                                              CSW024
      * Error fields/message IDs/message data (arrays) from/to caller                         CSW024
     C                   PARM                    FldNameArr                                   CSW024
     C                   PARM                    MsgIDArr                                     CSW024
     C                   PARM                    MsgDtaArr                                    CSW024
      * Array index (3P0) from/to caller                                                      CSW024
     C                   PARM                    Idx                                          CSW024
                                                                                              CSW024
      * Warning fields/message IDs/message data (arrays) from/to caller                       CSW024
     C                   PARM                    WFldNamArr                                   CSW024
     C                   PARM                    WMsgIDArr                                    CSW024
     C                   PARM                    WMsgDtaArr                                   CSW024
      * Array index (3P0) from/to caller                                                      CSW024
     C                   PARM                    WIdx                                         CSW024
                                                                                              CSW024
      * Valid Customer layout (DS) from/to caller                                             CSW024
     C                   PARM                    ValidCusd                                    CSW024
                                                                                              CSW024
     C                   ENDSR                                                                CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************
      *                                                               *
      * ValdCuMsrt - Validate Customer Message Routing details        *
      *                                                               *
      *****************************************************************
     C     ValdCuMsrt    BEGSR

     C                   CALLB     'SDCUSD4VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1

      ** Customer Primary Details
      ** Customer Base Rate Tax Details
      ** Customer Secondary Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
      ** Customer Message Routing Details
     C                   PARM                    TranInMsrt
      * Customer Extra Data file data                                           CAP004
     C                   PARM                    ExtData                        CAP004

      *
      * OUTPUTS
      *
      ** Customer Message Routing Details OK inds
     C                   PARM                    OKCuMsrt

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
     C                   PARM                    WIdx

      * Valid Customer layout (DS) from/to caller
     C                   PARM                    ValidCusd

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend.

      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

     C                   CALLB     'SDCUSDAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Customer in Screen Format :
 Form * - Primary Details
      * - Base Rate Tax Details
      * - Secondary Details
      * - Message Routing Details
     C                   PARM                    TraninPrim
     C                   PARM                    TraninBrtx
     C                   PARM                    TraninSeco
     C                   PARM                    TraninMsrt
     C                   PARM                    TranInSwft                                   CSW207
      *
      * (Current) Customer in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Message Routing Details
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCuSeco
     C                   PARM                    CurCuMsrt
     C                   PARM                    CurCuBrTx
     C                   PARM                    CurCuSwft                                    CSW207
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKCuPrim
     C                   PARM                    OKCuSeco
     C                   PARM                    OKCuMsrt
     C                   PARM                    OKCuBrtx
     C                   PARM                    OKCuSwft                                     CSW207
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************

     C     CheckWrite    BEGSR

      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report customer status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+


     C                   IF        Idx = 0

     C                   EXSR      SETUPVALID
     C                   WRITE     SDVCUSDD0

     C                   IF        S01383 = 'Y'

     C                   EVAL      V_BRFRNT = APFOTranID
     C                   EVAL      V_BRAFRT = APFOAsocID
     C                   EVAL      V_BRREPA = APRprLocn
     C                   EVAL      V_BRTMES = TimeStamp

     C                   WRITE     SDVCUBRPD0


     C                   ENDIF

     C                   IF        BGN4ST = 'Y'

     C                   WRITE     SDVCUPBPD0

     C                   ENDIF
                                                                                             CSW207A
      ** Write record to valid Swift Extension File                                          CSW207A
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                              CSW207A
     C                   WRITE     SDVSWSDD0                                                 CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A

     C/COPY WNCPYSRC,SDCUSDCC02
     C                   EXSR      CallMsgHdl

     C                   ENDIF


     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
     C                   IF        APRprLocn = 'B'                              CAP004

     C                   WRITE     SDICUSDD0

     C                   IF        S01383 = 'Y'
     C                   WRITE     SDICUBRD0
     C                   ENDIF                                                  CAP004

     C                   IF        BGN4ST = 'Y'
     C                   WRITE     SDICUPBD0
     C                   ENDIF                                                  CAP004
                                                                                             CSW207A
      ** Write record to invalid SWIFT extension file                                        CSW207A
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                              CSW207A
     C                   WRITE     SDISWFDD0                                                 CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
     C/COPY WNCPYSRC,SDCUSDCC01
      *                                                                                       CER001
     C                   IF        PB3610 = 'Y'                                               CER001
      *                                                                                       CER001
     C     V_CUFRNT      CHAIN     SDICEXL1                           89                      CER001
     C                   Eval      PBFRNT =  APFOTranID                                       CER001
     C                   Eval      PBCUST =  DDCUSN                                           CER001
      *                                                                                       CER001
     C                   IF        BGSECS = 'Y'                                               CER001
     C                   Eval      PBSEDT =  EXSEDT                                           CER001
     C                   ELSE                                                                 CER001
     C                   Eval      PBSEDT =  'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        BGLMCR = 'Y'                                               CER001
     C                   Eval      PBPLDT =  EXPLDT                                           CER001
     C                   ELSE                                                                 CER001
     C                   Eval      PBPLDT =  'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        BGSECS = 'Y'                                               CER001
     C                   Eval      PBFFDT =  EXFFDT                                           CER001
     C                   ELSE                                                                 CER001
     C                   Eval      PBFFDT =  'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   Eval      PBCLAS =  EXCLAS                                           CER001
     C                   Eval      PBPCYC =  EXPCYC                                           CER001
     C                   Eval      PBCYCD =  EXCYCD                                           CER001
     C                   Eval      PBACCD =  EXACCD                                           CER001
     C                   Eval      PBACSN =  EXACSN                                           CER001
     C                   Eval      PBCFIN =  EXCFIN                                           CER001
     C                   Eval      PBSTFQ =  EXSTFQ                                           CER001
     C                   Eval      PBSBDM =  EXSBDM                                           CER001
     C                   Eval      PBASIN =  EXASIN                                           CER001
     C                   Eval      PBCUCY =  EXCUCY                                           CER001
      *                                                                                       CER001
     C                   IF        *IN89 = False                                              CER001
     C                   UPDATE    SDICEXD0                                                   CER001
     C                   ELSE                                                                 CER001
     C                   WRITE     SDICEXD0                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInPrim + TranInSeco                         CSC011
     C                                        + TranInMsrt + TranInBrTx                       CSC011
     C**********                              + TranInPriv + ExtData                   CSC011 CER001
     C                                        + TranInPriv + RegData                          CER001
     C**********                              + ExtData                               CER001 CSW207A
     C                                        + TranInSwft + ExtData                  CER001 CSW207A
     C                   EVAL      APTGTTYPE = 'SDCUSD'                                       CSC011
     C                   EVAL      PCustNum = DDCUSN                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PCustNum                                     CSC011
     C                   PARM      *BLANKS       PACustNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      DBKEY = PCustNum                                           CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 002                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011

     C                   ENDIF                                                  CAP004

     C                   EXSR      CallMsgHdl

     C                   ENDIF

     C                   COMMIT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx

     C                   RESET                   FldNoArr

     C                   CLEAR                   CurCuPrim
     C                   CLEAR                   CurCuSeco
     C                   CLEAR                   CurCuMT3X                                    CSW024
     C                   CLEAR                   CurCuMsrt
     C                   CLEAR                   CurCuBrtx
     C                   CLEAR                   CurCuPriv

     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVE      *ALL'Y'       OKCuMT3X                                     CSW024
     C                   MOVE      *ALL'Y'       OKCuMsrt
     C                   MOVE      *ALL'Y'       OKCuBrtx
     C                   MOVE      *ALL'Y'       OKCuPriv

     C                   CLEAR                   ValidCusd
     C                   CLEAR                   ValidCuBr
     C                   CLEAR                   ValidPriv
     C                   CLEAR                   ValidTIcd                                    240665

     C                   Z-ADD     0             V_CUSSDT                                     CSW024
     C                   Z-ADD     0             V_CUDOIC                                     CSW024
     C                   Z-ADD     0             V_CUCHID                                     CSW024
     C                   Z-ADD     0             V_CUCHSC                                     CSW024
     C                   Z-ADD     0             V_CUCABA                                     CSW024
     C                   Z-ADD     0             V_CUFWCD                                     CSW024
     C                   Z-ADD     0             V_CULCD                                      CSW024
     C                   Z-ADD     0             V_CULALD                                     CSW024
     C                   Z-ADD     0             V_CULDHD                                     CSW024
     C                   Z-ADD     0             V_CULRLD                                     CSW024
     C                   Z-ADD     0             V_CUDTDL                                     CSW024
     C                   Z-ADD     0             V_CUABA2                                     CSW024
     C                   Z-ADD     0             V_CUORED                                     CSW024
     C                   Z-ADD     0             V_CUAGNP                                     CSW024
     C                   Z-ADD     0             V_CUEFDT                                     CSW024
     C                   Z-ADD     0             V_CUCLDT                                     CSW024
                                                                                              CSW024
     C                   Z-ADD     0             V_PBPBST                                     CSW024
     C                   Z-ADD     0             V_PBLCHD                                     CSW024
                                                                                              CSW024
     C                   Z-ADD     0             V_BRAHCD                                     CSW024
     C                   Z-ADD     0             V_BRXLCD                                     CSW024
     C                   Z-ADD     0             V_BRTNLU                                     CSW024
                                                                                              CSW024
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************

     C     SETUPINVAL    BEGSR

      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp

     C                   EVAL      TranStatus = 'F'

      /COPY WNCPYSRC,SDCUSDC017
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      * For Deletes put the complete (pre-existing) Customer
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                   MOVE      CustFilFmt    ValidCusd
     C***********        MOVE      BrtxFilFmt    ValidCuBr                                    CSW024
     C                   MOVEL     BrtxFilFmt    ValidCuBr                                    CSW024
     C                   MOVE      PrivFilFmt    ValidPriv
     C                   MOVE      SwftFilFmt    ValidSwft                                   CSW207A
     C                   EVAL      V_PBRECI = 'C'
     C/COPY WNCPYSRC,SDH00688
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_CUTYLC = DDACTN
     C                   EVAL      V_PBCHTP = DDACTN
     C                   EVAL      V_CUCUST = DDCUSN
     C                   MOVE      DDCUSN        V_PBCNUM
     C                   EVAL      V_CUCUSD = DDCUSN                                       BUG15052A
     C                   EVAL      V_CUBRCA = V_CUBRCD                                     BUG15052A

      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_CUFRNT = APFOTranID
     C                   EVAL      V_CUAFRT = APFOAsocID
     C                   EVAL      V_CUREPA = APRprLocn
     C                   EVAL      V_CUTMST = TimeStamp
     C                   IF        DDACTN = 'A' or
     C                             DDACTN = 'I'
     C                   EVAL      V_PBRECI = 'D'
     C                   ENDIF
     C                   EVAL      V_PBTMES = TimeStamp

     C                   EVAL      TranStatus = 'S'

      /COPY WNCPYSRC,SDCUSDC018
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************

     C     CallMsgHdl    BEGSR

      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors

     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax

     C                   IF        FldNameArr(Ix) <> *blanks

     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix

     C                   ENDDO

     C                   RESET                   ReturnCode

     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDCUSN
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ

     C                   ENDSR

      *****************************************************************
      /eject
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************

     C     DtaSubs       begsr

      ** Convert file fields to screen format
     C                   reset                   ReturnCode
     C                   CALLB     'SDCUSDCVT'
      * Return Code
     C                   PARM                    ReturnCode
      * Input parameters
      * Customer - file formats
     C                   PARM                    CustFilFmt
     C/COPY WNCPYSRC,SDH00689
     C                   PARM                    BrtxFilFmt
     C                   PARM                    PrivFilFmt
     C                   PARM                    CumiFilFmt                                   258286
     C                   PARM                    CuadFilFmt                                   258286
     C                   PARM                    SfeeFilFmt                                   258286
     C                   PARM                    ChecFilFmt                                   258286
     C                   PARM                    CusfFilFmt                                   258286
     C                   PARM                    RwanFilFmt                                   258286
     C                   PARM                    CufoFilFmt                                   258286
     C                   PARM                    CufnFilFmt                                   258286
     C                   PARM                    CupmFilFmt                                   258286
     C                   PARM                    TicdFilFmt                                   258286
     C                   PARM                    CueuFilFmt                                   258286
     C                   PARM                    CuibfFilFmt                                  258286
                                                                                              258286
     C                   PARM                    GCustFilFmt                                  CGP001
     C                   PARM                    SwftFilFmt                                   CSW207
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      *
      * Output parameters
      * Customer Details - screen formats
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCuSeco
     C                   PARM                    CurCuMT3X                                    CSW024
     C                   PARM                    CurCuMsrt
     C                   PARM                    CurCuBrTx
     C                   PARM                    CurCuPriv
     C                   PARM                    TranInCumi                                   258286
     C                   PARM                    TranInCuad                                   258286
     C                   PARM                    TranInACU3                                   CER059
     C                   PARM                    TranInACU4                                   CER059
     C                   PARM                    TranInSfee                                   258286
     C                   PARM                    TranInCufx                                   258286
     C                   PARM                    TranInCufd                                   258286
     C                   PARM                    TranInChec                                   258286
     C                   PARM                    TranInCusf                                   258286
     C                   PARM                    TranInRwan                                   258286
     C                   PARM                    TranInCufo                                   258286
     C                   PARM                    TranInCupm                                   258286
     C                   PARM                    TranInTicd                                   258286
     C                   PARM                    TranInCurx                                   258286
     C                   PARM                    CurCuSwft                                    CSW207
     C/COPY WNCPYSRC,SDH00690
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.

     C                   if        RepPrim = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInPrim    IncData        2000
      * Current Data
     C                   PARM      CurCuPrim     CurData        2000

     C                   MOVEL     IncDATA       TranInPrim

     C                   endif

     C                   if        RepSeco = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSeco    IncData
      * Current Data
     C                   PARM      CurCuSeco     CurData

     C                   MOVEL     IncDATA       TranInSeco

     C                   endif

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
     C                   PARM      TranInMT3X    IncData                                      CSW024
      * Current Data                                                                          CSW024
     C                   PARM      CurCuMT3X     CurData                                      CSW024
                                                                                              CSW024
     C                   MOVEL     IncDATA       TranInMT3X                                   CSW024
                                                                                              CSW024
     C                   endif                                                                CSW024
                                                                                              CSW024
     C                   if        RepMsrt = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInMsrt    IncData
      * Current Data
     C                   PARM      CurCuMsrt     CurData

     C                   MOVEL     IncDATA       TranInMsrt

     C                   endif

     C                   if        RepBrTx = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInBrTx    IncData
      * Current Data
     C                   PARM      CurCuBrTx     CurData

     C                   MOVEL     IncDATA       TranInBrTx

     C                   endif

     C                   if        RepPriv = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInPriv    IncData
      * Current Data
     C                   PARM      CurCuPriv     CurData

     C                   MOVEL     IncDATA       TranInPriv

     C                   endif
                                                                                             CSW207A
     C                   If        RepSWFT = 'Y'                                             CSW207A
                                                                                             CSW207A
     C                   Clear                   IncData                                     CSW207A
     C                   Clear                   CurData                                     CSW207A
     C                   RESET                   ReturnCode                                  CSW207A
     C                   CALLB     'APDTASUBS'                                               CSW207A
      * Return Code                                                                          CSW207A
     C                   PARM                    ReturnCode                                  CSW207A
      * Substitution character                                                               CSW207A
     C                   PARM                    GHSUBS                                      CSW207A
      * Incoming Data                                                                        CSW207A
     C                   PARM      TranInSwft    IncData                                     CSW207A
      * Current Data                                                                         CSW207A
     C                   PARM      CurCuSwft     CurData                                     CSW207A
                                                                                             CSW207A
     C                   MOVEL     IncDATA       TranInSwft                                  CSW207A
                                                                                             CSW207A
     C                   Endif                                                               CSW207A

     C                   endsr

      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,SDCUSDCC05
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL2                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012

     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005                      CAP004
     C                   PARM                    Trans5006                      CAP004
     C                   PARM                    Trans5007                                    CSW024
     C                   PARM                    Trans5008                                    CSW207
     C/COPY WNCPYSRC,SDCUSDCC06
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500                     CAP004
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
     C/COPY WNCPYSRC,SDCUSDCC03

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'SD'

      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
      *
      ** Access SAR details file to check if Base Rate Tax
      **  (S01383) is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *
      ** Access SAR details file to determine if Customer Deletion in COB
      ** feature (S01424) is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01424'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01424            1
     C                   ELSE
     C                   MOVEL     'N'           S01424
     C                   END
      *
      ** Access SAR details file to determine if CHIPS 2 is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01429'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01429            1
     C                   ELSE
     C                   MOVEL     'N'           S01429
     C                   END
      *
      ** Access SAR details file to determine if Private Banking
      ** securities enhancements is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01496            1
     C                   ELSE
     C                   MOVEL     'N'           S01496
     C                   END
      *
      ** Access SAR details file to determine if TOF/Midas
      ** Interface is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   END
      *
      ** Access SAR details file to determine if EMU UDC
      ** Changes is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU014'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU014            1
     C                   ELSE
     C                   MOVEL     'N'           CEU014
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
     C     @RTCD         IFEQ      *BLANK                                                     CSW024
     C                   MOVEL     'Y'           CSW024            1                          CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'N'           CSW024                                       CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtcd                                        CSC011
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
     C                   EVAL      DBASE = 001                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
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
                                                                                              CSD012
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
     C                   Z-ADD     3             DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'SDCUSDCTL'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Customer Details Authorisation is On set to Authorise                             CSD012
     C     CSD012        IFEQ      'Y'                                                        CSD012
     C     SVAL11        ANDEQ     'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012

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
     C                   EVAL      DBASE = 002                                                CGP001
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
     C                   EVAL      DBASE  = 3                                                 CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CGP001
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
     C                   EVAL      DBASE  = 4                                                 CFX001
     C                   EXSR      *PSSR                                                      CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C                   IF        PRTCD = *BLANKS                                            CFX001
     C                   EVAL      CFX001 = 'Y'                                               CFX001
     C                   ELSE                                                                 CFX001
     C                   EVAL      CFX001 = 'N'                                               CFX001
     C                   ENDIF                                                                CFX001
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APCUSDDTQ'

     C* Override SDCUSTLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C* Override SDCBRTLR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
     C* Override PTYHSTLR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN

     C* Override SDPBDSLR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
      * Override SDTICSLR                                                                    BUG3362
     C                   CALL      'QCMDEXC'                                                 BUG3362
     C                   PARM                    ##OX5                                       BUG3362
     C                   PARM                    MESLEN                                      BUG3362
      * Override SDCUX1LR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    ##OX6                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDCUX2LR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    ##OX7                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDFOX1LR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    ##OX8                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDPLCSLR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    ##OX9                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDFOCSLR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    #OX10                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDCRWALR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    #OX11                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDCHEQLR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    #OX12                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDCFCDLR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    #OX13                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDACUSLR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    #OX14                                       256351A
     C                   PARM                    MESLEN                                      256351A
      * Override SDCMRKLR                                                                    256351A
     C                   Z-ADD     50            MESLEN           15 5                       256351A
     C                   CALL      'QCMDEXC'                                                 256351A
     C                   PARM                    #OX15                                       256351A
     C                   PARM                    MESLEN                                      256351A

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUSDC019
      *                                                                                       CER001
      ** ULX004 - European Reporting as Feature                                               CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX004            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX004'                                          CER001
     C                   EVAL      DBASE  = 5                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - CSSF Statutory Reporting: Commissariat aux Bourses                          CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX008            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX008'                                          CER001
     C                   EVAL      DBASE  = 6                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX008                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX012 - Guarantees and Collateral Management enhancements                           CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX012            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX012'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX012'                                          CER001
     C                   EVAL      DBASE  = 7                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX012                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX032 - Pledges and Multiple Guarantors Management                                  CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX032            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX032'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX032'                                          CER001
     C                   EVAL      DBASE  = 8                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX032                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX609 - API for SD Customer Details                                                 CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX609            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX609'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
     C                   EVAL      DBASE  = 9                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX609                                       CER001
     C                   OPEN      SDVCULX2PD                                                 CER001
     C                   OPEN      SDICULX2PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - IBLC 2002                                                                   CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 10                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      SDVCULX1PD                                                 CER001
     C                   OPEN      SDICULX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access SAR details file to check Customer Extended details Default                   CER001
      **  (PB3610) is switched on                                                             CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'PB3610'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'PB3610'                                          CER001
     C                   EVAL      DBASE  = 11                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           PB3610            1                          CER001
     C                   OPEN      SDICEXL1                                                   CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           PB3610                                       CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,SDH00691
      ** Check if SWIFT 2007 is installed                                                    CSW207A
                                                                                             CSW207A
     C                   CALL      'SWIF2007'                                                CSW207A
     C                   PARM      *BLANKS       PRtCd                                       CSW207A
                                                                                             CSW207A
     C                   IF        PRtCd = 'CSW2007'                                         CSW207A
     C                   EVAL      CSW207 = 'Y'                                              CSW207A
     C                   ELSE                                                                CSW207A
     C                   EVAL      CSW207 = 'N'                                              CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
      *                                                                                       CER001
      ** ULX004 - Check if ULX004 in ON                                                     BUG13228
      *                                                                                     BUG13228
     C                   MOVEL     'N'           ULX004            1                        BUG13228
     C                   CALL      'AOSARDR0'                                               BUG13228
     C                   PARM      *BLANKS       @RTCD                                      BUG13228
     C                   PARM      '*VERIFY'     @OPTN                                      BUG13228
     C                   PARM      'ULX004'      @SARD                                      BUG13228
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG13228
      *                                                                                     BUG13228
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                BUG13228
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG13228
     C                   EVAL      DBKEY  = 'ULX004'                                        BUG13228
     C                   EVAL      DBASE  = 12                                              BUG13228
     C                   EXSR      *PSSR                                                    BUG13228
     C                   ENDIF                                                              BUG13228
      *                                                                                     BUG13228
     C     @RTCD         IFEQ      *BLANKS                                                  BUG13228
     C                   MOVEL     'Y'           ULX004                                     BUG13228
     C                   ENDIF                                                              BUG13228

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)
** ##OX2
OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)
** ##OX3
OVRDBF FILE(PTYHSTPR) TOFILE(PTYHSTPD) SHARE(*NO)
** ##OX4
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
** ##OX5                                                                                     BUG3362
OVRDBF FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)                                            BUG3362
** ##OX6                                                                                     256351A
OVRDBF FILE(SDCUX1LR) TOFILE(SDCUX1L0) SHARE(*NO)                                            256351A
** ##OX7                                                                                     256351A
OVRDBF FILE(SDCUX2LR) TOFILE(SDCUX2L0) SHARE(*NO)                                            256351A
** ##OX8                                                                                     256351A
OVRDBF FILE(SDFOX1LR) TOFILE(SDFOX1L0) SHARE(*NO)                                            256351A
** ##OX9                                                                                     256351A
OVRDBF FILE(SDPLCSLR) TOFILE(SDPLCSL0) SHARE(*NO)                                            256351A
** #OX10                                                                                     256351A
OVRDBF FILE(SDFOCSLR) TOFILE(SDFOCSL1) SHARE(*NO)                                            256351A
** #OX11                                                                                     256351A
OVRDBF FILE(SDCRWALR) TOFILE(SDCRWAL1) SHARE(*NO)                                            256351A
** #OX12                                                                                     256351A
OVRDBF FILE(SDCHEQLR) TOFILE(SDCHEQL1) SHARE(*NO)                                            256351A
** #OX13                                                                                     256351A
OVRDBF FILE(SDCFCDLR) TOFILE(SDCFCDL1) SHARE(*NO)                                            256351A
** #OX14                                                                                     256351A
OVRDBF FILE(SDACUSLR) TOFILE(SDACUSL1) SHARE(*NO)                                            256351A
** #OX15                                                                                     256351A
OVRDBF FILE(SDCMRKLR) TOFILE(SDCMRKL1) SHARE(*NO)                                            256351A
** CMD
OVRDBF FILE(SDAULGL2) TOFILE(SDAULGL2) SHARE(*NO)
