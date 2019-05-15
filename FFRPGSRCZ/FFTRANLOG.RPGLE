     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Trades support log setup module')             *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options Module                 *
      *                                                               *
      *  FFTRANLOG - Trades Support Log Setup Module                  *
      *                                                               *
      *  Function:  This module will convert fields of FF Trades and  *
      *             Settlement Details file into screen format to be  *
      *             used in writing records to the log file.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 14Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global processing.                                  *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    71         Chain to TRANS and INTYP                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *pssr - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *  Called by: FFSETLUPD module                                  *
      *                                                               *
      *  Calls:     FFEXTRCVT module                                  *
      *             FFOTCCCVT module                                  *
      *             FFSETLCVT module                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction details
     FTRANS2    IF   E           K DISK    PREFIX(T)
 
      ** Instrument details
     FINTYP     IF   E           K DISK    PREFIX(O)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Transaction Details:
      ** ~~~~~~~~~~~ ~~~~~~~~
 
      ** Trade Details in File Format
     D TRANFilFmt    E DS                  EXTNAME(TRANSD) PREFIX(T)
 
      ** Market Trade Details in Screen Format
     D EXTRScnFmt    E DS                  EXTNAME(FFEXTRPD) PREFIX(EX)
 
      ** OTC Trade Details in Screen Format
     D OTCCScnFmt    E DS                  EXTNAME(FFOTCCPD) PREFIX(OT)
 
      ** OTCO Trade Details in Screen Format                                                  CAP166
     D OTCOScnFmt    E DS                  EXTNAME(FFOTCOPD) PREFIX(ON)                       CAP166
                                                                                              CAP166
      ** Settlement Details:
      ** ~~~~~~~~~~ ~~~~~~~~
 
      ** Settlement Details in File Format
     D SETLFilFmt    E DS                  EXTNAME(TRSETD)
 
      ** Broker settlement details in screen format
     D BSETScnFmt    E DS                  EXTNAME(FFBSETPD)
 
      ** Customer settlement details in screen format
     D CSETScnFmt    E DS                  EXTNAME(FFCSETPD)
 
      ** Extension Details:
      ** ~~~~~~~~~ ~~~~~~~~
 
      ** FF Extension data (Exchange Traded)
     D EXTRExtDta    E DS                  EXTNAME(FFETEXPD) PREFIX(EX)
 
      ** FF Extension data (OTC Trade)
     D OTCCExtDta    E DS                  EXTNAME(FFOTEXPD) PREFIX(OT)
 
      ** Instrument Details:
      ** ~~~~~~~~~~ ~~~~~~~
 
      ** Instrument details in File format
     D INSTFilFmt    E DS                  EXTNAME(INTYPD) PREFIX(O)
 
      ** Standing Data files
      ** ~~~~~~~~ ~~~~ ~~~~~
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Portfolio Management ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCA_ZONE     E                     EXTFLD(ZONE)                                       CGP001
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define variable for switchable CFF001.
     D CFF001          S              1A   INZ(*BLANKS)
 
      ** Define variable for switchable CFF007.
     D CFF007          S              1
 
      ** Define parameter to be passed to APLOGTRAN.
     D TRANSDTL        S           5800A
 
      ** Parameter for premium
     D PPrem           S             15A   INZ(*BLANKS)
 
      ** Transaction status parameter
     D PSTS            S             24A
 
      ** Customer/Broker Flag
     D PFLAG           S              1A
 
      ** Alpha version of transaction reference
     D WTNBR           S              6A
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** Action Code
     D PACTN           S              1A
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Access the transaction details
     C     TNBR          CHAIN     TRANS2                             71
 
      ** If transaction reference does not exist in TRANSD, perform
      ** DBerror processing.
     C     *IN71         IFEQ      '1'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'TRANS'
     C                   MOVEL     TNBR          WTNBR
     C                   EVAL      DBKEY = WTNBR
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *pssr
 
     C                   ENDIF
 
      ** Access instrument details to get instrument currency
     C     TISTT         CHAIN     INTYP                              71
 
      ** If instrument type does not exist in INTYPD, perform
      ** DBerror processing.
     C     *IN71         IFEQ      '1'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'INTYP'
     C                   EVAL      DBKEY = TISTT
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *pssr
 
     C                   ENDIF
 
      ** Determine if the trade was a market or an OTC trade.
     C                   IF        TMTHN = 0
                                                                                              CAP166
     C                   IF        OISPT = 5                                                  CAP166
     C                   EXSR      SROTCTrade
     C                   ELSE                                                                 CAP166
     C                   EXSR      SROTCOTrade                                                CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
     C                   ELSE
     C                   EXSR      SRMKTTrade
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMKTTrade - Process exchange traded Futures & options       *
      *            transactions.                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: FFEXTRCVT - Exchange traded convert to screen format  *
      *         FFSETLCVT - Settlement convert functions              *
      *                                                               *
      *****************************************************************
 
     C     SRMKTTrade    BEGSR
 
      ** Store the value of Last Change type to SACTN field.
     C                   EVAL      EXSACTN = PACTN
 
      ** Call program to convert data from TRANSD to screen format.
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRCVT'
      ** Inputs
      ** ~~~~~~
     C                   PARM                    ReturnCode
      ** Transaction in file format
     C                   PARM                    TRANFilfmt
      ** ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      ** Outputs
      ** ~~~~~~~
      ** Transaction in screen format
     C                   PARM                    EXTRScnFmt
      ** Transaction Status
     C                   PARM                    PSTS
      ** CFF007 Enhancement
     C                   PARM                    CFF007
 
      ** If error occurred in the called module, stop processing and
      ** return an error code to the calling program. This applies to
      ** the rest of modules called in this program.
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Blank out Spot Price field if instrument is a Future.  This is
      ** to avoid error when trade is replayed in the main system.
     C                   IF        (OISPT < 4) OR (OISPT = 7)
     C                   EVAL      EXSSPTP = *BLANKS
     C                   ENDIF
 
      ** Call program to convert settlement details to screen format.
      ** Broker settlement instructions
     C                   EVAL      PFLAG = 'B'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    CSETScnFmt
      ** Broker settlement instructions, screen format
     C                   PARM                    BSETScnFmt
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    SETLFilFmt
      ** Customer/broker flag (1A)
     C                   PARM                    PFLAG
      ** Midas Transaction Number
     C                   PARM                    TNBR
      ** Instrument currency
     C                   PARM                    OISCY
 
      ** Check if error occurred.
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Customer settlement instructions
     C                   EVAL      PFLAG = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    CSETScnFmt
      ** Broker settlement instructions, screen format
     C                   PARM                    BSETScnFmt
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    SETLFilFmt
      ** Customer/broker flag (1A)
     C                   PARM                    PFLAG
      ** Midas Transaction Number
     C                   PARM                    TNBR
      ** Instrument currency
     C                   PARM                    OISCY
 
      ** Check if error occurred.
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Place the value of the outputted screen formats into one long
      ** data structure to be used by APLOGTRAN in writing to the
      ** standard log file.
     C                   EVAL      TRANSDTL = EXTRScnFmt + BSETScnFmt +
     C                             CSETScnFmt + EXTRExtDta
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROTCTrade - Process OTC option transactions.                *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: FFOTCCCVT - Currency OTC convert to screen format     *
      *         FFSETLCVT - Settlement convert functions              *
      *                                                               *
      *****************************************************************
 
     C     SROTCTrade    BEGSR
 
      ** Store the value of Last Change type to SACTN field.
     C                   EVAL      OTSACTN = PACTN
 
      ** Call program to convert data from TRANSD to screen format.
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCCVT'
      **
      ** Inputs
      ** ~~~~~~
     C                   PARM                    ReturnCode
      ** Transaction in file format
     C                   PARM                    TRANFilfmt
      ** Instrument types
     C                   PARM                    INSTFilFmt
      ** ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      **
      ** Outputs
      ** ~~~~~~~
      ** Transaction in screen format
     C                   PARM                    OTCCScnFmt
      ** Premium
     C                   PARM                    PPrem
      ** Transaction Status
     C                   PARM                    PSTS
      ** CFF001 Enhancement
     C                   PARM                    CFF001
      ** CFF007 Enhancement
     C                   PARM                    CFF007
 
      ** Check if error occurred.
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Call program to convert settlement details to screen format.
      ** Customer settlement instructions
     C                   EVAL      PFLAG = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      **
      ** Outputs
      ** ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    CSETScnFmt
      ** Broker settlement instructions, screen format
     C                   PARM      *BLANKS       BSETScnFmt
      **
      ** Inputs
      ** ~~~~~~
      ** Settlements in file format
     C                   PARM                    SETLFilFmt
      ** Customer/broker flag (1A)
     C                   PARM                    PFLAG
      ** Midas Transaction Number
     C                   PARM                    TNBR
      ** Instrument currency
     C                   PARM                    OISCY
 
      ** Check if error occurred.
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Place the value of the outputted screen formats into one long
      ** data structure to be used by APLOGTRAN in writing to the
      ** standard log file.
     C                   EVAL      TRANSDTL = OTCCScnFmt + CSETScnFmt +
     C                             OTCCExtDta
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAP166
      *****************************************************************                       CAP166
      *                                                               *                       CAP166
      *  SROTCOTrade - Process OTCO option transactions.              *                       CAP166
      *                                                               *                       CAP166
      *  Called by: Main                                              *                       CAP166
      *                                                               *                       CAP166
      *  Calls: FFOTCOCVT - Non-currency OTC convert to screen format *                       CAP166
      *         FFSETLCVT - Settlement convert functions              *                       CAP166
      *                                                               *                       CAP166
      *****************************************************************                       CAP166
                                                                                              CAP166
     C     SROTCOTrade   BEGSR                                                                CAP166
                                                                                              CAP166
      ** Store the value of Last Change type to SACTN field.                                  CAP166
     C                   EVAL      ONNACTN = PACTN                                            CAP166
                                                                                              CAP166
      ** Call program to convert data from TRANSD to screen format.                           CAP166
                                                                                              CAP166
     C                   CALLB     'FFOTCOCVT'                                                CAP166
                                                                                              CAP166
      ** Return Code                                                                          CAP166
                                                                                              CAP166
     C                   PARM      *BLANKS       ReturnCode                                   CAP166
                                                                                              CAP166
      ** Input Parameter                                                                      CAP166
      ** ---------------                                                                      CAP166
                                                                                              CAP166
      ** Old transaction in file format                                                       CAP166
      ** Instrument types                                                                     CAP166
                                                                                              CAP166
     C                   PARM                    TRANFilfmt                                   CAP166
     C                   PARM                    INSTFilFmt                                   CAP166
                                                                                              CAP166
      ** Standing Data                                                                        CAP166
      ** -------------                                                                        CAP166
                                                                                              CAP166
     C                   PARM                    SDBANK                                       CAP166
     C                   PARM                    SDDEAL                                       CAP166
     C                   PARM                    SDMMOD                                       CAP166
     C                   PARM                    SDPORT                                       CAP166
                                                                                              CAP166
      ** CFF001 and CFF007 enhancements                                                       CAP166
                                                                                              CAP166
     C                   PARM                    CFF001                                       CAP166
     C                   PARM                    CFF007                                       CAP166
                                                                                              CAP166
      ** Output Parameters                                                                    CAP166
      ** -----------------                                                                    CAP166
                                                                                              CAP166
      ** Old transaction in screen format                                                     CAP166
                                                                                              CAP166
     C                   PARM                    OTCOScnFmt                                   CAP166
                                                                                              CAP166
      ** Premium                                                                              CAP166
      ** Transaction Status                                                                   CAP166
                                                                                              CAP166
     C                   PARM                    PPrem                                        CAP166
     C                   PARM                    PSTS                                         CAP166
                                                                                              CAP166
      ** Check if error occurred.                                                             CAP166
                                                                                              CAP166
     C                   IF        ReturnCode <> *BLANKS                                      CAP166
     C                   EXSR      *PSSR                                                      CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** Call program to convert settlement details to screen format.                         CAP166
      ** Customer settlement instructions                                                     CAP166
                                                                                              CAP166
     C                   EVAL      PFLAG = 'C'                                                CAP166
     C                   CALLB     'FFSETLCVT'                                                CAP166
                                                                                              CAP166
      ** Outputs                                                                              CAP166
      ** ~~~~~~~                                                                              CAP166
      ** Return code (10A, returned to caller)                                                CAP166
                                                                                              CAP166
     C                   PARM      *BLANKS       ReturnCode                                   CAP166
                                                                                              CAP166
      ** Customer settlement instructions, screen format                                      CAP166
      ** Broker settlement instructions, screen format                                        CAP166
                                                                                              CAP166
     C                   PARM                    CSETScnFmt                                   CAP166
     C                   PARM      *BLANKS       BSETScnFmt                                   CAP166
                                                                                              CAP166
      ** Inputs                                                                               CAP166
      ** ~~~~~~                                                                               CAP166
      ** Settlements in file format                                                           CAP166
                                                                                              CAP166
     C                   PARM                    SETLFilFmt                                   CAP166
                                                                                              CAP166
      ** Customer/broker flag (1A)                                                            CAP166
                                                                                              CAP166
     C                   PARM                    PFLAG                                        CAP166
                                                                                              CAP166
      ** Midas Transaction Number                                                             CAP166
                                                                                              CAP166
     C                   PARM                    TNBR                                         CAP166
                                                                                              CAP166
      ** Instrument currency                                                                  CAP166
                                                                                              CAP166
     C                   PARM                    OISCY                                        CAP166
                                                                                              CAP166
      ** Check if error occurred.                                                             CAP166
                                                                                              CAP166
     C                   IF        ReturnCode <> *BLANKS                                      CAP166
     C                   EXSR      *pssr                                                      CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** Place the value of the outputted screen formats into one long                        CAP166
      ** data structure to be used by APLOGTRAN in writing to the                             CAP166
      ** standard log file.                                                                   CAP166
                                                                                              CAP166
     C                   EVAL      TRANSDTL = OTCOScnFmt + CSETScnFmt +                       CAP166
     C                             OTCCExtDta                                                 CAP166
                                                                                              CAP166
     C                   ENDSR                                                                CAP166
                                                                                              CAP166
      *****************************************************************                       CAP166
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: AOBANKR0 - Bank details                               *
      *         AOMMODR0 - Modules switched on                        *
      *         AODEALR0 - Dealing ICD                                *
      *         AOPORTR0 - Portfolio mgmt ICD                         *
      *         AOSARDR0 - Switchable Features details                *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
 
      ** Action Coce
     C                   PARM                    PACTN
 
      ** The format containing the sett details
     C                   PARM                    SETLFilFmt
 
      ** Passed from calling program to indicate if CFF007 is on.
     C                   PARM                    CFF007
 
      ** To be returned to calling program. This holds the converted
      ** trade and settlement details in screen format.
     C                   PARM                    TRANSDTL
 
      **
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Since we avoid issuing a rollback operation in this program
      ** we have to handle DBerror manually and not within the
      ** Access Object programs because it calls DBERRCTL w/c performs
      ** the rollback.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 1
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** If error occurred
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 2
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Access Dealing ICD
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** If error occurred
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDDEALPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 3
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDPORT        PARM      SDPORT        DSFDY
 
      ** If error occurred
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDPORTPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 4
     C                   EXSR      *pssr
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CFF001 is on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFF001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CFF001'
     C                   EVAL      DBase = 5
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANK
     C                   EVAL      CFF001 = 'Y'
     C                   ELSE
     C                   EVAL      CFF001 = 'N'
     C                   ENDIF
 
      ** Initialise Transaction Detail and Instrument detail fields
      ** as well as Extension data fields
     C                   CLEAR                   TRANSDTL
     C                   CLEAR                   INSTFilFmt
     C                   CLEAR                   EXTRExtDta
     C                   CLEAR                   OTCCExtDta
 
      **--------------------------------------------------------------+
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------+
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, use copy source PSSR_ILENE so that DBERRCTL will
      ** not be called since the caller will be the one to handle
      ** rollback processing.
     C/COPY ZACPYSRC,PSSR_ILENE
 
      ** Set the return code to indicate to the caller that an
      ** error occurred; do NOT call DBERRCTL, as the caller will
      ** handle rollback processing.
     C                   EVAL      ReturnCode = 'Error'
     C                   RETURN
 
     C                   ENDSR
      **--------------------------------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
