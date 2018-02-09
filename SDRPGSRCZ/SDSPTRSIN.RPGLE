     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Screen Input')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTRSIN - Spot Rate SCREEN INPUT                           *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for spot rate.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT147             Date 14Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084             Date 26Aug03               *
      *                 213558             Date 22Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 200420             Date 22Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 17Nov00               *
      *                 CAP057  *CREATE    Date 17Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_027, CFT147_028                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - API Wrapper project.  Override file SDCURRL0.       *
      *  213558 - MDF Rate Maintenance Time/Date Stamp amendable      *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *           (Recompiled over changed SDVSPTRPD)                 *
      *  200420 - Database error due to file SDCURRL1 is being open   *
      *           when it is already opened                           *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
 
     D CrMmFilFmt    E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(C_)
      * Current Transaction Detail in File Format
 
 
     D CurTrnDets    E DS                  EXTNAME(SDSPTRPD)
     D                                     PREFIX(@)
      * Current Transaction  Detail in Screen Format
 
 
     D NwMmFilFmt    E DS                  EXTNAME(SDVSPTRPD)
      * New Transaction Detail in File Format
 
 
     D PrvTrnDets    E DS                  EXTNAME(SDSPTRPD)
     D                                     PREFIX(@P)
      * Previous Transaction Detail in Scrn Format
 
 
     D OKTrnDets     E DS                  EXTNAME(SDESPTRPD)
      * Error indicators
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access progrmas, long data structure
 
     D*PCMD************S            100    DIM(2) CTDATA PERRCD(1)                      200420CAP084
     D PCMD            S            100    DIM(4) CTDATA PERRCD(1)                      200420CAP084
      ** Override Database Table                                                              200420
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Transaction Number
     D DDTRNN          S              3
 
      ** Action Code
     D DDACTN          S              1
 
 
      ** Build subfile
     D @BDSFL          S              1A
 
      ** Customer selected
     D @CUSEL          S              6A
 
      ** Whether position/select fields have been changed during key browse
     D KPosSelChg      S              1A
 
      ** condition availability of F10 (delete)
     D @EINKJ          S              1A
 
      ** error message reference
     D @ERRMS          S              7A
 
      ** F3 Exit
     D @INKC           S              1A
 
      ** F7 Roll backwards
     D @INKG           S              1A
 
      ** F8 Roll forwards
     D @INKH           S              1A
 
      ** F9 Insert
     D @INKI           S              1A
 
      ** F10 Delete
     D @INKJ           S              1A
 
      ** F12 Cancel
     D @INKL           S              1A
 
      ** Option selected
     D @OPSEL          S              1A
 
      ** Read backwards in roll
     D @RDBCK          S              1A
 
      ** Read forwards in roll
     D @RDFWD          S              1A
 
      ** Read next browse
     D @RDNB           S              1A
 
      ** Read subfile
     D @RDSFL          S              1A
 
      **
     D @SCRED          S              3A
 
      ** Screen / function
     D @SCRN           S              1A
 
      ** Control return to key screen after F7/F8 rolls
     D INSERTENQ       S              1A
 
      ** Read next browse in key screen query browse subfile
     D K@RDNB          S              1A
 
      ** Query check in key screen customer number field
     D KEYQUERY        S              1A
 
      ** Mode of operation
     D MODEOFOP        S              6A
 
      ** Called from Customer Details or Midas menu
     D BrwQuery        S              1A
 
      ** Index of errors
     D Idx             S              3P 0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D PCMDLEN         S             15  5                                                    200420
                                                                                              200420
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
     D/COPY OFCPYSRCZ,CFT147_027                                                              CFT147
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSPTRS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SDSPTRS002
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END
      *
      /COPY WNCPYSRC,SDSPTRS003
      *
      ** Build browse subfile record
      *
     C     @SCRN         IFEQ      'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRS004
      *
      ** Do while screen: Key Details Screen
      *
     C     @SCRN         DOWEQ     'K'
     C                   EXSR      Scrn@K
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDSPTRS005
      *
      ** Build key screen '?' browse subfile record
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      KBLDBRW
     C                   ENDIF
      *
      ** Read next key screen '?' browse subfile record
      *
     C     @SCRN         IFEQ      'S'
     C                   EXSR      KRDNBRW
     C                   ENDIF
      *
     C     @SCRN         IFEQ      ' '
     C                   EXSR      RTVTRN
     C     DDACTNOK      IFEQ      'N'
     C     DDTRNNOK      OREQ      'N'
     C                   MOVEL     'T'           @SCRN
     C                   END
      *
      * If action code is not insert
      *  .. Convert the Transaction details to screen format
      *  .. Go to Details screen
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      CVTTRN
     C                   EXSR      SFDS@P
     C                   END
      *
      * Clear DS parameter arrays and go to detail screen
      *
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRS006
      ** Do while screen: Transaction Detail Screen
      *
     C                   Z-ADD     *ZERO         WIdx              3 0
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   EXSR      SFDS@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDSPTRS007
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSPTRS008
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSPTRS009
 
      /EJECT
      *****************************************************************
      * SCRN@K - PROCESS SCREEN: KEY DETAILS
      *****************************************************************
     C     SCRN@K        BEGSR
     C     *LIKE         DEFINE    C_A6CYNM      DDCYNM
     C     *LIKE         DEFINE    @DDSPRT       DDSPR2
     C     *LIKE         DEFINE    C_A6MDIN      DDMDI2
     C     *LIKE         DEFINE    C_A6SWCY      DDSWC2
     C     *LIKE         DEFINE    C_A6DLCI      DDDCY2
     C     *LIKE         DEFINE    C_A6SWCY      DDSWCY
     C     *LIKE         DEFINE    C_A6DLCI      DDDLCY
     C     *LIKE         DEFINE    C_A6CYCD      DDVSEU
 
      * Set F7/F8 called from Insert mode flag
     C                   MOVE      'Y'           INSERTENQ
 
 
      ** WRITE/READ DISPLAY SCREEN - Key Details
 
     C                   CALLB     'SDSPTRDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM      *BLANK        CurTrnDets
     C                   PARM      *BLANK        DDVSEU
     C                   PARM      *BLANK        DDSWCY
     C                   PARM      *BLANK        DDDLCY
     C                   PARM      *BLANK        DDCYNM
     C                   PARM      *BLANK        DDSPR2
     C                   PARM      *BLANK        DDMDI2
     C                   PARM      *BLANK        DDSWC2
     C                   PARM      *BLANK        DDDCY2
     C                   PARM                    OKTrnDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'Y'           @EACTN            1
     C                   PARM      'Y'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM      'Y'           @HDTFD            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'Y'           @EINKG            1
     C                   PARM      'Y'           @EINKH            1
     C                   PARM      'Y'           @EINKP            1
     C                   PARM      'N'           @DERFD            1
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
 
 
      * Reset Errors
 
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * Fill communication variables with screen variables
     C                   EVAL      DDACTN = @DDACTN
     C                   EVAL      DDTRNN = @DDCYCD
 
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Key Screen
     C     @INKL         CASEQ     '1'           CANC@K
      *
      * F15 - Browse records
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * Validate input to Key screen
     C                   CAS                     VAL@K
      *
     C                   ENDCS
      *
     C     EndKey        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@K  - VALIDATE INPUT TO KEY SCREEN
      *****************************************************************
     C     VAL@K         BEGSR
 
      * If query on key screen, provide Transaction subfile for selection
 
     C                   MOVEL     DDTRNN        KEYQuery
     C                   IF        KEYQuery = '?'
     C                   Eval      @SCRN = 'C'
     C                   Eval      DDTRNN=*BLANKS
     C                   GOTO      EndVal@K
     C                   ENDIF
 
      * Retrieve Transaction Detail
      * Screen field may be Transaction number
 
     C                   EXSR      RTVTRN
 
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTRNNOK      OREQ      'N'
     C                   GOTO      EndVAL@K
     C                   END
      *
      * If action code is not insert
      *  .. Convert the Transaction details to screen format
      *  .. Update the transaction in file format
      *  .. Go to Details screen
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      CVTTRN
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
     C                   GOTO      EndVAL@K
     C                   END
      *
      * Clear DS parameter arrays and go to detail screen
      *
     C                   CLEAR                   NwMmFilFmt
     C                   CLEAR                   CrMmFilFmt
     C                   CLEAR                   CurTrnDets
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
      *
     C     EndVAL@K      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON DETAIL SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on detail screen
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS DETAIL SCREEN
      *****************************************************************
     C     SCRN@P        BEGSR
 
      * Set function key status on screen
     C                   EXSR      SFKEYS
 
      * Enable details fields
     C                   IF        @DDACTN = 'A'
     C                   EVAL      @EDTFD = 'Y'
     C                   ELSE
     C                   EVAL      @EDTFD = 'N'
     C                   ENDIF
 
      * Enable Euro fields ?
     C                   IF        DDSPR2 <> *BLANK
     C                   EVAL      @DERFD = 'Y'
     C                   ELSE
     C                   EVAL      @DERFD = 'N'
     C                   ENDIF
 
      ** WRITE/READ DISPLAY SCREEN - Primary Details
 
     C                   CALLB     'SDSPTRDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    CurTrnDets
     C                   PARM                    DDVSEU
     C                   PARM                    DDSWCY
     C                   PARM                    DDDLCY
     C                   PARM                    DDCYNM
     C                   PARM                    DDSPR2
     C                   PARM                    DDMDI2
     C                   PARM                    DDSWC2
     C                   PARM                    DDDCY2
     C                   PARM                    OKTrnDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           @EACTN            1
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM      'N'           @HDTFD            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'Y'           @EINKG            1
     C                   PARM      'Y'           @EINKH            1
     C                   PARM      'Y'           @EINKP            1
     C                   PARM                    @DERFD            1
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
 
      * Reset Errors
 
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
 
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Details Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      * F15 - Browse records
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * Validate Input to Details Screen
     C                   CAS                     VAL@P
 
     C                   ENDCS
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      *
      * If customer number is NOT OK
      * Re-output screen with error message on it
      *
     C     DDTRNNOK      IFEQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
 
     C     DDACTN        IFEQ      'E'
 
     C     @RDNB         IFEQ      'Y'
     C                   MOVE      'R'           @SCRN
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
 
      * Initialize error indicators as 'OK'
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   GOTO      EndVAL@P
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'A'
 
      * Validate Transaction Detail
 
      * Store image of input screen and current number of warnings
     C                   MOVEL     CurTrnDets    PrvTrnDets
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
 
      * Restore file format extracted from the convert as it holds
      * previous values on the file record.
      * Some validations are done using current values and previous values
     C                   MOVEL     CrMmFilFmt    NwMmFilFmt
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       OKTrnDets
 
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      @DDDTFR= *BLANKS                                           213558
     C                   EVAL      @DDDFTS= *BLANKS                                           213558
     C                   ENDIF                                                                213558
     C                   CALLB     'SDSPTRVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RespMode          1
     C                   PARM                    CurTrnDets
     C                   PARM                    OKTrnDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwMmFilFmt
 
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      *
      * If any screen defaulting or reformatting has occurred in validation
      * or if the number of warnings has changed, re-display the screen
      *
     C     CurTrnDets    IFNE      PrvTrnDets
     C     WIdx          ORNE      PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   ENDIF
 
     C                   MOVE      'U'           @SCRN
 
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * If action is insert, control return to key screen
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'Y'           INSERTENQ
     C                   END
      *
      * Default action code to enquiry if action insert or not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * Read next or previous record on customer file
      * according to command key taken (F7/@INKG or F8/@INKH)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'SDSPTRRED'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTRNN            3
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
     C                   PARM                    @ERRMS            7
     C                   PARM                    @SCRED
 
      * If error message returned from read, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   END
 
      * If transaction read
 
     C     @SCRED        IFNE      *BLANK
 
      * Retrieve transaction details
 
     C                   MOVEL     @SCRED        DDTRNN
 
     C                   EXSR      RTVTRN
 
      * Return to previous screen if there is an error on transaction/action
     C     DDTRNNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
 
     C     INSERTENQ     IFEQ      'Y'
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
 
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * Convert Transaction Detail
     C                   EXSR      CVTTRN
      *
      * Put the Transaction Detail on screen
      *
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Set/reset return to key screen from primary details
     C                   MOVE      'N'           INSERTENQ
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB
      *
      * Build Browse subfile
     C                   CALLB     'SDSPTRBRW'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTRNN            3
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      'N'           @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @TRSEL            3
     C                   PARM      '0'           @INKC             1
 
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
     C                   CALLB     'SDSPTRBRW'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTRNN            3
     C                   PARM      'N'           @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @TRSEL            3
     C                   PARM      '0'           @INKC             1
      *
      * If Transaction read from subfile
     C     @TrSEL        IFNE      *BLANK
      *
      * Retrieve Transaction Detail
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @TrSEL        DDTRNN
 
     C                   EXSR      RTVTRN
 
      * Stay on browse screen if there is an error on Transaction number
      *
     C     DDTRNNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   GOTO      EndRDNBRW
     C                   ENDIF
      *
      * Convert Transaction Detail
     C                   EXSR      CVTTRN
      *
      * Put Transaction Detail detail screen
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
      *
      * Else, rebuild subfile browse
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * KBLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     KBLDBRW       BEGSR
 
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        K@RDNB
 
      * Build Browse subfile
     C                   CALLB     'AOCURRR0'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        @RTCD             7            B:Return code
     C                   PARM      '*KEY'        @OPTN             7            I:Option
     C                   PARM      '?'           @K101             3            I:Key field
     C                   PARM                    DSSDY                          O:Format
 
      * If F3 taken in browse, return to key screen
     C     @RTCD         IFEQ      '*NOSEL'
     C                   Eval      @SCRN = 'K'
     C                   GOTO      EndKBLDBRW
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           K@RDNB
     C                   MOVEL     'S'           @SCRN
      *
     C     EndKBLDBRW    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * KRDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     KRDNBRW       BEGSR
      *
      * Transaction not read from subfile?
     C                   IF        @RTCD = '*NOSEL'
      *
      * Err: 'No selection' message
     C                   Eval      @ERRMS = 'USR5000'
     C                   EXSR      SNDM@K
     C                   Eval      DDTRNN=*BLANKS
     C                   Eval      @SCRN = 'K'
     C                   GOTO      EndKRDNBRW
      *
     C                   ELSE
      *
      * Retrieve Transaction
     C                   MOVEL     @K101         @TrSEL
     C                   MOVEL     @DDACTN       DDACTN
     C                   MOVEL     @TrSEL        DDTRNN
 
     C                   EXSR      RTVTRN
 
      * Return to key screen if there is an error on transaction number
 
     C     DDTRNNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'K'           @SCRN
     C                   GOTO      EndKRDNBRW
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     *BLANK        @SCRN
 
     C     EndKRDNBRW    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - Retrieve Transaction Detail
      *****************************************************************
     C     RTVTRN        BEGSR
     C     *LIKE         DEFINE    DDCYCDOK      DDTRNNOK
      *
      * Retrieve Transaction Detail
      *
     C                   CALLB     'SDSPTRRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM      *BLANK        ModeofOp          6
     C                   PARM      'S'           RespMode          1
     C                   PARM                    DDACTN            1
     C                   PARM                    C_FlFRNT         20
     C                   PARM                    DDTRNN            3
     C                   PARM                    CrMmFilFmt
     C                   PARM      *BLANK        DDACTNOK          1
     C     DDTRNNOK      PARM      *BLANK        DDCYCDOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      0             Idx
 
     C                   EVAL      @DDACTN = DDACTN
     C                   EVAL      @DDCYCD = DDTRNN
     C     EndRTVTRN     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRN - Put a Transaction Detail on Screen
      *****************************************************************
     C     CVTTRN        BEGSR
      *
      * Call program to fill screen fields with data from TranFlPD
      *
     C                   CALLB     'SDSPTRCVT'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    CrMmFilFmt
     C                   PARM                    CurTrnDets
     C                   PARM                    DDCYNM
     C                   PARM                    DDDLCY
     C                   PARM                    DDSWCY
     C                   PARM                    DDVSEU
     C                   PARM                    DDSPR2
     C                   PARM                    DDMDI2
     C                   PARM                    DDDCY2
     C                   PARM                    DDSWC2
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
 
      * Enable/disable function keys
 
      * KJ = Command Key F10 = CONFIRM DELETE
 
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO DETAIL SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@K - SEND A MESSAGE TO KEY SCREEN
      *****************************************************************
     C     SNDM@K        BEGSR
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@K     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@K - CANCEL ON KEY SCREEN
      *****************************************************************
     C     CANC@K        BEGSR
      *
      * Terminate program
      *
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     'T'           @SCRN
     C                   MOVEL     *BLANK        DDTRNN
      *
      * If input fields are enabled
      * Blank the screens
      *
     C                   MOVEL     *BLANK        CurTrnDets
      *
      * Initialize field status on Key Screen
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * Return to previous screen
     C                   MOVEL     *BLANK        DDTRNN
      *
     C     INSERTENQ     IFEQ      'Y'
     C                   MOVE      'I'           DDACTN
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'K'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
     C     *LIKE         DEFINE    C_A6ERLC      #1ERLC
     C     *LIKE         DEFINE    C_A6INER      #1INER
     C     *LIKE         DEFINE    C_A6INMD      #1INMD
     C     *LIKE         DEFINE    C_A6SPRT      WUSSSR
     C     *LIKE         DEFINE    C_A6MDIN      WUSMDI
                                                                                              CAP084
      ** Override SDCURRL0                                                                    CAP084
                                                                                              CAP084
     C                   Z-ADD     32            PCMDLEN                                      CAP084
     C                   CALL      'QCMDEXC'                                                  CAP084
     C                   PARM                    PCMD(3)                                      CAP084
     C                   PARM                    PCMDLEN                                      CAP084
                                                                                              200420
      ** Override SDCURRL1                                                                    200420
                                                                                              200420
     C                   Z-ADD     32            PCMDLEN                                      200420
     C                   CALL      'QCMDEXC'                                                  200420
     C                   PARM                    PCMD(1)                                      200420
     C                   PARM                    PCMDLEN                                      200420
 
      * Spot Rate Transaction Details Updates
 
     C                   CALLB     'SDSPTRUPD'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwMmFilFmt
     C/COPY OFCPYSRCZ,CFT147_028                                                              CFT147
                                                                                              CAP084
      ** Delete override of SDCURRL0                                                          CAP084
                                                                                              CAP084
     C                   Z-ADD     21            PCMDLEN                                      CAP084
     C                   CALL      'QCMDEXC'                                                  CAP084
     C                   PARM                    PCMD(4)                                      CAP084
     C                   PARM                    PCMDLEN                                      CAP084
                                                                                              200420
      ** Delete override of SDCURRL1                                                          200420
                                                                                              200420
     C                   Z-ADD     21            PCMDLEN                                      200420
     C                   CALL      'QCMDEXC'                                                  200420
     C                   PARM                    PCMD(2)                                      200420
     C                   PARM                    PCMDLEN                                      200420
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program. Otherwise, commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'SDM0089'     MsgIdArr(1)
     C
     C                   ENDIF
      *
      * If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO INSERT KEY SCREEN OR BROWSE SBFILE
      *
     C                   MOVEL     WSCRN         @SCRN
     C                   ENDIF
      *
     C     @CALLP        IFEQ      'SPTR'
     C                   MOVEL     'T'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     *BLANK        DDTRNN
      *
      * Blank the screens
      *
     C                   MOVEL     *BLANK        CurTrnDets
      *
      * Key Screen
      *
     C                   MOVEL     'K'           @SCRN
     C                   MOVEL     'K'           WSCRN             1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
      * INPUTS
      *
      * Spot rate transaction NUMBER
      *
     C                   PARM                    DDTRNN
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSPTRSIN'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 902                                                CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
     C     DDTRNN        IFNE      *blank
     C     DDACTN        ANDNE     ' '
     C                   MOVEL     ' '           WSCRN             1
     C                   MOVEL     ' '           @SCRN             1
     C                   MOVEL     'SPMA'        @CALLP            4
      *
      * Clear DS parameter arrays and go to detail screen
     C                   CLEAR                   NwMmFilFmt
     C                   CLEAR                   CrMmFilFmt
     C                   CLEAR                   CurTrnDets
     C                   MOVE      *ALL'Y'       OKTrnDets
      *
     C                   ELSE
      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
     C                   MOVEL     'SPMA'        @CALLP            4
     C                   ENDIF
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSPTRS010
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@                                                                                      200420
(c) Finastra International Limited 2001                                                       200420
** PCMD                                                                                       200420
OVRDBF FILE(SDCURRL1) SHARE(*NO)                                                              200420
DLTOVR FILE(SDCURRL1)                                                                         200420
OVRDBF FILE(SDCURRL0) SHARE(*NO)                                                              CAP084
DLTOVR FILE(SDCURRL0)                                                                         CAP084
