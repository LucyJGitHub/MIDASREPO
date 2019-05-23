     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Number Prompt Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSD1DP - Customer Details Display - Key Screen           *
      *                                                               *
      *  Function:  This module displays the KEY details screen       *
      *             of the customer details screen input function     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD025             Date 11Jan05               *
      *                 BUG2950            Date 02Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSD021             Date 14Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191530             Date 05Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD025 - Customer De-Activation                              *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD1DDF.          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD021 - System generated customer number.                   *
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

     FSDCUSD1DDFCF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       71  Condition function key F7 (read previous)           *
      *       72  Condition function key F8 (read next)               *
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
     D @NAR            S             50    DIM(1) CTDATA PERRCD(1)                            CSD021

     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure for SAR Details                                                       CSD021
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD021
                                                                                              CSD021
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D                 DS                                                                     CSD021
     D  DDFOTX                 1     55                                                       CSD021
     D  DDCNUM                14     19                                                       CSD021
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D CSD021          S              1A                                                      CSD021

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
     C                   MOVEA     OKCuPrim      @EI
      *
      * SET SCREEN ERROR INDICATOR ACCORDING TO STATUS OF 'OK' FLAG
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
      *                                                                                       CSD021
      * TEXT = SUCCESSFUL INSERT                                                              CSD021
      *                                                                                       CSD021
     C     CSD021        IFEQ      'Y'                                                        CSD021
     C     DDACTN        ANDEQ     'I'                                                        CSD021
     C     WWCNUM        ANDNE     *BLANK                                                     CSD021
     C                   MOVEL     @NAR(1)       DDFOTX                                       CSD021
     C                   MOVEL     WWCNUM        DDCNUM                                       CSD021
     C                   ELSE                                                                 CSD021
     C                   MOVE      *BLANK        DDFOTX                                       CSD021
     C                   ENDIF                                                                CSD021


      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = 'I'

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
      *
      * WRITE MESSAGE SUBFILE, KEY DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDKS0
     C                   WRITE     SDCUSDKD1
     C                   WRITE     SDCUSDKF1
     C                   READ      SDCUSDKD1                              99
      *
      * Clear message subfile
      *
      * SET SCREEN ERROR INDICATOR OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKL         @INKL
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
      * Custo (IN SCREEN FORMAT - Key)
     C                   PARM                    CuPrim
      *
      * Fields in Error
     C                   PARM                    OKCuPrim
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
      *
      * OUTPUT PARAMETERS :
      *
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKL             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
                                                                                              CSD021
     C                   PARM                    WWCNUM            6                          CSD021
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSD1DP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
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
                                                                                              CSD021
      ** Check if CSD021 is installed                                                         CSD021
                                                                                              CSD021
     C                   EVAL      CSD021 = 'N'                                               CSD021
                                                                                              CSD021
     C                   CALLB     'AOSARDR0'                                                 CSD021
     C                   PARM      *BLANKS       @RTCD                                        CSD021
     C                   PARM      '*VERIFY'     @OPTN                                        CSD021
     C                   PARM      'CSD021'      @SARD             6                          CSD021
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
                                                                                              CSD021
      ** Database error                                                                       CSD021
                                                                                              CSD021
     C                   IF        (@RTCD <> *BLANKS) and                                     CSD021
     C                             (@RTCD <> '*NRF   ')                                       CSD021
     C                   EVAL      DBKEY = 'CSD021'                                           CSD021
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD021
     C                   EVAL      DBASE = 902                                                CSD021
     C                   EXSR      *PSSR                                                      CSD021
     C                   ENDIF                                                                CSD021
                                                                                              CSD021
     C                   IF        @RTCD = *BLANKS                                            CSD021
     C                   EVAL      CSD021 = 'Y'                                               CSD021
     C                   ENDIF                                                                CSD021
      *
      *
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
     C                   MOVEL     'SDCUSD1DP'   DBPGM
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
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Customer No. 999999 successfully inserted.
