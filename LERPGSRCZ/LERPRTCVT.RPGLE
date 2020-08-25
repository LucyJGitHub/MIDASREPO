     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Risk participant convert')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LERPRTCVT - Risk Participant Convert                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
      *                 CAP069   *CREATE   Date 15Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
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
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------

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

      ** Risk Participant Details in file format
     D LEPARTPDFmt   E DS                  EXTNAME(LEPARTPD)

      ** Risk Participant Details in screen format
     D RPRT          E DS                  EXTNAME(LERPRTPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

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
      *  Primary facility
      ** ~~~~~~~~~~~~~~~~
     C                   MOVEL     CNUM          S#PMFC
     C                   MOVEL     FACT          S#PMFT
     C                   MOVEL     FCNO          S#PMFN

      *  Syndicate member
      ** ~~~~~~~~~~~~~~~~

     C                   MOVEL     MNUM          S#CNUM

      *  Syndicate member details
      ** ~~~~~~~~~~~~~~~~~~~~~~~~
     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      MNUM          @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
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
      ** Joining Date
      ** ~~~~~~~~~~~~
     C                   MOVE      JDTE          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#JDTE
      *
      ** Introduced by
      ** ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        S#INUM
     C                   MOVEL     INUM          S#INUM
      *
      ** Introduced by details
      ** ~~~~~~~~~~~~~~~~~~~~~

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
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @CNUM         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     BBCRNM        S#IRNM
     C                   MOVEL     BBCRTN        S#IRTN
      *
      ** Share Amount/Percentage
      *  ~~~~~~~~~~~~~~~~~~~~~~~
     C     SHTP          IFEQ      'A'
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      SHAM          ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
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
      ** Fee base rate
      *
     C*****FEBR          IFEQ      *ZEROS                                                     CSD103
     C     FEBR          IFEQ      *BLANKS                                                    CSD103
     C                   MOVE      *BLANKS       S#FEBR
     C                   ELSE
     C                   MOVEL     FEBR          S#FEBR
     C                   ENDIF
      *
      ** Fee rate/spread
      *
     C     FERA          IFNE      *ZEROS
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      FERA          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#FERA
     C                   ELSE
     C                   MOVE      *BLANKS       S#FERA
     C                   ENDIF
      *
      ** Fee sign
      *
     C                   MOVE      FERS          S#FERS
      *
      ** Default risk part loan type/sub-type
      *
     C                   MOVE      DRTP          S#DRTP
     C                   MOVE      DRST          S#DRST
     C                   MOVE      DRCL          S#DRCL                                       CLE042

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
      * Risk participant details in file format
     C                   PARM                    LEPARTPDFmt

      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
      * Risk Participant Details in screen format
     C                   PARM                    RPRT

      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10

      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
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
