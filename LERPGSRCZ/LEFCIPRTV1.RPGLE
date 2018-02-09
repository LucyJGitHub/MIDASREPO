     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility BoE Retrieve')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Support                             *
      *                                                               *
      *  LEFCIPRTV1- LE Facility BOE Retrieve                         *
      *                                                               *
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database.                                     *
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
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FBYFCLTY0  IF   E           K DISK    INFSR(*PSSR)
 
      * Transaction File by Front Office Id
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** External DS for
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
     D PRetCodeIn      S             10
     D PActn           S              1
     D PFORTID         S             20
     D PCustno         S              6
     D PFacTyp         S              3
     D PFacSeq         S              2
     D PBranch         S              3
     D PRtlFac         S             10
 
      ** key fields
     D KCustNo         S                   LIKE(LCNUM)
     D KFacTyp         S                   LIKE(LFACT)
     D KFacSeq         S                   LIKE(LFCNO)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Key list
      *
     C     Fclity_key    KLIST
     C                   KFLD                    KCustNo
     C                   KFLD                    KFacTyp
     C                   KFLD                    KFacSeq
      *
      * Initialization
      *
     C                   EXSR      Sr_Init
      *
     C     Fclity_Key    CHAIN     BYFCLTY0
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      * Sr_Init - INITIALIZATION
      *****************************************************************
     C     Sr_Init       BEGSR
 
      * Clear Outputs
     C                   CLEAR                   FCIPExFilFmt
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * Inputs
      *
      * Return code
     C                   PARM                    PRetCodeIn
      *
      * Action Code
     C                   PARM                    PActn
      *
      * Front Office Transaction ID
     C                   PARM                    PFORTID
      *
      * Customer Number
     C                   PARM                    PCustNo
      *
      * Facility Type
     C                   PARM                    PFacTyp
      *
      * Facility Sequence
     C                   PARM                    PFacSeq
      *
      * Branch
     C                   PARM                    PBranch
      *
      * Extension file Format
     C                   PARM                    FCIPExFilFmt
      *
      ** move parameter fields to key fields
     C                   MOVE      PCustNo       KCustNo
     C                   MOVE      PFacTyp       KFacTyp
     C                   MOVE      PFacSeq       KFacSeq
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'LEFCIPRTV1'
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
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
