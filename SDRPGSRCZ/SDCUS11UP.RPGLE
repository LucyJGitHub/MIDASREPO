     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Extended Details Update')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUS11UP - Midas SD CUSD - Update - Italian Details         *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER008  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER008 - Base Italian Features Upgrade to MidasPlus          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCUT1L1  UF A E           K Disk    Infsr(*PSSR)
     F                                     Commit
      ** Italian Details Extension File

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

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
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

     D ValidCUSDItl  E DS                  EXTNAME(SDCUT1PD)
     D                                     PREFIX(V)                                       LUC139
      ** Successfully validated screen data

     D SavRcd        E DS                  EXTNAME(SDCUT1PD)
     D                                     PREFIX(SV)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     DPactn            S              1A
     DPrtcd            S              7A
     DPfind            S              1A
     DPReturn          S              6A
     DPtype            S              1A
      ** Work fields

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C     VBBCUST       Chain     SDCUT1L1                           8081

      ** If JobType is Interactive

     C                   If        Ptype = '1'

     C                   If        *IN81 = *ON
     C                   Eval      Prtcd = '*RECLCK'
     C                   Eval      *INLR = *ON
     C                   Return
     C                   Endif

     C**********         If        (Pfind <> 'Y' Or Pactn = 'I')                        LUC139
     C**********                   And *IN80 = *Off                                     LUC139
     C**********         Eval      Prtcd = '*RECUPD'                                    LUC139
     C**********         Return                                                         LUC139
     C**********         Endif                                                          LUC139

     C**********         If        (Pfind = 'Y' And                                     LUC139
     C**********                    Pactn <> 'I') And                                   LUC139
     C**********                   *IN80 = *ON                                          LUC139
     C**********         Movel     '*RECUPD'     PRtCd                                  LUC139
     C**********         Return                                                         LUC139
     C**********         Endif                                                          LUC139

     C                   Endif

     C                   If        Pactn <> 'D'

     C                   Eval      BBCUST = VBBCUST
     C                   Eval      BBA004 = VBBA004

     C                   If        *IN80 = *OFF
     C                   Update    SDCUT1D0
     C                   Else
     C                   Write     SDCUT1D0
     C                   Endif

     C                   Endif

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

     C     *Entry        Plist

     C                   Parm                    Pactn
     C                   Parm                    Prtcd
     C                   Parm                    Pfind
     C                   Parm                    ValidCUSDItl
     C                   Parm                    SavRcd

      ** Retrieve Job Attributes

     C                   Callb     'ZARTVJOBA'
     C                   Parm                    PReturn
     C                   Parm                    Ptype

      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
