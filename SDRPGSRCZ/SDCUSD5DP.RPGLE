     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Display -Private Banking')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSD5DP - Customer Details Display - Private Banking      *
      *                                                               *
      *  Function:  This module displays the Private Banking screen   *
      *             of the customer details screen input function     *
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
      *                 CAP034  *CREATE    Date 03Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14653 - Errors encountered in Customer Repair API         *
      *             (Recompile)                                       *
      *  CSD025 - Customer De-Activation                              *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD5DDF.          *
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
 
     FSDCUSD5DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       10  Field Error - highlight Hold Mail Indicator         *
      *       11  Field Error - highlight Numbered Account Indicator  *
      *       12  Field Error - highlight Agent                       *
      *       13  Field Error - highlight Valid Counterparty          *
      *       14  Field Error - highlight Req. PB Customer field      *
      *       15  Field Error - highlight PB Start Date               *
      *       37  Enable function key F23 (further details)           *
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
 
     D @EI             S              1    DIM(60)
 
 
      ** External DS for Customer Primary Details
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
      ** External DS for Customer Private Banking Details
     D CuPriv        E DS                  EXTNAME(SDCUPBPD)
      ** External DS for Customer Private Banking Error Details
     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
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
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKCuPriv      @EI
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
 
 
      ** Set up the customer reference to be used by the message handler
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
     C     @EINKX        COMP      'Y'                                    37
      *
      * WRITE MESSAGE SUBFILE, PRIMARY DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDVS0
     C                   WRITE     SDCUSDVD1
     C                   WRITE     SDCUSDVF1
      *
      * READ DETAILS SCREEN, If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDCUSDVD1                              99
     C                   ENDIF
      *
      * Clear message subfile
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     '00000000'    *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKX         @INKX
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
      * Customer (IN SCREEN FORMAT - Primary)
     C                   PARM                    CuPrim
      *
      * Customer (IN SCREEN FORMAT - Private Banking)
     C                   PARM                    CuPriv
      *
      * Fields in error
     C                   PARM                    OKCuPriv
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * ENABLED FUNCTION KEYS
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKX            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKX             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSD5DP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
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
     C                   MOVEL     'SDCUSD5DP'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
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
(c) Misys International Banking Systems Ltd. 2001
