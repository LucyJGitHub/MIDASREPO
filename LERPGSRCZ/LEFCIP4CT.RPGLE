     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facilities Convert - Italian')                *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEFCIP4CT - PUMA II Transaction Details Conversion:          *
      *              File to Screen                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
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
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
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

     D CrFilDtaItl   E DS                  Extname(LEFCT1PD)
      ** Transaction Details in File Format

     D NwScnDtaItl   E DS                  Extname(LEFCRXPD)
      ** Transaction Details in Screen Format

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D A6NBDP          S              1S 0
     D BNDCSP          S              1A
     D PzADec          S              1P 0
     D PzAmount        S             13P 0
     D PzField         S             16A
     D PzField14       S             14A

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
      *  *Inzsr - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

      ** Program Parameters

     C     *Entry        Plist

     C                   Parm                    RetCodeIn
     C                   Parm                    A6NBDP
     C                   Parm                    BNDCSP
     C                   Parm                    CrFilDtaItl
     C                   Parm                    NwScnDtaItl

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr

      ** Initialise program name

     C                   Eval      DBPGM = 'LEFCIP4CT'
     C                   Clear                   NwScnDtaItl

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScreen - Set Screen Fields                                 *
      *                                                               *
      *****************************************************************
     C     SrScreen      Begsr

     C                   Move      PRSBCL        LITSBCL
     C                   Move      PROPPL        LITOPPL
     C                   Move      PREXPO        PzField

     C                   Callb     'ZEDIT'
     C                   Parm                    PzField
     C                   Parm      A6NBDP        PzADec

     C                   Move      PzField       LITEXPO
     C                   Move      PRDECD        LITDECD
     C                   Move      PRSACO        LITSACO
     C                   Move      PRSAPE        PzAmount

     C                   Callb     'ZA0920'
     C                   Parm      *BLANK        RetCodeOut
     C                   Parm                    PzAmount
     C                   Parm      3             PzADec
     C                   Parm                    BNDCSP
     C                   Parm      *BLANK        PzField14

     C                   Move      PzField14     LITSAPE

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
