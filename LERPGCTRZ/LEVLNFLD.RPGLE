     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Loan/Fees fields')          *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *          PDCL                                                 *
      *                                                               *
      *  LEVLNFLD - Validate Loan/Fees fields                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 AR1075853          Date 08Jan13               *
      *                 AR1073112          Date 27Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 262691             Date 01Aug12               *
      *                 262431   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR1075853 - APCTRANR does not allow transactions from being  *
      *              processed during COB                             *
      *  AR1073112 - Base rate code must only be validated if it is   *
      *              not blanks                                       *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  262691 - Manual PDCL input error                             *
      *  262431 - Serious Midas Error                                 *
      *                                                               *
      *****************************************************************
      *
      ** Penalties file
     FLEPRATL1  IF   E           K DISK
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others)
      ** the LDA layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields
      ** in the  Program Status Data Structures.
      ** They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant
      ** giving the size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
      *
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(LEPDCLPD)
      *
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(LEEPDCLPD)
      *
      ** Valid Transaction Details layout
     D ValidPDCL     E DS                  EXTNAME(LEVPDCLPD)
      *
      ** Data structure for loan ICD details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      *
      ** Data structure for loan ICD details
     D SDLOAN1       E DS                  EXTNAME(SDLOANPD)
     D                                     PREFIX(@)
      *
      ** Fee codes
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      *
      ** Base Rate Info
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** Formatting Details
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Short data structure for access objects                                              CLE134
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CLE134
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
     D BJRDNB          S              5  0
     D BJDFIN          S              1
      *
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
      *
     DWLOAN            S              6
     DWLTYP            S              2
     DWSUTP            S              2
     DWCLAS            S              4
     DWFCOD            S              2
      *
     DPLoanType        S              2
     DPLSubType        S              2
     DPLClass          S              4
      *
     D@FECD            S              2
     D@KEY1            S              3
     D@KEY2            S              2
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      ** Validation of various "BACKGROUND" fields to avoid system
      ** errors
      *
      ** LOANS
      *
     C                   IF        RecordType = Loan
      *
     C                   EVAL      WLOAN = DDORLN
      *
     C                   EVAL      WLTYP = DDLTYP
     C                   EVAL      WSUTP = DDSUTP
     C                   EVAL      WCLAS = DDLNCL
      *
      ** Find type/subtype info
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WLTYP         PLoanType
     C                   PARM      WSUTP         PLSubType
     C                   PARM      WCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     WLTYP         CAT       WSUTP         DBKEY
     C                   MOVE      WCLAS         DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Find range for PDCL loan
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AYPPLT        PLoanType
     C                   PARM      AYPPLS        PLSubType
     C                   PARM      AYPPLC        PLClass
     C     SDLOAN1       PARM      SDLOAN1       DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     AYPPLT        CAT       AYPPLS        DBKEY
     C                   MOVE      AYPPLC        DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Override the AY fields of the original loan where necessary
      *
     C                   MOVE      @AYLNTY       AYLNTY
     C                   MOVE      @AYLNST       AYLNST
     C                   MOVE      @AYLCD        AYLCD
     C                   MOVE      @AYTYLC       AYTYLC
     C                   MOVE      @AYLNTD       AYLNTD
     C                   MOVE      @AYLNPT       AYLNPT
     C                   MOVE      @AYEXPC       AYEXPC
     C                   MOVE      @AYINN1       AYINN1
     C                   MOVE      @AYINNR       AYINNR
     C                   MOVE      @AYLVLD       AYLVLD
     C                   MOVE      @AYDPRC       AYDPRC
     C                   MOVE      @AYRANG       AYRANG
     C                   MOVE      @AYILTY       AYILTY
     C                   MOVE      @AYILST       AYILST
     C                   MOVE      @PLDPCD       PLDPCD
     C                   MOVE      @PLDRCD       PLDRCD
     C                   MOVE      @PLCRED       PLCRED
     C                   MOVE      @AYYLDC       AYYLDC
     C                   MOVE      @AYFYLD       AYFYLD
     C                   MOVE      @AYYLDM       AYYLDM
     C                   MOVE      @AYFYCM       AYFYCM
     C                   MOVE      @AYZONE       AYZONE
     C                   MOVE      @AYACAI       AYACAI
     C                   MOVE      @AYLNCL       AYLNCL
     C                   MOVE      @AYILCL       AYILCL
     C                   MOVE      @AYIUSR       AYIUSR
     C                   MOVE      @AYAUSR       AYAUSR
     C                   MOVE      @AYXUSR       AYXUSR
     C                   MOVE      @AYAACC       AYAACC
     C                   MOVE      @AYEACC       AYEACC
     C                   MOVE      @AYGPDT       AYGPDT
     C                   MOVE      @AYOVRD       AYOVRD
     C**********         MOVE      @AYPCKO       AYPCKO                                       CLE164
     C                   MOVE      @AYPGID       AYPGID                                       CLE164
      *
      ** Access Penalties files and override values
      *
     C     WLOAN         CHAIN     LEPRATL1                           99
      *
     C                   IF        *IN99 = *OFF
     C                   EVAL      AYCAPI = B2CAPI
     C                   EVAL      AYSIIN = B2SPLI
     C                   EVAL      AYPBSR = B2PBSR
     C                   EVAL      AYPBRT = B2PBRT                                            CLE134
     C                   EVAL      AYPRSP = B2PRSP
     C                   EVAL      AYPRSI = B2PRAT
     C                   EVAL      AYPICB = B2PICB
     C                   EVAL      AYIBSR = B2IBSR
     C                   EVAL      AYIBRT = B2IBRT                                            CLE134
     C                   EVAL      AYIRSP = B2IRSP
     C                   EVAL      AYIRSI = B2IRAT
     C                   EVAL      AYIICB = B2IICB
     C                   EVAL      AYPOPR = B2POPR
     C                   ENDIF
      *
     C                   ELSE
      *
      ** FEES
      *
     C                   EVAL      WFCOD = DDFCOD
      *
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WFCOD         @FECD
     C     SDFEE         PARM      SDFEE         DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDFEEPD'
     C                   EVAL      DBKEY = WFCOD
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve base rates, penalties, ranges, etc. for all
      *
     C                   EVAL      WLTYP = AUCLTY
     C                   EVAL      WSUTP = AUCLST
     C                   EVAL      WCLAS = AUCLCL
      *
      ** Find type/subtype info
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WLTYP         PLoanType
     C                   PARM      WSUTP         PLSubType
     C                   PARM      WCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     WLTYP         CAT       WSUTP         DBKEY
     C                   MOVE      WCLAS         DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check the Base Rate data
      *
     C                   IF        RecordType = Loan
      *
      ** Check main PDCL (principal) for a loan
      *
     C                   IF        AYPBRT = 0                                                 CLE134
     C                   IF        AYPBSR <> 0                                             AR1073112
     C                   EVAL      @KEY1 = DDCCY
     C                   MOVE      AYPBSR        @KEY2
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                             AND AYPBSR <> *ZEROS                                       262691
     C                             OR  AYPBSR = *ZEROS                                        262691
     C                             AND AYPRSP = *ZEROS                                        262691
     C                   EVAL      DDORLNOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDORLN'
     C                   EVAL      MsgIdXAr(Idx) = '5045663'
     C                   ENDIF
     C                   ELSE                                                                 CLE134
     C                   IF        AYPBSR <> 0                                                CLE134
     C                   EVAL      DDORLNOK = 'N'                                             CLE134
     C                   EVAL      Idx += 1                                                   CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDORLN'                                  CLE134
     C                   EVAL      MsgIdXAr(Idx) = '5045689'                                  CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                             AR1073112
     C                   ENDIF                                                                CLE134
      *
      ** Check interest PDCL for a loan
      *
     C                   IF        NSEIN = 'Y'
      *
     C                   IF        AYIBRT = 0                                                 CLE134
     C                   IF        AYIBSR <> 0                                             AR1073112
     C                   EVAL      @KEY1 = DDCCY
     C                   MOVE      AYIBSR        @KEY2
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                             AND AYIBSR <> *ZEROS                                       262691
     C                             OR  AYIBSR = *ZEROS                                        262691
     C                             AND AYIRSP = *ZEROS                                        262691
     C                   EVAL      DDORLNOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDORLN'
     C                   EVAL      MsgIdXAr(Idx) = '5045664'
     C                   ENDIF
     C                   ENDIF                                                             AR1073112
     C                   ELSE                                                                 CLE134
     C                   IF        AYIBSR <> 0                                                CLE134
     C                   EVAL      DDORLNOK = 'N'                                             CLE134
     C                   EVAL      Idx += 1                                                   CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDORLN'                                  CLE134
     C                   EVAL      MsgIdXAr(Idx) = '5045689'                                  CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        AUCBRT = 0                                                 CLE134
     C                   IF        AUCBSR <> 0                                             AR1075853
     C                   EVAL      @KEY1 = DDCCY
     C                   MOVE      AUCBSR        @KEY2
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                             AND AUCBSR <> *ZEROS                                       262691
     C                             OR  AUCBSR = *ZEROS                                        262691
     C                             AND AUCRSP = *ZEROS                                        262691
     C                   EVAL      DDFECUOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFECU'
     C                   EVAL      MsgIdXAr(Idx) = '5045789'
     C                   ENDIF
     C                   ELSE                                                                 CLE134
     C                   IF        AUCBSR <> 0                                                CLE134
     C                   EVAL      DDFECUOK = 'N'                                             CLE134
     C                   EVAL      Idx += 1                                                   CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDFECU'                                  CLE134
     C                   EVAL      MsgIdXAr(Idx) = '5045790'                                  CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                             AR1075853
     C                   ENDIF                                                                CLE134
      *
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
     C                   PARM                    TrnDets
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    RecordType
      *
      ** OUTPUTS
      *
     C                   PARM                    ValidPDCL
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK values
      *
     C                   PARM                    OKTrnDets
      *
      ** Program, module and procedure names for DB Error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
