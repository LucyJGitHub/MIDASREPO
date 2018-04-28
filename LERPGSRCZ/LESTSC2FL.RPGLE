     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Move settlement screen fields to file fds')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LESTSC2FL -  Move settlement screen fields to file fields    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CLE031             Date 26Apr05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072             Date 02Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
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
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIB        E DS                  EXTNAME(SETLIAB)
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIZ        E DS                  EXTNAME(SETLIAZ)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   Z-ADD     PMRSTM        FLRSTM
     C                   MOVE      PMRONS        FLRONS
     C                   MOVE      PARIBN        FLRIBN
     C                   MOVE      PMRIBA        FLRIBA
     C     PAROBN        IFNE      *BLANK
     C                   MOVE      PAROBN        FLROBN
     C                   ENDIF
     C     PAROCN        IFNE      *BLANK
     C                   MOVE      PAROCN        FLROCN
     C                   ENDIF
     C                   MOVE      PMROBR        FLROBR
     C                   MOVEL     PMRSCY        FLRSCY
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      PMREXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
      *                                                                                       CLE031
     C                   MOVEL     ZAVAL         FLREXR                                       CLE031
     C                   MOVEL     PMREXI        FLREXI                                       CLE031
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   Z-ADD     PMPSTM        FLPSTM
     C                   MOVE      PMPONS        FLPONS
     C                   MOVE      PAPIBN        FLPIBN
     C                   MOVE      PMPIBA        FLPIBA
     C     PAPOBN        IFNE      *BLANK
     C                   MOVE      PAPOBN        FLPOBN
     C                   ENDIF
     C     PAPOCN        IFNE      *BLANK
     C                   MOVE      PAPOCN        FLPOCN
     C                   END
     C                   MOVE      PARCRN        FLRCRN
     C                   MOVE      PMRCRA        FLRCRA
     C                   MOVE      PARVNO        FLRVNO
     C                   MOVE      PAAWBN        FLAWBN
     C                   MOVE      PMAWBA        FLAWBA
     C                   MOVE      PABENN        FLBENN
     C                   MOVE      PMBENA        FLBENA
     C                   MOVE      PMDTP1        FLDTP1
     C                   MOVE      PMDTP2        FLDTP2
     C                   MOVE      PMDTP3        FLDTP3
     C                   MOVE      PMDTP4        FLDTP4
     C                   MOVE      PMDCHG        FLDCHG
     C                   MOVE      PMBTB1        FLBTB1
     C                   MOVE      PMBTB2        FLBTB2
     C                   MOVE      PMBTB3        FLBTB3
     C                   MOVE      PMBTB4        FLBTB4
     C                   MOVE      PMBTB5        FLBTB5
     C                   MOVE      PMBTB6        FLBTB6
     C                   MOVE      PMPOBR        FLPOBR
     C                   MOVE      PMCVMR        FLCVMR
     C                   MOVE      PMPSCY        FLPSCY
     C                   MOVE      PMIC72        FLIC72
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      PMPEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
      *                                                                                       CLE031
     C                   MOVEL     ZAVAL         FLPEXR                                       CLE031
     C                   MOVEL     PMPEXI        FLPEXI                                       CLE031
 
      * Return
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
 
      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
      *
      * OUTPUTS
      *
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
