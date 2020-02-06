     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate industry code')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSINDCD - Validate Industry Code                           *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      *                 183604             Date 16Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  183604 - Industry Code and Market Center must be mandatory   *
      *           when new PB Module is switched ON. Rating Code      *
      *           must be validated against new table PBRATIPD when   *
      *           new PB Module is switched ON.                       *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Externally described DS for industry code
     D SDINDS        E DS                  EXTNAME(SDINDSPD)
      *
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     D PMode           S              6A
      *
     D PReDsp          S              1A
      *
      ** Work parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKyst           S              7A
     D PKeyI           S              3A
     D BGN4ST          S              1A                                        183604
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
      *
      ** Validate industry code.
      *
     C                   EXSR      SRValIndC
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid dile fields.
      *
     C                   IF        OKSIDY = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKSIDY <> 'N'
 
     C                   IF        DDSIDY <> *BLANKS
     C**********         MOVEL     DDSIDY        S1SIDY                                       CER020
     C                   MOVEL     DDSIDY        S1LOIC                                       CER020
     C                   ELSE
     C**********         Z-ADD     *ZEROS        S1SIDY                                       CER020
     C                   MOVE      *BLANKS       S1LOIC                                       CER020
 
     C                   IF        DDISSR <> *BLANKS AND OKISSR = 'Y'
     C                   MOVE      *BLANKS       PCust
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDISSR        PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtCd = *BLANKS
     C**********         MOVEL     BBLICD        S1SIDY                                       CER020
     C                   MOVEL     BBLICD        S1LOIC                                       CER020
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALINDC - Validation for Industry Code                     *
      *                                                               *
      *****************************************************************
     C     SRValIndC     BEGSR
 
     C                   IF        DDSIDY <> *BLANKS
     C                             OR        DDSIDY =  *BLANKS                  183604
     C                             AND       BGN4ST =  'Y'                      183604
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C     '?'           SCAN      DDSIDY                                 01
 
     C                   IF        *IN01 = *ON
 
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKSIDY
     C                   ADD       1             IDx
     C                   MOVEL     'DDSIDY'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0245'     MsgIdXAr(IDx)
     C**********         MOVEL     DDSIDY        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSIDY))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDSIDY)                   MD000091
     C                   GOTO      ESRValIndC
     C                   ENDIF
 
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
 
     C                   CALL      'AOINDSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDSIDY        PKeyI
     C     SDINDS        PARM      SDINDS        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
 
     C                   IF        PRtcd = '*NOSEL '
     C                   EVAL      DDSIDY = *BLANKS
     C                   ELSE
     C                   ADD       1             Idx
     C                   MOVE      'N'           OKSIDY
     C                   MOVEL     'DDSIDY'      FldNamXAr(Idx)
     C                   IF        DDSIDY <> *BLANKS                            183604
     C                   MOVEL     'SEA0112'     MsgIdXAr(Idx)
     C                   ELSE                                                   183604
     C                   MOVEL     'SEA0443'     MsgIdXAr(IDx)                  183604
     C                   ENDIF                                                  183604
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      DDSIDY = AOLICD
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESRValIndC    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *                                                                        183604
      ** SDMMOD - Private banking                                              183604
     C                   PARM                    BGN4ST                        183604
      *
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
