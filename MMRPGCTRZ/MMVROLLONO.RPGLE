     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate rollover deal number')               *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVROLLONO - Validate rollover deal number                   *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             rollover deal number and confirms whether it has  *
      *             a valid value.                                    *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255466A            Date 05Aug08               *
      *                 255466             Date 23Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL013             Date 09Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5813            Date 30Mar05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL010             Date 02Aug02               *
      *                 CAP076             Date 03Jun02               *
      *                 222727             Date 05Nov03               *
      *                 215264             Date 28Feb03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 136429             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255466A- Conditioned rollover principal amount from the new  *
      *           system value that should allow a maximum of         *
      *           principal + interest.                               *
      *  255466 - Rollover pricipal amount should only allow a        *
      *           maximum of principal + interest.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG5813- Ignore 'Rolled over deal has matured' warining if   *
      *           an automatic rollover                               *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1010                   *
      *           (new parameter to ZINTDY)                           *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  215264 - Deal could not be rollover due to incorrect associa-*
      *           ted deal number.                                    *
      *  CPB001 - 'Private Banking' Module                            *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP004 - API's Phase 3.                                      *
      *  136429 - Rollover of deal not allowed                        *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     INCLUDE(MMDELDP0)
 
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDCF)
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of error messages.
     D Msgids          S                   DIM(4) INZ(*BLANK)
     D                                     LIKE(#MsgID)
 
     D INFDS           DS
      **  Data structure for file status of MM deals file.
     D  RECORD           *RECORD
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** EXTERNAL DS FOR NOSTRO DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CAP004
      ** EXTERNAL DS FOR CURRENCY DETAILS                                       CAP004
                                                                                CAP004
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CAP004
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                     CAP004
                                                                                CAP004
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields returned as parameters
     D Msgid1          S                   LIKE(#MsgID)
     D Msgid2          S                   LIKE(#MsgID)
     D Msgid3          S                   LIKE(#MsgID)
     D Msgid4          S                   LIKE(#MsgID)
 
      ** Warning message ID
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Rollover deal number received as a parameter
     D DDDADN          S              6A
 
      ** Deal Type received as a parameter
     D DDTYPE          S              2A
      ** Deal Type OK indicator received as a parameter
     D DDTypeOK        S              1A
      ** Deal Sub-Type received as a parameter
     D DDSTYP          S              2A
 
      ** Deal Class received as a parameter                                                   CDL038
     D DDCLAS          S              4A                                                      CDL038
                                                                                              CDL038
      ** Deal Number received as a parameter
     D DDDLNO          S              6A
      ** Deal Number OK indicator received as a parameter
     D DDDlNoOK        S              1A
 
      ** Currency received as a parameter
     D DDCCY           S              3A
      ** Currency OK indicator received as a parameter
     D DDCcyOK         S              1A
 
      ** Customer OK indicator received as a parameter
     D DDCustOK        S              1A
 
      ** Branch Code received as a parameter
     D DDBRCA          S              3A
      ** Branch Code OK indicator received as a parameter
     D DDBrCAOK        S              1A
 
      ** Profit Centre received as a parameter
     D DDPTFR          S              4A
      ** Profit Centre OK indicator received as a parameter
     D DDPtfrOK        S              1A
 
      *  Customer number in a numeric field received as a parameter
     D*IKCNUM***       S              6S 0                                                    CSD027
     D IKCNUM          S              6A                                                      CSD027
      *  Related deal buy amount in a numeric field output as a parameter
     D IKRBAT          S             15S 0
      ** Rollover currency received as a parameter                              CAP004
     D IKRTFC          S                   LIKE(HKCCY)                          CAP004
 
      ** Deal amount in a numeric field received as a parameter
     D IKAMNP          S                   LIKE(HKAMNP)
 
      ** Value date as a Midas day number received as a parameter
     D @VDYNO          S              5P 0
 
      ** Deal date OK indicator received as a parameter
     D DDDDatOK        S              1A
 
      ** Amount OK indicator received as a parameter
     D DDAmnpOK        S              1A
 
      ** Interest calculation method OK indicator received as a parameter
     D DDICMtOK        S              1A
 
      ** Interest payment frequecy OK indicator received as a parameter
     D DDIPFqOK        S              1A
 
      ** Total interest OK indicator received as a parameter
     D DDTotIOK        S              1A
 
      ** Tacable indicator OK indicator received as a parameter
     D DDMTaxOK        S              1A
 
      ** Next interest date OK indicator received as a parameter
     D DDNDatOK        S              1A
 
      ** Interest payment frequecy received as a parameter
     D DDIPFQ          S              1A
 
      ** Automatic Rollover Switchable Feature indicator r'ced as a parm
     D S01434          S              1A
 
      ** Basic Rate Tax Switchable Feature indicator received as a parm
     D S01383          S              1A
 
      ** EMU Rollover Switchable Feature indicator received as a parm           CAP004
     D CEU015          S              1A                                        CAP004
                                                                                CAP004
      * BRT Rate, Date Effective From, BRT Rate - Previous, all three
      * received as parameters from Basic Rate Tax ICD
     D BRTR            S              7P 5
     D DEFF            S              5P 0
     D PBRTR           S              7P 5
 
      * Hong Kong Tax rate incoming parameter from Dealing ICD
     D BNHKTR          S              5P 2
 
      ** Front up interest indicator received as a parameter
     D DDFUID          S              1A
                                                                                             BUG5813
      ** Automatic rollover indicator received as a parameter                                BUG5813
     D DDAURO          S              1A                                                     BUG5813
 
      ** System Location Code (from SDBANKPD) received as a parameter
     D BJSLCD          S              3A
 
      ** Ref Attched to 9997 (from SDPORTPD) received as a parameter
     D FCR997          S              4A
      ** Portfolios Supported from SDPORTPD) received as a parameter
     D FCPORS          S              1A
      ** Private Banking Module Indicator received as a parameter               CPB001
     D BGN4ST          S              1A                                        CPB001
 
      ** Portfoloio Management Indicator received as a parameter                              215264
     D BGPFMG          S              1A                                                      215264
                                                                                              215264
      ** Action Code - received as a parameter
     D DDACTN          S              1A
 
      ** Work fields
     D @@VDAT          S              5P 0
     D @DLKEY          S              6P 0
     D @BRCA1          S              3A
     D @MRDYN          S              5P 0
     D @TOTL           S                   LIKE(HKAMNP)
     D @@NXIP          S              5P 0
     D @@INMT          S             15P 0
     D ZLOC            S              3A
     D @@INTD          S             13P 0
     D @@TINT          S             15P 0
     D @@INFQ          S              1A
     D @@INCM          S              1A
     D @@DLAM          S             15P 0
     D @@EIRT          S             11P 7
     D @@MTXI          S              1A
     D @@RDFC          S              1A
     D @@DEAL          S              6P 0
     D @@BRMD          S              5P 0
     D ZCCY            S              3A
     D I#PORS          S                   LIKE(FCPORS)
 
      ** Index for array of message IDs
     D Idx             S              1S 0 INZ(0)
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
     D @KEYC           S             10A                                                      CGL029
      ** Withholding tax Flag received as a parameter                                         CDL013
     D CDL013          S              1A                                                      CDL013
                                                                                              CDL013
      ** Constant paramater for AOSVALR0                                                     255466A
     D ROPA            C                   CONST('RolloverPrinAmount')                       255466A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   DBErrFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgids
     C                   RESET                   Idx
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   Msgid3
     C                   RESET                   Msgid4
 
     C*
     C**  If the deal type is valid and is one of CD, CL or DL, and the
     C**  rollover deal no. is non-blank or zero, it is an error.
     C     DDTypeOK      IFNE      'N'
     C     DDTYPE        IFEQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDDADN        IFNE      *BLANKS
     C     DDDADN        ANDNE     *ZEROS
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C     DDTYPE        IFEQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM9017'     Msgids(Idx)                    CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0182'     Msgids(Idx)
     C                   ENDIF                                                  CDL006
     C                   END
     C                   END
     C                   END
     C*
     C**  If the deal type is valid, and the rollover deal no. is non-zero,
     C**  and no validation error has occurred, validate the rollover
     C**  deal no. further.
     C     DDTypeOK      IFNE      'N'
     C     ErrorFound    ANDEQ     'N'
     C     DDDADN        ANDNE     *BLANKS
     C     DDDADN        ANDNE     *ZEROS
     C*
     C**  Chain to the deals file, using the rollover deal no. as a key
     C**  - *IN65 set on if the record is not found.
     C                   MOVE      DDDADN        @DLKEY
     C     @DLKEY        CHAIN     MMDEALLL                           65
     C*
     C**  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDELDP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0158'     Msgids(Idx)
     C                   END
     C*
     C**  If the correct format was accessed, and no valid record is
     C**  found, it is an error.
     C     ErrorFound    IFEQ      'N'
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANKS
     C     HKDSTS        OREQ      'M'
 
 
     ***If*not*authorisation************************************************    136429
     ** If not authorisation or amendment                                       136429
     C     DDACTN        IFNE      'X'
     C     DDACTN        ANDNE     'A'                                          136429
 
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0184'     Msgids(Idx)
 
     ***If*authorisation***********************************************         136429
     ** If authorisation or amendment                                           136429
     C                   ELSE
 
 
     C     HKDSTS        IFEQ      'M'
     C     DDAURO        ANDNE     'A'                                                       BUG5813
     C                   EVAL      WarnGlobal = 'Y'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM1046'     WMsgID1
     C                   END
     C                   END
 
     C                   ELSE
      * Here, a valid record has been found on MMDELDPP
     C*
     C**  If the deal has been deleted, it is an error.
     C     HKDDLT        IFEQ      'D'
     C*
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0183'     Msgids(Idx)
     C                   ELSE
     C*
     C**  If the rolled over by deal no. is non-blank and not the
     C**  same as the no. of the deal being maintained, it is an error.
     C     HKROBY        IFNE      *BLANKS
     C     HKROBY        ANDNE     '000000'
     C     HKROBY        ANDNE     DDDLNO
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0189'     Msgids(Idx)
     C                   END
     C*
     C**  If the related deal status code is not 'A' or 'R', it is an
     C**  error.
     C     HKDSTS        IFNE      'A'
     C     HKDSTS        ANDNE     'R'
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0254'     Msgids(Idx)
     C                   END
      *
      ** If screen Portfolio set to default reference for R997
      ** check against '9997'
     C     BGPFMG        IFEQ      'Y'                                                        215264
     C     DDPTFR        IFEQ      FCR997
     C     I#PORS        ANDNE     'B'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C     I#PORS        OREQ      'B'
     C     DDPTFR        ANDNE     *BLANKS
     C     DDPTFR        ANDEQ     FCR997
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        WWPTF1            4
     C                   ELSE
     C                   MOVE      DDPTFR        WWPTF1
     C                   END
     C                   ELSE                                                                 215264
     C                   MOVE      *BLANKS       WWPTF1                                       215264
     C                   MOVE      *BLANKS       HKPTFR                                       215264
     C                   ENDIF                                                                215264
      *                                                                         CAP004
      ** Check whether rollover is from an 'in currency' to Euros               CAP004
      *                                                                         CAP004
     C                   MOVE      *BLANK        InCy2Euro         1            CAP004
     C                   MOVE      *BLANK        IKRTFC                         CAP004
     C     CEU015        IFEQ      'Y'                                          CAP004
     C     DDCCY         ANDEQ     BKEURO                                       CAP004
      *                                                                         CAP004
      *  Access currency file                                                   CAP004
      *  (database error handling done in access program)                       CAP004
     C                   CALLB     'AOCURRR0'                                   CAP004
     C                   PARM      '*DBERR '     @RTCD             7            CAP004
     C                   PARM      '*KEY   '     @OPTN             7            CAP004
     C                   PARM      HKCCY         @AJCD             3            CAP004
     C     SDCURR        PARM      SDCURR        DSSDY                          CAP004
      *                                                                         CAP004
     C     A6INCY        IFEQ      'Y'                                          CAP004
     C     A6TPSD        ANDLE     BJRDNB                                       CAP004
     C                   MOVE      'Y'           InCy2Euro                      CAP004
     C                   MOVE      HKCCY         IKRTFC                         CAP004
     C                   ENDIF                                                  CAP004
     C                   ENDIF                                                  CAP004
     C*
     C**  If the following fields on the related deal are not the same
     C**  as those on the maintained deal, it is an error;
     C**   Deal type, customer, currency, branch code, portfolio reference
     C**   (either entered code or default code).
     C                   MOVE      HKBRCA        @BRCA1
     C     DDTypeOK      IFNE      'N'
     C     DDCustOK      ANDNE     'N'
     C     DDCcyOK       ANDNE     'N'
     C     DDBrcaOK      ANDNE     'N'
     C     DDPtFrOK      ANDNE     'N'
     C*
     C     HKMTYP        IFNE      DDTYPE
     C     HKCNUM        ORNE      IKCNUM
     C     HKCCY         ORNE      DDCCY
     C     InCy2Euro     ANDNE     'Y'                                          CAP004
     C     HKPTFR        ORNE      WWPTF1
     C     @BRCA1        ORNE      DDBRCA
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0186'     Msgids(Idx)
     C                   END
 
     C                   END
      *
      ** If Deal Sub-Type is changed no new deal, issue warning error
     C     HKSTYP        IFNE      DDSTYP
     C                   EVAL      WarnGlobal = 'Y'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0689'     WMsgID1
     C                   END
                                                                                              CDL038
      ** If Deal Class is changed on new deal, issue warning error                            CDL038
     C     HKCLAS        IFNE      DDCLAS                                                     CDL038
     C                   EVAL      WarnGlobal = 'Y'                                           CDL038
     C                   EVAL      WarnFound = 'Y'                                            CDL038
     C                   MOVEL     'MMM0700'     WMsgID1                                      CDL038
     C                   END                                                                  CDL038
 
      **  Format the maturity date of the associated deal.
     C                   Z-ADD     HKMDYY        @YEAR
     C                   Z-ADD     HKMDMM        @MNTH
     C                   Z-ADD     HKMDDD        @DAY
     C     @DATE         IFEQ      0
     C                   MOVE      *ZEROS        @MRDYN
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    @DATE
     C                   PARM                    @MRDYN
     C                   END
 
      **  The value date of the maintained deal must be the same as the
      **  maturity date on the related deal.  If not, it is an error.
     C     @VDYNO        IFNE      @MRDYN
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0187'     Msgids(Idx)
     C                   END
 
      ** If none of the fields used are invalid or blank, calculate
      ** the interest at maturity.
      **   Deal date and Next Interest Date may have a warning error
      **   in which case, still need to calculate interest, otherwise
      **   Rollover deal amount does not get output to DEALSDC
 
      ** Proceed if there is only a warning message on deal date or next
      ** interest date, or if there are no errors so far.
     C                   IF         ErrorFound = 'N'
     C                              AND DDDlNoOK = 'Y'
     C                              AND DDAmnPOK = 'Y'
     C                              AND DDICMTOK = 'Y'
     C                              AND DDIPFqOK = 'Y'
     C                              AND DDTOTIOK = 'Y'
     C                              AND DDMTaxOK = 'Y'
     C                              AND DDDDatOK <> 'N'
     C                              AND DDNDatOK <> 'N'
 
      **  Access the record for the associated deal on the DEALS file,
      **  in order to find the interest to date.  If no valid record is
      **  found, it is a database error, which is passed back to the caller
      **  as a special form of error.
     C     @DLKEY        CHAIN     DEALSDCF                           65
 
     C     *IN65         IFEQ      '1'
     C     RECI          OREQ      '*'
 
      **  Ensure the DBErr message is the only one returned
     C                   RESET                   Msgids
     C                   RESET                   Idx
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   Msgid3
     C                   RESET                   Msgid4
 
     C                   MOVE      'Y'           DBErrFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMA0002'     Msgids(Idx)
     C                   MOVEL     'DEALS   '    DBFILE
     C                   MOVEL     @DLKEY        DBKEY
     C                   MOVEL     PSProcName    DBPROC
     C                   MOVEL     PSProcMod     DBMOD
     C                   MOVEL     PSProcPgm     DBPGM
 
     C                   EVAL      DBErrData = (PSProcPgm + PSProcMod
     C                              + PSProcName + DBFILE + DBKEY)
 
      ** Run exit routine to set the return code appropriately & return to
      **  the caller
     C                   EXSR      EXIT
 
     C                   END
     C*
     C**  Format the value date of the associated deal.
     C                   Z-ADD     HKVDYY        @YEAR
     C                   Z-ADD     HKVDMM        @MNTH
     C                   Z-ADD     HKVDDD        @DAY
     C     @DATE         IFEQ      0
     C                   MOVE      *ZEROS        @@VDAT
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    @DATE
     C                   PARM                    @@VDAT
     C                   END
     C*
     C**  Format the maturity date of the associated deal.
     C                   Z-ADD     HKNIYY        @YEAR
     C                   Z-ADD     HKNIMM        @MNTH
     C                   Z-ADD     HKNIDD        @DAY
     C     @DATE         IFEQ      0
     C                   MOVE      *ZEROS        @@NXIP
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    @DATE
     C                   PARM                    @@NXIP
     C                   END
     C*
     C                   Z-ADD     IPRD          @@INTD
     C                   Z-ADD     HKMTTI        @@TINT
     C                   MOVE      HKIPFQ        @@INFQ
     C                   MOVE      HKICMT        @@INCM
     C                   Z-ADD     HKAMNP        @@DLAM
     C                   Z-ADD     HKINTR        @@EIRT
     C                   MOVE      HKMTAX        @@MTXI
     C                   MOVE      HKRDFC        @@RDFC
     C                   Z-ADD     HKDN38        @@DEAL
     C     HKSTCY        IFNE      *BLANK
     C                   MOVE      HKSTCY        ZCCY
     C                   ELSE
     C                   MOVE      HKCCY         ZCCY
     C                   END
     C                   MOVE      @MRDYN        @@BRMD            5 0
     C*
     C**  Check whether loan or deposit in order to set up location
     C     HKAMNP        IFGT      0
     C*
     C*  Set up location used by ZCHKH - if Our PAY Settlement
     C*  Method is a nostro then use nostro code and currency to find
     C*  Nostro Location
     C     HKPSTM        IFEQ      01
     C     HKPSTM        OREQ      02
     C     HKPSTM        OREQ      07
     C     HKPSTM        OREQ      08
     C     HKPSTM        OREQ      12
     C*
      *  (database error handling done in access program)
     C                   CALLB     'AONOSTR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      ZCCY          @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      HKPONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C                   MOVE      A7NOSN        ZLOC
     C*
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   END
     C*
     C                   ELSE
     C*
     C**  HKAMNP is less than zero so deal is a loan
     C*  Set up location used by ZCHKH - if Our receive Settlement
     C*  Method is a nostro then use nostro code and currency to find
     C*  Nostro Location
     C*
     C     HKRSTM        IFEQ      01
     C     HKRSTM        OREQ      02
     C     HKRSTM        OREQ      07
     C     HKRSTM        OREQ      08
     C     HKRSTM        OREQ      12
     C*
      *  (database error handling done in access program)
     C                   CALLB     'AONOSTR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      HKCCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      HKRONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C                   MOVE      A7NOSN        ZLOC
     C*
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   END
     C*
     C                   END
     C*
     C                   CALLB     'MM1010'
     C                   PARM                    @@TINT
     C                   PARM                    @@INTD
     C                   PARM                    @@INFQ
     C                   PARM                    @@NXIP
     C                   PARM                    @@VDAT
     C                   PARM                    @@INCM
     C                   PARM                    @@DLAM
     C                   PARM                    @@EIRT
     C                   PARM                    @@RDFC
     C                   PARM                    @@MTXI
     C                   PARM                    @@DEAL
     C                   PARM                    @@BRMD
     C                   PARM                    BNHKTR
     C                   PARM                    S01383
     C                   PARM                    BRTR
     C                   PARM                    DEFF
     C                   PARM                    PBRTR
     C                   PARM                    IKCNUM
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    @@INMT
     C                   PARM                    CDL013                                      CDL013
      *                                                                         CAP004
      ** Initialize rollover principal                                          CAP004
      *                                                                         CAP004
     C                   Z-ADD     IKAMNP        RollPrin         15 0          CAP004
      *                                                                         CAP004
      ** Calculate rollover principal if 'in currency' to Euro rollover         CAP004
      *                                                                         CAP004
     C     CEU015        IFEQ      'Y'                                          CAP004
     C     InCy2Euro     ANDEQ     'Y'                                          CAP004
     C                   CALL      'EU0200'                                     CAP004
     C                   PARM      *BLANKS       P@RTCD            7            CAP004
     C                   PARM      IKAMNP        P@FRAM           18 3          CAP004
     C                   PARM      DDCCY         P@FRCY            3            CAP004
     C                   PARM      HKCCY         P@TOCY            3            CAP004
     C                   PARM      *ZERO         P@OUTA           15 0          CAP004
     C                   PARM                    P@INTA           18 3          CAP004
     C                   PARM                    P@EXRT           15 9          CAP004
     C                   PARM                    P@MDIN            1            CAP004
     C     P@RTCD        IFEQ      '*ERROR*'                                    CAP004
     C                   MOVEL     'EU0200'      DBFILE                         CAP004
     C                   MOVE      '991'         DBASE                          CAP004
     C                   MOVEL     DDCCY         DBKEY                          CAP004
     C                   EXSR      *PSSR                                        CAP004
     C                   ENDIF                                                  CAP004
     C                   Z-ADD     P@OUTA        RollPrin                       CAP004
     C                   ENDIF                                                  CAP004
     C*
     C** SETUP RELATED DEAL FIELD FOR PRINCIPAL AMOUNT
     C                   Z-ADD     HKAMNP        IKRBAT
     C*
     C*
     C**  Total up the interest at maturity and the deal amount for
     C**  the associated deal.  If the new deal amount is greater, it
     C**  is an error.
     C**  First, ensure all amounts are +ve.  Then, take into account
     C**  the negative interest indicator.
     C     HKAMNP        IFLT      0
     C                   Z-SUB     HKAMNP        HKAMNP
     C                   END
     C     @@INMT        IFLT      0
     C                   Z-SUB     @@INMT        @@INMT
     C                   END
     C*
     C     HKNGVI        IFEQ      'Y'
     C     HKAMNP        SUB       @@INMT        @TOTL
     C                   ELSE
     C     HKAMNP        ADD       @@INMT        @TOTL
     C                   END
      ** Access Midas System values via access program                                       255466A
     C                   CALLB     'AOSVALR0'                                                255466A
     C                   PARM                    @RTCD             7                         255466A
     C                   PARM      ROPA          @OP01            20                         255466A
     C                   PARM                    @VL01           200                         255466A
     C                   PARM                    @OP02            20                         255466A
     C                   PARM                    @VL02           200                         255466A
     C                   PARM                    @OP03            20                         255466A
     C                   PARM                    @VL03           200                         255466A
     C                   PARM                    @OP04            20                         255466A
     C                   PARM                    @VL04           200                         255466A
     C                   PARM                    @OP05            20                         255466A
     C                   PARM                    @VL05           200                         255466A
     C                   PARM                    @OP06            20                         255466A
     C                   PARM                    @VL06           200                         255466A
     C                   PARM                    @OP07            20                         255466A
     C                   PARM                    @VL07           200                         255466A
     C                   PARM                    @OP08            20                         255466A
     C                   PARM                    @VL08           200                         255466A
     C                   PARM                    @OP09            20                         255466A
     C                   PARM                    @VL09           200                         255466A
     C                   PARM                    @OP10            20                         255466A
     C                   PARM                    @VL10           200                         255466A
     C*
     C     DDIPFQ        IFEQ      'N'
     C*
     C*
     C*****IKAMNP********IFGT      HKAMNP                                       CAP004
     C     RollPrin      IFGT      HKAMNP                                       CAP004
     C*****S01434********ANDNE     'Y'                                                        255466
     C     S01434        ANDNE     'Y'                                                       255466A
     C     RollPrin      ORGT      HKAMNP                                                    255466A
     C     S01434        ANDEQ     'Y'                                                       255466A
     C     @VL01         ANDEQ     'Y'                                                       255466A
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0188'     Msgids(Idx)
     C                   END
 
 
     C                   ELSE
 
      * ERROR IF UP FRONT INTEREST INDICATORS DO NOT MATCH
      *    OR IF UP FRONT INDICATOR IS 'Y' AND PRINCIPAL OF ROLLOVER
      *       DEAL IS NOT EQUAL TO PRINCIPAL OF ROLLED OVER DEAL
 
     C     DDFUID        IFNE      HKFUID
     C     DDFUID        OREQ      'Y'
     C     HKAMNP        ANDNE     RollPrin                                     CAP004
     C*****HKAMNP********ANDNE     IKAMNP                                       CAP004
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0611'     Msgids(Idx)
     C                   ELSE
 
      * IF NOT UP FRONT INTEREST, PRINCIPAL OF ROLLOVER DEAL
      * MUST NOT BE GREATER THAN PRINCIPAL + INTEREST OF ROLLED OVER DEAL
 
 
     C*****IKAMNP********IFGT      @TOTL                                        CAP004
     C     RollPrin      IFGT      @TOTL                                        CAP004
     C*****S01434********ANDNE     'Y'                                                        255466
     C     S01434        ANDNE     'Y'                                                       255466A
     C     RollPrin      ORGT      @TOTL                                                     255466A
     C     S01434        ANDEQ     'Y'                                                       255466A
     C     @VL01         ANDEQ     'Y'                                                       255466A
     C                   MOVE      'Y'           ErrorFound
     C                   ADD       1             Idx
     C                   MOVEL     'MMM0188'     Msgids(Idx)
     C                   END
 
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
 
      ** Run exit routine to set the return code appropriately
     C                   EXSR      EXIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EXIT - Program exit routine                                   *
      *                                                               *
      * Called by: Main processing - at end                           *
      *                            - when terminal errors found       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     EXIT          BEGSR
 
      ** If errors or warnings were found, set the return code
      ** appropriately in the /COPY (note that the return code will not
      ** contain a special value if there is a database error, but the
      ** DBErrData field will be set in that case, and that field is
      ** checked by the caller).
     C/COPY ZACPYSRC,SETRETCDE
 
     C     ReturnCode    IFNE      *BLANKS
     C                   MOVEL     Msgids(1)     Msgid1
     C                   MOVEL     Msgids(2)     Msgid2
     C                   MOVEL     Msgids(3)     Msgid3
     C                   MOVEL     Msgids(4)     Msgid4
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      * Following are flag for errors found and error message IDs
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    Msgid3
     C                   PARM                    Msgid4
      ** Warning message ID (10A)
     C                   PARM                    WMsgID1
      * Data describing the database error found
     C                   PARM                    DBErrData
      * Following fields are from the transaction
     C                   PARM                    DDDADN
     C                   PARM                    DDTYPE
     C                   PARM                    DDSTYP
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDDLNO
     C                   PARM                    DDCCY
     C                   PARM                    DDBRCA
     C                   PARM                    DDPTFR
     C                   PARM                    DDIPFQ
     C                   PARM                    DDFUID
     C                   PARM                    DDAURO                                      BUG5813
      * Following fields are in/valid indicators for the transaction fields
     C                   PARM                    DDTypeOK
     C                   PARM                    DDDlNoOK
     C                   PARM                    DDCcyOK
     C                   PARM                    DDCustOK
     C                   PARM                    DDBrcaOK
     C                   PARM                    DDPtfrOK
     C                   PARM                    DDDDatOK
     C                   PARM                    DDAmnpOK
     C                   PARM                    DDICMtOK
     C                   PARM                    DDIPFqOK
     C                   PARM                    DDTotIOK
     C                   PARM                    DDMTaxOK
     C                   PARM                    DDNDatOK
      * Transaction Value Date as a Midas day number
     C                   PARM                    @VDYNO
      * Transaction Customer Number in a numeric, set up in the validation
     C                   PARM                    IKCNUM
      * Transaction Amount numeric, set up in the validation
     C                   PARM                    IKAMNP
      * Derived Related Deal Buy Amount which is (probably) used in the
      *  update of DEALSDC
     C                   PARM                    IKRBAT
      * Rollover Currency                                                       CAP004
      * Currency of rolled over deal if 'in' currency to Euro rollover          CAP004
     C                   PARM                    IKRTFC                         CAP004
      *                                                                         CAP004
      * Flag to show that warning errors have been found
     C                   PARM                    WarnGlobal
      * Flag for whether S01434 (Enhanced Rollovers) is switched on
     C                   PARM                    S01434
      * Flag for whether S01383 (Basic Rate Tax) is switched on
     C                   PARM                    S01383
      * Flag for whether CEU015 (EMU rollover) is switched on                   CAP004
     C                   PARM                    CEU015                         CAP004
      * System Location Code from Bank Details
     C                   PARM                    BJSLCD
      * Run Date                                                                CAP004
     C                   PARM                    BJRDNB            5 0          CAP004
      * Euro Currency                                                           CAP004
     C                   PARM                    BKEURO            3            CAP004
      * Hong Kong Tax Rate from Dealiing ICD
     C                   PARM                    BNHKTR
      * Type of Portfolios Supported & Ref attached to 9997, both from
      *  Portfolio Management ICD
     C                   PARM                    FCPORS
     C                   PARM                    FCR997
      * Private Banking Module Indicator (1A)                                   CPB001
     C                   PARM                    BGN4ST                         CPB001
      * Portfolio Management  Indicator (1A)                                                  215264
     C                   PARM                    BGPFMG                                       215264
      * BRT Rate, Date Effective From, BRT Rate - Previous, all three from
      *  Basic Rate Tax ICD
     C                   PARM                    BRTR
     C                   PARM                    DEFF
     C                   PARM                    PBRTR
      * Action code
     C                   PARM                    DDACTN
     C                   PARM                    CDL013                                      CDL013
 
      ** Set PM ICD field to the bname used in the code
     C                   EVAL      I#PORS = FCPORS
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
