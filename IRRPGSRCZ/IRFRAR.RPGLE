     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Fwd Rate Agreement Retrieve a record')           *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRFRAR    - Fwd Rate Agreement retrieve a record             *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD044506           Date 28Mar17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD029818           Date 03Dec14               *
      *                 CSW214             Date 03Dec14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW213             Date 03Jun13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18389           Date 08May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 235729             Date 29Jul05               *
      *                 BUG5871            Date 20May05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6512            Date 28Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG4469            Date 06Oct04               *
      *                 BUG2959            Date 07Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA011 (Reopen)    Date 02Apr04               *
      *                 TDA011             Date 31Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 20Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044506 - MT300 98D trade execution date can not be before  *
      *             value date.                                       *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD029818 - Deal Authorization status of FRA transaction is   *
      *             not updated when amended                          *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG18389- Incorrect timestamp when Amending/Authorising a    *
      *            record.  Apply GEMS fix 247343                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  235729 - Decimal data error FRTMESTMP not set up             *
      *           A default timestamp string is required              *
      *  BUG5871 - Send deal status to MidasPlus                      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6512 - Retrieve TRAM details                              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  BUG2959 - Settlement Confirmation Fields not being shown.    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA011 (Reopen) - Rate Fix Ccy writes to the wrong field     *
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - Synchronous calling of APIs                         *
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

     D FRAScnFmt     E DS                  EXTNAME(IRFRAPD)
      * Deal in screen format

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
      *                                                                                      BUG6377
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG6377
      ** External DS for Bank Details                                                        BUG6377
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 BUG6377

      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------

     D FRAFilFmt     E DS                  EXTNAME(IRVFRAPD)
     D  FRREC                716    784
     D**FRPAY***             785   1343                                                      BUG2959
     D  FRPAY                785   1344                                                      BUG2959
     D  FRCNF               1345   1992                                                      BUG2959
      ** Deal in file format

     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC***               1     69                                                       TDA011
     D  FLREC                  1     75                                                       TDA011
      * Receive settlement instructions in file format

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY***               1    559                                                       TDA011
     D  FLPAY                  1    565                                                       TDA011
      * Pay settlement instructions in file format

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
     D  FLCNF                  1    650                                                      BUG2959
      * FRA/IRS settlement instructions in file format

     ** FRA/IRS Interface Non-Screen Data                                                     CSW213
     D InfData       E DS                  EXTNAME(IRFRIFPD)                                  CSW213
                                                                                              CSW213
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D PDlRILkpd     E DS                  EXTNAME(DLRILKPD)                                  CSW213
                                                                                              CSW213
      ** Define data structure for InSwift2013                                                CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
      **-----------------------------------------------------------------------

      ***Array*containing Timestamp initial value                                    235729 BUG18389
     D*STAMP****       S             26    DIM(1) CTDATA PERRCD(1)                   235729 BUG18389
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

     D ZDATE           S              6  0                                                   BUG6377
     D ZDAYNO          S              5P 0                                                   BUG6377
     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
                                                                                              CSW213
      ** Work Variables for DLRPIFR                                                           CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
                                                                                              CSW213
     D PRtCd           S              7                                                       CSW213
     D CSW213          S              1                                                       CSW213
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+

     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_IN         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   CLEAR                   PDlRILkpd                                    CSW213

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,IRFRAM01
      ** Access Bank Details                                                                 BUG6377
                                                                                             BUG6377
     C                   CALLB     'AOBANKR0'                                                BUG6377
     C                   PARM      *BLANKS       ReturnCode                                  BUG6377
     C                   PARM      '*FIRST '     POptn             7                         BUG6377
     C     SDBANK        PARM      SDBANK        DSFDY                                       BUG6377
                                                                                             BUG6377
     C                   IF        ReturnCode <> *BLANK                                      BUG6377
     C     *LOCK         IN        LDA                                                       BUG6377
     C                   EVAL      DBFILE = 'SDBANKPD'                                       BUG6377
     C                   EVAL      DBASE  = 2                                                BUG6377
     C                   EVAL      DBKEY  = POptn                                            BUG6377
     C                   OUT       LDA                                                       BUG6377
     C                   EXSR      *PSSR                                                     BUG6377
     C                   ENDIF                                                               BUG6377
      *                                                                                      BUG6377
      *
      ***  Determine if FRA/IRS Deals Authorisation feature is
      ***  installed
      *
     C                   MOVE      'N'           CIR008            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR008'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR008
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CIR008
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 005 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRtCd                                        CSW213
      *                                                                                       CSW213
     C                   IF        PRtCd = 'CSW2013'                                          CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213

      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   FRAFilFmt
     C     SACCD         IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           SACCD
     C                   ELSE
     C                   MOVEL     'E'           SACCD
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
     C                   EXSR      IRFRARED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED            6
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If Fwd Rate Agreement read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @DLRED        SDLNO
     C                   EXSR      IRFRARTV
      *
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
                                                                                             BUG6512
      * Convert to screen format
     C     Idx           IFEQ      0
     C                   EXSR      IRFRACVT
     C                   EXSR      ZASETINCVT
      * Calculated Our/Their interest fix dates                                              BUG6377
     C                   EXSR      SrINFDCVT                                                 BUG6377
     C                   ENDIF

     C                   ENDIF

     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'SDLNO'       FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
                                                                                              CSW213
      ** FRA/IRS Interface Non-Screen Data                                                    CSW213
     C**********         EVAL      InfData = FRAUTH                                  CSW213 MD029818
      *                                                                                       CSW213
      ** Setup fields in link file if CSW213 is on.                                           CSW213
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SRGetRPIF                                                  CSW213
     C                   EVAL      DLRPIFS1In = DLRPIFScn1Fmt                                 CSW213
     C                   EVAL      DLRPIFS2In = DLRPIFScn2Fmt                                 CSW213
     C                   EVAL      DLRPIFS3In = DLRPIFScn3Fmt                                 CSW213
     C                   EVAL      DLRPIFS4In = DLRPIFScn4Fmt                                 CSW214
     C                   ENDIF                                                                CSW213

      * Build buffer with required output
     C**********         EVAL                    Buffer = FRAScnfmt                          BUG2959
     C**********                                 + ##RECS  + ##PAYS                          BUG2959
     C*******************MOVE      FRTMESTMP     @TimeStamp       26                  BUG4469 235729
     C**********         MOVEA     STAMP(1)      @TimeStamp       26                 235729 BUG18389
     C                   MOVE      FRTMESTMP     @TimeStamp       26                        BUG18389
     C                   Z-ADD     FRTNLU        WnTNLU            5 0                       BUG4469
     C                   MOVE      WnTNLU        @TNLU             5                         BUG4469
     C                   EVAL                    Buffer = FRAScnfmt                          BUG2959
     C                                           + CPST     + DSPCP                          BUG6512
     C                                           + BKST     + DSPBK                          BUG6512
     C                                           + @TimeStamp + @TNLU                        BUG4469
     C                                           + SUINFD + STINFD                           BUG6377
     C                                           + DDSTS                                     BUG5871
     C                                           + ##RECS  + ##PAYS                          BUG2959
     C                                           + ##FRIS                                    BUG2959
     C                                           + InfData                                    CSW213
     C                                           + InSwift2013                                CSW213

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     IRFRARED      BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'IRFRARED'
      *
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeOut

      * Action code
     C                   PARM                    SACCD             1

      * Deal number
     C                   PARM      DDDLNO_In     SDLNO             6

      * Read forwards
     C                   PARM                    @RDFWD            1

      * Read backwards
     C                   PARM                    @RDBCK            1

      ** Switchable feature CIR008
     C                   PARM                    CIR008
      *
      * Outputs
      *
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7

      * Deal number read
     C                   PARM      *BLANK        @DLNOR            6

     C                   ENDSR
      **********************************************************************
     C     IRFRARTV      BEGSR

     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'IRFRARTV'

      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      * Action Code
     C                   PARM                    SACCD             1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      * (Midas) Deal Number
     C                   PARM                    SDLNO             6
      * (Midas) Associated Deal Number
     C                   PARM                    SLNKDN            6
      * Booking branch
     C                   PARM                    SBRCA             3
      *  Switchable feature CIR008
     C                   PARM                    CIR008

      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    FRAFilFmt
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

     C                   ENDSR
      **********************************************************************
     C     IRFRACVT      BEGSR

     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'IRFRACVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Deal in file format
     C                   PARM                    FRAFilFmt

      ** Switchable feature CIR008
     C                   PARM                    CIR008
      *
      * Output parameters
      *
      * Deal in screen format
     C                   PARM                    FRAScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24

     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up payment instructions from Forward Rate Agreement
     C**********         MOVEL     FRPAY         FLPAY                                        TDA011
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(FRPAY:1:2)                      TDA011
     C                   EVAL      %SUBST(FLPAY:3:18) = FRPONS                                TDA011
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(FRPAY:15:545)                TDA011
     C                   MOVEL     FRPOBR        FLPOBR
     C                   MOVEL     FRCVMR        FLCVMR
     C                   MOVEL     FRPSCY        FLPSCY
     C                   MOVEL     FRIC72        FLIC72
      *
      * Set up receive instructions from deal
     C**********         MOVEL     FRREC         FLREC                                        TDA011
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(FRREC:1:2)                      TDA011
     C                   EVAL      %SUBST(FLREC:3:18) = FRRONS                                TDA011
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(FRREC:15:55)                  TDA011
     C                   MOVEL     FRROBR        FLROBR
     C                   MOVEL     FRRSCY        FLRSCY
      *
     C                   MOVEL     FRCNF         FLCNF                                       BUG2959
     C                   MOVE      FRAGVC        FLAGVC                                      BUG2959
      *                                                                                      BUG2959
     C                   CALLB     'ZASETINCVT'
      *
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    ##PAYF
      *
      ** File receipt settlement instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS settlement instruction
     C**********         PARM      *BLANK        ##FRIF                                      BUG2959
     C                   PARM                    ##FRIF                                      BUG2959
      *
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen receipt settlement instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS settlement instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************                      BUG6377
      /EJECT                                                                                 BUG6377
      *****************************************************************                      BUG6377
      *  SrINFDCVT  - Conversion of calculated interest fix dates     *                      BUG6377
      *****************************************************************                      BUG6377
     C     SrINFDCVT     BEGSR                                                               BUG6377
                                                                                             BUG6377
     C     FRUINFD       IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  FRUINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE            7                         BUG6377
     C                   MOVEL     ZDATE         SUINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C     FRTINFD       IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  FRTINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE                                      BUG6377
     C                   MOVEL     ZDATE         STINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C                   ENDSR                                                               BUG6377
      *****************************************************************                      BUG6377
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
     C                   PARM                    SACCD             1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    SDLNO             6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    BRKC              4                         BUG6512
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
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      * SRGetRPIF - Set-up Midas DL Transaction Reporting Information *                       CSW213
      *             Link File.                                        *                       CSW213
      *****************************************************************                       CSW213
     C     SRGetRPIF     BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   EVAL      PModeOp = ModeofOp                                         CSW213
     C                   EVAL      RLAPID = 'FRA '                                            CSW213
                                                                                              CSW213
     C                   IF        SACCD = 'R'                                                CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = SACCD                                             CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLBRCA = SBRCA                                             CSW213
     C                   EVAL      RLTRRF = SDLNO                                             CSW213
     C                   EVAL      RLLTRF = SLNKDN                                            CSW213
     C                   EVAL      RLDTYP = SDTYP                                             CSW213
     C                   EVAL      RLDLST = SDLST                                             CSW213
      *                                                                                     MD044506
      ** Change RLVALD from Value Date to Deal Date                                         MD044506
      *                                                                                     MD044506
     C**********         EVAL      RLVALD = SVDAT                                    CSW213 MD044506
     C                   EVAL      RLVALD = SDDAT                                           MD044506
      *                                                                                     MD044506
     C                   EVAL      RLCNUM = SCNUM                                             CSW213
     C                   EVAL      RLBCCY = SUCUCY                                            CSW213
     C                   EVAL      RLSCCY = SUCUCY                                            CSW213
     C                   EVAL      RLFOID = FOTRID                                            CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFR'                                                  CSW213
                                                                                              CSW213
      ** Return code                                                                          CSW213
     C                   PARM      *BLANKS       PRetCode                                     CSW213
                                                                                              CSW213
      ** Mode of operation                                                                    CSW213
     C                   PARM                    PModeOp                                      CSW213
                                                                                              CSW213
      ** RPIF Set up fields                                                                   CSW213
     C                   PARM                    PDlRILkpd                                    CSW213
                                                                                              CSW213
      ** OUTPUTS                                                                              CSW213
      ** Transaction Reference OK Flag                                                        CSW213
     C                   PARM                    PTranRefOK                                   CSW213
                                                                                              CSW213
      ** Front Office ID OK Flag                                                              CSW213
     C                   PARM                    DFOfcrIDOK                                   CSW213
                                                                                              CSW213
      ** No Report Information flag                                                           CSW213
     C                   PARM                    WNoRepFlag                                   CSW213
                                                                                              CSW213
      ** DLRPIF in File Format                                                                CSW213
     C                   PARM                    DLRPIFFileFmt                                CSW213
                                                                                              CSW213
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW213
     C                   PARM                    FldNameArr                                   CSW213
     C                   PARM                    MsgIdArr                                     CSW213
     C                   PARM                    MsgDtaArr                                    CSW213
                                                                                              CSW213
      ** Array index (3P0) from/to caller                                                     CSW213
     C                   PARM                    Idx                                          CSW213
                                                                                              CSW213
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CSW213
     C                   PARM                    WFldNamArr                                   CSW213
     C                   PARM                    WMsgIdArr                                    CSW213
     C                   PARM                    WMsgDtaArr                                   CSW213
                                                                                              CSW213
      ** Warning array index (3P0) from/to caller                                             CSW213
     C                   PARM                    WIdx                                         CSW213
                                                                                              CSW213
      ** Report Information File - Screen Format                                              CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT                                                                                 BUG6377
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
