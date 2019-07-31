     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Tax Status for Non-a/c Holder')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTXST02 - Validate European Tax Status for Non-A/C Holder  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER069             Date 03Jul14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 28Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER069 - German Tax Enhancement                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
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
                                                                                              CER069
      ** External data structure for access programs (short)                                  CER069
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER069
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** External data structure for access programs (long)                                 BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** External DS for Non-A/C Holder
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
                                                                                              CER069
      ** External DS for SAR Details                                                          CER069
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER069
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDNATXPD)
 
      ** New Details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVNATXPD)
 
      ** Screen Error Indicator
     D OKFlags       E DS                  EXTNAME(SDENATXPD)
                                                                                              232543
      ** Mode of Operation                                                                    232543
     D PModeOfOp       S              6A                                                      232543
 
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
     D PKEY1           S             10A
     D PKEY2           S             10A
     D PKYST           S              7A
     D CER069          S              1A                                                      CER069
     D PSard           S              6A                                                      CER069
 
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
 
     C                   MOVE      *Blanks       RetCodeIn
 
     C                   MOVE      *Blanks       FldNamXAr
     C                   MOVE      *Blanks       MsgIDXAr
     C                   MOVE      *Blanks       MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** If blank, get default status
 
     C                   IF        DDETXS = *Blanks
 
      ** Access Country of Residence via Access Object
 
     C                   CALLB     'AONAHOR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDNAHO        PKEY1
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRTCD <> *Blanks
                                                                                              232543
      ** Customer not found in SIN mode, database error.                                      232543
                                                                                              232543
     C                   IF        PModeOfOp = '*SIN'                                         232543
 
     C                   MOVEL     'SDNAHOPD'    DBFILE
     C                   MOVEL     PKEY1         DBKEY
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
                                                                                              232543
     C                   ELSE                                                                 232543
                                                                                              232543
      ** Customer not found in CTL/RPR mode, place transaction on repair queue.               232543
                                                                                              232543
     C                   EVAL      Idx = Idx + 1                                              232543
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'                                  232543
     C                   EVAL      MsgIDXAr(Idx) = 'USR4801'                                  232543
     C                   EVAL      OKETXS = 'N'                                               232543
     C                   GOTO      EMAIN                                                      232543
                                                                                              232543
     C                   ENDIF                                                                232543
 
     C                   ELSE
 
     C                   CALLB     'AOCTTXR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCTTX        PKEY1
     C                   PARM      NHCOLC        PKEY2
     C     SDCTTX        PARM      SDCTTX        DSSDY
 
     C                   IF        PRTCD = *Blanks
 
      ** Preventative codings: If default is blank, send error message.
 
     C                   IF        EWTXS1 = *Blanks
 
      ** Status must be one of S/D/T/E
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'
     C                   IF        CER069 = 'Y'                                               CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR5450'                                  CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR4780'
     C                   ENDIF                                                                CER069
     C                   EVAL      OKETXS = 'N'
     C                   GOTO      EMAIN
 
     C                   ELSE
 
     C                   EVAL      DDETXS = EWTXS1
     C                   EVAL      OKETXS = 'Y'
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      DDETXS = 'E'
     C                   EVAL      OKETXS = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Determine if status is valid
 
     C                   IF        DDETXS <> *Blanks
 
     C                   IF        (DDETXS = 'S') Or (DDETXS = 'D') Or
     C                             (DDETXS = 'T') Or (DDETXS = 'E')
     C                             Or (DDETXS = 'Y' And CER069 = 'Y')                         CER069
     C                   EVAL      OKETXS = 'Y'
 
     C                   ELSE
 
      ** Status must be one of S/D/T/E
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'
     C                   IF        CER069 = 'Y'                                               CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR5450'                                  CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR4780'
     C                   ENDIF                                                                CER069
     C                   EVAL      OKETXS = 'N'
     C                   GOTO      EMAIN
 
     C                   ENDIF
     C                   ENDIF
 
      ** If Tax Status is Taxable, access record from Countries of Tax                        232543
      ** error if missing or has no Account Code and Tax Basket                               232543
                                                                                              232543
     C                   IF        DDETXS = 'T'                                               232543
     C                             OR DDETXS = 'Y' AND CER069 = 'Y'                           CER069
                                                                                              232543
     C                   CALLB     'AONAHOR0'                                                 232543
     C                   PARM      *Blanks       PRTCD                                        232543
     C                   PARM      '*KEY   '     POPTN                                        232543
     C                   PARM      DDNAHO        PKEY1                                        232543
     C*****SDNAHO        PARM      SDNAHO        DSSDY                               232543 BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
                                                                                              232543
     C                   IF        PRTCD <> *Blanks                                           232543
     C                   MOVEL     'SDNAHOPD'    DBFILE                                       232543
     C                   MOVEL     PKEY1         DBKEY                                        232543
     C                   Z-ADD     002           DBASE                                        232543
     C                   EXSR      *PSSR                                                      232543
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Retrieve Default Tax Status using Country of Residence.                              232543
                                                                                              232543
     C                   CALLB     'AOCTTXR0'                                                 232543
     C                   PARM      *Blanks       PRTCD                                        232543
     C                   PARM      '*KEY   '     POPTN                                        232543
     C                   PARM      DDCTTX        PKEY1                                        232543
     C                   PARM      NHCOLC        PKEY2                                        232543
     C     SDCTTX        PARM      SDCTTX        DSSDY                                        232543
                                                                                              232543
     C                   IF        PRTCD <> *Blanks                                           232543
     C                             Or EWTXBS = *Blanks                                        232543
     C                             Or EWWTAC = *Blanks                                        232543
     C                   EVAL      Idx = Idx + 1                                              232543
     C                   EVAL      FldNamXAr(Idx) = 'DDETXS'                                  232543
     C                   IF        CER069 = 'Y'                                               CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR5451'                                  CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      MsgIDXAr(Idx) = 'USR4802'                                  232543
     C                   ENDIF                                                                CER069
     C                   EVAL      OKETXS = 'N'                                               232543
     C                   GOTO      EMAIN                                                      232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   ENDIF                                                                232543
                                                                                              232543
      ** Return to calling program
 
     C                   EVAL      OKETXS = 'Y'
     C                   EVAL      NTETXS = DDETXS
 
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
 
     C     *Entry        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    RetCodeIn
                                                                                              232543
      ** Mode of Operation                                                                    232543
     C                   PARM                    PModeOfOp                                    232543
 
      ** New Detail in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Output Parameters
      ** =================
 
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
(c) Finastra International Limited 2004
