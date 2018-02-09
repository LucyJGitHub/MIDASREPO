     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming Payments Convert Module - Ext')
      *****************************************************************
      *                                                               *
      *  Midas - Fund Transfer ILE Module                             *
      *                                                               *
      *  FTIPAY2CT - FT Incoming Payments Convert Module - Ext        *
      *                                                               *
      *  Function:  This module convert the file format details       *
      *             into screen format ready for display.             *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CFT032             Date 11Sep06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D IPAYExFilFmt  E DS                  EXTNAME(FTIPX1PD)
     D IPAYExScnFmt  E DS                  EXTNAME(FTIPRXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
 
     D PRetCodeIn      S             10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Set screen fields
 
     C                   EXSR      SRConvert
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRConvert - FILE FIELDS TO BE CONVERTED
      *****************************************************************
     C     SRConvert     BEGSR
      *
      ** Ordering Type
      *
     C                   EVAL      LLLXORTY = INORTY
      *
      ** Beneficiary Type
      *
     C                   EVAL      LLLXBETY = INBETY
      *
      ** IBLC Operation Code
      *
     C                   EVAL      LLLXOPCO = INOPCO
      *
      ** Country Code
      *
     C                   EVAL      LLLXCOCO = INCOCO
      *
      ** Identification Code
      *
     C                   EVAL      LLLXIDCO = INIDCO
      *
      ** Identification
      *
     C                   EVAL      LLLXIDEN = INIDEN
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - INITIALIZATION
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   IPAYExScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return code
      *
     C                   PARM                    PRetCodeIn
      *
      ** FTIPRXPD Extension File Format
      *
     C                   PARM                    IPAYExFilFmt
      *
      ** FTIPX1PD Extension Screen Format
      *
     C                   PARM                    IPAYExScnFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'FTIPAY2CT'
 
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
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
