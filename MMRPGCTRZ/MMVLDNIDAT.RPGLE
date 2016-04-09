     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate dates for loans & deposits')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVLDNIDAT - Validate dates for loans, deposits and          *
      *               negotiable assets issued.                       *
      *                                                               *
      *  Function:  This module cross-validates the various date      *
      *             fields on a LDNI transaction.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. MD029724           Date 24Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249967             Date 12Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL033             Date 10Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 209738             Date 20Sep02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212388             Date 02Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 26Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD029724 - Rollover not allowed before maturity for deposits *
      *             with Taxable Indicator not equal to 'T'(Threshold)*
      *           - Include the taxable indicator in the rollover     *
      *             validation                                        *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER048 - German Features - Taxes                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249967 - Restrict validation of VDAT to insert               *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209738 - For Int Freq "N" deals the NIDT is being corrupted  *
      *           on amend action.  Fix is to apply 196996 and 206242 *
      *           from TCV.                                           *
      *  212388 - More important error messages are being overidden   *
      *           by warning messages if both messages are for the    *
      *           same field.                                         *
      *  CSE006 - Repos Maintenance                                   *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
      *                                                                                       CER048
      ** First DS For Access Programs, Short Data Structure                                   CER048
      *                                                                                       CER048
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER048
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Message ID 1 (7A, returned to caller)
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Message ID 2 (7A, returned to caller)
     D Msgid2          S                   LIKE(#MsgID)
 
      ** Message ID 3 (7A, returned to caller)
     D Msgid3          S                   LIKE(#MsgID)
 
      ** Message ID 4 (7A, returned to caller)
     D Msgid4          S                   LIKE(#MsgID)
 
      ** Message ID 5 (7A, returned to caller)
     D Msgid5          S                   LIKE(#MsgID)
 
      ** Message ID 6 (7A, returned to caller)
     D Msgid6          S                   LIKE(#MsgID)
 
      ** Message ID 7 (7A, returned to caller)
     D Msgid7          S                   LIKE(#MsgID)
      *                                                                                     BUG23732
      ** Message ID 8 (7A, returned to caller)                                              BUG23732
     D Msgid8          S                   LIKE(#MsgID)                                     BUG23732
 
      ** Warning message ID 1 (7A, returned to caller)
     D WMsgid1         S                   LIKE(#MsgID)
 
      ** Warning message ID 2 (7A, returned to caller)
     D WMsgid2         S                   LIKE(#MsgID)
 
      ** Warning message ID 3 (7A, returned to caller)
     D WMsgid3         S                   LIKE(#MsgID)
 
      ** Warning message ID 4 (7A, returned to caller)
     D WMsgid4         S                   LIKE(#MsgID)
 
      ** Warning message ID 5 (7A, returned to caller)
     D WMsgid5         S                   LIKE(#MsgID)
 
      ** Warning message ID 6 (7A, returned to caller)
     D WMsgid6         S                   LIKE(#MsgID)
 
      ** Warning message ID 7 (7A, returned to caller)
     D WMsgid7         S                   LIKE(#MsgID)
      **********                                                                     CER048 BUG23732
      ***Warning*message*ID*8*(7A,*returned*to*caller)                               CER048 BUG23732
      **********                                                                     CER048 BUG23732
     D*WMsgid8**       S                   LIKE(#MsgID)                              CER048 BUG23732
     D WMsgid8         S                   LIKE(#MsgID)                                       CDL096
     D WMsgDta8        S                   LIKE(#MsgData)                                     CDL096
     D PCurrency       S              3A   Dim(10)                                            CDL096
 
      ** Error in deal date flag (1A, returned to caller)
     D ErrDealDat      S                   LIKE(ErrorFound)
 
      ** Error in value date flag (1A, returned to caller)
     D ErrValDate      S                   LIKE(ErrorFound)
 
      ** Error in Maturity date flag (1A, returned to caller)
     D ErrMatDate      S                   LIKE(ErrorFound)
 
      ** Error in Next interest date flag (1A, returned to caller)
     D ErrNxInDat      S                   LIKE(ErrorFound)
 
      ** Deal file version of deal date (5,0P, returned from this module)
     D IKDDND          S              5P 0
 
      ** Deal file version of value date (5,0P, returned from this module)
     D IKDVSD          S                   LIKE(IKDDND)
 
      ** Deal file version of start/last interest date
      ** (5,0P, returned from this module)
     D IKSLID          S                   LIKE(IKDDND)
 
      ** Deal file version of maturity date (5,0P, returned from
      ** this module)
     D IKMATD          S                   LIKE(IKDDND)
 
      ** Deal file version of next interest payment date
     D IKNIPD          S                   LIKE(IKDDND)
 
      ** Deal date (6A, from transaction)
     D DDDLDT          S              6A
 
      ** Value date (6A, from transaction)
     D DDVDAT          S                   LIKE(DDDLDT)
 
      ** Maturity date (6A, from transaction)
     D DDMDAT          S                   LIKE(DDDLDT)
 
      ** Next interest date (6A, from transaction)
     D DDNDAT          S                   LIKE(DDDLDT)
 
      ** Run date (5,0P (Midas day number) from SDBANKPD via caller)
     D BJRDNB          S                   LIKE(IKDDND)
 
      ** Date format indicator (1A, from SDBANKPD via caller)
     D BJDFIN          S              1A
 
      ** Local Currency code (3A, from SDBANKPD via caller)
     D BJLCCY          S              3A
 
      ** Branch Location Code (3A, from SDBRCHPD via caller)
     D A8LCCD          S              3A
 
      ** Deal currency (3A, from transaction)
     D DDCCY           S                   LIKE(BJLCCY)
 
      ** Deal type (2A, from transaction)
     D DDTYPE          S              2A
 
      ** Error codes (150A, from caller)
     D PMERCD          S            150A
 
      ** Pay - settlement currency (3A, from caller)
     D PMPSCY          S              3A
 
      ** Pay - our nostro (12A, from caller)
     D***PMPONS*         S             12A                                                    CGL029
     D PMPONS          S             18A                                                      CGL029
 
      ** Pay - settlement method (2,0S, from caller)
     D PMPSTM          S              2S 0
 
      ** Receive - settlement currency (3A, from caller)
     D PMRSCY          S              3A
 
      ** Receive - our nostro (12A, from caller)
     D PMRONS          S                   LIKE(PMPONS)
 
      ** Receive - settlement method (2,0S, from caller)
     D PMRSTM          S                   LIKE(PMPSTM)
 
      ** Interest payment frequency (1A, from transaction)
     D DDIPFQ          S              1A
 
      ** Japanese sub-module on (1A, from caller)
     D S01391          S              1A
 
      ** Action Code (1A, from transaction)
     D DDACTN          S              1A
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
     D CDL096          S              1A   IMPORT                                             CDL096
                                                                                CSE006
      ** Flag Indicating if screen input program is MMREPOSIN                   CSE006
     D RepoFlag        S              1A                                        CSE006
 
     D CER048          S              1A                                                      CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
     D DDDADN          S              6A                                                      CER048
      *                                                                                       CER048
      ** End of parameters
      ** =================
 
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
 
      ** Reset the individual date error flags
     C                   RESET                   ErrDealDat
     C                   RESET                   ErrValDate
     C                   RESET                   ErrMatDate
     C                   RESET                   ErrNxInDat
      *
      * Effective settlement currency
      *
     C     PMPSCY        IFNE      *BLANKS
     C                   MOVEL     PMPSCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     DDCCY         EffSetCcy         3
     C                   ENDIF
 
      ** Do the validation of the individual date fields
     C                   EXSR      ValDates
 
      ** Do the cross-validation
     C                   EXSR      CrossVal
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   IF        (IKDVSD > BJRDNB) AND                                      CER048
     C                             (DDDADN <> *BLANKS AND                                     CER048
     C**********                   DDDADN <> '000000')                               CER048 BUG23732
     C                             DDDADN <> '000000') AND                                  BUG23732
     C                             DDTYPE = 'TD'                                            BUG23732
     C                             AND DDTAXI = 'T'                                         MD029724
     C**********         EVAL      WarnFound = 'Y'                                   CER048 BUG23732
     C**********         EVAL      WMsgid8 = 'MMM1076'                               CER048 BUG23732
     C**********         EVAL      ErrValDate = 'W'                                  CER048 BUG23732
     C                   EVAL      ErrorFound = 'Y'                                         BUG23732
     C                   EVAL      Msgid8 = 'MMM1076'                                       BUG23732
     C                   EVAL      ErrValDate = 'Y'                                         BUG23732
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CrossVal - Does cross-validation among the various date fields*
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: DealDate, MatDate, NextIntDat                          *
      *                                                               *
      *****************************************************************
 
     C     CrossVal      BEGSR
 
      ** +--------------------------------------+
      ** ¦ Deal date                            ¦
      ** ¦ =========                            ¦
      ** +--------------------------------------+
 
      **  If the deal date is valid, carry out further validation.
     C**********         IF        ErrDealDat = 'N'                                           212388
     C                   IF        ErrDealDat <> 'Y'                                          212388
     C                   EXSR      DealDate
     C                   ENDIF
 
      ** +--------------------------------------+
      ** ¦ Value date                           ¦
      ** ¦ ==========                           ¦
      ** ¦ No extra cross-checks for value date ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Maturity date                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
 
      **  If the maturity date is valid, carry out further validation.
     C**********         IF        ErrMatDate = 'N'                                           212388
     C                   IF        ErrMatDate <> 'Y'                                          212388
     C                   EXSR      MatDate
     C                   ENDIF
 
      ** +--------------------------------------+
      ** ¦ Next interest date                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **  If the next interest date is valid and nonblank, carry out
      **  further validation.
     C**********         IF        ErrNxInDat = 'N' AND DDNDAT <> *blanks                     212388
     C                   IF        ErrNxInDat <> 'Y' AND DDNDAT <> *blanks                    212388
     C                   EXSR      NextIntDat
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * NextIntDat - Cross-validation of next interest date           *
      *                                                               *
      * Called by: CrossVal                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     NextIntDat    BEGSR
 
      **  Check that the next interest date is after the value date.
      **  (If the value date has been entered and is valid.)
     C     IKDVSD        IFNE      *ZEROS
     C*****ErrValDate    ANDEQ     'N'                                                        212388
     C     ErrValDate    ANDNE     'Y'                                                        212388
     C     IKNIPD        ANDLE     IKDVSD
     C     DDIPFQ        ANDNE     'N'
     C     IKDVSD        ORNE      *ZEROS
     C*****ErrValDate    ANDEQ     'N'                                                        212388
     C     ErrValDate    ANDNE     'Y'                                                        212388
     C     IKNIPD        ANDLT     IKDVSD
     C     DDIPFQ        ANDEQ     'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrNxInDat = 'Y'
     C                   MOVEL     'MMM0440'     MsgID6
     C                   END
 
      **  Check that the next interest date is before the mat. date.
      **  (If the maturity date has been entered and is valid.)
     C     DDMDAT        IFNE      *BLANKS
     C     DDMDAT        ANDNE     *ZEROS
     C*****ErrMatDate    ANDEQ     'N'                                                        212388
     C*****ErrNxInDat    ANDEQ     'N'                                                        212388
     C     ErrMatDate    ANDNE     'Y'                                                        212388
     C     ErrNxInDat    ANDNE     'Y'                                                        212388
     C     DDIPFQ        ANDNE     'N'
     C     IKNIPD        ANDGE     IKMATD
     C                   EVAL      ErrMatDate = 'Y'
     C                   EVAL      ErrNxInDat = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0441'     MsgID7
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MatDate - Cross-validation of maturity date                   *
      *                                                               *
      * Called by: CrossVal                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MatDate       BEGSR
 
      **  Check that the maturity date is after the value date.
      **  if the Japanese Sub Module is not installed,
      **  else that it is not less than the value date
      **  if the Japanese Sub Module is installed and the deal
      **  is an interbank deposit placed or taken
 
     C                   IF        DDMDAT <> *blanks
 
     C     IKMATD        IFLE      IKDVSD
     C     S01391        ANDNE     'Y'
     C     IKMATD        ORLT      IKDVSD
     C     S01391        ANDEQ     'Y'
     C     DDTYPE        ANDEQ     'IP'
     C     IKMATD        ORLT      IKDVSD                                       CDL006
     C     S01391        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        ANDEQ     'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMATD        ORLT      IKDVSD
     C     S01391        ANDEQ     'Y'
     C     DDTYPE        ANDEQ     'IT'
     C     IKMATD        ORLE      IKDVSD
     C     S01391        ANDEQ     'Y'
     C     DDTYPE        ANDNE     'IP'
     C     DDTYPE        ANDNE     'IT'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     IKMATD        ORLE      IKDVSD                                       CDL006
     C     S01391        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        ANDNE     'IP'                                         CDL006
     C     DDTYPE        ANDNE     'IT'                                         CDL006
     C     DDTYPE        ANDNE     'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrMatDate = 'Y'
     C                   MOVEL     'MMM0130'     MsgID4
     C                   END
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DealDate - Cross-validation of deal date                      *
      *                                                               *
      * Called by: CrossVal                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DealDate      BEGSR
 
      **  The deal date must not be greater than the value date.
 
      **  If the value date is invalid then this check is not carried
      **  out.
     C**********         IF        ErrValDate = 'N'                                           212388
     C                   IF        ErrValDate <> 'Y'                                          212388
     C     IKDDND        IFGT      IKDVSD
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrDealDat  ='Y'
     C                   MOVEL     'MMM0250'     MsgID2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDates - Validate the individual date fields                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: External routines MMVDLDATE, MMVVALDAT, MMVMATDAT,     *
      *                          MMVNXINTDT                           *
      *                                                               *
      *****************************************************************
 
     C     ValDates      BEGSR
 
      ** Validate Deal date
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVDLDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    WMsgid1
     C                   PARM                    IKDDND
     C                   PARM                    DDDldt
     C                   PARM                    BJRdnb
     C                   PARM                    BJDfin
     C                   PARM                    WarnGlobal
     C                   PARM                    BJLCCY
     C                   PARM                    A8LCCD
 
      ** If errors and/or warnings found in deal date, set the appropriate
      ** return code and error flag
     C                   SELECT
 
     C                   WHEN      ReturnCode = 'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrDealDat = 'Y'
 
     C                   WHEN      ReturnCode = 'Warning'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrDealDat = 'W'
 
     C                   WHEN      ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrDealDat = 'Y'
 
     C                   ENDSL
 
      ** Validate value date
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVVALDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid3
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3
     C                   PARM                    IKDVSD
     C                   PARM                    IKSLID
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJRDNB
     C                   PARM                    A8LCCD
     C                   PARM                    EffSetCcy
     C                   PARM                    DDTYPE
     C                   PARM                    DDVDAT
     C                   PARM                    PMERCD
     C                   PARM                    PMPONS
     C                   PARM                    PMPSTM
     C                   PARM                    PMRONS
     C                   PARM                    PMRSTM
     C                   PARM                    TransType
     C                   PARM                    DDACTN                                       249967
 
      ** If errors and/or warnings found in value date, set the appropriate
      ** return code and error flag
     C                   SELECT
 
     C                   WHEN      ReturnCode = 'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrValDate = 'Y'
 
     C                   WHEN      ReturnCode = 'Warning'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrValDate = 'W'
 
     C                   WHEN      ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrValDate = 'Y'
 
     C                   ENDSL
 
      ** Validate maturity date
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVMATDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid4
     C                   PARM                    Msgid5
     C                   PARM                    WMsgid4
     C                   PARM                    WMsgid5
     C                   PARM                    IKMATD
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJRDNB
     C                   PARM                    A8LCCD
     C                   PARM                    DDTYPE
     C                   PARM                    EffSetCcy
     C                   PARM                    DDMDAT
     C                   PARM                    PMERCD
     C                   PARM                    PMPONS
     C                   PARM                    PMPSTM
     C                   PARM                    PMRONS
     C                   PARM                    PMRSTM
     C                   PARM                    DDACTN
     C                   PARM                    RepoFlag                       CSE006
     C                   PARM                    CDL033                                       CDL033
 
      ** If errors and/or warnings found in maturity date, set the
      ** appropriate return code and error flag
     C                   SELECT
 
     C                   WHEN      ReturnCode = 'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrMatDate = 'Y'
 
     C                   WHEN      ReturnCode = 'Warning'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrMatDate = 'W'
 
     C                   WHEN      ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrMatDate = 'Y'
 
     C                   ENDSL
 
      ** Validate next interest date
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVNXINTDT'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid6
     C                   PARM                    WMsgid6
     C                   PARM                    WMsgid7
     C                   PARM                    IKNIPD
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    A8LCCD
     C                   PARM                    DDTYPE
     C                   PARM                    EffSetCcy
     C                   PARM                    DDNDAT
     C                   PARM                    DDVDAT
     C                   PARM                    DDIPFQ
     C                   PARM                    PMERCD
     C                   PARM                    PMPONS
     C                   PARM                    PMPSTM
     C                   PARM                    PMRONS
     C                   PARM                    PMRSTM
     C                   PARM                    WarnGlobal
     C                   PARM                    DDACTN                         209738
     C                   PARM                    BJRDNB                         209738
     C                   PARM                    IKSLID                         209738
     C                   Parm                    PCurrency                                    CDL096
     C                   PARM                    WMsgid8                                      CDL096
     C                   Parm                    WMsgDta8                                     CDL096
 
      ** If errors and/or warnings found in next interest date, set the
      ** appropriate return code and error flag
     C                   SELECT
 
     C                   WHEN      ReturnCode = 'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrNxInDat = 'Y'
 
     C                   WHEN      ReturnCode = 'Warning'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrNxInDat = 'W'
 
     C                   WHEN      ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrNxInDat = 'Y'
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** -------------------------------------------------------------------
      ** All message IDs are 7A, returned to caller
      ** Message IDs 1 and 2 indicate errors in Deal Date
      ** Message ID 3 indicates error in Value Date
      ** Message IDs 4 and 5 indicate errors in Maturity Date
      ** Message IDs 6 and 7 indicate error in Next Interest Date
      ** -------------------------------------------------------------------
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    Msgid3
     C                   PARM                    Msgid4
     C                   PARM                    Msgid5
     C                   PARM                    Msgid6
     C                   PARM                    Msgid7
     C                   PARM                    Msgid8                                     BUG23732
      ** -------------------------------------------------------------------
      ** All Warning message IDs are 7A, returned to caller
      ** Warning Message ID 1 indicates warnings in Deal Date
      ** Warning Message IDs 2 and 3 indicate warnings in Value Date
      ** Warning Message IDs 4 and 5 indicate warnings in Maturity Date
      ** Warning Message IDs 6 and 7 indicate warnings in Next Interest Date
      ** Warning Message ID 8 indicates warning for Next Interest Date                        CDL096
      **   being holiday in one or more Business Day Conventions                              CDL096
      **   Currencies                                                                         CDL096
      ** -------------------------------------------------------------------
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3
     C                   PARM                    WMsgid4
     C                   PARM                    WMsgid5
     C                   PARM                    WMsgid6
     C                   PARM                    WMsgid7
     C**********         PARM                    WMsgid8                             CER048 BUG23732
     C                   PARM                    WMsgid8                                      CDL096
     C                   PARM                    WMsgDta8                                     CDL096
      ** Error in deal date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrDealDat
      ** Error in value date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrValDate
      ** Error in Maturity date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrMatDate
      ** Error in Next interest date flag (1A, returned to caller; contains
      ** 'Y' if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrNxInDat
      ** Deal file version of deal date (5,0P, returned from
      ** this module)
     C                   PARM                    IKDDND
      ** Deal file version of value date (5,0P, returned from
      ** this module)
     C                   PARM                    IKDVSD
      ** Deal file version of start/last interest date
      ** (5,0P, returned from this module)
     C                   PARM                    IKSLID
      ** Deal file version of maturity date (5,0P, returned by
      ** this module)
     C                   PARM                    IKMATD
      ** Deal File version of next interest payment date
      ** (5,0P, returned from this module)
     C                   PARM                    IKNIPD
      ** Deal date (6A, from transaction)
     C                   PARM                    DDDLDT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Maturity date (6A, from transaction)
     C                   PARM                    DDMDAT
      ** Next interest date (6A, from transaction)
     C                   PARM                    DDNDAT
      *                                                                                       CER048
      ** Rollover Deal No                                                                     CER048
      *                                                                                       CER048
     C                   PARM                    DDDADN                                       CER048
      *                                                                                       CER048
      ** Run date (5,0P (Midas day number) from SDBANKPD via caller)
     C                   PARM                    BJRDNB
      ** Date format indicator (1A, from SDBANKPD via caller)
     C                   PARM                    BJDFIN
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Branch Location Code (3A, from SDBRCHPD via caller)
     C                   PARM                    A8LCCD
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Error codes (150A, from caller)
     C                   PARM                    PMERCD
      ** Pay - settlement currency (3A, from caller)
     C                   PARM                    PMPSCY
      ** Pay - our nostro (12A, from caller)
     C                   PARM                    PMPONS
      ** Pay - settlement method (2,0S, from caller)
     C                   PARM                    PMPSTM
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    PMRSCY
      ** Receive - our nostro (12A, from caller)
     C                   PARM                    PMRONS
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    PMRSTM
      ** Interest payment frequency (1A, from transaction)
     C                   PARM                    DDIPFQ
      ** Japanese sub-module on (1A, from caller)
     C                   PARM                    S01391
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
      ** Transaction type (4A, from caller)
     C                   PARM                    TransType
      ** Action Code (1A, from transaction)
     C                   PARM                    DDACTN
      ** Flag Indicating if screen input program is MMREPOSIN                   CSE006
     C                   PARM                    RepoFlag                       CSE006
      ** Floating Rate CDs Issued                                                             CDL033
     C                   PARM                    CDL033            1                          CDL033
      ** Business Day Convention Currencies                                                   CDL096
     C                   PARM                    PCurrency                                    CDL096
      ** Taxable Indicator                                                                  MD029724
     C                   PARM                    DDTAXI            1                        MD029724
 
      *                                                                                       CER048
      ** Access SAR details file to determine if CER048 is installed                          CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database Error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd  <> *BLANKS AND                                      CER048
     C                             PRtcd <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 001                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Initialise error flags (can't be done using INZ keyword in
      ** D-specs because they are on the parameter list)
     C                   EVAL            ErrDealDat = 'N'
     C                   EVAL            ErrValDate = 'N'
     C                   EVAL            ErrMatDate = 'N'
     C                   EVAL            ErrNxInDat = 'N'
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
