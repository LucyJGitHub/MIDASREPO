     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Move settlement file fields to screen fds')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LESTFL2SC -  Move settlement file fields to screen fields    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072             Date 02Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     C                   Z-ADD     FLRSTM        PMRSTM
     C                   MOVE      FLRONS        PMRONS
     C                   MOVE      FLRIBN        PARIBN
     C                   MOVE      FLRIBA        PMRIBA
     C*****FLROBN        IFNE      0                                                          CSD027
     C                   MOVE      FLROBN        PAROBN
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       PAROBN                                       CSD027
     C**********         ENDIF                                                                CSD027
     C*****FLROCN        IFNE      0                                                          CSD027
     C                   MOVE      FLROCN        PAROCN
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       PAROCN                                       CSD027
     C**********         ENDIF                                                                CSD027
     C     FLRSTM        IFEQ      05
     C                   MOVE      FLROBR        PMROBR
     C                   ELSE
     C                   MOVE      *BLANKS       PMROBR
     C                   ENDIF
     C                   MOVE      FLRSCY        PMRSCY
      *                                                                                       CLE031
      ** Edit exchange rate to add decimal point                                              CLE031
      *                                                                                       CLE031
     C                   MOVEL     FLREXR        @@WK14           14                          CLE031
     C                   EXSR      CVTAMT                                                     CLE031
     C                   MOVEL     @@WK14        PMREXR                                       CLE031
     C                   MOVEL     FLREXI        PMREXI                                       CLE031
      *
      ** Payment instructions
      *
     C                   Z-ADD     FLPSTM        PMPSTM
     C                   MOVE      FLPONS        PMPONS
     C                   MOVE      FLPIBN        PAPIBN
     C                   MOVE      FLPIBA        PMPIBA
     C*****FLPOBN        IFNE      0                                                   CSD027 CSD027
     C                   MOVE      FLPOBN        PAPOBN
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       PAPOBN                                       CSD027
     C**********         ENDIF                                                                CSD027
     C*****FLPOCN        IFNE      0                                                   CSD027 CSD027
     C                   MOVE      FLPOCN        PAPOCN
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       PAPOCN                                       CSD027
     C**********         END                                                                  CSD027
     C                   MOVE      FLCVMR        PMCVMR
     C                   MOVE      FLRCRN        PARCRN
     C                   MOVE      FLRCRA        PMRCRA
     C                   MOVE      FLRVNO        PARVNO
     C                   MOVE      FLAWBN        PAAWBN
     C                   MOVE      FLAWBA        PMAWBA
     C                   MOVE      FLBENN        PABENN
     C                   MOVE      FLBENA        PMBENA
     C                   MOVE      FLDTP1        PMDTP1
     C                   MOVE      FLDTP2        PMDTP2
     C                   MOVE      FLDTP3        PMDTP3
     C                   MOVE      FLDTP4        PMDTP4
     C                   MOVE      FLDCHG        PMDCHG
     C                   MOVE      FLBTB1        PMBTB1
     C                   MOVE      FLBTB2        PMBTB2
     C                   MOVE      FLBTB3        PMBTB3
     C                   MOVE      FLBTB4        PMBTB4
     C                   MOVE      FLBTB5        PMBTB5
     C                   MOVE      FLBTB6        PMBTB6
     C     FLPSTM        IFEQ      05
     C                   MOVE      FLPOBR        PMPOBR
     C                   ELSE
     C                   MOVE      *BLANKS       PMPOBR
     C                   ENDIF
     C                   MOVE      FLPSCY        PMPSCY
     C                   MOVE      FLIC72        PMIC72
      *                                                                                       CLE031
      ** Edit exchange rate to add decimal point                                              CLE031
      *                                                                                       CLE031
     C                   MOVEL     FLPEXR        @@WK14                                       CLE031
     C                   EXSR      CVTAMT                                                     CLE031
     C                   MOVEL     @@WK14        PMPEXR                                       CLE031
     C                   MOVEL     FLPEXI        PMPEXI                                       CLE031
      *
      ** COUNTERPARTY PAY INSTRUCTIONS.
     C                   MOVE      *BLANKS       PMRIBN
     C                   MOVEL     PARIBN        PMRIBN
      *
      ** RCPT - RCPT - ORDERING BANK NO.
     C                   MOVE      *BLANKS       PMROBN
     C                   MOVEL     PAROBN        PMROBN
      *
      ** RCPT - ORDERING CUSTOMER NO.
     C                   MOVE      *BLANKS       PMROCN
     C                   MOVEL     PAROCN        PMROCN
      *
      ** PAY - INTERMEDIARY BANK NO.
     C                   MOVE      *BLANKS       PMPIBN
     C                   MOVEL     PAPIBN        PMPIBN
      *
      ** PAY - ORDERING BANK NO.
     C                   MOVE      *BLANKS       PMPOBN
     C                   MOVEL     PAPOBN        PMPOBN
      *
      ** PAY - ORDERING CUSTOMER NO.
     C                   MOVE      *BLANKS       PMPOCN
     C                   MOVEL     PAPOCN        PMPOCN
      *
      ** RECEIVER CORRESPONDENT NO.
     C                   MOVE      *BLANKS       PMRCRN
     C                   MOVEL     PARCRN        PMRCRN
      *
      ** RECEIVER NUMBER
     C                   MOVE      *BLANKS       PMRVNO
     C                   MOVEL     PARVNO        PMRVNO
      *
      ** COUNTERPARTY RECEIVE INSTRUCTIONS.
     C                   MOVE      *BLANKS       PMAWBN
     C                   MOVEL     PAAWBN        PMAWBN
      *
      ** FOR ACCOUNT OF INSTRUCTIONS.
      *
     C                   MOVE      *BLANKS       PMBENN
     C                   MOVEL     PABENN        PMBENN
 
      * Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT                                                                                  CLE031
     C*****************************************************************                       CLE031
     C*                                                               *                       CLE031
     C* CVTAMT - Convert a amount to have the decimal point added     *                       CLE031
     C*                                                               *                       CLE031
     C*****************************************************************                       CLE031
     C     CVTAMT        BEGSR                                                                CLE031
      *                                                                                       CLE031
     C     @@WK14        IFNE      *ZEROS                                                     CLE031
     C     @@WK14        ANDNE     *BLANKS                                                    CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZEDIT'                                                    CLE031
     C     @@WK14        PARM      @@WK14        ZFIELD           16                          CLE031
     C                   PARM      8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVEL     *BLANKS       @@WK14                                       CLE031
     C                   END                                                                  CLE031
      *                                                                                       CLE031
     C                   ENDSR                                                                CLE031
     C*****************************************************************                       CLE031
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
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
      *
      * OUTPUTS
      *
      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD             7                          CLE031
     C                   PARM      '*VERIFY'     @OPTN             7                          CLE031
     C                   PARM      'CLE031'      @SARD             6                          CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
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
(c) Finastra International Limited 2002
