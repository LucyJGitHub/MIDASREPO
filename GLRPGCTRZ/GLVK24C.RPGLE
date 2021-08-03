     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Subject to KWG §24c reporting')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVK24C - Midas GL Validate Subject to KWG §24c reporting    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD050685           Date 12Nov19               *
      *  Prev Amend No. CER075             Date 14Sep17               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 02Jun09               *
      *                 BUG22828           Date 17Feb09               *
      *                 BUG22198           Date 15Jan09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050685 - Live KWG24c defaulting flag "NO"                  *
      *  CER075 - KWG 24c Reporting Branch Enhancement                *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y                            *
      *  BUG22828 - Provide different error for missing ACUS          *
      *  BUG22198 - Remove DBError Processing for AOACUSR0            *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      **--------------------------------------------------------------------------------------------
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNamXAr      S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Customer Details by Country of Tax
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Second DS for access programs, LONG DATA STRUCTURE
     D DSLDY         E DS                  EXTNAME(DSLDY)
                                                                                              CER075
      ** External data structures for Location Details                                        CER075
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  CER075
                                                                                              CER075
      ** External DS for SAR Details                                                          CER075
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER075
                                                                                              CER075
      ** External data structures for Branch Details                                          CER075
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CER075
                                                                                              CER075
      ** First DS for access programs, SHORT DATA STRUCTURE                                   CER075
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER075
                                                                                              CER075
      ** Dummy Data Structure                                                                 CER075
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER075
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0

      ** KWG §24c reporting field
     D***DDK24C          S              1A                                                  BUG24157
     D DD24C           S              1A                                                    BUG24157

      ** Customer Number
     D DDCUSN          S              6A

      ** KWG §24c reporting Y/N - Ok Flag
     D***DDK24COK        S              1A                                                  BUG24157
     D DD24COK         S              1A                                                    BUG24157
                                                                                              CER075
      ** Branch                                                                               CER075
     D DDBRCA          S              3A                                                      CER075
 
      ** Return Code
     D PRtcd           S              7A

     D POptn           S              7A

     D PCusn           S              6A
                                                                                              CER075
      ** CER075 System Value - KWGCountryCode                                                 CER075
     D PSYSVL          C                   CONST('KWGCountryCode')                            CER075
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
      *
      ** Initialization
      *
     C                   MOVEL     *BLANKS       RetCodeIn
     C                   MOVEL     *BLANKS       FldNamXAr
     C                   MOVEL     *BLANKS       MsgIDXAr
     C                   MOVEL     *BLANKS       MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVEL     *BLANKS       WFldNamXAr
     C                   MOVEL     *BLANKS       WMsgIDXAr
     C                   MOVEL     *BLANKS       WMsgDtaXAr
     C                   Z-ADD     0             WIdx
      *
      ** Validation
      *
     C                   EXSR      SRVK24C
      *
      ** If an error was found, set the return code appropriately
      *
     C**********         IF        DDK24COK = 'N'                                           BUG24157
     C                   IF        DD24COK = 'N'                                            BUG24157
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVK24C - Validate Subject to KWG §24c reporting              *
      *****************************************************************
     C     SRVK24C       BEGSR
                                                                                              CER075
     C                   IF        CER075 = 'Y'                                               CER075
      ** Default DD24C to 'N' if branch is not located in country defined on                  CER075
      ** the system value KWGCountryCode and DD24C is blank                                   CER075
     C                   IF        KWGCtryCode <> DVCNCD                                      CER075
     C                             AND DD24C = *BLANKS                                        CER075
     C                   EVAL      DD24C = 'N'                                                CER075
     C                   GOTO      EndK24C                                                    CER075
      *                                                                                       CER075
      ** Throw error if DD24C is 'Y' and branch is not located in country                     CER075
      ** defined on the system value KWGCountryCode                                           CER075
     C                   ELSEIF    KWGCtryCode <> DVCNCD                                      CER075
     C                             AND DD24C = 'Y'                                            CER075
     C                   EVAL      DD24COK = 'N'                                              CER075
     C                   ADD       1             Idx                                          CER075
     C                   MOVEL     'DD24C     '  FldNamXAr(Idx)                               CER075
     C                   MOVEL     'USR8034'     MsgIDXAr(Idx)                                CER075
     C                   GOTO      EndK24C                                                    CER075
     C                   ENDIF                                                                CER075
      *                                                                                       CER075
     C                   ENDIF                                                                CER075
      *
      ** Default to N if KWG §24c reporting is blanks
      *
      ** Set defaulting to CUAP KWG if field is set to blanks                               BUG24157
     C**********         IF        DDK24C = *BLANKS                                         BUG24157
     C**********         EVAL      DDK24C = 'N'                                             BUG24157
     C**********         ENDIF                                                              BUG24157
      *
      ** Field must be Y/N
      *
     C                   IF        DD24C <> *BLANKS                                        BUG24157
     C**********         IF        DDK24C <> 'Y' and DDK24C <> 'N'                         BUG24157
     C                   IF        DD24C <> 'Y' and DD24C <> 'N'                           BUG24157
     C**********         EVAL      DDK24COK = 'N'                                          BUG24157
     C                   EVAL      DD24COK = 'N'                                           BUG24157
     C                   ADD       1             Idx
     C**********         MOVEL     'DDK24C'      FldNamXAr(Idx)                            BUG24157
     C                   MOVEL     'DD24C     '  FldNamXAr(Idx)                            BUG24157
     C                   MOVEL     'USR3973'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                              BUG24157
      *
      ** Check if Customer is Subject to @24c
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDCUSN        PCusn
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtcd <> *BLANKS
     C*********          EVAL      DBFILE = 'SDACUSPD'                                      BUG22198
     C*********          EVAL      DBKEY = 'DDCUSN'                                         BUG22198
     C*********          EVAL      DBASE = 1                                                BUG22198
     C*********          EXSR      *PSSR                                                    BUG22198
     C                   ADD       1             Idx                                        BUG22198
     C                   MOVEL     'DDCUSN'      FldNamXAr(Idx)                             BUG22198
     C**********         MOVEL     'USR8088'     MsgIDXAr(Idx)                     BUG22198 BUG22828
     C                   MOVEL     'USR8009'     MsgIDXAr(Idx)                              BUG22828
     C                   GOTO      EndK24C                                                  BUG22198
     C                   ENDIF
      *                                                                                     BUG24157
      ** Set DD24C = E5S24C if DD24C is blanks                                              BUG24157
      *                                                                                     BUG24157
     C                   IF        DD24C = *blanks                                          BUG24157
     C                   EVAL      DD24C = E5S24C                                           BUG24157
     C                   ENDIF                                                              BUG24157
      *
      ** Field must be N if customer is not Subject to @24c
      *
     C**********         IF        DDK24C = 'Y' and E5S24C <> 'Y'                           BUG24157
     C                   IF        DD24C = 'Y' and E5S24C <> 'Y'                            BUG24157
     C**********         EVAL      DDK24COK = 'N'                                           BUG24157
     C                   EVAL      DD24COK = 'N'                                            BUG24157
     C                   ADD       1             Idx
     C**********         MOVEL     'DDK24C'      FldNamXAr(Idx)                             BUG24157
     C                   MOVEL     'DD24C     '  FldNamXAr(Idx)                             BUG24157
     C                   MOVEL     'USR8088'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send a warning MSG if Customer is Subject to @24c and Account is not Subject to @24c
      ** and CER075 is OFF                                                                    CER075
      *
     C**********         IF        DDK24C = 'N' and E5S24C = 'Y'                            BUG24157
     C                   IF        DD24C = 'N' and E5S24C = 'Y'                             BUG24157
      *                                                                                       CER075
     C                   IF        CER075 = 'N'                                               CER075
     C**********         EVAL      DDK24COK = 'N'                                           BUG24157
     C                   EVAL      DD24COK = 'N'                                            BUG24157
     C                   ADD       1             WIdx
     C**********         EVAL      WFldNamXAr(WIdx) = 'DDK24C'                              BUG24157
     C                   EVAL      WFldNamXAr(WIdx) = 'DD24C'                               BUG24157
     C                   EVAL      WMsgIDXAr(WIdx) = 'USR8087'
      *                                                                                       CER075
      ** Default to Y if branch is located in country defined on the system value             CER075
      ** KWGCountryCode and CER075 is ON                                                      CER075
      *                                                                                       CER075
     C                   ELSEIF    CER075 = 'Y' and KWGCtryCode = DVCNCD                      CER075
     C                   IF        DD24C = *Blanks                                          MD050685
     C                   EVAL      DD24C = 'Y'                                                CER075
     C                   ENDIF                                                              MD050685
     C                   ENDIF                                                                CER075
     C                   ENDIF
      *
     C**********         ENDSR                                                              BUG22198
     C     EndK24C       ENDSR                                                              BUG22198
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    RetCodeIn
      ** KWG §24c reporting field
     C**********         PARM                    DDK24C                                     BUG24157
     C                   PARM                    DD24C                                      BUG24157
      ** Customer Number
     C                   PARM                    DDCUSN
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
      ** KWG §24c reporting Y/N - Ok Flag
     C**********         PARM                    DDK24COK                                   BUG24157
     C                   PARM                    DD24COK                                    BUG24157
      ** Branch                                                                               CER075
     C                   PARM                    DDBRCA                                       CER075
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS
 
      *                                                                                       CER075
      ** Check if CER075 feature is on.                                                       CER075
      *                                                                                       CER075
     C                   CALL      'AOSARDR0'                                                 CER075
     C                   PARM      *BLANKS       PRTCD             7                          CER075
     C                   PARM      '*VERIFY'     POPTN             7                          CER075
     C                   PARM      'CER075'      PSARD             6                          CER075
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER075
      *                                                                                       CER075
      ** Check for Database error                                                             CER075
      *                                                                                       CER075
     C     PRTCD         IFNE      *BLANKS                                                    CER075
     C     PRTCD         ANDNE     '*NRF   '                                                  CER075
     C     *LOCK         IN        LDA                                                        CER075
     C                   EVAL      DBKEY = 'CER075'                                           CER075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER075
     C                   EVAL      DBASE = 2                                                  CER075
     C                   OUT       LDA                                                        CER075
     C                   EXSR      *PSSR                                                      CER075
     C                   END                                                                  CER075
      *                                                                                       CER075
     C     PRTCD         IFEQ      *BLANKS                                                    CER075
     C                   MOVE      'Y'           CER075            1                          CER075
     C                   ELSE                                                                 CER075
     C                   MOVE      'N'           CER075                                       CER075
     C                   ENDIF                                                                CER075
      *                                                                                       CER075
     C     CER075        IFEQ      'Y'                                                        CER075
      *                                                                                       CER075
      ** Retrieve KWGCountryCode's current setting                                            CER075
      *                                                                                       CER075
     C                   CALL      'AOSVALR0'                                                 CER075
     C                   PARM      *BLANKS       @RTCDE            7                          CER075
     C                   PARM      PSYSVL        P@OP01           20                          CER075
     C                   PARM      *BLANKS       P@VL01          200                          CER075
     C                   PARM      *BLANKS       P@OP02           20                          CER075
     C                   PARM      *BLANKS       P@VL02          200                          CER075
     C                   PARM      *BLANKS       P@OP03           20                          CER075
     C                   PARM      *BLANKS       P@VL03          200                          CER075
     C                   PARM      *BLANKS       P@OP04           20                          CER075
     C                   PARM      *BLANKS       P@VL04          200                          CER075
     C                   PARM      *BLANKS       P@OP05           20                          CER075
     C                   PARM      *BLANKS       P@VL05          200                          CER075
     C                   PARM      *BLANKS       P@OP06           20                          CER075
     C                   PARM      *BLANKS       P@VL06          200                          CER075
     C                   PARM      *BLANKS       P@OP07           20                          CER075
     C                   PARM      *BLANKS       P@VL07          200                          CER075
     C                   PARM      *BLANKS       P@OP08           20                          CER075
     C                   PARM      *BLANKS       P@VL08          200                          CER075
     C                   PARM      *BLANKS       P@OP09           20                          CER075
     C                   PARM      *BLANKS       P@VL09          200                          CER075
     C                   PARM      *BLANKS       P@OP10           20                          CER075
     C                   PARM      *BLANKS       P@VL10          200                          CER075
                                                                                              CER075
      ** Handle Database Error                                                                CER075
                                                                                              CER075
     C                   IF        @RTCDE <> *BLANKS                                          CER075
     C     *LOCK         IN        LDA                                                        CER075
     C                   EVAL      DBASE = 3                                                  CER075
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CER075
     C                   EVAL      DBKEY = P@OP01                                             CER075
     C                   OUT       LDA                                                        CER075
     C                   EXSR      *PSSR                                                      CER075
     C                   ELSE                                                                 CER075
     C                   MOVEL     P@VL01        KWGCtryCode       2                          CER075
     C                   ENDIF                                                                CER075
      *                                                                                       CER075
      ** Retrieve country code                                                                CER075
      *                                                                                       CER075
     C                   CALL      'AOBRCHR1'                                                 CER075
     C                   PARM      *BLANKS       PRtcd                                        CER075
     C                   PARM      '*KEY   '     POptn                                        CER075
     C                   PARM                    DDBRCA                                       CER075
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CER075
                                                                                              CER075
      ** Handle Database Error                                                                CER075
     C                   IF        PRtcd <> *BLANKS                                           CER075
     C     *LOCK         IN        LDA                                                        CER075
     C                   EVAL      DBASE = 4                                                  CER075
     C                   EVAL      DBFILE = 'SDBRCHPD'                                        CER075
     C                   EVAL      DBKEY = DDBRCA                                             CER075
     C                   EVAL      DBPGM = 'GLVK24C'                                          CER075
     C                   OUT       LDA                                                        CER075
     C                   EXSR      *PSSR                                                      CER075
     C                   ENDIF                                                                CER075
      *                                                                                       CER075
     C                   CALL      'AOLOCNR0'                                                 CER075
     C                   PARM      *BLANKS       PRtcd                                        CER075
     C                   PARM      '*KEY   '     POptn                                        CER075
     C                   PARM                    A8LCCD                                       CER075
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        CER075
                                                                                              CER075
      ** Handle Database Error                                                                CER075
     C                   IF        PRtcd <> *BLANKS                                           CER075
     C     *LOCK         IN        LDA                                                        CER075
     C                   EVAL      DBASE = 5                                                  CER075
     C                   EVAL      DBFILE = 'SDLOCNPD'                                        CER075
     C                   EVAL      DBKEY = A8LCCD                                             CER075
     C                   EVAL      DBPGM = 'GLVK24C'                                          CER075
     C                   OUT       LDA                                                        CER075
     C                   EXSR      *PSSR                                                      CER075
     C                   ENDIF                                                                CER075
      *                                                                                       CER075
     C                   ENDIF                                                                CER075
                                                                                              CER075
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2008
