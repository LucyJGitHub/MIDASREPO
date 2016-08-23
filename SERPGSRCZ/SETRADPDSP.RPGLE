     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade display - primary screen')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADPDSP - SECURITIES TRADES DISPLAY - Primary Screen      *
      *                                                               *
      *  Function:  This module displays the primary details screen   *
      *             of the securites trades input function.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210962             Date 07Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 02Oct01               *
      *                 CSE028             Date 06Jun01               *
      *                 194229             Date 18Jun01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 29Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  210962 - Trades deletion shows 'Trade successfully inserted'.*
      *           Display the correct narrative based on the action   *
      *           code (only for delete and insert, as appropriate).  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CPK014 - Release 4 Packaging                                 *
      *         - Fix parameter mismatch                              *
      *  CSE028 - Standing Settlement Instructions Enhancement        *
      *  194229 - If Buy Sell on 1st leg is one book make sure 2nd    *
      *           leg has same book. Field protect book on 2nd leg.   *
      *  CSE016 - Extended Security Descriptions (Recompiled.)        *
      *  166907 - Display 'Trade No. 999999 successfully inserted'.   *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Recompiled over changes to /COPY       *
      *           MSGHNDDCL.                                          *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSETRADPDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect trade key fields (action code & trade ref)  *
      *       70  Protect trade detail fields                         *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF15                                         *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Bulk input option not used                          *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
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
 
      ** Successful Insert Trade                                                166907
     D                 DS                                                       166907
     D**DDFOTX**               1     40                                                166907 CAP067
     D  DDFOTX                 1     70                                                       CAP067
     D  DDSITR                11     16                                         166907
                                                                                166907
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D*@NAR*****       S             40    DIM(2) CTDATA PERRCD(1)                            CAP067
     D @NAR            S             70    DIM(3) CTDATA PERRCD(1)                            CAP067
 
     D @EI             S              1    DIM(60)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS DOR SECURITIES TRADING DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
 
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
 
 
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
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
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
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKTrPrim      @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
 
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDTDRF
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
 
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      * ENABLE KEY FIELDS (ACTION CODE AND TRADE REF)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & TRADE REF)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *                                                                                       CSE028
      * If from PGM SE0190, disable function keys                                             CSE028
      *                                                                                       CSE028
     C     @FRPGM        IFEQ      'Y'                                                        CSE028
     C                   MOVE      'N'           @EINKG                                       CSE028
     C                   MOVE      'N'           @EINKH                                       CSE028
     C                   MOVE      'N'           @EINKP                                       CSE028
     C                   MOVE      '1'           *IN79                                        CSE028
     C                   ENDIF                                                                CSE028
      *
      ** If this is the second leg of a trade field protect the book as                       194229
      ** it has already been set up in 1st leg.                                               194229
      *                                                                                       194229
     C                   IF        IN50 = 'Y'                                                 194229
     C                   EVAL      *IN50 = '1'                                                194229
     C                   END                                                                  194229
      *                                                                                       194229
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKP        COMP      'Y'                                    73
      *                                                                         166907
      ** Successful Insert Trade                                                166907
      *                                                                         166907
     C                   IF        PBYSL = 'Y'                                                CAP067
     C                   IF        @SITR <> *BLANKS AND                                       CAP067
     C                             PSITR  <> *BLANKS                                          CAP067
     C                   MOVEL     @NAR(3)       DDFOTX                                       CAP067
     C                   EVAL      %SUBST(DDFOTX:16:6) = @SITR                                CAP067
     C                   EVAL      %SUBST(DDFOTX:27:6) = PSITR                                CAP067
     C                   ENDIF                                                                CAP067
     C                   ELSE                                                                 CAP067
      *                                                                                       CAP067
     C     @SITR         IFNE      *BLANK                                       166907
     C                   MOVEL     @NAR(1)       DDFOTX                         166907
     C     DDACTN        IFEQ      'I'                                                        210962
     C                   EVAL      %SUBST(DDFOTX:31:9) = 'inserted.'                          210962
     C                   MOVEL     *BLANK        DDSRNME                                      210962
     C                   ELSE                                                                 210962
     C     DDACTN        IFEQ      'D'                                                        210962
     C                   EVAL      %SUBST(DDFOTX:31:8) = 'deleted.'                           210962
     C                   ELSE                                                                 210962
     C                   MOVEL     *BLANK        DDFOTX                                       210962
     C                   MOVEL     *BLANK        @SITR                                        210962
     C                   ENDIF                                                                210962
     C                   ENDIF                                                                210962
     C                   MOVEL     *BLANK        DDACTN                                       210962
     C                   MOVEL     @SITR         DDSITR                         166907
     C                   MOVEL     *BLANK        @SITR                          166907
     C                   ELSE                                                                 210962
     C                   MOVEL     *BLANK        DDFOTX                                       210962
     C                   END                                                    166907
     C                   ENDIF                                                                CAP067
      *
      ** If the second leg of a buy sell trade move 1st leg book into 2nd                     194229
      ** leg of trade.                                                                        194229
      *                                                                                       194229
     C     IN50          IFEQ      'Y'                                                        194229
     C                   EVAL      DDBPBK = TRDBK1                                            194229
     C                   END                                                                  194229
      *                                                                                       194229
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SETRADPS0
     C                   WRITE     SETRADPD1
     C                   WRITE     SETRADPF1
      *
      * READ DETAILS SCREEN, If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SETRADPD1                              99    *
     C                   ENDIF
      *
      * Clear message subfile
      *
     C**** martin        CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
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
      *
      * Trade (IN SCREEN FORMAT - Primary)
     C                   PARM                    TrPrim
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14                           S0126
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CPK014
     C                   PARM                    DDSRNME          41                          CPK014
     C                   PARM                    DDCRNM           20
      *
      * Fields in error
     C                   PARM                    OKTrPrim
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM                    @FRPGM            1                          CSE028
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKP            1
      * SUCCESSFUL INSERT TRADE
     C                   PARM                    @SITR             6
      *
      * Protect book on second leg                                                            194229
     C                   PARM                    IN50              1                          194229
     C                   PARM                    TRDBK1            2                          194229
      *                                                                                       194229
      ** Buy-sell back                                                                        CAP067
     C                   PARM                    PBYSL             1                          CAP067
      *                                                                                       CAP067
      ** Successfull insert trade 2                                                           CAP067
     C                   PARM                    PSITR             6                          CAP067
      *                                                                                       CAP067
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADPDSP'  DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Securities Trading
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLY INDICATORS
      *
      *
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Bulk Input Option not used
      *
     C     BVBIOP        IFNE      'Y'
     C                   MOVE      '1'           *IN81
     C                   END
      *                                                                                       CAP067
      ** If Buy-sell back processing, write appropriate screen header                         CAP067
     C                   IF        PBYSL = 'Y'                                                CAP067
     C                   EVAL      *IN86 = *ON                                                CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      *IN86 = *OFF                                               CAP067
     C                   ENDIF                                                                CAP067
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
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
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Trade No. 999999 successfully                                                                 210962
F10=CONFIRM DELETE
Buy-sell backs 999999 and 999999 successfully inserted.                                       CAP067
