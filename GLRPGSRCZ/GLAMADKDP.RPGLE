     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Maintenance Display - Key Screen')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADKDP -  Account Maintenance Display - Key Screen        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 12Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050  - Annualised Percentage Rate (Recompile)             *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165  - Dual Withholding Tax (Recompile)                   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLAMADPDF CF   E             WORKSTN IGNORE(GLAMADDP)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  50-60 -  Field Error - highlight screen fields               *
      *  42 - Confirm Delete Indcator                                 *
      *  48 - Retail A/c No. Required                                 *
      *  70 - Insert Mode                                             *
      *  73 - Delete Mode                                             *
      *  96 - Subfile control                                         *
      *  97 - Subfile end                                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
 
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
 
     D @Z0             S              1    DIM(10) CTDATA PERRCD(10)
 
     D @EI             S              1    DIM(10)
 
     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)
     D OKAcPrim      E DS                  EXTNAME(GLEAMADPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** External DS for Retail Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
     D/COPY WNCPYSRC,GLAMAKXD01
 
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
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
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
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OKAcPrim      @EI
      *
      ** Set screen error inds according to status of 'OK' Flags
      *
     C                   Z-ADD     4             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
     C     C             DOUGT     10
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
      *
      ** Enable key fields (Branch, Customer, Currency, A/c code & A/c Seq)
     C                   MOVE      *ON           *IN35
     C/COPY WNCPYSRC,GLAMAKXC03
      *
      ** Enable function keys
      *
     C                   MOVE      *OFF          *IN42
     C     @EINKJ        IFEQ      'Y'
     C                   MOVE      *ON           *IN42
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN70
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *ON           *IN70
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN73
     C     DDACTN        IFEQ      'D'
     C                   MOVE      *ON           *IN73
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN48
     C     BMRANR        IFEQ      'Y'
     C/COPY WNCPYSRC,GLAMAKXC01
     C                   MOVE      *ON           *IN48
     C                   ENDIF
      *
      ** Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLAMADC1
     C                   WRITE     GLAMADDK
     C                   WRITE     GLAMADF1
      *
      ** Read details screen, if not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLAMADDK                               99
     C                   ENDIF
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
      *
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
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
      * Account (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewAcPrim
      *
      * Fields in error
     C                   PARM                    OKAcPrim
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
      * ENABLED FUNCTION KEYS
      * KJ = COMMAND KEY 10 = Confirm Delete
     C                   PARM                    @EINKJ            1
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKE             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C/COPY WNCPYSRC,GLAMAKXC04
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADKDP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWSID
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMAKXC02
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for GL *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY GLCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
0000000000
