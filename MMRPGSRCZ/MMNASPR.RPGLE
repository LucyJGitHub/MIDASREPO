     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs purchased retrieve a record')             *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPR   - Negotiable Assets Purchased retrieve a record    *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD044880           Date 15Jan18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 BUG6218            Date 03Jun15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 239400             Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10401           Date 07Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6512            Date 22Apr05               *
      *                 BUG4146            Date 31Aug04               *
      *                 BUG629             Date 19Jul04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA002             Date 26Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 25Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044880 - BOE FBM 2.1 switched on testing and fixing        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Core hooks added: MMNASPRD01,MMNASPRC04, MMNASPRC05 *
      *           MMNASPRC08                                          *
      *  BUG6218 - Extra data must be included in the buffer          *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10401- Add the Auto Authorise flag to the buffer to       *
      *            correct the mapping error.                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG4146 - Stopping two users to update the same record at the*
      *            same time.                                         *
      *  BUG629 - Pass Deal Status (DDSTS) to Midasplus screen.       *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project.                                *
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
 
     D DealScnFmt    E DS                  EXTNAME(MMNASPPD)
      * Deal in screen format
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
      *                                                                                      BUG6218
     D ExtData       E DS                  EXTNAME(MMNPEXPD)                                 BUG6218
      ** Midas MM NASP Extra Data Layout                                                     BUG6218
                                                                                              CER001
     D RegData       E DS                  EXTNAME(MMNPRXPD)                                  CER001
      ** Regional data in screen format - Lux                                                 CER001
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D DealFilFmt    E DS                  EXTNAME(MMDENBPP)
      ** Deal in file format
     D DENBRecIns            477    531                                                       TCA002
     D DENBPayIns            546   1090                                                       TCA002
     D*DENBRecIns************463    531                                                       TCA002
     D*DENBPayIns************532   1090                                                       TCA002
 
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA002
     D  FLREC2                21     75                                                       TCA002
      * Receive settlement instructions in file format
 
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA002
     D  FLPAY2                21    565                                                       TCA002
      * Pay settlement instructions in file format
 
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format
                                                                                              LLN022
     D NaspExFilFmt  E DS                  EXTNAME(BYNASPX0)                                 LLN022A
      ** Negotiable Assets Purchased Details in File format                                  LLN022A
      *                                                                                      LLN022A
                                                                                              CER001
     D NASPLuxVFil   E DS                  EXTNAME(MMVNPLX1PD)                                CER001
      ** NA Purchased Valids Extension File (LUX)                                             CER001
                                                                                              CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER001
      ** First DS for access programs, short data structure                                   CER001
                                                                                              CER001
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER001
      ** External ds for SAR details                                                          CER001
                                                                                            BUG10401
     D InfData       E DS                  EXTNAME(MMNAIFPD)                                BUG10401
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
     D DDFOID          S             20                                                       239400
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      ** Access SAR details file to determine if LLN012                                      LLN022A
      ** FSA Liquidity Report LR extract is installed.                                       LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN012            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       WRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     WOPTN                                       LLN022A
     C                   PARM      'LLN012'      WSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN012 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN012 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMNASPM01
 
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      **  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *                                                                                       CER001
      ** Check if Switch ULX004 is on                                                         CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       WRTCD             7                          CER001
     C                   PARM      '*VERIFY'     WOPTN             7                          CER001
     C                   PARM      'ULX004'      WSARD             6                          CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   SELECT                                                               CER001
     C                   WHEN      WRTCD = *BLANKS                                            CER001
     C                   MOVE      'Y'           ULX004            1                          CER001
     C                   WHEN      WRTCD = '*NRF   '                                          CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   OTHER                                                                CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     WSARD         DBKEY                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   Z-ADD     1             DBASE                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDSL                                                                CER001
      *
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   DealFilFmt
     C                   CLEAR                   NASPLuxVFil                                  CER001
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
     C                   EXSR      MMNASPRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      MMNASPRTV
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   EXSR      SRMMNASP2RV                                                CER001
     C                   ENDIF                                                                CER001
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
                                                                                             BUG6512
      ** If BOE installed Call module that will retrieve details from extension file         LLN022A
      ** BYNASPX0                                                                            LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   CALLB     'MMNASPRTV1'                                              LLN022A
     C                   PARM      *BLANK        ReturnCode                                  LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    FOTRID                                      LLN022A
     C                   PARM                    DDDLNO                                      LLN022A
     C                   PARM                    NaspExFilFmt                                LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *
      * Convert to screen format
     C     Idx           IFEQ      0
     C                   EXSR      MMNASPCVT
      *                                                                                      LLN022A
      ** If BOE installed call module that will convert details of extension file            LLN022A
      ** BYNASPX0 to screen format.                                                          LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   CALLB     'MMNASPCVT1'                                              LLN022A
     C                   PARM      *BLANK        ReturnCode                                  LLN022A
     C                   PARM                    DDDLNO                                      LLN022A
     C                   PARM                    NaspExFilFmt                                LLN022A
     C                   PARM                    ExtData                                     LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        ULX004 = 'Y'                                               CER001
     C                   EXSR      SRMMNASP2CT                                                CER001
     C                   ENDIF                                                                CER001
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
      ** Please ensure that when setting up the buffer, new core fields                      BUG6218
      ** are added before the data structure ExtData                                         BUG6218
      *                                                                                      BUG6218
     C                   MOVEL     HLTMST        @TimeStamp       26                         BUG4146
     C*******************EVAL                    Buffer = DealScnfmt
     C                   EVAL                    Buffer = DealScnfmt + DDSTS
     C                                           + CPST     + DSPCP                          BUG6512
     C                                           + BKST     + DSPBK                          BUG6512
     C                                                    + @TimeStamp                       BUG4146
     C                                           + DDFOID                                     239400
     C                                           + InRecSttmt
     C                                           + InPaySttmt
     C                                           + InfData                                  BUG10401
     C**********                                 + RegData                           CER001 MD044880
     C                                           + ExtData                                   BUG6218
     C                                           + RegData                                  MD044880
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     MMNASPRED     BEGSR
      *
     C                   CALLB     'MMNASPRED'
      * Input parameters
      * ----------------
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM      '      '      @@MODE            6
      * Action code
     C                   PARM                    DDACTN            1
      * Deal number pointer
     C                   PARM      DDDLNO_In     DDDLNO            6
      * Front Office ID
     C                   PARM                    DDFRTN           20
      * Read Forwards
     C                   PARM                    @RDFWD            1
      * Read Backwards
     C                   PARM                    @RDBCK            1
      *
      * Output parameters
      * ------------------
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      * Deal number read
     C                   PARM      *BLANK        @DLRED            6
      * Front Office ID read
     C                   PARM                    @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     MMNASPRTV     BEGSR
      *
     C                   CALLB     'MMNASPRTV'
      * INPUTS
      * ------
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not Front office transaction interface)
     C                   PARM      *BLANK        ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      * Booking branch
     C                   PARM                    BRC
      * OUTPUTS
      * -------
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      * OK - Action code
     C                   PARM      'Y'           DDActnOK          1
      * OK - Deal Number
     C                   PARM      'Y'           DDDlnoOK          1
      * OK - Booking branch
     C                   PARM      'Y'           DDBrcaOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C                   ENDSR
      **********************************************************************
     C     MMNASPCVT     BEGSR
 
     C                   CALLB     'MMNASPCVT'
      * INPUTS
      * ------
      * Return Code
     C                   PARM      *BLANK        ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      * OUTPUTS
      * -------
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
 
     C                   EVAL      DDFOID = HLFRNT                                            239400
                                                                                              239400
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up payment instructions from deal
     C*******************MOVEL     DENBPayIns    FLPAY                                        TCA002
     C                   MOVEL     HLPSTM        FLPSTM                                       TCA002
     C                   MOVEL     HLPONS        FLPONS                                       TCA002
     C                   MOVEL     DENBPayIns    FLPAY2                                       TCA002
     C                   MOVEL     HLPOBR        FLPOBR
     C                   MOVEL     HLCVMR        FLCVMR
     C                   MOVEL     HLSTCY        FLPSCY
     C                   MOVEL     HLIC72        FLIC72
      *
      * Set up receive instructions from deal
     C*******************MOVEL     DENBRecIns    FLREC                                        TCA002
     C                   MOVEL     HLRSTM        FLRSTM                                       TCA002
     C                   MOVEL     HLRONS        FLRONS                                       TCA002
     C                   MOVEL     DENBRecIns    FLREC2                                       TCA002
     C                   MOVEL     HLROBR        FLROBR
     C                   MOVEL     HLSTCY        FLRSCY
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    DBPaySttmt
      *
      ** File receipt settlement instruction
     C                   PARM                    DBRecSttmt
      *
      ** File FRA/IRS settlement instruction
     C                   PARM      *BLANK        DBFRASttmt
      *
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM      *BLANK        InPaySttmt
      *
      ** Screen receipt settlement instruction
     C                   PARM      *BLANK        InRecSttmt
      *
      ** Screen FRA/IRS settlement instruction
     C                   PARM      *BLANK        InFRASttmt
     C                   PARM      HLCCY         InRCCY                                      CSF011A
     C                   PARM      HLCCY         InPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRMMNASP2RV - Subroutine to retrieve extension file detail   *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRMMNASP2RV   BEGSR                                                                CER001
                                                                                              CER001
     C                   CALLB     'MMNASP2RV'                                                CER001
                                                                                              CER001
      ** INPUTS                                                                               CER001
      ** Return Code                                                                          CER001
     C                   PARM      *BLANK        RetCodeIn                                    CER001
      ** (Midas) Deal Number                                                                  CER001
     C                   PARM                    DDDLNO                                       CER001
                                                                                              CER001
      ** OUTPUTS                                                                              CER001
      ** (Current) Deal in file format                                                        CER001
     C                   PARM                    NASPLuxVFil                                  CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      ****************************************************************                        CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRMMNASP2CT - Subroutine to convert extension details        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRMMNASP2CT   BEGSR                                                                CER001
                                                                                              CER001
     C                   CALLB     'MMNASP2CT'                                                CER001
                                                                                              CER001
      ** INPUTS                                                                               CER001
      ** Return Code                                                                          CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
      ** Payment currency                                                                     CER001
     C                   PARM                    DDCCY                                        CER001
      ** (Current) Deal in file format                                                        CER001
     C                   PARM                    NASPLuxVFil                                  CER001
                                                                                              CER001
      ** OUTPUTS                                                                              CER001
      ** (Current) Deal in screen format                                                      CER001
     C                   PARM                    RegData                                      CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    DDACTN            1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    DDDLNO            6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    HLBKCD            4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      **********************************************************************                 BUG6512
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
