     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased BoE Conversion')              *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPCVT1 - BYNASPX0 Transaction Details Conversion:        *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of the extension  *
      *             file BYNASPX0 from file to screen format.         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
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
 
     D PRetCodeIn      S             10
     D PDealN          S              6  0
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D NaspExFilFmt  E DS                  EXTNAME(BYNASPX0)
      ** Negotiable Assets Purchased Details File Format
 
     D NaspExScnFmt  E DS                  EXTNAME(MMNPEXPD)
      ** MM NASP extra data layout file
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialization
      *
     C                   EXSR      SRINIT
      *
      ** Set screen fields
      *
     C                   EXSR      SRSETFLD
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETFLD - Set Screen Fields                                 *
      *                                                               *
      *****************************************************************
     C     SRSETFLD      BEGSR
      *
      ** Guarantee Code
      *
     C                   EVAL      LGTEEEX = LGTEE
      *
      ** Qualifying Flag
      *
     C                   EVAL      LQUALEX = LQUAL
      *
      ** Final Maturity Date
      *
     C                   IF        LFMAT  = *Zeros
     C                   EVAL      LFMATEX = *Blanks
     C                   ELSE
     C                   MOVE      LFMAT         LFMATEX
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C                   MOVEL     *BLANKS       NaspExScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      *
      ** Return Code
     C                   PARM                    PRetCodeIn
      *
      ** Deal Number
      *
     C                   PARM                    PDealN
      *
      ** BYNASPX0 Transaction Details File Format
      *
     C                   PARM                    NaspExFilFmt
      *
      ** Output Parameters
      ** MMNPEXPD Transaction Details Screen Format
      *
     C                   PARM                    NaspExScnFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'MMNASPCVT1'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
