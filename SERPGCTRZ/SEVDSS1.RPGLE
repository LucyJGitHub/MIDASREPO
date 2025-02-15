     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Deliverer of Securities (Line 1)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDSS1 - Validate Deliverer of Securities (Line 1)          *
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
      *                 CSD027             Date 09Dec05               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** � Automatically included D-specs       �
      ** � ==============================       �
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
      ** � End of automatically included D-specs�
      ** � =====================================�
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** � Manually included D-specs            �
      ** � =========================            �
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
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
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work parameter
     D OVER8           S              1A
     D WWDSS1          S              1A
     D WTDTP           S              2A
     D WWLI02          S              2A
     D WWLI34          S             34A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
     D PINKS           S              1A
      *
      ** +--------------------------------------+
      ** � End of D-specs                       �
      ** � ==============                       �
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** �                                                            �
      ** � *INZSR is executed at program activation.                  �
      ** �                                                            �
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
      *
      ** Validate Deliverer of Securities (Line 1)
      *
     C                   EXSR      SRValDss1
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESDSS1OK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESDSS1OK <> 'N'
     C                   MOVEL     ESDSS1        T2DSS1
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALDSS1 - Validation for Deliverer of Securities (Line 1)  *
      *                                                               *
      *****************************************************************
 
     C     SRValDss1     BEGSR
      *
      ** Validate If not Blank
      *
     C                   MOVEL     ESDSS1        WWDSS1
     C     ESDSS1        IFNE      *BLANKS
     C     WWDSS1        ANDNE     '#'
      *
      ** Override by F18
      *
     C     PSENT         IFEQ      'CEDEL'
     C     PINKS         ANDEQ     *ON
     C     OVER8         ANDEQ     '1'
     C                   MOVE      *OFF          PINKS
     C                   MOVE      'Y'           OVER8
     C                   ENDIF
      *
      ** If not Overridden
      *
     C     OVER8         IFNE      'Y'
 
     C     WTDTP         IFEQ      'TS'
     C     PGMEC         ANDNE     'Y'
 
     C     WTDTP         OREQ      'TS'
     C     PCCID         ANDNE     'P'
     C                   MOVE      'N'           ESDSS1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESDSS1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5290'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C     WWDSS1        IFNE      '/'
     C                   MOVE      'N'           ESDSS1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESDSS1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5210'     MsgIdXAr(IDx)
     C                   MOVE      '1'           OVER8
     C                   ENDIF
 
     C                   MOVEL     ESDSS1        WWLI02
     C     WWDSS1        IFEQ      '//'
     C                   MOVE      'N'           ESDSS1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESDSS1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5211'     MsgIdXAr(IDx)
     C                   MOVE      '1'           OVER8
     C                   ENDIF
 
     C                   MOVE      ESDSS1        WWLI34
     C     WWDSS1        IFEQ      '/'
     C     WWLI34        ANDEQ     *BLANKS
     C                   MOVE      'N'           ESDSS1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESDSS1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5212'     MsgIdXAr(IDx)
     C                   MOVE      '1'           OVER8
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     EValDss1      ENDSR
 
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
 
     C                   PARM                    WTDTP
 
     C                   PARM                    OVER8
 
     C                   PARM                    PINKS
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
