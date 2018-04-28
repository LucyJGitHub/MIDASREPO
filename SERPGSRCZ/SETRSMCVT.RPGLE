     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements conv file to screen fmt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMCVT - Security Trade Settlment convert file to screen  *
      *              format                                           *
      *                                                               *
      *  Function: This module will convert the fields of a Security  *
      *            Trade Settlement from their format as on file to a *
      *            screen format.                                     *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                SETRSMCTL                                      *
      *                SETRSMRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP182   *CREATE   Date 25Feb03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit     - Subroutine to initialise fields                 *
      *  SrConvFlds - Subroutine to convert file fields to screen     *
      *               format.                                         *
      *  SrSetDet   - Settlement Details                              *
      *  SrAOCurr   - Check currency details                          *
      *  SrZDate2   - Convert Midas Date into DDMMYY or MMDDYY        *
      *  SrZSEDIT   - Edit Amount                                     *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SE Trades Settlement - By Branch/Trade/Sequence number
     FSETLE     IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D TABMTH          S              1  0 DIM(6) CTDATA PERRCD(1)              Payment Method
     D TABMTN          S             22    DIM(6) ALT(TABMTH)                   Method Name
      *
      ** SE Trade Settlement details retrieved from file
      ** - screen format
     D CrTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S_)
      *
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry parameter list definition
     D PMode           S              6A
     D PEdtFld         S              1A
     D PDTRDR          S              6A
     D PDMVDT          S              6A
     D PDFSET          S              1A
     D PDREVE          S              1A
     D PSSEQN          S              3  0
      *
      ** Parameters for ZDATE2
     D PDateIn         S              5P 0
     D BJDFIN          S              1A
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameters for ZSEDIT
     D AmountIn        S             15  0
     D ZDecs           S              1  0
     D ZECode          S              1
     D AmountOut       S             21A
      *
      ** Parameters for AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCyCd           S              3A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialisation.
     C                   EXSR      SrInit
      *
      ** Convert fields
     C                   EXSR      SrConvFlds
      *
      ** Return.
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  SrConvFlds - Subroutine to convert file fields to screen     *
      *               format.                                         *
      *                                                               *
      *****************************************************************
     C     SrConvFlds    BEGSR
      *
      ** If valid trade move key file fields to key screen fields.
      *
     C                   If        TDRF <> *Blanks
      *
     C                   Z-Add     TNLU          STNLU             5 0
      *
     C                   Movel     TCNR          PKeyC
     C                   CallB     'AOCUSTR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PKeyC            10
     C                   Parm      *BLANKS       PKyst             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
      *
      ** Trade type (Literal)
     C                   If        TDTP = 'TP'
     C                   Move      'Purchase'    DDSLPR
     C                   Else
     C                   If        TDTP = 'TS'
     C                   Movel     'Sale'        DDSLPR
     C                   Endif
     C                   Endif
      *
      ** Branch Code
     C                   Eval      DDBRCD = TDBA
      *
      ** Security report name
     C                   Movel     S_SRPN        DDSRNM
      *
      ** Customer report name and town
     C                   Move      BBCRNM        DDCLNM
     C                   Move      BBCRTN        DDTOWN
      *
      ** Settlement type
     C                   Move      SMTH          DDSTYP
      *
      ** Payment method name
     C                   Move      PCOD          WPCODN            1 0
     C     WPCODN        LookUp    TABMTH        TABMTN                   50                   E1421
     C   50              Move      TABMTN        DDPMTN
      *
      ** If type is Purchase, text is 'Deliver to/Pay from'
     C                   If        TDTP = 'TP'
     C                   Move      DELT          DDDELI
     C                   Eval      DDPAYI = PYFM
     C                   Else
      ** else type is Sale, text is 'Deliver from/Pay to'
     C                   Move      DELF          DDDELI
     C                   Eval      DDPAYI = PAYT
     C                   EndIf
      *
      ** Security shortname
     C                   Eval      DDSECS = TDSS
      *
      ** Trade reference
     C                   Move      TDRF          DDTRAD
      *
      ** Value date
     C                   Z-add     TDVD          PDateIn
     C                   Exsr      SrZDate2
     C                   Move      PDateOut      DDVALD
      *
      ** Client
     C                   Move      TCNR          DDCLNT
      *
      ** Nominal currency
     C                   Eval      DDNOMC = TNMC
      *
      ** Settlement/Value currency
     C                   Eval      DDVALC = SETC
      *
      ** Movement date
     C                   Eval      DDMDAT = PDMVDT
      *
      ** Full Settle
     C                   Eval      DDFULS = PDFSET
      *
      ** Reversal
     C                   If        PDREVE <> *Blanks
     C                   Eval      DDREVR = PDREVE
     C                   Else
     C                   Eval      DDREVR = 'N'
     C                   EndIf
      *
      ** Get the Settlement value details from the settlement file if
      *  in enquiry mode
     C                   If        PMode = '*SIN' And PEdtFld <> 'Y'
     C                   Exsr      SrSetDet
     C                   Goto      EndSetDet
     C                   EndIf
      *
      ** O/S nominal ( or if reversal then total nominal settled )
     C                   Z-Add     *Zeros        AmountIn
     C                   If        DDREVR = 'Y'
     C     TNSN          Add       TNSP          AmountIn
     C                   Else
     C                   Add       TOSN          AmountIn
     C                   Endif
      *
     C                   Z-Add     TNMD          ZDecs
     C                   Move      'L'           ZECode
     C                   Exsr      SrZSEDIT
     C                   Move      EdtAmnt       DDONOM
      *
      ** Nominal settled
     C                   If        DDREVR = 'Y'
      ** Default to total nominal settled
     C                   Move      EdtAmnt       DDNOMS
     C                   Else
     C                   Eval      DDNOMS = *Blanks
     C                   EndIf
      *
      ** O/S Value ( or if reversal then total value settled )
     C                   If        SETC <> *Blanks
     C                   Z-Add     *Zeros        AmountIn
     C                   If        DDREVR = 'Y'
     C     TVSP          Add       TVSN          AmountIn
     C                   Else
     C                   Add       TOSV          AmountIn
     C                   Endif
      *
     C                   Eval      PCyCd = SETC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZDecs
     C                   Move      'L'           ZECode
     C                   Exsr      SrZSEDIT
     C                   Move      EdtAmnt       DDOVAL
     C                   EndIf
      *
      ** Value settled
     C                   If        DDREVR = 'Y'
      ** Default to total Value Settled
     C                   Move      EdtAmnt       DDVALS
     C                   Else
     C                   Eval      DDVALS = *Blanks
     C                   EndIf
      *
      ** If full settlement, allow nominal and value settled to default
     C                   If        DDFULS = 'Y'
     C                   Move      DDONOM        DDNOMS
     C                   Move      DDOVAL        DDVALS
     C                   EndIf
      *
      ** Narrative
     C                   Eval      DDNARR = *Blanks
      *
      ** Reference
     C                   Eval      DDSREF = *Blanks
 
     C     EndSetDet     TAG
 
     C                   EndIf
      *
     C                   Eval      DDTRDR = PDTRDR
     C                   Eval      DDMVDT = PDMVDT
     C                   Eval      DDFSET = PDFSET
     C                   Eval      DDREVE = PDREVE
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrSetDet - Settlement Details                                *
      *                                                               *
      *****************************************************************
     C     SrSetDet      Begsr
      *
      ** Set Up keylist to access Settlement File
     C                   Eval      KSBCA = TDBA
     C                   Eval      KTRDR = PDTRDR
     C                   Z-Add     PSSEQN        KSEQN
      *
     C     KeySet        CHAIN     SETLE                              80
     C                   If        *IN80 = *OFF
      *
      ** Nominal settled/Reversed
     C                   Z-Add     SNMS          AmountIn
     C                   Z-Add     TNMD          ZDecs
     C                   Move      'L'           ZECode
     C                   Exsr      SrZSEDIT
     C                   Move      EdtAmnt       DDNOMS
      *
      ** Value Settled/Reversed
     C                   Z-Add     SVLS          AmountIn
     C                   Eval      PCyCd = SETC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZDecs
     C                   Move      'L'           ZECode
     C                   Exsr      SrZSEDIT
     C                   Move      EdtAmnt       DDVALS
      *
      ** Outstanding Nominal/Settled value not available from SETLED
     C                   Eval      DDONOM = *Blanks
      *
      ** Outstanding Value/Settled value not available from SETLED
     C                   Eval      DDOVAL = *Blanks
      *
      ** Narrative
     C                   Eval      DDNARR = SNTV
      *
      ** Reference
     C                   Eval      DDSREF = SSRF
      *
     C                   EndIf
      *
     C                   Endsr
      *
      *****************************************************************
      *                                                               *
      *  SrInit - Subroutine to initialise fields                     *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr
      *
      ** Initialise output parameters.
     C                   Clear                   CrTS1ScnFmt
      *
     C                   Endsr
      *
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCyCd
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = PCyCd
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Z-Add     1             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR
      *
     C                   CallB     'ZDATE2'
     C                   Parm                    PDateIn
     C                   Parm                    BJDFIN
     C                   Parm      *ZERO         PDateOut
     C                   Parm      *BLANKS       PADateOut
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      ** SrZSEDIT - Edit Amount                                       *
      *                                                               *
      *****************************************************************
     C     SrZSEDIT      Begsr
      *
      ** Reset the working field
     C                   Eval      EdtAmnt = *Blanks
     C                   Eval      AmountOut = *Blanks
      *
      **  Call ZSEDIT to edit an amount field
     C                   Call      'ZSEDIT'
     C                   Parm                    AmountIn
     C                   Parm                    ZDecs
     C                   Parm                    ZECode
     C                   Parm                    AmountOut
      *
      **  Drop right hand charaacter as this is for a sign
     C                   Movel     AmountOut     EdtAmnt          20
      *
     C                   Endsr
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
      ** Settlement Sequence Number
     C                   PARM                    PDTRDR
     C                   PARM                    PDMVDT
     C                   PARM                    PDFSET
     C                   PARM                    PDREVE
     C                   PARM                    PSSEQN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** SE Trade Settlements screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrTS1ScnFmt
      *
      *
      ** Key list to access Settlement Details File
     C     KeySet        KLIST
     C                   KFLD                    KSBCA             3
     C                   KFLD                    KTRDR             6
     C                   KFLD                    KSEQN             3 0
      *
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
**   TABMTH/TABMTN  -  Settlement type/description
0As required
1Against Payment
2Payment after delivery
3Free
4Delivery after payment
5Against Payment
