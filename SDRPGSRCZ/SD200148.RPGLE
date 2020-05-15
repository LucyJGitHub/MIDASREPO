     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network description - details 8 validatn')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200148 - Midas SD Network Description Maintenance    *
      *                   (Details 8 Screen Validation - Multicash)   *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of eighth screen of fields of a Network record.   *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. EML104             Date 05Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL152             Date 02Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *           Add EML104_029, EML104_030, EML104_031, EML104_032  *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950 (Recompile)                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  Error Indicators                                             *
      *                                                               *
      *    40         General Error Indicator                         *
      *    41         GVC Default Value - Debit                       *
      *    42         GVC Default Value - Credit                      *
      *    43         Field Separator                                 *
      *    44         Fixed Transaction Ref No.                       *
      *                                                               *
      *  (The DS IN40_TO_70 is used to cover the whole set of         *
      *  reserved error indicators)                                   *
      *                                                               *
      *  Database Error Indicators                                    *
      *                                                               *
      *    U7         Abnormal Completion                             *
      *    U8         File Out of Balance                             *
      *    U7 + U8    Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRZaSndMsg - Send Message to Program Message Queue           *
      *  SRExitMod - Exit from the Module                             *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR - Program exception error routine                      *
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
      ** Midas SD Network Transaction file
      *
     FSDNTCDL0  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** New Network File Record (i.e. new state after amendments)
      *
     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      *
     D ScrLayout     E DS                  EXTNAME(SD200128DF:SD200128F8)
      *
      ** Error Indicators Array
      *
     D IN40_TO_70      S              1A   DIM(31)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRetCodeOut     S             10A
     D PActCode        S              1A
     D PCallerIn       S             10A
     D PZaPgm          S             10A
     D PZaMsgF         S             10A
     D PZaPgrl         S              5A
     D PZaMsId         S              7A
     D PZaMsda         S            132A
     D PZaMstp         S              7A
      *
     D KNwrk           S              6A
     D KTrCd           S             10A
      *
     D WCpy            S             80A
     D WaPgm           S             10A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      **  Details 8 Validation
      *
      ** GVC default value - Debit Field is Mandatory
      *
     C                   IF        D8GVCD = *BLANKS
     C                   EVAL      PZaMsId = 'USR3970'
     C                   EVAL      *IN41 = *ON
      *
     C                   ELSE
     C                   EVAL      KNwrk = EDNWRK
     C                   EVAL      KTrCd = D8GVCD
     C     KNtCd         CHAIN     SDNTCDL0
     C                   IF        NOT %FOUND (SDNTCDL0)
     C                   EVAL      PZaMsId = 'USR5313'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was Found
      *
     C                   IF        *IN41 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** GVC default value - Credit Field is Mandatory
      *
     C                   IF        D8GVCC = *BLANKS
     C                   EVAL      PZaMsId = 'USR3970'
     C                   EVAL      *IN42 = *ON
      *
     C                   ELSE
     C                   EVAL      KNwrk = EDNWRK
     C                   EVAL      KTrCd = D8GVCC
     C     KNtCd         CHAIN     SDNTCDL0
     C                   IF        NOT %FOUND (SDNTCDL0)
     C                   EVAL      PZaMsId = 'USR5313'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was Found
      *
     C                   IF        *IN42 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Field Separator and Line separator cannot be same
      *
     C                   IF        D8FSEP = *BLANKS
     C                   EVAL      PZaMsId = 'USR3970'
     C                   EVAL      *IN43 = *ON
      *
     C                   ELSEIF    EDENRA = 'Y' AND
     C                             D8FSEP = EDLSEP
     C                   EVAL      PZaMsId = 'USR5314'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
      ** If an error was Found
      *
     C                   IF        *IN43 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Field Transaction Reference Number
      *
     C/COPY WNCPYSRC,EML104_029                                                               EML104
     C                   IF        D8FTRN = *BLANKS
     C/COPY WNCPYSRC,EML104_030                                                               EML104
     C                   EVAL      PZaMsId = 'USR3970'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
     C/COPY WNCPYSRC,EML104_031                                                               EML104
      *
      ** Exit from Module
      *
     C                   EXSR      SRExitMod
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZaSndMsg - Send Message to Program Message Queue           *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRZaSndMsg    BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgm
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaMsId
     C                   PARM                    PZaMsgf
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMstp
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExitMod - Exit from the Module                             *
      *                                                               *
      *  Called by : Main Processing,*PSSR                            *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRExitMod     BEGSR
      *
      ** Return the current values of the error indicators
      *
     C                   MOVEA     *IN(40)       IN40_TO_70

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeOut
     C                   PARM                    PCallerIn
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
      *
      ** Initialize Copyright Array
      *
     C                   MOVEA     CPY@          WCpy
      *
      ** If No named caller,setup WaPgm with the current program name
      *
     C                   IF        PCallerIn = *BLANKS
     C                   EVAL      WaPgm = PSProcPgm
     C                   ELSE
     C                   EVAL      WaPgm = PCallerIn
     C                   ENDIF
      *
     C                   EVAL      PZaMsgf = 'SDUSRMSG'
     C                   EVAL      PZaPgm = WaPgm
     C                   EVAL      PZaPgrl = '*SAME'
     C                   EVAL      PZaMsId = *BLANKS
     C                   EVAL      PZaMsda = *BLANKS
     C                   EVAL      PZaMstp = *BLANKS
      *
     C                   EVAL      PRetCodeOut = *BLANKS
      *
      ** Initialize error indicators with the values passed by the
      ** caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
      *
      ** Reset general error indicator
      *
     C                   EVAL      *IN40 = *OFF
      *
      ** KList for SDNTCDL0
      *
     C     KNtCd         KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KTrCd
      *
     C/COPY WNCPYSRC,EML104_032                                                               EML104
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by : (**calling routines**)                           *
      *                                                               *
      *  Calls : SRExitMod                                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   EVAL      PRetCodeOut = '*ERROR'
     C                   EXSR      SRExitMod
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
