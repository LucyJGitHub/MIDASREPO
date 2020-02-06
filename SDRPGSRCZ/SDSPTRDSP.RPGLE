     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Display')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRDSP - Spot Rate Transaction Details Display            *
      *                                                               *
      *  Function:  This module displays the Spot Rate Transaction    *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 213558             Date 09Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 02May01               *
      *                 CAP057  *CREATE    Date 18Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *  213558 - Change data feed req id and timestamp to output only*
      *           (recompile)                                         *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDSPTRDDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       07  Enable Function Key - F07                           *
      *       08  Enable Function Key - F08                           *
      *       10  Enable Function Key - F10                           *
      *       15  Enable Function Key - F15                           *
      *       25  CSD006 Market data feeds                            *
      *       26  Enable key field                                    *
      *       27  Enable non key field                                *
      *       28  For slf msgq                                        *
      *       29  Display Euro rate fields                            *
      *     30-35 Field Error - highlight screen fields               *
      *     36-90 Reserved for future Field Errors                    *
      *       95  Enable action code                                  *
      *       99  Working indicator                                   *
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
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @Z10            S              1    DIM(10) CTDATA PERRCD(10)
 
      ** Spot Rate Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDSPTRPD)
     D   DDTSDT                            OVERLAY(DDDFTS:3)
     D   DDTSTM                            OVERLAY(DDDFTS:9)
 
      ** Spot Rate Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDESPTRPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CSD006
      ** External DS for switchable features                                                  CSD006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD006
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CER048          S              1A                                                      CER048
      *                                                                                       CER048
      ** Parameters for AOSARDR0 call                                                         CER048
      *                                                                                       CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
      *                                                                                       CER048
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
      * Move 'OK' flags to array (for checking)
      *
     C                   MOVEA     OKTrnDets     @EI
      *
      * Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     30            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      * Enable action code
     C     @EACTN        COMP      'Y'                                    95
 
      * Enable key fields
     C     @EKYFD        COMP      'Y'                                    26
 
      * Enable detail fields
     C     @EDTFD        COMP      'Y'                                    27
 
      * Enable Function Key - F10
     C     @EINKJ        COMP      'Y'                                    10
 
      * Enable Function Key - F07
     C     @EINKG        COMP      'Y'                                    07
 
      * Enable Function Key - F08
     C     @EINKH        COMP      'Y'                                    08
 
      * Enable Function Key - F15
     C     @EINKP        COMP      'Y'                                    15
 
      * Display euro rates fields
     C     @DERFD        COMP      'Y'                                    29
 
      * Write message subfile, Securities Clients Details and footer screen
 
     C                   WRITE     #MSGCTL
     C                   WRITE     SDSPTRF2
     C                   WRITE     SDSPTRF0
     C                   IF        @HDTFD <> 'Y'
     C                   WRITE     SDSPTRF1
     C                   ELSE
     C                   WRITE     CLEARDTL
     C                   ENDIF
 
     C                   READ      SDSPTRF0                               99
     C                   IF        @HDTFD <> 'Y'
     C                   READ      SDSPTRF1                               99
     C                   ENDIF
 
 
      * Set screen error indicators off
     C                   MOVEA     @Z0           *IN(30)
 
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
 
      ** BKEURO currency
     C                   PARM                    DDVSEU
 
      ** Swift currency code (output screen field)
     C                   PARM                    DDSWCY
 
      ** Dealing currency (output screen field)
     C                   PARM                    DDDLCY
 
      ** Currency name (output screen field)
     C                   PARM                    DDCYNM
 
      ** Spot Rate against base currency (when DDSPRT is against BKEURO)
      ** (output screen field)
     C                   PARM                    DDSPR2
 
      ** Multiply divide indicator tied to DDSPR2
      ** (output screen field)
     C                   PARM                    DDMDI2
 
      ** Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2
 
      ** Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2
 
      ** Transaction Details OK indicators
     C                   PARM                    OKTrnDets
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * ENABLED ACTION CODE
     C                   PARM                    @EACTN            1
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * HIDE DETAIL FIELDS
     C                   PARM                    @HDTFD            1
      *
      *
      * Enabled Function Keys
      * F10 - Delete
     C                   PARM                    @EINKJ            1
      * F07 - Prev Record
     C                   PARM                    @EINKG            1
      * F08 - Next Record
     C                   PARM                    @EINKH            1
      * F15 - Select
     C                   PARM                    @EINKP            1
      *
      * DISPLAY FIELDS RELATED TO EURO RATES
      *
     C                   PARM                    @DERFD            1
 
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
     C                   MOVEL     'SDSPTRDSP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
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
      *                                                                                       CSD006
      ** Access switchable features file - Market data feed                                   CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
      *                                                                                       CSD006
      ** Set screen conditioning indicator                                                    CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   EVAL      *IN25 = '0'                                                CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      *IN25 = '1'                                                CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Set On Indicator to display the new field, based on                                  CER048
      ** the feature installed or not                                                         CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN90 = *ON                                                CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN90 = *OFF                                               CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
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
     C                   MOVEL     'SDSPTRDSP'   DBPGM
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
000000000000000000000000000000000000000000000000000000000000
** @Z10
0000000000
