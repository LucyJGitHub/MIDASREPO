     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees retrieve')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  DLDLFERTV - DEALING FEES RETRIEVE                            *
      *              (WITH ACTION CODE VERSUS Transact.NO. VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and deal number.                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EUR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting.  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction File by Front Office Id
     FDLFEEDL2  IF   E           K DISK    INFSR(*PSSR)
 
     FDLFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDTR)
 
      ** Transaction File by Transaction Number
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
 
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** External DS for bank details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
 
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
 
     D DealsDtl1     E DS                  EXTNAME(DEALSDC)
     D DLFEFilFmt    E DS                  EXTNAME(DLFEED)
     D                                     PREFIX(@)
      ** Dealing Fees retrieve from file.
     D DLF2FilFmt    E DS                  EXTNAME(DLFEED)
     D P_RONS        E                     EXTFLD(RONSQQ)                                     CAS011
     D P_PONS        E                     EXTFLD(PONSQQ)                                     CAS011
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D ZMUSER          DS            17
     D  ZUSER                  1     10
     D  BRC                   11     13
     D  DEPT                  14     16
     D DEALKY          S                   LIKE(DFDLNO)
     D FSEQKY          S                   LIKE(DFFSEQ)
     D OKACTN          S              1A
     D OKDLNO          S              1A
     D OKFSEQ          S              1A
     D DDDLNO          S              6A
     D DDFSEQ          S              2A
     D DDACTN          S              1A
     D ZACTN           S                   LIKE(DDACTN)
     D ERR             S              1  0
     D W1TRNN          S              1A
     D ModeofOp        S              6A
     D RespMode        S              1A
     D Fotrid          S             20A
     D ZBR             S                   LIKE(DFBRCA)
     D WWDLNO          S              6  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      * Initialization
 
     C                   EXSR      INIT
 
      * If the mode is 'Front Office Transaction Interface'
      * Do (Extra) Validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code & Transaction Number
 
     C                   EXSR      VAL
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' OR  OKDLNO = 'N'
     C                             OR OKFSEQ = 'N'
     C                   RETURN
     C                   ENDIF
 
     C     DDACTN        CASEQ     'I'           VALINS
     C     DDACTN        CASEQ     'A'           VALAMD
     C     DDACTN        CASEQ     'D'           VALDEL
     C     DDACTN        CASEQ     'E'           VALENQ
     C     DDACTN        CASEQ     'X'           VALAUT
     C                   CAS                     VALERR
     C                   ENDCS
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
 
      **  Check user's authority for the action.
 
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN
     C                   PARM                    ERR
 
      **  If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0292'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
 
      **  Check user's authority for the action & Booking Branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN
     C                   PARM      BRCA          ZBR
     C                   PARM                    ERR
 
      **   If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0290'
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   IF        DDACTN = 'E' OR  DDACTN = 'I' OR DDACTN = 'A'
     C                             OR DDACTN = 'D' OR DDACTN = 'X'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0291'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************************
      * RTVDLFE - Retrieve Transaction Details If action code 'A', 'E' , 'X' OR 'D'
      *****************************************************************************
     C     RTVDLFE       BEGSR
 
      **  If there is no valid record on DLFEEDL1, it is an error.
 
     C     @DEALKY       CHAIN     DLFEEDL1
 
      **  Check for a valid record.
 
     C                   IF        NOT %FOUND(DLFEEDL1) OR DFRECI <> 'D'
     C                             AND DDACTN <> 'E'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      OKFSEQ = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0029'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      ** Error if action code is not 'I','A','E' OR 'D'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'X'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0200'
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0201'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access Transaction with Front Office Transaction ID
 
     C     FOTRID        CHAIN     DLFEEDL2
 
      ** If Insert
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be Present already
 
     C                   IF        %FOUND(DLFEEDL2)
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0202'
     C                   EVAL      MsgDtaArr(Idx) = FOTRID
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID Must be Present
 
     C                   IF        NOT %FOUND(DLFEEDL2)
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0203'
     C                   EVAL      MsgDtaArr(Idx) = FOTRID
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ENDIF
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRANSACTION NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      ** Action Code
      **  .. must be 'I','A','D', 'X', or 'E'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'X' AND
     C                             DDACTN <> 'E'
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0036'
     C                   ENDIF
 
      ** Deal number  required
 
     C                   IF        DDDLNO = *BLANKS OR
     C                             DDDLNO = *ZEROS
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0037'
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** If the Deal Number is not blank, check that it is numeric.
 
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        W1TRNN
     C                   TESTZ                   W1TRNN                   99
     C                   IF        DDDLNO <> *BLANKS AND
     C                             *IN98 = *OFF OR
     C                             DDDLNO <> *BLANKS AND
     C                             *IN99 = *OFF
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0036'
     C                   GOTO      EVAL
     C                   ENDIF
     C                   MOVEL     DDDLNO        WWDLNO
 
      ** Access Transaction from the Transactions file
 
     C     WWDLNO        CHAIN     DEALS
     C                   IF        RCDT = 'C'
     C                   MOVEL     DealsDtl1     DealsDtlC
     C                   ELSE
     C                   EXSR      MoveDtl
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALINS - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALINS        BEGSR
 
      ** Error if not found
 
     C                   IF        NOT %FOUND(DEALS)
     C                   EVAL      OKDLNO = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0027'
     C                   ELSE
     C                   IF        DTYP <> 'IP' AND DTYP <> 'TI'
     C                             AND DTYP <> 'CL' AND DTYP <> 'DL'
     C                             AND DTYP <> 'IT' AND DTYP <> 'TD'
     C                             AND DTYP <> 'CI' AND DTYP <> 'CD'
     C                             AND DTYP <> 'C2' AND DTYP <> 'BP'
     C                             AND DTYP <> 'BD' AND DTYP <> 'TB'
     C                             AND DTYP <> 'DA' AND DTYP <> 'TA'
     C                   EVAL      OKDLNO = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0028'
     C                   ENDIF
     C                   ENDIF
 
      ** Fee sequence should be blank on insert
 
     C                   IF        DDFSEQ <> *BLANKS
     C                   EVAL      OKFSEQ = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSEQ'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0034'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      * VALENQ - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALENQ        BEGSR
 
      ** Access Transaction from the Transactions file
 
     C                   EXSR      RTVDLFE
     C                   ENDSR
      *****************************************************************
      * VALAMD - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALAMD        BEGSR
 
      ** Access Transaction from the Transactions file
 
     C                   EXSR      RTVDLFE
 
     C                   ENDSR
      *****************************************************************
      * VALAUT - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALAUT        BEGSR
 
      ** Access Transaction from the Transactions file
 
     C                   EXSR      RTVDLFE
 
      ** Authorising user must be different from the insert and
      ** amend users
 
     C     ZUSER         IFEQ      DFIUSR
     C     ZUSER         OREQ      DFAUSR
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0031'
     C                   ENDIF
 
      ** Status of deal must be complete or requiring re-authori-
      ** sation
 
     C     DFFSTS        IFNE      'C'
     C     DFFSTS        ANDNE     'R'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0032'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALDEL - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALDEL        BEGSR
 
      ** Access Transaction from the Transactions file
 
     C                   EXSR      RTVDLFE
     C                   ENDSR
      *****************************************************************
      * MOVEDTL - Move DealsDc fields to DealsDtlD Data strcuture
      *****************************************************************
     C     MOVEDTL       BEGSR
 
     C                   EVAL      D_RECI = RECI
     C                   EVAL      D_DLNO = DLNO
     C                   EVAL      D_RCDT = RCDT
     C                   EVAL      D_RCDC = RCDC
     C                   EVAL      D_ISCN = ISCN
     C                   EVAL      D_BRCA = BRCA
     C                   EVAL      D_DTYP = DTYP
     C                   EVAL      D_DLST = DLST
     C                   EVAL      D_DDAT = DDAT
     C                   EVAL      D_VDAT = VDAT
     C                   EVAL      D_MDAT = MDAT
     C                   EVAL      D_IDAS = IDAS
     C                   EVAL      D_BRKC = BRKC
     C                   EVAL      D_BAGE = BAGE
     C                   EVAL      D_CCY  = CCY
     C                   EVAL      D_PUPR = PUPR
     C                   EVAL      D_ZZ001 = ZZ001
     C                   EVAL      D_YRAT = YRAT
     C                   EVAL      D_ZZ008 = ZZ008
     C                   EVAL      D_RTSP = RTSP
     C                   EVAL      D_INTR = INTR
     C                   EVAL      D_ZZ003 = ZZ003
     C                   EVAL      D_RNNA = RNNA
     C                   EVAL      D_CNUM = CNUM
     C                   EVAL      D_FACT = FACT
     C                   EVAL      D_FCNO = FCNO
     C                   EVAL      D_FVAL = FVAL
     C                   EVAL      D_BCXR = BCXR
     C                   EVAL      D_LCXR = LCXR
     C                   EVAL      D_SDST = SDST
     C                   EVAL      D_OSDA = OSDA
     C                   EVAL      D_TSTN = TSTN
     C                   EVAL      D_MDST = MDST
     C                   EVAL      D_OMDA = OMDA
     C                   EVAL      D_TMAN = TMAN
     C                   EVAL      D_BDID = BDID
     C                   EVAL      D_ZZ002A = ZZ002A
     C                   EVAL      D_DISA = DISA
     C                   EVAL      D_ZZ006 = ZZ006
     C                   EVAL      D_DPTD = DPTD
     C                   EVAL      D_ICBS = ICBS
     C                   EVAL      D_IPFR = IPFR
     C                   EVAL      D_TOTI = TOTI
     C                   EVAL      D_NIDT = NIDT
     C                   EVAL      D_IBDT = IBDT
     C                   EVAL      D_SLID = SLID
     C                   EVAL      D_AIPD = AIPD
     C                   EVAL      D_DLRC = DLRC
     C                   EVAL      D_IACD = IACD
     C                   EVAL      D_AITC = AITC
     C                   EVAL      D_AIAN = AIAN
     C                   EVAL      D_AIAP = AIAP
     C                   EVAL      D_IPRD = IPRD
     C                   EVAL      D_IPRM = IPRM
     C                   EVAL      D_SAPR = SAPR
     C                   EVAL      D_ASDN = ASDN
     C                   EVAL      D_SADT = SADT
     C                   EVAL      D_DAVD = DAVD
     C                   EVAL      D_DASN = DASN
     C                   EVAL      D_FACO = FACO
     C                   EVAL      D_SPI = SPI
     C                   EVAL      D_INTF = INTF
     C                   EVAL      D_MDBX = MDBX
     C                   EVAL      D_PINT1 = PINT1
     C                   EVAL      D_ZZ015 = ZZ015
     C                   EVAL      D_DNSI = DNSI
     C                   EVAL      D_DSTI = DSTI
     C                   EVAL      D_CNFI = CNFI
     C                   EVAL      D_ACEI = ACEI
     C                   EVAL      D_TLXI = TLXI
     C                   EVAL      D_ZZ010 = ZZ010
     C                   EVAL      D_LSWC = LSWC
     C                   EVAL      D_LSWS = LSWS
     C                   EVAL      D_ZZ002 = ZZ002
     C                   EVAL      D_ORED = ORED
     C                   EVAL      D_LCD  = LCD
     C                   EVAL      D_CHTP = CHTP
     C                   EVAL      D_TNLU = TNLU
     C                   EVAL      D_BOKC = BOKC
     C                   EVAL      D_LNKDN = LNKDN
     C                   EVAL      D_RSTM = RSTM
     C                   EVAL      D_RONS = RONS
     C                   EVAL      D_RIBN = RIBN
     C                   EVAL      D_RIBA = RIBA
     C                   EVAL      D_ROBN = ROBN
     C                   EVAL      D_ROCN = ROCN
     C                   EVAL      D_PSTM = PSTM
     C                   EVAL      D_PONS = PONS
     C                   EVAL      D_PIBN = PIBN
     C                   EVAL      D_PIBA = PIBA
     C                   EVAL      D_POBN = POBN
     C                   EVAL      D_POCN = POCN
     C                   EVAL      D_RCRN = RCRN
     C                   EVAL      D_RCRA = RCRA
     C                   EVAL      D_RVNO = RVNO
     C                   EVAL      D_AWBN = AWBN
     C                   EVAL      D_AWBA = AWBA
     C                   EVAL      D_BENN = BENN
     C                   EVAL      D_BENA = BENA
     C                   EVAL      D_DTP1 = DTP1
     C                   EVAL      D_DTP2 = DTP2
     C                   EVAL      D_DTP3 = DTP3
     C                   EVAL      D_DTP4 = DTP4
     C                   EVAL      D_DCHG = DCHG
     C                   EVAL      D_BTB1 = BTB1
     C                   EVAL      D_BTB2 = BTB2
     C                   EVAL      D_BTB3 = BTB3
     C                   EVAL      D_BTB4 = BTB4
     C                   EVAL      D_BTB5 = BTB5
     C                   EVAL      D_BTB6 = BTB6
     C                   EVAL      D_ORBR = ORBR
     C                   EVAL      D_PRFC = PRFC
     C                   EVAL      D_ROBR = ROBR
     C                   EVAL      D_POBR = POBR
     C                   EVAL      D_CVMR = CVMR
     C                   EVAL      D_JRDFC = JRDFC
     C                   EVAL      D_NSDD = NSDD
     C                   EVAL      D_PCLI = PCLI
     C                   EVAL      D_PSZE = PSZE
     C                   EVAL      D_OPUP = OPUP
     C                   EVAL      D_NSLD = NSLD
     C                   EVAL      D_FSRP = FSRP
     C                   EVAL      D_FSGN = FSGN
     C                   EVAL      D_FPRC = FPRC
     C                   EVAL      D_TCOF = TCOF
     C                   EVAL      D_ACPD = ACPD
     C                   EVAL      D_ACDA = ACDA
     C                   EVAL      D_ACAP = ACAP
     C                   EVAL      D_ACAN = ACAN
     C                   EVAL      D_COFD = COFD
     C                   EVAL      D_COFM = COFM
     C                   EVAL      D_STCY = STCY
     C                   EVAL      D_IC72 = IC72
     C                   EVAL      D_FSOYLC = FSOYLC
     C                   EVAL      D_FSURPL = FSURPL
     C                   EVAL      D_FSTUPL = FSTUPL
     C                   EVAL      D_FSPUPL = FSPUPL
     C                   EVAL      D_FSYUPL = FSYUPL
     C                   EVAL      D_FSEFUP = FSEFUP
     C                   EVAL      D_FSECUP = FSECUP
     C                   EVAL      D_FSLQPR = FSLQPR
     C                   EVAL      D_FSLQPS = FSLQPS
     C                   EVAL      D_FSAIPN = FSAIPN
     C                   EVAL      D_FSIPRN = FSIPRN
     C                   EVAL      D_FSAIAN = FSAIAN
     C                   EVAL      D_FSAITN = FSAITN
     C                   EVAL      D_FSAINN = FSAINN
     C                   EVAL      D_FSIPMN = FSIPMN
     C                   EVAL      D_FSTOTN = FSTOTN
     C                   EVAL      D_FSPINN = FSPINN
     C                   EVAL      D_TFDP = TFDP
     C                   EVAL      D_TFDPA = TFDPA
     C                   EVAL      D_TFAM = TFAM
     C                   EVAL      D_TFAC = TFAC
     C                   EVAL      D_AFDP = AFDP
     C                   EVAL      D_CFDP = CFDP
     C                   EVAL      D_AMDS = AMDS
     C                   EVAL      D_AMADJ = AMADJ
     C                   EVAL      D_ANADJ = ANADJ
     C                   EVAL      D_DSAM = DSAM
     C                   EVAL      D_AMCOST = AMCOST
     C                   EVAL      D_YMCOST = YMCOST
     C                   EVAL      D_YAINT = YAINT
 
     C                   ENDSR
      *****************************************************************
      *  VALERR - Error in Action code                                *
      *****************************************************************
     C     VALERR        BEGSR
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'DLF0033'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
      ** Clear Outputs
 
     C                   CLEAR                   DLF2FilFmt
     C                   CLEAR                   DealsDtlC
     C                   CLEAR                   DealsDtlD
     C                   CLEAR                   DealsDtl1
     C**********         EVAL      ISCN = *ZERO                                               CSD027
     C                   EVAL      ISCN = *BLANKS                                             CSD027
     C                   EVAL      IDAS = *ZERO
     C                   EVAL      PUPR = *ZERO
     C                   EVAL      YRAT = *ZERO
     C                   EVAL      FVAL = *ZERO
     C                   EVAL      BDID = *ZERO
     C                   EVAL      DISA = *ZERO
     C                   EVAL      DPTD = *ZERO
     C                   EVAL      SAPR = *ZERO
     C                   EVAL      ASDN = *ZERO
     C                   EVAL      SADT = *ZERO
     C                   EVAL      MDBX = *ZERO
     C                   EVAL      PINT1 = *ZERO
     C                   EVAL      NSDD = *ZERO
     C                   EVAL      PSZE = *ZERO
     C                   EVAL      OPUP = *ZERO
     C                   EVAL      NSLD = *ZERO
     C                   EVAL      FSPINN = *ZERO
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKDLNO = 'Y'
     C                   EVAL      OKFSEQ = 'Y'
     C                   EVAL      Idx = 0
     C                   MOVEL     DDDLNO        DEALKY
     C                   MOVEL     DDFSEQ        FSEQKY
     C     @DEALKY       KLIST
     C                   KFLD                    DEALKY
     C                   KFLD                    FSEQKY
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
     C                   PARM                    RespMode
 
      ** Action Code
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    FOTRID
 
      ** Deal number
     C                   PARM                    DDDLNO
 
      ** Fee Sequence
     C                   PARM                    DDFSEQ
 
      ** Outputs
      ** Transaction Details in File Format
     C                   PARM                    DLF2FilFmt
 
      ** OK - Action code
     C                   PARM                    OKACTN
 
      ** OK - Deal Number
     C                   PARM                    OKDLNO
 
      ** OK - Fee sequence
     C                   PARM                    OKFSEQ
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
      ** Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'DLDLFERTV'
 
     C     *DTAARA       DEFINE                  ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   MOVEL     '900'         DBASE
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
