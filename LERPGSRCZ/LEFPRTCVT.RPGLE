     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding Participant Convert')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFPRTCVT - Funding Participant Convert                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068   *CREATE   Date 21Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
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

      ** Funding Participant Details in file format record 'A'
     D FCLTYFMFmt    E DS                  EXTNAME(FCLTYFM)

      ** Funding Participant Details in screen format
     D FPRT          E DS                  EXTNAME(LEFPRTPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

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

      ** Set output screen fields

     C                   EXSR      SETFLD

     C                   RETURN

      /SPACE 5
      *****************************************************************
      ** Set output screen fields
      *****************************************************************
     C     SETFLD        BEGSR

      *
      * Primary facility
      ** ~~~~~~~~~~~~~~~~
     C                   MOVEL     PMFC          S#PMFC
     C                   MOVEL     PMFT          S#PMFT
     C                   MOVEL     PMFN          S#PMFN

      * Syndicate member
      ** ~~~~~~~~~~~~~~~~

     C                   MOVEL     CNUM          S#CNUM

      * Syndicate member details
      ** ~~~~~~~~~~~~~~~~~~~~~~
     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      CNUM          @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @CNUM         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   MOVEL     BBCSSN        S#CSNM
     C                   MOVEL     BBCRNM        S#SRNM
     C                   MOVEL     BBCRTN        S#SRTN
      *
      ** Facility
      ** ~~~~~~~~
     C                   MOVE      FACT          S#FACT
     C                   MOVE      FCNO          S#FCNO

      ** Facility currency details

     C                   CALL      'AOCURRR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FCCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @CCY          DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Joining Date
      ** ~~~~~~~~~~~~
     C                   MOVE      JDTE          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#JDTE
      *
      **  Introduced by
      ** ~~~~~~~~~~~~~~~~~~~~~~
     C                   MOVE      *BLANK        S#INUM
     C                   MOVEL     INUM          S#INUM
      *
      **  Introduced by details
      ** ~~~~~~~~~~~~~~~~~~~~~~

     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      INUM          @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     @CNUM         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     BBCRNM        S#IRNM
     C                   MOVEL     BBCRTN        S#IRTN
      *
      ** Value Date
      ** ~~~~~~~~~~
     C                   MOVE      VDTC          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#VDTC
      *
      ** Share Amount/Percentage
      *  ~~~~~~~~~~~~~~~~~~~~~~~
     C     SHTP          IFEQ      'A'
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      FAMT          ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#SHAR
      * SHTP = 'P'
     C                   ELSE
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      SHPC          ZFIELD
     C                   Z-ADD     12            ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#SHAR
     C                   ENDIF
      *
      ** Share Type
      *  ~~~~~~~~~~
     C                   MOVE      SHTP          S#SHTP
      *
      **  Recourse Indicator
     C                   MOVE      RCSI          S#RCSI
      *
      **  Assignment/Participation indicator
     C                   MOVE      PASI          S#PASI
      *
      **  Interest Skim
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      SKIR          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#SKIR
     C                   MOVE      SKIS          S#SKIS
      *
      **  Fees Skim
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      SKFR          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#SKFR
     C                   MOVE      SKFS          S#SKFS
      *
      **  Alternate Name & Address Code
     C                   MOVE      NACD          S#NACD

     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZEDIT2        BEGSR
     C                   CALLB     'ZEDIT2'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
     C                   ENDSR
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Funding participant facility details in file format record 'A'
     C                   PARM                    FCLTYFMFmt
      *
      * OUTPUTS
      *
      * Funding Participant Facility Details in screen format
     C                   PARM                    FPRT

      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10

      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10

      *
      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
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
