     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities BOE convert file to screen fmt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  SESECSCVT1- SE Securities BOE convert file to screen format  *
      *                                                               *
      *  Function:  This module convert the details of the extension  *
      *             file BYSECTX0 to screen format.                   *
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
 
     D SecsExFilFmt  E DS                  EXTNAME(BYSECTX0)
      ** Securities File Extension
 
     D SecsExScnFmt  E DS                  EXTNAME(SESEEXPD)
      ** Securities Screen Extension
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
 
     D PRetCodeIn      S             10
     D PSecShrtNme     S             10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      SRINIT
 
      ** Set screen fields
 
     C                   EXSR      SRSETFLD
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSETFLD - SET SCREEN FIELDS
      *****************************************************************
     C     SRSETFLD      BEGSR
      *
      ** gurantee code
      *
     C                   EVAL      GTEE   = LGTEE
      *
      ** qualifying flag
      *
     C                   EVAL      QUAL   = LQUAL
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - INITIALIZATION
      *****************************************************************
     C     SRINIT        BEGSR
 
     C                   CLEAR                   SecsExScnFmt
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
      ** Security Shortname
      *
     C                   PARM                    PSecShrtNme
      *
      ** BYSECTX0 Extension File Format
      *
     C                   PARM                    SecsExFilFmt
      *
      ** Outputs
      *
      ** SESEEXPD Extension Screen Format
      *
     C                   PARM                    SecsExScnFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SESECSCVT1'
 
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
