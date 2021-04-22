     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Sec Diary Events conv file to screen fmt')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDECVT - Security Diary Events convert file to screen     *
      *              format                                           *
      *                                                               *
      *  Function: This module will convert the fields of a Security  *
      *            Diary Events from their format as on file to a     *
      *            screen format.                                     *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDECTL                                      *
      *                SESEDERPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 237063             Date 20Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
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
      *  SRConvFlds - Subroutine to convert file fields to screen     *
      *               format.                                         *
      *  SRInit - Subroutine to initialise fields                     *
      *  SRAOCurr - Check currency details                            *
      *  SRFmtDat - Format Midas Date to DDMMYY (OR MMDDYY)           *
      *  SRFmtAmt - Format amount for screen output                   *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** SE Diary events screen details retrieved from file
      ** - screen format
     D CrDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
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
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work variables
     D WCPRI           S              7A
      *
      ** Work parameters
     D RMFL            S              1A
     D PACTN           S              1A
     D PPROT           S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A                                                      CAS006
     D CSE065          S              1A                                                      CSE065
      *
      ** Parameters for ZDATE2
     D PDateIn         S              5P 0
     D BJDFIN          S              1A
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameters for ZEDIT
     D ZField          S             16A
     D ZADec           S              1P 0
      *
      ** Parameters for AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCyCd           S              3A
                                                                                              CSE065
      ** Parameters for ZA0140M                                                               CSE065
     D P@RTN           S              1A                                                      CSE065
     D P@DAYN          S              5P 0                                                    CSE065
     D P@DATE          S              6P 0                                                    CSE065
     D P@DATA          S              7A                                                      CSE065
     D P@DAT8          S              8P 0                                                    CSE065
     D P@DAT8F         S              8P 0                                                    CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
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
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Convert fields
      *
     C                   EXSR      SRConvFlds
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvFlds - Subroutine to convert file fields to screen     *
      *               format.                                         *
      *                                                               *
      *****************************************************************
     C     SRConvFlds    BEGSR
      *
      ** Move key file fields to key screen fields.
      *
     C                   EVAL      DDACTN = PACTN
     C                   EVAL      DDSDSN = SDSN
     C                   EVAL      DDSDET = SDET
 
     C                   IF        SDED <> *ZEROS
     C                   IF        SDED = 99999
     C                   EVAL      DDSDED = *ALL'9'
     C                   ELSE
     C                   Z-ADD     SDED          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      DDSDED
     C                   ENDIF
     C                   ENDIF
      *
      ** Dividends declared.
      *
     C                   IF        DDSDET = 'DV'
      *
      ** Amount per unit.
     C                   IF        SDVA <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDVA          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDSDDV
     C                   ENDIF
      *
      ** Payment date.
     C                   IF        SDPD <> *ZEROS
     C                   Z-ADD     SDPD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      DDSDPD
     C                   ENDIF
      *
      ** Dividend ex. date.
     C                   IF        SDXD <> *ZEROS AND S01510 = 'Y'
     C                   Z-ADD     SDXD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      DDSDXD
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR1 = SDNV
      *
     C                   ENDIF
      *
      ** Partly paids.
      *
     C                   IF        DDSDET = 'PP'
      *
      ** Call amount.
     C                   IF        PPROT = '4' AND SDPP <> *ZEROS
      *
      ** Get nominal decimal places.  Format call amount.
     C                   MOVE      D1NMCY        PCyCd
     C                   EXSR      SRAOCurr
 
     C                   Z-ADD     A6NBDP        ZADec
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPP          ZField
     C                   EXSR      SRFmtAmt
 
     C                   MOVE      ZField        DDCAMT
     C                   ENDIF
      *
      ** Call percentage / Put percentage.
     C                   IF        PPROT <> '4' AND SDPC <> *ZEROS
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPC          ZField
     C                   Z-ADD     3             ZADec
     C                   EXSR      SRFmtAmt
 
     C                   IF        SDPC = 100
     C                   MOVE      ZField        WCPRI
     C                   MOVEL     WCPRI         DDCPRI
     C                   ELSE
     C                   MOVE      ZField        DDCPRI
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR1 = SDNV
 
     C                   ENDIF
      *
      ** Mortgage payments.
      *
     C                   IF        DDSDET = 'MP'
      *
      ** Current factor.
     C                   IF        SDCP <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDCP          ZField
     C                   Z-ADD     9             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDSDCP
     C                   ENDIF
      *
      ** Payment amount.
     C                   IF        SRPT <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SRPT          ZField
     C                   Z-ADD     0             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDSRPT
     C                   ENDIF
      *
      ** Payment date.
     C                   IF        SDPD <> *ZEROS
     C                   Z-ADD     SDPD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      DDSDPD
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR2 = SDNV
 
     C                   ENDIF
      *
      ** Interest rate changes.
      *
     C                   IF        DDSDET = 'IR'
      *
      ** Next coupon rate.
     C                   IF        SDNC <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDNC          ZField
     C                   Z-ADD     7             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDSDNC
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR1 = SDNV
 
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
     C                   IF        SCRS <> *ZEROS                                             CAS006
     C                   MOVE      *BLANKS       ZField                                       CAS006
     C                   MOVE      SCRS          ZField                                       CAS006
     C                   Z-ADD     7             ZADec                                        CAS006
     C                   EXSR      SRFmtAmt                                                   CAS006
     C                   MOVE      ZField        DDSCRS                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
     C                   IF        SLQP <> *ZEROS                                             CAS006
     C                   MOVE      *BLANKS       ZField                                       CAS006
     C                   MOVE      SLQP          ZField                                       CAS006
     C                   Z-ADD     7             ZADec                                        CAS006
     C                   EXSR      SRFmtAmt                                                   CAS006
     C                   MOVE      Zfield        DDSLQP                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF
      *
      ** Exchange rates.
      *
     C                   IF        DDSDET = 'XR'
 
     C                   IF        SDCE <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDCE          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDCUTR
     C                   ENDIF
 
     C                   IF        S01509 = 'N'
     C                   MOVE      SDCX          DDPAYC
     C                   ELSE
     C                   MOVE      D1VLCY        DDPAYC
     C                   ENDIF
 
     C                   MOVE      SDMD          DDSDMD
     C                   MOVE      SDNV          DDNAR3
 
     C                   ENDIF
      *
      ** Redemption calls.
      *
     C                   IF        DDSDET = 'RC'
      *
      ** Call amount.
     C                   IF        SDPP <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPP          ZField
     C                   Z-ADD     0             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDCLAT
     C                   ENDIF
      *
      ** Call percentage.
     C                   IF        SDPC <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPC          ZField
     C                   Z-ADD     3             ZADec
     C                   EXSR      SRFmtAmt
 
     C                   IF        SDPC = 100
     C                   MOVE      ZField        WCPRI
     C                   MOVEL     WCPRI         DDCPRI
     C                   ELSE
     C                   MOVE      ZField        DDCPRI
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redemption price.
     C                   IF        SDRP <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDRP          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDRAMT
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR2 = SDNV
 
     C                   IF        S01509 = 'Y'
      *
      ** Redemption currency.
     C                   IF        SDCX <> *BLANKS
     C                   MOVE      SDCX          DDRCCY
     C                   ENDIF
      *
      ** Exchange rate.
     C                   IF        SDCE <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDCE          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDXRAT
     C                   ENDIF
      *
      ** Multiply / Divide indicator.
     C                   IF        SDMD <> *BLANKS
     C                   MOVE      SDMD          DDRCMD
     C                   ENDIF
     C                   ENDIF
      *
      ** Analysis cash flow.
     C                   IF        RMFL = 'Y'
     C                   MOVE      RCIC          DDRCIC
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redemption puts.
      *
     C                   IF        DDSDET = 'RP'
      *
      ** Put amount.
     C                   IF        SDPP <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPP          ZField
     C                   Z-ADD     0             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDCLAT
     C                   ENDIF
      *
      ** Put percentage.
     C                   IF        SDPC <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPC          ZField
     C                   Z-ADD     3             ZADec
     C                   EXSR      SRFmtAmt
 
     C                   IF        SDPC = 100
     C                   MOVE      ZField        WCPRI
     C                   MOVEL     WCPRI         DDCPRI
     C                   ELSE
     C                   MOVE      ZField        DDCPRI
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redemption price.
     C                   IF        SDRP <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDRP          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDRAMT
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR2 = SDNV
 
     C                   ENDIF
      *
      ** Conversions.
      *
     C                   IF        DDSDET = 'CV'
      *
      ** Conversion security.
     C                   EVAL      DDSDCV = SDCV
      *
      ** Conversion currency.
     C                   IF        SDCX <> *BLANKS
     C                   EVAL      DDCONC = SDCX
     C                   ELSE
     C                   EVAL      DDCONC = D1NMCY
     C                   ENDIF
      *
      ** Conversion exchange rate.
     C                   IF        SDCE <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDCE          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDCONR
     C                   ENDIF
      *
      ** Conversion price.
     C                   IF        SDRP <> *ZEROS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDRP          ZField
     C                   Z-ADD     8             ZADec
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        DDCONP
     C                   ENDIF
      *
      ** Narrative.
     C                   EVAL      DDNAR3 = SDNV
 
     C                   ENDIF
      *
      ** Bonus issues, Rights issues, Capital reorganisation and
      ** Other changes.
      *
     C                   IF        DDSDET = 'BI' OR DDSDET = 'RI' OR
     C                             DDSDET = 'CR' OR DDSDET = 'OC'
     C                   EVAL      DDNAR4 = SDNV
     C                   ENDIF
                                                                                              CSE065
      ** Average Life Date                                                                    CSE065
                                                                                              CSE065
     C                   IF        CSE065 = 'Y'  AND                                          CSE065
     C                             DDSDET = 'AL'                                              CSE065
                                                                                              CSE065
     C                   EVAL      P@DAYN = SDAL                                              CSE065
                                                                                              CSE065
      ** Convert Average Life Date (day number) to MMDDYYYY or DDMMYYYY                       CSE065
                                                                                              CSE065
     C                   EXSR      SRConvSDAL                                                 CSE065
     C                   MOVE      P@DAT8F       DDSDAL                                       CSE065
                                                                                              CSE065
     C                   EVAL      DDNAR1 = SDNV                                              CSE065
     C                   ENDIF                                                                CSE065
                                                                                              237063
      ** European Taxation                                                                    237063
                                                                                              237063
     C                   IF        CGL031 = 'Y'                                               237063
     C                   EVAL      DDSETX = SETX                                              237063
     C                   ENDIF                                                                237063
 
     C                   ENDSR
      *
      *****************************************************************                       CSE065
      /EJECT                                                                                  CSE065
      *****************************************************************                       CSE065
      *                                                               *                       CSE065
      *  SRConvSDAL - Convert SDAL from Midas Day number to           *                       CSE065
      *               MMDDYYYY or DDMMYYYY date format                *                       CSE065
      *                                                               *                       CSE065
      *****************************************************************                       CSE065
     C     SRConvSDAL    BEGSR                                                                CSE065
                                                                                              CSE065
     C                   CALLB     'ZA0140M'                                                  CSE065
     C                   PARM                    P@RTN                                        CSE065
     C                   PARM                    P@DAYN                                       CSE065
     C                   PARM                    BJDFIN                                       CSE065
     C                   PARM      *ZEROS        P@DATE                                       CSE065
     C                   PARM      *BLANKS       P@DATA                                       CSE065
     C                   PARM      *ZEROS        P@DAT8                                       CSE065
     C                   PARM      *ZEROS        P@DAT8F                                      CSE065
                                                                                              CSE065
                                                                                              CGL031
      ***European*Taxation*********************************************                CGL031 237063
***** *****************************************************************                CGL031 237063
     C**********         IF        CGL031 = 'Y'                                        CGL031 237063
     C**********         EVAL      DDSETX = SETX                                       CGL031 237063
     C**********         ENDIF                                                         CGL031 237063
     C                   ENDSR                                                                CSE065
      *                                                                                       CSE065
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to initialise fields                     *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** Initialise output parameters.
      *
     C                   CLEAR                   CrDE1ScnFmt
 
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
      *  SRFmtDat - Format Midas Date to DDMMYY (OR MMDDYY)           *
      *                                                               *
      *****************************************************************
     C     SRFmtDat      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM                    PDateOut
     C                   PARM                    PADateOut
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format amount for screen output                   *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADec
 
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    PACTN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
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
