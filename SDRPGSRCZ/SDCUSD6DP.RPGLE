     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Base Rate Tax Screen Dsp')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSD6DP - Customer Details Base Rate Tax Detail Screens   *
      *                                                               *
      *  Function:  This module displays the Base Rate Tax Details    *
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
      * Midas Release 4.01 -------------------------------------------*
      *                 191530             Date 05Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 10May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD025 - Customer De-Activation                              *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD6DDF.          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  191530 - SDCUSDSIN - Unable to send msg RE7105B.  Need to    *
      *           recompile pgm to pick up changes made in cpysrc     *
      *           MSGHNDDATA.                                         *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Base Rate Tax Details Display File
     FSDCUSD6DDFCF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       78  Protect BRT Tax Indicator                           *                       CRE007
      *       79  Protect fields (except name change verification)    *
      *       80  Display field 'Post 5/4/01 R105'                    *                       CRE007
      *       81  Confirm party 1 is name change or new party         *
      *       82  Confirm party 2 is name change or new party         *
      *       83  Confirm party 3 is name change or new party         *
      *       84  Confirm party 4 is name change or new party         *
      *       85  Confirm party 5 is name change or new party         *
      *       86  Display further parties prompt                      *
      *       87  Display Base Rate Tax prompt                        *
      *       88  Amend party details (function key F18)              *
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

     D*@Z0*************S              1    DIM(60) CTDATA PERRCD(60)                          CRE007
     D @Z0             S              1    DIM(63) CTDATA PERRCD(63)                          CRE007

     D*@EI*************S              1    DIM(60)                                            CRE007
     D @EI             S              1    DIM(63)                                            CRE007

      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)

      ** External DS for Customer Primary Details
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
      ** External DS for Customer Base Rate Tax Details
     D CuBrt         E DS                  EXTNAME(SDCUBRPD)
      ** External DS for Customer Base Rate Tax Error Indicators
     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
                                                                                              CRE007
      ** External DS for SAR Details                                                          CRE007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE007

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
      * Move 'OK' flsgs into array (for checking)
      *
     C                   MOVEA     OKCuBrt       @EI
      *
      * Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C*****C*************DOUGT     60                                                         CRE007
     C     C             DOUGT     63                                                         CRE007
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
     C     'N'           LOOKUP    @EI                                    89
      *
      * Protect all fields
      *
     C                   MOVE      *OFF          *IN79
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        WHENEQ    'A'
     C                   OTHER
     C                   MOVE      *ON           *IN79
     C                   ENDSL
      *
      * Screen display conditions
      *
      * If the Base Rate Tax 2001 is switched ON then display the                             CRE007
      * input capable field 'Post 5/4/01 R105'.                                               CRE007
      *                                                                                       CRE007
     C     CRE007        IFEQ      'Y'                                                        CRE007
     C                   MOVE      *ON           *IN80                                        CRE007
     C                   ELSE                                                                 CRE007
     C                   MOVE      *OFF          *IN80                                        CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CRE007
      * If the Account Holder type is 'R' then protect                                        CRE007
      * BRT Tax Indicator.                                                                    CRE007
      *                                                                                       CRE007
     C     DDTAIN        IFEQ      'R'                                                        CRE007
     C                   MOVE      *ON           *IN78                                        CRE007
     C                   ELSE                                                                 CRE007
     C                   MOVE      *OFF          *IN78                                        CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CRE007
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN84
     C                   MOVE      *OFF          *IN85
      *
      * Protect party screen details during new party confirmation
     C     'P'           LOOKUP    ChgNamArr                              99
     C     *IN99         IFEQ      '1'
     C                   MOVE      *ON           *IN79
      *
      * Check whether new names are new parties
     C     ChgNamArr(1)  IFEQ      'P'
     C*                  MOVE      'N'           DD1STS
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *
     C     ChgNamArr(2)  IFEQ      'P'
     C*                  MOVE      'N'           DD2STS
     C                   MOVE      *ON           *IN82
     C                   ENDIF
      *
     C     ChgNamArr(3)  IFEQ      'P'
     C*                  MOVE      'N'           DD3STS
     C                   MOVE      *ON           *IN83
     C                   ENDIF
      *
     C     ChgNamArr(4)  IFEQ      'P'
     C*                  MOVE      'N'           DD4STS
     C                   MOVE      *ON           *IN84
     C                   ENDIF
      *
     C     ChgNamArr(5)  IFEQ      'P'
     C*                  MOVE      'N'           DD5STS
     C                   MOVE      *ON           *IN85
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*                  MOVE      *OFF          *IN86
     C*    DspFurPar     IFEQ      '1'
     C*                  MOVE      *ON           *IN86
     C*                  ENDIF
      *
      * Write message subfile, base rate tax details (page 1 or page 2)
      * and footer
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDTS0
     C     BRTSCREEN     IFEQ      '1'
     C                   WRITE     SDCUSDTD1
     C                   ELSE
     C                   WRITE     SDCUSDTD2
     C                   ENDIF
     C                   WRITE     SDCUSDTF1
      *
      * Read details screen, If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C     BRTSCREEN     IFEQ      '1'
     C                   READ      SDCUSDTD1                              99
     C                   ELSE
     C                   READ      SDCUSDTD2                              99
     C                   ENDIF
     C                   ENDIF
      *
      * Clear message subfile
      *
      * Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKS         @INKS
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
      * Primary Details
     C                   PARM                    CuPrim
      *
      * Base Rate Tax Details
     C                   PARM                    CuBrt
      *
      * Fields in error
     C                   PARM                    OKCuBrt
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
      *
      * ENABLED FUNCTION KEYS
      * Display screen (1A)
     C                   PARM                    BRTSCREEN         1
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         1
      *
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKS             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDTDSP'  DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CRE007
      ** Access SAR details file to determine if CRE007                                       CRE007
      ** (Base Rate Tax 2001) is on.                                                          CRE007
      *                                                                                       CRE007
     C                   CALLB     'AOSARDR0'                                                 CRE007
     C                   PARM      *BLANKS       @RTCD                                        CRE007
     C                   PARM      '*VERIFY'     @OPTN                                        CRE007
     C                   PARM      'CRE007'      @SARD             6                          CRE007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE007
      *                                                                                       CRE007
     C     @RTCD         IFEQ      *BLANK                                                     CRE007
     C                   MOVEL     'Y'           CRE007            1                          CRE007
     C                   ELSE                                                                 CRE007
     C                   MOVEL     'N'           CRE007                                       CRE007
     C                   ENDIF                                                                CRE007
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSD6DP'   DBPGM
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
000000000000000000000000000000000000000000000000000000000000000
