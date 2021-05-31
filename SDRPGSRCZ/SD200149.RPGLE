     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network description - details 7 validatn')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200149 - Midas SD Network Description Maintenance    *
      *                   (Details 7 Screen Validation - Extended     *
      *                   Narrative)                                  *
      *                                                               *
      *  Function : This module handles the input and the validation  *
      *             of seventh screen of fields of a Network record.  *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26824           Date 09Dec09               *
      *                 BUG24305           Date 11Jun09               *
      *                 BUG23742           Date 19May09               *
      *                 BUG24111           Date 29May09               *
      *                 BUG24071           Date 28May09               *
      *                 BUG23994           Date 14May09               *
      *                 BUG23654           Date 01Apr09               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26824 - Max length validation error.                      *
      *  BUG24305 - REInputCycleRetailPrintAdv Schema Mismatch due to *
      *             Multicash Change Control                          *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  BUG24111 - NSTD format should only accept a maximun line     *
      *             length of 70                                      *
      *  BUG24071 - MT940 and MT942 not reflected in MMM              *
      *  BUG23994 - No validation for SWIFT network's field 86 format *
      *  BUG23654 - No. of lines validation error for UNSD3           *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  Error Indicators                                             *
      *                                                               *
      *    40         General Error Indicator                         *
      *    41         Field 86 Format                                 *
      *    42         Number of Lines                                 *
      *    43         Line Length                                     *
      *    44         Line Separator                                  *
      *    45         Wrap Text                                       *
      *    46         Truncate Lines                                  *
      *    47         Merge Lines                                     *
      *    48         Keep Lines Separator                            *
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
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
     D ScrLayout     E DS                  EXTNAME(SD200129DF:SD200129F7)
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
      *
     D PZaPgm          S             10A
     D PZaMsgF         S             10A
     D PZaPgrl         S              5A
     D PZaMsId         S              7A
     D PZaMsda         S            132A
     D PZaMstp         S              7A
      *
     D WErrFlag        S              1A
     D WMaxLen         S              5S 0
     D WLenComp        S              3S 0                                                  BUG23742
     D WNoLine         S              2S 0                                                  BUG23742
      *
     D WCpy            S             80A
     D WaPgm           S             10A
     D WPos            S              3S 0                                                  BUG24071
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
      **  Details 7 Validation
      *                                                                                     BUG23994
      ** If network is SWIFT, the only valid values for                                     BUG23994
      ** fld 86 format is SWIFT and UNSD1                                                   BUG23994
      *                                                                                     BUG23994
     C                   IF        EDNWRK = 'SWIFT'                                         BUG23994
     C                   IF        D7F86F <> 'SWIFT' AND                                    BUG23994
     C                             D7F86F <> 'UNSD1'                                        BUG23994
     C                   EVAL      PZaMsId = 'USR9912'                                      BUG23994
     C                   EVAL      *IN41 = *ON                                              BUG23994
     C                   EXSR      SRZaSndMsg                                               BUG23994
     C                   EVAL      *IN40 = *ON                                              BUG23994
     C                   EVAL      PRetCodeOut = '*MSG'                                     BUG23994
     C                   ENDIF                                                              BUG23994
      *                                                                                     BUG23994
     C                   ELSE                                                               BUG23994
      *
      ** Field 86 Format
      ** Field is Optional
      *
     C                   IF        D7F86F <> 'SWIFT' AND
     C                             D7F86F <> 'UNSD0' AND
     C                             D7F86F <> 'UNSD1' AND
     C                             D7F86F <> 'UNSD2' AND
     C                             D7F86F <> 'UNSD3' AND
     C                             D7F86F <> 'STRCT' AND
     C                             D7F86F <> 'NSTD'
     C                   EVAL      PZaMsId = 'USR5308'
     C                   EVAL      *IN41 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
     C                   ENDIF                                                              BUG23994
      *
      ** Number of lines is mandatory for NSTD format
      *
     C                   IF        D7F86F = 'NSTD' AND D7NOLN = *ZEROS
     C                   EVAL      PZaMsId = 'USR5332'
     C                   EVAL      *IN42 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Number of Lines cannot be Greater than 20
      *
     C**********         IF        EDMCNW = 'Y'                                    BUG23742 BUG24305
     C**********         EVAL      WNoLine = 40                                    BUG23742 BUG24305
     C**********         ELSE                                                      BUG23742 BUG24305
     C                   EVAL      WNoLine = 20                                             BUG23742
     C**********         ENDIF                                                     BUG23742 BUG24305
      *                                                                                     BUG23742
     C**********         IF        D7NOLN > 20                                              BUG23742
     C                   IF        D7NOLN > WNoLine                                         BUG23742
     C                   EVAL      PZaMsId = 'USR5335'
     C                   MOVEL     WNoLine       PZaMsda                                    BUG23742
     C                   EVAL      *IN42 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
     C                   IF        D7NOLN <> *ZEROS
      *
     C                   SELECT
      *
     C                   WHEN      D7F86F = 'SWIFT'
     C                   IF        D7NOLN <> 6
     C                   EVAL      PZaMsId = 'USR5318'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD0'
     C                   IF        D7NOLN <> 14
     C                   EVAL      PZaMsId = 'USR5319'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD1'
     C                   IF        D7NOLN <> 6
     C                   EVAL      PZaMsId = 'USR5320'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD2'
     C                   IF        D7NOLN <> 10
     C                   EVAL      PZaMsId = 'USR5321'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD3'
     C**********         IF        D7NOLN <> 11                                             BUG23654
     C                   IF        D7NOLN <> 16                                             BUG23654
     C                   EVAL      PZaMsId = 'USR5322'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'STRCT'
     C                   IF        D7NOLN <> 1
     C                   EVAL      PZaMsId = 'USR5323'
     C                   EVAL      *IN42 = *ON
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** If an error was Found
      *
     C                   IF        *IN42 = *ON AND PZaMsId <> 'USR5335'
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Number of characters per line is mandatory for NSTD format
      *
     C                   IF        D7F86F = 'NSTD' AND D7NCLN = *ZEROS
     C                   EVAL      PZaMsId = 'USR5333'
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Number of characters per line should be greater than 20
      *
     C                   IF        D7NCLN < 20
     C                   EVAL      PZaMsId = 'USR5310'
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *                                                                                     BUG24111
      ** Number of characters per line should only have a maximum of 70                     BUG24111
      *                                                                                     BUG24111
     C                   IF        D7F86F = 'NSTD' AND D7NCLN > 70                          BUG24111
     C                   EVAL      PZaMsId = 'USR9939'                                      BUG24111
     C                   EVAL      *IN43 = *ON                                              BUG24111
     C                   EXSR      SRZaSndMsg                                               BUG24111
     C                   EVAL      *IN40 = *ON                                              BUG24111
     C                   EVAL      PRetCodeOut = '*MSG'                                     BUG24111
     C                   ENDIF                                                              BUG24111
      *
     C                   IF        D7NCLN <> *ZEROS
      *
     C                   SELECT
      *
     C                   WHEN      D7F86F = 'SWIFT'
     C                   IF        D7NCLN <> 65
     C                   EVAL      PZaMsId = 'USR5324'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD0'
     C                   IF        D7NCLN <> 27
     C                   EVAL      PZaMsId = 'USR5325'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD1'
     C                   IF        D7NCLN <> 65
     C                   EVAL      PZaMsId = 'USR5326'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD2'
     C                   IF        D7NCLN <> 32
     C                   EVAL      PZaMsId = 'USR5327'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD3'
     C                   IF        D7NCLN <> 35
     C                   EVAL      PZaMsId = 'USR5328'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'STRCT'
     C**********         IF        D7NCLN <> 387                                            BUG26824
     C                   IF        D7NCLN <> 390                                            BUG26824
     C                   EVAL      PZaMsId = 'USR5329'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** If an error was Found
      *
     C**********         IF        *IN43 = *ON AND PZaMsId <> 'USR5310'                     BUG24111
     C                   IF        *IN43 = *ON AND                                          BUG24111
     C                             PZaMsId <> 'USR5310' AND                                 BUG24111
     C                             PZaMsId <> 'USR9939'                                     BUG24111
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Line length * Number of lines cannot be greater than 390
      *
     C                   EVAL      WMaxLen = D7NCLN * D7NOLN
      *
      ***Set*'length*to*be*compared*with'*accordingly                              BUG23742 BUG24305
      **********                                                                   BUG23742 BUG24305
     C**********         IF        EDMCNW = 'Y'                                    BUG23742 BUG24305
      **********                                                                   BUG23742 BUG24305
     C**********         EVAL      WLenComp = 800                                  BUG23742 BUG24305
     C**********         ELSE                                                      BUG23742 BUG24305
     C                   EVAL      WLenComp = 390                                           BUG23742
      *                                                                                     BUG23742
     C**********         ENDIF                                                     BUG23742 BUG24305
      *                                                                                     BUG23742
     C**********         IF        D7F86F = 'NSTD' AND WMaxLen > 390                        BUG23742
     C                   IF        D7F86F = 'NSTD' AND                                      BUG23742
     C                             WMaxLen > WLenComp                                       BUG23742
      *                                                                                     BUG23742
     C                   EVAL      PZaMsId = 'USR5331'
     C                   MOVEL     WLenComp      PZaMsda                                    BUG23742
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
      *                                                                                     BUG23742
     C                   ENDIF
      *
      ** Line Separator should be blanks when number of lines is 1
      *
     C                   IF        D7NOLN = 1 AND D7LSEP <> *BLANKS
     C                   EVAL      PZaMsId = 'USR5311'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *                                                                                     BUG24071
      ** Line separator should not have ':' as a value                                      BUG24071
      *                                                                                     BUG24071
     C                   EVAL      WPos = %SCAN(':':D7LSEP:1)                               BUG24071
     C                   IF        WPos > *ZEROS AND EDMCNW = 'Y'                           BUG24071
     C                   EVAL      PZaMsId = 'USR5336'                                      BUG24071
     C                   EVAL      *IN44 = *ON                                              BUG24071
     C                   EXSR      SRZaSndMsg                                               BUG24071
     C                   EVAL      *IN40 = *ON                                              BUG24071
     C                   EVAL      PRetCodeOut = '*MSG'                                     BUG24071
     C                   ENDIF                                                              BUG24071
      *
      ** Wrap Text: Valid values are 'Y' or 'N'
      *
     C                   IF        D7WTXT  <> 'Y' AND D7WTXT <> 'N'
     C                   EVAL      PZaMsId = 'USR3973'
     C                   EVAL      *IN45 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Truncate Lines: Valid values are 'Y' and 'N'
      *
     C                   IF        D7TRLN  <> 'Y' AND D7TRLN <> 'N'
     C                   EVAL      PZaMsId = 'USR3973'
     C                   EVAL      *IN46 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Wrap Lines and Truncate lines cannot be set to 'Y' at the same
      ** time
      *
     C                   IF        D7WTXT  = 'Y' AND D7TRLN = 'Y'
     C                   EVAL      PZaMsId = 'USR5312'
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Wrap Lines and Truncate lines cannot be set to 'N' together
      *
     C                   IF        D7WTXT  = 'N' AND D7TRLN = 'N'
     C                   EVAL      PZaMsId = 'USR5330'
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Merge Lines must be lower or equal to the Number of Lines
      *
     C                   IF        D7MGLN  > D7NOLN
     C                   EVAL      PZaMsId = 'USR5316'
     C                   EVAL      *IN47 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
      *
      ** Keep Line separators Flag: Valid Values 'Y' or 'N'
      *
     C                   IF        D7KLSP  <> 'Y' AND D7KLSP <> 'N'
     C                   EVAL      PZaMsId = 'USR3973'
     C                   EVAL      *IN48 = *ON
     C                   EXSR      SRZaSndMsg
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRetCodeOut = '*MSG'
     C                   ENDIF
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
      *  Called by : Main Processing, *PSSR                           *
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
     C                   IF        PCallerIn= *BLANKS
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
