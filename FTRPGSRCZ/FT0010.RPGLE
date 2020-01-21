     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate and calculate currencies')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT0010 - Currency Conversion/Validation for FT               *
      *           (Converted from OPM to ILE module)                  *
      *                                                               *
      *                            WARNING                            *                       CTI002
      *                            -------                            *                       CTI002
      *  THE SAME RELEASE OF THIS PROGRAM EXISTS IN AN OTHER NAME     *                       CTI002
      *  EM0010 SO ANY AMENDMENTS MADE HERE MUST BE COPIED IN         *                       CTI002
      *  EM0010.                                                      *                       CTI002
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the FT0010        *
      *  program.  The program contains one or more /COPY members.    *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  The boundaries of the original /COPY members have been       *
      *  marked, to facilitate future maintenance of both the old     *
      *  members and this one.                                        *
      *                                                               *
      *  If this member has to change, the changes should ALMOST      *
      *  CERTAINLY be implemented by changing the old /COPY member,   *
      *  reconverting it using CVTRPGSRC, and copying it into this    *
      *  member, replacing the existing section and re-changing the   *
      *  EXSRs to CALLBs.                                             *
      *                                                               *
      *  Function:  This program will be called by all input          *
      *  programs which need to calculate an amount or verify         *
      *  an entered amount.                                           *
      *  (phase(s)) I/C                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD053553           Date 21Jan20               *
      *  Prev Amend No. MD050134           Date 21Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD045094           Date 10May17               *
      *                 MD030406           Date 27Oct14               *
      *                 258369             Date 06Jun13               *
      *                 AR787421           Date 27Sep12               *
      *                 AR737259           Date 27Sep12               *
      *                 CRE072             Date 30Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255710             Date 04Aug08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240719             Date 30Jun06               *
      *                 BUG4227            Date 10Mar04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 171706             Date 23Jan02               *
      *                 195110             Date 22Jan02               *
      *                 194316             Date 21Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187222             Date 23Nov00               *
      *                 CFT014             Date 21Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136             Date 15Nov99               *
      *                 CFT006             Date 02Nov99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP031             Date 07JUN99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002             Date 28Aug98               *
      *                 148229             Date 13Dec98               *
      *                 139103             Date 17Jul98               *
      *                 CEU006  *CREATE    Date 23Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053553 - FT Incoming EUR-USD: Invalid Pay Amount           *
      *  MD050134 - A serious midas error encountered when exchange   *
      *             rate exceeds tolerance level                      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045094 - Credit and Debit amount are incorrect             *
      *  MD030406 - Cross Currency Outgoing Payment, pay amount not   *
      *             automatically calculated & show 0 in confirmation *
      *             screen. FT0010 should not return to calling       *
      *             program if warning encountered.                   *
      *  258369 - Consider the inverse rate. (Reopen)                 *
      *         - Applied for AR737259B. (Child: AR787421)            *
      *  AR787421 - Incorrect calculation in currency conversion      *
      *             with exchange rate less than 1.                   *
      *  AR737259 - Incorrect calculation in currency conversion with *
      *             base currency (Child: AR737260)                   *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255710 - Incorrect calculation of commission. Applied 248177 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240719 - Apply fix 196950.                                   *
      *  196950 - Multiple/divide indicator are not set up correctly  *
      * BUG4227 - Allow input of inverse rates. (199133)              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  171706 - In case of the "Pay ccy" and the "Settle ccy"       *
      *           different from the "Base ccy", the debit amount     *
      *           calculation is incorrect.                           *
      *  195110 - Validate for duplicate currencies even if CEU006 is *
      *           not switched on.                                    *
      *  194316 - Only compute for the delivery amounts if CEU006 is  *
      *           on.                                                 *
      *  187222 - Allow messages to be passed back                    *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *           This change is not applicable to EM0010 as it is    *
      *           effective only when called from FT0040 and FT0050.  *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *  CFT006 - Funds Transfer/Swift Messages MT101                 *
      *  CAP031 - adjust error processing for new FT API
      *  CTI002 - Addition of the WARNING statement.                  *
      *  148229 - Add Interim amount calculation processing.          *
      *  139103 - DB Error when Euro feature is off.                  *
      *  CEU006 - EMU Funds Transfer                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      * 01-05         Error Indicators                                *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-Specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--- The converted ZPOWERZ1 starts here --------------------------+

     D Power           S              7  3 DIM(7) CTDATA PERRCD(1)
      ** Array containing powers for Ccy conversion

      ** +--- The converted ZPOWERZ1 ends here ----------------------------+
      *
      *
     D CCY             S              3    DIM(4)
      ** Array containing Currencies
      *
     D AMNT            S             13  0 DIM(4)
     D INTA            S             18  3 DIM(4)
      ** Array containing Amounts
      ** And array containing Interim Amounts                                                 148229
      *
     D VDAT            S              5  0 DIM(4)
      ** Array containing Debit & Credit Dates
      *
     D TYPE            S              2    DIM(4)
      ** Array containing Currency status
      *
     D SPRT            S             13  8 DIM(4)
      ** Array containing Currency rates
      *
     D MDIN            S              1    DIM(4)
      ** Array containing Currency M/D indicators
      *
     D EUER            S             13  8 DIM(4)
      ** Array containing Currency rates
      *
     D EUMD            S              1    DIM(4)
      ** Array containing Currency M/D indicators
      *
     D NBDP            S              1  0 DIM(4)
      ** Array containing Currency number of d.p.'s
      *
     D WINVER          S              1A                                                    MD045094
     D NRATE           S             14  9                                                  MD053553
     D D9              S              1  0                                                  MD053553
      /SPACE 3
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External data structures for General Ledger Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External data structures for Currency Details
      *
     D DSFDY         E DS
      **  First data structure for Access Programs, short DS
      *
     D DSSDY         E DS
      **  Second data structure for Access Programs, long DS
      *
      /COPY FTCPYSRC,FT0010D001
      **  Data Structure for input/output parameters
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Perform Main Processing.
      *
     C                   EXSR      CHKAM1
     C/COPY WNCPYSRC,FT0010C006
     C                   EXSR      CCYDET
     C/COPY WNCPYSRC,FT0010C007
     C                   EXSR      CHKRAT
     C     CEU006        IFEQ      'Y'                                                        194316
     C                   EXSR      DLVAMT
     C                   ELSE                                                                 195110
     C                   EXSR      CHKDUP                                                     195110
     C                   ENDIF                                                                194316
     C                   EXSR      TRNAMT
     C     CCY(1)        IFNE      *BLANKS
     C     AMNT(1)       ANDEQ     *ZERO
     C     CCY(4)        ORNE      *BLANKS
     C     AMNT(4)       ANDEQ     *ZERO
     C                   EXSR      DLVAM2
     C                   ENDIF
      *
      ***  End Program and Return.
      *
     C                   EXSR      RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AOGELRR0 Access Program (General Ledger)                     *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#0010
      *
     C                   SETOFF                                       55                    MD030406
      *                                                                                     MD030406
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Initialise LDA field.
      *
     C/COPY WNCPYSRC,FT0010C008
     C                   MOVEL     'FT0010'      DBPGM
     C*
     C** Access SAR details file to determine if CEU006 is switched ON
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU006'      PSARD             6
     C                   MOVE      'N'           CEU006            1
     C*
     C** If core feature is switched ON, set on indicator that will
     C** condition the rest of the processing
     C*
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU006
     C                   ELSE
     C*
     C** else, database error (return code other than *NRF)
     C*
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SCSARDPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     'CEU006'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C*                                                                                       CRE072
     C** Access SAR details file to determine if CRE072 is switched ON                        CRE072
     C*                                                                                       CRE072
     C                   CALL      'AOSARDR0'                                                 CRE072
     C                   PARM      *BLANKS       PRTCD                                        CRE072
     C                   PARM      '*VERIFY'     POPTN                                        CRE072
     C                   PARM      'CRE072'      PSARD                                        CRE072
     C                   MOVE      'N'           CRE072            1                          CRE072
     C*                                                                                       CRE072
     C** If switchable feature is switched ON, set on indicator that will                     CRE072
     C** condition the rest of the processing                                                 CRE072
     C*                                                                                       CRE072
     C     PRTCD         IFEQ      *BLANKS                                                    CRE072
     C                   MOVE      'Y'           CRE072                                       CRE072
     C                   ELSE                                                                 CRE072
     C*                                                                                       CRE072
     C** else, database error (return code other than *NRF)                                   CRE072
     C*                                                                                       CRE072
     C     PRTCD         IFNE      '*NRF   '                                                  CRE072
     C     *LOCK         IN        LDA                                                        CRE072
     C                   Z-ADD     008           DBASE                                        CRE072
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE072
     C                   MOVEL     'CRE072'      DBKEY                                        CRE072
     C                   OUT       LDA                                                        CRE072
     C                   EXSR      *PSSR                                                      CRE072
     C                   ENDIF                                                                CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C/COPY WNCPYSRC,FT0010C009
      *
      ***  Setup array CCY
      *
     C                   MOVEL     P#NDCY        CCY(1)
     C                   MOVEL     P#DBCY        CCY(2)
     C                   MOVEL     P#CRCY        CCY(3)
     C                   MOVEL     P#PDCY        CCY(4)
      *
      ***  Setup array AMNT
      *
     C                   Z-ADD     P#NDAM        AMNT(1)
     C                   Z-ADD     P#DBAM        AMNT(2)
     C                   Z-ADD     P#CRAM        AMNT(3)
     C                   Z-ADD     P#PDAM        AMNT(4)
      *                                                                                       194316
     C     CEU006        IFEQ      'N'                                                        194316
     C                   MOVE      *BLANKS       CCY(1)                                       194316
     C                   Z-ADD     *ZERO         AMNT(1)                                      194316
     C                   Z-ADD     *ZERO         AMNT(4)                                      194316
     C                   MOVE      *BLANKS       CCY(4)                                       194316
     C                   ENDIF                                                                194316
      *                                                                                       148229
      ***  Setup array INTA                                                                   148229
      *                                                                                       148229
     C                   MOVEA     *ZEROS        INTA
      *
      ***  Setup array VDAT
      *
     C                   Z-ADD     P#DBDT        VDAT(1)
     C                   Z-ADD     P#DBDT        VDAT(2)
     C                   Z-ADD     P#CRDT        VDAT(3)
     C                   Z-ADD     P#CRDT        VDAT(4)
      *
      ** Set Error indicators to zero.
      *
     C                   MOVE      '00000'       P#INDC
     C                   MOVEA     '00000'       *IN(01)
      *
      ** Set Return Code to Blanks.
      *
     C                   MOVE      *BLANKS       P#RTCD
      *
      ** Access Standing Data General Ledger File.
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Data base error in file SDGELRPD.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE                          ***************
     C                   MOVEL     'SDGELRPD'    DBFILE                         *DB ERROR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Standing Data Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Data base error in file SDBANKPD.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     003           DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 003 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Access Base currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      BJCYCD        PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     004           DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *DB ERROR 004 *
     C                   MOVEL     BJCYCD        DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * SET MESSAGE PROCESSING COMPARISON FIELDS           CAP031
     C                   MOVEL     'FTVEUC'      W1PMSQ                         CAP031
     C                   MOVE      'HK  '        W1PMSQ                         CAP031
     C                   MOVEL     'FTVTOT'      W2PMSQ                         CAP031
     C                   MOVE      'CG  '        W2PMSQ                         CAP031
      *                                                                         CAP136
     C                   MOVEL     'FTVIRA'      W3PMSQ                         CAP136
     C                   MOVE      'TE  '        W3PMSQ                         CAP136
     C                   MOVEL     'FTVAMAM'     W4PMSQ                         CFT014
      *
      * Determine whether base currency is In, Out, or euro.
      * When deciding if it is In, use the earlier of debit or
      * credit date as long as it is non-zero.
     C     A6INCY        IFEQ      'Y'
     C                   SELECT
     C     P#DBDT        WHENEQ    *ZERO
     C                   Z-ADD     P#CRDT        W#DAT1
     C     P#CRDT        WHENEQ    *ZERO
     C                   Z-ADD     P#DBDT        W#DAT1
     C     P#DBDT        WHENLT    P#CRDT
     C                   Z-ADD     P#DBDT        W#DAT1
     C                   OTHER
     C                   Z-ADD     P#CRDT        W#DAT1
     C                   ENDSL
     C                   ENDIF
      *
     C                   SELECT
     C     CEU006        WHENEQ    'N'
     C                   MOVE      'OT'          BASTYP            2
      *
     C     BJCYCD        WHENEQ    BKEURO
     C                   MOVE      'EU'          BASTYP
      *
     C     A6INCY        WHENEQ    'Y'
     C     A6TPSD        ANDLE     W#DAT1
     C                   MOVE      'IN'          BASTYP
      *
     C                   OTHER
     C                   MOVE      'OT'          BASTYP
     C                   ENDSL
      *
     C     BASTYP        IFEQ      'IN'
     C**********         Z-ADD     A6EUER        BSEUER                                       255710
     C**********         MOVE      A6EUMD        BSEUMD                                       255710
     C                   Z-ADD     A6SPRT        BSSPRT                                       255710
     C                   MOVE      A6MDIN        BSMDIN                                       255710
     C                   ENDIF
      *
      * If base is 'out', the euro spot (+/- spread) may be required
      * later to convert in-->out or out-->in.
      * Only call when CEU006 is on.                                      139103
     C     CEU006        IFEQ      'Y'                                                         13910
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      BKEURO        PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     007           DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     BKEURO        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6SPRT        EUBYRT
     C                   Z-ADD     A6SPRT        EUSLRT
     C                   MOVE      A6MDIN        EUMDIN
     C                   ENDIF                                                                 13910
     C/COPY WNCPYSRC,FT0010C001
      *
      * Add/subtract buy/sell spread
     C     P#SDIN        IFEQ      'Y'
     C     A6BYSS        IFEQ      '+'
     C                   ADD       A6BYSR        EUBYRT
     C                   ENDIF
     C     A6BYSS        IFEQ      '-'
     C                   SUB       A6BYSR        EUBYRT
     C                   ENDIF
     C     A6SLSS        IFEQ      '+'
     C                   ADD       A6SLSR        EUSLRT
     C                   ENDIF
     C     A6SLSS        IFEQ      '-'
     C                   SUB       A6SLSR        EUSLRT
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,FT0010C002
      *
      * Definitions.
     C     *LIKE         DEFINE    P#DBDT        W#DAT1
     C     *LIKE         DEFINE    P#PMSQ        W1PMSQ                         CAP031
     C     *LIKE         DEFINE    P#PMSQ        W2PMSQ                         CAP031
     C     *LIKE         DEFINE    P#PMSQ        W3PMSQ                         CAP136
     C     *LIKE         DEFINE    P#PMSQ        W4PMSQ                         CFT014
     C     *LIKE         DEFINE    P@OUTA        UPPER
     C     *LIKE         DEFINE    P@OUTA        LOWER
     C     *LIKE         DEFINE    P@FRAM        W#EAMT
     C     *LIKE         DEFINE    P@FRAM        INTER1
     C     *LIKE         DEFINE    P@FRAM        INTER2
     C     *LIKE         DEFINE    P@FRCY        W#TRCY
     C     *LIKE         DEFINE    P@TOCY        W#STCY
     C     *LIKE         DEFINE    A6SPRT        EURATE
     C     *LIKE         DEFINE    A6SPRT        EUBYRT
     C     *LIKE         DEFINE    A6SPRT        EUSLRT
     C     *LIKE         DEFINE    A6MDIN        EUMDIN
     C******LIKE         DEFINE    A6EUER        BSEUER                                       255710
     C     *LIKE         DEFINE    A6EUER        BSSPRT                                       255710
     C******LIKE         DEFINE    A6EUMD        BSEUMD                                       255710
     C     *LIKE         DEFINE    A6EUMD        BSMDIN                                       255710
     C     *LIKE         DEFINE    P#RATE        WGRATE                                     AR787421
      *                                                                         187222
      * If P#PMSQ is equal to 'PassBack' blank out                              187222
      * also set message id to blanks                                           187222
      *                                                                         187222
     C                   IF        P#PMSQ = 'PassBack'                          187222
     C     *Like         Define    P#PMSQ        ##PMSQ                         187222
     C                   Eval      ##PMSQ = P#PMSQ                              187222
     C                   Eval      P#PMSQ = *Blanks                             187222
     C                   Endif                                                  187222
     C                   Eval      FTMSID = *Blanks                             187222
      *                                                                         187222
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKAM1 - Determine first non-zero amount                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  SNDMSG - Send Messages.                                      *
      *  RETURN - Return control.                                     *
      *                                                               *
      *****************************************************************
      *
     C     CHKAM1        BEGSR
      *
      ** Determine first non-zero amount.
      *
     C                   DO        4             A                 1 0
      *
     C     AMNT(A)       IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
      *
      ** Error if no non-zero amount is found.
      *
     C     A             IFEQ      4
     C                   MOVE      *ON           *IN02
     C                   MOVE      *ON           *IN03
     C                   MOVEL     'FTM2572'     FTMSID
     C                   SETON                                        55                    MD050134
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   SETOFF                                       55                    MD050134
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CCYDET - Get Currency Details, (Whether 'IN' or 'OUT' etc)   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AOCURRR0 Access Program (Currency Details)                   *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
     C     CCYDET        BEGSR
      *
      ** Determine Currency status and details for each Ccy.
      *
     C                   DO        4             X                 1 0
     C     CCY(X)        IFEQ      *BLANKS
     C                   ITER
     C                   ENDIF
      *
      ** Access Currencies File.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      CCY(X)        PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Data base error in file SDCURRPD.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     005           DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *DB ERROR 005 *
     C                   MOVEL     CCY(X)        DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        NBDP(X)
      *
      ** Check whether Currency is 'IN' or Euro or 'OUT'
      *
     C                   SELECT
      *
      ** Check whether switch CEU006 is on, if it is not then set
      ** currency status as 'OUT'.
      *
     C     CEU006        WHENEQ    'N'
     C                   MOVE      'OT'          TYPE(X)
      *
     C     CCY(X)        WHENEQ    BKEURO
     C                   MOVE      'EU'          TYPE(X)
      *
     C     A6INCY        WHENEQ    'Y'
     C     A6TPSD        ANDLE     VDAT(X)
     C     X             ANDGT     1
     C     X             ANDLT     4
     C     A6INCY        OREQ      'Y'
     C     X             ANDEQ     1
     C     A6INCY        OREQ      'Y'
     C     X             ANDEQ     4
     C                   MOVE      'IN'          TYPE(X)
      *
     C                   OTHER
     C                   MOVE      'OT'          TYPE(X)
     C                   ENDSL
      *
      * Setup rates for currencies 2 and 3.
     C     X             IFEQ      2
     C     X             OREQ      3
     C                   Z-ADD     A6SPRT        SPRT(X)
     C                   MOVE      A6MDIN        MDIN(X)
      *
     C     BASTYP        IFEQ      'OT'
     C     TYPE(X)       ANDNE     'IN'
     C     TYPE(X)       OREQ      'OT'
     C/COPY WNCPYSRC,FT0010C003
      *
      * Add/subtract buy/sell spread
     C     P#SDIN        IFEQ      'Y'
     C/COPY WNCPYSRC,FT0010C005
     C                   SELECT
     C     X             WHENEQ    2
     C     A6BYSS        ANDEQ     '+'
     C                   ADD       A6BYSR        SPRT(X)
     C     X             WHENEQ    2
     C     A6BYSS        ANDEQ     '-'
     C                   SUB       A6BYSR        SPRT(X)
     C     X             WHENEQ    3
     C     A6SLSS        ANDEQ     '+'
     C                   ADD       A6SLSR        SPRT(X)
     C     X             WHENEQ    3
     C     A6SLSS        ANDEQ     '-'
     C                   SUB       A6SLSR        SPRT(X)
     C                   ENDSL
     C/COPY WNCPYSRC,FT0010C004
     C                   ENDIF
     C                   ENDIF
      *
     C     TYPE(X)       IFEQ      'IN'
     C**********         Z-ADD     A6EUER        EUER(X)                                      255710
     C**********         MOVE      A6EUMD        EUMD(X)                                      255710
     C                   Z-ADD     A6SPRT        EUER(X)                                      255710
     C                   MOVE      A6MDIN        EUMD(X)                                      255710
      *
      * The 'spot' for an In currency where base is 'out' is derived
      * by combining the euro rate of the 'in' currency with the
      * spot (+/- spread) for euros.
     C     BASTYP        IFEQ      'OT'
     C     X             IFEQ      2
     C                   Z-ADD     EUBYRT        EURATE
     C                   ELSE
     C                   Z-ADD     EUSLRT        EURATE
     C                   ENDIF
      *
     C                   SELECT
     C     EUMDIN        WHENEQ    EUMD(X)
     C     EURATE        MULT(H)   EUER(X)       SPRT(X)
     C                   MOVE      EUMDIN        MDIN(X)
      *
     C     EURATE        WHENGT    EUER(X)
     C     EURATE        DIV(H)    EUER(X)       SPRT(X)
     C                   MOVE      EUMDIN        MDIN(X)
      *
     C                   OTHER
     C     EUER(X)       DIV(H)    EURATE        SPRT(X)
     C                   MOVE      EUMD(X)       MDIN(X)
     C                   ENDSL
      *
     C                   ENDIF
      *
      * The 'spot' for an In currency where base is euros
      * is the euro rate.
     C     BASTYP        IFEQ      'EU'
     C**********         Z-ADD     A6EUER        SPRT(X)                                      255710
     C**********         MOVE      A6EUMD        MDIN(X)                                      255710
     C                   Z-ADD     A6SPRT        SPRT(X)                                      255710
     C                   MOVE      A6MDIN        MDIN(X)                                      255710
     C                   ENDIF
      *
      * The 'spot' for an In currency where base is In is the
      * cross-rate of the two euro rates.
     C     BASTYP        IFEQ      'IN'
     C                   SELECT
     C*****A6EUMD        WHENNE    BSEUMD                                                     255710
     C*****A6EUER        MULT(H)   BSEUER        SPRT(X)                                      255710
     C**********         MOVE      A6EUMD        MDIN(X)                                      255710
     C     A6MDIN        WHENNE    BSMDIN                                                     255710
     C     A6SPRT        MULT(H)   BSSPRT        SPRT(X)                                      255710
     C                   MOVE      A6MDIN        MDIN(X)                                      255710
      *
     C*****A6EUER        WHENGT    BSEUER                                                     255710
     C*****A6EUER        DIV(H)    BSEUER        SPRT(X)                                      255710
     C**********         MOVE      A6EUMD        MDIN(X)                                      255710
     C     A6SPRT        WHENGT    BSSPRT                                                     255710
     C     A6SPRT        DIV(H)    BSSPRT        SPRT(X)                                      255710
     C                   MOVE      A6MDIN        MDIN(X)                                      255710
      *
     C                   OTHER
     C*****BSEUER        DIV(H)    A6EUER        SPRT(X)                                      255710
     C*****A6EUMD        IFEQ      'D'                                                        255710
     C     BSSPRT        DIV(H)    A6SPRT        SPRT(X)                                      255710
     C     A6MDIN        IFEQ      'D'                                                        255710
     C                   MOVE      'M'           MDIN(X)
     C                   ELSE
     C                   MOVE      'D'           MDIN(X)
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDIF
      *
      **The*'spot'*for*euros*where*base*is*an*In*currency*is***********                       255710
      **the*euro*rate*with*the*multiply/divide*indicator*inverted.*****                       255710
     C*****BASTYP        IFEQ      'IN'                                                       255710
     C*****TYPE(X)       ANDEQ     'EU'                                                       255710
     C**********         Z-ADD     BSEUER        SPRT(X)                                      255710
     C*****BSEUMD        IFEQ      'D'                                                        255710
     C**********         MOVE      'M'           MDIN(X)                                      255710
     C**********         ELSE                                                                 255710
     C**********         MOVE      'D'           MDIN(X)                                      255710
     C**********         ENDIF                                                                255710
     C**********         ENDIF                                                                255710
      *
     C                   ENDIF
     C     SPRT(X)       IFLT      1                                                        AR737259
     C     1             DIV       SPRT(X)       SPRT(X)                                    AR737259
     C     MDIN(X)       IFEQ      'M'                                                      AR737259
     C                   MOVE      'D'           MDIN(X)                                    AR737259
     C                   ELSE                                                               AR737259
     C                   MOVE      'M'           MDIN(X)                                    AR737259
     C                   ENDIF                                                              AR737259
     C                   ENDIF                                                              AR737259
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKRAT - Check entry of rate is allowed, and calculate rate  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AOCURRR0 Access Program (Currency Details)                   *
      *  SNDMSG - Send Messages.                                      *
      *  RETURN - Return control.                                     *
      *                                                               *
      *****************************************************************
      *
     C     CHKRAT        BEGSR
      *
      ** Check entry of rate is allowed and whether one of the
      ** currencies is the Base currency.
      *
     C                   MOVE      '0'           *IN07                                        171706
     C     CCY(2)        IFNE      *BLANKS
     C     CCY(3)        ANDNE     *BLANKS
     C                   SELECT
      *
      ** Set Rate to 1 if the currencies are the same.
      ** Or the Euro rate if have an 'IN'/Euro combination.
     C     CCY(2)        WHENEQ    CCY(3)
     C                   Z-ADD     1             ZRATEX
     C                   MOVE      'D'           ZMDIX
      *
     C*****TYPE(2)       WHENEQ    'IN'                                                       255710
     C*****TYPE(3)       ANDEQ     'EU'                                                       255710
     C**********         Z-ADD     EUER(2)       ZRATEX                                       255710
     C**********         MOVE      EUMD(2)       ZMDIX                                        255710
      *****************************************************************                       255710
     C*****TYPE(2)       WHENEQ    'EU'                                                       255710
     C*****TYPE(3)       ANDEQ     'IN'                                                       255710
     C**********         Z-ADD     EUER(3)       ZRATEX                                       255710
     C*****EUMD(3)       IFEQ      'M'                                                        255710
     C**********         MOVE      'D'           ZMDIX                                        255710
     C**********         ELSE                                                                 255710
     C**********         MOVE      'M'           ZMDIX                                        255710
     C**********         ENDIF                                                                255710
      *
     C     TYPE(2)       WHENEQ    'IN'
     C     TYPE(3)       ANDEQ     'IN'
     C     EUER(3)       IFLE      EUER(2)
     C                   Z-ADD     EUER(2)       ZRATE1           13 8
     C                   MOVE      EUMD(2)       ZMDI1             1
     C                   Z-ADD     EUER(3)       ZRATE2           13 8
     C                   MOVE      EUMD(3)       ZMDI2             1
     C                   ELSE
     C                   Z-ADD     EUER(3)       ZRATE1
     C                   MOVE      EUMD(3)       ZMDI1
     C                   Z-ADD     EUER(2)       ZRATE2
     C                   MOVE      EUMD(2)       ZMDI2
     C                   ENDIF
     C                   EXSR      #XRATE
     C     EUER(3)       IFGT      EUER(2)
     C     ZMDIX         IFEQ      'M'
     C                   MOVE      'D'           ZMDIX
     C                   ELSE
     C                   MOVE      'M'           ZMDIX
     C                   ENDIF
     C                   ENDIF
      *
      * The remainder of cases will be EU/OT, OT/OT, OT/EU,
      * IN/OT, OT/IN which are treated the same.
     C                   OTHER
     C                   SELECT
      *
     C     CCY(3)        WHENEQ    BJCYCD
     C                   Z-ADD     SPRT(2)       ZRATEX
     C                   MOVE      MDIN(2)       ZMDIX
      *
     C     CCY(2)        WHENEQ    BJCYCD
     C                   Z-ADD     SPRT(3)       ZRATEX
     C     MDIN(3)       IFEQ      'M'
     C                   MOVE      'D'           ZMDIX
     C                   ELSE
     C                   MOVE      'M'           ZMDIX
     C                   ENDIF
      *
     C                   OTHER
     C     SPRT(3)       IFLE      SPRT(2)
     C                   Z-ADD     SPRT(2)       ZRATE1           13 8
     C                   MOVE      MDIN(2)       ZMDI1             1
     C                   Z-ADD     SPRT(3)       ZRATE2           13 8
     C                   MOVE      MDIN(3)       ZMDI2             1
     C                   ELSE
     C                   Z-ADD     SPRT(3)       ZRATE1
     C                   MOVE      MDIN(3)       ZMDI1
     C                   Z-ADD     SPRT(2)       ZRATE2
     C                   MOVE      MDIN(2)       ZMDI2
     C                   ENDIF
     C                   EXSR      #XRATE
     C     SPRT(3)       IFGT      SPRT(2)
     C     ZMDIX         IFEQ      'M'
     C                   MOVE      'D'           ZMDIX
     C                   ELSE
     C                   MOVE      'M'           ZMDIX
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDSL
     C                   MOVE      '1'           *IN07                                        171706
     C                   ENDIF
     C                   EVAL      WINVER = 'N'                                             MD045094
     C                   Z-ADD     0             WGRATE                                     AR787421
     C     P#RATE        IFNE      0                                                        AR787421
     C     P#RATE        IFLT      1                                                        AR787421
     C     ZRATEX        ANDGT     1                                                        AR787421
     C     P#RATE        ORGT      1                                                        AR787421
     C     ZRATEX        ANDLT     1                                                        AR787421
     C                   Z-ADD     P#RATE        WGRATE                                     AR787421
     C     1             DIV       P#RATE        P#RATE                                     AR787421
     C                   EVAL      WINVER = 'Y'                                             MD045094
     C                   ENDIF                                                              AR787421
     C                   ENDIF                                                              AR787421
      *
      ** Send message if Currency types are not compatible and
      ** a rate has been entered.
      *
     C     P#RATE        IFNE      *ZERO
      *
     C     CCY(2)        IFEQ      *BLANKS
     C     CCY(3)        OREQ      *BLANKS
     C                   MOVE      *ON           *IN05
     C                   MOVEL     'FTM2573'     FTMSID
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   ENDIF
      *
     C     CCY(2)        IFEQ      CCY(3)
     C     P#RATE        ANDNE     1
     C                   MOVE      *ON           *IN05
     C                   MOVEL     'FTM2587'     FTMSID
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   ENDIF
      *
     C     TYPE(2)       IFEQ      'IN'
     C     TYPE(3)       ANDEQ     'EU'
     C     P#RATE        ANDNE     ZRATEX
     C     TYPE(2)       OREQ      'EU'
     C     TYPE(3)       ANDEQ     'IN'
     C     P#RATE        ANDNE     ZRATEX
     C     TYPE(2)       OREQ      'IN'
     C     TYPE(3)       ANDEQ     'IN'
     C     P#RATE        ANDNE     ZRATEX
     C                   MOVE      *ON           *IN05
     C                   MOVEL     'FTM2574'     FTMSID
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   ENDIF
      *
     C     AMNT(2)       IFEQ      *ZERO
     C     AMNT(3)       ANDEQ     *ZERO
     C                   MOVE      *ON           *IN05
     C                   MOVEL     'FTM2575'     FTMSID
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   ENDIF
      *
      ** If 'Override' flag on rate is not 'Y' then the entered
      ** rate must be within the percentage tolerance.
      *
     C*****P#OVRT        IFNE      'Y'                                                      AR737259
     C*****ZRATEX        ANDNE     P#RATE                                                   AR737259
     C                   Z-ADD     0             NEWRAT           13 8
      *
     C     P#RATE        SUB       ZRATEX        DIFF1            13 8                       BUG4227
     C     DIFF1         IFLT      0                                                         BUG4227
     C                   MULT      -1            DIFF1                                       BUG4227
     C                   ENDIF                                                               BUG4227
      *                                                                                      BUG4227
     C     1             DIV       P#RATE        I#RATE           13 8                       BUG4227
     C     I#RATE        SUB       ZRATEX        DIFF2            13 8                       BUG4227
     C     DIFF2         IFLT      0                                                         BUG4227
     C                   MULT      -1            DIFF2                                       BUG4227
     C                   ENDIF                                                               BUG4227
      *                                                                                      BUG4227
     C     ZRATEX        MULT      P#RTDS        TOLR             13 8                       BUG4227
      *                                                                                      BUG4227
     C*****DIFF1         IFGT      TOLR                                             BUG4227 AR737259
     C     P#OVRT        IFNE      'Y'                                                      AR737259
     C     ZRATEX        ANDNE     P#RATE                                                   AR737259
     C     DIFF1         ANDGT     TOLR                                                     AR737259
     C     DIFF2         ANDGT     TOLR                                                      BUG4227
     C                   MOVE      '1'           *IN05                                       BUG4227
     C                   MOVEL     'FTM2577'     FTMSID                                      BUG4227
     C                   SETON                                        55                    MD030406
     C                   EXSR      SNDMSG                                                    BUG4227
     C                   EXSR      RETURN                                                    BUG4227
     C                   SETOFF                                       55                    MD030406
     C                   ENDIF                                                               BUG4227
      *                                                                                      BUG4227
     C     1             DIV       ZRATEX        ZRATEI           13 8                      AR737259
     C     ZRATEI        MULT      P#RTDS        TOLRI            13 8                      AR737259
      *                                                                                     AR737259
      ** Calculate the upper and lower limits of the actual and inverse                     AR737259
      ** of calculated Cross Rate. Check if the entered rate falls                          AR737259
      ** outside the limits of calc. Cross Rate but within the limits                       AR737259
      ** of inverse of the calculated Cross rate then reverse ZMDIX.                        AR737259
      *                                                                                     AR737259
     C     ZRATEX        SUB       TOLR          WLOLIM           13 8                      AR737259
     C     ZRATEX        ADD       TOLR          WUPLIM           13 8                      AR737259
     C     ZRATEI        SUB       TOLRI         WLOLIMI          13 8                      AR737259
     C     ZRATEI        ADD       TOLRI         WUPLIMI          13 8                      AR737259
      *                                                                                     AR737259
     C     P#RATE        IFLT      WLOLIM                                                   AR737259
     C     P#RATE        ORGT      WUPLIM                                                   AR737259
      *                                                                                     AR737259
     C     P#RATE        IFGE      WLOLIMI                                                  AR737259
     C     P#RATE        ANDLE     WUPLIMI                                                  AR737259
      *                                                                                     AR737259
     C     DIFF2         IFLT      DIFF1                                                     BUG4227
     C     ZMDIX         IFEQ      'M'                                                       BUG4227
     C                   MOVEL     'D'           ZMDIX                                       BUG4227
     C                   ELSE                                                                BUG4227
     C                   MOVEL     'M'           ZMDIX                                       BUG4227
     C                   ENDIF                                                               BUG4227
     C                   ENDIF                                                               BUG4227
      *                                                                                     AR737259
     C                   ENDIF                                                              AR737259
      *                                                                                     AR737259
     C                   ENDIF                                                              AR737259
      *                                                                                      BUG4227
     C**********         SELECT                                                              BUG4227
     C*****P#RATE        WHENGT    ZRATEX                                                    BUG4227
     C**********         ADD       1             P#RTDS                                      BUG4227
     C*****ZRATEX        MULT(H)   P#RTDS        NEWRAT                                      BUG4227
     C**********         SUB       1             P#RTDS                                      BUG4227
     C*****P#RATE        IFGT      NEWRAT                                                    BUG4227
     C**********         MOVE      *ON           *IN05                                       BUG4227
     C**********         MOVEL     'FTM2577'     FTMSID                                      BUG4227
     C**********         EXSR      SNDMSG                                                    BUG4227
     C**********         EXSR      RETURN                                                    BUG4227
     C**********         ENDIF                                                               BUG4227
      **********                                                                             BUG4227
     C*****P#RATE        WHENLT    ZRATEX                                                    BUG4227
     C*****1             SUB       P#RTDS        P#RTDS                                      BUG4227
     C*****ZRATEX        MULT(H)   P#RTDS        NEWRAT                                      BUG4227
     C*****1             SUB       P#RTDS        P#RTDS                                      BUG4227
     C*****P#RATE        IFLT      NEWRAT                                                    BUG4227
     C**********         MOVE      *ON           *IN05                                       BUG4227
     C**********         MOVEL     'FTM2578'     FTMSID                                      BUG4227
     C**********         EXSR      SNDMSG                                                    BUG4227
     C**********         EXSR      RETURN                                                    BUG4227
     C**********         ENDIF                                                               BUG4227
     C**********         ENDSL                                                               BUG4227
      *
     C**********         ENDIF                                                              AR737259
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DLVAMT - Delivery Amounts                                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  CHKDUP - Check for duplicate Currencies                      *
      *  DLVAM1 - Delivery Amount (First 2 Currencies)                *
      *  CHKDUP - Check for duplicate Currencies                      *
      *  DLVAM1 - Delivery Amount (Second 2 Currencies)               *
      *                                                               *
      *****************************************************************
      *
     C     DLVAMT        BEGSR
     C                   EXSR      CHKDUP
     C                   EXSR      DLVAM1
     C                   EXSR      CHKDUP
     C                   EXSR      DLVAM2
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKDUP - If Currency is duplicated, the corresponding        *
      *           amounts (if non-zero) must be equal.                *
      *                                                               *
      *  Called By: DLVAMT                                            *
      *  Calls:                                                       *
      *  SNDMSG - Send Messages.                                      *
      *  RETURN - Return control.                                     *
      *                                                               *
      *****************************************************************
      *
     C     CHKDUP        BEGSR
      *
      ** If both currencies are the same then so must be the amounts,
      ** otherwise it's an error.
      *
     C                   DO        2             X
     C     CCY(X)        IFEQ      *BLANKS
     C                   ITER
     C                   ENDIF
      *
     C     X             ADD       1             Z                 1 0
     C     CCY(X)        LOOKUP    CCY(Z)                                 06
     C     *IN06         IFEQ      *ON
     C                   SELECT
     C     AMNT(X)       WHENEQ    *ZERO
     C                   Z-ADD     AMNT(Z)       AMNT(X)
     C     AMNT(Z)       WHENEQ    *ZERO
     C                   Z-ADD     AMNT(X)       AMNT(Z)
     C     AMNT(X)       WHENNE    AMNT(Z)
     C                   MOVE      *ON           *IN(X)
     C                   MOVE      *ON           *IN(Z)
     C                   MOVEL     'FTM2579'     FTMSID
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DLVAM1 - Check and convert first 2 currency amounts.         *
      *                                                               *
      *  Called By: DLVAMT                                            *
      *  Calls:                                                       *
      *  CONVRT - Convert amount from 'From Ccy' to 'To Ccy'          *
      *  SNDMSG - Send Messages.                                      *
      *  RETURN - Return control.                                     *
      *                                                               *
      *****************************************************************
      *
     C     DLVAM1        BEGSR
      *
      ** Check first 2 currency amounts.
      *
     C                   Z-ADD     A             F                 1 0
     C                   SELECT
     C     A             WHENEQ    1
     C                   Z-ADD     2             T                 1 0
     C     A             WHENEQ    2
     C                   Z-ADD     1             T
     C     A             WHENEQ    3
     C                   Z-ADD     4             T
     C     A             WHENEQ    4
     C                   Z-ADD     3             T
     C                   ENDSL
     C     CCY(T)        IFNE      *BLANKS
      *
      ** Convert 'From amount' to 'To Currency' amount.
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(T)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
      *
     C                   SELECT
     C     AMNT(T)       WHENEQ    *ZERO
     C                   Z-ADD     P@OUTA        AMNT(T)
     C     T             IFEQ      2
     C     T             OREQ      3
     C                   Z-ADD     P@INTA        INTA(T)
     C                   ENDIF
     C     AMNT(T)       WHENNE    *ZERO
     C     AMNT(T)       ANDNE     P@OUTA
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(T)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(T)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(F)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
     C     AMNT(F)       IFNE      P@OUTA
     C     F             IFEQ      1
     C     F             OREQ      2
     C     P#PMSQ        IFEQ      'FT0050'                                    CFT014
     C                   MOVEL     'FTM3257'     FTMSID                        CFT014
     C                   ELSE                                                  CFT014
     C                   MOVEL     'FTM2580'     FTMSID
     C                   ENDIF                                                 CFT014
     C                   MOVE      *ON           *IN01
     C                   MOVE      *ON           *IN02
     C                   ELSE
     C     P#PMSQ        IFEQ      'FT0040'                                    CFT014
     C                   MOVEL     'FTM3258'     FTMSID                        CFT014
     C                   ELSE                                                  CFT014
     C                   MOVEL     'FTM2581'     FTMSID
     C                   ENDIF                                                 CFT014
     C                   MOVE      *ON           *IN03
     C                   MOVE      *ON           *IN04
     C                   ENDIF
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DLVAM2 - Check and convert second 2 currency amounts.        *
      *                                                               *
      *  Called By: DLVAMT                                            *
      *  Calls:                                                       *
      *  CONVRT - Convert amount from 'From Ccy' to 'To Ccy'          *
      *  SNDMSG - Send Messages.                                      *
      *  RETURN - Return control.                                     *
      *                                                               *
      *****************************************************************
      *
     C     DLVAM2        BEGSR
      *
      ** Check second 2 currency amounts.
      *
     C                   SELECT
     C     A             WHENLT    3
     C     AMNT(3)       IFNE      *ZERO
     C                   Z-ADD     3             F
     C                   Z-ADD     4             T
     C                   ELSE
     C                   Z-ADD     4             F
     C                   Z-ADD     3             T
     C                   ENDIF
      *
     C     A             WHENGT    2
     C     AMNT(1)       IFNE      *ZERO
     C                   Z-ADD     1             F
     C                   Z-ADD     2             T
     C                   ELSE
     C                   Z-ADD     2             F
     C                   Z-ADD     1             T
     C                   ENDIF
      *
     C                   ENDSL
      *
     C     CCY(T)        IFNE      *BLANKS
     C     CCY(F)        ANDNE     *BLANKS
      *
      ** Convert 'From amount' to 'To Currency' amount.
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C     INTA(F)       IFNE      *ZERO
     C                   Z-ADD     INTA(F)       W#EAMT
     C                   ELSE
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   ENDIF
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(T)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
      *
     C                   SELECT
     C     AMNT(T)       WHENEQ    *ZERO
     C                   Z-ADD     P@OUTA        AMNT(T)
     C     T             IFEQ      2
     C     T             OREQ      3
     C                   Z-ADD     P@INTA        INTA(T)
     C                   ENDIF
     C     AMNT(T)       WHENNE    *ZERO
     C     AMNT(T)       ANDNE     P@OUTA
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(T)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(T)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(F)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
     C     AMNT(F)       IFNE      P@OUTA
     C     F             IFEQ      1
     C     F             OREQ      2
     C                   MOVEL     'FTM2581'     FTMSID
     C                   MOVE      *ON           *IN01
     C                   MOVE      *ON           *IN02
     C                   ELSE
     C                   MOVEL     'FTM2582'     FTMSID
     C                   MOVE      *ON           *IN03
     C                   MOVE      *ON           *IN04
     C                   ENDIF
     C                   SETON                                        55                    MD050134
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   SETOFF                                       55                    MD050134
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  TRNAMT - Transaction Amount                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  CONVRT - Convert amount from 'From Ccy' to 'To Ccy'          *
      *  SNDMSG - Send Messages.                                      *
      *  RETURN - Return control.                                     *
      *                                                               *
      *****************************************************************
      *
      ** Debit amount is verified against or calculated from Credit
      ** amount or vice versa.
      *
     C     TRNAMT        BEGSR
     C                   SELECT
     C     CCY(2)        WHENEQ    *BLANKS
     C     CCY(3)        OREQ      *BLANKS
      *
     C     CCY(2)        WHENEQ    CCY(3)
     C     CCY(2)        OREQ      CCY(4)
     C     CCY(3)        OREQ      CCY(1)
     C     CCY(1)        OREQ      CCY(4)
     C     CCY(1)        ANDNE     *BLANKS
      *                                                                                       194316
     C     CEU006        IFEQ      'N'                                                        194316
      *                                                                                       194316
     C     CCY(2)        IFEQ      CCY(3)                                                     194316
     C     AMNT(2)       ANDEQ     *ZERO                                                      194316
     C     AMNT(3)       ANDNE     *ZERO                                                      194316
     C                   Z-ADD     AMNT(3)       AMNT(2)                                      194316
     C                   ENDIF                                                                194316
      *                                                                                       194316
     C     CCY(2)        IFEQ      CCY(3)                                                     194316
     C     AMNT(3)       ANDEQ     *ZERO                                                      194316
     C     AMNT(2)       ANDNE     *ZERO                                                      194316
     C                   Z-ADD     AMNT(2)       AMNT(3)                                      194316
     C                   ENDIF                                                                194316
      *                                                                                       194316
     C                   ENDIF                                                                194316
      *
     C     TYPE(2)       WHENEQ    'EU'
     C     TYPE(3)       ANDEQ     'IN'
     C     TYPE(2)       OREQ      'IN'
     C     TYPE(3)       ANDEQ     'EU'
      *
      ** Convert 'From amount' to 'To Currency' amount.
      ** From Euro to 'IN' or from 'IN' to Euro.
      *
     C     AMNT(2)       IFNE      *ZERO
     C                   Z-ADD     2             F
     C                   Z-ADD     3             T
     C                   ELSE
     C                   Z-ADD     3             F
     C                   Z-ADD     2             T
     C                   ENDIF
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C     INTA(F)       IFNE      *ZERO
     C                   Z-ADD     INTA(F)       W#EAMT
     C                   ELSE
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   ENDIF
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(T)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
      *
     C                   SELECT
     C     AMNT(T)       WHENEQ    *ZERO
     C                   Z-ADD     P@OUTA        AMNT(T)
     C     T             IFEQ      2
     C     T             OREQ      3
     C                   Z-ADD     P@INTA        INTA(T)
     C                   ENDIF
      *
     C     AMNT(T)       WHENNE    *ZERO
     C     AMNT(T)       ANDNE     P@OUTA
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(T)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(T)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(F)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
     C     AMNT(F)       IFNE      P@OUTA
     C                   MOVE      *ON           *IN(2)
     C                   MOVE      *ON           *IN(3)
     C                   MOVEL     'FTM2582'     FTMSID
     C                   SETON                                        55                    MD050134
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   SETOFF                                       55                    MD050134
     C                   ENDIF
     C                   ENDSL
      *
     C     TYPE(2)       WHENEQ    'IN'
     C     TYPE(3)       ANDEQ     'IN'
     C                   SELECT
     C     AMNT(2)       WHENEQ    *ZERO
     C     AMNT(3)       OREQ      *ZERO
      *
      ** Convert 'From amount' to 'To Currency' amount.
      ** For 'IN' to 'IN' by calling EU0200 twice.
      *
     C     AMNT(2)       IFNE      *ZERO
     C                   Z-ADD     2             F
     C                   Z-ADD     3             T
     C                   ELSE
     C                   Z-ADD     3             F
     C                   Z-ADD     2             T
     C                   ENDIF
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C     INTA(F)       IFNE      *ZERO
     C                   Z-ADD     INTA(F)       W#EAMT
     C                   ELSE
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   ENDIF
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      BKEURO        W#STCY                         TO Euros
     C                   EXSR      CONVRT
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     P@INTA        W#EAMT                         FROM Ccy Amount
     C                   MOVE      BKEURO        W#TRCY                         FROM Euros
     C                   MOVE      CCY(T)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
     C                   Z-ADD     P@OUTA        AMNT(T)
     C     T             IFEQ      2
     C     T             OREQ      3
     C                   Z-ADD     P@INTA        INTA(T)
     C                   ENDIF
      *
     C     CCY(1)        WHENEQ    BKEURO
      *
      ** Convert 'From amount' to 'To Currency' amount.
      ** From Euro to 'IN' or from 'IN' to Euro for Notify Delivery
      ** and Credit amounts.
      *
     C     AMNT(1)       IFNE      *ZERO
     C                   Z-ADD     1             F
     C                   Z-ADD     3             T
     C                   ELSE
     C                   Z-ADD     3             F
     C                   Z-ADD     1             T
     C                   ENDIF
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C     INTA(F)       IFNE      *ZERO
     C                   Z-ADD     INTA(F)       W#EAMT
     C                   ELSE
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   ENDIF
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(T)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
      *
     C                   SELECT
     C     AMNT(T)       WHENEQ    *ZERO
     C                   Z-ADD     P@OUTA        AMNT(T)
     C     T             IFEQ      2
     C     T             OREQ      3
     C                   Z-ADD     P@INTA        INTA(T)
     C                   ENDIF
      *
     C     AMNT(T)       WHENNE    *ZERO
     C     AMNT(T)       ANDNE     P@OUTA
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(T)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(T)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(F)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
     C     AMNT(F)       IFNE      P@OUTA
     C                   MOVE      *ON           *IN(2)
     C                   MOVE      *ON           *IN(3)
     C                   MOVEL     'FTM2582'     FTMSID
     C                   SETON                                        55                    MD050134
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   SETOFF                                       55                    MD050134
     C                   ENDIF
     C                   ENDSL
      *
     C     CCY(4)        WHENEQ    BKEURO
      *
      ** Convert 'From amount' to 'To Currency' amount.
      ** From Euro to 'IN' or from 'IN' to Euro for Pay Delivery
      ** and Debit amounts.
      *
     C                   Z-ADD     2             F
     C                   Z-ADD     4             T
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C     INTA(F)       IFNE      *ZERO
     C                   Z-ADD     INTA(F)       W#EAMT
     C                   ELSE
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   ENDIF
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(T)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
      *
     C                   SELECT
     C     AMNT(T)       WHENEQ    *ZERO
     C                   Z-ADD     P@OUTA        AMNT(T)
     C     T             IFEQ      2
     C     T             OREQ      3
     C                   Z-ADD     P@INTA        INTA(T)
     C                   ENDIF
     C     AMNT(T)       WHENNE    *ZERO
     C     AMNT(T)       ANDNE     P@OUTA
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(T)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(T)        W#TRCY                         FROM Currency
     C                   MOVE      CCY(F)        W#STCY                         TO Currency
     C                   EXSR      CONVRT
     C     AMNT(F)       IFNE      P@OUTA
     C                   MOVE      *ON           *IN(2)
     C                   MOVE      *ON           *IN(3)
     C                   MOVEL     'FTM2582'     FTMSID
     C                   SETON                                        55                    MD050134
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   SETOFF                                       55                    MD050134
     C                   ENDIF
     C                   ENDSL
      *
     C                   OTHER
      *
      ** Otherwise if Debit and Credit amounts are entered and both are
      ** 'IN' currencies ' and niether Pay delivery nor Notify delivery
      ** are Euros. Then calculate amounts within upper and lower ranges.
      *
     C                   Z-ADD     2             F
     C                   Z-ADD     3             T
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(F)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(F)        W#TRCY                         FROM Currency
     C                   MOVE      BKEURO        W#STCY                         Euro Currency
     C                   EXSR      CONVRT
      *
      ** Calculate the upper and lower bounderies for Debit to
      ** Credit amounts.
      *
     C                   Z-ADD(H)  P@INTA        INTERI           18 1
     C     INTERI        ADD       0.05          INTER1
     C     INTERI        SUB       0.05          INTER2
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     INTER1        W#EAMT                         FROM Ccy Amount
     C                   MOVE      BKEURO        W#TRCY                         Euro Currency
     C                   MOVE      CCY(T)        W#STCY                         To Currency
     C                   EXSR      CONVRT
     C                   Z-ADD     P@OUTA        UPPER
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     INTER2        W#EAMT                         FROM Ccy Amount
     C                   MOVE      BKEURO        W#TRCY                         Euro Currency
     C                   MOVE      CCY(T)        W#STCY                         To Currency
     C                   EXSR      CONVRT
     C                   Z-ADD     P@OUTA        LOWER
      *
     C     AMNT(T)       IFGT      UPPER
     C     AMNT(T)       ORLT      LOWER
      *
      ** If the amount is outside the bounderies, calculate in
      ** the opposite direction.
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     AMNT(T)       W#EAMT                         FROM Ccy Amount
     C                   MOVE      CCY(T)        W#TRCY                         FROM Currency
     C                   MOVE      BKEURO        W#STCY                         Euro Currency
     C                   EXSR      CONVRT
      *
      ** Calculate the upper and lower bounderies for Credit to
      ** Debit amounts.
      *
     C                   Z-ADD     P@INTA        INTERI
     C     INTERI        ADD       0.05          INTER1
     C     INTERI        SUB       0.05          INTER2
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     INTER1        W#EAMT                         FROM Ccy Amount
     C                   MOVE      BKEURO        W#TRCY                         Euro Currency
     C                   MOVE      CCY(F)        W#STCY                         To Currency
     C                   EXSR      CONVRT
     C                   Z-ADD     P@OUTA        UPPER
      *
     C                   MOVE      *BLANKS       W#TRCY                         FROM Currency
     C                   MOVE      *BLANKS       W#STCY                         TO Currency
     C                   Z-ADD     INTER2        W#EAMT                         FROM Ccy Amount
     C                   MOVE      BKEURO        W#TRCY                         Euro Currency
     C                   MOVE      CCY(F)        W#STCY                         To Currency
     C                   EXSR      CONVRT
     C                   Z-ADD     P@OUTA        LOWER
      *
     C     AMNT(F)       IFGT      UPPER
     C     AMNT(F)       ORLT      LOWER
     C                   MOVE      *ON           *IN(2)
     C                   MOVE      *ON           *IN(3)
     C                   SETON                                        55                    MD050134
     C                   MOVEL     'FTM2582'     FTMSID
     C                   EXSR      SNDMSG
     C                   SETOFF                                       55                    MD050134
     C                   EXSR      RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
      * Verify/calculate the remaining cases using rate passed
      * if non-zero, or the calculated rate.
     C                   OTHER
      *
     C     P#RATE        IFNE      *ZERO
     C                   Z-ADD     P#RATE        ZCRSRT                         Cross Ccy Exch
      *                                                                                     MD045094
      ** If rate is inverse, use the original rate for calculation,                         MD045094
      ** then inverse M/D indicator for precision                                           MD045094
      *                                                                                     MD045094
     C                   IF        WINVER = 'Y'                                             MD045094
     C                   EVAL      ZCRSRT = WGRATE                                          MD045094
     C     ZMDIX         IFEQ      'M'                                                      MD045094
     C                   MOVE      'D'           ZMDIX                                      MD045094
     C                   ELSE                                                               MD045094
     C                   MOVE      'M'           ZMDIX                                      MD045094
     C                   ENDIF                                                              MD045094
     C                   ENDIF                                                              MD045094
      *                                                                                     MD045094
     C                   ELSE
     C                   Z-ADD     ZRATEX        ZCRSRT
     C                   ENDIF
      *
     C     AMNT(2)       IFNE      *ZERO
     C                   Z-ADD     2             F
     C                   Z-ADD     3             T
     C                   MOVE      ZMDIX         ZCRSMD                         Cross Ccy M/D
     C                   ELSE
     C                   Z-ADD     3             F
     C                   Z-ADD     2             T
     C     ZMDIX         IFEQ      'M'
     C                   MOVE      'D'           ZCRSMD
     C                   ELSE
     C                   MOVE      'M'           ZCRSMD
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     AMNT(F)       ZAMTF                          FROM Ccy Amount
     C                   MOVE      NBDP(F)       ZCDPF                          FROM Ccy d.p.
     C                   MOVE      NBDP(T)       ZCDPT                          TO Ccy d.p.
     C                   EXSR      ZCCYXR
     C                   IF        CRE072 = 'Y'                                               CRE072
     C                   EXSR      SETHILO                                                    CRE072
     C                   ENDIF                                                                CRE072
      *
     C                   SELECT
     C     AMNT(T)       WHENEQ    *ZERO
     C                   Z-ADD     ZAMTT         AMNT(T)
      *
     C*****AMNT(T)       WHENNE    ZAMTT                                                      CRE072
     C                   WHEN      AMNT(T) <> ZAMTT AND                                       CRE072
     C                             (CRE072 = 'N' OR                                           CRE072
      *                                                                                       CRE072
      ** If CRE072 is ON, check if amount is not within tolerance                             CRE072
      *                                                                                       CRE072
     C                             (CRE072 = 'Y' AND                                          CRE072
     C                               (AMNT(T) > ZAMTTHI OR AMNT(T) < ZAMTTLO)))               CRE072
      *
      * The entered amount is not equal to the calculated amount;
      * try the calculation in the opposite direction in case this
      * is due to rounding.
     C     F             IFEQ      3
     C                   Z-ADD     2             F
     C                   Z-ADD     3             T
     C                   MOVE      ZMDIX         ZCRSMD                         Cross Ccy M/D
     C                   ELSE
     C                   Z-ADD     3             F
     C                   Z-ADD     2             T
     C     ZMDIX         IFEQ      'M'
     C                   MOVE      'D'           ZCRSMD
     C                   ELSE
     C                   MOVE      'M'           ZCRSMD
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     AMNT(F)       ZAMTF                          FROM Ccy Amount
     C                   MOVE      NBDP(F)       ZCDPF                          FROM Ccy d.p.
     C                   MOVE      NBDP(T)       ZCDPT                          TO Ccy d.p.
     C                   EXSR      ZCCYXR
      *                                                                                       258369
      ** If amounts still don't agree, try the inverse rate.                                  258369
      *                                                                                       258369
     C     AMNT(T)       IFNE      ZAMTT                                                      258369
     C                   EXSR      SrVAmtInvR                                                 258369
     C                   ENDIF                                                                258369
      *                                                                                       258369
      ** If amounts still don't agree, try the rate with 9 decimal places                   MD053553
      *                                                                                     MD053553
     C     AMNT(T)       IFNE      ZAMTT                                                    MD053553
     C                   EXSR      SrVAmtNR9D                                               MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C                   IF        CRE072 = 'Y'                                               CRE072
     C                   EXSR      SETHILO                                                    CRE072
     C                   ENDIF                                                                CRE072
      *
     C*****AMNT(T)       IFNE      ZAMTT                                                      CRE072
     C                   IF        AMNT(T) <> ZAMTT AND                                       CRE072
     C                             (CRE072 = 'N' OR                                           CRE072
      *                                                                                       CRE072
      ** If CRE072 is ON, check if amount is not within tolerance                             CRE072
      *                                                                                       CRE072
     C                             (CRE072 = 'Y' AND                                          CRE072
     C                               (AMNT(T) > ZAMTTHI OR AMNT(T) < ZAMTTLO)))               CRE072
      *                                                                                       CRE072
     C                   MOVE      *ON           *IN(2)
     C                   MOVE      *ON           *IN(3)
     C                   MOVEL     'FTM2582'     FTMSID
     C                   SETON                                        55                    MD050134
     C                   EXSR      SNDMSG
     C                   EXSR      RETURN
     C                   SETOFF                                       55                    MD050134
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SETHILO - Set higher and lower tolerance of the amount       *                       CRE072
      *                                                               *                       CRE072
      *  Called By: TRNAMT                                            *                       CRE072
      *  Calls: none                                                  *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
      *                                                                                       CRE072
     C     SETHILO       BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Set upper tolerance                                                                  CRE072
      *                                                                                       CRE072
     C     1             DIV       ZRATEX        ZTOL             13 8                        CRE072
      *                                                                                       CRE072
      ** Set upper tolerance                                                                  CRE072
      *                                                                                       CRE072
     C     ZAMTT         ADD       ZTOL          ZAMTTHI          15 0                        CRE072
      *                                                                                       CRE072
      ** Set lower tolerance                                                                  CRE072
      *                                                                                       CRE072
     C     ZAMTT         SUB       ZTOL          ZAMTTLO          15 0                        CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *                                                                                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************
      *                                                               *
      *  CONVRT - Subroutine to Call EU0200                           *
      *                                                               *
      *  Called By: DLVAM1, DLVAM2                                    *
      *  Calls:                                                       *
      *  EU0200 - Convert amount from 'From Ccy' to 'To Ccy'          *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
      ** Convert 'From amount' to 'To Currency' amount.
      *
     C     CONVRT        BEGSR
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       P@RTCD            7            Return Code
     C                   PARM      W#EAMT        P@FRAM           18 3          FROM Ccy Amount
     C                   PARM      W#TRCY        P@FRCY            3            FROM Currency
     C                   PARM      W#STCY        P@TOCY            3            TO Currency
     C                   PARM                    P@OUTA           15 0          Outright Amount
     C                   PARM                    P@INTA           18 3          Interim Amount
     C                   PARM                    P@EXRT           15 9          Exchange Rate
     C                   PARM                    P@MDIN            1            Mult/Div Ind
     C     P@RTCD        IFEQ      '*ERROR*'
     C     *LOCK         IN        LDA
     C                   Z-ADD     006           DBASE
     C                   MOVEL     *BLANKS       DBFILE                         ***************
     C                   MOVEL     'EU0200  '    DBFILE                         *DB ERROR 006 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   MOVEL     *BLANKS       W@OPTN            7
     C                   MOVEL     P@FRCY        W@OPTN
     C                   MOVE      P@TOCY        W@OPTN
     C                   MOVEL     W@OPTN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SNDMSG - Subroutine to do send messages                      *
      *                                                               *
      *  Called By:                                                   *
      *  CHKAM1, CHKRAT, CHKDUP, DLVAM1, DLVAM2, TRNAMT               *
      *  Calls:                                                       *
      *  AOCREPT Access Program (General Ledger)                      *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
     C     SNDMSG        BEGSR
      *
     C                   CALL      'AOCREPT'
     C                   PARM                    FTMSID            7
     C                   PARM      'FTUSRMSG'    FTMSGF           10
     C                   PARM                    FTMSFL           10
     C                   PARM                    FTMSDT          256
     C                   PARM      '*SAME'       FTPGRL            5
     C                   PARM      P#PMSQ        FTPGMQ           10
     C                   PARM                    FTMSGQ           10
     C                   PARM                    FTMSGT            7
      *
      ** Clear all fields for default mechanism next time
      *
     C******               MOVEL*BLANK    FTMSID           CAP031
     C                   MOVEL     *BLANK        FTMSFL
     C                   MOVEL     *BLANK        FTMSDT
     C                   MOVEL     *BLANK        FTPGMQ
     C                   MOVEL     *BLANK        FTMSGQ
     C                   MOVEL     *BLANK        FTMSGT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #XRATE - Subroutine to calculate cross rate                  *
      *                                                               *
      *  Called By: CHKRAT                                            *
      *  Calls:                                                       *
      *        None                                                   *
      *                                                               *
      *        Based on core sr/zxrate.                               *
     C*****************************************************************
     C*
     C     #XRATE        BEGSR
     C*
     C                   Z-ADD     *ZEROS        ZRATEX           13 8
     C*
     C** CALCULATE CROSS RATE
     C*
     C*    ..  IF M/D INDICATOR 1 = M/D INDICATOR 2
     C*
     C     ZMDI1         IFEQ      ZMDI2
     C     ZRATE1        DIV(H)    ZRATE2        ZRATEX
     C*
     C                   ELSE
     C*    ..  ELSE
     C*
     C     ZRATE1        MULT(H)   ZRATE2        ZRATEX
     C                   END
     C*
     C** SET CROSS M/D INDICATOR
     C*
     C                   MOVE      ZMDI1         ZMDIX             1
     C*
     C                   ENDSR
     C*
      *****************************************************************                       258369
      *                                                               *                       258369
      *  SrVAmtInvR- Validate amounts using the inverse of the rate.  *                       258369
      *                                                               *                       258369
      *  Called By: TRNAMT                                            *                       258369
      *  Calls: None                                                  *                       258369
      *                                                               *                       258369
      *****************************************************************                       258369
     C     SrVAmtInvR    BEGSR                                                                258369
      *                                                                                       258369
     C     AMNT(2)       IFNE      *ZERO                                                      258369
     C                   Z-ADD     2             F                                            258369
     C                   Z-ADD     3             T                                            258369
     C                   MOVE      ZMDIX         ZCRSMD                                       258369
     C                   ELSE                                                                 258369
     C                   Z-ADD     3             F                                            258369
     C                   Z-ADD     2             T                                            258369
     C     ZMDIX         IFEQ      'M'                                                        258369
     C                   MOVE      'D'           ZCRSMD                                       258369
     C                   ELSE                                                                 258369
     C                   MOVE      'M'           ZCRSMD                                       258369
     C                   ENDIF                                                                258369
     C                   ENDIF                                                                258369
      *                                                                                       258369
      ** Inverse the operation instead of the rate to retain precision.                       258369
      *                                                                                       258369
     C     ZCRSMD        IFEQ      'M'                                                        258369
     C                   MOVE      'D'           ZCRSMD                                       258369
     C                   ELSE                                                                 258369
     C                   MOVE      'M'           ZCRSMD                                       258369
     C                   ENDIF                                                                258369
      *                                                                                       258369
     C                   Z-ADD     AMNT(F)       ZAMTF                                        258369
     C                   MOVE      NBDP(F)       ZCDPF                                        258369
     C                   MOVE      NBDP(T)       ZCDPT                                        258369
     C                   EXSR      ZCCYXR                                                     258369
      *                                                                                       258369
     C     AMNT(T)       IFNE      ZAMTT                                                      258369
      *                                                                                       258369
      ** The entered amount is not equal to the calculated amount                             258369
      ** try the calculation in the opposite direction in case this                           258369
      ** is due to rounding.                                                                  258369
      *                                                                                       258369
     C     F             IFEQ      3                                                          258369
     C                   Z-ADD     2             F                                            258369
     C                   Z-ADD     3             T                                            258369
     C                   MOVE      ZMDIX         ZCRSMD                                       258369
     C                   ELSE                                                                 258369
     C                   Z-ADD     3             F                                            258369
     C                   Z-ADD     2             T                                            258369
     C     ZMDIX         IFEQ      'M'                                                        258369
     C                   MOVE      'D'           ZCRSMD                                       258369
     C                   ELSE                                                                 258369
     C                   MOVE      'M'           ZCRSMD                                       258369
     C                   ENDIF                                                                258369
     C                   ENDIF                                                                258369
      *                                                                                       258369
      ** Inverse the operation instead of the rate to retain precision.                       258369
      *                                                                                       258369
     C     ZCRSMD        IFEQ      'M'                                                        258369
     C                   MOVE      'D'           ZCRSMD                                       258369
     C                   ELSE                                                                 258369
     C                   MOVE      'M'           ZCRSMD                                       258369
     C                   ENDIF                                                                258369
      *                                                                                       258369
     C                   Z-ADD     AMNT(F)       ZAMTF                                        258369
     C                   MOVE      NBDP(F)       ZCDPF                                        258369
     C                   MOVE      NBDP(T)       ZCDPT                                        258369
     C                   EXSR      ZCCYXR                                                     258369
      *                                                                                       258369
     C                   ENDIF                                                                258369
      *                                                                                       258369
     C                   ENDSR                                                                258369
      *                                                                                     MD053553
      *****************************************************************                     MD053553
      *                                                               *                     MD053553
      *  SrVAmtNR9D - Validate amounts using rate with 9 decimal      *                     MD053553
      *           places                                              *                     MD053553
      *                                                               *                     MD053553
      *  Called By:TRNAMT                                             *                     MD053553
      *  Calls: SrCalcAmnt                                            *                     MD053553
      *                                                               *                     MD053553
      *****************************************************************                     MD053553
     C     SrVAmtNR9D    BEGSR                                                              MD053553
      *                                                                                     MD053553
      ** Get 9th decimal place from the input amounts                                       MD053553
      *                                                                                     MD053553
     C                   EVAL      NRATE = AMNT(T) / AMNT(F)                                MD053553
     C                   MOVE      NRATE         D9                                         MD053553
     C                   MOVEL     P#RATE        NRATE                                      MD053553
      *                                                                                     MD053553
      ** Adjustment if original exchange rate was rounded up.                               MD053553
      *                                                                                     MD053553
     C                   IF        D9 > 4                                                   MD053553
     C                   EVAL      NRATE -= 0.00000001                                      MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C                   EXSR      SrCalcAmnt                                               MD053553
      *                                                                                     MD053553
     C     AMNT(T)       IFNE      ZAMTT                                                    MD053553
      *                                                                                     MD053553
     C                   IF        ZCRSMD = 'M'                                             MD053553
     C                   EVAL      ZCRSMD = 'D'                                             MD053553
     C                   ELSE                                                               MD053553
     C                   EVAL      ZCRSMD = 'M'                                             MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C                   EXSR      SrCalcAmnt                                               MD053553
     C                   ELSE                                                               MD053553
     C                   LEAVESR                                                            MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
      ** Input amounts may have been reversed.                                              MD053553
      *                                                                                     MD053553
     C     AMNT(T)       IFNE      ZAMTT                                                    MD053553
      *                                                                                     MD053553
     C                   IF        F = 2                                                    MD053553
     C                   EVAL      F = 3                                                    MD053553
     C                   EVAL      T = 2                                                    MD053553
     C                   ELSE                                                               MD053553
     C                   EVAL      F = 2                                                    MD053553
     C                   EVAL      T = 3                                                    MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
      ** Get 9th decimal place from the input amounts                                       MD053553
      *                                                                                     MD053553
     C                   EVAL      NRATE = AMNT(T) / AMNT(F)                                MD053553
     C                   MOVE      NRATE         D9                                         MD053553
     C                   MOVEL     P#RATE        NRATE                                      MD053553
      *                                                                                     MD053553
      ** Adjustment if original exchange rate was rounded up.                               MD053553
      *                                                                                     MD053553
     C                   IF        D9 > 4                                                   MD053553
     C                   EVAL      NRATE -= 0.00000001                                      MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C                   EXSR      SrCalcAmnt                                               MD053553
     C                   ELSE                                                               MD053553
     C                   LEAVESR                                                            MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C     AMNT(T)       IFNE      ZAMTT                                                    MD053553
      *                                                                                     MD053553
     C                   IF        ZCRSMD = 'M'                                             MD053553
     C                   EVAL      ZCRSMD = 'D'                                             MD053553
     C                   ELSE                                                               MD053553
     C                   EVAL      ZCRSMD = 'M'                                             MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C                   EXSR      SrCalcAmnt                                               MD053553
     C                   ENDIF                                                              MD053553
     C                   ENDSR                                                              MD053553
      *                                                                                     MD053553
      *****************************************************************                     MD053553
      *                                                               *                     MD053553
      *  SrCalcAmnt - Calculates amount based M/D Indicator           *                     MD053553
      *                                                               *                     MD053553
      *  Called By: SrVAmtNR9D                                        *                     MD053553
      *  Calls: None                                                  *                     MD053553
      *                                                               *                     MD053553
      *****************************************************************                     MD053553
     C     SrCalcAmnt    BEGSR                                                              MD053553
     C                   IF        ZCRSMD = 'M'                                             MD053553
     C                   Z-ADD     AMNT(F)       ZAMTT                                      MD053553
     C                   EVAL(H)   ZAMTT *= NRATE                                           MD053553
     C                   ENDIF                                                              MD053553
      *                                                                                     MD053553
     C                   IF        ZCRSMD = 'D'                                             MD053553
     C                   Z-ADD     AMNT(F)       ZAMTT                                      MD053553
     C                   EVAL(H)   ZAMTT /= NRATE                                           MD053553
     C                   ENDIF                                                              MD053553
     C                   ENDSR                                                              MD053553
      /EJECT
      *****************************************************************
      *                                                               *
      *  RETURN - Sets parameters to be returned and returns control  *
      *           to calling program.                                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     RETURN        BEGSR
      *
      ***  Setup array AMNT output.
      *
     C                   Z-ADD     AMNT(1)       P#NDAM
     C                   Z-ADD     AMNT(2)       P#DBAM
     C                   Z-ADD     AMNT(3)       P#CRAM
     C                   Z-ADD     AMNT(4)       P#PDAM
     C                   Z-ADD     INTA(2)       P#INTD
     C                   Z-ADD     INTA(3)       P#INTC
     C     P#RATE        IFEQ      *ZERO
     C                   Z-ADD     ZRATEX        P#RATE
     C                   ENDIF
     C     ZMDIX         IFEQ      'M'
     C                   Z-ADD     1             P#MDIN
     C                   ELSE
     C                   Z-ADD     0             P#MDIN
     C                   ENDIF
     C     WGRATE        IFGT      *ZERO                                                    AR787421
     C                   Z-ADD     WGRATE        P#RATE                                     AR787421
     C                   ENDIF                                                              AR787421
     C     P#PMSQ        IFEQ      'FT0070'                                                   196950
     C     TYPE(2)       ANDEQ     'IN'                                                       196950
     C     TYPE(3)       ANDEQ     'EU'                                                       196950
     C     P#PMSQ        OREQ      'FT0070'                                                   196950
     C     TYPE(2)       ANDEQ     'EU'                                                       196950
     C     TYPE(3)       ANDEQ     'IN'                                                       196950
     C     P#MDIN        IFEQ      0                                                          196950
     C                   Z-ADD     1             P#MDIN                                       196950
     C                   ELSE                                                                 196950
     C                   Z-ADD     0             P#MDIN                                       196950
     C                   END                                                                  196950
     C                   END                                                                  196950
     C     P#PMSQ        IFEQ      'FT0080'                                                   171706
     C     *IN07         ANDEQ     '1'                                                        171706
     C     P#MDIN        IFEQ      0                                                          171706
     C                   Z-ADD     1             P#MDIN                                       171706
     C                   ELSE                                                                 171706
     C                   Z-ADD     0             P#MDIN                                       171706
     C                   ENDIF                                                                171706
     C                   ENDIF                                                                171706
     C                   MOVEA     *IN           P#INDC
      *
     C     P#PMSQ        IFEQ      W1PMSQ                                       CAP031
     C     P#PMSQ        OREQ      W2PMSQ                                       CAP031
     C     P#PMSQ        OREQ      W3PMSQ                                       CAP136
     C     P#PMSQ        OREQ      W4PMSQ                                       CFT014
     C     *IN55         IFEQ      *OFF                                                     MD050134
     C                   MOVE      *BLANKS       P#PMSQ                         CAP031
     C                   MOVEL     FTMSID        P#PMSQ                         CAP031
     C                   ENDIF                                                              MD050134
     C                   ENDIF                                                  CAP031
      *                                                                         187222
      * If P#PMSQ is equal to 'PassBack' blank out                              187222
      *                                                                         187222
     C                   IF        ##PMSQ = 'PassBack'                          187222
     C                   Eval      P#PMSQ = FTMSID                              187222
     C                   Endif                                                  187222
      *                                                                                     MD030406
     C     *IN55         IFEQ      *OFF                                                     MD030406
     C                   RETURN
     C                   ENDIF                                                              MD030406
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVEL     '*ERROR*'     P#RTCD
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
     C/COPY WNCPYSRC,FT0010C010
      ********************************************************************
      ** +--- The converted ZCCYXR starts here ----------------------------+
      /COPY ZSRSRC,ZCCYXR_ILE
      ** +--- The converted ZCCYXR ends here ------------------------------+
**  CPY@
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
