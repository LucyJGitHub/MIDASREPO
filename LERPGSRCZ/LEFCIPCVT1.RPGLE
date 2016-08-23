     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility BOE Conversion')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPCVT1- LE Facility BOE conversion                       *
      *                                                               *
      *                                                               *
      *  Function:  This module populates the Euro Facility of the    *
      *             Facility Data Layout.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CSD027             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Convert Customer Number to Alpha                    *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FCIPExFilFmt  E DS                  EXTNAME(BYFCLTX0)
      ** Extension File Format
 
     D FCIPExScnFmt  E DS                  EXTNAME(LEFCEXPD)
      ** Extension Screen Format
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter field
     D PRetCodeIn      S             10
     D*PCustNo*********S              6  0                                                    CSD027
     D PCustNo         S              6                                                       CSD027
     D PFacTyp         S              3  0
     D PFacSeq         S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      Sr_Init
 
      ** Set screen fields
 
     C                   EXSR      Sr_SetFld
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Sr_SetFld - SET SCREEN FIELDS
      *****************************************************************
     C     Sr_SetFld     BEGSR
 
      * Field 1
     C                   EVAL      LEUROX = LEURO
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Sr_Init - INITIALIZATION
      *****************************************************************
     C     Sr_Init       BEGSR
 
      ** Initialise data structure
 
     C                   MOVEL     *BLANK        FCIPExScnFmt
 
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
      * Input Parameters
      *
      * Return Code
     C                   PARM                    PRetCodeIn
      *
      *Customer Number
     C                   PARM                    PCustNo
      *
      *Facility Type
     C                   PARM                    PFacTyp
      *
      *Facility Sequence
     C                   PARM                    PFacSeq
      *
      *Extension File Format
     C                   PARM                    FCIPExFilFmt
      * Output Parameters
 
      * Extension Screen Format
     C                   PARM                    FCIPExScnFmt
 
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'LEFCIPCVT1'
 
 
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
