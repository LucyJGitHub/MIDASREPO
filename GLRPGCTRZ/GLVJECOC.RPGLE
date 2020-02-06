     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JECOCx Country code')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLVJECOC  - Validate Country code                            *
      *                                                               *
      *  Function:  This module receives parameters containing a      *
      *             Country code and confirm wether it is a valid     *
      *             Country code or not                               *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP122CTYLX*-*Core*Luxembourg*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX607  *CREATE    Date 13Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX607 - API Luxembourg - Function GLBITP                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for country details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, Short data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #7LXCOCF        S              2A
     D #7LXOPCF        S              3A
     D @CLIM           S             14P 0
     D WPTAF           S             13P 0
     D WWBKCO          S              2A
 
      ** Define parameters for call module
     D @KEY1           S              2A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ** Validate field
      *
      ** Check country limit
      *
     C     WPTAF         IFGT      @CLIM
      *
      ** If blank - report error
      *
     C     #7LXCOCF      IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10004'     #MSGID
      *
      ** If not blank, check if exist
      *
     C                   ELSE
     C                   MOVE      *BLANKS       @KEY1
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #7LXCOCF      @KEY1
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10005'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Country code 'BE' not authorize in Belgium & 'LU' in Luxembourg
      *
     C     #7LXCOCF      IFEQ      WWBKCO
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10013'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** For Operation Codes 430, 431, 421, 422, 424, 428, 429, 473 &
      ** 478 check if Country Code is an EMU country
      *
     C     #7LXOPCF      IFEQ      '430'
     C     #7LXOPCF      OREQ      '431'
     C     #7LXOPCF      OREQ      '421'
     C     #7LXOPCF      OREQ      '422'
     C     #7LXOPCF      OREQ      '424'
     C     #7LXOPCF      OREQ      '428'
     C     #7LXOPCF      OREQ      '429'
     C     #7LXOPCF      OREQ      '473'
     C     #7LXOPCF      OREQ      '478'
     C     #7LXCOCF      IFNE      'DE'
     C     #7LXCOCF      ANDNE     'AT'
     C     #7LXCOCF      ANDNE     'ES'
     C     #7LXCOCF      ANDNE     'FI'
     C     #7LXCOCF      ANDNE     'FR'
     C     #7LXCOCF      ANDNE     'GP'
     C     #7LXCOCF      ANDNE     'GF'
     C     #7LXCOCF      ANDNE     'MQ'
     C     #7LXCOCF      ANDNE     'RE'
     C     #7LXCOCF      ANDNE     'YT'
     C     #7LXCOCF      ANDNE     'PM'
     C     #7LXCOCF      ANDNE     'IE'
     C     #7LXCOCF      ANDNE     'IT'
     C     #7LXCOCF      ANDNE     'NL'
     C     #7LXCOCF      ANDNE     'PT'
     C     #7LXCOCF      ANDNE     'AT'
     C     #7LXCOCF      ANDNE     'XA'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL30001'     #MSGID
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If amount is lower then limit, force blanks
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       #7LXCOCF
     C                   ENDIF
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #7LXCOCF
     C                   PARM                    #7LXOPCF
     C                   PARM                    WPTAF
     C                   PARM                    @CLIM
     C                   PARM                    WWBKCO
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
