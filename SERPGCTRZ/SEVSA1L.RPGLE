     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Counterparty Safekeeping A/c')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSA1L - Validate Counterparty Safekeeping A/c (a/c line)   *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
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
     D WWSA1L          S              1A
     D WWLI02          S              2A
     D SWRTN           S              7A
     D WTDTP           S              2A
     D CSE028          S              1A
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
      ** Validate Counterparty Safekeeping A/c (a/c line)
      *
     C                   EXSR      SRValSa1l
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESSA1LOK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESSA1LOK <> 'N'
     C                   MOVEL     ESSA1L        T2SA1L
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSA1L - Validation for Counterparty Safekeeping A/c      *
      *                                                               *
      *****************************************************************
 
     C     SRValSa1l     BEGSR
      *
      ** ESSA1L If not Blank
      *
     C     ESSA1L        IFNE      *BLANKS
 
     C     PGMEC         IFNE      'Y'
     C     *IN88         ANDEQ     *OFF
     C     PCCID         ORNE      'C'
     C     *IN88         ANDEQ     *OFF
     C                   MOVE      'N'           ESSA1LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESSA1L'      FldNamXAr(IDx)
     C     ESSA1N        IFEQ      *BLANKS
     C     SWRTN         ANDNE     'CSW098 '
     C                   MOVEL     'SEW5206'     MsgIdXAr(IDx)
     C                   ENDIF
     C     SWRTN         IFEQ      'CSW098 '
     C                   MOVEL     'SEW5177'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     ESSA1L        WWSA1L
     C     WWSA1L        IFNE      '/'
     C                   MOVE      'N'           ESSA1LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESSA1L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5210'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   MOVEL     ESSA1L        WWLI02
     C     WWLI02        IFEQ      '//'
     C                   MOVE      'N'           ESSA1LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESSA1L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5211'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
      *
      ** For a Confirmation of Purchase, Either Field 83 or 87 may
      ** be present.
      *
     C     WTDTP         IFEQ      'TP'
     C     ESSA1N        ANDNE     *BLANKS
     C     SWRTN         ANDNE     'CSW098  '
 
     C     WTDTP         OREQ      'TP'
     C     ESSA1L        ANDNE     *BLANKS
 
     C     ESRSSN        IFNE      *BLANKS
     C     ESRSS1        ORNE      *BLANKS
     C     ESDSSN        ORNE      *BLANKS
     C     ESDSS1        ORNE      *BLANKS
     C                   MOVE      'N'           ESSA1NOK
     C                   MOVE      'N'           ESSA1LOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESSA1L'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5270'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
 
     C     EValSa1l      ENDSR
 
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
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
 
     C                   PARM                    WTDTP
 
     C                   PARM                    CSE028
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
 
      *
      ** Enable display of counterparty safekeeping a/c if
      ** CSE028 is on and ISO15022 is on.
      *
     C     CSE028        IFEQ      'Y'
     C     PSNEW         ANDEQ     'Y'
     C     PGMES         ANDEQ     'Y'
     C                   EVAL      *IN88 = *ON
     C                   ELSE
     C                   EVAL      *IN88 = *OFF
     C                   ENDIF
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
(c) Misys International Banking Systems Ltd. 2003
