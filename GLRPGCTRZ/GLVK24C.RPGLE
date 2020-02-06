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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 02Jun09               *
      *                 BUG22828           Date 17Feb09               *
      *                 BUG22198           Date 15Jan09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** Return Code
     D PRtcd           S              7A
 
     D POptn           S              7A
 
     D PCusn           S              6A
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
      *
     C**********         IF        DDK24C = 'N' and E5S24C = 'Y'                            BUG24157
     C                   IF        DD24C = 'N' and E5S24C = 'Y'                             BUG24157
     C**********         EVAL      DDK24COK = 'N'                                           BUG24157
     C                   EVAL      DD24COK = 'N'                                            BUG24157
     C                   ADD       1             WIdx
     C**********         EVAL      WFldNamXAr(WIdx) = 'DDK24C'                              BUG24157
     C                   EVAL      WFldNamXAr(WIdx) = 'DD24C'                               BUG24157
     C                   EVAL      WMsgIDXAr(WIdx) = 'USR8087'
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
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2008
