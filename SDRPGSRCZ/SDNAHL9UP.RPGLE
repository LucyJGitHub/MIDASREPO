     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder CER076 Economic Id Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHL9UP - SD NAHL CER076 Economic Id Update                *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CAP240  *Create    Date 02Jul21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP240 - SD Non-Account Holder JAVA conversion               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Non-Account Holder Economic ID - Update
     FSDNAHOY0  UF A E           K DISK    COMMIT

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.

      /COPY ZACPYSRC,ERR_XARRYS

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

      ** Valid Non-A/C Holder layout
     D ValidNaho     E DS                  Extname(SDVNAHLPD)
     D                                     Prefix(V_)

      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D P@Rtcd          S              7A
     D ValidEINO       S             30A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     V_NaNaho      Chain     SDNAHOY0                           80

     C                   If        DDACTN = 'D'
     C                             and *In80 = *Off
     C                   Delete    SDNAHOF0
     C                   Endif

     C                   If        DDActn = 'A'
     C                             Or DDActn = 'I'

     C                   eval      NhEino = ValidEino

     C     *In80         Ifeq      *Off
     C                   Update    SDNAHOF0
     C                   else
     C                   eval      NhNaho = V_NaNaho
     C                   Write     SDNAHOF0
     C                   Endif

     C                   Endif

     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initial Processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PLIST

      * Input Parameters :

      ** Return Code
      ** Action Code
      ** New Details in File Format
     C                   PARM                    P@Rtcd
     C                   PARM                    ValidNaho
     C                   PARM                    DDActn            1
     C                   PARM                    ValidEino

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      *****************************************************************

     C     SRErr         BEGSR

     C                   EVAL      P@Rtcd = '*ERROR '
     C                   EVAL      DBPGM = 'SDNAHL9UP'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      **  Terminate the Program

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2021
