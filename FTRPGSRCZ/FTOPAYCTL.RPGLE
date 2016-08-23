     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments interface controller')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYCTL - Outgoing Payments Interface Controller           *
      *                                                               *
      *  Function: This Program Validates FT Outgoing payments for    *
      *            input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the payment fields                    *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise) call a separate function to   *
      *              process this payment and bypass the rest of the  *
      *              validation                                       *
      *            - For D (=Delete) call a separate function to      *
      *              process this payment and bypass the rest of the  *
      *              validation                                       *
      *            For all action codes, the decision as to           *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT151             Date 21Mar14               *
      *  Prev Amend No. 258944             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE067             Date 05Oct10               *
      *                 262659             Date 13Nov09               *
      *                 BUG26775           Date 27Nov09               *
      *                 262867             Date 24Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26548           Date 23Oct09               *
      *                 BUG26489           Date 18Oct09               *
      *                 260433             Date 28May09               *
      *                 CSW209             Date 01Apr09               *
      *                 257361             Date 10Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257897             Date 26Nov08               *
      *                 256330             Date 01Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      *                 248095A            Date 26Jun07               *
      *                 248920             Date 05Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242711             Date 17Oct06               *
      *                 GBO009             Date 14Aug06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 222731             Date 06Jun06               *
      *                 CSD027A            Date 09May06               *
      *                 CER001             Date 25Apr05               *
      *                 CFT118             Date 02Sep04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 18Jul03               *
      *                 217337             Date 19May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 200149             Date 15Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 197220             Date 11Sep01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      *                 190845             Date 21Mar01               *
      *                 CPB002             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 16Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP013             Date 22Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP011             Date 07Sep99               *
      *                 CAP031  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  258944 - APISERVER API FTOPAY: correct positions; fix use of *
      *           APNARV in CFT148 which adds one to positions        *
      *           Amended hook: CFT148_001 (Recompile)                *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_001, CFT148_002, CFT148_003     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00051                                 *
      *             WNCPYSRC,FTH00099                                 *
      *             WNCPYSRC,FTH00100                                 *
      *             WNCPYSRC,FTH00101                                 *
      *             WNCPYSRC,FTH00052                                 *
      *             WNCPYSRC,FTH00092                                 *
      *             WNCPYSRC,FTH00053                                 *
      *             WNCPYSRC,FTH00054                                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  262659 - Include MEMSG to the message files used by Funds    *
      *           transfer transactions inserted via API.             *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  262867 - Set MT103 flag to 'Y'                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG26548 - Passed parm does not match entry parm for FTVXVXV *
      *  BUG26489 - Missing Codes SWIFT 2009                          *
      *  260433 - Blank out Notify Delivery Currency/Amount if CEU006 *
      *           is off.                                             *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257361 - Pass SDFTFR to FTOPAV1VL in case Warning message    *
      *           ('Network TELEX must be defined in Standing data')  *
      *           which appears for Settlement type '02' (cheques)    *
      *  257897 - Pass transaction reference on reply.                *
      *           Apply client fix 250881                             *
      *  256330 - Recompiled due to change in APDUMP.                 *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  248095A- Recompiled to ensure APISERVER job doesn't fail.    *
      *           Applied fix 245310D.                                *
      *  248920 - FT OPAY API buffer is divided into file format      *
      *           lengths with a maximum of 500 wh. is too short for  *
      *           parms 1 and 7 (FTOPY1PD + FTOPY6PD)                 *
      *  242711 - Apply Fix BUG9071 to prevent error message during   *
      *           API transaction from third party.                   *
      *  GBO009 - Funds Transfer Outgoing Payment Reference           *
      *           Added core hooks: FTOPAYCC04, FTOPAYCC05,           *
      *                             FTOPAYCC06.                       *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  222731 - Receiver's charges remitted details defaulted from  *
      *           previous transaction. Initialize @RCRM properly.    *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build).  *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts Printing - Upgrade to MidasPlus       *
      *           Core hooks amended:FTOPAYCD01                       *
      *                              FTOPAYCC09                       *
      *                              FTOPAYCC10                       *
      *  CFT116 - Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Added core hooks:FTOPAYCC09,FTOPAYCC10,FTOPAYCD01   *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  CAP084 - MidasPlus Changes                                   *
      *  217337 - Chaps code is taken from the previous transaction.  *
      *           Fix is to initialize the field @CHAP.               *
      *  200149 - Program dumped on FTVCHPY.                          *
      *  CSC011 - 24x7 Midas Availability                             *
      *  197220 - DB error because of DS Val@Fields not addressable,  *
      *           Pointer not set for location. Fix 187056 introduced *
      *           new parameter in FTOPAY3DT but parameter list of    *
      *           this module was not amended.                        *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  190845 - Add extra fields for Message Unique Reference and   *
      *           Part Number                                         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompile - BIC Database Plus Integration           *
      *  CFT004 - IBAN - International Bank Account Number            *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FFTVOPAYPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
                                                                                CFT014
     FFTVOPY2PD UF A E             DISK    INFSR(*pssr)                         CFT014
     F                                     COMMIT                               CFT014
 
     FFTIOPAYPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FFTVOPAYL0 IF   E           K DISK    RENAME(FTVOPAYD0:FTVOPAYCHK)
     F                                     INFSR(*pssr)                         CAP013
     FFTVOPAYL1 IF   E           K DISK    RENAME(FTVOPAYD0:FTVOPAYCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
     F/COPY WNCPYSRC,FTH00175
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTOPAYC019
     FFTVOPLX1PDUF A E             DISK    USROPN                                             CER001
      *                                                                                       CER001
      **  Midas IBLC 2002 FT OPAY - Valid File                                                CER001
      *                                                                                       CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FFTIOPLX1PDUF A E             DISK    USROPN                                             CER001
      *                                                                                       CER001
      **  Midas IBLC 2002 FT OPAY - Invalid File                                              CER001
      *                                                                                       CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FSDCUX1L0  IF   E           K DISK    USROPN                                             CER001
      *                                                                                       CER030
      ** Network Transaction Identifier File                                                  CER030
      *                                                                                       CER030
     FSDNTTIL1  IF   E           K DISK    INFSR(*PSSR)                                       CER030
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
     D/COPY WNCPYSRC,FTOPAYCD01
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
     D/COPY WNCPYSRC,FTH00329
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D TranInThrB    E DS                  EXTNAME(FTOPY5PD)                    CFT014
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014
     D TranInMarg    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      *                                                                                       CFT039
      ** FT OPAY API Ordering Bank Details                                                    CFT039
     D TranInfoFlds  E DS                  EXTNAME(FTOPIFPD)                                  CFT039
      *                                                                                       CFT039
      ** Cover Message                                                                        CSW209
     D TranInCVA     E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D TranInCVC     E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)                                 CSW209
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)                                 CSW209
 
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
     D QQCDROX       E                     EXTFLD(QQCDRO)                                     CGL029
      * Valid Payments layout
                                                                                CFT014
     D ValidPmntB    E DS                  EXTNAME(FTVOPY2PD)                   CFT014
      ** Valid Payments layout B                                                CFT014
 
     D/COPY WNCPYSRC,FTH00176
     D PmntFilFmt    E DS                  EXTNAME(OTPAYDD)
      * (Current) Transaction in File Format
                                                                                CFT014
     D PmntFilFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
      ** (Current) Transaction in File Format Extension                         CFT014
 
     D CurTrPrim     E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 1st screen (level 1)
                                                                                CFT014
     D CurTrPrm2     E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D                                     PREFIX(@)                            CFT014
      ** (Current) Transaction in Screen Format - 1st screen (level 2)          CFT014
 
     D CurTrSeco     E DS                  EXTNAME(FTOPY2PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 2nd screen (level 2)
 
     D CurTrThrd     E DS                  EXTNAME(FTOPY3PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 2nd screen (level 2)
 
     D CurTrFour     E DS                  EXTNAME(FTOPY4PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 3rd screen (level 2)
                                                                                CFT014
     D CurTr5th      E DS                  EXTNAME(FTOPY5PD)                    CFT014
     D                                     PREFIX(@)                            CFT014
      ** (Current) Transaction in Screen Format - 3rd screen (level 2)          CFT014
                                                                                CFT014
     D CurTr6th      E DS                  EXTNAME(FTOPY6PD)                    CFT014
     D                                     PREFIX(@)                            CFT014
      ** (Current) Transaction in Screen Format - 4th screen (level 2)          CFT014
                                                                                CFT014
     D CurTr7th      E DS                  EXTNAME(FTOPY7PD)                    CFT014
     D                                     PREFIX(@)                            CFT014
     D CurTrAth      E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@)                                          CSW209
     D CurTrCth      E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@)                                          CSW209
      ** (Current) Transaction in Screen Format - Margin Info                   CFT014
                                                                                CFT014
     D OKFlag1DS     E DS                  EXTNAME(FTEOPY1PD)                   CFT014
      ** Flags to indicate wheter transaction fields are valid for screen 1     CFT014
      ** (Screen 1 Level 1)                                                     CFT014
                                                                                CFT014
     D OKFlag2DS     E DS                  EXTNAME(FTEOPY2PD)                   CFT014
      ** Flags to indicate wheter transaction fields are valid for screen 2     CFT014
      ** (Screen 1 Level 2)                                                     CFT014
                                                                                CFT014
     D OKFlag3DS     E DS                  EXTNAME(FTEOPY3PD)                   CFT014
      ** Flags to indicate wheter transaction fields are valid for screen 3     CFT014
      ** (Screen 2 Level 2)                                                     CFT014
                                                                                CFT014
     D OKFlag4DS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014
      ** Flags to indicate wheter transaction fields are valid for screen 4     CFT014
      ** (Charges and Commission Screen 3 Level 2)                              CFT014
                                                                                CFT014
     D OKFlag5DS     E DS                  EXTNAME(FTEOPY5PD)                   CFT014
      ** Flags to indicate wheter transaction fields are valid for screen 5     CFT014
      ** (Margin Information Screen 4 Level 2)                                  CFT014
 
     D/COPY WNCPYSRC,FTH00177
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
     D/COPY OFCPYSRCZ,CFT148_001                                                              CFT148
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(FTOPRXPD)                                  CER001
      * FT Outgoing Payments Extra Data - File (D/B) format
      *
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @NotDelAmt    E                     EXTFLD(@SNDAM)
     D @PayDelAmt    E                     EXTFLD(@SPDAM)
     D @PayAmount    E                     EXTFLD(@SPYAM)
     D @SettleAmt    E                     EXTFLD(@SSMAM)
 
     D/COPY WNCPYSRC,FTH00178
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D*OTPAYD**      E DS                  EXTNAME(OTPAYDA)                                   CFT151
      ***** DATA AREA FOR ORDINARY PAYMENT REF NUMBERING                                      CFT151
      ** DS for next Outgoing Payment Reference Number                                        CFT151
     D OTPAYD          DS             4                                                       CFT151
     D  WOTSQ                  1      4  0                                                    CFT151
 
     D RGPAYD        E DS                  EXTNAME(RGPAYDA)
     D*     DATA AREA FOR REGULAR PAYMENT REF NUMBERING
     D*
                                                                                CFT009
      ** Valid Outgoing Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
     D/COPY WNCPYSRC,FTH00179
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
     D  WRATDIS               44     48  4
                                                                                CAP011
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011
                                                                                              262867
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  262867
      ** External DS for Branch details                                                       262867
                                                                                              262867
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  262867
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     262867
      ** External DS Customer Details                                                         262867
                                                                                              262867
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  262867
      * External DS for Nostro details                                                        262867
                                                                                              CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
     D  WPRDTE                 5      9  0                                                    CSC011
                                                                                              CSC011
      ** SD Status DataArea Layout                                                            CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
 
     D FTOPAYUPC       DS             1    DTAARA(FTOPAYUPC)
 
      *  User / Branch data area
     D ZMUSER          DS            17
     D  WUSRID                 1     10                                                       CAP084
     D  WDFBR                 11     13
     D  WDPPT                 14     16
 
      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13
 
     D                 DS
     D*     REDEFINE IPREF FOR INSERTS
     D  IPREF                  1     15
     D  P                      1      1    INZ('P')
     D  RUNDYY                 2      3  0
     D  RUNDMD                 4      7  0
     D**PRNUM                  8     11  0                                                    CFT151
     D  PRNUM                  8     11                                                       CFT151
     D  PmntType              12     13
     D  StmtType              14     15  0
     D/COPY WNCPYSRC,FTH00051
      *                                                                                       CER001
     D PDATA           DS          1024                                                       CER001
     D  #1FLD1#                1      6  0                                                    CER001
     D  PREF1                  7     21                                                       CER001
     D  #1FOTR                22     41                                                       CER001
     D  #1TMST                42     67Z                                                      CER001
     D  #1ORCT                68     68                                                       CER001
     D  #1ORBK                69     80                                                       CER001
     D  #1ORC1                81    115                                                       CER001
     D  #1SMCY               116    118                                                       CER001
     D  #1ORBT               119    119                                                       CER001
     D  #1SMAM               120    132P 0                                                    CER001
     D  #1PCCY               133    135                                                       CER001
     D  #1SNCT               136    136                                                       CER001
     D  #1SNCO               137    146                                                       CER001
     D  #1DSTT               147    147                                                       CER001
     D  #1DST1               148    182                                                       CER001
     D*
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
     D***Trans5002       S            500A                                                   CSF011A
     D***Trans5003       S            500A                                                   CSF011A
     D Trans5002       S           1000A                                                     CSF011A
     D Trans5003       S           1000A                                                     CSF011A
     D Trans5004       S            500A
     D Trans5005       S            500A                                        CFT014
     D Trans5006       S            500A                                        CFT014
     D Trans5007       S            500A                                        CFT014
     D Trans5008       S            500A                                        CFT014
     D Trans5009A      S           1000A                                                      CSW209
     D Trans5009B      S           1000A                                                      CSW209
      *                                                                                       CER030
     D Trans5009       S            500A                                                      CER030
     D Trans5010       S            500A                                                      CER030
     D TRANS5011       S            500A                                                      CFT039
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ***Flags*to*indicate*whether*transaction*fields*are*valid********         CFT014
     D*OKFlag1DS*      DS                                                       CFT014
     D**SActionOK                     1A   INZ('Y')                             CFT014
     D**SPrefOK**                     1A   INZ('Y')                             CFT014
     D**SBrCAOK**                     1A   INZ('Y')                             CFT014
     D**SOrBrOK**                     1A   INZ('Y')                             CFT014
     D**SPyTpOK**                     1A   INZ('Y')                             CFT014
     D**SPySTOK**                     1A   INZ('Y')                             CFT014
     D**SStTpOK**                     1A   INZ('Y')                             CFT014
     D**SSwPCOK**                     1A   INZ('Y')                             CFT014
     D**SDst1OK**                     1A   INZ('Y')                             CFT014
     D**SDst2OK**                     1A   INZ('Y')                             CFT014
     D**SDst3OK**                     1A   INZ('Y')                             CFT014
     D**SDst4OK**                     1A   INZ('Y')                             CFT014
     D**SOdMTOK**                     1A   INZ('Y')                             CFT014
     D**SOrC1OK**                     1A   INZ('Y')                             CFT014
     D**SOrC2OK**                     1A   INZ('Y')                             CFT014
     D**SOrC3OK**                     1A   INZ('Y')                             CFT014
     D**SOrC4OK**                     1A   INZ('Y')                             CFT014
     D**SOrBkOK**                     1A   INZ('Y')                             CFT014
     D**SOrBBOK**                     1A   INZ('Y')                             CFT014
     D**SSnCoOK**                     1A   INZ('Y')                             CFT014
     D**SSnMTOK**                     1A   INZ('Y')                             CFT014
     D**SNDCyOK**                     1A   INZ('Y')                             CFT014
     D**SNDAmOK**                     1A   INZ('Y')                             CFT014
     D**SSmCyOK**                     1A   INZ('Y')                             CFT014
     D**SSmAmOK**                     1A   INZ('Y')                             CFT014
     D**SPyDtOK**                     1A   INZ('Y')                             CFT014
     D**SPCcyOK**                     1A   INZ('Y')                             CFT014
     D**SPyAmOK**                     1A   INZ('Y')                             CFT014
     D**SPyVDOK**                     1A   INZ('Y')                             CFT014
     D**SPDCyOK**                     1A   INZ('Y')                             CFT014
     D**SPDAmOK**                     1A   INZ('Y')                             CFT014
     D**SRateOK**                     1A   INZ('Y')                             CFT014
     D**SOvrdOK**                     1A   INZ('Y')                             CFT014
     D**SAdDcOK**                     1A   INZ('Y')                             CFT014
     D**SBokCOK**                     1A   INZ('Y')                             CFT014
     D**SPrfCOK**                     1A   INZ('Y')                             CFT014
     D**SRPayOK**                     1A   INZ('Y')                             CFT014
     D**SPayFOK**                     1A   INZ('Y')                             CFT014
     D**SDyiMOK**                     1A   INZ('Y')                             CFT014
     D**SNDatOK**                     1A   INZ('Y')                             CFT014
     D**SFinDOK**                     1A   INZ('Y')                             CFT014
      ***********                                                               CFT014
     D*OKFlag2DS*      DS                                                       CFT014
      ***Screen*2*flags************************************************         CFT014
     D**SActn2OK*                     1A   INZ('Y')                             CFT014
     D**SPref2OK*                     1A   INZ('Y')                             CFT014
     D**STrCTOK**                     1A   INZ('Y')                             CFT014
     D**SCDrOOK**                     1A   INZ('Y')                             CFT014
     D**SCDBrOK**                     1A   INZ('Y')                             CFT014
     D**SRCo1OK**                     1A   INZ('Y')                             CFT014
     D**SRCo2OK**                     1A   INZ('Y')                             CFT014
     D**SRCo3OK**                     1A   INZ('Y')                             CFT014
     D**SRCo4OK**                     1A   INZ('Y')                             CFT014
     D**SRCo5OK**                     1A   INZ('Y')                             CFT014
     D**SAcB1OK**                     1A   INZ('Y')                             CFT014
     D**SAcB2OK**                     1A   INZ('Y')                             CFT014
     D**SAcB3OK**                     1A   INZ('Y')                             CFT014
     D**SAcB4OK**                     1A   INZ('Y')                             CFT014
     D**SAcB5OK**                     1A   INZ('Y')                             CFT014
     D**SBnC1OK**                     1A   INZ('Y')                             CFT014
     D**SBnC2OK**                     1A   INZ('Y')                             CFT014
     D**SBnC3OK**                     1A   INZ('Y')                             CFT014
     D**SBnC4OK**                     1A   INZ('Y')                             CFT014
     D**SBnC5OK**                     1A   INZ('Y')                             CFT014
     D**SDtP1OK**                     1A   INZ('Y')                             CFT014
     D**SDtP2OK**                     1A   INZ('Y')                             CFT014
     D**SDtP3OK**                     1A   INZ('Y')                             CFT014
     D**SDtP4OK**                     1A   INZ('Y')                             CFT014
     D**SBBI1OK**                     1A   INZ('Y')                             CFT014
     D**SBBI2OK**                     1A   INZ('Y')                             CFT014
     D**SBBI3OK**                     1A   INZ('Y')                             CFT014
     D**SBBI4OK**                     1A   INZ('Y')                             CFT014
     D**SBBI5OK**                     1A   INZ('Y')                             CFT014
     D**SBBI6OK**                     1A   INZ('Y')                             CFT014
      ***********                                                               CFT014
     D*OKFlag3DS*      DS                                                       CFT014
      ***Screen*3*flags************************************************         CFT014
     D**SActn3OK*                     1A   INZ('Y')                             CFT014
     D**SPref3OK*                     1A   INZ('Y')                             CFT014
     D**SInB1OK**                     1A   INZ('Y')                             CFT014
     D**SInB2OK**                     1A   INZ('Y')                             CFT014
     D**SInB3OK**                     1A   INZ('Y')                             CFT014
     D**SInB4OK**                     1A   INZ('Y')                             CFT014
     D**SInB5OK**                     1A   INZ('Y')                             CFT014
     D**SDnbcOK**                     1A   INZ('Y')                             CFT014
     D**SDtChOK**                     1A   INZ('Y')                             CFT014
     D**STrCdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT1OK**                     1A   INZ('Y')                             CFT014
     D**SChCdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT7OK**                     1A   INZ('Y')                             CFT014
     D**STxCdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT2OK**                     1A   INZ('Y')                             CFT014
     D**SCqCdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT3OK**                     1A   INZ('Y')                             CFT014
     D**SCstdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT4OK**                     1A   INZ('Y')                             CFT014
     D**SSpCdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT5OK**                     1A   INZ('Y')                             CFT014
     D**SMsCdOK**                     1A   INZ('Y')                             CFT014
     D**SVAT6OK**                     1A   INZ('Y')                             CFT014
     D**SRlPROK**                     1A   INZ('Y')                             CFT014
     D**SCHAPOK**                     1A   INZ('Y')                             CFT014
     D**SFXMPOK**                     1A   INZ('Y')                             CFT014
     D**SMBSIOK**                     1A   INZ('Y')                             CFT014
     D**SMSIGOK**                     1A   INZ('Y')                             CFT014
      ***Flag(s)*to indicate if combinations of transaction fields are valid    CFT014
     D**DDDltStpOK                    1A   INZ('Y')                             CFT014
 
      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
 
      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)
 
      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0
 
      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             12A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             12A
 
     D Object          S             10A   INZ('FTOPAYUPC')
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
                                                                                CAP011
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in                  CAP011
      ** each of the various parts the transaction                              CAP011
     D RepPrim         S              1A   inz('N')                             CAP011
     D RepSecA         S              1A   inz('N')                             CAP011
     D RepSecB         S              1A   inz('N')                             CAP011
     D RepThir         S              1A   inz('N')                             CAP011
     D RepPrmB         S              1A   inz('N')                             CFT014
     D RepThrB         S              1A   inz('N')                             CFT014
     D RepFour         S              1A   inz('N')                             CFT014
     D RepMarg         S              1A   inz('N')                             CFT014
     D RepFiveA        S              1A   inz('N')                                           CSW209
     D RepFiveB        S              1A   inz('N')                                           CSW209
     D CSW209          S              1A                                                      CSW209
     D CSW203          S              1A                                                      262867
 
      * Msg Unique Reference                                                                  190845
     D SHMSGR          S              8  0                                                    190845
     D                                                                                        190845
      * Part Number                                                                           190845
     D SHPART          S              3  0                                                    190845
      *                                                                                       190845
                                                                                              200149
     D PReDspChg       S              1A                                                      200149
     D PCDROCHG        S              1A                                                      200149
                                                                                              CSC011
      ** Access Object parameter fields                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** Transaction Detail Field                                                             CSC011
     D TRANSDTL        S           5800A                                                      CSC011
                                                                                              CSC011
      ** Transaction Reference                                                                CSC011
     D PREFERENCE      S             18A                                                      CSC011
     D PAREFERENCE     S             18A                                                      CSC011
                                                                                              CSC011
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
     D KTtcd           S             10A                                                      CER030
      **                                                                                      CSC022
     D/COPY WNCPYSRC,FTH00180
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTOPAYC020
      *                                                                                       CER030
      ** DS defined for Extended narrative feature                                            CER030
      *                                                                                       CER030
     D TranInMargA   E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
     D TranInMargB   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
      *                                                                                       CER030
     D CurTr7Ath     E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
     D CurTr7Bth     E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER001
      ** Valid Extended Outgoing payments in File Format                                      CER001
      *                                                                                       CER001
     D ValidFilExtL  E DS                  EXTNAME(FTVOPLX1PD)                                CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExtL   E DS                  EXTNAME(FTEOPLX1PD)                                CER001
      *                                                                                       CER001
      ** Define parameters for call pgm                                                       CER001
      *                                                                                       CER001
     D @CURR           S              3A                                                      CER001
     D @TYPE           S              1A                                                      CER001
     D @LINE           S             35                                                       CER001
     D @OPCL           S              1  0                                                    CER001
     D @ACCD           S             10A                                                      CER001
     D @CUST           S              6A                                                      CER001
     D @FOUND          S              1A                                                      CER001
     D WWCUTY          S              2A                                                      CER001
     D ULX608          S              1A   INZ('N')                                           CER001
     D ULX043          S              1A   INZ('N')                                           CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FTOPAYC001
 
      *                                                                                       217337
      ** Initialize the field @CHAP                                                           217337
      *                                                                                       217337
     C                   CLEAR                   @CHAP                                        217337
                                                                                              217337
      ** Initialize field @RCRM                                                               222731
                                                                                              222731
     C                   CLEAR                   @RCRM                                        222731
      *                                                                                       222731
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * appropriate (externally described) data structure.
     C****************** MOVEL     Trans5001     TranInPrim                                   248920
     C***********        MOVEL     Trans5002     TranInSecA                     CFT014
     C***********        MOVEL     Trans5003     TranInSecB                     CFT014
     C***********        MOVEL     Trans5004     TranInThir                     CFT014
     C***********        MOVEL     Trans5002     TranInPrmB                     CFT014        248920
     C***********        MOVEL     Trans5003     TranInSecA                     CFT014        248920
     C***********        MOVEL     Trans5004     TranInSecB                     CFT014        248920
     C****************** MOVEL     Trans5005     TranInThir                     CFT014        248920
     C****************** MOVEL     Trans5006     TranInThrB                     CFT014        248920
     C****************** MOVEL     Trans5007     TranInFour                     CFT014        248920
     C****************** MOVEL     Trans5008     TranInMarg                     CFT014        248920
     C                   MOVEL     Trans5001FT   TranInPrim                                   248920
     C                   MOVEL     Trans5001A    TranInPrmB                                   248920
     C                   MOVEL     Trans5002     TranInSecA                                   248920
     C                   MOVEL     Trans5003     TranInSecB                                   248920
     C                   MOVEL     Trans5004     TranInThir                                   248920
     C                   MOVEL     Trans5005     TranInThrB                                   248920
     C                   MOVEL     Trans5006FT   TranInFour                                   248920
     C                   MOVEL     Trans5007     TranInMarg                                   248920
     C                   MOVEL     Trans5011     TranInfoFlds                                 CFT039
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   IF        CSW209 = 'Y'                                             BUG26489
     C                   MOVEL     Trans5009A    TranInCVA                                  BUG26489
     C                   MOVEL     Trans5009B    TranInCVC                                  BUG26489
     C                   ENDIF                                                              BUG26489
      ** Blank out Notify Delivery Currency/Amount if CEU006 is off                           260433
     C     @CEU006       IFEQ      'N'                                                        260433
     C                   EVAL      SNDCY = *BLANKS                                            260433
     C                   EVAL      SNDAM = *BLANKS                                            260433
     C                   ENDIF                                                                260433
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,FTOPAYC002
 
      *  Check if valid transaction exists for Front Office ID
 
     C                   EXSR      ChkValTran
      *
      *  If valid transaction does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
      *  Check if valid Payment exists for Midas Payment Reference              CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiFT                                   CAP013
      *                                                                         CAP013
      *  If valid Account does exist (even after delay), fail this input        CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
     C                                                                          CAP013
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid transaction file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,FTOPAYC003
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,FTOPAYC004
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN      SACTION = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,FTOPAYC005
      /COPY WNCPYSRC,FTOPAYC006
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,FTOPAYC007
      /COPY WNCPYSRC,FTOPAYC008
 
     C                   WHEN      SACTION = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,FTOPAYC009
 
      * Check for the existence of the replacement character; if this is        CAP011
      * used, only the changed data has been sent, and all occurrences of       CAP011
      * the replacement character must be replaced with the corresponding       CAP011
      * character from the original transaction.                                CAP011
     C                   if        GHSUBS <> *blank                             CAP011
                                                                                CAP011
     C     GHSUBS        scan      TranInPrim                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepPrim = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      TranInSecA                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepSecA = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      TranInSecB                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepSecB = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      TranInThir                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepThir = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CFT014
     C     GHSUBS        scan      TranInPrmB                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepPrmB = 'Y'                                CFT014
     C                   endif                                                  CFT014
                                                                                CFT014
     C     GHSUBS        scan      TranInThrB                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepThrB = 'Y'                                CFT014
     C                   endif                                                  CFT014
                                                                                CFT014
     C     GHSUBS        scan      TranInFour                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepFour = 'Y'                                CFT014
     C                   endif                                                  CFT014
                                                                                CFT014
     C     GHSUBS        scan      TranInMarg                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepMarg = 'Y'                                CFT014
     C                   endif                                                  CFT014
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C     GHSUBS        SCAN      TranInCVA                              99                  CSW209
      *                                                                                       CSW209
     C                   IF        *IN99                                                      CSW209
     C                   EVAL      RepFiveA = 'Y'                                             CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C     GHSUBS        SCAN      TranInCVC                              99                  CSW209
      *                                                                                       CSW209
     C                   IF        *IN99                                                      CSW209
     C                   EVAL      RepFiveB = 'Y'                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                CAP011
      ** If any of the flags set above is true, do the data                     CAP011
      ** substution subroutine.                                                 CAP011
     C                   if        (RepPrim = 'Y' OR RepSecA = 'Y' OR           CAP011
     C***********                   RepSecB = 'Y' OR RepThir = 'Y')             CAP011 CFT014
     C                              RepSecB = 'Y' OR RepThir = 'Y' OR           CFT014
     C                              RepPrmB = 'Y' OR RepThrB = 'Y' OR           CFT014
     C**********                    RepFour = 'Y' OR RepMarg = 'Y')                    CFT014 CSW209
     C                              RepFour = 'Y' OR RepMarg = 'Y' OR                         CSW209
     C                              RepFiveA = 'Y' AND CSW209 = 'Y' OR                        CSW209
     C                              RepFiveB = 'Y' AND CSW209 = 'Y')                          CSW209
     C                   EXSR      DtaSubs                                      CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
      **                 (End of "if GHSUBS <> *blank")                         CAP011
                                                                                CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,FTOPAYC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,FTOPAYC011
      /COPY WNCPYSRC,FTOPAYC012
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,FTOPAYC013
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,FTOPAYC014
 
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
      /COPY WNCPYSRC,FTOPAYC015
      *                                                                                       CER001
      ** ULX608 - API Luxembourg - Function FTOPAY                                            CER001
      *                                                                                       CER001
     C     ULX608        IFEQ      'Y'                                                        CER001
     C     ULX043        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExtL                                  CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C     SACTION       IFEQ      'I'                                                        CER001
     C     Idx           ANDEQ     0                                                          CER001
     C     SACTION       ORNE      'I'                                                        CER001
      *                                                                                       CER001
      ** Setup parameters PTYPE and PLINE to call BL0296                                      CER001
      ** with FTVOPAYPD valid file                                                            CER001
      *                                                                                       CER001
     C     OTORCT        IFEQ      'A'                                                        CER001
     C                   MOVE      OTORBT        @TYPE                                        CER001
     C                   MOVEL     OTORBK        @LINE                                        CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      OTORCT        @TYPE                                        CER001
     C                   MOVE      OTORC1        @LINE                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'IL0421'                                                   CER001
      * Input                                                                                 CER001
     C                   PARM      OTSMCY        @CURR                                        CER001
     C                   PARM                    @TYPE                                        CER001
     C                   PARM                    @LINE                                        CER001
     C                   PARM      0             @OPCL                                        CER001
      * Output                                                                                CER001
     C                   PARM      *BLANKS       @ACCD                                        CER001
     C                   PARM      *BLANKS       @CUST                                        CER001
     C                   PARM                    @FOUND                                       CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WWCUTY                                       CER001
      *                                                                                       CER001
     C     @FOUND        IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
     C     @CUST         CHAIN     SDCUX1L0                           99                      CER001
     C     *IN99         IFEQ      '1'                                                        CER001
     C                   MOVEL     'SDCUX1L0'    DBFILE                                       CER001
     C                   MOVEL     '902'         DBASE                                        CER001
     C                   MOVEL     *BLANKS       DBKEY                                        CER001
     C                   MOVEL     @CUST         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      CUTYPE        WWCUTY                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     SPREF         PREF1                                        CER001
     C                   MOVEL     SFOTRANID     #1FOTR                                       CER001
     C                   MOVEL     STMESTMP      #1TMST                                       CER001
     C                   MOVEL     @ORCT         #1ORCT                                       CER001
     C                   MOVEL     @ORBT         #1ORBT                                       CER001
     C                   MOVEL     SORBK         #1ORBK                                       CER001
     C                   MOVEL     SORC1         #1ORC1                                       CER001
     C                   MOVEL     SSMCY         #1SMCY                                       CER001
     C                   Z-ADD     @SMAM         #1SMAM                                       CER001
     C                   MOVEL     SPCCY         #1PCCY                                       CER001
     C                   MOVEL     @SNCT         #1SNCT                                       CER001
     C                   MOVEL     SSNCO         #1SNCO                                       CER001
     C                   MOVEL     @DSTT         #1DSTT                                       CER001
     C                   MOVEL     SDST1         #1DST1                                       CER001
      *                                                                                       CER001
     C                   CALLB     'FTOPAY8VL'                                                CER001
     C                   PARM                    SACTION                                      CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    RegData                                      CER001
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
     C                   PARM                    WWCUTY                                       CER001
     C                   PARM                    @CUST                                        CER001
     C                   PARM                    ValidPmnt                                    CER001
      *                                                                                       CER001
      ** set up the Payment Reference                                                         CER001
      *                                                                                       CER001
     C     SACTION       IFEQ      'I'                                                        CER001
     C     Idx           ANDEQ     0                                                          CER001
     C                   EXSR      SETUPPYREF                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      SPREF         PREF1                                        CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Call pgm once more just to close files                                               CER001
      *                                                                                       CER001
     C                   CALL      'IL0421'                                                   CER001
      * Input                                                                                 CER001
     C                   PARM                    @CURR                                        CER001
     C                   PARM                    @TYPE                                        CER001
     C                   PARM                    @LINE                                        CER001
     C                   PARM      9             @OPCL                                        CER001
      * Output                                                                                CER001
     C                   PARM                    @ACCD                                        CER001
     C                   PARM                    @CUST                                        CER001
     C                   PARM                    @FOUND                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   EVAL      #LLXOPPREF = SPREF                                         CER001
     C                   EVAL      #LLXOPFOTR = APFOTranID                                    CER001
     C                   EVAL      #LLXOPTMES = TimeStamp                                     CER001
     C                   WRITE     FTVOPLXDL                                                  CER001
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
     C                   EVAL      #LLXORTY = LLLXORTY                                        CER001
     C                   EVAL      #LLXBETY = LLLXBETY                                        CER001
     C                   EVAL      #LLXOPCO = LLLXOPCO                                        CER001
     C                   EVAL      #LLXCOCO = LLLXCOCO                                        CER001
     C                   EVAL      #LLXIDCO = LLLXIDCO                                        CER001
     C                   EVAL      #LLXIDEN = LLLXIDEN                                        CER001
     C                   WRITE     FTIOPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,FTOPAYC016
 
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
      *  Check if any messages are already on the data queue
      *  No need to send duplicate prompt messages
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00315
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FTOPAYC021
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValTran - Routine to check if valid transaction exists for *
      *    Front Office ID                                            *
      *                                                               *
      *****************************************************************
 
     C     ChkValTran    BEGSR
 
      * Check for payment on Valid file
     C     APFOTranID    CHAIN     FTVOPAYL0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     FTVOPAYL0                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPREF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiFT - Routine to check if valid Transaction Exists for *         CAP013
      *    Midas Reference Number                                     *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiFT    BEGSR                                                  CAP013
                                                                                CAP013
      ** Key list for file FTVOPAYL1                                            CAP013
     C     KMIOPA        KLIST                                                  CAP013
     C                   KFLD                    KREF             15            CAP013
      *                                                                         CAP013
      * If (numeric) Midas Reference number supplied                            CAP013
                                                                                CAP013
     C/COPY WNCPYSRC,FTH00099
     C                   TESTN                   SPREF                9898      CAP013
     C/COPY WNCPYSRC,FTH00100
                                                                                CAP013
     C     SPREF         IFNE      *BLANKS                                      CAP013
     C/COPY WNCPYSRC,FTH00359
     C     *IN98         ANDEQ     '1'                                          CAP013
     C/COPY WNCPYSRC,FTH00101
                                                                                CAP013
      * Check for Ref No. on Valid file                                         CAP013
     C                   MOVEL     SPREF         KREF                           CAP013
     C     KMIOPA        CHAIN     FTVOPAYL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     KMIOPA        CHAIN     FTVOPAYL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'SPREF'                    CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
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
     C     SACTION       IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     SPREF         IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      * Validate action code versus transaction IDs supplied
      * This function will set up the Midas payment reference.
      *
      * The transaction in file format from the FT database
      * is retrieved as well.
      *                                                                                       242711
      ** Only set the respmode to 'S' when the front office is blank                          242711
      *                                                                                       242711
     C                   IF        APFOTranID = *BLANK                                        242711
     C                   EVAL      APRESPMODE = 'S'                                           242711
     C                   EVAL      APRespMode = 'S'                                           242711
     C                   ENDIF                                                                242711
 
      * Input is Level 1
     C                   MOVE      '1'           @Level            1
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FTOPAYRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C**********         PARM                    APRESPMODE                                   CAP084
     C**********         PARM      'S'           APRESPMODE                            CAP084 242711
     C                   PARM                    APRESPMODE                                   242711
 
      * Action Code
     C                   PARM                    SACTION
 
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
 
      * (Midas) Payment Reference
     C                   PARM                    SPREF
 
      * Booking branch
     C                   PARM                    SBRCA
 
      * Level 1/2 indicator
     C                   PARM                    @Level            1
     C                   PARM                    Val@Fields                     CFT014
 
      * OUTPUTS
 
      * (Current) transaction in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX                     CFT014
 
      * OK - Action code
     C***********        PARM                    SActionOK                      CFT014
     C                   PARM                    OKACTION                       CFT014
 
      * OK - Payment reference
     C***********        PARM                    SPRefOK                        CFT014
     C                   PARM                    OKPREF                         CFT014
 
      * OK - Booking branch
     C***********        PARM                    SBrcaOK                        CFT014
     C                   PARM                    OKBRCA                         CFT014
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C/COPY WNCPYSRC,FTOPAYCC09
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      * For Amends, put the complete (pre-existing) payment into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVE      PmntFilFmt    ValidPmnt
     C                   MOVE      PmntFilFmX    ValidPmntB                     CFT014
 
      *  (Certain groups of fields on the paymt may not be supplied for an
      *  amendment. If this is the case some defaulting from existing
      *  database values may need to be done here.)
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FTOPAYCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX                     CFT014
 
      * OUTPUTS
      * (Current) Payment in screen format
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrPrm2                      CFT014
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThrd
     C                   PARM                    CurTrFour
     C                   PARM                    CurTr5th                       CFT014
     C                   PARM                    CurTr6th                       CFT014
     C                   PARM                    CurTr7th                       CFT014
     C                   PARM                    CurTrAth                                     CSW209
     C                   PARM                    CurTrCth                                     CSW209
      *                                                                                       CER030
     C                   PARM                    CurTr7Ath                                    CER030
     C                   PARM                    CurTr7Bth                                    CER030
      *                                                                                       CER030
     C                   PARM                    SDFTFR                         CFT014
 
      *  Validation Work Fields
     C                   PARM                    Val@Fields
 
      * Status
     C                   PARM                    PmntStatus       24
 
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
      * Validate Level One details
 
     C/COPY WNCPYSRC,FTH00330
     C                   EXSR      ValdL1Detl
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
                                                                                              262867
      ** Find out if there is a MT103 bilateral agreement exists between                      262867
      ** the booking branch and the receiver only when CFT014 is setup.                       262867
                                                                                              262867
      ** If CSW203 is installed, Default @MT103 to 'Y'.                                       262867
                                                                                              262867
     C                   If        CSW203  = 'Y'                                              262867
     C                   Eval      @MT103 = 'Y'                                               262867
     C                   Else                                                                 262867
                                                                                              262867
     C                   If        @CFT014 = 'Y'                                              262867
     C                   Eval      @MT103 = *Blank                                            262867
     C                   ExSr      SrBMT103                                                   262867
     C                   EndIf                                                                262867
     C                   EndIf                                                                262867
                                                                                              262867
      * Validate Level Two details if not blank, else assume Level One
      * input only.
 
     C     TranInSecA    IFNE      *BLANKS
     C     TranInSecB    ORNE      *BLANKS
     C     TranInThir    ORNE      *BLANKS
     C     TranInThrB    ORNE      *BLANKS                                      CFT014
     C     TranInFour    ORNE      *BLANKS                                      CFT014
     C     TranInMarg    ORNE      *BLANKS                                      CFT014
     C     TranInCVA     ORNE      *BLANKS                                                    CSW209
     C     CSW209        ANDEQ     'Y'                                                        CSW209
     C     TranInCVC     ORNE      *BLANKS                                                    CSW209
     C     CSW209        ANDEQ     'Y'                                                        CSW209
      *                                                                                       CER030
     C     TranInMargA   ORNE      *BLANKS                                                    CER030
     C     TranInMargB   ORNE      *BLANKS                                                    CER030
 
     C                   EXSR      ValdL2Detl
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
                                                                                CFT014
      ** Validate Screen 3 Level 2 details                                      CFT014
                                                                                CFT014
     C                   ExSr      ValdS3Detl                                   CFT014
                                                                                CFT014
      ** If error in validation, fail this input                                CFT014
                                                                                CFT014
     C     Idx           IfNe      0                                            CFT014
     C                   Goto      EValidTr                                     CFT014
     C                   EndIf                                                  CFT014
 
      * Validate Charges/Commission details
      *  - Default values
     C                   IF        @CFT009 = 'N'                                CFT009
     C                   EXSR      DeftCCDetl
     C                   ENDIF                                                  CFT009
 
     C                   EXSR      ValdCCDetl
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
                                                                                CFT014
     C                   IF        SACTION = 'I' OR SACTION = 'A'                             CER030
      *                                                                                       CER030
      ** Default Retail Transaction Type from Transaction code                                CER030
      ** If Retail Transaction type is blank                                                  CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   IF        STRTC <> *BLANKS AND @CFT014 = 'Y'                         CER030
     C                             AND SRTTY = *BLANKS                                        CER030
      *                                                                                       CER030
     C                   EVAL      KTtcd = STRTC                                              CER030
      *                                                                                       CER030
     C     KTtcd         CHAIN     SDNTTIL1                                                   CER030
     C                   IF        %FOUND (SDNTTIL1)                                          CER030
     C                   EVAL      SRTTY = NIRTTY                                             CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Validate Margin Info                                                   CFT014
                                                                                CFT014
     C                   ExSr      ValdMargin                                   CFT014
                                                                                CFT014
      ** If error in validation, fail this input                                CFT014
                                                                                CFT014
     C     Idx           IfNe      0                                            CFT014
     C                   Goto      EValidTr                                     CFT014
     C                   EndIf                                                  CFT014
      *                                                                                       CSW209
      ** Validate SWIFT MT202 COV and SWIFT MT205 COV messages                                CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EXSR      ValdSADetl                                                 CSW209
      *                                                                                       CSW209
      ** If error in validation, fail this input                                              CSW209
      *                                                                                       CSW209
     C     Idx           IFNE      0                                                          CSW209
     C                   GOTO      EValidTr                                                   CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   EXSR      ValdSCDetl                                                 CSW209
      *                                                                                       CSW209
      ** If error in validation, fail this input                                              CSW209
      *                                                                                       CSW209
     C     Idx           IFNE      0                                                          CSW209
     C                   GOTO      EValidTr                                                   CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
 
     C                   END
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdL1Detl - Routine to validate Level One details            *
      *              (This corresponds to the first input screen)     *
      *****************************************************************
     C     ValdL1Detl    BEGSR
     C/COPY OFCPYSRCZ,CFT148_002                                                              CFT148
 
     C                   CALLB     'FTOPAY1VL'
      * Response mode (1A), from source system common header
     C**********         PARM                    APRespMode                                   CAP084
     C**********         PARM      'S'           APRespMode                            CAP084 242711
     C                   PARM                    APRespMode                                   242711
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
     C                   PARM                    CurTrPrim
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    CurTrPrm2                      CFT014
     C                   PARM      APFOTRANID    FrontOffice      20            CPB002
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    TranInfoFlds                                 CFT039
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag1DS
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
      * Valid payment layout (DS) from/to caller
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmntB                     CFT014
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
                                                                                              257361
      *  Funds Transfer Details                                                               257361
     C                   PARM                    SDFTFR                                       257361
     C/COPY WNCPYSRC,FTOPAYCC10
 
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdL2Detl - Routine to validate Level Two details            *
      *              (This corresponds to the second input screen)    *
      *****************************************************************
     C     ValdL2Detl    BEGSR
 
     C                   CALLB     'FTOPAY2VL'
      * Response mode (1A), from source system common header
     C**********         PARM                    APRespMode                                   CAP084
     C**********         PARM      'S'           APRespMode                            CAP084 242711
     C                   PARM                    APRespMode                                   242711
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
      * Level 2 details
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    TranInThir                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag2DS
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
      * Valid payment layout (DS) from/to caller
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmntB                     CFT014
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DeftCCDetl - Routine to default  Charges/Commission details   *
      *              for Inserts                                      *
      *****************************************************************
     C     DeftCCDetl    BEGSR
 
     C                   MOVE      'Y'           PreCalc                                      197220
                                                                                              197220
     C                   CALLB     'FTOPAY3DT'
      *
      * INPUTS :
      * Response mode
     C**********         PARM                    APRespMode                                   CAP084
     C**********         PARM      'S'           APRespMode                            CAP084 242711
     C                   PARM                    APRespMode                                   242711
 
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
      * Level 2 details
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
      * Charges / Commissions details
     C                   PARM                    TranInThir
     C                   PARM                    TranInFour                     CFT014
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    PmntFilFmt
 
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      *  Funds transfer Details
     C                   Parm                    SDFTFR
 
      ** Recalcution flag.                                                                    197220
      *                                                                                       197220
     C                   PARM                    PReCalc           1                          197220
      *                                                                                       197220
      * OUTPUTS :
 
      ** OK inds
     C                   PARM                    OKFlag1DS
     C***********        PARM                    OKFlag2DS                      CFT014
     C***********        PARM                    OKFlag3DS                      CFT014
     C                   PARM                    OKFlag4DS                      CFT014
 
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
 
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    ValidPmnt
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *  Extra rate required for FTVCHPY module                                 CFT009
     C                   Parm                    O2XRTE                         CFT009
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **ValdCCDetl*-*Routine*to*validate*Charges/Commission*details****         CFT014
      * ValdS3Detl - Routine to validate Screen 3 Level 2             *         CFT014
      *              (This corresponds to the third input screen)     *
      *****************************************************************
     C*****ValdCCDetl    BEGSR                                                  CFT014
     C     ValdS3Detl    BEGSR                                                  CFT014
 
     C                   CALLB     'FTOPAY3VL'
      * Response mode (1A), from source system common header
     C**********         PARM                    APRespMode                                   CAP084
     C**********         PARM      'S'           APRespMode                            CAP084 242711
     C                   PARM                    APRespMode                                   242711
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
      * Level 2 details
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
      **Charges*/*Commissions*details**********************************         CFT014
     C                   PARM                    TranInThir
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    TranInThrB                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag3DS
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
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmntB                     CFT014
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
 
 
     C                   ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/ValdCCDetl                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/ValdCCDetl - Validate Charges and Commissions Details      *         CFT014
      *                                                               *         CFT014
      * Called By: Main Routine                                       *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *  FTOPAY4VL  - Charges and Commissions validation module       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     ValdCCDetl    BegSr                                                  CFT014
                                                                                CFT014
     C                   CallB     'FTOPAY4VL'                                  CFT014
     C**********         Parm                    APRespMode                             CFT014CAP084
     C**********         Parm      'S'           APRespMode                            CAP084 242711
     C                   Parm                    APRespMode                                   242711
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInSecB                     CFT014
     C                   Parm                    TranInThir                     CFT014
     C                   Parm                    TranInPrmB                     CFT014
     C                   Parm                    TranInThrB                     CFT014
     C                   Parm                    TranInFour                     CFT014
     C                   Parm                    ExtData                        CFT014
     C                   PARM                    PReDspChg                                    200149
     C                   Parm                    OKFlag4DS                      CFT014
     C                   Parm                    FldNameArr                     CFT014
     C                   Parm                    MsgIDArr                       CFT014
     C                   Parm                    MsgDtaArr                      CFT014
     C                   Parm                    Idx                            CFT014
     C                   Parm                    WFldNamArr                     CFT014
     C                   Parm                    WMsgIDArr                      CFT014
     C                   Parm                    WMsgDtaArr                     CFT014
     C                   Parm                    WIdx                           CFT014
     C                   Parm                    ValidPmnt                      CFT014
     C                   Parm                    ValidPmntB                     CFT014
     C                   Parm                    Val@Fields                     CFT014
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
                                                                                              200149
      ** Charges to the debit of - field changed (Y or blank)                                 200149
                                                                                              200149
     C                   PARM                    PCDROCHG                                     200149
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/ValdMargin                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/ValdMargin - Validate Margin Info                          *         CFT014
      *                                                               *         CFT014
      * Called By: Main Routine                                       *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *  FTOPAY5VL  - Margin Info validation module                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     ValdMargin    BegSr                                                  CFT014
                                                                                CFT014
     C                   CallB     'FTOPAY5VL'                                  CFT014
     C**********         Parm                    APRespMode                             CFT014CAP084
     C**********         Parm      'S'           APRespMode                            CAP084 242711
     C                   Parm                    APRespMode                                   242711
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInMarg                     CFT014
      *                                                                                       CER030
     C                   Parm                    TranInMargA                                  CER030
     C                   Parm                    TranInMargB                                  CER030
     C                   Parm                    STRTC                                        CER030
      *                                                                                       CER030
     C                   Parm                    ExtData                        CFT014
     C                   Parm                    OKFlag5DS                      CFT014
     C                   Parm                    FldNameArr                     CFT014
     C                   Parm                    MsgIDArr                       CFT014
     C                   Parm                    MsgDtaArr                      CFT014
     C                   Parm                    Idx                            CFT014
     C                   Parm                    WFldNamArr                     CFT014
     C                   Parm                    WMsgIDArr                      CFT014
     C                   Parm                    WMsgDtaArr                     CFT014
     C                   Parm                    WIdx                           CFT014
     C                   Parm                    ValidPmnt                      CFT014
     C                   Parm                    Val@Fields                     CFT014
      *                                                                                       CER030
     C                   PARM                    O2TTCD                                       CER030
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************                       CSW209
      /TITLE SR/ValdSADetl                                                                    CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/ValdSADetl - Validate SWIFT MT202 COV and SWIFT MT205      *                       CSW209
      *                 COV messages                                  *                       CSW209
      *                                                               *                       CSW209
      * Called By: ValidateTr                                         *                       CSW209
      *                                                               *                       CSW209
      * Calls: FTOPAYAVL - Validate SWIFT MT202 COV and SWIFT MT205   *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     ValdSADetl    BEGSR                                                                CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTOPAYAVL'                                                CSW209
     C                   PARM                    APRespMode                                   CSW209
     C                   PARM                    TranInPrim                                   CSW209
     C                   PARM                    ValidPmnt                                    CSW209
     C                   PARM                    ValidPmntB                                   CSW209
     C                   PARM                    TranInCVA                                    CSW209
     C                   PARM                    FTEOPYA                                      CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIDArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
     C                   PARM                    Idx                                          CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIDArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
     C                   PARM                    WIdx                                         CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /TITLE SR/ValdSCDetl                                                                    CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/ValdSCDetl - Validate SWIFT MT202 COV and SWIFT MT205      *                       CSW209
      *                 COV messages                                  *                       CSW209
      *                                                               *                       CSW209
      * Called By: ValidateTr                                         *                       CSW209
      *                                                               *                       CSW209
      * Calls: FTOPAYCVL - Validate SWIFT MT202 COV and SWIFT MT205   *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     ValdSCDetl    BEGSR                                                                CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTOPAYCVL'                                                CSW209
     C                   PARM                    APRespMode                                   CSW209
     C                   PARM                    ValidPmnt                                    CSW209
     C                   PARM                    ValidPmntB                                   CSW209
     C                   PARM                    TranInPrim                                   CSW209
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   PARM                    TranInSecA                                 BUG26548
     C                   PARM                    TranInSecB                                   CSW209
     C                   PARM                    TranInThir                                   CSW209
     C                   PARM                    TranInCVA                                    CSW209
     C                   PARM                    TranInCVC                                    CSW209
     C                   PARM                    FTEOPYC                                      CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIDArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
     C                   PARM                    Idx                                          CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIDArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
     C                   PARM                    WIdx                                         CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.
 
      ** To determine what fields have changed, the current fields
      ** on file are converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'FTOPAYAMD'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Payment in Screen Format (Incoming Transaction)
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInThir
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    TranInThrB                     CFT014
     C                   PARM                    TranInFour                     CFT014
     C                   PARM                    TranInMarg                     CFT014
      * (Current) Payment in Screen Format
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThrd
     C                   PARM                    CurTrFour
     C                   PARM                    CurTrPrm2                      CFT014
     C                   PARM                    CurTr5th                       CFT014
     C                   PARM                    CurTr6th                       CFT014
     C                   PARM                    CurTr7th                       CFT014
      * (Current) Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX                     CFT014
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag1DS
     C                   PARM                    OKFlag2DS
     C                   PARM                    OKFlag3DS
     C                   PARM                    OKFlag4DS                      CFT014
     C                   PARM                    OKFlag5DS                      CFT014
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
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
      *  - If Action Code is Insert and Payment Ref is not supplied
      *     - set up the Payment Reference
      *  - If there are still no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report transaction status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report transaction status
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
 
     C     Idx           IFEQ      0
 
     C                   IF        SACTION = 'I'
     C                   EXSR      SETUPPYREF
     C                   ENDIF
     C                   MOVEL     SPREF         OTPREF
 
     C     Idx           IFEQ      0
     C/COPY WNCPYSRC,FTH00181
     C                   EXSR      SETUPVALID
     C                   WRITE     FTVOPAYD0
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C                   Write     FTVOPY2D0                                    CFT014
     C                   EndIf                                                  CFT014
     C/COPY WNCPYSRC,FTH00118
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
      *
     C     APRprLocn     IFEQ      'B'
     C/COPY WNCPYSRC,FTH00256
     C                   WRITE     FTIOPAYD0
     C/COPY WNCPYSRC,FTH00182
                                                                                              CSC011
      ** If support system is active, write invalid transaction to log file via               CSC011
      ** APLOGTRAN standard module.                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
                                                                                              CSC011
      ** Setup TRANSDTL transaction field.                                                    CSC011
                                                                                              CSC011
     C                   EXSR      SRSDTL                                                     CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'FTOPAY'                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANK        RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    TimeStamp                                    CSC011
     C                   PARM      SPREF         PREFERENCE                                   CSC011
     C                   PARM      *BLANKS       PAREFERENCE                                  CSC011
                                                                                              CSC011
      ** Error writing in log file, process db error.                                         CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 12                                                 CSC011
     C                   EVAL      DBKEY = SPREF                                              CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00119
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
     C                   ENDSR
                                                                                              CSC011
      *****************************************************************                       CSC011
      /Title SR/SRDTL                                                                         CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      * SRSDTL     - Setup TRANSDTL transaction field                 *                       CSC011
      *                                                               *                       CSC011
      * Called by: CheckWrite subroutine                              *                       CSC011
      *                                                               *                       CSC011
      * Calls:     None                                               *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRSDTL        BEGSR                                                                CSC011
                                                                                              CSC011
      ** Set TRANSDTL by joining all outgoing payment screens and the extra                   CSC011
      ** data received by this module into a single data transaction field.                   CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInPrim + TranInPrmB +                       CSC011
     C                                        TranInSecA + TranInSecB +                       CSC011
     C                                        TranInThir + TranInThrB +                       CSC011
     C                                        TranInFour + TranInMarg +                       CSC011
     C                                        TranInCVA + TranInCVC +                         CSW209
      *                                                                                       CER030
     C                                        TranInMargA +                                   CER030
     C                                        TranInMargB +                                   CER030
      *                                                                                       CER030
     C                                        RegData    +                                    CER001
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
                                                                                              CSC011
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
 
     C***********        RESET                   OKFlag1DS                      CFT014
     C***********        RESET                   OKFlag2DS                      CFT014
     C***********        RESET                   OKFlag3DS                      CFT014
                                                                                CFT014
      ** Initialise all OK flags to 'Y'                                         CFT014
                                                                                CFT014
     C                   Eval      OKFlag1DS = (*All'Y')                        CFT014
     C                   Eval      OKFlag2DS = (*All'Y')                        CFT014
     C                   Eval      OKFlag3DS = (*All'Y')                        CFT014
     C                   Eval      OKFlag4DS = (*All'Y')                        CFT014
     C                   Eval      OKFlag5DS = (*All'Y')                        CFT014
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   Eval      FTEOPYA = (*All'Y')                                        CSW209
     C                   Eval      FTEOPYC = (*All'Y')                                        CSW209
     C                   ENDIF                                                                CSW209
 
     C                   RESET                   AmendOK
 
     C                   RESET                   PayDat
     C                   RESET                   RecDat
 
     C                   CLEAR                   ValidPmnt
     C                   CLEAR                   ValidPmntB                     CFT014
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   CLEAR                   CurTrAth                                     CSW209
     C                   CLEAR                   CurTrCth                                     CSW209
     C                   ENDIF                                                                CSW209
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Invalid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      SFOtranID = APFOTranID
     C                   EVAL      SRprLocn  = APRprLocn
     C                   EVAL      STMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,FTOPAYC017
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPPYREF - Generate Payment Reference for Inserts           *
      *                                                               *
      *****************************************************************
 
     C     SETUPPYREF    BEGSR
 
     C                   IF           SPREF  = *blanks
     C                             OR SPREF  = *zeros
 
     C/COPY WNCPYSRC,FTOPAYCC04
     C                   EXSR      SETPAYREF
     C/COPY WNCPYSRC,FTOPAYCC05
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPREF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C***********        PARM                    SPrefOK                        CFT014
     C                   PARM                    OKPREF                         CFT014
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If payment reference was entered, put it in the file field
     C                   ELSE
     C                   MOVE      SPREF         OTPREF
 
     C                   ENDIF
 
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
 
      * For Deletes & Authorises, put the complete (pre-existing) Payment
      *  into the Valid file record
     C                   IF           SACTION = 'D'
     C/COPY WNCPYSRC,FTH00456
     C                   MOVE      PmntFilFmt    ValidPmnt
     C                   MOVE      PmntFilFmX    ValidPmntB                     CFT014
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      OTCHTP = SACTION
     C                   EVAL      OTRECI = 'D'
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      OTFRNT = APFOTranID
     C                   EVAL      OTREPA = APRprLocn
     C                   EVAL      OTTMESTMP = TimeStamp
     C/COPY WNCPYSRC,FTH00183
                                                                                CFT014
      ** Setup valid extension file                                             CFT014
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C                   Eval      O2RECI = 'D'                                 CFT014
     C                   Eval      O2PREF = OTPREF                              CFT014
     C                   Eval      O2FRNT = APFOTranID                          CFT014
     C                   Eval      O2REPA = APRprLocn                           CFT014
     C                   Eval      O2TMST = TimeStamp                           CFT014
     C                   If        (SACTION = 'I') Or (SACTION = 'A')           CFT014
     C                   Eval      O2AUTO = 'N'                                 CFT014
     C/COPY WNCPYSRC,FTH00184
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,FTOPAYC018
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETPAYREF  Set up Payment Reference
      *****************************************************************
     C     SETPAYREF     BEGSR
      *
     C                   MOVE      SPYTP         PmntType
     C                   MOVE      SSTTP         StmtType
                                                                                              CSC011
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011
 
     **  Convert rundate to YYMMDD format.
     C                   CALLB     'ZDATE2'
     C**********         PARM      BJRDNB        ZDAYNO            5 0                        CSC011
     C                   PARM                    ZDAYNO            5 0                        CSC011
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
 
     C                   MOVE      ZDATE         RUNDYY
     C                   MOVEL     ZDATE         RUNDMD
 
     **  Get sequence number from data area.
     C     PYTP          IFEQ      'RP'
     C     *LOCK         IN        RGPAYD
     C**********         Z-ADD     RSQNM         PRNUM                                        CFT151
     C                   MOVEL     RSQNM         PRNUM                                        CFT151
     C                   ADD       1             RSQNM
     C                   OUT       RGPAYD
     C                   ELSE
      *
     C/COPY WNCPYSRC,FTH00052
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *LOCK         IN        OTPAYD
     C**********         Z-ADD     OSQNM         PRNUM                                        CFT151
     C**********         ADD       1             OSQNM                                        CFT151
     C                   MOVEL     WOTSQ         PRNUM                                        CFT151
     C                   ADD       1             WOTSQ                                        CFT151
     C                   OUT       OTPAYD
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    PRNUM                                        CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   ENDIF                                                                CFT151
     C/COPY WNCPYSRC,FTH00092
     C                   END
     C/COPY WNCPYSRC,FTH00053
 
     C                   MOVE      IPREF         SPREF
 
     C/COPY WNCPYSRC,FTH00054
      *
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
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
     C                   MOVEL     OTPREF        PTranID          20                          257897
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** repair location (1A, from caller)
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
      ** Midas transaction ID (15A, from caller)
     C**********         PARM                    SPREF                                        257897
     C                   PARM                    PTranID                                      257897
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    SACTION
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C**********         PARM                    APRespMode                                   CAP084
     C**********         PARM      'S'           APRespMode                            CAP084 242711
     C                   PARM                    APRespMode                                   242711
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
 
      *****************************************************************         CAP011
      /eject                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * DtaSubs - Data Substitution                                   *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     DtaSubs       begsr                                                  CAP011
                                                                                CAP011
      ** Convert file fields to screen format                                   CAP011
     C                   reset                   ReturnCode                     CAP011
     C                   callb     'FTOPAYCVT'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX                     CFT014
 
      * OUTPUTS
      * (Current) Payment in screen format
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrPrm2                      CFT014
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThrd
     C                   PARM                    CurTrFour
     C                   PARM                    CurTr5th                       CFT014
     C                   PARM                    CurTr6th                       CFT014
     C                   PARM                    CurTr7th                       CFT014
     C                   PARM                    CurTrAth                                     CSW209
     C                   PARM                    CurTrCth                                     CSW209
      *                                                                                       CER030
     C                   PARM                    CurTr7Ath                                    CER030
     C                   PARM                    CurTr7Bth                                    CER030
      *                                                                                       CER030
     C                   PARM                    SDFTFR                         CFT014
 
      *  Validation Work Fields
     C                   PARM                    Val@Fields
 
      * Status
     C                   PARM                    PmntStatus       24
                                                                                CAP011
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
      ** Substitute the data for the various parts of the transaction,          CAP011
      ** dependent on the flags that were set earlier.                          CAP011
                                                                                CAP011
     C                   if        RepPrim = 'Y'                                CAP011
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
     C                   PARM      TranInPrim    IncData        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrPrim     CurData        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInPrim                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepSecA = 'Y'                                CAP011
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
     C                   PARM      TranInSecA    IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSeco     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInSecA                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepSecB = 'Y'                                CAP011
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
     C                   PARM      TranInSecB    IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrThrd     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInSecB                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepThir = 'Y'                                CAP011
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
     C                   PARM      TranInThir    IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrFour     CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInThir                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CFT014
     C                   If        RepPrmB = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      TranInPrmB    IncData                        CFT014
     C                   Parm      CurTrPrm2     CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       TranInPrmB                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        RepThrB = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      TranInThrB    IncData                        CFT014
     C                   Parm      CurTr5th      CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       TranInThrB                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        RepFour = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      TranInFour    IncData                        CFT014
     C                   Parm      CurTr6th      CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       TranInFour                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        RepMarg = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      TranInMarg    IncData                        CFT014
     C                   Parm      CurTr7th      CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       TranInMarg                     CFT014
     C                   EndIf                                                  CFT014
      *                                                                                       CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   If        RepFiveA = 'Y'                                             CSW209
     C                   Clear                   IncData                                      CSW209
     C                   Clear                   CurData                                      CSW209
     C                   Reset                   ReturnCode                                   CSW209
                                                                                              CSW209
     C                   CallB     'APDTASUBS'                                                CSW209
     C                   Parm                    ReturnCode                                   CSW209
     C                   Parm                    GHSUBS                                       CSW209
     C                   Parm      TranInCVA     IncData                                      CSW209
     C                   Parm      CurTrAth      CurData                                      CSW209
                                                                                              CSW209
     C                   Movel     IncDATA       TranInCVA                                    CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C                   If        RepFiveB = 'Y'                                             CSW209
     C                   Clear                   IncData                                      CSW209
     C                   Clear                   CurData                                      CSW209
     C                   Reset                   ReturnCode                                   CSW209
                                                                                              CSW209
     C                   CallB     'APDTASUBS'                                                CSW209
     C                   Parm                    ReturnCode                                   CSW209
     C                   Parm                    GHSUBS                                       CSW209
     C                   Parm      TranInCVC     IncData                                      CSW209
     C                   Parm      CurTrCth      CurData                                      CSW209
                                                                                              CSW209
     C                   Movel     IncDATA       TranInCVC                                    CSW209
     C                   EndIf                                                                CSW209
     C                   EndIf                                                                CSW209
                                                                                CAP011
     C                   endsr                                                  CAP011
                                                                                CAP011
      *****************************************************************                       262867
      /EJECT                                                                                  262867
      *****************************************************************                       262867
      *                                                               *                       262867
      * SR/SrBMT103   - Check MT103 agreement                         *                       262867
      *                                                               *                       262867
      * Called By: ValidateTr subroutine                              *                       262867
      *                                                               *                       262867
      * Calls:                                                        *                       262867
      * AOCUSTR0  - Access Object to get customer details             *                       262867
      * AOBRCHR0  - Access Object to get branch details               *                       262867
      * ME1730    - Determines whether an MT103 exists                *                       262867
      *                                                               *                       262867
      *****************************************************************                       262867
                                                                                              262867
     C     SrBMT103      BegSr                                                                262867
                                                                                              262867
     C                   Eval      PSNBRC = *Blank                                            262867
     C                   Eval      PSBICA = *Blank                                            262867
     C                   Eval      PSWIFT = *Blank                                            262867
     C                   Eval      PORDBK = *Blank                                            262867
     C                   Eval      PORTCD = *Blank                                            262867
     C                   Eval      WSWIFT = *Blank                                            262867
     C                   Eval      WCNUM = *Blank                                             262867
                                                                                              262867
      ** Get SWIFT-BIC of destination                                                         262867
                                                                                              262867
     C                   If        @DSTT = 'S'                                                262867
     C     11            SubSt     SDST1:1       WSWIFT           11                          262867
     C                   EndIf                                                                262867
                                                                                              262867
      ** Destination type is a full nostro 'F', customer number 'C'                           262867
      ** retail account 'R' or GL account 'G', get SWIFT ID through                           262867
      ** customer number                                                                      262867
                                                                                              262867
     C                   If        (@DSTT = 'F') Or (@DSTT = 'C') Or                          262867
     C                             (@DSTT = 'R') Or (@DSTT = 'G')                             262867
                                                                                              262867
     C                   Select                                                               262867
     C                   When      @DSTT = 'F'                                                262867
     C     3             SubSt     SDST1:1       @CYCD                                        262867
     C     2             SubSt     SDST1:4       @NONB                                        262867
     C                   Call      'AONOSTR0'                                                 262867
     C                   Parm      *Blanks       @RTCD                                        262867
     C                   Parm      '*KEY   '     @OPTN                                        262867
     C                   Parm      *Blanks       @CUST             6                          262867
     C                   Parm                    @CYCD             3                          262867
     C                   Parm      *Blanks       @ACCD            10                          262867
     C                   Parm      *Blanks       @ACSN             2                          262867
     C                   Parm                    @NONB             2                          262867
     C                   Parm      *Blanks       @BRCD             3                          262867
     C                   Parm      *Blanks       @CSSN            10                          262867
     C                   Parm      *Blanks       @PNOI             1                          262867
     C     SDNOST        Parm      SDNOST        DSFDY                                        262867
                                                                                              262867
      ** Error on call                                                                        262867
                                                                                              262867
     C                   If        @RTCD <> *Blanks                                           262867
     C                   Movel     'SDNOSTPD'    DBFILE                                       262867
     C                   Movel     '081'         DBASE                                        262867
     C                   Movel     @CYCD         WKEY              5                          262867
     C                   Move      @NONB         WKEY                                         262867
     C                   Movel     WKEY          DBKEY                                        262867
     C                   Exsr      *PSSR                                                      262867
     C                   EndIf                                                                262867
     C                   Movel     A7CUST        WCNUM            10                          262867
                                                                                              262867
     C                   When      @DSTT = 'C'                                                262867
     C     10            SubSt     SDST1:1       WCNUM                                        262867
                                                                                              262867
     C                   Other                                                                262867
     C     6             SubSt     SDST1:1       WCNUM                                        262867
     C                   EndSl                                                                262867
                                                                                              262867
      ** Access customer's file to get SWIFT id                                               262867
                                                                                              262867
     C                   Call      'AOCUSTR0'                                                 262867
     C                   Parm      *Blanks       @RTCD                                        262867
     C                   Parm      '*KEY   '     @OPTN                                        262867
     C                   Parm      WCNUM         @KEY1            10                          262867
     C                   Parm      *Blanks       @KYST             7                          262867
     C     SDCUST        Parm      SDCUST        DSSDY                                        262867
                                                                                              262867
     C                   If        @RTCD = *Blank                                             262867
     C                   If        BBCSID <> *Blank                                           262867
     C                   Movel     BBCSID        WSWIFT                                       262867
     C                   EndIf                                                                262867
     C                   Else                                                                 262867
     C                   Movel     'SDCUSTPD'    DBFILE                                       262867
     C                   Movel     '082'         DBASE                                        262867
     C                   Movel     WCNUM         DBKEY                                        262867
     C                   Exsr      *PSSR                                                      262867
     C                   EndIf                                                                262867
     C                   EndIf                                                                262867
                                                                                              262867
      ** Setup parameter to ME1730                                                            262867
                                                                                              262867
     C                   If        WSWIFT <> *Blank                                           262867
     C                   Movel     SBRCA         PSNBRC                                       262867
     C                   Call      'AOBRCHR0'                                                 262867
     C                   Parm      *Blanks       @RTCD                                        262867
     C                   Parm      '*KEY   '     @OPTN                                        262867
     C                   Parm      SBRCA         @BRCD                                        262867
     C     SDBRCH        Parm      SDBRCH        DSFDY                                        262867
                                                                                              262867
     C                   If        @RTCD <> *Blank                                            262867
     C                   Movel     'SDBRCHPD'    DBFILE                                       262867
     C                   Movel     '083'         DBASE                                        262867
     C                   Movel     SBRCA         DBKEY                                        262867
     C                   Exsr      *PSSR                                                      262867
     C                   EndIf                                                                262867
     C                   Movel     A8BTID        PSBICA                                       262867
     C                   Movel     WSWIFT        PSWIFT                                       262867
     C                   Movel     SORBK         PORDBK                                       262867
                                                                                              262867
      ** Call ME1730                                                                          262867
                                                                                              262867
     C                   Call      'ME1730'                                                   262867
     C                   Parm                    PSNBRC            3                          262867
     C                   Parm                    PSBICA           11                          262867
     C                   Parm                    PSWIFT           11                          262867
     C                   Parm                    PORDBK          256                          262867
     C                   Parm                    PBBINF          256                          262867
     C                   Parm                    PSNCOR          256                          262867
     C                   Parm                    PRCCOR          256                          262867
     C                   Parm                    PORTCD            7                          262867
                                                                                              262867
     C                   If        PORTCD = '*ERROR '                                         262867
     C                   Movel     'ME1730'      DBFILE                                       262867
     C                   Movel     '084'         DBASE                                        262867
     C                   Movel     '*CALL   '    DBKEY                                        262867
     C                   Exsr      *PSSR                                                      262867
     C                   Else                                                                 262867
     C                   If        PORTCD = '*CRT103'                                         262867
     C                   Move      'Y'           @MT103                                       262867
     C                   EndIf                                                                262867
     C                   EndIf                                                                262867
     C                   EndIf                                                                262867
                                                                                              262867
     C                   EndSr                                                                262867
     C/COPY WNCPYSRC,FTH00331
                                                                                              262867
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C****************** PARM                    Trans5001                                    248920
     C                   PARM                    Trans5001FT    1000                          248920
     C                   PARM                    Trans5001A     1000                          248920
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005                      CFT014
     C****************** PARM                    Trans5006                      CFT014        248920
     C                   PARM                    Trans5006FT    1000                          248920
     C                   PARM                    Trans5007                      CFT014
     C**************     PARM                    Trans5008                      CFT014        248920
     C                   PARM                    Trans5009A                                   CSW209
     C                   PARM                    Trans5009B                                   CSW209
     C                   PARM                    Trans5009                                    CER030
     C                   PARM                    Trans5010                                    CER030
     C                   PARM                    Trans5011                                    CFT039
 
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'FTUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C/COPY WNCPYSRC,FTH00347
     C                   EVAL      MsgFArray(2) = 'MEMSG'                                     262659
 
     C/COPY WNCPYSRC,FTH00185
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'FT'
 
      * Clear fields used invalidation
     C                   Clear                   Val@Fields
 
      * GET ZMUSER to access default branch.
     C     *DTAARA       Define                  ZMUSER
     C                   In        ZMUSER
     C                   Unlock    ZMUSER
 
     C                   Eval      @DFBR = WDFBR
     C                   Eval      @DPPT = WDPPT
 
      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT
 
     C                   Eval      @MBIN = WMBIN
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access Funds Transfer details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOFTFRR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDFTFR        Parm      SDFTFR        DSFDY
 
     C                   Eval      @RATDIS = WRATDIS
 
      * Access SAR details file to determine if CEU006 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   Movel     '002'         DBASE
     C                   Movel     'CEU006'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End
 
      * Access SAR details file to determine if S01494 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01494'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01494
     C                   Else
     C                   Movel     'N'           @01494
     C                   End
 
      * Access SAR details file to determine if S01499 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01499'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01499'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01499
     C                   Else
     C                   Movel     'N'           @01499
     C                   End
 
      * Access SAR details file to see if CFT003 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT003'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'CFT003'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End
                                                                                CFT014
      ** Access SAR details file to see if CFT014 is installed.                 CFT014
                                                                                CFT014
     C                   CallB     'AOSARDR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*VERIFY'     @OPTN                          CFT014
     C                   Parm      'CFT014'      @SARD                          CFT014
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks and                         CFT014
     C                             @RTCD <> '*NRF   '                           CFT014
     C                   Movel     'SCSARDPD'    DBFILE                         CFT014
     C                   Movel     '010'         DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blanks                              CFT014
     C                   Movel     'Y'           @CFT014                        CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           @CFT014                        CFT014
     C                   EndIf                                                  CFT014
 
      * Access SAR details file to see if S01508 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01508'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01508'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01508
     C                   Else
     C                   Movel     'N'           @01508
     C                   End
 
      * Access SAR details file to see if S01506 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01506'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01506'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01506
     C                   Else
     C                   Movel     'N'           @01506
     C                   End
                                                                                CFT004
      * Access SAR details file to see if CFT004 is installed.                  CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   Parm      *BLANKS       @RTCD                          CFT004
     C                   Parm      '*VERIFY'     @OPTN                          CFT004
     C                   Parm      'CFT004'      @SARD                          CFT004
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT004
                                                                                CFT004
     C                   If        @RTCD = *Blanks                              CFT004
     C                   Movel     'Y'           @CFT004                        CFT004
     C                   Else                                                   CFT004
     C                   Movel     'N'           @CFT004                        CFT004
     C                   End                                                    CFT004
      *                                                                         CFT009
      * Access SAR details file to see if CFT009 is installed.                  CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT009'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT009                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT009                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      * Access SAR details file to see if CFT010 is installed.                  CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT010'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT010                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT010                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                                       CFT151
      * Access SAR details file to see if CFT151 is installed.                                CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       @RTCD                                        CFT151
     C                   PARM      '*VERIFY'     @OPTN                                        CFT151
     C                   PARM      'CFT151'      @SARD                                        CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
                                                                                              CFT151
     C                   IF        @RTCD = *BLANKS                                            CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
                                                                                              CSC011
      ** Access SAR details file to see if 24X7 (CSC011) is installed.                        CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> *BLANKS AND                                       CSC011
     C                             PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 11                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      @CSC011 = 'Y'                                              CSC011
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      @CSC011 = 'N'                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSW209
      ** Check if CSW209 is installed                                                         CSW209
      *                                                                                       CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM                    PRTCD                                        CSW209
     C     PRTCD         IFEQ      'CSW2009'                                                  CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ENDIF                                                                CSW209
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtCd                                        CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtCd = *BLANKS                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTOPAYCTL'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
 
                                                                                              262867
      ** Call SWIF2003 to check if CSW203 is installed                                        262867
                                                                                              262867
     C                   CALL      'SWIF2003'                                                 262867
     C                   PARM      *BLANKS       PRTCD                                        262867
                                                                                              262867
      ** If ret. code is "CSW203", set CSW203 flag to "Y", else set it to "N"                 262867
                                                                                              262867
     C                   IF        PRTCD = 'CSW2003'                                          262867
     C                   EVAL      CSW203 = 'Y'                                               262867
     C                   ELSE                                                                 262867
     C                   EVAL      CSW203 = 'N'                                               262867
     C                   ENDIF                                                                262867
     C/COPY WNCPYSRC,FTH00186
     C/COPY OFCPYSRCZ,CFT148_003                                                              CFT148
                                                                                              262867
      * Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Eval      @BCDP = A6NBDP
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
                                                                                              CSC011
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011
 
      * Calculate Run Date
     C                   CALLB     'ZDATE2'
     C**********         Parm      BJRDNB        ZDAYNO                                       CSC011
     C                   Parm                    ZDAYNO                                       CSC011
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE
     C                   Parm      *Blanks       ZADATE
 
     C                   Eval      @RUNN = ZDATE
 
      * Calculate Back Value Date
      ** Use processing date defined in SC24X7 dataarea when support system is                CSC011
      ** active.                                                                              CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   Eval      @BVLD = WPRDTE - BJBVPD                                    CSC011
     C                   ELSE                                                                 CSC011
     C                   Eval      @BVLD = BJRDNB - BJBVPD
     C                   ENDIF                                                                CSC011
 
      * Set up User id
     C                   Eval      PSUSER = WUSRID                                            CAP084
     C                   Eval      @USRID = PSUSER
 
      *
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APOPAYDTQ'
 
      *  Data areas for Payment reference numbering.
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD
     C     *DTAARA       DEFINE    RGPAYDA       RGPAYD
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FTOPAYC022
     C                   MOVEL     'N'           ULX608                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX608'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks and                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '013'         DBASE                                        CER001
     C                   MOVEL     'ULX608'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   MOVEL     'Y'           ULX608                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as Feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks and                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '014'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      FTVOPLX1PD                                                 CER001
     C                   OPEN      FTIOPLX1PD                                                 CER001
     C                   OPEN      SDCUX1L0                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** CER030 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   MOVEL     'N'           CER030                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS AND                                       CER030
     C                             PRtcd <> '*NRF   '                                         CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '015'         DBASE                                        CER030
     C                   MOVEL     'CER030'      DBKEY                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   END                                                                  CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   MOVEL     'Y'           CER030                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CGL013 - SWIFT Switchable Feature                                                    CER030
      *                                                                                       CER030
     C                   MOVEL     'N'           CGL013                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS AND                                       CER030
     C                             PRtcd <> '*NRF   '                                         CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '016'         DBASE                                        CER030
     C                   MOVEL     'CGL013'      DBKEY                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   END                                                                  CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   MOVEL     'Y'           CGL013                                       CER030
     C                   ENDIF                                                                CER030
 
     C                   ENDSR
     C/COPY WNCPYSRC,FTOPAYCC06
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
