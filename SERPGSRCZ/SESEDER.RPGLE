     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities retrieve a record')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDER - SE Retrieve Security Diary Events                  *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8550            Date 07Oct05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG4258            Date 13Sep04               *
      *                 CAP084  *CREATE    Date 07Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSE074 - Constant Yield Amortisation Upgrade to MidasPlus    *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG4258- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas module flag - details
     FMMODF     IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     D SedeScnFmt    E DS                  EXTNAME(SESEDEPD)
      *
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
      *
      ** SE Diary events retrieved from file - file format
     D SedeFilFmt    E DS                  EXTNAME(SEDEVD)
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     D Sede1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(O)
      *
      ** SE Diary events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **-----------------------------------------------------------------------
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      *
      ** Externally described DS for investment types
     D PINVTP        E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
 
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D DRECI         E                     EXTFLD(RECI)
     D DLCD          E                     EXTFLD(LCD)
     D DCHTP         E                     EXTFLD(CHTP)
 
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A
     D CSE010          S              1A
     D CSE031          S              1A
     D CSC011          S              1A
     D CGL031          S              1A                                                      CGL031
     D PEvtDno         S              5P 0
     D PSDSNSel        S             10A
     D PSDETSel        S              2A
     D PSDEDSel        S              6A
     D PErrMs          S              7A
     D PFRNT           S             20A
     D PReDsp          S              1A
     D PMode           S              6A   INZ('      ')
     D POptn           S              7A
     D PRespMode       S              1A   INZ('S')
     D PRtcd           S              7A
     D PSARd           S              6A
     D RMFL            S              1A
     D DDCUCR          S             12A
     D DDSEXR          S             14A
     D DDNTCR          S             11A
     D PPayCcy         S              3A
     D OKFLDS          S              1A   INZ('N')
     D DDMATY          S              8A                                                      CSE074
      *
      ** Processing date
     D WRDAY           S                   LIKE(BJRDNB)
      *
      ** Parameters for ZEDIT
     D ZField          S             16A
     D ZADec           S              1P 0
                                                                                              CSE074
     D CSE065          S              1A                                                      CSE074
 
      *
      ** +--- Start of main processing -----------------------------------+
 
      *                                                                                      BUG8550
      ** Retrieve ZMUSER details.                                                            BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
                                                                                             BUG8550
      *
      **If the action code is blank, enquire unless authorising
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SESEDERED
     C                   MOVEL     PSDSNSel      DDSDSN
     C                   MOVEL     PSDEDSel      DDSDED
     C                   MOVEL     PSDETSel      DDSDET
     C                   ELSE
     C                   MOVEL     DDSDSN_In     DDSDSN
     C                   MOVEL     DDSDED_In     DDSDED
     C                   MOVEL     DDSDET_In     DDSDET
     C                   MOVEL     *BLANK        PErrMs
     C                   ENDIF
      *
      **If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK AND
     C                             DDSDSN <> *BLANK    AND
     C                             DDSDET <> *BLANK
      *
      **Retrieve deal details (all key fields required for call to rtv module)
     C                   EXSR      SESEDERTV
      *
      **Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SESEDECVT
     C                   ENDIF
      *
      ** Setup defaults on screen 1.
     C     Idx           IFEQ      0
     C                   EXSR      SRDefault1
     C                   ENDIF
     C                   ENDIF
      *
      ** Setup field DDNTCR
     C                   IF        CAS006 = 'Y'  AND
     C                             DDSDET = 'IR' AND
     C                             D1CPNN <> *ZEROS
     C                   EXSR      SRSetupDDNTCR
     C                   ENDIF
     C                   IF        RetCodeOut <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDSDSN'      FldNameArr(1)
     C                   MOVEL     PErrMs        MsgIDArr(1)
     C                   ENDIF
     C     OKSDSN        IFEQ      'Y'
     C     OKSDED        ANDEQ     'Y'
     C     OKSDET        ANDEQ     'Y'
     C                   EVAL      OKFLDS = 'Y'
     C                   ELSE
     C                   MOVEL     DDSDSN        ODDSDSN
     C                   MOVEL     DDSDED        ODDSDED
     C                   MOVEL     DDSDET        ODDSDET
     C                   ENDIF
     C
      *
      **Build buffer with required output
     C                   MOVE      TMST          @TimeStamp       26                         BUG4258
     C***************    EVAL      Buffer = Sede1ScnFmt + PPROT + RMFL                       BUG4258
     C                   EVAL      Buffer = Sede1ScnFmt                                      BUG4258
     C                                      + @TimeStamp                                     BUG4258
     C                                      + PPROT + RMFL                                   BUG4258
     C                                 + DDCUCR + DDSEXR +DDNTCR + OKFLDS
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     SESEDERED     BEGSR
     C                   CALLB     'SESEDERED'
      *                             =========
      ** INPUT
      ** =====
 
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    DDSDSN
     C                   PARM                    DDSDED
     C                   PARM                    DDSDET
      *
      ** Read backwards
     C                   PARM                    @RDBCK
      *
      ** Read forwards
     C                   PARM                    @RDFWD
      *
      ** STANDING DATA
      ** =============
 
      *
      ** SDBANK - Single branch
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
 
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    PSDSNSel
     C                   PARM                    PSDEDSel
     C                   PARM                    PSDETSel
 
     C                   ENDSR
      **********************************************************************
     C     SESEDERTV     BEGSR
     C                   EVAL      Idx = 0
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      WRDAY = BJRDNB
 
      ** If CSC011 is present and CTL is still running in the support
      ** system, set the rundate to processing date in dtaara SC24X7,
      ** to be used by RTV module.
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
     C                   EVAL      WRDAY = S1DATE
     C                   ENDIF
      *
     C                   CALLB     'SESEDERTV'
      *
      ** INPUT
      ** =====
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction Id
     C                   PARM      *BLANKS       PFRNT
      *
      ** Security shortname
     C                   PARM                    DDSDSN
      *
      ** Event date
     C                   PARM                    DDSDED
      *
      ** Event type
     C                   PARM                    DDSDET
      *
      ** STANDING DATA
      ** =============
 
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** Rundate
     C                   PARM                    WRDAY
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
 
      *
      ** SE transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Coupon Fixing for Floating Rate Notes
     C                   PARM                    CSE031
                                                                                              CSE074
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE074
     C                   PARM                    CSE065                                       CSE074
      *
      ** OUTPUT
      ** ======
 
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** OK Action code
     C                   PARM                    OKACTN
      *
      ** OK Security shortname
     C                   PARM                    OKSDSN
      *
      ** OK Event date
     C                   PARM                    OKSDED
      *
      ** OK Event type
     C                   PARM                    OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    SEDEFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** Redisplay screen
     C
     C                   PARM      *BLANK        PReDsp
 
     C                   ENDSR
      **********************************************************************
     C     SESEDECVT     BEGSR
 
      *
     C                   CALLB     'SESEDECVT'
      *
      ** INPUT
      ** =====
 
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities retrieved from file - file format
     C                   PARM                    SEDEFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    DDACTN
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
      *
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
                                                                                              CSE074
     C                   PARM                    CSE065                                       CSE074
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
     C                   PARM                    Sede1ScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault1 - Defaulting for screen 1                         *
      *                                                               *
      *****************************************************************
     C     SRDefault1    BEGSR
 
     C                   CALLB     'SESEDE1DT'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    SedeFilFmt
      *
      ** Externally described DS for security details
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
                                                                                              CSE074
     C                   PARM                    CSE065                                       CSE074
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
     C                   PARM                    SedeScnFmt
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE074
     C                   PARM                    DDMATY                                       CSE074
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetupDDNTCR - Routine to setup DDNTCR field.               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRSetupDDNTCR BEGSR
     C                   EVAL      DDNTCR = *BLANKS
     C                   EVAL      ZField = *BLANKS
     C                   MOVE      D1CPNN        ZField
     C                   EVAL      ZADec = 7
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   EVAL      DDNTCR = ZField
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Entry parameters.
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDSDSN_In        10
     C                   PARM                    DDSDED_In         6
     C                   PARM                    DDSDET_In         2
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      *
      **Set up the name of the primary and secondary message files from
      **which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
 
      *
      ** Access bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Value currency to be
      ** currency of the issuer payment' is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01509'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01509'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01509
     C                   ELSE
     C                   MOVEL     'N'           S01509
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Dividend Payments'
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01510'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01510'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01510
     C                   ELSE
     C                   MOVEL     'N'           S01510
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Hedge Accounting
      ** Phase B(CAS006)' is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAS006'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CAS006'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CAS006
     C                   ELSE
     C                   MOVEL     'N'           CAS006
     C                   ENDIF
      *
      ** Access SAR file to determine if 'SE Transaction enhancement'
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE010'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSE010'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE010
     C                   ELSE
     C                   MOVEL     'N'           CSE010
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Coupon Fixing for
      ** Floating Rate Note' is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE031'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSE031'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE031
     C                   ELSE
     C                   MOVEL     'N'           CSE031
     C                   ENDIF
      *
      ** Check if CSC011 is installed
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD = *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
                                                                                              CSE074
      ** Access SAR file to determine if 'SE Transaction enhancement'                         CSE074
      ** is installed.                                                                        CSE074
                                                                                              CSE074
     C                   CALLB     'AOSARDR0'                                                 CSE074
     C                   PARM      *BLANKS       PRtcd                                        CSE074
     C                   PARM      '*VERIFY'     POptn                                        CSE074
     C                   PARM      'CSE065'      PSarD                                        CSE074
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE074
                                                                                              CSE074
      ** An NRF (No Record Found) return code is valid.                                       CSE074
      ** Issue database error only for error return codes.                                    CSE074
                                                                                              CSE074
     C                   IF        PRtcd <> *BLANKS AND                                       CSE074
     C                             PRtcd <> '*NRF   '                                         CSE074
     C     *LOCK         IN        LDA                                                        CSE074
     C                   EVAL      DBKey = 'CSE065'                                           CSE074
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE074
     C                   EVAL      DBase = 9                                                  CSE074
     C                   OUT       LDA                                                        CSE074
     C                   EXSR      *PSSR                                                      CSE074
     C                   ENDIF                                                                CSE074
     C                   IF        PRtcd = *BLANKS                                            CSE074
     C                   MOVEL     'Y'           CSE065                                       CSE074
     C                   ELSE                                                                 CSE074
     C                   MOVEL     'N'           CSE065                                       CSE074
     C                   ENDIF                                                                CSE074
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Access ICD details for securities trading.
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   EVAL      DBASE = 8
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve ZMUSER details.
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
      *
      ** Access MMODF to determine if Strategic Risk Man. Ind is on
     C                   READ      MMODF                                  01
 
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SESEDE011
 
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
(c) Finastra International Limited 2004
