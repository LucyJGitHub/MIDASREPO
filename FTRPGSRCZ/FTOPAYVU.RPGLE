     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate & Update')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTOPAYVU - FT Outgoing Payments validate and update          *
      *                                                               *
      *  Function: This Program Validates FT OPAY for                 *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054059           Date 28Nov19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD050928A          Date 28Jun18               *
      *                 MD050928           Date 15May18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042042           Date 14Feb17               *
      *                 MD044395           Date 08Mar17               *
      *                 AR1090283          Date 10Aug16               *
      *                 MD041641           Date 04Oct16               *
      *                 MD033098           Date 23Feb15               *
      *                 MD030906           Date 13Nov14               *
      *                 CFT157             Date 29Aug14               *
      *                 CFT151             Date 20Mar14               *
      *                 258944             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 AR1077978          Date 22Jan13               *
      *                 AR1070111          Date 21Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR1067499          Date 12Dec12               *
      *                 CAP211             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 AR971184A          Date 22Jun12               *
      *                 AR971184           Date 28May12               *
      *                 AR870195           Date 11Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CFT045             Date 04Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 BUG26775           Date 27Nov09               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 262664             Date 11Nov09               *
      *                 CER030             Date 09Jul08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26548           Date 23Oct09               *
      *                 CSW209             Date 01Apr09               *
      *                 257758             Date 19Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22150           Date 16Jan09               *
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 BUG18500           Date 05May08               *
      *                 242863             Date 25Sep07               *
      *                 250345             Date 24Sep07               *
      *                 BUG14156           Date 25Jun07               *
      *                 BUG14157           Date 19Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245108             Date 19Jan07               *
      *                 244540             Date 15Jan07               *
      *                 244537             Date 17Aug05               *
      *                 243991             Date 05Dec06               *
      *                 GBO009             Date 14Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12705           Date 17Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSW206             Date 03Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG6864            Date 14Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG10128           Date 27Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG6280            Date 15Mar05               *
      *                 BUG4163            Date 21Jan05               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4196            Date 09Sep04               *
      *                 CFT118 (redeliver) Date 01Sep04               *
      *                 CFT118             Date 24Aug04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084  *CREATE    Date 08Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD054059 - Missing outgoing payment reference in the         *
      *             extension files                                   *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD050928A -OPAY inserted as unauthorised even AutoAUTH = 'Y' *
      *             Re-instate codes reversed by MD033098.  CFT157    *
      *             codes were reversed on APTRANVU and on FTOP* files*
      *  MD050928 - SP15_MQ: Unclear error message - Error validating *
      *              'Stamp Tax Amount' : Invalid Numeric Value       *
      *           - Correction to CFT157. Move fields to end of Buffer*
      *           - Patterned after fix MD039094                      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042042 - Input Officer 1 and Input Officer 2 are being     *
      *             populated with WIP authoriser. Use the WIP input  *
      *             user profile instead.                             *
      *  MD044395 - Incorrect Customer Name on Inputs details for     *
      *             valid BIC entry                                   *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  MD041641 - Details of Payment fields are uppercase. Remove   *
      *             GEMS 250345.                                      *
      *  MD033098 - Incorrect data mapping due to CFT157. Adjust      *
      *             TranInExtn1 and TranInExtn2 accordingly.          *
      *  MD030906 - Counterparty Nostro not defaulted.                *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  258944 - APISERVER API FTOPAY: correct positions; fix use of *
      *           APNARV in CFT148 which adds one to positions        *
      *           Amended hook: CFT148_007 (Recompile)                *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_007, CFT148_008, CFT148_009     *
      *  AR1077978 - MT103 not generated when Ordering Bank is entered*
      *  AR1070111 - System defaulted values of some fields were not  *
      *              saved                                            *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  AR1067499 - Defaulted values of some OP fields are erroneous *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  AR870195 - IBAN account has been used for the settlement 1   *
      *             tab, however upon complete the Customer details   *
      *             were blanked out                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CFT045 - Outgoing Payments - Extended Settlement Instructions*
      *  CER049 - Stamp Tax                                           *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262664 - Parameter conflict against SWIFT09.                 *
      *         - Change the parameter name.                          *
      *  CER030 - Multicash German Feature                            *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG26548 - Passed parm does not match entry parm for FTVXVXV *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257758 - Warning message displayed in Outgoing payments. Add *
      *           SDFTFR in the calling parameters of FTOPAY1VL.      *
      *           Pattern after fix 257361.                           *
      *  BUG22150 - Missing authorization field in repository.        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  BUG18500 - Unable to authorize amended data                  *
      *  242863 - The MMM1067 message should be displayed when a      *
      *           record being amended is updated by another user     *
      *  250345 - Convert 'Details of Payment' fields from lowercase  *
      *           to uppercase to avoid SWIFT error                   *
      *  BUG14156 - Amend decimal places in Charge Amount (Recompile) *
      *  BUG14157 - Error in SWIFT Standard Charge Conv. (Recompile)  *
      *  245108 - Default to 'SHA' if MT103 is 'Y'.                   *
      *  244540 - Check if source of payment is MT103.                *
      *  244537 - To avoid overriding front office identifier.        *
      *  243991  - Always validate level 2 details when 'level joiner'*
      *            set to 'Y'                                         *
      *  GBO009 - Funds Transfer Outgoing Payment Reference           *
      *         - Added core hooks: FTOPAYVUF1, FTOPAYVUCA,           *
      *           FTOPAYVUC1, FTOPAYVUC2, FTOPAYVUCB, FTOPAYVUC3.     *
      *  BUG12705 - Error in ordering customer       (Recompile)      *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSW206 - SWIFT 2006 Standard Changes                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6864 - SCHCM is not setup after call to CVT               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG10128-Ordering is not valid and Beneficiary type is       *
      *           mandatory                                           *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG6280 - Perform SR/GetChgCcys in Amend mode                *
      *  BUG4163 - Pass correct parameter to RTV module               *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4196- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CFT118 - Core changes for GBO018.                            *
      *         - Demand Drafts printing - Upgrade to Midasplus.      *
      *           (Redelivery) Added new field CQIN to the buffer.    *
      *  CFT118 - Core changes for GBO018.                            *
      *         - Demand Drafts Printing - Upgrade to MidasPlus.      *
      *           Core hooks added:   FTOPAYVU10                      *
      *           Core hooks amended: FTOPAYVUC4                      *
      *                               FTOPAYVUC5                      *
      *                               FTOPAYVUC7                      *
      *                               FTOPAYVUC9                      *
      *                               FTOPAYVUD1                      *
      *  CFT116 - Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks added:FTOPAYVUC5,FTOPAYVUC7,FTOPAYVUD1,  *
      *                            FTOPAYVUC8,FTOPAYVUC9,FTOPAYVUC4   *
      *           Core hooks amended:FTOPAYM01                        *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

     F/COPY WNCPYSRC,FTOPAYVUF1
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
      ** UpperCase letters                                                      250345
     D UpperCase       C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'         250345
      ** LowerCase letters                                                      250345
     D LowerCase       C                   'abcdefghijklmnopqrstuvwxyz'         250345
                                                                                              CRE067
      ** The maximum size of the appended error arrays                                        CRE067
     D XArrayMax       C                   CONST(20)                                          CRE067

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      ** Variable to hold translated 'Details of Payment' fields                250345
     D TranSec1        S                   LIKE(TranInThir)                     250345
      **                                                                                      CSC022
      ** Array of Fields in error                                                             CRE067
     D WFldNamXAr      S             10A   DIM(XArrayMax)                                     CRE067
                                                                                              CRE067
      ** Array of error message IDs                                                           CRE067
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CRE067
                                                                                              CRE067
      ** Array of error message data                                                          CRE067
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      CRE067

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)
     D TranInThrB    E DS                  EXTNAME(FTOPY5PD)
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)
     D TranInMarg    E DS                  EXTNAME(FTOPY7PD)
     D TranInCovA    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D TranInCovC    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D TranInExtn    E DS                  EXTNAME(FTOPY9PD)                                  CER049
      *                                                                                       CFT039
      ** FT OPAY API Ordering Bank Details                                                    CFT039
     D TranInfoFlds  E DS                  EXTNAME(FTOPIFPD)                                  CFT039

     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
      * Valid Payments layout

     D ValidPmntB    E DS                  EXTNAME(FTVOPY2PD)
      ** Valid Payments layout B
                                                                                              CER001
     D PValidPmntX   E DS                  EXTNAME(FTVOPLX1PD)                                CER001
      * Valid Payments layout - extension file                                                CER001

     D PmntFilFmt    E DS                  EXTNAME(OTPAYDD)
      * (Current) Transaction in File Format

     D PmntFilFmX    E DS                  EXTNAME(OTPAYXPD)
      ** (Current) Transaction in File Format Extension
                                                                                              CER001
     D PSvRcdX       E DS                  EXTNAME(FTOPX1PD)                                  CER001
     D                                     PREFIX(SV)                                         CER001
      ** Transaction in File Format Extension                                                 CER001

     D CurTrPrim     E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 1st screen (level 1)

     D CurTrPrm2     E DS                  EXTNAME(FTOPY1APD)
     D                                     PREFIX(@)
      ** (Current) Transaction in Screen Format - 1st screen (level 2)

     D CurTrSeco     E DS                  EXTNAME(FTOPY2PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 2nd screen (level 2)

     D CurTrThrd     E DS                  EXTNAME(FTOPY3PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 2nd screen (level 2)

     D CurTrFour     E DS                  EXTNAME(FTOPY4PD)
     D                                     PREFIX(@)
      * (Current) Transaction in Screen Format - 3rd screen (level 2)

     D CurTr5th      E DS                  EXTNAME(FTOPY5PD)
     D                                     PREFIX(@)
      ** (Current) Transaction in Screen Format - 3rd screen (level 2)

     D CurTr6th      E DS                  EXTNAME(FTOPY6PD)
     D                                     PREFIX(@)
      ** (Current) Transaction in Screen Format - 4th screen (level 2)

     D CurTr7th      E DS                  EXTNAME(FTOPY7PD)
     D                                     PREFIX(@)
      ** (Current) Transaction in Screen Format - Margin Info

     D CurTrCovA     E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@)                                          CSW209
      ** (Current) Transaction in Screen Format - Cover Message                               CSW209
                                                                                              CSW209
     D CurTrCovC     E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@)                                          CSW209
      ** (Current) Transaction in Screen Format - Cover Message                               CSW209
                                                                                              CSW209
      ** Copy of transaction in Screen Format
     D CurTrPrim@    E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(@C)
     D CurTrPrm2@    E DS                  EXTNAME(FTOPY1APD)
     D                                     PREFIX(@C)
     D CurTrSeco@    E DS                  EXTNAME(FTOPY2PD)
     D                                     PREFIX(@C)
     D CurTrThrd@    E DS                  EXTNAME(FTOPY3PD)
     D                                     PREFIX(@C)
     D CurTrFour@    E DS                  EXTNAME(FTOPY4PD)
     D                                     PREFIX(@C)
     D CurTr5th@     E DS                  EXTNAME(FTOPY5PD)
     D                                     PREFIX(@C)
     D CurTr6th@     E DS                  EXTNAME(FTOPY6PD)
     D                                     PREFIX(@C)
     D CurTr7th@     E DS                  EXTNAME(FTOPY7PD)
     D                                     PREFIX(@C)
     D CurTrCovA@    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@C)                                         CSW209
     D CurTrCovC@    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@C)                                         CSW209

     D OKFlag1DS     E DS                  EXTNAME(FTEOPY1PD)
      ** Flags to indicate wheter transaction fields are valid for screen 1
      ** (Screen 1 Level 1)

     D OKFlag2DS     E DS                  EXTNAME(FTEOPY2PD)
      ** Flags to indicate wheter transaction fields are valid for screen 2
      ** (Screen 1 Level 2)

     D OKFlag3DS     E DS                  EXTNAME(FTEOPY3PD)
      ** Flags to indicate wheter transaction fields are valid for screen 3
      ** (Screen 2 Level 2)

     D OKFlag4DS     E DS                  EXTNAME(FTEOPY4PD)
      ** Flags to indicate wheter transaction fields are valid for screen 4
      ** (Charges and Commission Screen 3 Level 2)

     D OKFlag5DS     E DS                  EXTNAME(FTEOPY5PD)
      ** Flags to indicate wheter transaction fields are valid for screen 5
      ** (Margin Information Screen 4 Level 2)
                                                                                              CER001
     D OKFlagADS     E DS                  EXTNAME(FTEOPYAPD)                                 CSW209
      ** Flags to indicate whether transaction fields are valid for cover msg scr             CSW209
      ** (Cover Message)                                                                      CSW209
                                                                                              CSW209
     D OKFlagCDS     E DS                  EXTNAME(FTEOPYCPD)                                 CSW209
      ** Flags to indicate whether transaction fields are valid for cover msg scr             CSW209
      ** (Cover Message)                                                                      CSW209
                                                                                              CSW209
     D OKFlagXDS     E DS                  EXTNAME(FTEOPLX1PD)                                CER001
      ** Flags to indicate wheter transaction fields are valid for extension file             CER001
                                                                                              CER001
     D PData           DS                                                                     CER001
     D  #1FLD1                 1      6  0                                                    CER001
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

     D ExtData       E DS                  EXTNAME(FTOPEXPD)
     D/COPY OFCPYSRCZ,CFT148_007                                                              CFT148
     D RegData       E DS                  EXTNAME(FTOPRXPD)                                  CER001
     D StopFTDta     E DS                  EXTNAME(FTOPY10APD)                              MD050928
      * FT Outgoing Payments Extra Data - File (D/B) format
      *
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @NotDelAmt    E                     EXTFLD(@SNDAM)
     D @PayDelAmt    E                     EXTFLD(@SPDAM)
     D @PayAmount    E                     EXTFLD(@SPYAM)
     D @SettleAmt    E                     EXTFLD(@SSMAM)
     D Val@Fields@   E DS                  EXTNAME(FTV@OPAYPD)
     D                                     PREFIX(@C)
     D @C@NotDelAmt  E                     EXTFLD(@SNDAM)
     D @C@PayDelAmt  E                     EXTFLD(@SPDAM)
     D @C@PayAmount  E                     EXTFLD(@SPYAM)
     D @C@SettleAmt  E                     EXTFLD(@SSMAM)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

     D*OTPAYD***     E DS                  EXTNAME(OTPAYDA)                                   CFT151
      ***** DATA AREA FOR ORDINARY PAYMENT REF NUMBERING                                      CFT151
      ** DS for next Outgoing Payment Reference Number                                        CFT151
     D OTPAYD          DS             4                                                       CFT151
     D  WOTSQ                  1      4  0                                                    CFT151
                                                                                              CFT151

     D RGPAYD        E DS                  EXTNAME(RGPAYDA)
      *     DATA AREA FOR REGULAR PAYMENT REF NUMBERING
      *

      ** Valid Outgoing Payments Extension File (default)
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)
     D                                     PREFIX(D#)

      * Valid Payments layout (default)
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)
     D                                     PREFIX(D#)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS

      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  244540
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     244540
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  244540
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  244540
      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
     D  WRATDIS               44     48  4

      ** Externally described DS for Counterpary nostro                                     MD030906
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                MD030906
                                                                                            MD030906
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      *                                                                                       CER030
     D TranInMarA    E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
     D TranInMarB    E DS                  EXTNAME(FTOPY7BPD)                                 CER030
      *                                                                                       CER030
     D CurTr7Ath     E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
     D CurTr7Bth     E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
     D CurTr7AthCp   E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(C)                                          CER030
      *                                                                                       CER030
     D CurTr7BthCp   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(C)                                          CER030


      *  User / Branch data area
     D ZMUSER          DS            17
     D  WUSRID                 1     10
     D  WDFBR                 11     13
     D  WDPPT                 14     16

      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13

     D                 DS
      *     REDEFINE IPREF FOR INSERTS
     D  IPREF                  1     15
     D  P                      1      1    INZ('P')
     D  RUNDYY                 2      3  0
     D  RUNDMD                 4      7  0
     D**PRNUM                  8     11  0                                                    CFT151
     D  PRNUM                  8     11                                                       CFT151
     D  PmntType              12     13
     D  StmtType              14     15  0
      *
                                                                                              CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D WNumDetlIn      S           1000A                                                      CSF011
     D WAccntType      S             10A                                                      CSF011
     D WNumDetLn3      S           1000A                                                      CSF011
     D CusIdx          S              4S 0 INZ(1)                                             CSF011
     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
     D CusIdx3         S              4S 0 INZ(1)                                             CSF011
     D AccLength       S              2S 0 INZ(72)                                            CSF011
     D NoOfCusField    S              2S 0 INZ(10)                                            CSF011
     D P@TYP           S             10                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D P@Str2          S             35                                                       CSF011
     D P@Str3          S             35                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D W@ATyp          S              1                                                       CSF011
     D W@CCY           S              3                                                       CSF011
     D W@BRC           S              3                                                       CSF011
     D W@Slash         S              1                                                       CSF011
     D WAccName        S             20                                                      CSF011A
                                                                                              CSF011
     D MT110GEN        S              1                                                       CFT116
     D SMTCN           S              6                                                       CFT116
     D SCHQN           S              6                                                       CFT116
     D SCQIN           S              1                                                       CFT118
                                                                                              CRE067
     D BSCDTLS         S             10    DIM(23) CTDATA PERRCD(1)                           CRE067
                                                                                              CRE067
     D/COPY WNCPYSRC,FTOPAYVUD1
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

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D***Trans5001       S            500A                                                   CSF011A
     D***Trans5002       S            500A                                                   CSF011A
     D***Trans5003       S            500A                                                   CSF011A
     D Trans5001       S           1000A                                                     CSF011A
     D Trans5002       S           1000A                                                     CSF011A
     D Trans5003       S           1000A                                                     CSF011A
     D*Trans5004       S            500A                                                      CFT120
     D Trans5004       S           1000A                                                      CFT120
     D Trans5005       S            500A
     D***Trans5006       S            500A                                                   CSF011A
     D*Trans5006       S           1000A                                              CSF011A CFT120
     D Trans5006       S            500A                                                      CFT120
     D Trans5007       S            500A
     D Trans5008       S            500A
     D Trans5009       S            500A
     D Trans5010       S           1000A                                                      CSW209
     D Trans5011       S           1000A                                                      CSW209
     D Trans5012       S            500A                                                      CER049
     D Trans5009B      S            500A                                                      262664
     D Trans5009C      S            500A                                                      262664
     D TRANS5013       S            500A                                                      CFT039
      *                                                                                       262664
     D TransIn7and8    S           1000A
     D RegData500      S            500A                                                      CER001

      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')

      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

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
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
     D RepSecA         S              1A   inz('N')
     D RepSecB         S              1A   inz('N')
     D RepThir         S              1A   inz('N')
     D RepPrmB         S              1A   inz('N')
     D RepThrB         S              1A   inz('N')
     D RepFour         S              1A   inz('N')
     D RepMarg         S              1A   inz('N')
     D RepCovA         S              1A   inz('N')                                           CSW209
     D RepCovC         S              1A   inz('N')                                           CSW209

      * Msg Unique Reference
     D SHMSGR          S              8  0
     D SHMSGR@         S              8  0
     D
      * Part Number
     D SHPART          S              3  0
     D SHPART@         S              3  0
     D PRTCD           S              7A                                                      244540
     D PSARD           S              6A                                                      244540
     D PACCD           S             10A                                                      244540
      ** Flag to indicate if CSW203 is switched on                                            244540
     D CSW203          S              1A                                                      244540
      ** CSC022 switchable feature                                                            CSC022
     D CSC022          S              1A                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      *                                                                                       CFT045
      ** CFT045 switchable feature                                                            CFT045
      *                                                                                       CFT045
     D CFT045          S              1A                                                      CFT045
     D/COPY WNCPYSRC,FTH00561
      *                                                                                       CFT045
      ** ULX043 switchable feature                                                            CER001
     D ULX043          S              1A                                                      CER001
      ** parameter fields                                                                     CER001
     D PRetCodeIn      S             10                                                       CER001
     D PActn           S              1                                                       CER001
     D PFrontID        S             20                                                       CER001
     D PPayRef         S             15                                                       CER001
     D PCuty           S              2                                                       CER001
     D PCust           S              6                                                       CER001
     D PFind           S              1                                                       CER001
     D CSW209          S              1                                                       CSW209
                                                                                              CSW209
     D InputUser       S             10A                                                    MD042042
      *
     D TimeStampC      S             26A   INZ('0001-01-01-00.00.00.000000')                BUG18500
     D TimeStampZ      S             26Z                                                    BUG18500
     D BtnPressed      S             10A                                                   AR1090283
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

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029

      /COPY WNCPYSRC,FTOPAYC001

     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInPrmB
     C                   MOVEL     Trans5003     TranInSecA
     C                   MOVEL     Trans5004     TranInSecB
     C                   MOVEL     Trans5005     TranInThir
     C                   MOVEL     Trans5006     TranInThrB
     C     Trans5007     cat       Trans5008     TransIn7and8
     C                   MOVEL     TransIn7and8  TranInFour
     C                   MOVEL     Trans5009     TranInMarg
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     Trans5010     TranInCovA                                   CSW209
     C                   MOVEL     Trans5011     TranInCovC                                   CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   MOVEL     Trans5009B    TranInMarA                                   262664
     C                   MOVEL     Trans5009C    TranInMarB                                   262664
     C                   MOVEL     Trans5012     TranInExtn                                   CER049
     C                   MOVEL     Trans5013     TranInfoFlds                                 CFT039
      *                                                                                       262664
     C                   MOVEL     RegData500    RegData                                    BUG10128
     C/COPY WNCPYSRC,FTOPAYVUC5

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      *  Validate Action Code

     C                   EXSR      ValidateAc

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

     C     SACTION       IFEQ      'I'                                                        244540
     C     SACTION       OREQ      'A'                                                        244540
     C                   If        @CFT014 = 'Y'                                              244540
     C                   Eval      @MT103 = *Blank                                            244540
     C                   ExSr      SrBMT103                                                   244540
     C                   If        SDTCH = '   ' and                                          245108
     C                             @MT103 = 'Y'                                               245108
     C                   Eval      SDTCH = 'SHA'                                              245108
     C                   Endif                                                                245108
     C                   EndIf                                                                244540
     C                   EndIf                                                                244540
      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      SACTION = 'I'
      *  Processing for Inserts
     C                   EXSR      ValidateTr

     C                   WHEN      SACTION = 'A'
      *  Processing for Amends

      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        GHSUBS <> *blank

     C     GHSUBS        scan      TranInPrim                             99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInSecA                             99
     C                   if        *in99
     C                   eval      RepSecA = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInSecB                             99
     C                   if        *in99
     C                   eval      RepSecB = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInThir                             99
     C                   if        *in99
     C                   eval      RepThir = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInPrmB                             99
     C                   if        *in99
     C                   eval      RepPrmB = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInThrB                             99
     C                   if        *in99
     C                   eval      RepThrB = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInFour                             99
     C                   if        *in99
     C                   eval      RepFour = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInMarg                             99
     C                   if        *in99
     C                   eval      RepMarg = 'Y'
     C                   endif

     C                   IF        CSW209 = 'Y'                                               CSW209
                                                                                              CSW209
     C     GHSUBS        SCAN      TranInCovA                             99                  CSW209
     C                   IF        *in99                                                      CSW209
     C                   EVAL      RepCovA = 'Y'                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     GHSUBS        SCAN      TranInCovC                             99                  CSW209
     C                   IF        *in99                                                      CSW209
     C                   EVAL      RepCovC = 'Y'                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        (RepPrim = 'Y' OR RepSecA = 'Y' OR
     C                              RepSecB = 'Y' OR RepThir = 'Y' OR
     C                              RepPrmB = 'Y' OR RepThrB = 'Y' OR
     C                              RepFour = 'Y' OR RepMarg = 'Y')
     C                   EXSR      DtaSubs
     C                   endif

     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   IF        (RepCovA = 'Y' OR RepCovC = 'Y')                           CSW209
     C                   EXSR      DtaSubs                                                    CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   endif
      **                 (End of "if GHSUBS <> *blank")

     C                   EXSR      SetupAmend
     C                   EXSR      ValidateTr
     C                   EXSR      ValdateAmd

     C                   ENDSL
      *
     C                   IF        Idx <> 0 AND UpdateYN <> 'Y' AND                           CRE067
     C                             SVALBD = 'Y'                                               CRE067
                                                                                              CRE067
     C                   Z-ADD     1             X                 3 0                        CRE067
     C                   RESET                   WFldNamXAr                                   CRE067
     C                   RESET                   WMsgIDXAr                                    CRE067
     C                   RESET                   WMsgDtaXAr                                   CRE067
                                                                                              CRE067
     C     X             DOUEQ     Idx                                                        CRE067
     C                   IF        FldNameArr(X) <> *BLANKS                                   CRE067
                                                                                              CRE067
     C     FldNameArr(X) LOOKUP    BSCDTLS                                99                  CRE067
     C     *IN99         IFEQ      *ON                                                        CRE067
     C                   MOVEA     FldNameArr(X) WFldNamXAr(X)                                CRE067
     C                   MOVEA     MsgIdArr(X)   WMsgIDXAr(X)                                 CRE067
     C                   MOVEA     MsgDtaArr(X)  WMsgDtaXAr(X)                                CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ENDIF                                                                CRE067
     C                   ADD       1             X                                            CRE067
     C                   ENDDO                                                                CRE067
                                                                                              CRE067
     C                   RESET                   FldNameArr                                   CRE067
     C                   RESET                   MsgIdArr                                     CRE067
     C                   RESET                   MsgDtaArr                                    CRE067
                                                                                              CRE067
     C                   MOVEA     WFldNamXAr    FldNameArr                                   CRE067
     C                   MOVEA     WMsgIDXAr     MsgIdArr                                     CRE067
     C                   MOVEA     WMsgDtaXAr    MsgDtaArr                                    CRE067
                                                                                              CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C     INVALID       TAG

      ** Populate Account Details                                                             CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

     C                   MOVEL     OTOPMSGR      PMSGR             8                          CSD083
     C                   MOVEL     RegData       RegData1          2                          CSF011
     C                   MOVE      RegData       RegData2         18                          CSF011
     C**********         MOVEL     TranInExtn    TranInExtn1      19                 CFT120 MD033098
     C**********         MOVE      TranInExtn    TranInExtn2       1                 CFT120 MD033098
     C**********         MOVEL     TranInExtn    TranInExtn1       9              MD033098 MD050928A
     C**********         MOVE      TranInExtn    TranInExtn2      11              MD033098 MD050928A
     C                   MOVEL     TranInExtn    TranInExtn1      19                       MD050928A
     C                   MOVE      TranInExtn    TranInExtn2       1                       MD050928A
     C                   EVAL                    Buffer =
     C                                             TranInPrim + TranInPrmB
     C                                           + TranInSecA + TranInSecB
     C                                           + TranInThir + TranInThrB
     C                                           + TranInFour + TranInMarg
     C                                           + MT110GEN + SMTCN                           CFT116
     C**********                                 + SCHQN                               CFT116 CFT118
     C**********                                 + SCHQN + SCQIN                       CFT118 CFT118
     C                                           + SCHQN + SCQIN + OTCQIN                     CFT118
     C                                           + TranInCovA + TranInCovC                    CSW209
     C                                           + TranInMarA + TranInMarB                    CER030
     C                                           + @TimeStamp                                BUG4196
     C                                           + PMSGR + OTOPORB1 + OTOPORB2                CSD083
     C                                           + OTOPORB3 + OTOPORB4                        CSD083
     C                                           + OTOPORB5                                   CSD083
     C**********                                 + OTORBT                           CSD083 AR1077978
     C                                           + OTOPORBT                                AR1077978
     C**********                                 + TranInExtn                          CER049 CFT120
     C**********                                 + RegData                             CER001 CSF011
     C**********                                 + RegData1                            CSF011 CFT120
     C                                           + TranInExtn1                                CFT120
                                                                                              CSF011
     C**********         EVAL      Buffer2 =  RegData2                                 CSF011 CFT120
     C**********         EVAL      Buffer2 =  TranInExtn2 + AAuth +                  CFT120 MD042042
     C**********                              BtnPressed +                         MD039986 MD042042
     C**********                              RegData + ExtData                      CFT120 MD042042
     C                   EVAL      Buffer2 =  TranInExtn2 + AAuth                           MD042042
     C                                        + BtnPressed                                  MD042042
     C                                        + ExtData                                     MD042042
     C                                        + InputUser                                   MD042042
     C                                        + RegData                                     MD042042
     C                                        + StopFTDta                                   MD050928
                                                                                              CSF011
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     SACTION       IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C     SPREF         IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             SACTION = 'I'                                            AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF                                                              AR971184

      * Validate action code versus transaction IDs supplied
      * This function will set up the Midas payment reference.
      *
      * The transaction in file format from the FT database
      * is retrieved as well.

      * Input is Level 1
     C                   MOVE      '1'           @Level            1

     C                   RESET                   ReturnCode
     C                   CALLB     'FTOPAYRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE

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
     C                   PARM                    Val@Fields

      * OUTPUTS

      * (Current) transaction in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX

      * OK - Action code
     C                   PARM                    OKACTION

      * OK - Payment reference
     C                   PARM                    OKPREF

      * OK - Booking branch
     C                   PARM                    OKBRCA

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C/COPY WNCPYSRC,FTOPAYVUCA
      *                                                                                       CER001
      ** Retrieve outgoing payment extension details                                          CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   CALLB     'FTOPAY3RV'                                                CER001
      *                                                                                       CER001
      ** Inputs                                                                               CER001
      *                                                                                       CER001
      ** Return code                                                                          CER001
      *                                                                                       CER001
     C                   PARM      *Blanks       PRetCodeIn                                   CER001
      *                                                                                       CER001
      ** Action Code                                                                          CER001
      *                                                                                       CER001
     C                   PARM      SACTION       PActn                                        CER001
      *                                                                                       CER001
      ** Front Office Transaction ID                                                          CER001
      *                                                                                       CER001
     C                   PARM      APFOTranID    PFrontID                                     CER001
      *                                                                                       CER001
      ** Payment Reference                                                                    CER001
      *                                                                                       CER001
     C                   PARM      SPREF         PPayRef                                      CER001
      *                                                                                       CER001
      ** Outputs                                                                              CER001
      *                                                                                       CER001
      ** outgoing payment extension details                                                   CER001
      *                                                                                       CER001
     C                   PARM                    PSvRcdX                                      CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,FTOPAYVUC9

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
     C                   MOVE      PmntFilFmX    ValidPmntB

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
     C                   PARM                    PmntFilFmX

      * OUTPUTS
      * (Current) Payment in screen format
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrPrm2
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThrd
     C                   PARM                    CurTrFour
     C                   PARM                    CurTr5th
     C                   PARM                    CurTr6th
     C                   PARM                    CurTr7th
     C                   PARM                    CurTrCovA                                    CSW209
     C                   PARM                    CurTrCovC                                    CSW209
     C                   PARM                    CurTr7Ath                                    CER030
     C                   PARM                    CurTr7Bth                                    CER030
     C                   PARM                    SDFTFR

      *  Validation Work Fields
     C                   PARM                    Val@Fields

      * Status
     C                   PARM                    PmntStatus       24

      * Msg Unique Reference
     C                   PARM                    SHMSGR
      * Part Number
     C                   PARM                    SHPART
     C                   PARM      *BLANKS       BtnPressed                                AR1090283
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

     C                   EXSR      ValdL1Detl
      *                                                                                       CFT045
      ** Default Outgoing Payments Extended Settlement Instructions details                   CFT045
      *                                                                                       CFT045
     C                   IF        OKPCCY = 'Y' AND OKBNC1 = 'Y' AND                          CFT045
     C                             CFT045 = 'Y'                                               CFT045
     C                   EXSR      DeftESDetl                                                 CFT045
     C                   ENDIF                                                                CFT045
      *                                                                                       CFT045
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Level Two details if not blank, else assume Level One
      * input only.
      * Also validate level 2 details when 'level joiner' = 'Y'                               243991

     C     TranInSecA    IFNE      *BLANKS
     C     TranInSecB    ORNE      *BLANKS
     C     TranInThir    ORNE      *BLANKS
     C     TranInThrB    ORNE      *BLANKS
     C     TranInFour    ORNE      *BLANKS
     C     TranInMarg    ORNE      *BLANKS
     C     TranInMarA    ORNE      *BLANKS                                                    CER030
     C     TranInMarB    ORNE      *BLANKS                                                    CER030
     C     RegData       ORNE      *BLANKS                                                    CER001
     C     BTLVJN        OREQ      'Y'                                                        243991

     C                   EXSR      ValdL2Detl
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      ** Validate Screen 3 Level 2 details

     C                   ExSr      ValdS3Detl

      ** If error in validation, fail this input

     C     Idx           IfNe      0
     C                   Goto      EValidTr
     C                   EndIf

      * Validate Charges/Commission details
      *  - Default values
     C                   IF        @CFT009 = 'N'
     C                   EXSR      DeftCCDetl
     C                   ENDIF

     C                   EXSR      ValdCCDetl
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      ** Validate Margin Info

     C                   ExSr      ValdMargin

      ** Ensure currencies for charges screen are derived

     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'                                                       BUG6280
     C                   ExSr      GetChgCcys
     C                   ENDIF

      ** If error in validation, fail this input

     C     Idx           IfNe      0
     C                   Goto      EValidTr
     C                   EndIf

     C                   IF        CSW209 = 'Y'                                               CSW209
                                                                                              CSW209
      ** Validate Cover Message info                                                          CSW209
                                                                                              CSW209
     C                   ExSr      ValdCoverA                                                 CSW209
                                                                                              CSW209
      ** If error in validation, fail this input                                              CSW209
                                                                                              CSW209
     C     Idx           IfNe      0                                                          CSW209
     C                   Goto      EValidTr                                                   CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      ** Validate Cover Message info                                                          CSW209
                                                                                              CSW209
     C                   ExSr      ValdCoverC                                                 CSW209
                                                                                              CSW209
      ** If error in validation, fail this input                                              CSW209
                                                                                              CSW209
     C     Idx           IfNe      0                                                          CSW209
     C                   Goto      EValidTr                                                   CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      ** Validate outgoing payment extension details                                          CER001
                                                                                              CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EXSR      ValdOutPymntX                                              CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C     Idx           IFNE      0                                                          CER001
     C                   GOTO      EValidTr                                                   CER001
     C                   END                                                                  CER001
                                                                                              CER001
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
     C/COPY OFCPYSRCZ,CFT148_008                                                              CFT148

     C                   CALLB     'FTOPAY1VL'
      * Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
     C                   PARM                    CurTrPrim
     C                   PARM                    TranInPrmB
     C                   PARM                    CurTrPrm2
     C                   PARM      APFOTRANID    FrontOffice      20
     C                   PARM                    TRANINFOUR
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
     C                   PARM                    ValidPmntB
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
      * Msg Unique Reference
     C                   PARM                    SHMSGR
      * Part Number
     C                   PARM                    SHPART
      *  Saved default charges
     C                   PARM                    DEFVALID
     C                   PARM                    DEFVALIDX
      *  Funds Transfer Details                                                               257758
     C                   PARM                    SDFTFR                                       257758
     C                   PARM                    InputUser                                  MD042042
                                                                                              257758
     C/COPY WNCPYSRC,FTOPAYVUC7



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
     C                   PARM      'S'           APRespMode
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
      * Level 2 details
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInPrmB
     C                   PARM                    TranInThir
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
     C                   PARM                    ValidPmntB
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

     C                   CALLB     'FTOPAY3DT'
      *
      * INPUTS :
      * Response mode
     C                   PARM      'S'           APRespMode

      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
      * Level 2 details
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
      * Charges / Commissions details
     C                   PARM                    TranInThir
     C                   PARM                    TranInFour
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    PmntFilFmt

      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      *  Funds transfer Details
     C                   Parm                    SDFTFR
      *
      ** Recalcution flag.
     C                   PARM                    PReCalc           1

      * OUTPUTS :

      ** OK inds
     C                   PARM                    OKFlag1DS
     C                   PARM                    OKFlag4DS

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
      *  Extra rate required for FTVCHPY module
     C                   Parm                    O2XRTE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CFT045
      *                                                               *                       CFT045
      * DeftESDetl - Routine to default Outgoing Payments             *                       CFT045
      *              Extended Settlement Instructions Details         *                       CFT045
      *                                                               *                       CFT045
      *****************************************************************                       CFT045
     C     DeftESDetl    BEGSR                                                                CFT045
      *                                                                                       CFT045
     C                   CALLB     'FTOPAY2DT'                                                CFT045
      *                                                                                       CFT045
      ** Transaction information (DS) from source system (Level 1)                            CFT045
      *                                                                                       CFT045
     C                   PARM                    TranInPrim                                   CFT045
      *                                                                                       CFT045
      ** Level 2 details                                                                      CFT045
      *                                                                                       CFT045
     C                   PARM                    TranInSecA                                   CFT045
     C                   PARM                    TranInSecB                                   CFT045
     C                   PARM                    TranInPrmB                                   CFT045
      *                                                                                       CFT045
      ** Charges / Commissions details                                                        CFT045
      *                                                                                       CFT045
     C                   PARM                    TranInThir                                   CFT045
     C                   PARM                    TranInFour                                   CFT045
      *                                                                                       CFT045
     C                   ENDSR                                                                CFT045
      *****************************************************************                       CFT045
      /EJECT                                                                                  CFT045
      *****************************************************************
      *                                                               *
      * ValdS3Detl - Routine to validate Screen 3 Level 2             *
      *              (This corresponds to the third input screen)     *
      *****************************************************************
     C     ValdS3Detl    BEGSR
      ** Translate lowercase Details of Payment input to uppercase              250345
      ** to be recognized in validation                                         250345
     C**********         EVAL      TranSec1 =                                   250345      MD041641
     C**********                   %XLATE(LowerCase:UpperCase:TranInThir)       250345      MD041641
     C**********         EVAL      TranInThir = TranSec1                        250345      MD041641

     C                   CALLB     'FTOPAY3VL'
      * Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
      * Level 2 details
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInThir
     C                   PARM                    TranInPrmB
     C                   PARM                    TranInThrB
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
     C                   PARM                    ValidPmntB
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
     C                   PARM                    InputUser                                  MD042042


     C                   ENDSR

      *****************************************************************
      /Title Sr/ValdCCDetl
      *****************************************************************
      *                                                               *
      * SR/ValdCCDetl - Validate Charges and Commissions Details      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  FTOPAY4VL  - Charges and Commissions validation module       *
      *                                                               *
      *****************************************************************

     C     ValdCCDetl    BegSr

     C                   CallB     'FTOPAY4VL'
     C                   Parm      'S'           APRespMode
     C                   Parm                    TranInPrim
     C                   Parm                    TranInSecA
     C                   Parm                    TranInSecB
     C                   Parm                    TranInThir
     C                   Parm                    TranInPrmB
     C                   Parm                    TranInThrB
     C                   Parm                    TranInFour
     C                   Parm                    ExtData
     C                   PARM                    PReDspChg         1
     C                   Parm                    OKFlag4DS
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
     C                   Parm                    ValidPmnt
     C                   Parm                    ValidPmntB
     C                   Parm                    Val@Fields
      *  Saved default charges
     C                   PARM                    DEFVALID
     C                   PARM                    DEFVALIDX
      *
      ** Charges to the debit of - field changed (Y or blank)
     C                   PARM                    PCDROCHG          1
     C                   PARM                    InputUser                                  MD042042

     C                   EndSr

      *****************************************************************
      /Title Sr/ValdMargin
      *****************************************************************
      *                                                               *
      * SR/ValdMargin - Validate Margin Info                          *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  FTOPAY5VL  - Margin Info validation module                   *
      *                                                               *
      *****************************************************************

     C     ValdMargin    BegSr

     C                   CallB     'FTOPAY5VL'
     C                   Parm      'S'           APRespMode
     C                   Parm                    TranInPrim
     C                   Parm                    TranInMarg
     C                   PARM                    TranInMarA                                   CER030
     C                   PARM                    TranInMarB                                   CER030
     C                   PARM                    STRTC                                        CER030
     C                   Parm                    ExtData
     C                   Parm                    OKFlag5DS
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
     C                   Parm                    ValidPmnt
     C                   Parm                    Val@Fields
     C                   PARM                    O2TTCD                                       CER030

     C                   EndSr

      *****************************************************************
      /EJECT
      /Title Sr/ValdCoverA                                                                    CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/ValdCoverA - Validate Cover Message Info                   *                       CSW209
      *                                                               *                       CSW209
      * Called By: Main Routine                                       *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *  FTOPAYAVL  - Cover Message info validation module            *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     ValdCoverA    BegSr                                                                CSW209
                                                                                              CSW209
     C                   CallB     'FTOPAYAVL'                                                CSW209
     C                   Parm      'S'           APRespMode                                   CSW209
     C                   Parm                    TranInPrim                                   CSW209
     C                   Parm                    ValidPmnt                                    CSW209
     C                   Parm                    ValidPmntB                                   CSW209
     C                   Parm                    TranInCovA                                   CSW209
     C                   Parm                    OKFlagADS                                    CSW209
     C                   Parm                    FldNameArr                                   CSW209
     C                   Parm                    MsgIDArr                                     CSW209
     C                   Parm                    MsgDtaArr                                    CSW209
     C                   Parm                    Idx                                          CSW209
     C                   Parm                    WFldNamArr                                   CSW209
     C                   Parm                    WMsgIDArr                                    CSW209
     C                   Parm                    WMsgDtaArr                                   CSW209
     C                   Parm                    WIdx                                         CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      /Title Sr/ValdCoverC                                                                    CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/ValdCoverC - Validate Cover Message Info                   *                       CSW209
      *                                                               *                       CSW209
      * Called By: Main Routine                                       *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *  FTOPAYCVL  - Cover Message info validation module            *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     ValdCoverC    BegSr                                                                CSW209
                                                                                              CSW209
     C                   CallB     'FTOPAYCVL'                                                CSW209
     C                   Parm      'S'           APRespMode                                   CSW209
     C                   Parm                    ValidPmnt                                    CSW209
     C                   Parm                    ValidPmntB                                   CSW209
     C                   Parm                    TranInPrim                                   CSW209
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   Parm                    TranInSecA                                 BUG26548
     C                   Parm                    TranInSecB                                   CSW209
     C                   Parm                    TranInThir                                   CSW209
     C                   Parm                    TranInCovA                                   CSW209
     C                   Parm                    TranInCovC                                   CSW209
     C                   Parm                    OKFlagCDS                                    CSW209
     C                   Parm                    FldNameArr                                   CSW209
     C                   Parm                    MsgIDArr                                     CSW209
     C                   Parm                    MsgDtaArr                                    CSW209
     C                   Parm                    Idx                                          CSW209
     C                   Parm                    WFldNamArr                                   CSW209
     C                   Parm                    WMsgIDArr                                    CSW209
     C                   Parm                    WMsgDtaArr                                   CSW209
     C                   Parm                    WIdx                                         CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR


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
     C                   PARM                    TranInPrmB
     C                   PARM                    TranInThrB
     C                   PARM                    TranInFour
     C                   PARM                    TranInMarg
      * (Current) Payment in Screen Format
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThrd
     C                   PARM                    CurTrFour
     C                   PARM                    CurTrPrm2
     C                   PARM                    CurTr5th
     C                   PARM                    CurTr6th
     C                   PARM                    CurTr7th
      * (Current) Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag1DS
     C                   PARM                    OKFlag2DS
     C                   PARM                    OKFlag3DS
     C                   PARM                    OKFlag4DS
     C                   PARM                    OKFlag5DS
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
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValdOutPymntX - Routine to check outgoing payment extension   *                       CER001
      *                 details.                                      *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
                                                                                              CER001
     C     ValdOutPymntX BEGSR                                                                CER001
      *                                                                                       CER001
      ** populate PData                                                                       CER001
      *                                                                                       CER001
     C                   EVAL       #1FLD1 = *ZERO                                            CER001
     C                   EVAL       PREF1  = SPREF                                            CER001
     C                   EVAL       #1FOTR = APFOTRANID                                       CER001
     C                   EVAL       #1TMST = TMST                                             CER001
     C                   EVAL       #1ORCT = ORCT                                             CER001
     C                   EVAL       #1ORBK = SORBK                                            CER001
     C                   EVAL       #1ORC1 = SORC1                                            CER001
     C                   EVAL       #1SMCY = SSMCY                                            CER001
     C                   EVAL       #1ORBT = ORBT                                             CER001
     C                   EVAL       #1SMAM = SMAM                                             CER001
     C                   EVAL       #1PCCY = SPCCY                                            CER001
     C                   EVAL       #1SNCT = SNCT                                             CER001
     C                   EVAL       #1DSTT = DSTT                                             CER001
     C                   EVAL       #1DST1 = DST1                                             CER001
     C                   MOVEL     SNCO          #1SNCO                                       CER001
      *                                                                                       CER001
     C                   CALLB     'FTOPAY8VL'                                                CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PData                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKFlagXDS                                    CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    PValidPmntX                                  CER001
     C                   PARM                    PCuty                                        CER001
     C                   PARM                    PCust                                        CER001
     C                   PARM                    PSvRcdX                                      CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C                   IF        SACTION = 'I'
     C/COPY WNCPYSRC,FTOPAYVUC1
     C                   EXSR      SETUPPYREF
     C/COPY WNCPYSRC,FTOPAYVUC2
     C                   ENDIF

     C                   MOVEL     SPREF         OTPREF

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   MOVEL     OTPREF        SPREF                                      MD054059
     C                   ENDIF

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


      ** Initialise all OK flags to 'Y'

     C                   Eval      OKFlag1DS = (*All'Y')
     C                   Eval      OKFlag2DS = (*All'Y')
     C                   Eval      OKFlag3DS = (*All'Y')
     C                   Eval      OKFlag4DS = (*All'Y')
     C                   Eval      OKFlag5DS = (*All'Y')

     C                   RESET                   AmendOK

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidPmnt
     C                   CLEAR                   ValidPmntB
                                                                                             CSF011A
      ** Initialise Customer Name on input fields                                            CSF011A
                                                                                             CSF011A
     C                   EVAL      DDD1SN = *BLANKS                                          CSF011A
     C                   EVAL      DDD1NM = *BLANKS                                          CSF011A
     C                   EVAL      DDD1TN = *BLANKS                                          CSF011A
     C                   EVAL      DDD1AN = *BLANKS                                          CSF011A
     C                   EVAL      DDD1SW = *BLANKS                                          CSF011A
     C                   EVAL      DDRCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDRCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDRCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDRCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDRCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDBCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDBCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDBCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDBCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDBCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDTRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDTRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDTRTN = *BLANKS                                          CSF011A
     C                   EVAL      DDTRAN = *BLANKS                                          CSF011A
     C                   EVAL      DDTRSW = *BLANKS                                          CSF011A
     C                   EVAL      DDABSN = *BLANKS                                          CSF011A
     C                   EVAL      DDABNM = *BLANKS                                          CSF011A
     C                   EVAL      DDABTN = *BLANKS                                          CSF011A
     C                   EVAL      DDABAN = *BLANKS                                          CSF011A
     C                   EVAL      DDABSW = *BLANKS                                          CSF011A
     C                   EVAL      DDOCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDOCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDOCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDOCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDOCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDOBSN = *BLANKS                                          CSF011A
     C                   EVAL      DDOBNM = *BLANKS                                          CSF011A
     C                   EVAL      DDOBTN = *BLANKS                                          CSF011A
     C                   EVAL      DDOBAN = *BLANKS                                          CSF011A
     C                   EVAL      DDOBSW = *BLANKS                                          CSF011A
     C                   EVAL      DDSCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDSCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDSCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDSCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDSCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDIBSN = *BLANKS                                          CSF011A
     C                   EVAL      DDIBNM = *BLANKS                                          CSF011A
     C                   EVAL      DDIBTN = *BLANKS                                          CSF011A
     C                   EVAL      DDIBAN = *BLANKS                                          CSF011A
     C                   EVAL      DDIBSW = *BLANKS                                          CSF011A
     C                   EVAL      DDCDSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCDTN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDAN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDSW = *BLANKS                                          CSF011A

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

     C                   EXSR      SETPAYREF

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPREF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKPREF
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
     C                             Or (SACTION = 'S' and CFT157 = 'Y')                        CFT157
                                                                                              CFT157
     C                   MOVE      PmntFilFmt    ValidPmnt
     C                   MOVE      PmntFilFmX    ValidPmntB
     C                   ENDIF

     C                   IF        SACTION = 'S' AND CFT157 = 'Y'                             CFT157
     C                   IF        AAUTH = 'Y'                                                CFT157
     C                   EVAL      OTSUSR = WUSRID                                            CFT157
     C                   ELSE                                                                 CFT157
     C                   EVAL      OTSAUS = WUSRID                                            CFT157
     C                   EVAL      OTSUSR = SSUSR                                             CFT157
     C                   ENDIF                                                                CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      OTCHTP = SACTION
     C                   EVAL      OTRECI = 'D'

      * Include Header fields that need to be o/p to the Valid file
                                                                                              244537
      * Do not override header fields from existing transaction.                              244537
     C**********         IF        SACTION = 'I'                                    244537 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      OTFRNT = APFOTranID
     C                   EVAL      OTREPA = APRprLocn
                                                                                              244537
     C                   ENDIF                                                                244537

      ** Setup valid extension file

     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')
     C                             OR (@CFT009 = 'Y')
     C                   Eval      O2RECI = 'D'
     C                   Eval      O2PREF = OTPREF
     C                   Eval      O2FRNT = APFOTranID
     C                   Eval      O2REPA = APRprLocn
     C                   If        (SACTION = 'I') Or (SACTION = 'A')
     C/COPY WNCPYSRC,FTH00400
     C                   Eval      O2AUTO = 'N'
     C/COPY WNCPYSRC,FTH00401
     C                   EndIf
     C                   EndIf
                                                                                             BUG4196
     C/COPY WNCPYSRC,FTH00548
      * Restore Timestamp from the original record                                           BUG4196
     C                   IF        SACTION <> 'I'                                            BUG4196
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    OTTMESTMP                                   BUG4196
     C                   ENDIF                                                               BUG4196

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR

      ** Set up fields on Val@Fields
     C                   EXSR      SetParms

     C                   CALLB     'FTOPAYUPD'
      *  Return Code
     C                   PARM                    @@RTCD           10

      *  OK Flags
     C                   Parm                    OKFlag1DS
     C                   Parm                    OKFlag2DS
     C                   Parm                    OKFlag3DS
     C                   Parm                    OKFlag4DS
     C                   Parm                    OKFlag5DS

      * New Valid payment layout
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmntB

      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *                                                                                       CAP211
     C                   PARM                    AAuth                                        CAP211
     C                   PARM                    APUSERID                                     CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTH00402
      *                                                                                     BUG18500
     C                   IF        OTTMESTMP <>  TimeStampZ                                 BUG18500
     C                   MOVEL     OTTMESTMP     @TimeStamp                                 BUG18500
     C                   ENDIF                                                              BUG18500
     C/COPY WNCPYSRC,FTOPAYVUCB
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' and                                           CER001
     C                             @@RTCD = *Blanks                                           CER001
     C                   EVAL      #LLXOPPREF = OTPREF                                        CER001
     C                   CALLB     'FTOPAY2UP'                                                CER001
     C                   PARM                    PActn                                        CER001
     C     @@RTCD        PARM      @@RTCD        PRetCodeIn                                   CER001
     C                   PARM                    PFind                                        CER001
     C                   PARM                    PValidPmntX                                  CER001
     C                   PARM                    PSvRcdX                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,FTOPAYVUC8
      *
      * If there were any errors in the update functions, rollbcak any
      * updates and end this program. Otherwise, commit the updates
      *
     C*****@RTCD         IFNE      *BLANK                                                     242863
     C*****@RTCD         ANDNE     '*RECUPD'                                                  242863
     C     @@RTCD        IFNE      *BLANK                                                     242863
     C     @@RTCD        ANDNE     '*RECUPD'                                                  242863
     C                   MOVEL     '0'           APIRetc
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
     C/COPY WNCPYSRC,FTOPAYVU10                                                               CFT118
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C*****@RTCD         IFEQ      '*RECUPD'                                                  242863
     C     @@RTCD        IFEQ      '*RECUPD'                                                  242863
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetParms - Set up of fields required to be passed to FTOPAYUPD*
      *                                                               *
      *****************************************************************
     C     SetParms      BEGSR

      * Charges branch
      * If single branch...
     C                   If        @MBIN = 'N'
     C                   Eval      @PYBR = BJSBRC

     C                   Else
      * Else,if multi branched...
     C                   MOVEL     'Y'           BKOBRU            1
     C                   If        @MBIN = 'Y' and
     C                             BKOBRU = 'Y'
     C                   Eval      @PYBR = OTORBR
     C                   Else
     C                   Eval      @PYBR = OTBRCA
     C                   End

     C                   End
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

     **  Convert rundate to YYMMDD format.
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
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
     C                   END

     C                   MOVE      IPREF         SPREF

      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetChgCcys - Set up Charges and Commissions currency by       *
      *              calling CVT module during insert                 *
      *                                                               *
      *****************************************************************

     C     GetChgCcys    BEGSR

      * Save fields before calling FTOPAYCVT to get charge currencies

     C                   CALLB     'FTOPAYCVT'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Payment in file format
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmntB

      * OUTPUTS
      * (Current) Payment in screen format
     C                   PARM                    CurTrPrim@
     C                   PARM                    CurTrPrm2@
     C                   PARM                    CurTrSeco@
     C                   PARM                    CurTrThrd@
     C                   PARM                    CurTrFour@
     C                   PARM                    CurTr5th@
     C                   PARM                    CurTr6th@
     C                   PARM                    CurTr7th@
     C                   PARM                    CurTrCovA@                                   CSW209
     C                   PARM                    CurTrCovC@                                   CSW209
     C                   PARM                    CurTr7AthCp                                  CER030
     C                   PARM                    CurTr7BthCp                                  CER030
     C                   PARM                    SDFTFR

      *  Validation Work Fields
     C**********         PARM                    Val@Fields@                                 BUG4163
     C                   PARM                    Val@Fields                                  BUG4163

      * Status
     C                   PARM                    PmntStatus@      24

      * Msg Unique Reference
     C                   PARM                    SHMSGR@
      * Part Number
     C                   PARM                    SHPART@
     C                   PARM      *BLANKS       BtnPressed                                AR1090283

      ** Move necessary currency and amounts

     C                   MOVE      @CSTRCM       STRCM
     C                   MOVE      @CSCHCM       SCHCM                                       BUG6864
     C                   MOVE      @CSTXCH       STXCH
     C                   MOVE      @CSCQCH       SCQCH
     C                   MOVE      @CSCSTA       SCSTA
     C                   MOVE      @CSTCH        STCH
     C                   MOVE      @CSSPCH       SSPCH
     C                   MOVE      @CSMSCH       SMSCH
     C                   MOVE      @CSMISC1      SMISC1
     C                   MOVE      @CSMISC2      SMISC2
     C                   MOVE      @CSMISC3      SMISC3
     C                   MOVE      @CSMISC4      SMISC4
     C                   MOVE      @CSMISC5      SMISC5
     C                   MOVE      @CSTOTVA      STOTVA
     C                   MOVE      @CSTOTVB      STOTVB
     C                   MOVE      @CSCCYA1      SCCYA1
     C                   MOVE      @CSCCYA2      SCCYA2
     C                   MOVE      @CSCCYA3      SCCYA3
     C                   MOVE      @CSCCYB1      SCCYB1
     C                   MOVE      @CSCCYB2      SCCYB2
     C                   MOVE      @CSCCYB3      SCCYB3

     C                   ENDSR
     C/COPY WNCPYSRC,FTOPAYVUC3
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
     C                   callb     'FTOPAYCVT'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Payment in file format
     C                   PARM                    PmntFilFmt
     C                   PARM                    PmntFilFmX

      * OUTPUTS
      * (Current) Payment in screen format
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrPrm2
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThrd
     C                   PARM                    CurTrFour
     C                   PARM                    CurTr5th
     C                   PARM                    CurTr6th
     C                   PARM                    CurTr7th
     C                   PARM                    CurTrCovA                                    CSW209
     C                   PARM                    CurTrCovC                                    CSW209
     C                   PARM                    CurTr7Ath                                    CER030
     C                   PARM                    CurTr7Bth                                    CER030
     C                   PARM                    SDFTFR

      *  Validation Work Fields
     C                   PARM                    Val@Fields

      * Status
     C                   PARM                    PmntStatus       24

      * Msg Unique Reference
     C                   PARM                    SHMSGR
      * Part Number
     C                   PARM                    SHPART
     C                   PARM      *BLANKS       BtnPressed                                AR1090283
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
     C                   PARM      CurTrPrim     CurData        2000

     C                   MOVEL     IncDATA       TranInPrim

     C                   endif

     C                   if        RepSecA = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSecA    IncData
      * Current Data
     C                   PARM      CurTrSeco     CurData

     C                   MOVEL     IncDATA       TranInSecA

     C                   endif

     C                   if        RepSecB = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSecB    IncData
      * Current Data
     C                   PARM      CurTrThrd     CurData

     C                   MOVEL     IncDATA       TranInSecB

     C                   endif

     C                   if        RepThir = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInThir    IncData
      * Current Data
     C                   PARM      CurTrFour     CurData

     C                   MOVEL     IncDATA       TranInThir

     C                   endif

     C                   If        RepPrmB = 'Y'
     C                   Clear                   IncData
     C                   Clear                   CurData
     C                   Reset                   ReturnCode

     C                   CallB     'APDTASUBS'
     C                   Parm                    ReturnCode
     C                   Parm                    GHSUBS
     C                   Parm      TranInPrmB    IncData
     C                   Parm      CurTrPrm2     CurData

     C                   Movel     IncDATA       TranInPrmB
     C                   EndIf

     C                   If        RepThrB = 'Y'
     C                   Clear                   IncData
     C                   Clear                   CurData
     C                   Reset                   ReturnCode

     C                   CallB     'APDTASUBS'
     C                   Parm                    ReturnCode
     C                   Parm                    GHSUBS
     C                   Parm      TranInThrB    IncData
     C                   Parm      CurTr5th      CurData

     C                   Movel     IncDATA       TranInThrB
     C                   EndIf

     C                   If        RepFour = 'Y'
     C                   Clear                   IncData
     C                   Clear                   CurData
     C                   Reset                   ReturnCode

     C                   CallB     'APDTASUBS'
     C                   Parm                    ReturnCode
     C                   Parm                    GHSUBS
     C                   Parm      TranInFour    IncData
     C                   Parm      CurTr6th      CurData

     C                   Movel     IncDATA       TranInFour
     C                   EndIf

     C                   If        RepMarg = 'Y'
     C                   Clear                   IncData
     C                   Clear                   CurData
     C                   Reset                   ReturnCode

     C                   CallB     'APDTASUBS'
     C                   Parm                    ReturnCode
     C                   Parm                    GHSUBS
     C                   Parm      TranInMarg    IncData
     C                   Parm      CurTr7th      CurData

     C                   Movel     IncDATA       TranInMarg
     C                   EndIf

     C                   endsr

      *****************************************************************
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer fields for retrieval of details                                             CSF011
                                                                                              CSF011
     C                   EVAL      W@ATyp = ' '                                             AR870195
     C                   EVAL      %SUBST(WNumDetlIn:1:70)   = SDST1 + SDST2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:70)  = SRCO1 + SRCO2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:141:70) = SBNC1 + SBNC2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:70) = STRI1 + STRI2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:70) = SACB1 + SACB2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:351:70) = SORBK                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:421:70) = SORC1 + SORC2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:491:70) = SSNCO                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:561:70) = SINB1 + SINB2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:631:70) = SCDRO                          CSF011
                                                                                              CSF011
      ** Determine third line to identify account type with blank value                       CSF011
                                                                                              CSF011
     C                   EVAL      %SUBST(WNumDetLn3:1:35)   = SDST3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:36:35)  = SRCO3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:71:35)  = SBNC3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:106:35) = STRI3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:141:35) = SACB3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:176:35) = *BLANKS                        CSF011
     C                   EVAL      %SUBST(WNumDetLn3:211:35) = SORC3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:246:35) = *BLANKS                        CSF011
     C                   EVAL      %SUBST(WNumDetLn3:281:35) = SINB3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:316:35) = *BLANKS                        CSF011
     C                                                                                        CSF011
                                                                                              CSF011
      ** Customer fields for retrieval type indicator                                         CSF011
                                                                                              CSF011
     C**********         EVAL      %SUBST(WAccntType:1:10) = @DSTT + @RCRT           CSF011 AR870195
     C**********                   + @BNCT + @TRIT + @ACBT + @ORBT + @ORCT           CSF011 AR870195
     C**********                   + @SNCT + @INBT + @CDRT                           CSF011 AR870195
                                                                                              CSF011
     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
                                                                                              CSF011
     C                   EVAL      W@ATyp = ' '                                            AR1070111
     C                   EVAL      WCustomer = *BLANKS                                     AR1067499
     C                   EVAL      WAccName  = *BLANKS                                     AR1067499
     C                   EVAL      W@Slash = 'N'                                              CSF011
     C**********         EVAL      W@ATyp = %SUBST(WAccntType:CusIdx:1)              CSF011 AR870195
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
     C                   EVAL      P@Str2 = %SUBST(WNumDetlIn:CusIdx2+35:35)                  CSF011
     C                   EVAL      P@Str3 = %SUBST(WNumDetLn3:CusIdx3:35)                     CSF011
     C                   IF        %SUBST(P@Str:1:1) = '/'                                    CSF011
     C                   EVAL      W@Slash = 'Y'                                              CSF011
     C                   IF        P@Str2 <> *BLANKS                                          CSF011
     C                   EVAL      P@Str = P@Str2                                             CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      P@Str= %SUBST(P@Str:2:34)                                  CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C**********         IF        W@ATyp = *BLANKS                                  CSF011 AR870195
     C                   IF        (W@Slash = 'Y' AND P@Str3 <> *BLANKS)                      CSF011
     C                             OR (W@Slash = 'N' AND P@Str2 <> *BLANKS)                   CSF011
     C                   EVAL      W@ATyp = 'A'                                               CSF011
     C                   ENDIF                                                                CSF011
     C**********         ENDIF                                                       CSF011 AR870195
                                                                                              CSF011
     C                   IF        P@Str <> *BLANKS                                           CSF011
     C                             AND  W@ATyp <> 'A'                                         CSF011
                                                                                              CSF011
      ** Check if IBAN                                                                        CSF011
                                                                                              CSF011
     C                   CALL      'AOIBANR2'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
     C                   EVAL      WAccName = AC_ANAM                                        CSF011A
                                                                                              CSF011
     C                   ELSE                                                                 CSF011
                                                                                              CSF011
      ** Format Full GL Account                                                               CSF011
      ** Format Partial Account                                                               CSF011
      ** Format Nostro Account                                                                CSF011
                                                                                              CSF011
     C                   EVAL      W@CCY = SSMCY                                              CSF011
     C                   EVAL      W@BRC = SORBB                                              CSF011
                                                                                              CSF011
     C                   IF        CusIdx = 8 AND SPCCY <> *BLANKS                            CSF011
     C                   EVAL      W@CCY = SPCCY                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        CusIdx = 10                                                CSF011
                                                                                              CFT120
     C                   IF        CFT120 = 'N'                                               CFT120
     C                   EVAL      W@CCY = BJCYCD                                             CSF011
     C                   ELSE                                                                 CFT120
     C                   EVAL      W@CCY = SCDRC                                              CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT120
     C                   EVAL      W@BRC = SCDBR                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 24                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:22:3)                                 CSF011
     C                             + %SUBST(P@Str:1:21)                                       CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 21                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +                               CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                    CSF011
     C                   EVAL      P@Str = W@BRC +                                            CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                     CSF011
     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)                          CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
      ** Retrieve Account Details, Customer Report Name,                                      CSF011
      ** and Town, Account Name and Swift ID                                                  CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
     C                             P@TYP = '*LEDGER'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
     C                   EVAL      WAccName = AC_ANAM                                        CSF011A
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = A7CUST                                         CSF011
     C                   CALL      'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      *BLANKS       P0RETL                                       CSF011
     C                   PARM                    A7CUST                                       CSF011
     C                   PARM                    A7CYCD                                       CSF011
     C                   PARM                    A7ACCD                                       CSF011
     C                   PARM                    A7ACSN                                       CSF011
     C                   PARM                    A7BRCD                                       CSF011
     C     ACCNT         PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD =  *BLANKS                                           CSF011
     C                   EVAL      WAccName = AC_ANAM                                        CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
     C                             P@TYP = '*SWIFT ' OR                                     MD044395
     C                             P@TYP = '*SHNAME'                                          CSF011
                                                                                              CSF011
     C                   EVAL      SDCUST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   EVAL      WAccName = *BLANKS                                        CSF011A
                                                                                            MD044395
     C                   IF        P@TYP = '*SWIFT '                                        MD044395
     C                             AND BBCSSN = *BLANKS                                     MD044395
     C                   EVAL      BBCSID = *BLANKS                                         MD044395
     C                   ENDIF                                                              MD044395
                                                                                            MD044395
     C                   WHEN      P@TYP = '*NRF   '                                          CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   EVAL      WAccName = *BLANKS                                        CSF011A
                                                                                            MD030906
     C                   WHEN      P@TYP = '*CNST'                                          MD030906
                                                                                            MD030906
     C                   EVAL      SDCNST = DSSDY                                           MD030906
     C                   EVAL      WCustomer = *BLANKS                                      MD030906
     C                   EVAL      WAccName = *BLANKS                                       MD030906
                                                                                            MD030906
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                      CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                             OR P@TYP = '*CNST'                                       MD030906
                                                                                             CSF011A
     C                   SELECT                                                              CSF011A
                                                                                             CSF011A
      ** Destination                                                                         CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDD1SN = AWCPNC                                          MD030906
     C                   EVAL      DDD1NM = AWCPNM                                          MD030906
     C                   EVAL      DDD1TN = AWCNTN                                          MD030906
     C                   EVAL      DDD1AN = *BLANKS                                         MD030906
     C                   EVAL      DDD1SW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDD1SN = BBCSSN                                           CSF011A
     C                   EVAL      DDD1NM = BBCRNM                                           CSF011A
     C                   EVAL      DDD1TN = BBCRTN                                           CSF011A
     C                   EVAL      DDD1AN = WAccName                                         CSF011A
     C                   EVAL      DDD1SW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Receivers correspondent                                                             CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDRCSN = AWCPNC                                          MD030906
     C                   EVAL      DDRCNM = AWCPNM                                          MD030906
     C                   EVAL      DDRCTN = AWCNTN                                          MD030906
     C                   EVAL      DDRCAN = *BLANKS                                         MD030906
     C                   EVAL      DDRCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDRCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDRCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDRCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDRCAN = WAccName                                         CSF011A
     C                   EVAL      DDRCSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Beneficiary                                                                         CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDBCSN = AWCPNC                                          MD030906
     C                   EVAL      DDBCNM = AWCPNM                                          MD030906
     C                   EVAL      DDBCTN = AWCNTN                                          MD030906
     C                   EVAL      DDBCAN = *BLANKS                                         MD030906
     C                   EVAL      DDBCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDBCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDBCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDBCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDBCAN = WAccName                                         CSF011A
     C                   EVAL      DDBCSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Third Reimbursement Institution                                                     CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDTRSN = AWCPNC                                          MD030906
     C                   EVAL      DDTRNM = AWCPNM                                          MD030906
     C                   EVAL      DDTRTN = AWCNTN                                          MD030906
     C                   EVAL      DDTRAN = *BLANKS                                         MD030906
     C                   EVAL      DDTRSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDTRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDTRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDTRTN = BBCRTN                                           CSF011A
     C                   EVAL      DDTRAN = WAccName                                         CSF011A
     C                   EVAL      DDTRSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Account with Bank                                                                   CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDABSN = AWCPNC                                          MD030906
     C                   EVAL      DDABNM = AWCPNM                                          MD030906
     C                   EVAL      DDABTN = AWCNTN                                          MD030906
     C                   EVAL      DDABAN = *BLANKS                                         MD030906
     C                   EVAL      DDABSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDABSN = BBCSSN                                           CSF011A
     C                   EVAL      DDABNM = BBCRNM                                           CSF011A
     C                   EVAL      DDABTN = BBCRTN                                           CSF011A
     C                   EVAL      DDABAN = WAccName                                         CSF011A
     C                   EVAL      DDABSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDOBSN = AWCPNC                                          MD030906
     C                   EVAL      DDOBNM = AWCPNM                                          MD030906
     C                   EVAL      DDOBTN = AWCNTN                                          MD030906
     C                   EVAL      DDOBAN = *BLANKS                                         MD030906
     C                   EVAL      DDOBSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDOBSN = BBCSSN                                           CSF011A
     C                   EVAL      DDOBNM = BBCRNM                                           CSF011A
     C                   EVAL      DDOBTN = BBCRTN                                           CSF011A
     C                   EVAL      DDOBAN = WAccName                                         CSF011A
     C                   EVAL      DDOBSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Ordering Customer                                                                   CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDOCSN = AWCPNC                                          MD030906
     C                   EVAL      DDOCNM = AWCPNM                                          MD030906
     C                   EVAL      DDOCTN = AWCNTN                                          MD030906
     C                   EVAL      DDOCAN = *BLANKS                                         MD030906
     C                   EVAL      DDOCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDOCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDOCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDOCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDOCAN = WAccName                                         CSF011A
     C                   EVAL      DDOCSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDSCSN = AWCPNC                                          MD030906
     C                   EVAL      DDSCNM = AWCPNM                                          MD030906
     C                   EVAL      DDSCTN = AWCNTN                                          MD030906
     C                   EVAL      DDSCAN = *BLANKS                                         MD030906
     C                   EVAL      DDSCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDSCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDSCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDSCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDSCAN = WAccName                                         CSF011A
     C                   EVAL      DDSCSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Intermediary Bank                                                                   CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDIBSN = AWCPNC                                          MD030906
     C                   EVAL      DDIBNM = AWCPNM                                          MD030906
     C                   EVAL      DDIBTN = AWCNTN                                          MD030906
     C                   EVAL      DDIBAN = *BLANKS                                         MD030906
     C                   EVAL      DDIBSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDIBSN = BBCSSN                                           CSF011A
     C                   EVAL      DDIBNM = BBCRNM                                           CSF011A
     C                   EVAL      DDIBTN = BBCRTN                                           CSF011A
     C                   EVAL      DDIBAN = WAccName                                         CSF011A
     C                   EVAL      DDIBSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Charges to the Debit of Account                                                     CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDCDSN = AWCPNC                                          MD030906
     C                   EVAL      DDCDNM = AWCPNM                                          MD030906
     C                   EVAL      DDCDTN = AWCNTN                                          MD030906
     C                   EVAL      DDCDAN = *BLANKS                                         MD030906
     C                   EVAL      DDCDSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDCDSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCDNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCDTN = BBCRTN                                           CSF011A
     C                   EVAL      DDCDAN = WAccName                                         CSF011A
     C                   EVAL      DDCDSW = BBCSID                                           CSF011A
     C                   ENDIF                                                              MD030906
     C                   ENDSL                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Increment counter fields                                                             CSF011
                                                                                              CSF011
     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
     C                   EVAL      CusIdx2 = Cusidx2 + 70                                     CSF011
     C                   EVAL      CusIdx3 = Cusidx3 + 35                                     CSF011
                                                                                              CSF011
     C                   CLEAR                   SDCUST                                      CSF011A
                                                                                             CSF011A
     C                   ENDDO                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
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
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005
     C                   PARM                    Trans5006
     C                   PARM                    Trans5007
     C                   PARM                    Trans5008
     C                   PARM                    Trans5009
     C                   PARM                    Trans5010                                    CSW209
     C                   PARM                    Trans5011                                    CSW209
     C                   PARM                    Trans5009B                                   262664
     C                   PARM                    Trans5009C                                   262664
     C                   PARM                    Trans5013                                    CFT039
     C                   PARM                    Trans5012                                    CER049

     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData
     C                   PARM                    StopFTDta                                  MD050928

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2        3999                          CSF011
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG4196
     C                   PARM                    AAuth             1                        BUG22150
     C                   PARM                    InputUser                                  MD042042

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'                                     CSW206

      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTOPAYM01

      * Clear fields used invalidation
     C                   Clear                   Val@Fields
      **********                                                                             BUG7029
      **GET*ZMUSER*to*access*default*branch.                                                 BUG7029
     C******DTAARA       Define                  ZMUSER                                      BUG7029
     C**********         In        ZMUSER                                                    BUG7029
     C**********         Unlock    ZMUSER                                                    BUG7029

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
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 001 *
     C                   Movel     '001'         DBASE
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
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 003 *
     C                   Movel     '003'         DBASE
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
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 004 *
     C                   Movel     '004'         DBASE
     C                   Movel     'CFT003'      DBKEY
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End

      ** Access SAR details file to see if CFT014 is installed.

     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT014'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 005 *
     C                   Movel     '005'         DBASE
     C                   Movel     'CFT014'      DBKEY
     C                   Exsr      *PSSR
     C                   EndIf

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT014
     C                   Else
     C                   Movel     'N'           @CFT014
     C                   EndIf

      * Access SAR details file to see if S01508 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01508'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 006 *
     C                   Movel     '006'         DBASE
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
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 007 *
     C                   Movel     '007'         DBASE
     C                   Movel     'S01506'      DBKEY
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01506
     C                   Else
     C                   Movel     'N'           @01506
     C                   End

      * Access SAR details file to see if CFT004 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT004'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT004
     C                   Else
     C                   Movel     'N'           @CFT004
     C                   End
      *
      * Access SAR details file to see if CFT009 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           @CFT009
     C                   ELSE
     C                   MOVEL     'N'           @CFT009
     C                   ENDIF
      *
      * Access SAR details file to see if CFT010 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT010'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           @CFT010
     C                   ELSE
     C                   MOVEL     'N'           @CFT010
     C                   ENDIF
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
      *                                                                                       CER001
      * Access SAR details file to see if ULX043 is installed.                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks and                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '008'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       @RTCD                                        CGL014
     C                   PARM      '*VERIFY'     @OPTN                                        CGL014
     C                   PARM      'CGL014'      @SARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 41                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        @RTCD = *BLANKS                                            CGL014
     C                   EVAL      @CGL014 = 'Y'                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      @CGL014 = 'N'                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014

      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       @RtCd                                        CSC022
     C                   Parm      '*VERIFY'     @Optn                                        CSC022
     C                   Parm      'CSC022'      @Sard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        @RtCd = *BLANKS                                            CSC022
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
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTOPAYVU'                                        CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
      ** Call SWIF2003 to check if CSW203 is installed                                        244540
                                                                                              244540
     C                   CALL      'SWIF2003'                                                 244540
     C                   PARM      *BLANKS       PRTCD                                        244540
      *                                                                                       244540
      ** If ret. code is "CSW203", set CSW203 flag to "Y", else set it to "N"                 244540
      *                                                                                       244540
     C                   IF        PRTCD = 'CSW2003'                                          244540
     C                   EVAL      CSW203 = 'Y'                                               244540
     C                   ELSE                                                                 244540
     C                   EVAL      CSW203 = 'N'                                               244540
     C                   ENDIF                                                                244540
      *                                                                                       244540
      ** Check if switchable feature CFT045 - Outgoing Payments                               CFT045
      **   Extended Settlement Instructions is on                                             CFT045
      *                                                                                       CFT045
     C                   CALLB     'AOSARDR0'                                                 CFT045
     C                   PARM      *BLANKS       @RTCD                                        CFT045
     C                   PARM      '*VERIFY'     @OPTN                                        CFT045
     C                   PARM      'CFT045'      @SARD                                        CFT045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT045
      *                                                                                       CFT045
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CFT045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT045
     C                   EVAL      DBKEY  = 'CFT045'                                          CFT045
     C                   EVAL      DBASE  = 42                                                CFT045
     C                   EXSR      *PSSR                                                      CFT045
     C                   ENDIF                                                                CFT045
      *                                                                                       CFT045
     C                   IF        @RTCD = *BLANKS                                            CFT045
     C                   EVAL      CFT045 = 'Y'                                               CFT045
     C                   ELSE                                                                 CFT045
     C                   EVAL      CFT045 = 'N'                                               CFT045
     C                   ENDIF                                                                CFT045
      *                                                                                       CFT045
     C/COPY OFCPYSRCZ,CFT148_009                                                              CFT148
     C/COPY WNCPYSRC,FTOPAYVUC4
      * Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   Eval      @BCDP = A6NBDP

      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      * Calculate Run Date
     C                   CALLB     'ZDATE2'
     C                   Parm      BJRDNB        ZDAYNO
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE
     C                   Parm      *Blanks       ZADATE

     C                   Eval      @RUNN = ZDATE

      * Calculate Back Value Date
     C                   Eval      @BVLD = BJRDNB - BJBVPD
                                                                                            BUG18500
      * Initialise TimeStamp                                                                BUG18500
     C                   MOVEL     TimeStampC    TimeStampZ                                 BUG18500
      *                                                                                       CSW209
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   Eval      CSW209 = 'N'                                               CSW209
     C                   Call      'SWIF2009'                                                 CSW209
     C                   Parm      *BLANKS       PRTCD                                        CSW209
                                                                                              CSW209
     C                   If        PRTCD = 'CSW2009'                                          CSW209
     C                   Eval      CSW209 = 'Y'                                               CSW209
     C                   EndIf                                                                CSW209
     C/COPY WNCPYSRC,FTH00403
      *                                                                                       CSW209
      ** Access SAR file to determine if CFT120 is switched on                                CFT120
      *                                                                                       CFT120
     C                   MOVEL     'N'           CFT120            1                          CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** If return code <> *NRF, call program exception error routine                         CFT120
      *                                                                                       CFT120
     C                   If        @RTCD <> *BLANKS AND                                       CFT120
     C                             @RTCD <> '*NRF'                                            CFT120
     C     *LOCK         IN        LDA                                                        CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 043                                                CFT120
     C                   OUT       LDA                                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT157
      ** Check if CFT157 Feature is enabled                                                   CFT157
                                                                                              CFT157
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   PARM      *BLANKS       @RTCD                                        CFT157
     C                   PARM      '*VERIFY'     @OPTN                                        CFT157
     C                   PARM      'CFT157'      @SARD                                        CFT157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT157
                                                                                              CFT157
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CFT157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT157
     C                   EVAL      DBKEY  = 'CFT157'                                          CFT157
     C                   EVAL      DBASE  = 32                                                CFT157
     C                   EXSR      *PSSR                                                      CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C                   IF        @RTCD = *BLANKS                                            CFT157
     C                   MOVEL     'Y'           CFT157            1                          CFT157
     C                   ELSE                                                                 CFT157
     C                   EVAL      CFT157 = 'N'                                               CFT157
     C                   ENDIF                                                                CFT157

      * Set up User id
     C                   Eval      PSUSER = WUSRID
     C                   Eval      @USRID = PSUSER


      *  Data areas for Payment reference numbering.
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD
     C     *DTAARA       DEFINE    RGPAYDA       RGPAYD

     C                   ENDSR
      *****************************************************************
      /Title Sr/SrBMT103                                                                      244540
      *****************************************************************                       244540
      *                                                               *                       244540
      * SR/SrBMT103   - Check MT103 agreement                         *                       244540
      *                                                               *                       244540
      * Called By: VAL@S subroutine                                   *                       244540
      *                                                               *                       244540
      * Calls:                                                        *                       244540
      * AOCUSTR0  - Access Object to get customer details             *                       244540
      * AOBRCHR0  - Access Object to get branch details               *                       244540
      * ME1730    - Determines whether an MT103 exists                *                       244540
      *                                                               *                       244540
      *****************************************************************                       244540
      *                                                                                       244540
     C     SrBMT103      BegSr                                                                244540
      *                                                                                       244540
     C                   Eval      PSNBRC = *Blank                                            244540
     C                   Eval      PSBICA = *Blank                                            244540
     C                   Eval      PSWIFT = *Blank                                            244540
     C                   Eval      PORDBK = *Blank                                            244540
     C                   Eval      PORTCD = *Blank                                            244540
     C                   Eval      WSWIFT = *Blank                                            244540
     C                   Eval      WCNUM = *Blank                                             244540
      *                                                                                       244540
      ** Get SWIFT-BIC of destination                                                         244540
      *                                                                                       244540
     C                   If        @DSTT = 'S'                                                244540
     C     11            SubSt     SDST1:1       WSWIFT           11                          244540
     C                   EndIf                                                                244540
      *                                                                                       244540
      ** Destination type is a full nostro 'F', customer number 'C'                           244540
      ** retail account 'R' or GL account 'G', get SWIFT ID through                           244540
      ** customer number                                                                      244540
      *                                                                                       244540
     C                   If        (@DSTT = 'F') Or (@DSTT = 'C') Or                          244540
     C                             (@DSTT = 'R') Or (@DSTT = 'G')                             244540
      *                                                                                       244540
     C                   Select                                                               244540
     C                   When      @DSTT = 'F'                                                244540
     C     3             SubSt     SDST1:1       @CYCD                                        244540
     C     2             SubSt     SDST1:4       @NONB                                        244540
     C                   Call      'AONOSTR0'                                                 244540
     C                   Parm      *Blanks       @RTCD                                        244540
     C                   Parm      '*KEY   '     @OPTN                                        244540
     C                   Parm      *Blanks       @CUST             6                          244540
     C                   Parm                    @CYCD             3                          244540
     C                   PARM      *BLANKS       PACCD                                        244540
     C                   Parm      *Blanks       @ACSN             2                          244540
     C                   Parm                    @NONB             2                          244540
     C                   Parm      *Blanks       @BRCD             3                          244540
     C                   Parm      *Blanks       @CSSN            10                          244540
     C                   Parm      *Blanks       @PNOI             1                          244540
     C     SDNOST        Parm      SDNOST        DSFDY                                        244540
      *                                                                                       244540
      ** Error on call                                                                        244540
      *                                                                                       244540
     C                   If        @RTCD <> *Blanks                                           244540
     C                   Movel     'SDNOSTPD'    DBFILE                                       244540
     C                   Movel     '081'         DBASE                                        244540
     C                   Movel     @CYCD         WKEY              5                          244540
     C                   Move      @NONB         WKEY                                         244540
     C                   Movel     WKEY          DBKEY                                        244540
     C                   Exsr      *PSSR                                                      244540
     C                   EndIf                                                                244540
     C                   Movel     A7CUST        WCNUM            10                          244540
      *                                                                                       244540
     C                   When      @DSTT = 'C'                                                244540
     C     10            SubSt     SDST1:1       WCNUM                                        244540
      *                                                                                       244540
     C                   Other                                                                244540
     C     6             SubSt     SDST1:1       WCNUM                                        244540
     C                   EndSl                                                                244540
      *                                                                                       244540
      ** Access customer's file to get SWIFT id                                               244540
      *                                                                                       244540
     C                   Call      'AOCUSTR0'                                                 244540
     C                   Parm      *Blanks       @RTCD                                        244540
     C                   Parm      '*KEY   '     @OPTN                                        244540
     C                   Parm      WCNUM         @KEY1            10                          244540
     C                   Parm      *Blanks       @KYST             7                          244540
     C     SDCUST        Parm      SDCUST        DSSDY                                        244540
      *                                                                                       244540
     C                   If        @RTCD = *Blank                                             244540
     C                   If        BBCSID <> *Blank                                           244540
     C                   Movel     BBCSID        WSWIFT                                       244540
     C                   EndIf                                                                244540
     C                   Else                                                                 244540
     C                   Movel     'SDCUSTPD'    DBFILE                                       244540
     C                   Movel     '082'         DBASE                                        244540
     C                   Movel     WCNUM         DBKEY                                        244540
     C                   Exsr      *PSSR                                                      244540
     C                   EndIf                                                                244540
     C                   EndIf                                                                244540
      *                                                                                       244540
      ** If CSW203 is installed, ME1730 will not be called. Default                           244540
      ** @MT103 TO 'Y'                                                                        244540
      *                                                                                       244540
     C                   IF        CSW203 = 'Y'                                               244540
     C                   EVAL      @MT103 = 'Y'                                               244540
     C                   ELSE                                                                 244540
      *                                                                                       244540
      ** Setup parameter to ME1730                                                            244540
      *                                                                                       244540
     C                   If        WSWIFT <> *Blank                                           244540
     C                   Movel     SBRCA         PSNBRC                                       244540
     C                   CALL      'AOBRCHR1'                                                 244540
     C                   Parm      *Blanks       @RTCD                                        244540
     C                   Parm      '*KEY   '     @OPTN                                        244540
     C                   Parm      SBRCA         @BRCD                                        244540
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        244540
      *                                                                                       244540
     C                   If        @RTCD <> *Blank                                            244540
     C                   Movel     'SDBRCHPD'    DBFILE                                       244540
     C                   Movel     '083'         DBASE                                        244540
     C                   Movel     SBRCA         DBKEY                                        244540
     C                   Exsr      *PSSR                                                      244540
     C                   EndIf                                                                244540
     C                   Movel     A8BTID        PSBICA                                       244540
     C                   Movel     WSWIFT        PSWIFT                                       244540
     C                   Movel     SORBK         PORDBK                                       244540
      *                                                                                       244540
      ** Call ME1730                                                                          244540
      *                                                                                       244540
     C                   Call      'ME1730'                                                   244540
     C                   Parm                    PSNBRC            3                          244540
     C                   Parm                    PSBICA           11                          244540
     C                   Parm                    PSWIFT           11                          244540
     C                   Parm                    PORDBK          256                          244540
     C                   Parm                    PBBINF          256                          244540
     C                   Parm                    PSNCOR          256                          244540
     C                   Parm                    PRCCOR          256                          244540
     C                   Parm                    PORTCD            7                          244540
      *                                                                                       244540
     C                   If        PORTCD = '*ERROR '                                         244540
     C                   Movel     'ME1730'      DBFILE                                       244540
     C                   Movel     '084'         DBASE                                        244540
     C                   Movel     '*CALL   '    DBKEY                                        244540
     C                   Exsr      *PSSR                                                      244540
     C                   Else                                                                 244540
     C                   If        PORTCD = '*CRT103'                                         244540
     C                   Move      'Y'           @MT103                                       244540
     C                   EndIf                                                                244540
     C                   EndIf                                                                244540
     C                   EndIf                                                                244540
      *                                                                                       244540
     C                   ENDIF                                                                244540
      *                                                                                       244540
     C                   EndSr                                                                244540
      *****************************************************************                       244540
**  CPY@
(c) Finastra International Limited 2003
