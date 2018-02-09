     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL A/c maintenance display - primary scrn')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADPDP -  Account Maintenance Display - Primary Screen    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03Aug06               *
      *                 222549             Date 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165  - Dual Withholding Tax (Recompile)                   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  222549 - API version of Accounts master enquiry should be    *
      *           used in the linked enquiry from the Customer Account*
      *           Balances Enquiry. Introduced linked enquiry         *
      *           processing in the API version of GL accounts        *
      *           maintenance.                                        *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLAMADPDF CF   E             WORKSTN IGNORE(GLAMADDK)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  50-60 Field Error - highlight screen fields                  *
      *  68 - Position cursor on action code (if it is blank)         *
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
     DEMSDS          E DS                  EXTNAME(EMDTA) DTAARA(EMSDS)                       222549
     D CUSTNO                141    146                                                       222549
     D*CUSTN****             141    146  0                                            222549 CSD027A
     D CUSTN                 141    146                                                      CSD027A
     D CURRCY                147    149                                                       222549
     D ACCODE                150    159                                                       222549
     D ACCDN                 150    159  0                                                    222549
     D ACCSEQ                160    161                                                       222549
     D ACSQN                 160    161  0                                                    222549
     D BRANCH                162    164                                                       222549
     D AREF15                141    161                                                       222549
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)
     D OKAcPrim      E DS                  EXTNAME(GLEAMADPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
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
      ** ¦ isexecuted at program activation.                          ¦
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
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Set screen error inds according to status of 'OK' Flags
      *
     C                   MOVE      *OFF          *IN50
     C     DDACTNOK      IFEQ      'N'
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN51
     C     DDACCNOK      IFEQ      'N'
     C                   MOVE      *ON           *IN51
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN52
     C     DDRFRAOK      IFEQ      'N'
     C                   MOVE      *ON           *IN52
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
      *
      ** Position cursor on action code if it is blank
      *
     C                   MOVE      *OFF          *IN68
     C     DDACTN        IFEQ      *BLANK
     C     DDACCN        ANDEQ     *BLANKS
     C     DDRFRA        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN68
     C                   ENDIF
      *                                                                                       222549
      ** Check if this is a linked enquiry                                                    222549
      *                                                                                       222549
     C     *LOCK         IN        EMSDS                                                      222549
     C                   MOVE      RQDTD         MODID             2                          222549
     C                   OUT       EMSDS                                                      222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   MOVE      '1'           *IN36                                        222549
     C                   ELSE                                                                 222549
     C                   MOVE      '0'           *IN36                                        222549
     C                   ENDIF                                                                222549
      *
     C                   MOVE      *OFF          *IN35
      *
      ** Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLAMADC1
     C                   WRITE     GLAMADDP
     C                   WRITE     GLAMADF1
      *
      * Read details screen, if not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLAMADDP                               99
     C                   ENDIF
      *
      * Set screen error indicators off
      *
     C                   MOVEA     '000'         *IN(50)
      *
      * Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *IN49         @IN49
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
      * Trade (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewAcPrim
      *
      * Fields in error
     C                   PARM                    OKAcPrim
      *
      ** ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKL             1
     C                   PARM                    @IN49             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADPDP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWSID
      *
      ** Message subfile control
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
