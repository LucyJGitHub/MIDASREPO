     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payment Retrieve - Extension')
      *****************************************************************
      *                                                               *
      *  Midas - Fund Transfer Module                                 *
      *                                                               *
      *  FTOPAY2RV - FT Outgoing Payments Retrieve - Extension        *
      *                                                               *
      *  Function:  This module retrieve the details of extension file*
      *             FTOPX1L0.                                         *
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
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFTOPX1L0  IF   E           K DISK    INFSR(*PSSR)
 
      * Midas IBLC 2002 Outgoing Payments Extended Index
 
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
 
     D OPAYExFilFmt  E DS                  EXTNAME(FTOPX1PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
 
     D PRetCodeIn      S             10
     D PActn           S              1
     D PFrontID        S             20
     D PPayRef         S             15
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
     C
     C     PPayRef       CHAIN     FTOPX1L0
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   CLEAR                   OPAYExFilFmt
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return code
      *
     C                   PARM                    PRetCodeIn
      *
      ** Action Code
      *
     C                   PARM                    PActn
      *
      ** Front Office Transaction ID
      *
     C                   PARM                    PFrontID
      *
      ** Payment Reference
      *
     C                   PARM                    PPayRef
      *
      ** Outputs
      *
      ** Account Details File Format
      *
     C                   PARM                    OPAYExFilFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'FTOPAY2RV'
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
