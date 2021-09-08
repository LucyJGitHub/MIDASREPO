     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Retrieve Acct Extension Convert - Italy')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD7RV- GL Retrieve Accnt. Ext - Italy                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 21Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UIC Italian features upgrade to FM2.1               *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FREACT1L0  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

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

     D ItalyFileFmt  E DS                  EXTNAME(REACT1PD)
      ** REACT1PD Transaction Details in File Format

     D RegData       E DS                  EXTNAME(GLAMRXPD)

     D DataItaly       DS          1024
     D  I1CNUM                 1      6
     D  I1CCY                  7      9
     D  I1ACOD                10     19
     D  I1ACSQ                20     21
     D  I1BRCA                22     24
     D  I1ATYP                25     25

     D I1ACOD#         S             10S 0
     D I1ACSQ#         S              2S 0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************

      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation

     C                   CLEAR                   ItalyFileFmt

     C     K@KEY         CHAIN     REACT1L0

      ** Return

     C                   EVAL      *INLR=*ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    DataItaly
     C                   PARM                    ItalyFileFmt

      ** Key fields list

     C     K@KEY         KLIST
     C                   KFLD                    I1CNUM
     C                   KFLD                    I1CCY
     C                   KFLD                    I1ACOD#
     C                   KFLD                    I1ACSQ#
     C                   KFLD                    I1BRCA

      ** Move account code/sequence to numeric fields

     C                   MOVE      I1ACOD        I1ACOD#
     C                   MOVE      I1ACSQ        I1ACSQ#

     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program, and performs     *
      *           a ROLLBACK.                                         *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

     C/COPY ZACPYSRC,PSSR_ILE

      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
