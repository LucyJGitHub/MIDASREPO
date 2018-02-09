     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security Diary Events screen 1 defaults')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDE1DT - Security Diary Events screen 1 defaults          *
      *                                                               *
      *  Function: This module provide initial values for default     *
      *            fields.                                            *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDECTL                                      *
      *                SESEDERPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
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
      *  SRDefault - Default main screen fields                       *
      *  SRFmtDat - Format Midas Date to DDMMYY (OR MMDDYY)           *
      *  SRBkDat - Find Nth working day previous.                     *
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
      ** Security events by type, desc. date
     FSEDEV     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVDFX)
     F                                     PREFIX(I1)
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(SNDEVDF)
     F                                     PREFIX(SO)
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
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *                                                                                       CSE075
      ** Externally described DS for SAR details                                              CSE075
      *                                                                                       CSE075
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE075
     D  SLCD         E                     EXTFLD(LCD)                                        CSE075
      *                                                                                       CSE075
      ** Data structure for access objects, short data structure                              CSE075
      *                                                                                       CSE075
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE075
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work parameters
     D RMFL            S              1A
     D S01509          S              1A
     D S01510          S              1A
     D PPayCcy         S              3A
     D PEvtDno         S              5P 0
     D DDCUCR          S             12A
     D DDSEXR          S             14A
     D DDMATY          S              8A                                                      CSE065
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
     D CSE075          S              1A                                                      CSE075
      *
      ** Work variables
     D WEdft           S              1A
     D WFLD            S              9P 8
      *
      ** Parameters for ZDATE2
     D PDateIn         S              5P 0
     D BJDFIN          S              1A
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameters for ZBKDT
     D PCcy            S              3A
     D PLoc            S              3A
     D PNrDys          S              2P 0
     D PDyNbr          S              5P 0
      *
      ** Parameters for ZEDIT
     D Pfield          S             16A
     D PAdec           S              1P 0
                                                                                              CSE065
      ** Paramters for ZA0140M                                                                CSE065
     D P@RTN           S              1A                                                      CSE065
     D PDayN           S              5P 0                                                    CSE065
     D P@DATE          S              6P 0                                                    CSE065
     D P@DATA          S              7A                                                      CSE065
     D P@DAT8          S              8P 0                                                    CSE065
     D P@DAT8F         S              8P 0                                                    CSE065
      *                                                                                       CSE075
      ** Parameters for AOSARDR0                                                              CSE075
      *                                                                                       CSE075
     D PRTCD           S              7A                                                      CSE075
     D POPTN           S              7A                                                      CSE075
     D PSARD           S              6A                                                      CSE075
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
      ** Initialise work parameters.
      *
     C                   EVAL      PPayCcy = *BLANKS
     C                   EVAL      DDSEXR  = *BLANKS
     C                   EVAL      DDCUCR  = *BLANKS
     C                   EVAL      DDMATY  = *BLANKS                                          CSE065
      *
      ** Default screen fields.
      *
     C                   EXSR      SRDefault
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Default main screen fields                       *
      *                                                               *
      *****************************************************************
     C     SRDefault     BEGSR
      *
      ** Dividends declared.
      *
     C                   IF        DDSDET = 'DV' AND S01510 = 'Y' AND
     C                             DDACTN = 'I'  AND DDSDXD = *BLANKS
 
     C                   MOVE      D1EDFT        WEdft
     C                   MOVEL     D1EDFT        PNrDys
      *
      ** Extension date - Defaults to event date if the extension date
      **  default (day number from PF/SECTYD) is zero.
     C                   IF        PNrDys = *ZEROS
     C                   MOVE      DDSDED        DDSDXD
     C                   ELSE
 
     C                   IF        WEdft = 'W'
     C                   Z-ADD     PEvtDno       PDateIn
     C                   MOVE      D1VLCY        PCcy
     C                   EXSR      SRBkDat
     C                   Z-ADD     PDyNbr        PDateIn
     C                   ELSE
     C                   EVAL      PDateIn = PEvtDno - PNrDys
     C                   ENDIF
 
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      DDSDXD
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Interest rate change.
      *
     C                   IF        DDSDET = 'IR'
      *
      ** First check the diary for prior prior rate change.
     C     KSEDO         SETLL     SECEO
     C                   READ      SECEO                                  01
 
     C                   IF        DDACTN <> 'I'
     C                   READ      SECEO                                  01
     C                   ENDIF
      *
      ** Cumulative coupon rate - If a prior diary event was found, default
      ** this field to next coupon rate.  Otherwise, default it to coupon
      ** from PF/SECTYD.
     C                   MOVE      *BLANKS       Pfield
 
     C                   IF        *IN01 = *OFF AND
     C                             SOSDSN = DDSDSN AND SOSDET = 'IR'
     C                   MOVE      SOSDNC        Pfield
     C                   ELSE
     C                   MOVE      D1CPNR        Pfield
     C                   ENDIF
 
     C                   IF        Pfield <> *ZEROS
     C                   Z-ADD     7             PAdec
     C                   EXSR      SRFmtAmt
     C                   MOVE      Pfield        DDCUCR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Exchange rates.
      *
     C                   IF        DDSDET = 'XR'
      *
      ** Current exchange rate.
     C                   IF        D1SEXR <> *ZEROS
     C                   MOVE      *BLANKS       Pfield
     C                   MOVE      D1SEXR        Pfield
     C                   Z-ADD     8             PAdec
     C                   EXSR      SRFmtAmt
     C                   MOVE      Pfield        DDSEXR
     C                   ENDIF
      *
      ** Payment currency.
     C                   IF        S01509 = 'N'
 
     C                   IF        DDACTN = 'I' AND D1MLTI = 'Y'
      *
      ** Fetch previous payment currency if security is multi-currency.
     C     KSedev        SETLL     SEDEV
     C                   READP     SEDEV                                  02
 
     C                   DOW       *IN02 = *OFF AND DDSDSN = I1SDSN
      *
      ** If previous 'XR' record found, use payment currency.
     C                   IF        I1SDET = 'XR'
     C                   MOVE      I1SDCX        PPayCcy
     C                   LEAVE
     C                   ENDIF
 
     C                   READP     SEDEV                                  02
 
     C                   ENDDO
      *
      ** If no payment currency was retrieved use the nominal currency.
     C                   IF        PPayCcy = *BLANKS
     C                   MOVE      I1NMCY        PPayCcy
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      PPayCcy = D1VLCY
 
     C                   ENDIF
 
     C                   IF        DDPAYC = *BLANKS
     C                   EVAL      DDPAYC = PPayCcy
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redemption calls.
      *
     C                   IF        DDSDET = 'RC' AND  DDACTN = 'I'
 
     C                   IF        S01509 = 'Y'
     C                   EVAL      WFLD = 1
     C                   MOVE      *BLANKS       Pfield
     C                   MOVE      WFLD          Pfield
     C                   Z-ADD     8             PAdec
     C                   EXSR      SRFmtAmt
      *
      ** Exchange rate.
     C                   IF        DDXRAT = *BLANKS
     C                   MOVE      Pfield        DDXRAT
     C                   ENDIF
      *
      ** Redemption currency.
     C                   IF        DDRCCY = *BLANKS
     C                   MOVEL     D1NMCY        DDRCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Analysis cash flow.
     C                   IF        RMFL = 'Y' AND DDRCIC = *BLANK
     C                   MOVE      'Y'           DDRCIC
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Conversions.
      *
     C                   IF        DDSDET = 'CV' AND DDACTN = 'I'
      *
      ** Conversion currency.
     C                   IF        DDCONC = *BLANKS
     C                   MOVEL     D1NMCY        DDCONC
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
                                                                                              CSE065
     C                   IF        CSE065 = 'Y' AND                                           CSE065
     C                             DDSDET = 'AL'                                              CSE065
                                                                                              CSE065
      ** Convert Maturity Date from day number to either MMDDYYYY or                          CSE065
      ** DDMMYYYY format                                                                      CSE065
                                                                                              CSE065
     C                   EVAL      PDayN = D1MATY                                             CSE065
     C                   EXSR      SRConvDte                                                  CSE065
                                                                                              CSE065
     C                   MOVE      P@DAT8F       DDMATY                                       CSE065
     C                   ENDIF                                                                CSE065
 
     C                   IF        DDSDET = 'DV' AND DDACTN = 'I'                             CGL031
                                                                                              CGL031
      ** European Tax Indicator                                                               CGL031
                                                                                              CGL031
     C                   IF        DDSETX = *BLANKS                                           CGL031
     C                   MOVEL     D1SETX        DDSETX                                       CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      *                                                                                       CSE075
      ** Default payment date as Event date plus the delay period                             CSE075
      *                                                                                       CSE075
     C                   IF        CSE075 = 'Y' AND DDSDET = 'MP'                             CSE075
     C                   EVAL      PDateIn = PEvtDno + D1CPDY                                 CSE075
     C                   EXSR      SRFmtDat                                                   CSE075
     C                   MOVE      PDateOut      DDSDPD                                       CSE075
     C                   ENDIF                                                                CSE075
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
      *****************************************************************                       CSE065
      /EJECT                                                                                  CSE065
      *****************************************************************                       CSE065
      *                                                               *                       CSE065
      *  SRConvDte - Convert Midas day number to MMDDYYYY or DDMMYYYY *                       CSE065
      *              date format                                      *                       CSE065
      *                                                               *                       CSE065
      *****************************************************************                       CSE065
     C     SRConvDte     BEGSR                                                                CSE065
                                                                                              CSE065
     C                   CALLB     'ZA0140M'                                                  CSE065
     C                   PARM                    P@RTN                                        CSE065
     C                   PARM                    PDayN                                        CSE065
     C                   PARM                    BJDFIN                                       CSE065
     C                   PARM      *ZEROS        P@DATE                                       CSE065
     C                   PARM      *BLANKS       P@DATA                                       CSE065
     C                   PARM      *ZEROS        P@DAT8                                       CSE065
     C                   PARM      *ZEROS        P@DAT8F                                      CSE065
                                                                                              CSE065
     C                   ENDSR                                                                CSE065
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBkDat - Find Nth working day previous.                     *
      *                                                               *
      *****************************************************************
     C     SRBkDat       BEGSR
 
     C                   CALLB     'ZBKDT'
     C                   PARM                    PDateIn
     C                   PARM                    PCcy
     C                   PARM      *BLANKS       PLoc
     C                   PARM                    PNrDys
     C                   PARM                    PDyNbr
 
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
     C                   PARM                    Pfield
     C                   PARM                    PAdec
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
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
      ** Security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
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
      ** Dividend payments
     C                   PARM                    S01510
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
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
     C                   PARM                    NwDE1ScnFmt
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
     C                   PARM                    DDMATY                                       CSE065
                                                                                              CSE065
      *
      ** Key list for security events by type, desc. date.
     C     KSEDO         KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    DDSDET
     C                   KFLD                    PEvtDno
      *
      ** Key list for diary event record.
     C     KSedev        KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    PEvtDno
     C                   KFLD                    DDSDET
      *                                                                                       CSE075
      ** Access SAR File to determine if CSE075 is switched on                                CSE075
      *                                                                                       CSE075
     C                   EVAL      CSE075 = 'N'                                               CSE075
     C                   CALLB     'AOSARDR0'                                                 CSE075
     C                   PARM      *BLANKS       PRtcd                                        CSE075
     C                   PARM      '*VERIFY'     POptn                                        CSE075
     C                   PARM      'CSE075'      PSard                                        CSE075
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE075
      *                                                                                       CSE075
     C                   IF        PRtcd = *BLANKS                                            CSE075
     C                   EVAL      CSE075 = 'Y'                                               CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CSE075
      ** Issue database error for error return codes                                          CSE075
      *                                                                                       CSE075
     C                   IF        PRtcd <> *BLANKS AND                                       CSE075
     C                             PRtcd <> '*NRF   '                                         CSE075
     C     *LOCK         IN        LDA                                                        CSE075
     C                   EVAL      DBKEY  = 'CSE075'                                          CSE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE075
     C                   EVAL      DBASE  = 1                                                 CSE075
     C                   OUT       LDA                                                        CSE075
     C                   EXSR      *PSSR                                                      CSE075
     C                   ENDIF                                                                CSE075
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
