     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP payment subtype')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIPYST - Validate Payment Subtype                          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Parameters missing.  Applied fix 210654.            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.  (Recompiled)           *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Deal Type/Subtype file
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Externally described DS for Deal Subtype details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
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
      ** Initialise work variable.
      *
     C                   EVAL      Idx = 0
      *
      ** Validate Payment Subtype.
      *
     C                   EXSR      SRValStyp
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File field.
      *
     C                   IF        OKPYST = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKPYST <> 'N'
     C                   EVAL      IPPYST = DDPYST
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSTYP - Payment Subtype Validation                       *
      *                                                               *
      *****************************************************************
      *
     C     SRValStyp     BEGSR
      *
      ** Field must be entered and entry must be an existing
      ** Deal Subtype.
      *
     C                   IF        DDPYST = *BLANKS
     C                   MOVE      'N'           OKPYST
     C                   ADD       1             Idx
     C                   MOVEL     'DDPYST'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0040'     MsgIdXAr(Idx)
     C                   GOTO      EValStyp
     C                   ENDIF
      *
      ** Check for question mark.
      *
     C     '?'           SCAN      DDPYST                                 01
      *
      ** Question mark is invalid on *CTL function.
      *
     C                   IF        PMODE = '*FRONT' and
     C                             *IN01 = *On
     C                   MOVE      'N'           OKPYST
     C                   ADD       1             Idx
     C                   MOVEL     'DDPYST'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0041'     MsgIdXAr(Idx)
     C                   GOTO      EValStyp
     C                   ENDIF
      *
     C                   CALLB     'AODLSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDPYST        PDSTC             2
     C     SDDLST        PARM      SDDLST        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
      *
     C                   EVAL      DDPYST = ASDSTC
      *
      ** Subtype exists in Deal Subtypes file.  Check if Deal
      ** Type/Subtype combination exists.
      *
     C     KTypSTyp      CHAIN     FDDTSTL1                           01
      *
     C                   IF        *IN01 = *ON  or
     C                             RCID11 = '*'
     C                   MOVE      'N'           OKPYST
     C                   ADD       1             Idx
     C                   MOVEL     'DDPYST'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0041'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Blank out entry if question mark has been entered
      ** and no selection has been made.
      *
     C                   IF        PRtCd = '*NOSEL '
      *
     C                   MOVE      *BLANKS       DDPYST
     C                   MOVE      'N'           OKPYST
     C                   ADD       1             Idx
     C                   MOVEL     'DDPYST'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0040'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** Subtype is not existing.
      *
     C                   MOVE      'N'           OKPYST
     C                   ADD       1             Idx
     C                   MOVEL     'DDPYST'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0041'     MsgIdXAr(Idx)
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValStyp      ENDSR
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
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Setup key list for Deal Type/Subtype file (FDDTSTPD).
      *
     C     KTypSTyp      KLIST
     C                   KFLD                    PPYTP
     C                   KFLD                    DDPYST
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
(c) Finastra International Limited 2001
