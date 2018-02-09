     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-Traded Transactions retrieve rec')   *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options module                           *
      *                                                               *
      *  FFEXTRR   - FF Exchange-Traded Transaction retrieve a record *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26944           Date 28Jan10               *
      *                 BUG26906           Date 21Jan10               *
      *                 CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 23Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  BUG26944 - Field values on the Extension tab of EXTR         *
      *             transaction were intermittently displayed as      *
      *             <BLANKS>                                          *
      *  BUG26906 - Values for Broker and Customer tabs were reset    *
      *             to blanks                                         *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFTRX2L0  IF   E           K DISK    USROPN                                             CAP191
     F                                     RENAME(TRANSDD6:RTVIDX)                            CAP191
                                                                                              CAP191
      * Exchange-traded transactions file                                                     CAP191
     FFFEXTRL0  IF   E           K DISK    INFSR(*PSSR) PREFIX(F1)                            CAP191
     F                                     RENAME(TRANSDF:TRANSINF)                           CAP191
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
 
     D EXTRScnFmt    E DS                  EXTNAME(FFEXTRPD)
      * Deal in screen format
 
     D CustSetScnFmt E DS                  EXTNAME(FFCSETPD)
      * Customer Settlements in screen format
 
     D BrokSetScnFmt E DS                  EXTNAME(FFBSETPD)
      * Broker Settlements in screen format
 
     D ExtData       E DS                  EXTNAME(FFETEXPD)                                  CAP191
      * Exchange-traded trd extra data layout                                                 CAP191
                                                                                              CAP191
     D RegData       E DS                  EXTNAME(FFETRXPD)                                  CAP191
      * Exchange-traded reg extra data layout                                                 CAP191
                                                                                              CAP191
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D EXTRFilFmt    E DS                  EXTNAME(TRANSD)
      * Deal in file format
 
     D SetlFilFmt    E DS                  EXTNAME(TRSETD) PREFIX(S_)
      * Settlements in file format
 
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(I_)
      * Instrument types
 
      **-----------------------------------------------------------------------
      * Standing Data files
      **-----------------------------------------------------------------------
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  DEALACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features Details
     D  SLCD         E                     EXTFLD(LCD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
 
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Market centre
     D @Market         S              2A
 
      **                                                                                      CAP191
     D @TimeStamp      S             26A                                                      CAP191
     D AAuth           S              1A                                                      CAP191
     D PFRNT           S             20A                                                      CAP191
     D PAFRT           S             20A                                                      CAP191
     D KTNBR           S              6S 0                                                    CAP191
                                                                                              CAP191
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDTRNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,FFEXTR02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   EXTRFilFmt
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
     C                   EXSR      FFEXTRRED
     C                   ELSE
 
      * MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDTRNO_In     @DLRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
 
      * If transaction read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED <> *Blank
 
      * Retrieve transaction details (all key fields required for call to rtv module)
     C                   MOVEL     @DLRED        DDDLNO
     C                   MOVEL     @DLRED        KTNBR
     C     KTNBR         CHAIN     FFEXTRL0                                                   CAP191
     C                   IF        %FOUND                                                     CAP191
     C                   EVAL      @Market = %SUBST(F1ISTT : 1 : 2)                           CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   EXSR      FFEXTRRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FFEXTRCVT
     C                   EXSR      ZASETINCVT                                               BUG26906
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
                                                                                            BUG26944
     C                   OPEN      FFTRX2L0                                                 BUG26944
     C                   MOVEL     DDTRNO_In     XSTNBR            6 0                      BUG26944
     C     XSTNBR        CHAIN     RTVIDX                                                   BUG26944
     C                   CLOSE     FFTRX2L0                                                 BUG26944
     C                   IF        %Found(FFTRX2L0)                                         BUG26944
     C                   MOVEL     FFTIME        RegData                                    BUG26944
     C                   MOVE      FFCABR        RegData                                    BUG26944
     C                   ENDIF                                                              BUG26944
                                                                                            BUG26944
 
      * Build buffer with required output
     C                   MOVE      TMST          @TimeStamp                                   CAP191
     C**********         EVAL                    Buffer = EXTRScnFmt +                        CAP191
     C**********                                 CustSetScnFmt + BrokSetScnFmt                CAP191
     C**********         EVAL      Buffer = EXTRScnFmt + CustSetScnFmt +             CAP191 BUG26906
     C**********                   BrokSetScnFmt + @TimeStamp + AAuth +              CAP191 BUG26906
     C                   EVAL      Buffer = EXTRScnFmt + BrokSetScnFmt +                    BUG26906
     C                             CustSetScnFmt + @TimeStamp + AAuth +                     BUG26906
     C                             RegData + ExtData + PFRNT + PAFRT                          CAP191
 
     C                   SETON                                        LR
     C                   RETURN
 
      **********************************************************************
 
     C     FFEXTRRED     BEGSR
 
     C                   RESET                   RetCodeOut
 
     C                   CALLB     'FFEXTRRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
 
      * Transaction number
     C                   PARM      DDTRNO_In     DDDLNO            6
 
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
 
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
 
      * OUTPUT PARAMETERS
 
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
 
      * Transaction number read
     C                   PARM      *BLANK        @DLRED            6
 
      * Market centre of transaction
     C                   PARM                    @Market
 
     C                   ENDSR
 
      **********************************************************************
 
     C     FFEXTRRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FFEXTRRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Front Office Transaction ID (20A)
     C                   PARM                    FOTRID           20
 
      * Transaction number
     C                   PARM                    DDDLNO
      * (Midas) Market
     C                   PARM                    @Market
      ** Module being called as linked enquiry
     C                   PARM      'N'           LnkEnq            1
      * Standing Data and multi-branching indicator
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    BGMBIN
 
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    EXTRFilFmt
      * Settlements in file format
     C                   PARM                    SetlFilFmt
      * Instrument types
     C                   PARM                    InstTypes
      * OK - Action code
     C                   PARM                    DDActnOK          1
      * OK - Transaction number
     C                   PARM                    DDDlnoOK          1
      * OK - Market
     C                   PARM                    MrktOK            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
 
      **********************************************************************
 
     C     FFEXTRCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FFEXTRCVT'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * Transaction in file format
     C                   PARM                    EXTRFilFmt
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      * OUTPUTS
      * Transaction in screen format
     C                   PARM                    EXTRScnfmt
      * Transaction Status
     C                   PARM                    FFSTS            24
      * CFF007 Enhancement (passed TO the called procedure, despite its position
      * in the paramater list)
     C                   PARM                    CFF007
 
      ** Front Office Transaction ID                                                          CAP191
      ** Associated Front Office Transaction ID                                               CAP191
     C                   PARM                    PFRNT                                        CAP191
     C                   PARM                    PAFRT                                        CAP191
                                                                                              CAP191
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
 
      * We need both customer and broker settlements, so we're going to
      * have to call the converter twice (stupid design, but hey, it was mine)
     C                   EVAL      CustBrokFl = 'C'
 
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * Return code
     C                   PARM      *BLANKS       RetCodeOut
      ** Customer settlement instructions, screen format
     C                   PARM                    CustSetScnFmt
      ** Broker settlement instructions, screen format
     C                   PARM                    BrokSetScnFmt
      * Inputs
      * Settlements in file format
     C                   PARM                    SetlFilFmt
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl        1
      ** Midas Transaction Number
     C                   PARM                    DDTRNO_In
      ** Instrument currency
     C                   PARM                    ISCY
 
     C                   EVAL      CustBrokFl = 'B'
 
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * Return code
     C                   PARM      *BLANKS       RetCodeOut
      ** Customer settlement instructions, screen format
     C                   PARM                    CustSetScnFmt
      ** Broker settlement instructions, screen format
     C                   PARM                    BrokSetScnFmt
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    SetlFilFmt
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    DDTRNO_In
      ** Instrument currency
     C                   PARM                    ISCY
 
     C                   ENDSR
 
      **-----------------------------------------------------------------------
      * *INZSR
      **-----------------------------------------------------------------------
 
     C     *INZSR        BEGSR
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Access Dealing ICD
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      * Determine whether CFF007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFF007            1
     C                   ELSE
     C                   MOVE      'N'           CFF007
     C                   ENDIF
 
     C                   MOVEL     'N'           ULX604            1                          CAP191
                                                                                              CAP191
      ** Determine if ULX604 is installed                                                     CAP191
                                                                                              CAP191
     C                   CALLB     'AOSARDR0'                                                 CAP191
     C                   PARM      *BLANKS       @RTCD                                        CAP191
     C                   PARM      '*VERIFY'     @OPTN                                        CAP191
     C                   PARM      'ULX604'      @SARD                                        CAP191
     C                   PARM      SCSARD        DSFDY                                        CAP191
                                                                                              CAP191
     C                   IF        @RTCD <> *Blanks and @RTCD <> '*NRF'                       CAP191
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP191
     C                   EVAL      DBKEY  = 'ULX604'                                          CAP191
     C                   EVAL      DBASE  = 6                                                 CAP191
     C                   EXSR      *PSSR                                                      CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   IF        @RTCD = *Blanks                                            CAP191
     C                   EVAL      ULX604 = 'Y'                                               CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C**********         OPEN      FFTRX2L0                                          CAP191 BUG26944
     C**********         MOVEL     DDTRNO_In     XSTNBR            6 0               CAP191 BUG26944
     C*****XSTNBR        CHAIN     RTVIDX                                            CAP191 BUG26944
     C**********         CLOSE     FFTRX2L0                                          CAP191 BUG26944
     C**********         IF        %Found(FFTRX2L0)                                  CAP191 BUG26944
     C**********         MOVEL     FFTIME        RegData                             CAP191 BUG26944
     C**********         MOVE      FFCABR        RegData                             CAP191 BUG26944
     C**********         ENDIF                                                       CAP191 BUG26944
                                                                                              CAP191
     C                   ENDSR
 
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
