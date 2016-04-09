     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Settlement Value Settled')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTSVALS - Validate Trade Settlement Value Settled Amount   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAP182   *CREATE   Date 03Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrValSetAmnt - Validate Value Settled Amount                 *
      *  SrAOCurr     - Check currency details                        *
      *  SrAOStrd     - Access Securities Trading Details             *
      *  SrZconv      - Convert an amount from one currency to another*
      *  *PSSR        - Error processing                              *
      *  *INZSR       - Initialise                                    *
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
      ** SE Trade Settlement Details for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      ** Error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities Trading Details
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIdx            S              3P 0
      *
      ** Work parameters
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
      *
      ** Parameters for AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCyCd           S              3A
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise work variables.
     C                   Eval      IDx = 0
      *
     C                   Exsr      SrAOBank
      *
     C                   Exsr      SrValSetAmnt
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   If        OKVALS = 'N'
     C                   Eval      RetCodeIn = 'ERROR'
     C                   Else
     C                   Z-Add     VSAmtSCcy     VTSSVLS
     C                   EndIf
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValSetAmnt - Validate Value Settled Amount                 *
      *                                                               *
      *****************************************************************
 
     C     SrValSetAmnt  BEGSR
      *
      ** Reset all working fields
     C                   Z-Add     *Zeros        VSAmtSCcy        15 0
     C                   Z-Add     *Zeros        TotSetPost       15 0
     C                   Z-Add     *Zeros        WK15N            15 0
     C                   Z-Add     *Zeros        DUNDER           15 0
     C                   Z-Add     *Zeros        DOVER            15 0
     C                   Z-Add     *Zeros        ZADIG
     C                   Z-Add     *Zeros        ZADEC
     C                   Eval      ZFIELD = *Blanks
      *
     C                   If        DDVALS <> *Blanks
      *
      ** Check valid amount in settlement currency
     C                   Eval      ZFIELD = DDVALS
      *
      ** Fetch base currency decimal places for ZCONV
     C                   Eval      PCyCd = BJCYCD
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPI
      *
      ** Fetch settlement currency decimal places
     C                   Eval      PCyCd = SETC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZADEC
     C     15            Sub       A6NBDP        ZADIG
     C                   CALLB     'ZALIGN'
     C                   Parm      *BLANK        ZALIGNok
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZALIGNok = 'N'
     C                   Move      'N'           OKVALS
     C                   Add       1             IDx
     C                   MoveL     'DDVALS'      FldNamXAr(IDx)
     C                   MoveL     'USR2046'     MsgIdXAr(IDx)
     C                   Else
      *
      ** Value Settled Amount in Settlement currency
     C                   Move      ZFIELD        VSAmtSCcy
      *
      ** If full settlement, check value does not exceed discrepancy
      *  limits
     C                   If        DDFSET = 'Y'
      *
      ** Access Securities Trading Details file to get the discrepancy limit
     C                   Exsr      SrAOStrd
     C                   Z-Add     BVSDUN        ZAMTCI
      *
      ** Convert discrepancy under value to settlement currency
     C                   Z-Add     A6SPRT        ZEXCH
     C                   If        A6MDIN = 'M'
     C                   Eval      ZMD = 'D'
     C                   Else
     C                   Eval      ZMD = 'M'
     C                   EndIf
      *
     C                   Eval      ZCCYI = BJCYCD
     C                   Z-Add     A6NBDP        ZCDPO
     C                   Eval      ZCCYO = SETC
     C                   Exsr      SrZconv
     C                   Move      ZAMTCO        DUNDER
      *
      ** Convert discrepancy over
     C                   Z-Add     BVSDOV        ZAMTCI                                        S0111
     C                   Exsr      SrZconv
     C                   Move      ZAMTCO        DOVER
      *
      ** Fetch working amount
     C     TOSV          SUB       VSAmtSCcy     WK15N
      *
      ** Check against discrepancy amounts  - UNDER
     C     WK15N         Ifgt      DUNDER
     C                   Move      'N'           OKVALS
     C                   Add       1             IDx
     C                   MoveL     'DDVALS'      FldNamXAr(IDx)
     C                   MoveL     'USR2047'     MsgIdXAr(IDx)
     C                   Else
      *
     C     VSAmtSCcy     SUB       TOSV          WK15N
      *
      ** Check against discrepancy amounts  - OVER
     C     WK15N         Ifgt      DOVER
     C                   Move      'N'           OKVALS
     C                   Add       1             IDx
     C                   MoveL     'DDVALS'      FldNamXAr(IDx)
     C                   MoveL     'USR2047'     MsgIdXAr(IDx)
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** If Reversal, must be equal to sum of value settled.
     C                   If        DDREVE = 'Y'
     C     TVSN          Add       TVSP          TotSetPost
     C     VSAmtSCcy     Ifgt      TotSetPost
     C                   Move      'N'           OKVALS
     C                   Add       1             IDx
     C                   MoveL     'DDVALS'      FldNamXAr(IDx)
     C                   MoveL     'USR2048'     MsgIdXAr(IDx)
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
     C                   EndIf
      *
      ** Nominal settled and Value settled cannot both be blank
     C                   If        DDNOMS = *Blanks And
     C                             DDVALS = *Blanks
     C                   Move      'N'           OKNOMS
     C                   Move      'N'           OKVALS
     C                   Add       1             IDx
     C                   MoveL     'DDVALS'      FldNamXAr(IDx)
     C                   MoveL     'USR2049'     MsgIdXAr(IDx)
     C                   EndIf
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCyCd
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = PCyCd
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Z-Add     1             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOStrd - Access Securities Trading Details                 *
      *                                                               *
      *****************************************************************
     C     SrAOStrd      BEGSR
 
     C                   CallB     'AOSTRDR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*FIRST  '    POptn
     C     SDSTRD        Parm      SDSTRD        DSSDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile = 'SDSTRDPD'
     C                   Z-Add     2             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOBank -  Access bank details.                             *
      *                                                               *
      *****************************************************************
     C     SrAOBank      BEGSR
 
     C                   CallB     'AOBANKR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*FIRST  '    POptn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Z-Add     3             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZconv - Convert an amount from one currency to another     *
      *                                                               *
      *****************************************************************
     C     SrZconv       Begsr
 
     C                   CallB     'ZCONV'
     C                   Parm                    ZAMTCI           15 0
     C                   Parm                    ZEXCH            13 8
     C                   Parm                    ZMD               1
     C                   Parm                    ZCCYI             3
     C                   Parm                    ZCCYO             3
     C                   Parm                    ZCDPI             1 0
     C                   Parm                    ZCDPO             1 0
     C                   Parm                    ZAMTCO           15 0
      *
     C                   Endsr
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
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
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
(c) Misys International Banking Systems Ltd. 2003
