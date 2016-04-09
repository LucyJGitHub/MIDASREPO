     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased BoE Retrieve')                *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPRTV1 - MM's NA's Purchased BOE RETRIEVE                *
      *                                                               *
      *  Function:  This module retrieves the details from the        *
      *             extension file BYNASPX0.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FBYNASPY0  IF   E           K DISK    INFSR(*PSSR)
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
 
     D NaspExFilFmt  E DS                  EXTNAME(BYNASPX0)
      ** Transaction Details in File Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCodeIn      S             10
     D PActn           S              1
     D PFotrid         S             20
     D PDealN          S              6
     D WDealKey        S              6  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   EXSR      SRINIT
      *
     C                   CLEAR                   WDealKey
     C                   MOVEL     PDealN        WDealKey
     C     WDealKey      CHAIN     BYNASPY0
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Clear Outputs
     C                   CLEAR                   NaspExFilFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
     C     *ENTRY        PLIST
 
      ** Inputs
 
      ** Return code
     C                   PARM                    PRetCodeIn
 
      ** Action Code
     C                   PARM                    PActn
 
      ** Front Office Transaction ID
     C                   PARM                    PFotrid
 
      ** Deal Number
     C                   PARM                    PDealN
 
      ** Outputs
 
      ** Transaction Details in File Format
     C                   PARM                    NaspExFilFmt
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
