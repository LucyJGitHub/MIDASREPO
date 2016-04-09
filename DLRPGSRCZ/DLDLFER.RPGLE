     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees Retrieve a Record')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFER - DL Dealing Fees Retrieve a Record                  *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
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
      *                 CAS011  *CREATE    Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
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
      ** names, prefzxed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
     D DLFEScnFmt    E DS                  EXTNAME(DLDLFEPD)
      ** Transaction in Screen Format
 
     D DLFEFilFmt    E DS                  EXTNAME(DLFEED)
      ** Transaction in File Format
     D  FeemFilREC           166    220
     D**FeemFilPAY           235    289                                                      CSF011A
     D  FeemFilPAY           235    779                                                      CSF011A
 
     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
 
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs - short data structure
 
      ** Settlement details data structures file format
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D  FLREC                 21     75
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                 21    565
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
 
      ** Settlement details data structures screen format
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PStat           S             16A
     D PRespMode       S              1A
     D PAmendOk        S              1A
     D PActnOK         S              1A
     D PDlnoOK         S              1A
     D PDlFSeqOK       S              1A
     D PAPIRetCd       S              1A
     D PModeofOp       S              6A
     D PAPFOTranID     S             20A
     D PBuffer         S           6000A
     D PAuthComp       S              1A
     D PFwdBck         S              1A
     D PDDDLNO_In      S              6A
     D PDDFSEQ_In      S              2A
     D PMODE           S              6A
     D PDACTN          S              1A
     D PDDLNO          S              6A
     D PDFRTN          S             20A
     D PRDFWD          S              1A
     D PRDBCK          S              1A
     D PERRMS          S              7A
     D PDLRED          S              6A
     D PFTRED          S             20A
     D PSQRED          S              2A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
 
      **-------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
      **  Hook to enable non-core message files to be included
      /COPY WNCPYSRC,DLDLFEM02
 
      ** Initialise dealing fees file format
     C                   CLEAR                   DLFEFilFmt
 
      ** If the action code is blank, enquire unless authorising
     C                   IF        PDACTN = *BLANK
     C                   IF        PAuthComp = 'X'
     C                   MOVEL     'X'           PDACTN
     C                   ELSE
     C                   MOVEL     'E'           PDACTN
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PFwdBck = 'F'
     C                   MOVEL     'Y'           PRDFWD
     C                   MOVEL     'N'           PRDBCK
     C                   ELSE
     C                   IF        PFwdBck = 'B'
     C                   MOVEL     'N'           PRDFWD
     C                   MOVEL     'Y'           PRDBCK
     C                   ELSE
     C                   MOVEL     'N'           PRDFWD
     C                   MOVEL     'N'           PRDFWD
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PRDFWD = 'Y' OR
     C                             PRDBCK = 'Y'
     C                   EXSR      SRDLFERED
     C                   ELSE
     C                   MOVEL     PDDDLNO_In    PDLRED
     C                   MOVEL     PDDFSEQ_In    PSQRED
     C                   MOVEL     *BLANK        PERRMS
     C                   ENDIF
 
      ** If deal read and no error message returned, retrieve deal details
      ** then convert to screeen format
     C                   IF        RetCodeOut = *BLANK AND
     C                             PDLRED <> *BLANK
 
     C                   MOVEL     PFTRED        PAPFOTranID
     C                   MOVEL     PDLRED        PDDLNO
     C                   MOVEL     PSQRED        DDFSEQ
     C                   EXSR      SRDLFERTV
 
      ** Convert retrieved dealing fee details to screen format
     C                   IF        Idx = *ZERO
     C                   EXSR      SRDLFECVT
     C                   EXSR      SRCVTSETTLE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           PAPIRetCd
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     PERRMS        MsgIDArr(1)
     C                   ENDIF
 
      ** Build buffer with required output
     C                   EVAL      PBuffer = DLFEScnFmt
     C*                                     + ##RECS + ##PAYS
     C                                      + ##RECS + ##PAYS                                CSF011A
 
     C                   MOVE      *ON           *INLR
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRDLFERED - Read Dealing Fee Details
      *****************************************************************
     C     SRDLFERED     BEGSR
 
     C                   CALLB     'DLDLFERED'
 
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM      '      '      PMODE
 
      ** Action Code
     C                   PARM                    PDACTN
 
      ** Deal Number Pointer
     C                   PARM      PDDDLNO_In    PDDLNO
 
      ** Front Office ID
     C                   PARM                    PDFRTN
 
      ** Read Forwards
     C                   PARM                    PRDFWD
 
      ** Read Backwards
     C                   PARM                    PRDBCK
 
      ** OUTPUTS
      ** Error Message
     C                   PARM      *BLANK        PERRMS
 
      ** Deal Number Read
     C                   PARM      *BLANK        PDLRED
 
      ** Front Office ID Read
     C                   PARM      *BLANK        PFTRED
 
      ** Sequence Number Read
     C                   PARM                    PSQRED
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRDLFERTV - Retrieve dealing fee details from file
      *****************************************************************
     C     SRDLFERTV     BEGSR
 
     C                   CALLB     'DLDLFERTV'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS
      ** Return code
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      *BLANK        PModeofOp
 
      ** Response mode
     C                   PARM      'S'           PRespMode
 
      ** Action Code
     C                   PARM                    PDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    PAPFOTranID
 
      ** Deal number
     C                   PARM                    PDDLNO
 
      ** Fee Sequence
     C                   PARM                    DDFSEQ
 
      ** OUTPUTS
      ** Transaction Details in File Format
     C                   PARM                    DLFEFilFmt
 
      ** OK - Action code
     C                   PARM                    PActnOK
 
      ** OK - Deal Number
     C                   PARM                    PDlnoOK
 
      ** OK - Fee sequence
     C                   PARM                    PDlFSeqOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
 
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRDLFECVT - Convert fee details from file to screen format
      *****************************************************************
     C     SRDLFECVT     BEGSR
 
     C                   CALLB     'DLDLFECVT'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Transaction Details in File Format
     C                   PARM                    DLFEFilFmt
 
      ** OUTPUTS
      ** Current transaction in screen format
     C                   PARM                    DLFEScnfmt
 
      ** Status
     C                   PARM                    PStat
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **  SRCVTSETTLE - Convert settlement file format to screen      *
      *****************************************************************
     C     SRCVTSETTLE   BEGSR
 
      ** Set up payment instructions from fee
     C                   MOVEL     FeemFilPAY    FLPAY
     C                   MOVEL     DFPSTM        FLPSTM
     C                   MOVEL     DFPONS        FLPONS
     C                   MOVEL     DFCVMR        FLCVMR
     C                   MOVEL     DFSCCY        FLPSCY
     C                   MOVEL     DFICCY        FLIC72
     C                   MOVE      DFOMDB        FLPOBR
 
      ** Set up receive instructions from fee
     C                   MOVEL     FeemFilREC    FLREC
     C                   MOVEL     DFRSTM        FLRSTM
     C                   MOVEL     DFRONS        FLRONS
     C                   MOVEL     DFSCCY        FLRSCY
     C                   MOVE      DFOSDB        FLROBR
 
      ** Convert settlement details from file to screen format
     C                   CALLB     'ZASETINCVT'
 
      ** INPUTS
      ** File Payment Settlement Instruction
      ** File Receipt Settlement Instruction
      ** File FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANKS       ##FRIF
 
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
      ** Screen Receipt Settlement Instruction
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANKS       ##PAYS
     C                   PARM      *BLANKS       ##RECS
     C                   PARM      *BLANKS       ##FRIS
     C                   PARM      DDFCCY        InRCCY                                      CSF011A
     C                   PARM      DDFCCY        InPCCY                                      CSF011A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initialisations
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PAuthComp
     C                   PARM                    PFwdBck
     C                   PARM                    PDDDLNO_In
     C                   PARM                    PDDFSEQ_In
     C                   PARM                    PBuffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    PAPIRetCd
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'DLUSRMSG'
 
      ** Access bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      PAPIRetCd = '0'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
