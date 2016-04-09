     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Details LUX Conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS2CT - SE Securities Details LUX Conversion             *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
 
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      *
      ** External DS for Extension File 1
      *
     D SecsLUX1FilFmtE DS                  EXTNAME(SESDX1PD)
 
      *
      ** External DS for Extension File 2
      *
     D SecsLUX2FilFmtE DS                  EXTNAME(SESDX2PD)
 
      *
      ** External DS for Extension File 3
      *
     D SecsLUX3FilFmtE DS                  EXTNAME(SESDX3PD)
     D                                     PREFIX(CR)
 
      *
      ** External DS for Extension Screen Format
      *
     D SecsLUXScnFmt E DS                  EXTNAME(SESERXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @RETURN         S             10
     D SECSNM          S             10
     D TMPVOTR         S                   LIKE(L6LXVOTR)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRSETFLD
 
     C                   SETON                                        LR
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * SRSETFLD - Populate SecsLUXScnFmt Data Structure
      *****************************************************************
     C     SRSETFLD      BEGSR
 
     C                   MOVE      VXPORE        L4LXPORE
     C                   MOVE      CRVVLUSU      L6LXLUSU
     C                   MOVE      CRVVSUBR      L6LXSUBR
     C                   MOVE      CRVVIM93      L6LXIM93
     C                   MOVE      CRVVCLAT      L6LXCLAT
     C                   MOVE      CRVVSECT      L6LXSECT
     C                   MOVE      CRVVROFC      L6LXROFC
     C                   MOVE      CRVVRATC      L6LXRATC
     C                   MOVE      CRVVVOTR      TMPVOTR
     C                   EVAL      L6LXVOTR = %Subst(%Trim(TMPVOTR):1:3) + '.' +
     C                                        %Subst(%Trim(TMPVOTR):4:2)
     C                   MOVE      CRVVSECD      L6LXSECD
     C                   MOVE      CRVVSNCD      L6LXSNCD
     C                   MOVE      CRVVEEEM      L6LXEEEM
     C                   MOVE      CRVVQUOT      L6LXQUOT
     C                   MOVE      VVISTP        LLLXISTP
 
     C                   ENDSR
 
      *****************************************************************
      * SRINIT - Initialise data Structure SecsLUXScnFmt
      *****************************************************************
     C     SRINIT        BEGSR
 
     C                   CLEAR                   SecsLUXScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    @RETURN
     C                   PARM                    SECSNM
     C                   PARM                    SecsLUX1FilFmt
     C                   PARM                    SecsLUX2FilFmt
     C                   PARM                    SecsLUX3FilFmt
     C                   PARM                    SecsLUXScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
