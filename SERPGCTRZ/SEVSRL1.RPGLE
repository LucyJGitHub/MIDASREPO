     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Sender to Receiver Information 1')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSRL1 - Validate Sender to Receiver Information 1          *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
     D VA0             S              1    DIM(36) CTDATA PERRCD(36)            Validations Alpha
     D WARY            S              1    DIM(10)
      *
      ** Security API Trades Extended Settlements from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Security API Trades Extended Settlements for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
      *
      ** Security API Trades Extended Settlements error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work parameter
     D WKSRL1          S              1A
     D WWSRL1          S              1A
     D WWSR25          S             25A
     D WWSR03          S              3A
     D WWSR04          S              4A
     D WWSR06          S              6A
     D WWSR07          S              7A
     D WWSR08          S              8A
     D WWSR10          S             10A
     D WWVALI          S              1A
     D WTDTP           S              2A
     D WWCLTY          S              2A
     D WERR            S              1A
     D CSW014          S              1A
     D CSW201          S              1A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
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
      ** Initialise work variables.
     C                   EVAL      IDx = 0
      *
      ** Validate Sender to Receiver Information 1
      *
     C                   EXSR      SRValSrl1
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESSRL1OK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESSRL1OK <> 'N'
     C                   MOVEL     ESSRL1        T2SRL1
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSRL1 - Validation for Sender to Receiver Information 1  *
      *                                                               *
      *****************************************************************
 
     C     SRValSrl1     BEGSR
      *
      ** Validate If not Blank
      *
     C                   MOVE      *BLANKS       WKSRL1
     C                   MOVE      *BLANKS       WWSRL1
     C                   MOVE      *BLANKS       WWVALI
 
     C     ESSRL1        IFNE      *BLANKS
 
     C                   MOVEL     ESSRL1        WWSRL1
     C     WWSRL1        IFEQ      '/'
 
     C     WTDTP         IFEQ      'TS'
     C     WWCLTY        ANDNE     '14'
     C                   MOVEL     ESSRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04
     C     WWSR06        IFEQ      '/PRIOR'
     C     WWSR04        ANDEQ     'REQ/'
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   ENDIF
     C                   ENDIF
 
     C     WTDTP         IFEQ      'TP'
     C     WWCLTY        ANDNE     '14'
     C                   MOVEL     ESSRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04
     C     WWSR06        IFEQ      '/TRADE'
     C     WWSR04        ANDEQ     'CP/ '
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   ENDIF
     C                   ENDIF
 
     C     WTDTP         IFEQ      'TP'
     C     WWCLTY        ANDEQ     '5'
     C                   MOVEL     ESSRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04
     C                   MOVEL     WWSR04        WWSR03
     C     WWSR06        IFEQ      '/TRADE'
     C     WWSR03        ANDEQ     'CP/'
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     ESSRL1        WWSR06
     C                   MOVEL     ESSRL1        WWSR07
     C                   MOVEL     ESSRL1        WWSR08
     C     WWSR06        IFEQ      '/AGEN/'
     C     WWSR06        OREQ      '/PRIN/'
     C     WWSR06        OREQ      '/PHON/'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
     C     WWSR07        IFEQ      '/TELEX/'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
     C     WWSR08        IFEQ      '/BROKER/'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
 
     C     WWCLTY        IFEQ      '14'
     C                   MOVEL     ESSRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04
     C                   MOVE      ESSRL1        WWSR25
     C     WWSR06        IFEQ      '/ADDPR'
     C     WWSR04        ANDEQ     'TY/ '
     C     WWSR25        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   ENDIF
     C     WWSR06        IFEQ      '/CANCE'
     C     WWSR04        ANDEQ     'L/  '
     C     WWSR25        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   ENDIF
     C     WWSR06        IFEQ      '/CONFI'
     C     WWSR04        ANDEQ     'RM/ '
     C     WWSR25        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWVALI
     C                   MOVE      'Y'           WKSRL1
     C                   ENDIF
     C                   ENDIF
 
     C     CSW014        IFEQ      'Y'
     C                   MOVEL     ESSRL1        WWSR06
     C     WWSR06        IFEQ      '/OCMT/'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
     C                   ENDIF
 
     C     CSW201        IFEQ      'Y'
     C                   MOVEL     ESSRL1        WWSR10
     C                   EXSR      SR2001
     C                   ENDIF
 
     C     WWVALI        IFNE      'Y'
     C                   MOVE      'N'           ESSRL1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESSRL1'      FldNamXAr(IDx)
     C     CSW201        IFEQ      'Y'
     C                   MOVEL     'SEW5293'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVEL     'SEW5265'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     EValSrl1      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR2001 - To Validate Swift2001 Codewords                     *
      *                                                               *
      *****************************************************************
 
     C     SR2001        BEGSR
 
     C                   MOVEA     WWSR10        WARY
     C                   MOVE      'N'           WERR              1
     C                   Z-ADD     1             X                 3 0
 
     C     X             DOWLT     10
     C     WERR          ANDEQ     'N'
     C                   ADD       1             X
     C     WARY(X)       LOOKUP    VA0                                    90
 
     C     WARY(X)       IFEQ      '/'
     C                   LEAVE
     C                   ENDIF
 
     C     *IN90         IFEQ      *OFF
     C     X             OREQ      10
     C     WARY(X)       ANDNE     '/'
     C                   MOVE      'Y'           WERR
     C                   ENDIF
 
     C                   ENDDO
 
     C     WARY(2)       IFNE      '/'
     C     WERR          ANDEQ     'N'
     C                   MOVE      'Y'           WWVALI
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    WTDTP
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    CSW014
 
     C                   PARM                    CSW201
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    WKSRL1
 
     C                   PARM                    WWSRL1
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
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
(c) Finastra International Limited 2003
**  VA0  - All Numeric Chars
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
