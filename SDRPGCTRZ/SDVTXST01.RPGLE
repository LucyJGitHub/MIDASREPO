     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate European Tax Status')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTXST01 - Validate European Tax Status                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR743761           Date 16Apr11               *
      *                 AR740196           Date 03Apr11               *
      *                 AR738919           Date 29Mar11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 28Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR743761  - The pay/rec confirmation job DLC0211 encountered *
      *              a DB Error (Child:743762)                        *
      *  AR740196  - Cannot enquire on deal for non-resident using    *
      *              Deals Enquiry (Child:AR740197)                   *
      *  AR738919 - Serious midas error when tax                      *
      *             status = 'T' (Child:AR738920)                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Additional Customer Details File - by Customer number
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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

      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
                                                                                              CER069
      ** External DS for SAR Details                                                          CER069
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER069

      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)

      ** New Details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)

      ** Valid Customer Details                                                             AR740196
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)                               AR740196
     D                                     PREFIX(A_)                                       AR740196
      ** Valid Additional Customer Details                                                  AR740196
     D ValidCuad     E DS                  EXTNAME(SDVCUADPD)                               AR740196
     D                                     PREFIX(B_)                                       AR740196
      ** Screen Error Indicator
     D OKFlags       E DS                  EXTNAME(SDECCTXPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Work Variables
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY            S             10A
     D PKYST           S              7A
     D PCTRT           S              2A
     D PCTRR           S              2A
     D CER069          S              1A                                                      CER069
     D PSard           S              6A                                                      CER069
                                                                                              232543
      ** Mode of Operation                                                                    232543
     D PModeOfOp       S              6A                                                      232543

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   MOVE      *BLANK        RetCodeIn

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
                                                                                            AR740196
     C                   IF        PModeOfOp =  '*VU '                                      AR740196
     C                   EVAL      BBCOLC  = A_CUCOLC                                       AR740196
     C                   EVAL      E5JATP  = B_ADJATP                                       AR740196
     C                   ENDIF                                                              AR740196

      ** Retrieve account type.

     C     DDCUST        CHAIN     SDACUSL1                           01

     C                   IF        *IN01 = *ON
                                                                                              232543
      ** Customer not found in SIN mode, database error.                                      232543
                                                                                              232543
     C**********         IF        PModeOfOp = '*SIN'                                  232543 CER059
     C                   SELECT                                                               CER059
     C                   WHEN      PModeOfOp = '*SIN'                                         CER059
                                                                                              232543
     C                   MOVEL     'SDACUSPD'    DBFILE
     C                   MOVEL     PKEY          DBKEY
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
                                                                                              232543
      ** If *VU mode, record is being inserted via CSDU API.                                  CER059
                                                                                              CER059
     C                   WHEN      PModeOfOp = '*VU '                                         CER059
                                                                                              CER059
     C                   OTHER                                                                CER059
     C**********         ELSE                                                          232543 CER059
                                                                                              232543
      ** Customer not found in CTL/RPR mode, place transaction on repair queue.               232543
                                                                                              232543
     C                   EVAL      Idx = Idx + 1                                              232543
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'                                  232543
     C                   EVAL      MsgIDXAr(Idx) = 'USR4801'                                  232543
     C                   EVAL      OKETXS = 'N'                                               232543
     C                   GOTO      EMAIN                                                      232543
                                                                                              232543
     C**********         ENDIF                                                         232543 CER059
     C                   ENDSL                                                                CER059
                                                                                              232543
     C                   ENDIF

      ** If entry is blank and account type is private individual, get default tax status.

     C                   IF        DDETXS = *BLANK AND
     C                             E5JATP = 'I'                                             AR740196
     C**********                   E5JATP = 'I'                                    AR738919 AR740196
     C**********                   E5JATP = 'I' AND                                AR738919 AR740196
     C**********                   PModeOfOp <> '*VU '                             AR738919 AR740196
     C                   IF        PModeOfOp <> '*VU '                                      AR740196

     C                   EVAL      PKEY = DDCUST

      ** Retrieve Country of Residence.

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PKEY          DBKEY
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                              AR740196

      ** Retrieve Default Tax Status using Country of Residence.

     C                   CALLB     'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCTTX        PCTRT
     C                   PARM      BBCOLC        PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF'

      ** Retrieve Default Tax Status without Country of Residence.

     C                   CALLB     'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCTTX        PCTRT
     C                   PARM      *BLANKS       PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DDETXS = EWTXS1
     C                   ENDIF

     C                   ENDIF

      ** Determine if status is valid

     C                   IF        DDETXS = 'S' OR
     C                             DDETXS = 'D' OR
     C                             DDETXS = 'T' OR
     C                             DDETXS = 'Y' AND                                           CER069
     C                             CER069 = 'Y' OR                                            CER069
     C                             DDETXS = 'E' OR
     C                             DDETXS = ' ' AND
     C                             E5JATP <> 'I'

     C                   EVAL      OKETXS = 'Y'

     C                   ELSE

      ** Status must be one of S/D/T/E

     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'
     C                   IF        CER069 = 'Y'                                               CER069
     C                   EVAL      MsgIDXAr(Idx) = '5046494'                                  CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR4780'
     C                   ENDIF                                                                CER069
     C                   EVAL      OKETXS = 'N'
     C                   GOTO      EMAIN

     C                   ENDIF

      ** If Tax Status is Taxable, access record from Countries of Tax                        232543
      ** error if missing or has no Account Code and Tax Basket                               232543
                                                                                              232543
     C**********         IF        DDETXS = 'T'                                      232543 AR743761
     C                   IF        DDETXS = 'T' OR                                          AR743761
     C                             DDETXS = ' ' OR                                          AR743761
     C                             DDETXS = 'D' OR                                          AR743761
     C                             DDETXS = 'Y' AND                                           CER069
     C                             CER069 = 'Y' OR                                            CER069
     C                             DDETXS = 'E' OR                                          AR743761
     C                             DDETXS = 'S'                                             AR743761
     C**********                   AND PModeOfOp <> '*VU '                         AR738919 AR740196
     C                   IF        PModeOfOp <> '*VU '                                      AR740196
                                                                                              232543
     C                   EVAL      PKEY = DDCUST                                              232543
     C                   CALLB     'AOCUSTR0'                                                 232543
     C                   PARM      *BLANKS       PRTCD                                        232543
     C                   PARM      '*KEY   '     POPTN                                        232543
     C                   PARM                    PKEY                                         232543
     C                   PARM      *BLANKS       PKYST                                        232543
     C     SDCUST        PARM      SDCUST        DSSDY                                        232543
                                                                                              232543
     C                   IF        PRTCD <> *BLANKS                                           232543
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       232543
     C                   MOVEL     PKEY          DBKEY                                        232543
     C                   Z-ADD     003           DBASE                                        232543
     C                   EXSR      *PSSR                                                      232543
     C                   ENDIF                                                                232543
     C                   ENDIF                                                              AR740196
                                                                                              232543
      ** Retrieve Default Tax Status using Country of Residence.                              232543
                                                                                              232543
     C                   CALLB     'AOCTTXR0'                                                 232543
     C                   PARM      *BLANKS       PRTCD                                        232543
     C                   PARM      '*KEY   '     POPTN                                        232543
     C                   PARM      DDCTTX        PCTRT                                        232543
     C                   PARM      BBCOLC        PCTRR                                        232543
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        232543
                                                                                              232543
     C                   IF        PRTCD <> *BLANKS                                           232543
     C                             Or EWTXBS = *BLANKS                                        232543
     C                             Or EWWTAC = *BLANKS                                        232543
     C                   IF        DDETXS = 'T'                                             AR743761
     C                             OR DDETXS = 'Y'                                            CER069
     C                   EVAL      Idx = Idx + 1                                              232543
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'                                  232543
     C                   IF        CER069 = 'Y'                                               CER069
     C                   EVAL      MsgIDXAr(Idx) = '5046495'                                  CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR4802'                                  232543
     C                   ENDIF                                                                CER069
     C                   EVAL      OKETXS = 'N'                                               232543
     C                   GOTO      EMAIN                                                      232543
     C                   ELSE                                                               AR743761
     C                   IF        PRTCD <> *BLANKS                                         AR743761
     C                   EVAL      Idx = Idx + 1                                            AR743761
     C                   EVAL      FldNamXAr(Idx) = 'DDCTTX'                                AR743761
     C                   EVAL      MsgIDXAr(Idx) = 'USR4996'                                AR743761
     C                   EVAL      OKCTTX = 'N'                                             AR743761
     C                   GOTO      EMAIN                                                    AR743761
     C                   ENDIF                                                              AR743761
     C                   ENDIF                                                              AR743761
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Return to calling program

     C                   EVAL      CTETXS = DDETXS

     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Input Parameters
      ** Return Code
     C                   PARM                    RetCodeIn
                                                                                              232543
      ** Mode of Operation                                                                    232543
     C                   PARM                    PModeOfOp                                    232543

      ** New Detail in Screen Format
     C                   PARM                    NwDlScnFmt

     C                   PARM                    ValidCusd                                  AR740196
     C                   PARM                    ValidCuad                                  AR740196
      ** Output Parameters
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Screen Error Indicator
     C                   PARM                    OKFlags

      ** New Detail in File Format
     C                   PARM                    NwDlFilFmt

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS
                                                                                              CER069
      ** Access SAR file to determine if CER069 is present.                                   CER069
                                                                                              CER069
     C                   EVAL      CER069 = 'N'                                               CER069
                                                                                              CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtCd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
                                                                                              CER069
     C                   IF        PRtCd <> *BLANKS AND                                       CER069
     C                             PRtCd <> '*NRF'                                            CER069
     C     *LOCK         IN        LDA                                                        CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBASE = 4                                                  CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   IF        PRtCd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ENDIF                                                                CER069

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
