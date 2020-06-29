     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Diary Events Call Amount')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDCAMT - Validate Diary Events Call Amount                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. DUG502             Date 05Dec17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *           Add hooks DUG502_149->_154.                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRCalAmt - Validate call amount                              *
      *  SRZAlign - Validate decimal places                           *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Diary Events - Details
     FSEDEV     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IF)
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
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary Events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
     D                                     PREFIX(OV)
      *
      ** SE Diary Events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** SE Diary Events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D/COPY WNCPYSRC,DUG502_154                                                               DUG502
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work variables
     D WAmount         S             15P 0
     D WSDTA           S             15P 0
     D WTotAm          S             15P 0
     D WOSDPP          S             15P 0
      *
      ** Parameters for ZALIGN
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
     C                   EVAL      IDx = 0
     C                   EVAL      WAmount = 0
     C                   EVAL      WSDTA = 0
      *
     C                   EXSR      SRCalAmt
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKCAMT = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   Z-ADD     WAmount       S2SDPP
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalAmt - Validate call amount                              *
      *                                                               *
      *****************************************************************
     C     SRCalAmt      BEGSR
      *
      ** If entry is a share.  Call amount is mandatory.
      *
     C                   IF        DDCAMT = *BLANKS
     C                   EVAL      OKCAMT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= 'DDCAMT'
     C                   EVAL      MsgIdXAr(IDx) = 'SEA0358'
     C                   GOTO      ESRCalAmt
     C                   ENDIF
      *
      ** Use number of decimal places from nominal currency.
      *
     C                   MOVE      D1NMCY        PCyCd
     C                   EXSR      SRAOCurr
     C/COPY WNCPYSRC,DUG502_150                                                               DUG502
     C     15            SUB       A6NBDP        ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C/COPY WNCPYSRC,DUG502_151                                                               DUG502
      *
      ** Check for valid number.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCAMT        ZFIELD
     C                   EXSR      SRZAlign
 
     C                   IF        ZALIGNok <> 'Y'
     C                   EVAL      OKCAMT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= 'DDCAMT'
     C                   EVAL      MsgIdXAr(IDx) = 'SEA0359'
     C                   GOTO      ESRCalAmt
     C                   ENDIF
     C/COPY WNCPYSRC,DUG502_152                                                               DUG502
 
     C                   MOVE      ZFIELD        WAmount
     C/COPY WNCPYSRC,DUG502_153                                                               DUG502
      *
      ** If action is amend, get the original call amount.
      *
     C                   IF        DDACTN = 'A'
     C                   Z-ADD     OVSDPP        WOSDPP
     C                   ENDIF
      *
      ** Fetch total paid for this security.
      *
     C     DDSDSN        SETGT     SEDEV
     C                   READP     SEDEV                                  01
 
     C                   DOW       EndOfFile = False
      *
      ** Check record is not a cancelled record.
      *
     C                   IF        IFRECI <> 'C'
      *
      ** Check same Security
     C                   IF        DDSDSN = IFSDSN
      *
      ** Check same Event type
     C                   IF        IFSDET = 'PP'
     C                   Z-ADD     IFSDTA        WSDTA
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if security are not the same.
     C                   ELSE
     C                   EVAL      EndOfFile = True
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   READP     SEDEV                                  01
 
     C                   ENDDO
      *
      ** If no event was read used the "Current partly paid price"
      ** from PF/SECTYD.
      *
     C                   IF        EndOfFile = True
     C                   Z-ADD     D1CPDP        WSDTA
     C                   ENDIF
 
     C                   EVAL      WTotAm = WAmount + WSDTA
      *
      ** If amendment, subtract the original amount that was entered.
      *
     C                   IF        DDACTN = 'A'
     C     WTotAm        SUB       WOSDPP        WTotAm
     C                   ENDIF
      *
      ** If total amount is more than the fully paid price for the
      ** Security.  Send an error.
      *
     C                   IF        WTotAm > D1SFPP
     C                   EVAL      OKCAMT = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= 'DDCAMT'
     C                   EVAL      MsgIdXAr(IDx) = 'SEA0360'
     C                   ENDIF
 
     C     ESRCalAmt     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate decimal places                           *
      *                                                               *
      *****************************************************************
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
     C     SRAOCurr      BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCyCd
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKey = PCyCd
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
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
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
     C/COPY WNCPYSRC,DUG502_149                                                               DUG502
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
