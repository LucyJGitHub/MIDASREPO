     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Display')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Market Price API                 *
      *                                                               *
      *  FFMPRIDSP - Midas FF Market Price Details Display            *
      *                                                               *
      *  Function:  This module displays the Market Prices            *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 245143             Date 24Jan07               *
      *  Prev Amend No. BUG13119           Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10387           Date 06Feb06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245143 - No error messages are shown.                        *
      *  BUG13119 - No error message/error is displayed to validate   *
      *             for the market instrument Market Price input      *
      *  BUG10387 - Checks Market Code even if OTC                    *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFMPRIDDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       72  Toggle F3 footer text                               *
      *       73  Position cursor on first field if no error          *
      *     80-89 Reference and Part./Non-Part. fields display        *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of the
      ** arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **-------------------------------------------------------------------
 
 
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
 
     D AEI             S              1    DIM(60)
     D AZ0             S              1    DIM(60) CTDATA PERRCD(60)
     D AZ10            S              1    DIM(10) CTDATA PERRCD(10)
 
      ** Market Prices Details in screen format
     D TrnDets       E DS                  EXTNAME(FFMPRIPD)
 
      ** Market Prices Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FFEMPRIPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for market prices key
     D PRTRNN          DS
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
     D PTransStat      S             10A
     D POTCFlag        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   EXSR      MAIN
 
      ** Return
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS
      ** ================
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Transaction Details in screen format
 
     C                   PARM                    TrnDets
 
     C                   PARM                    PTransStat
 
      ** Transaction Details OK indicators
 
     C                   PARM                    OKTrnDets
 
     C                   PARM                    PRTRNN
 
     C                   PARM                    POTCFlag
 
      ** ERRORS
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** WARNING
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key & detail fields
 
     C                   PARM                    PEDTFD            1
 
      **  Enabled Function Keys
      ** F10 - Delete
 
     C                   PARM                    PEINKJ            1
 
      ** Screen to display
 
     C                   PARM                    Pscrn             1
 
      ** OUTPUT PARAMETERS
      ** =================
      ** Function Keys
 
     C                   PARM                    PINKC             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKJ             1
     C                   PARM                    PINKL             1
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'FFMPRIDSP'
 
      ** Move user and workstation ID to screen fields.
 
     C                   EVAL      DDWID  = PsJobName
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'FF'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
     C
 
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
 
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'                                BUG10387
     C                   EVAL      *IN19 = *OFF
 
      **------------------------------------------------------------------
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OKTrnDets     AEI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
 
     C                   DOU       (C > 4 AND Pscrn = 'A') OR (C > 9 AND
     C                             Pscrn = 'K') OR (C > 13 AND (Pscrn = 'P'
     C                             OR Pscrn = 'X'))
     C                   IF        AEI(C) = 'N' or
     C                             AEI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      ** Set up the customer reference to be used by the message handler
 
     C                   EVAL      ActionCode = DDACTN
 
      **------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **------------------------------------------------------------------
 
      ** Protect all fields
 
     C                   EVAL      *IN70 = *OFF
     C                   EVAL      *IN05 = *OFF
     C                   EVAL      *IN69 = *OFF
 
      ** Enable detail fields
 
     C     PEDTFD        COMP      'Y'                                7070
 
      ** Enable Function Key - F10 Delete
 
     C     PEINKJ        COMP      'Y'                                    71
 
      ** Position cursor on first field if no errors
 
     C     'N'           LOOKUP    AEI                                    73
 
      ** Write message subfile, Securities Clients Details and footer screen
 
     C**********         WRITE     FFMPRIS0                                                   245143
 
     C                   IF        PTransStat = 'DELETED'
     C                   EVAL      *IN19 = *ON
     C                   ELSE
     C                   EVAL      *IN19 = *OFF
     C                   ENDIF
 
     C                   SELECT
 
      ** First screen
 
     C                   WHEN      Pscrn = 'A'
 
     C                   EVAL      DDMKT = DDMRKT
 
     C                   WRITE     FFMPRID1
 
      ** Second screen
 
     C                   WHEN      Pscrn = 'K'
 
     C     DDMRKT        COMP      '  '                                   74
     C     DDMRKT        COMP      '  '                                   75
 
     C                   IF        DDMRKT = *BLANKS
     C                   EVAL      DDISTT = PRISTT
     C                   ENDIF
 
      ** Retrieve Title
 
     C                   EXSR      SRTITL
 
 
     C                   WRITE     FFMPRID2
 
      ** Third screen
 
     C                   WHEN      Pscrn = 'P'  OR Pscrn = 'X'
 
     C                   IF        Pscrn = 'P'
     C                   EVAL      *IN05 = *ON
     c                   IF        DDACTN <> 'I'
     C                   EVAL      *IN68 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   IF        Pscrn = 'X'
     C                   EVAL      *IN69 = *ON
     C                   ENDIF
     C                   IF        Pscrn = 'P'
     C     DDMRKT        COMP      '  '                                   74
     C     DDMRKT        COMP      '  '                                   75
     C                   IF        POTCFlag = 'Y'
     C                   EVAL      DDISTT = PRISTT
     C                   ENDIF
     C                   ENDIF
     C                   WRITE     FFMPRID2
     C                   WRITE     FFMPRID3
 
     C                   ENDSL
 
     C                   WRITE     FFMPRIF1
     C                   WRITE     FFMPRIS0                                                 BUG13119
 
      ** First screen
 
     C                   IF        Pscrn = 'A'
 
     C                   READ      FFMPRID1                               99
     C                   EVAL      DDMRKT = DDMKT
     C                   EVAL      PRMRKT = DDMKT
 
     C                   ENDIF
 
      ** Second screen
 
     C                   IF        Pscrn = 'K' OR Pscrn = 'X'
 
     C                   READ      FFMPRID2                               99
     C                   IF        DDMRKT <> *BLANKS
     C                   EVAL      PRISTC = DDISTC
     C                   EVAL      PRMRKT = DDMRKT
     C                   ELSE
     C                   EVAL      PRISTT = DDISTT
     C                   ENDIF
     C                   EVAL      PRYRNO = DDYRNO
     C                   EVAL      PRMTHN = DDMTHN
     C                   EVAL      PRPCAL = DDPCAL
     C                   EVAL      PRSTRP = DDSTRP
 
 
     C                   ENDIF
 
      ** Third screen
 
     C                   IF        Pscrn = 'P' OR Pscrn = 'X'
 
     C                   READ      FFMPRID3                               99
 
     C                   ENDIF
 
      ** Set screen error indicators off
 
     C                   MOVEA     AZ0           *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTITL - Retrieve Title
      *****************************************************************
     C     SRTITL        BEGSR
 
     C                   EVAL      DDTITL = *BLANKS
     C                   IF        DDMRKT = *BLANKS
     C                   EVAL      DDTITL = 'OVER THE COUNTER'
     C                   ELSE
     C                   EVAL      DDTITL = %TRIM(DDMKTN) + ' as of ' +
     c                                      %TRIM(DDBUSD)
     C                   ENDIF
 
     C                   ENDSR
      **------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
** AZ0
000000000000000000000000000000000000000000000000000000000000
** AZ10
0000000000
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
