     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward rates detail display module')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTDSP - Forward Rates Details Display                    *
      *                                                               *
      *  Function:  This module displays the Forward Rates            *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 213558             Date 09Jun03               *
      *                 211374             Date 13May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201985             Date 15Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 06Oct00               *
      *                 CAP059  *CREATE    Date 06Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  213558 - Change data feed req id and timestamp to output only*
      *           (recompile)                                         *
      *  211374 - Check if Securities module is ON before calling     *
      *           AOSTRDR0.                                           *
      *  201985 - Cursor positioned to non-displayed field            *
      *           - Recompile only.                                   *
      *  CSD006 - Market Data Feed                                    *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFDFWRTDDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-89 Field Error - highlight screen fields               *
      *       90  Enable Function Key - F10 (delete)                  *
      *       91  Position cursor on Action code if it is blank       *
      *       92  Position cursor on first field if no error          *
      *       93  Protect Action and Ccy codes                        *
      *       94  CSD006 Market Data Feeds                            *
      *     96-97 Message subfile                                     *
      *       98  Display only (protect fields)                       *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
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
      ** The following /COPY includes the FD standard declares:
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @EI             S              1    DIM(80)
     D @Z0             S              1    DIM(80) CTDATA PERRCD(80)
     D @Z10            S              1    DIM(10) CTDATA PERRCD(10)
     D OkSecs          S              1                                                       211374
 
      ** Forward Rates Details in screen format
     D TrnDets       E DS                  EXTNAME(FDFWRTPD)
     D  DDTSDT                             OVERLAY(DDDFTS:3)
     D  DDTSTM                             OVERLAY(DDDFTS:9)
 
      ** Forward Rates Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FDEFWRTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Securities Trading Data
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** External DS for Modules                                                              211374
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  211374
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Move 'OK' flags to array (for checking)
      *
     C                   MOVEA     OKTrnDets     @EI
      *
      * Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUEQ     80
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
 
     C                   END
 
 
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCCY
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      * Protect all fields
     C                   MOVE      *OFF          *IN98
      *
      * Enable detail fields (all fields except action code & currency)
      *
     C                   IF        WriteOnly = 'Y'
     C                   EVAL      *IN98 = TRUE
     C                   ELSE
     C                   EVAL      *IN98 = FALSE
     C                   ENDIF
 
      * Enable Function Key - F10 Delete
     C     @EINKJ        COMP      'Y'                                    90
      *
      * Position cursor on action code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 91
 
     C     'N'           LOOKUP    @EI                                    92
 
     C     @EKYFD        COMP      'Y'                                9393
      *
      * Write message subfile, Securities Clients Details and footer screen
     C                   TIME                    DDTIME
     C                   WRITE     FDFWRTS0
     C                   WRITE     FDFWRTD1
     C                   WRITE     FDFWRTF1
 
     C                   READ      FDFWRTD1                               99
 
      * Set screen error indicators off
     C                   MOVEA     @Z0           *IN(10)
 
      * Set return keys
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
 
      * Return code
     C                   PARM                    RetCodeIn
 
      ** Transaction Details in screen format
     C                   PARM                    TrnDets
 
      ** Transaction Details OK indicators
     C                   PARM                    OKTrnDets
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    WriteOnly         1
      *
      * Enabled Function Keys
      * F10 - Delete
     C                   PARM                    @EINKJ            1
 
      * OUTPUT PARAMETERS :
 
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
 
 
      *
      ** Initialise program name
      *
     C                   MOVEL     'FDFWRTDSP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       211374
      **  Access module file                                                                  211374
      *                                                                                       211374
     C                   CALLB     'AOMMODR0'                                                 211374
     C                   PARM      '*DBERR '     @RTCD             7                          211374
     C                   PARM      '*FIRST '     @OPTN             7                          211374
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        211374
      *                                                                                       211374
      ** Database error                                                                       211374
      *                                                                                       211374
     C     @RTCD         IFNE      *BLANKS                                                    211374
     C                   MOVEL     'SDMMODPD'    DBFILE                                       211374
     C                   MOVEL     '903'         DBASE                                        211374
     C                   MOVEL     @OPTN         DBKEY                                        211374
     C                   EXSR      *PSSR                                                      211374
     C                   END                                                                  211374
      *                                                                                       211374
      ** Check if Securities Module is ON                                                     211374
      *                                                                                       211374
     C     BGSECS        IFEQ      'Y'                                                        211374
     C                   MOVE      '1'           OkSecs                                       211374
     C                   ELSE                                                                 211374
     C                   MOVE      '0'           OkSecs                                       211374
     C                   ENDIF                                                                211374
 
      ** Access Securities Clients Details
      *
     C     OkSecs        IFEQ      '1'                                                        211374
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   END                                                                  211374
      *                                                                                       211374
      ** Access switchable features file - Market data feed                     CSD006
      *                                                                         CSD006
     C                   CALLB     'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD             6            CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSD006
      *
      ** Set screen conditioning indicator                                      CSD006
      *
     C     @RTCD         IFEQ      *BLANKS                                      CSD006
     C                   EVAL      *IN94 = '0'                                  CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      *IN94 = '1'                                  CSD006
     C                   ENDIF                                                  CSD006
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'FDFWRTDSP'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
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
**  CPY@
(c) Finastra International Limited 2001
** @Z0
0000000000000000000000000000000000000000000000000000000000000000000000000000000000
** @Z10
0000000000
