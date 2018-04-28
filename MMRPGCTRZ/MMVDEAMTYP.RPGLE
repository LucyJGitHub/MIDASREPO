     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Deal Amendment Type')                *
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMTYP - Validate Deal Amendment Type                    *
      *               (for Deal Amendment processing)                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Deal Amendment Type and confirms if it is         *
      *             valid. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16257           Date 14Mar08               *
      *                 250892             Date 12Oct07               *
      *                 245960             Date 24Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 240942             Date 06Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL017             Date 29Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191379             Date 02Apr01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 109499             Date 31Mar00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16257 - Clarify the settlement default for amendment      *
      *             type BC, SC, or CI with a warning message         *
      *  250892 - Allow Interest Capitalisation (CI) for Term Deposits*
      *           (TD) and Term Loans (TI) if system value            *
      *           AllowCIforTDTI = Y.                                 *
      *  245960 - Allow SC deal amendments only when system value     *
      *           AllowSCforFiXD is set to "Y".                       *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240942 - Allow PI/PD amendments to IP/IT only if system      *
      *           value AllowPIPDforITIPD = Y                         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  191379 - Remove 109499. Its logic is completely erroneous.   *
      *  109499 - Interest Capitalisation  should not be allowed if   *
      *           interest capitalisation Indicator on the deal is    *
      *           not equal to  'Y' .                                 *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
     D INFDS           DS
      **  Data structure for file status of MM deals file.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External data structure for access programs (short)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      * Constant to hold input parameter for AOSVALR0.                                        240942
     D PSysVal1        C                   Const('AllowPIPDforITIPD')                         240942
     D PSysVal2        C                   Const('AllowSCforFiXD'   )                         245960
     D PSysVal3        C                   Const('AllowCIforTDTI'   )                         250892
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Error message code 2 received as a parameter
     D Msgid2          S                   LIKE(#MSGID)
 
      ** Error message code 3 received as a parameter
     D Msgid3          S                   LIKE(#MSGID)
 
      ** Error message code 4 received as a parameter
     D Msgid4          S                   LIKE(#MSGID)
 
      ** Error message code 5 received as a parameter
     D Msgid5          S                   LIKE(#MSGID)
 
      ** Error message code 6 received as a parameter
      ** (for errors relating to Value Date)
     D Msgid6          S                   LIKE(#MSGID)
 
      ** Error message code 7 received as a parameter
      ** (for errors relating to Deal Number)
     D Msgid7          S                   LIKE(#MSGID)
 
      ** Warning message code 2 received as a parameter                                     BUG16257
     D WMsgid2         S                   LIKE(#MSGID)                                     BUG16257
                                                                                            BUG16257
      ** Deal Amendment Type received as a parameter
     D DDMTYP          S              2A
 
      ** Deal Number received as a parameter
     D DDDLNO          S              6A
 
      ** Associated Deal Number from original deal received as a parameter
     D H@DADN          S              6A
 
      ** Value Date from original deal received as a parameter
     D H@VDAT          S              8S 0
 
      ** Start/Last Interest date from original deal received as a parameter
     D H@SLDT          S              8S 0
 
      ** Interest Accrual date from original deal received as a parameter
     D H@IADT          S              8S 0
 
      ** Record ID from original deal received as a parameter
     D H@RCID          S              2A
 
      ** Interest Capitalisation indicator from original deal
      ** received as a parameter
     D H@CPTI          S              1A
 
      ** Deal Type from original deal received as a parameter
     D H@MTYP          S              2A
 
      ** Interest Payment Frequency indicator from original deal
      ** received as a parameter
     D H@IPFQ          S              1A
 
      ** Next Interest Payment Date from original deal
      ** received as a parameter
     D H@NIDT          S              8S 0
 
      ** Deal Type passed back to calling program received as a parameter
     D IGMTYP          S              2A
 
      ** Value Date in Midas Day No. format received as a parameter
     D @VDYNO          S              5  0
 
      ** Start/Last Interest Date in Midas Day Number format
      ** received as a parameter
     D @SLDYN          S              5  0
 
      ** Interest Accrual Date in Midas Day Number format
      ** received as a parameter
     D @IADYN          S              5  0
 
      ** Value Date in error flag received as a parameter
     D DDVdatOK        S              1A
 
      ** Deal Number in error flag received as a parameter
     D DDDlnoOK        S              1A
 
      ** Date fields used in call to ZDATE10
     D DateIn          S              8S 0
     D ZZMDNO          S              5  0
 
      ** Key for chain to MMDEALLL
     D @DLKEY          S              6S 0
     D CDL006          S              1A   IMPORT                               CDL006
 
     D PSysVal01       S             20A                                                      240942
     D PCurSet01       S            200A                                                      240942
     D PSysVal02       S             20A                                                      240942
     D PCurSet02       S            200A                                                      240942
     D PSysVal03       S             20A                                                      240942
     D PCurSet03       S            200A                                                      240942
     D PSysVal04       S             20A                                                      240942
     D PCurSet04       S            200A                                                      240942
     D PSysVal05       S             20A                                                      240942
     D PCurSet05       S            200A                                                      240942
     D PSysVal06       S             20A                                                      240942
     D PCurSet06       S            200A                                                      240942
     D PSysVal07       S             20A                                                      240942
     D PCurSet07       S            200A                                                      240942
     D PSysVal08       S             20A                                                      240942
     D PCurSet08       S            200A                                                      240942
     D PSysVal09       S             20A                                                      240942
     D PCurSet09       S            200A                                                      240942
     D PSysVal10       S             20A                                                      240942
     D PCurSet10       S            200A                                                      240942
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   Msgid3
     C                   RESET                   Msgid4
     C                   RESET                   Msgid5
     C                   RESET                   Msgid6
     C                   RESET                   Msgid7
     C                   RESET                   WarnFound                                  BUG16257
     C                   RESET                   WMsgid2                                    BUG16257
      *
      *
      *  *------------------------------*
      *  * Validate Deal Amendment Type *                     (MMP0084)
      *  *------------------------------*
     C*
     C**  Amendment type must not be blank
     C     DDMTYP        IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0297'     Msgid1
     C                   ELSE
     C*
     C**  Type must have a value of SC,PI,PD,CI or SI
     C**  or EM                                                                               CDL017
     C**  or BC                                                                               CDL022
     C     DDMTYP        IFNE      'SC'
     C     DDMTYP        ANDNE     'PI'
     C     DDMTYP        ANDNE     'PD'
     C     DDMTYP        ANDNE     'CI'
     C     DDMTYP        ANDNE     'SI'
     C     DDMTYP        ANDNE     'EM'                                                       CDL017
     C     DDMTYP        ANDNE     'BC'                                                       CDL022
 
     C                   MOVE      'Y'           ErrorFound
     C****************** MOVEL     'MMM0298'     Msgid1                                       CDL017
     C                   MOVEL     'MMM0318'     Msgid1                                       CDL022
     C                   END
     C                   END
     C*
     C*  For types CI or SI
     C** Value date must be greater than both interest accrual
     C** control date & start/last interest date.
     C     DDMTYP        IFEQ      'CI'
     C     DDMTYP        OREQ      'SI'
     C*
     C     @VDYNO        IFLE      @SLDYN
     C     @VDYNO        ORLE      @IADYN
     C*
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0299'     Msgid6
     C                   MOVE      'N'           DDVdatOK
     C                   Else                                                   CDL006
                                                                                CDL006
      ** Amendment type SI or CI must not have related deal types DP            CDL006
      ** DT, LP or LT                                                           CDL006
                                                                                CDL006
     C                   If        (DDMTYP = 'SI' or DDMTYP = 'CI') and         CDL006
     C                             (H@MTYP = 'DP' or H@MTYP = 'DT' or           CDL006
     C                              H@MTYP = 'LP' or H@MTYP = 'LT')             CDL006
     C                   Eval      ErrorFound = 'Y'                             CDL006
     C                   Eval      Msgid1 = 'MMM0320'                           CDL006
     C                   Endif                                                  CDL006
     C                   END
     C                   END
     C*
     C*  For type SI
 
     C     DDMTYP        IFEQ      'SI'
 
     C*
     C** If there is a NAS deal number in the deal associated
     C** deal number field, retrieve NAS details.
     C     H@DADN        IFNE      *BLANK
     C                   MOVE      H@DADN        @DLKEY
     C     @DLKEY        CHAIN     MMDEALLL                           65
     C*
     C     *IN65         IFEQ      '1'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0184'     Msgid5
     C*
     C                   ELSE
     C*
     C** Convert NA sale date to MIDAS day number.
     C                   Z-ADD     H@VDAT        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C*
     C** Check that the Deam value date is not after the NA sale date.
     C     @VDYNO        IFGT      ZZMDNO
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0580'     Msgid7
     C                   MOVE      'N'           DDDlnoOK
     C                   END
     C*
     C                   END
     C                   END
     C                   END
     C*
     C*  For types PI,PD or SC
     C** If Value date of DEAL is = to both interest accrual
     C** control date & start/last interest date.
     C** Value date must not be greater than both interest accrual
     C** control date & start/last interest date.
     C     DDMTYP        IFEQ      'PI'
     C     DDMTYP        OREQ      'PD'
     C     DDMTYP        OREQ      'SC'
     C*
     C     H@VDAT        IFEQ      H@SLDT
     C     H@VDAT        ANDEQ     H@IADT
     C*
     C     @VDYNO        IFLT      @SLDYN
     C     @VDYNO        ANDLT     @IADYN
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0300'     Msgid6
     C                   MOVE      'N'           DDVdatOK
     C                   END
     C*
     C                   ELSE
     C*
     C** If Value date of DEAL is NOT = to both interest accrual
     C** control date & start/last interest date.
     C** Value date of DEAM be greater than or equal to both
     C** interest accrual control date & start/last interest date.
     C*
     C     @VDYNO        IFLT      @SLDYN
     C     @VDYNO        ORLT      @IADYN
     C*
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0300'     Msgid6
     C                   MOVE      'N'           DDVdatOK
     C                   END
     C                   END
     C                   END
     C*
     C** For type SI interest capitilisation indicator must not be 'Y'
     C** Not present for N/A's bought or sold
     C*
     C     DDMTYP        IFEQ      'SI'
     C     H@RCID        ANDEQ     'HK'
     C     H@CPTI        ANDEQ     'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0301'     Msgid3
     C                   END
     C*
     C**********                                                         109499 191379
     C***For*type CI interest capitilisation indicator MUST  be  'Y'     109499 191379
     C**********                                                         109499 191379
     C*****DDMTYP        IFEQ      'CI'                                  109499 191379
     C*****H@RCID        ANDEQ     'HK'                                  109499 191379
     C*****H@CPTI        ANDNE     'Y'                                   109499 191379
     C**********         MOVE      'Y'           ErrorFound              109499 191379
     C**********         MOVEL     'MMM0321'     Msgid3                  109499 191379
     C**********         END                                             109499 191379
     C**********                                                         109499 191379
     C**********                                                         109499 191379
     C** For deam type PI,PD,SC,CI deal types must be CD,CL,DL,IL or ID.
     C     DDMTYP        IFEQ      'PI'
     C     DDMTYP        OREQ      'PD'
     C     DDMTYP        OREQ      'SC'
     C     DDMTYP        OREQ      'CI'
     C     H@MTYP        IFNE      'CD'
     C     H@MTYP        ANDNE     'CL'
     C     H@MTYP        ANDNE     'DL'
     C     H@MTYP        ANDNE     'IL'
     C     H@MTYP        ANDNE     'ID'
     C     CDL006        AndEq     'N'                                          CDL006
      *                                                                         CDL019
      ** Also allow deal types TI, IP, TD and IT                                CDL019
     C     H@MTYP        AndNe     'TI'                                         CDL019
     C     H@MTYP        AndNe     'IP'                                         CDL019
     C     H@MTYP        AndNe     'TD'                                         CDL019
     C     H@MTYP        AndNe     'IT'                                         CDL019
      *                                                                         CDL019
     C     H@MTYP        OrNe      'CD'                                         CDL006
     C     H@MTYP        AndNe     'CL'                                         CDL006
     C     H@MTYP        AndNe     'DL'                                         CDL006
     C     H@MTYP        AndNe     'IL'                                         CDL006
     C     H@MTYP        AndNe     'ID'                                         CDL006
     C     H@MTYP        AndNe     'DP'                                         CDL006
     C     H@MTYP        AndNe     'LP'                                         CDL006
     C     H@MTYP        AndNe     'DT'                                         CDL006
     C     H@MTYP        AndNe     'LT'                                         CDL006
     C     CDL006        AndEq     'Y'                                          CDL006
      *                                                                         CDL019
      ** Also allow deal types TI, IP, TD and IT                                CDL019
     C     H@MTYP        AndNe     'TI'                                         CDL019
     C     H@MTYP        AndNe     'IP'                                         CDL019
     C     H@MTYP        AndNe     'TD'                                         CDL019
     C     H@MTYP        AndNe     'IT'                                         CDL019
      *                                                                         CDL019
      * Do not allow PI/PD for IT/IP dealtypes unless                                         240942
      * system value AllowPIPDforITIPD = 'Y'                                                  240942
      *                                                                                       240942
     C     H@MTYP        OrEq      'IT'                                                       240942
     C     DDMTYP        AndEq     'PI'                                                       240942
     C     PRNINT        AndEq     'N'                                                        240942
     C     H@MTYP        OrEq      'IT'                                                       240942
     C     DDMTYP        AndEq     'PD'                                                       240942
     C     PRNINT        AndEq     'N'                                                        240942
     C     H@MTYP        OrEq      'IP'                                                       240942
     C     DDMTYP        AndEq     'PI'                                                       240942
     C     PRNINT        AndEq     'N'                                                        240942
     C     H@MTYP        OrEq      'IP'                                                       240942
     C     DDMTYP        AndEq     'PD'                                                       240942
     C     PRNINT        AndEq     'N'                                                        240942
      *                                                                                       250892
      * Do not allow CI for TD/TI deal types unless                                           250892
      * system value AllowCIforTDTI = 'Y'                                                     250892
      *                                                                                       250892
     C     H@MTYP        OrEq      'TD'                                                       250892
     C     DDMTYP        AndEq     'CI'                                                       250892
     C     AllowCI       AndEq     'N'                                                        250892
     C     H@MTYP        OrEq      'TI'                                                       250892
     C     DDMTYP        AndEq     'CI'                                                       250892
     C     AllowCI       AndEq     'N'                                                        250892
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0302'     Msgid2
     C                   END
     C                   END
      *
      ** Do not allow SC amendments for Fix term deposits unless                              245960
      ** system value AllowSCforFiXD = "Y".                                                   245960
      *                                                                                       245960
     C     DDMTYP        IFEQ      'SC'                                                       245960
     C     PRNINTB       AndEq     'N'                                                        245960
      *                                                                                       245960
     C     H@MTYP        IFeq      'TI'                                                       245960
     C     H@MTYP        OReq      'IP'                                                       245960
     C     H@MTYP        OReq      'TD'                                                       245960
     C     H@MTYP        Oreq      'IT'                                                       245960
     C                   MOVE      'Y'           ErrorFound                                   245960
     C                   MOVEL     'MMM0302'     Msgid2                                       245960
     C                   END                                                                  245960
      *                                                                                       245960
     C                   END                                                                  245960
     C*
     C** For deam type CI or SI next interest date must not be zero
     C**  if interest frequency is not blank
     C     DDMTYP        IFEQ      'SI'
     C     H@IPFQ        ANDNE     *BLANK
     C     H@NIDT        ANDNE     *ZEROS
     C     DDMTYP        OREQ      'CI'
     C     H@IPFQ        ANDNE     *BLANK
     C     H@NIDT        ANDNE     *ZEROS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0303'     Msgid4
     C                   END
     C*
     C** For deam type SI related deal must be IT,IP,TD,TI,CI,LN,
     C** C1,C2,BP,BD.
     C** or CL or CD.
     C** or IL or ID.
     C     DDMTYP        IFEQ      'SI'
     C     H@MTYP        IFNE      'IT'
     C     H@MTYP        ANDNE     'IP'
     C     H@MTYP        ANDNE     'TD'
     C     H@MTYP        ANDNE     'TI'
     C     H@MTYP        ANDNE     'CI'
     C     H@MTYP        ANDNE     'LN'
     C     H@MTYP        ANDNE     'C1'
     C     H@MTYP        ANDNE     'C2'
     C     H@MTYP        ANDNE     'BP'
     C     H@MTYP        ANDNE     'BD'
     C     H@MTYP        ANDNE     'CL'
     C     H@MTYP        ANDNE     'CD'
     C     H@MTYP        ANDNE     'DL'
     C     H@MTYP        ANDNE     'IL'
     C     H@MTYP        ANDNE     'ID'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     H@MTYP        ORNE      'IT'                                         CDL006
     C     H@MTYP        ANDNE     'IP'                                         CDL006
     C     H@MTYP        ANDNE     'TD'                                         CDL006
     C     H@MTYP        ANDNE     'TI'                                         CDL006
     C     H@MTYP        ANDNE     'CI'                                         CDL006
     C     H@MTYP        ANDNE     'LN'                                         CDL006
     C     H@MTYP        ANDNE     'C1'                                         CDL006
     C     H@MTYP        ANDNE     'C2'                                         CDL006
     C     H@MTYP        ANDNE     'BP'                                         CDL006
     C     H@MTYP        ANDNE     'BD'                                         CDL006
     C     H@MTYP        ANDNE     'CL'                                         CDL006
     C     H@MTYP        ANDNE     'CD'                                         CDL006
     C     H@MTYP        ANDNE     'DL'                                         CDL006
     C     H@MTYP        ANDNE     'IL'                                         CDL006
     C     H@MTYP        ANDNE     'ID'                                         CDL006
     C     H@MTYP        ANDNE     'FL'                                         CDL006
     C     H@MTYP        ANDNE     'FT'                                         CDL006
     C     H@MTYP        ANDNE     'DP'                                         CDL006
     C     H@MTYP        ANDNE     'DT'                                         CDL006
     C     H@MTYP        ANDNE     'LP'                                         CDL006
     C     H@MTYP        ANDNE     'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVE      'Y'           ErrorFound
     C     CDL006        IFEQ      'Y'                                          CDL006
     C                   MOVEL     'MMM9020'     Msgid2                         CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0304'     Msgid2
     C                   ENDIF                                                  CDL006
     C                   END
     C                   END
      *                                                                                       CDL017
      ** For deam type EM related deal must be IP,IT,TD or TI.                                CDL017
      *                                                                                       CDL017
     C     DDMTYP        IFEQ      'EM'                                                       CDL017
     C     H@MTYP        IFNE      'IP'                                                       CDL017
     C     H@MTYP        ANDNE     'IT'                                                       CDL017
     C     H@MTYP        ANDNE     'TD'                                                       CDL017
     C     H@MTYP        ANDNE     'TI'                                                       CDL017
     C                   MOVE      'Y'           ErrorFound                                   CDL017
     C                   MOVEL     'MMM0351'     Msgid2                                       CDL017
     C                   ENDIF                                                                CDL017
     C                   ENDIF                                                                CDL017
      *                                                                                       CDL017
      ** For deam type BC related deal must be IP,IT,TD or TI.                                CDL022
      *                                                                                       CDL022
     C     DDMTYP        IFEQ      'BC'                                                       CDL022
     C     H@MTYP        IFNE      'IP'                                                       CDL022
     C     H@MTYP        ANDNE     'IT'                                                       CDL022
     C     H@MTYP        ANDNE     'TD'                                                       CDL022
     C     H@MTYP        ANDNE     'TI'                                                       CDL022
     C                   MOVE      'Y'           ErrorFound                                   CDL022
     C                   MOVEL     'MMM0322'     Msgid2                                       CDL022
     C                   ENDIF                                                                CDL022
     C                   ENDIF                                                                CDL022
      *                                                                                     BUG16257
      ** For deam type BC, SC, or CI, settlement methods should be                          BUG16257
      ** defaulted to 00                                                                    BUG16257
      *                                                                                     BUG16257
     C     DDMTYP        IFEQ      'BC'                                                     BUG16257
     C     DDMTYP        OREQ      'SC'                                                     BUG16257
     C     DDMTYP        OREQ      'CI'                                                     BUG16257
     C                   MOVE      'Y'           WarnFound                                  BUG16257
     C                   MOVEL     'MMM9205'     WMsgid2                                    BUG16257
     C                   ENDIF                                                              BUG16257
     C*
     C** if the deal type is valid, output it
     C                   IF        ErrorFound = 'N'
     C                   MOVE      DDMTYP        IGMTYP
     C                   END
     C*
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C*
     C                   IF        ErrorFound = 'N' AND WarnFound = 'Y'                     BUG16257
     C                   EVAL      RetCodeIn = 'Warning'                                    BUG16257
     C                   ENDIF                                                              BUG16257
     C*                                                                                     BUG16257
     C                   IF        ErrorFound = 'Y' AND WarnFound = 'Y'                     BUG16257
     C                   EVAL      RetCodeIn = 'ErrAndWarn'                                 BUG16257
     C                   ENDIF                                                              BUG16257
     C*                                                                                     BUG16257
     C                   RETURN
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    Msgid3
     C                   PARM                    Msgid4
     C                   PARM                    Msgid5
     C                   PARM                    Msgid6
     C                   PARM                    Msgid7
     C                   PARM                    WMsgid2                                    BUG16257
     C                   PARM                    DDMTYP
     C                   PARM                    DDDLNO
     C                   PARM                    H@DADN
     C                   PARM                    H@VDAT
     C                   PARM                    H@SLDT
     C                   PARM                    H@IADT
     C                   PARM                    H@RCID
     C                   PARM                    H@CPTI
     C                   PARM                    H@MTYP
     C                   PARM                    H@IPFQ
     C                   PARM                    H@NIDT
     C                   PARM                    IGMTYP
     C                   PARM                    @VDYNO
     C                   PARM                    @SLDYN
     C                   PARM                    @IADYN
     C                   PARM                    DDVdatOK
     C                   PARM                    DDDlnoOK
 
      ** Check whether this program should also update spot rates                             240942
     C                   CALLB     'AOSVALR0'                                                 240942
     C                   PARM      *BLANKS       PRtCd             7                          240942
     C                   PARM      PSysVal1      PSysVal01                                    240942
     C                   PARM                    PCurSet01                                    240942
     C**********         PARM                    PSysVal02                             240942 245960
     C                   PARM      PSysVal2      PSysVal02                                    245960
     C                   PARM                    PCurSet02                                    240942
     C**********         PARM                    PSysVal03                             240942 250892
     C                   PARM      PSysVal3      PSysVal03                                    250892
     C                   PARM                    PCurSet03                                    240942
     C                   PARM                    PSysVal04                                    240942
     C                   PARM                    PCurSet04                                    240942
     C                   PARM                    PSysVal05                                    240942
     C                   PARM                    PCurSet05                                    240942
     C                   PARM                    PSysVal06                                    240942
     C                   PARM                    PCurSet06                                    240942
     C                   PARM                    PSysVal07                                    240942
     C                   PARM                    PCurSet07                                    240942
     C                   PARM                    PSysVal08                                    240942
     C                   PARM                    PCurSet08                                    240942
     C                   PARM                    PSysVal09                                    240942
     C                   PARM                    PCurSet09                                    240942
     C                   PARM                    PSysVal10                                    240942
     C                   PARM                    PCurSet10                                    240942
                                                                                              240942
     C                   If        PRtCd <> *Blanks                                           240942
     C     *LOCK         In        LDA                                                        240942
     C                   Eval      DBFile = 'SDSVALPD'                                        240942
     C                   Eval      DBase = 1                                                  240942
     C                   Select                                                               250892
     C                   When      %SUBST(PCurSet01:1:4) = '*NRF'                             250892
     C                   Eval      DBKey = PSysVal01                                          240942
     C                   When      %SUBST(PCurSet02:1:4) = '*NRF'                             250892
     C                   Eval      DBKey = PSysVal02                                          250892
     C                   When      %SUBST(PCurSet03:1:4) = '*NRF'                             250892
     C                   Eval      DBKey = PSysVal03                                          250892
     C                   Endsl                                                                250892
     C                   Out       LDA                                                        240942
     C                   ExSR      *PSSR                                                      240942
     C                   EndIf                                                                240942
                                                                                              240942
      * Isolate the first character of the current system value setting                       240942
     C                   MOVEL     PCurSet01     PRNINT            1                          240942
     C                   MOVEL     PCurSet02     PRNINTB           1                          245960
     C                   MOVEL     PCurSet03     AllowCI           1                          250892
 
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
