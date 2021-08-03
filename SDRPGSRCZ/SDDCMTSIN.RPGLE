     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - Details Maintenance')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTSIN - SD Document Management Input                     *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Document Management                           *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Current Deal in File Format
     D CrDcFilFmt    E DS                  EXTNAME(SDDCMTPD)
 
      * (Current) Deal in Screen Format
     D CrDcScnFmt    E DS                  EXTNAME(SDDCMSPD)
     D                                     PREFIX(A)
 
      ** New Deal in File Format
     D NwDcFilFmt    E DS                  EXTNAME(SDVDCMTPD)
     D                                     PREFIX(V)
 
      ** New Deal in Screen Format
     D NwDcScnFmt    E DS                  EXTNAME(SDDCMSPD)
 
      ** Error indicators
     D SDEDCMT       E DS                  EXTNAME(SDEDCMTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Modules details accessed via access program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Midas Customer details accessed via access program
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Midas Non-Account Holder details accessed via access program
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Midas Document Code details accessed via access program
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current Control Indicators for Main Detail Screen
     D WCCIM           DS
     D  WEKYFD                 1      1
     D  WEDTFD                 2      2
     D  WEINKJ                 3      3
     D  WEINKV                 4      4
 
     D WPCIM           DS             4
 
     D CUSNAH          DS
     D  CHKCUS                 1      6
     D  CHKNAH                 7     10
 
      ** Re-display Main details screen, in case of amends or inserts
     D REDSPLY         S              1A   INZ('Y')
 
      ** Work Fields
     D WOPSEL          S              1A
     D WSCRN           S              1A
     D WRDNB           S              1A
     D WBDSFL          S              1A
     D WRDSFL          S              1A
     D WPACTN          S              1A
     D WPCODE          S              2A
     D WCODE           S              2A
     D WSEQN           S              3S 0
     D WHDTFD          S              1A
     D WERRMS          S              7A
     D PCODE           S              2A
     D Idx             S              3P 0
     D Widx            S              3P 0
     D PRTCD           S              7A
     D POPTN           S              7A
 
     D PINKC           S              1A
     D PINKI           S              1A
     D PINKE           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKV           S              1A
 
     D PIREFN          S             10A
     D PICSSN          S             10A
     D PINRNM          S             20A
     D PICRTN          S             10A
 
     D PINSEQ          S              3S 0
     D PINTYP          S              1A
     D PINMOD          S              1A
 
      ** Previous Control Indicators for main detail screen
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDDCMTS008
 
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
      /COPY WNCPYSRC,SDDCMTS001
 
      ** BUILD BROWSE SUBFILE RECORD
      *
      *
     C                   IF        WSCRN = 'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
      *
     C                   IF        WSCRN = 'R'
     C                   EXSR      RBDBRW
     C                   ENDIF
      *
     C                   DOW       WSCRN = 'I'
     C                   EXSR      SCRDIN
     C                   ENDDO
 
      *
      ** DO WHILE SCREEN: MAIN DETAILS
      *
     C                   DOW       WSCRN = 'M'
     C                   EXSR      SCRDSP
     C                   ENDDO
 
      *
      ** DO FILE UPDATES
      *
     C                   IF        WSCRN = 'U'
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
      ** TERMINATE PROGRAM
     C                   IF        WSCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDDCMTS009
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  BLDBRW - Process Screen: Main Details                        *
      *                                                               *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      ** Update 'previous' key fields & screen control indicator
      *
     C                   EVAL      WRDNB = *BLANK
      *
      ** WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SDDCMTBRW'
      *
      ** INPUT PARAMETERS
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    PIREFN
     C                   PARM                    PICSSN
     C                   PARM                    PINRNM
     C                   PARM                    PICRTN
     C                   PARM      'Y'           WBDSFL
     C                   PARM      *BLANK        WRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *BLANK        WERRMS
     C                   PARM      *BLANK        WOPSEL
     C                   PARM      *BLANK        WCODE
     C                   PARM      *ZERO         WSEQN
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI
     C                   PARM      '0'           PINKE
     C                   PARM                    PINTYP
     C                   PARM                    PINMOD
      *
      ** If CK/3 taken in browse, end program
      *
     C                   IF        PINKC = '1'
     C                   EXSR      SRENDP
     C                   GOTO      EBLBRW
     C                   END
      *
      ** If Insert (F9) selected from browse, go to Key Screen
      *
     C                   IF        WOPSEL = 'I'
     C                   EVAL      WSCRN  = 'I'
     C                   EVAL      DDACTN = 'I'
     C                   GOTO      EBLBRW
     C                   END
      *
      ** If F5 taken in browse, Reload subfile
      *
     C                   IF        PINKE =  '1'
     C                   EVAL      WSCRN = 'B'
     C                   GOTO      EBLBRW
     C                   ENDIF
      *
      ** If error message returned from browse, send it to detail screen
      *
     C                   IF        WERRMS <> *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLBRW
     C                   ENDIF
      *
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
      *
     C                   IF        PINKL <> '1'
     C                   EVAL      WRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   GOTO      EBLBRW
     C                   ENDIF
      *
     C     EBLBRW        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RBDBRW - PROCESS SCREEN: MAIN DETAILS                        *
      *                                                               *
      *****************************************************************
     C     RBDBRW        BEGSR
      *
      ** Write/Read Display Screen
      *
     C                   CALLB     'SDDCMTBRW'
      *
      ** Input Parameters
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    PIREFN
     C                   PARM                    PICSSN
     C                   PARM                    PINRNM
     C                   PARM                    PICRTN
     C                   PARM      *BLANK        WBDSFL
     C                   PARM      'Y'           WRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *BLANK        WERRMS
     C                   PARM      *BLANK        WOPSEL
     C                   PARM      *BLANK        WCODE
     C                   PARM      *ZERO         WSEQN
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI
     C                   PARM      '0'           PINKE
     C                   PARM                    PINTYP
     C                   PARM                    PINMOD
      *
     C                   IF         WCODE <>   *BLANK
      *
      ** Retrieve deal details
      *
     C                   EVAL      DDACTN  = WOPSEL
     C                   EVAL      DDCODE  = WCODE
     C                   EVAL      PINSEQ  = WSEQN
     C                   EVAL      REDSPLY = 'N'
 
     C                   EXSR      SRRTV
      *
     C                   IF        DDACTNOK  = 'N' OR
     C                             DDREFNOK  = 'N'
     C                   EVAL      WSCRN = 'B'
     C                   GOTO      ERBBRW
     C                   END
      *
      ** Set field and function key status on main details screen
      ** (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ** Put the deal on the main details screen
      *
     C                   EXSR      SRCVT
      *
     C                   EVAL      WSCRN = 'M'
      *
      ** Else, reset read next browse subfile record
      *
     C                   ELSE
     C                   EVAL      WRDNB = *BLANK
      *
      ** Go to Browse Screen
      *
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
      *
      ** If CK/3 taken in browse, end program
      *
     C                   IF        PINKC = '1'
     C                   EXSR      SRENDP
     C                   GOTO      ERBBRW
     C                   END
      *
      ** If error message returned from browse, send it to detail screen
      *
     C                   IF        WERRMS <> *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      ERBBRW
     C                   ENDIF
      *
     C     ERBBRW        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRDIN - Input Screen: Main Details                          *
      *                                                               *
      *****************************************************************
     C     SCRDIN        BEGSR
      *
      ** Update 'previous' key fields & screen control indicator
      *
     C                   EVAL      DDREFN = PIREFN
     C                   EVAL      DDCSSN = PICSSN
     C                   EVAL      DDCRTN = PICRTN
     C                   EVAL      DDCRNM = PINRNM
     C                   EVAL      DDRTYP = PINTYP
     C                   EVAL      WPACTN = DDACTN
     C                   EVAL      WPCODE = DDCODE
     C                   MOVEL(P)  WCCIM         WPCIM
     C                   EVAL      DDCODE = *BLANKS
     C                   EVAL      DDNARR = *BLANKS
     C                   EVAL      DDSEQN = *BLANKS
      *
      ** WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SDDCMTDSP'
      *
      ** INPUT PARAMETERS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDcScnFmt
      *
      ** FIELDS IN ERROR
     C                   PARM                    SDEDCMT
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
      ** ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'Y'           WEKYFD
     C                   PARM      'Y'           WEDTFD
      *
      ** ENABLED FUNCTION KEYS
     C                   PARM                    WEINKJ
     C                   PARM                    WEINKV
      *
      ** OUTPUT PARAMETERS
      *
      ** FUNCTION KEYS
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKV
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM      'Y'           WHDTFD            1
     C                   PARM      'Y'           CLRSCRN           1
     C                   PARM                    PINTYP            1
     C                   PARM                    PINMOD
 
     C                   EVAL      WSCRN = 'M'
      ** CK/3 - END PROGRAM
      *
     C     PINKC         CASEQ     '1'           SRENDP
      *
      ** CK/12 - Cancel on Main Details Screen
      *
     C     PINKL         CASEQ     '1'           SRCANC
      *
      ** Validate Input To Main Details Screen
      *
     C                   CAS                     SRVALM
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRDSP - PROCESS SCREEN: MAIN DETAILS                        *
      *                                                               *
      *****************************************************************
     C     SCRDSP        BEGSR
      *
      ** Update 'previous' key fields & screen control indicator
      *
     C                   EVAL      DDREFN = PIREFN
     C                   EVAL      DDCSSN = PICSSN
     C                   EVAL      DDCRTN = PICRTN
     C                   EVAL      DDCRNM = PINRNM
     C                   EVAL      DDRTYP = PINTYP
     C                   MOVEL     PINSEQ        DDSEQN
     C                   EVAL      WPACTN = DDACTN
     C                   EVAL      WPCODE = DDCODE
     C                   MOVEL(P)  WCCIM         WPCIM
      *
      ** Write/Read Display Screen
      *
     C                   CALLB     'SDDCMTDSP'
      *
      ** Input Parameters
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDcScnFmt
      *
      ** Fields in Error
     C                   PARM                    SDEDCMT
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
      ** ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    WEKYFD
     C                   PARM                    WEDTFD
      *
      ** ENABLED FUNCTION KEYS
     C                   PARM                    WEINKJ
     C                   PARM                    WEINKV
      *
      ** OUTPUT PARAMETERS
      *
      ** FUNCTION KEYS
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKV
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM                    WHDTFD            1
     C                   PARM                    CLRSCRN           1
     C                   PARM                    PINTYP
     C                   PARM                    PINMOD
      *
      ** RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       SDEDCMT
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
      *
      ** If Enter is taken from main screen and key fields are blank, show the browse
      *
      ** CK/3 - End Program
      *
     C     PINKC         CASEQ     '1'           SRENDP
      *
      ** CK/12 - Cancel On Main Details Screen
      *
     C     PINKL         CASEQ     '1'           SRCANC
      *
      ** CK/21 - Build Browse Comments History
      *
     C     PINKV         CASEQ     '1'           SCRDCH
      *
      ** Validate Input to Main Details Screen
      *
     C                   CAS                     SRVALM
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALM - Validate Input to Main Details Screen               *
      *                                                               *
      *****************************************************************
     C     SRVALM        BEGSR
      *
      ** Retrieve deal details
      *
     C                   EXSR      SRRTV
      *
      ** If any of key fields are not OK
      ** Re-output screen with error messages on it
      *
     C                   IF        DDACTNOK  = 'N' OR
     C                             DDREFNOK  = 'N' OR
     C                             DDCODEOK  = 'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      ** Set field and function key status on main details screen
      ** (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ** If action code is delete, or enquire or action is
      ** amend and key fields have changed
      ** Put the deal on the main details screen
      *
     C                   IF          DDACTN    =     'D'  OR
     C                               DDACTN    =     'E'  OR
     C                               DDACTN    =     'A'  AND
     C                               DDACTN    <>    WPACTN  OR
     C                               DDACTN    =     'A'  AND
     C                               DDCODE    <>    WPCODE
     C                   EXSR      SRCVT
     C                   ENDIF
      *
     C                   IF          DDCODE    <>    WPCODE  AND
     C                               DDACTN    <>    'I'     OR
     C                               DDACTN    <>    WPACTN  OR
     C                               WCCIM     <>    WPCIM
     C                   EVAL      REDSPLY = 'Y'
     C                   ENDIF
      *
      ** IF DELETE
      *
     C                   IF        DDACTN = 'D'
      *
      ** Update Deal in File Format
      *
     C                   MOVEL     CrDcFilFmt    NwDcFilFmt
      *
      ** IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C                   IF        PINKJ = '1'
     C                   EVAL      WSCRN = 'U'
     C                   ENDIF
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      ** IF ENQUIRE
      *
     C                   IF        DDACTN = 'E'
      *
      ** Update Deal in File Format
      *
      ** Update Deal in File Format
      *
     C                   MOVEL     CrDcFilFmt    NwDcFilFmt
      *
      ** IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C                   IF        WRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ENDIF
      *
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      ** IF INSERT OR AMEND
      *
     C                   IF        DDACTN = 'I'
     C                             OR DDACTN = 'A'
      *
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       SDEDCMT
     C                   CLEAR                   NwDcFilFmt
      * IF AMEND
 
      ** Update Deal in File Format
      *
      *
      ** Update Deal in File Format
      *
     C                   MOVEL     CrDcFilFmt    NwDcFilFmt
 
     C                   IF        REDSPLY = 'Y'
     C                   EVAL      REDSPLY = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      ** Validate security details
      *
     C                   CALLB     'SDDCMTVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDcScnFmt
     C                   PARM                    SDEDCMT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    NwDcFilFmt
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** If errors returned
      *
     C                   IF        IDX = 0 AND WIDX = 0
     C                   EVAL      WSCRN = 'U'
     C                   ENDIF
     C                   ENDIF
 
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTV  - Retrieve Document Management Detail                 *
      *                                                               *
      *****************************************************************
     C     SRRTV         BEGSR
      *
      ** Retrieve Details
      *
     C                   CALLB     'SDDCMTRTV'
      *
      ** INPUTS
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      PMODE             6
      *
      ** Response mode
     C                   PARM      'S'           RespMode
      *
      ** Entry Mode
     C                   PARM                    PINMOD
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Customer and Document Code
     C                   PARM                    PIREFN
     C                   PARM                    PINTYP
     C                   PARM                    DDCODE
     C                   PARM                    PINSEQ
      *
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ** OUTPUTS
      *
      ** (Current) deal in file format
     C                   PARM                    CrDcFilFmt
      *
      ** OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ** OK - Security
     C                   PARM      *BLANK        DDREFNOK
      *
     C                   PARM      *BLANK        DDCODEOK
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      ** Document Code narrative
     C                   PARM                    DDNARR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCVT  - Put Details on the Main Details Screen              *
      *                                                               *
      *****************************************************************
     C     SRCVT         BEGSR
      *
      * Call program to fill screen fields with data from SDDCMTPD
      *
     C                   CALLB     'SDDCMTCVT'
      *
      ** INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Deal in file format
     C                   PARM                    CrDcFilFmt
      *
      ** OUTPUTS
      *
      ** Deal in screen format
     C                   PARM                    NwDcScnFmt
      *
      ** Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDcScnFmt    CrDcScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCRDCH - Build comment history browse subfile                *
      *                                                               *
      *****************************************************************
 
     C     SCRDCH        BEGSR
 
     C                   CALLB     'SDDCMTHBW'
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    PIREFN
     C                   PARM                    PINTYP
     C                   PARM                    DDCODE
     C                   PARM                    DDNARR
     C                   PARM                    PINSEQ
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** F3 - End Program
     C     PINKC         CASEQ     '1'           SRENDP
     C                   CAS                     SRCANH
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SFDS@M - Set Field status on main details screen             *
      *           According to action code                            *
      *                                                               *
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      ** Enable/disable key & detail fields on main details screen
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'E', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   EVAL      WEKYFD = 'N'
     C                   EVAL      WEDTFD = 'Y'
     C                   ELSE
     C                   EVAL      WEKYFD = 'N'
     C                   EVAL      WEDTFD = 'N'
     C                   END
      *
     C                   EVAL      WHDTFD = 'N'
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SFKS@M - Set Function Key Status On Main Details Screen      *
      *           According to Action Code                            *
      *                                                               *
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      ** Enable/disable function keys on main details screen
      *
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C                   IF        DDACTN = 'D'
     C                   EVAL      WEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      WEINKJ = 'N'
     C                   END
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      WEINKV = 'N'
     C                   ELSE
     C                   EVAL      WEINKV = 'Y'
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIFDSM - Initialize Field Status On Main Details Screen     *
      *                                                               *
      *****************************************************************
     C     SRIFDSM       BEGSR
      *
      ** Enable Key & Details Fields on Main Details Screen
      *
     C                   EVAL      WEKYFD = 'Y'
     C                   EVAL      WEDTFD = 'N'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIFKSM - Initialize Function Key Status on Main Details Scr *
      *                                                               *
      *****************************************************************
     C     SRIFKSM       BEGSR
      *
      ** Enable/Disable Function Keys on Main Details Screen
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C                   EVAL      WEINKJ = 'N'
     C                   EVAL      WEINKV = 'Y'
      *
     C                   EVAL      PINKJ  = '0'
     C                   EVAL      PINKL  = '0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCANH - CANCEL ON MAIN DETAILS SCREEN                       *
      *                                                               *
      *****************************************************************
     C     SRCANH        BEGSR
 
      ** Return to previous screen
 
     C                   EVAL      WSCRN = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCANC - Cancel On Main Details Screen                       *
      *                                                               *
      *****************************************************************
     C     SRCANC        BEGSR
      *
      ** If input fields are enabled
      ** Blank the main details screen
      *
     C                   EVAL      NwDcScnFmt = *BLANK
      *
      ** Initialize field and function key status on main details screen
      *
     C                   EXSR      SRIFDSM
     C                   EXSR      SRIFKSM
      *
     C                   EVAL      WSCRN = 'B'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SNDM@M - Send a Message To Main Details Screen               *
      *                                                               *
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      ** If single branching, user can't browse file
      *
     C                   IF        WERRMS = 'FXM0292'
     C                   EVAL      DDACTNOK = 'N'
     C                   ENDIF
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E)   = WERRMS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDAT - Updates                                            *
      *                                                               *
      *****************************************************************
     C     SRUPDAT       BEGSR
 
     C                   EVAL      VDVLTYP = DDACTN
      *
     C                   CALLB     'SDDCMTUPD'
     C                   PARM      *BLANKS       RETURNCODE
     C                   PARM                    NwDcFilFmt
      *
      * If there were any Errors in the Update Functions, Rollback any
      * Updates and End this Program. Otherwise, Commit the updates
      *
     C                   IF        RETURNCODE <> *BLANK
     C                   ROLBK
     C                   IF        RETURNCODE =  '*ERROR '
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
      *
     C                   IF        RETURNCODE =   '*RECUPD'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'MMM1067'
     C                   EVAL      CLRSCRN       = 'N'
     C                   ENDIF
      *
      ** If update not done due to error in Background Update of TABLETK file
      ** Send message 'Unable to update' to screen.
      *
     C                   IF        RETURNCODE =   '*ERTBTK'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'USR0015'
     C                   EVAL      CLRSCRN       = 'N'
     C                   ENDIF
      ** Blank the Main Details screen
      *
     C                   EVAL      NwDcScnFmt = *BLANK
     C                   EVAL      CLRSCRN    = 'Y'
      *
      ** Initialize field and function key status on main details screen
      *
     C                   EXSR      SRIFDSM
     C                   EXSR      SRIFKSM
      *
      ** Return to Browse Details Screen
      *
     C                   EVAL      WSCRN = 'B'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCREF - Check Reference if Customer or Non-Account Holder   *
      *                                                               *
      *****************************************************************
     C     SRCREF        BEGSR
 
      ** Check field if customer number or NAHO reference
 
     C                   EVAL      DDRTYP =  PINTYP
 
     C                   CALLB     'SDDCMTDFT'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PIREFN
     C                   PARM                    PINTYP
     C                   PARM      *BLANK        PCODE
     C                   PARM      *BLANK        SDCUST
     C                   PARM      *BLANK        SDNAHO
     C                   PARM      *BLANK        SDDOCM
 
      ** Access Customer Details
     C                   IF        PINTYP = 'C'
 
     C                   EVAL      DDREFN = *BLANKS
     C                   EVAL      PIREFN = BBCUST
     C                   EVAL      PICSSN = BBCSSN
     C                   EVAL      PICRTN = BBCRTN
     C                   EVAL      PINRNM = BBCRNM
     C                   EVAL      DDREFN = BBCUST
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRTN = BBCRTN
     C                   EVAL      DDCRNM = BBCRNM
     C                   ENDIF
 
      ** Access Non Account Holder
     C                   IF        PINTYP = 'N'
 
     C                   EVAL      PIREFN = NHNAHO
     C                   EVAL      PICSSN = *BLANKS
     C                   EVAL      PICRTN = NHNATW
     C                   EVAL      PINRNM = NHNARN
     C                   EVAL      DDREFN = NHNAHO
     C                   EVAL      DDCSSN = *BLANKS
     C                   EVAL      DDCRTN = NHNATW
     C                   EVAL      DDCRNM = NHNARN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDP - END PROGRAM                                         *
      *                                                               *
      *****************************************************************
     C     SRENDP        BEGSR
      *
      ** Terminate program
      *
     C                   EVAL      WSCRN = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - INITIAL PROCESSING                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Entry Mode
     C                   PARM                    PINMOD
      *
      * Customer Number
     C                   PARM                    PIREFN
      *
      * Reference Indicator
     C                   PARM                    PINTYP
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SDDCMTSIN'
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Databse  Error
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 902
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check Reference if Document for Customer or Non-Account Holder
      *
     C                   EXSR      SRCREF
      *
     C                   EVAL      WRDNB = *BLANK
      *
      ** Start on Main Details Screen
      *
     C                   EVAL      WSCRN = 'B'
 
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
