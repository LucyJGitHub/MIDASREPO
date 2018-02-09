     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF validate broker')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVBROKER - Validate broker                                  *
      *                                                               *
      *  Function:  This module checks that the broker field on an    *
      *             FF trade contains a valid broker entry, and       *
      *             switches on the broker settlement instructions    *
      *             if required.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDFOCS        E DS                  EXTNAME(SDFOCSPD)
      ** Midas Futures and Options Clients File Data Structure
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Midas Customer file Data Structure
 
     D @DSFDY        E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D*@DSSDY***     E DS                  EXTNAME(DSSDY)                                     CFF007
     D @DSLDY        E DS                  EXTNAME(DSLDY)                                     CFF007
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Broker screen field
     D SBOCO           S             10A
 
      ** Default broker field
     D*DBRK*****       S              6S 0                                                    CSD027
     D DBRK            S              6A                                                      CSD027
 
      ** Market instrument OK flag.
     D OKMKTI          S              1A
 
      ** Numeric version of broker to return to caller
     D*BrokerNum       S              6S 0                                                    CSD027
     D BrokerNum       S              6A                                                      CSD027
 
      ** PB customer indicator                                                                CFF007
     D PPBBFLG         S              1A                                                      CFF007
                                                                                              CFF007
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      * If broker is not defined, it is an error if it can't be defaulted
 
     C     SBOCO         IFEQ      *BLANKS
 
      **   Use Default Broker from the Instrument
      **   ( only if the instrument is valid, and a default exists)
 
     C     OKMKTI        IFEQ      'Y'
     C*****DBRK*         ANDNE     0                                                          CSD027
     C     DBRK          ANDNE     *BLANKS                                                    CSD027
 
     C                   MOVEL     DBRK          SBOCO
                                                                                              CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*KEY   '     @OPTN                                        CFF007
     C                   PARM      SBOCO         @KEY1                                        CFF007
     C                   PARM                    @KYST                                        CFF007
     C     SDCUST        PARM      SDCUST        @DSLDY                                       CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVEL     BBPRBA        PPBBFLG                                      CFF007
     C                   ENDIF                                                                CFF007
 
     C                   ELSE
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBOCO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0365'
 
     C                   ENDIF
     C                   ENDIF
      **                 (End of "If broker blank")
 
      * If broker is defined, validate it
 
     C     SBOCO         IFNE      *BLANKS
 
      * Ensure that the AO return code is blank to prevent problems
      * on subsequent calls
     C                   CLEAR                   @RTCD
 
      * First verify customer number on customer master file
      * ...but don't call AOCUSTR0 if '?' entered , because it's not much
      * use.
     C     '?'           SCAN      SBOCO         FOUND             3 0
     C     FOUND         IFEQ      *ZERO
 
     C**********         CALLB     'AOCUSTR0'                                                 CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SBOCO         @KEY1            10
     C                   PARM                    @KYST             7
     C*****SDCUST        PARM      SDCUST        @DSSDY                                       CFF007
     C     SDCUST        PARM      SDCUST        @DSLDY                                       CFF007
 
     C                   ENDIF
 
      * If found on master, check whether an F&O client and
      * whether a broker (done later)
     C     @RTCD         IFEQ      *BLANKS
 
      * If question mark was entered, pass that into AOFOCSR0; otherwise
      * pass in the customer number (SBOCO may contain a shortname).
     C                   IF        Found = 0
     C                   EVAL      @CUST = BBCUST
     C                   ELSE
     C                   EVAL      @CUST = '?'
     C                   ENDIF
 
     C                   CALLB     'AOFOCSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    @CUST             6
     C     SDFOCS        PARM      SDFOCS        @DSFDY
 
      ** Set up SBOCO for display; do this as long as broker valid
 
     C                   IF        @RTCD = '      '
     C                   MOVEL     *BLANKS       SBOCO
     C                   MOVEL     BHCUST        SBOCO
     C                   MOVEL     BBPRBA        PPBBFLG                                      CFF007
     C                   ENDIF
     C
     C                   ENDIF
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         IFEQ      '*NOSEL'
 
      ** No broker selected
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBOCO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0366'
 
     C                   ELSE
 
      ** Entry does not exist on file
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBOCO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0363'
 
     C                   ENDIF
 
     C                   ELSE
      **   - must be a Broker
     C     BHBKIN        IFNE      'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SBOCO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0364'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If broker not blank")
      *                                                                                       CSD025
     C     ErrorFound    IFNE      'Y'                                                        CSD025
     C     BBDEAC        ANDEQ     'Y'                                                        CSD025
     C     DDACTN        ANDEQ     'I'                                                        CSD025
     C     CSD025        ANDEQ     'Y'                                                        CSD025
     C                   EVAL      ErrorFound = 'Y'                                           CSD025
     C                   EVAL      XIdx = XIdx + 1                                            CSD025
     C                   EVAL      FldNamXArr(XIdx) = 'SBOCO'                                 CSD025
     C                   EVAL      MsgIDXArr(XIdx) = 'ABM0027'                                CSD025
     C**********         EVAL      MsgDtaXArr(XIdx) = BBCUST                         CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXArr(XIdx) = LenStr +%TRIM(BBCUST)                 MD000091
      *                                                                                       CSD025
     C                   ENDIF                                                                CSD025
 
      ** Set up the numeric value of broker code to return
     C                   IF        ErrorFound = 'N'
     C                   MOVEL     SBOCO         BrokerNum
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Numeric version of broker code (6,0S)
     C                   Parm                    BrokerNum
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBBFLG                                      CFF007
 
      ** Parameters received from caller
      ** -------------------------------
      ** Broker I.D. (10A, from transaction)
     C                   PARM                    SBOCO
      ** Market Instrument OK flag (1A, from module FFVMKTINS)
     C                   PARM                    OKMKTI
      ** Default Broker I.D. (6S0, from module FFVMKTINS)
     C                   PARM                    DBRK
      ** Action code (1A)                                                                     CSD025
     C                   PARM                    DDACTN            1                          CSD025
      *                                                                                       CSD025
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd             7                          CSD025
     C                   PARM      '*VERIFY'     POptn             7                          CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        @DSFDY                                       CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
