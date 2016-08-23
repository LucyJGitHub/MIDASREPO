     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details - Message Screen')
      *****************************************************************
      *                                                               *
      *  Midas - SD Customer Details Module                           *
      *                                                               *
      *  SDCUSD4DP  - SD Customer Details Display - Message Screen    *
      *                                                               *
      *  Function:  This module displays the Other details screen of  *
      *             the Securites input function, i.e.                *
      *             - Exchange Rates                                  *
      *             - Settlements                                     *
      *             - Charges & Commissions                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG14653           Date 23Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD025             Date 11Jan05               *
      *                 BUG2950            Date 02Jun04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191530             Date 05Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 28May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14653 - Errors encountered in Customer Repair API         *
      *             (Recompile)                                       *
      *  CSD025 - Customer De-Activation                              *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD4DDF.          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  191530 - SDCUSDSIN - Unable to send msg RE7105B.  Need to    *
      *           recompile pgm to pick up changes made in cpysrc     *
      *           MSGHNDDATA.                                         *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSD4DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       69  Postion cursor to first screen field if no errors   *
      *       70  Protect screen fields                               *
      *       72  Enable function key F10 (delete)                    *
      *       73  Enable function key F23 (further details)           *
      *       97  Subfile end                                         *
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @EI             S              1    DIM(60)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
     D CuMsg         E DS                  EXTNAME(SDCUMRPD)
 
     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
 
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
     C                   MOVEA     OKCuMsg       @EI
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
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
      * Position cursor on first field if no errors
      *
     C     'N'           LOOKUP    @EI                                    69
      *
      * Protect all fields
      *
     C                   MOVE      *OFF          *IN70
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        WHENEQ    'A'
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   ENDSL
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKJ        COMP      'Y'                                    72
     C     @EINKX        COMP      'Y'                                    73
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDMS0
     C                   WRITE     SDCUSDMD1
     C                   WRITE     SDCUSDMF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDCUSDMD1                              99
     C                   ENDIF
      *
      ** IF EXIT/PREVIOUS SCREEN NOT SELECTED
      ** PROCESS USER REQUEST FOR DATA TABLES WITH QUERY '?'
      *
     C     @INKC         IFNE      *ON
     C     @INKL         ANDNE     *ON
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS01        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN            7
     C                   PARM                    DDDS01
     C                   ENDIF
      *
 
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS02        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS02
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS03        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS03
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS04        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS04
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS05        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS05
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS06        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS06
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS07        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS07
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS08        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS08
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS09        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS09
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS10        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS10
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS11        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS11
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS12        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS12
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS13        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS13
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS14        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS14
     C                   ENDIF
      *
      * Message Type Descriptions / Default Status Release
     C                   MOVEL     DDDS15        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2030S'
     C                   PARM                    RETURN
     C                   PARM                    DDDS15
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW1
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW2
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW3
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW4
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW5
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW6        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW6
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW7        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW7
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW8        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW8
     C                   ENDIF
      *
      * Message Network Details / Default Network
     C                   MOVEL     DDDNW9        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD2000S'
     C                   PARM                    RETURN
     C                   PARM                    DDDNW9
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKX         @INKX
      *
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
      * INPUT PARAMETERS
      * RETURN CODE
     C                   PARM                    RetCodeIn
      * CUSTOMER (IN SCREEN FORMAT)
     C                   PARM                    CuPrim
     C                   PARM                    CuMsg
      * FIELDS IN ERROR
     C                   PARM                    OKCuMsg
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED FUNCTION KEYS
      * KJ = COMMAND KEY 10 = DELETE
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKX            1
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKX             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADODSP'  DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
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
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
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
