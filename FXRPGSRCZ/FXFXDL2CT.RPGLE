     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals Transaction Extension - Convert')       *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXFXDL2CT - FX Deals Transaction Extension - Convert         *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 15Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D FXDLExFilFmt  E DS                  EXTNAME(DLFXT1PD)
      ** FX Transaction Extension File - File Format

     D RegData       E DS                  EXTNAME(FXFXRXPD)
      ** Regional Data in File Format

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PRetCodeIn      S             10A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialisation

     C                   Exsr      SrInit

      ** Set screen fields

     C                   Exsr      SrScreen

      ** Return

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialise fields                                   *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr

     C                   Eval      DDTMOOP = *BLANKS
     C                   Eval      DDTTPPR = *BLANKS
     C                   Eval      DDTPEPR = *BLANKS
     C                   Eval      DDTGLPA = *BLANKS
     C                   Eval      DDTTPFD = *BLANKS

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScreen - Set Screen Fields                                 *
      *                                                               *
      *****************************************************************
     C     SrScreen      Begsr

     C                   Movel     PJMOOP        DDTMOOP

     C                   If        PJTPPR = *zero
     C                   Eval      DDTTPPR = *blank
     C                   Else
     C                   Movel     PJTPPR        DDTTPPR
     C                   EndIf

     C                   If        PJPEPR = *zero
     C                   Eval      DDTPEPR = *blank
     C                   Else
     C                   Movel     PJPEPR        DDTPEPR
     C                   EndIf

     C                   Movel     PJGLPA        DDTGLPA
     C                   Movel     PJTPFD        DDTTPFD

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

      ** Program Parameters

     C     *Entry        Plist

     C                   Parm                    PRetCodeIn
     C                   Parm                    FXDLExFilFmt
     C                   Parm                    RegData

      ** Initialise program name

     C                   Eval      DBPGM = 'FXFXDL2CT'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using Exsr.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK                                           *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Systems Ltd. 2020
