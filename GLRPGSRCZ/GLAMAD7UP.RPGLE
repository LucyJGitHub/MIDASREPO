     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Extension Update - Italy')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD7UP- GL Account Ext Update - Italy                     *
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
     FREACT1L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

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

      **   Arrays and Data Structures
      **   ==========================
      **
     D ValidItalyExt E DS                  EXTNAME(GLVAMIT1PD)
      ** Valid extended Account Details

     D PRETURN         S              6
     D PTYPE           S              1
     D PRTCD           S              7
      ** Modules parameters

     D K@CNUM          S                   LIKE(PQCNUM)
     D K@CCYC          S                   LIKE(PQCCY)
     D K@ACOD          S                   LIKE(PQACOD)
     D K@ACSQ          S                   LIKE(PQACSQ)
     D K@BRCA          S                   LIKE(PQBRCA)
      ** Define key to access to extended details

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
      ** In insert mode

     C                   IF        ActionCode = 'I'
     C                   EXSR      SrInsert
     C                   ENDIF

      ** In action mode

     C                   IF        ActionCode = 'A'
     C                   EXSR      SrAmend
     C                   ENDIF

      ** In delete mode

     C                   IF        ActionCode = 'D'
     C                   ENDIF

      ** Return

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsert - Insert action code routine                        *
      *                                                               *
      *****************************************************************
     C     SrInsert      BEGSR
     C                   MOVE      ITCNUM        K@CNUM
     C                   MOVE      ITCCY         K@CCYC
     C                   MOVE      ITACOD        K@ACOD
     C                   MOVE      ITACSQ        K@ACSQ
     C                   MOVE      ITBRCA        K@BRCA

     C     K@KEY         CHAIN     REACT1D0                           80

      ** If the record exists

     C                   IF        *IN80 = *OFF
     C                   MOVEL     '*RECUPD'     PRTCD

      ** Write a new record

     C                   ELSE

     C                   EVAL      PQCNUM = ITCNUM
     C                   EVAL      PQCCY  = ITCCY
     C                   EVAL      PQACOD = ITACOD
     C                   EVAL      PQACSQ = ITACSQ
     C                   EVAL      PQBRCA = ITBRCA
     C                   EVAL      PQMBCD = ITMBCD
     C                   EVAL      PQUNDT = ITUNDT
     C                   EVAL      PQCATC = ITCATC
     C                   EVAL      PQTPAC = ITTPAC
     C                   EVAL      PQCLRL = ITCLRL
     C                   EVAL      PQACST = ITACST
     C                   EVAL      PQLNIT = ITLNIT                                     LUC139
     C                   EVAL      PQTEGL = ITTEGL                                     LUC139
     C                   EVAL      PQCMPC = ITCMPC                                     LUC139
     C                   WRITE     REACT1D0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmend - Amend database                                     *
      *                                                               *
      *****************************************************************
     C     SrAmend       BEGSR
     C                   MOVE      ITCNUM        K@CNUM
     C                   MOVE      ITCCY         K@CCYC
     C                   MOVE      ITACOD        K@ACOD
     C                   MOVE      ITACSQ        K@ACSQ
     C                   MOVE      ITBRCA        K@BRCA

     C     K@KEY         CHAIN     REACT1D0                           8081

      ** If record locked, display screen again with information message

     C                   SELECT
     C                   WHEN      *IN81 = *ON

      ** If interactive mode

     C                   IF        PTYPE = '1'
     C                   MOVEL     '*RECLCK'     PRTCD

      ** If batch mode

     C                   ELSE
     C                   MOVEL     '*RECUPD'     PRTCD
     C                   ENDIF

     C                   WHEN      *IN80 = *ON
     C**********         MOVEL     '*RECUPD'     PRTCD                                 LUC139
     C                   EVAL      PQCNUM = ITCNUM                                     LUC139
     C                   EVAL      PQCCY  = ITCCY                                      LUC139
     C                   EVAL      PQACOD = ITACOD                                     LUC139
     C                   EVAL      PQACSQ = ITACSQ                                     LUC139
     C                   EVAL      PQBRCA = ITBRCA                                     LUC139
     C                   EVAL      PQMBCD = ITMBCD                                     LUC139
     C                   EVAL      PQUNDT = ITUNDT                                     LUC139
     C                   EVAL      PQCATC = ITCATC                                     LUC139
     C                   EVAL      PQTPAC = ITTPAC                                     LUC139
     C                   EVAL      PQCLRL = ITCLRL                                     LUC139
     C                   EVAL      PQACST = ITACST                                     LUC139
     C                   EVAL      PQLNIT = ITLNIT                                     LUC139
     C                   EVAL      PQTEGL = ITTEGL                                     LUC139
     C                   EVAL      PQCMPC = ITCMPC                                     LUC139
     C                   WRITE     REACT1D0                                            LUC139

     C                   WHEN      *IN80 = *OFF
     C                   EVAL      PQMBCD = ITMBCD
     C                   EVAL      PQUNDT = ITUNDT
     C                   EVAL      PQCATC = ITCATC
     C                   EVAL      PQTPAC = ITTPAC
     C                   EVAL      PQCLRL = ITCLRL
     C                   EVAL      PQACST = ITACST
     C                   EVAL      PQLNIT = ITLNIT                                     LUC139
     C                   EVAL      PQTEGL = ITTEGL                                     LUC139
     C                   EVAL      PQCMPC = ITCMPC                                     LUC139
     C                   UPDATE    REACT1D0
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    ActionCode
     C                   PARM                    ValidItalyExt

      ** Key fields list

     C     K@KEY         KLIST
     C                   KFLD                    K@CNUM
     C                   KFLD                    K@CCYC
     C                   KFLD                    K@ACOD
     C                   KFLD                    K@ACSQ
     C                   KFLD                    K@BRCA

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)

     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PRETURN
     C                   PARM                    PTYPE

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
