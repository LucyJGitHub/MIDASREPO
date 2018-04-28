     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details Display')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLDSP - Collateral Details Display                       *
      *                                                               *
      *  Function: This module will display the appropriate           *
      *            collateral details screen according to the input   *
      *            parameter passed and any messages as required.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL018             Date 26Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL018 - Risk Weighted Assets                                *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Main Details screen
     FGLCOLLDDF CF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FUNCTION OF INDICATORS                                       *
      *  ----------------------                                       *
      *  10-45  Field Error - highlight screen fields                 *
      *  64  Enquiry, Delete or Authorise Mode.                       *
      *  65  Insert Mode.                                             *
      *  69 - Position to Action Code.                                *
      *  70 - CGL012 is installed.                                    *
      *  71 - Pledge collateral type.                                 *
      *  72 - Mortgage collateral type.                               *
      *  73 - General/Specific Ind is 'S'.                            *
      *  74 - Account, Deposit or Pledge collateral type.             *
      *  75 - Charges, Guarantees, Letters or Official Guarantees     *
      *       collateral type.                                        *
      *  76 - F17(RWA) is enabled.                                    *                       CGL018
      *  77 - F15(Allocation) is enabled.                             *
      *  78 - F16(Narrative) is enabled.                              *
      *  79 - F10(Delete) is enabled.                                 *
      *  96  Message subfile display control                          *
      *  97  Message subfile end                                      *
      *  99  End of file indicator                                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D WZ0             S              1    DIM(35) CTDATA PERRCD(35)
     D WEI             S              1    DIM(35)
     D WMSG            S             75    DIM(3) CTDATA PERRCD(1)
      *
      ** Collateral Definition Details from incoming transaction
      ** - in screen format
     D NwCoScnFmt    E DS                  EXTNAME(GLSCOLPD)
      *
      ** Error indicators
     D OkCoScnFld    E DS                  EXTNAME(GLECOLPD)
      *
      ** Initial screen error inds
     D  IndInitial             1     12
      ** First screen error inds
     D  IndFirst              13     43
      ** Second screen error inds
     D  IndSecond             44     73
      ** Third screen error inds
     D  IndThird              74     84
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *
      *****************************************************************
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVE      *ALL'Y'       WEI
      *
     C                   SELECT
     C     ScrnMode      WHENEQ    'I'
     C                   MOVEA     IndInitial    WEI
     C     ScrnMode      WHENEQ    '1'
     C                   MOVEA     IndFirst      WEI
     C     ScrnMode      WHENEQ    '2'
     C                   MOVEA     IndSecond     WEI
     C     ScrnMode      WHENEQ    '3'
     C                   MOVEA     IndThird      WEI
     C                   ENDSL
      *
     C     DDACTN        IFEQ      'I'
     C                   EVAL      *IN65 = *ON
     C                   ELSE
     C                   EVAL      *IN65 = *OFF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     PENQ          OREQ      'E'
     C     DDACTN        OREQ      'X'
     C                   EVAL      *IN64 = *ON
     C                   ELSE
     C                   EVAL      *IN64 = *OFF
     C                   ENDIF
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
      *
     C                   Z-ADD     1             Cx                2 0
     C                   Z-ADD     10            Ex                2 0
     C     Cx            DOUGT     35
     C     WEI(Cx)       IFEQ      'N'
     C     WEI(Cx)       OREQ      'W'
     C                   MOVEL     '1'           *IN(Ex)
     C                   ENDIF
     C                   ADD       1             Cx
     C                   ADD       1             Ex
     C                   ENDDO
      *
      ** Set up the transaction reference to be used by the message handler.
      *
     C                   EVAL      TranRef = DDCREF
     C                   EVAL      ActionCode = DDACTN
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Enable CF10 (Confirm Delete).
      *
     C     PEINKJ        IFEQ      'Y'
     C                   EVAL      *IN79 = *ON
     C                   ELSE
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF
      *
      ** Enable CF15 (Allocation details).
      *
     C     PEINKP        IFEQ      'Y'
     C                   EVAL      *IN77 = *ON
     C                   ELSE
     C                   EVAL      *IN77 = *OFF
     C                   ENDIF
      *
      ** Enable CF16 (Narrative details).
      *
     C     PEINKQ        IFEQ      'Y'
     C                   EVAL      *IN78 = *ON
     C                   ELSE
     C                   EVAL      *IN78 = *OFF
     C                   ENDIF
      *
      ** Enable CF17 (Risk Weighted Assets).                                                  CGL018
      *                                                                                       CGL018
     C     PEINKR        IFEQ      'Y'                                                        CGL018
     C                   EVAL      *IN76 = *ON                                                CGL018
     C                   ELSE                                                                 CGL018
     C                   EVAL      *IN76 = *OFF                                               CGL018
     C                   ENDIF                                                                CGL018
      *
      ** Clear-out text message.
     C                   MOVEL     *Blanks       DDTEXT
      *
      ** Process Initial Screen
     C     ScrnMode      IFEQ      'I'
      *
      ** Position cursor on action code if it is blank.
     C     DDACTN        IFEQ      *Blanks
     C                   EVAL      *IN69 = *ON
     C                   ELSE
     C                   EVAL      *IN69 = *OFF
     C                   ENDIF
      *
     C                   MOVEA     '000'         *IN(77)
      *
     C     WSCREF        IFNE      *Blanks
     C                   MOVEL     WMSG(1)       DDTEXT
     C                   EVAL      %SUBST(DDTEXT:22:10) = WSCREF
     C                   MOVEL     *BLANKS       WSCREF
     C                   ENDIF
      *
      ** Set screen authorisation fields to display if CGL012 is present.
     C     CGL012        IFEQ      'Y'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      *OFF          *IN70
     C                   ENDIF
      *
      ** Write message subfile, details and footer screen.
     C                   WRITE     GLCOLLC1
     C                   TIME                    DDTIME
     C                   WRITE     GLCOLLD0
     C                   WRITE     GLCOLLF1
      *
      ** If not write only, read details screen.
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLCOLLD0                               99
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Process Detail Screens
     C     ScrnMode      IFEQ      '1'
     C     ScrnMode      OREQ      '2'
     C     ScrnMode      OREQ      '3'
      *
     C     PEINKJ        IFEQ      'Y'
     C                   MOVEL     WMSG(2)       DDTEXT
     C                   ENDIF
      *
     C     ConfInd       IFEQ      'Y'
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     WMSG(3)       DDTEXT
     C                   ENDIF
     C                   ENDIF
      *
     C                   TIME                    DDTIME
      *
     C     ScrnMode      IFEQ      '1'
     C                   WRITE     GLCOLLC1
     C                   WRITE     GLCOLLD1
     C                   WRITE     GLCOLLF1
      *
      ** If not write only, read details screen.
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLCOLLD1                               99
     C                   ENDIF
     C                   ENDIF
      *
     C     ScrnMode      IFEQ      '2'
     C                   WRITE     GLCOLLC1
      *
     C     CDCOPT        IFEQ      'P'
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'M'
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
     C     CDGNSP        IFEQ      'S'
     C                   MOVE      *ON           *IN73
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'A'
     C     CDCOPT        OREQ      'D'
     C     CDCOPT        OREQ      'P'
     C                   MOVE      *ON           *IN74
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'C'
     C     CDCOPT        OREQ      'G'
     C     CDCOPT        OREQ      'L'
     C     CDCOPT        OREQ      'O'
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C                   WRITE     GLCOLLD2
     C                   WRITE     GLCOLLF1
      *
      ** If not write only, read details screen.
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLCOLLD2                               99
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ScrnMode      IFEQ      '3'
     C                   WRITE     GLCOLLC1
     C                   WRITE     GLCOLLD3
     C                   WRITE     GLCOLLF1
      *
      ** If not write only, read details screen.
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLCOLLD3                               99
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WZ0           *IN(10)
     C                   MOVEA     '00000000000' *IN(69)
      *
      ** Set return keys.
      *
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKJ         PINKJ
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
     C                   MOVE      *INKQ         PINKQ
     C                   MOVE      *INKR         PINKR                                        CGL018
      *
     C     *INKC         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS :
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Status
     C                   PARM                    TransStat         7
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Fields OK Indicators
     C                   PARM                    OkCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Screen Mode
     C                   PARM                    ScrnMode          1
      *
      ** Enquiry Mode
     C                   PARM                    PENQ              1
      *
     C                   PARM                    CGL012            1
      *
      ** Collateral Processing Type
     C                   PARM                    CDCOPT            1
      *
      ** General/Specific Indicator
     C                   PARM                    CDGNSP            1
      *
      ** Enabled function keys
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Allocation
      ** KQ = Command key 16 = Narrative Details
     C                   PARM                    PEINKJ            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKQ            1
     C                   PARM                    PEINKR            1                          CGL018
      *
      ** Successful Inserted Collateral
     C                   PARM                    WSCREF           10
      *
      ** Confirmation indicator
     C                   PARM                    ConfInd           1
      *
      ** OUTPUT PARAMETERS:
      *
      ** Function Keys Taken
     C                   PARM                    PINKC             1
     C                   PARM                    PINKJ             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKQ             1
     C                   PARM                    PINKR             1                          CGL018
      *
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLDSP  ' DBPGM
     C                   OUT       LDA
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PSUser        DDUSER
     C                   MOVEL     PSJobName     DDWSID
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'GL'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'GLUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Message subfile control and program queue initialisation
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WZ0
00000000000000000000000000000000000
** CTDATA WMSG
Collateral Reference 9999999999 successfully inserted.
F10 = Confirm Delete
Press enter to confirm.
