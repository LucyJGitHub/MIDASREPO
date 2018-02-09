     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Convert Module - Ext')
      *****************************************************************
      *                                                               *
      *  Midas - Fund Transfer ILE Module                             *
      *                                                               *
      *  FTOPAY2CT - FT Outgoing Payments Convert - Extension         *
      *                                                               *
      *  Function:  This module convert the details of the extension  *
      *             file FTOPX1PD to screen format.                   *
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
 
     D OPAYExFilFmt  E DS                  EXTNAME(FTOPX1L0)
     D OPAYExScnFmt  E DS                  EXTNAME(FTOPRXPD)
 
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
      ** SRConvert - SET SCREEN FIELDS
      *****************************************************************
     C     SRConvert     BEGSR
      *
      ** Ordering Type
      *
     C                   EVAL      LLLXORTY = OPORTY
      *
      ** Beneficiary Type
      *
     C                   EVAL      LLLXBETY = OPBETY
      *
      ** IBLC Operation Code
      *
     C                   EVAL      LLLXOPCO = OPOPCO
      *
      ** Country Code
      *
     C                   EVAL      LLLXCOCO = OPCOCO
      *
      ** Identification Code
      *
     C                   EVAL      LLLXIDCO = OPIDCO
      *
      ** Identification
      *
     C                   EVAL      LLLXIDEN = OPIDEN
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - INITIALIZATION
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   OPAYExScnFmt
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
      ** FTOPEXPD Extension File Format
      *
     C                   PARM                    OPAYExFilFmt
      *
      ** FTOPX1PD Extension Screen Format
      *
     C                   PARM                    OPAYExScnFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'FTOPAY2CT'
 
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
