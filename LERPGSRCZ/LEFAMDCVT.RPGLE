     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment convert')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFAMDCVT - Facility Amendment Convert                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 07Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 20Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071             Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00223                                 *
      *             WNCPYSRC,LEH00224                                 *
      *             WNCPYSRC,LEH00225                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager. Added ProRata Indicator.      *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Change S#CNUM to be 10 long instead of 6 long       *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as API's                                        *
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
 
      ** Facility Amendment Details in file format
     D LEFCAMPDFmt   E DS                  EXTNAME(LEFCAMPD)
 
      ** Facility Amendment Details in screen format
     D FAMD          E DS                  EXTNAME(LEFAMDPD)
 
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
     D CLE106          S              1A                                                      CLE106
 
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
 
      ** Customer
 
     C                   MOVEL     CNUM          S#CNUM
 
      ** Customer details
 
     C                   MOVE      *BLANK        @CNUM
     C                   MOVE      CNUM          @CNUM
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
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
     C                   MOVEL     BBCRNM        S#CRNM
     C                   MOVEL     BBCRTN        S#CRTN
 
      ** Facility Type and Facility Number
 
     C                   MOVE      FACT          S#FACT
     C                   MOVE      FCNO          S#FCNO
 
      ** Sequence Number
 
     C                   MOVE      SQNO          S#SQNO
 
      ** Value Date
 
     C                   Z-ADD     VLDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         S#VLDT
     C                   MOVEL     ZADATE        S#VLDA
 
      ** Amendment Type
 
     C                   MOVE      FATP          S#FATP
      *
     C                   SELECT
 
     C     FATP          WHENEQ    'FI'
     C                   MOVEL     'LEF0281'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#FATN
 
     C     FATP          WHENEQ    'FD'
     C                   MOVEL     'LEF0282'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#FATN
 
     C     FATP          WHENEQ    'FR'
     C                   MOVEL     'LEF0283'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#FATN
 
     C     FATP          WHENEQ    'RC'
     C                   MOVEL     'LEF0284'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#FATN
     C/COPY WNCPYSRC,LEH00223
 
     C                   ENDSL
 
      ** Amendment Currency
 
     C                   MOVEL     ACCY          S#ACCY
 
      ** Amendment Amount and Sign
 
     C                   Z-ADD     AAMT          W#AAMT           13 0          *
     C     FATP          IFEQ      'FR'
     C     AAMT          IFLT      *ZERO
     C                   MOVE      '-'           S#SIGN
     C                   Z-SUB     AAMT          W#AAMT
     C                   ELSE
     C                   MOVE      '+'           S#SIGN
     C                   END
     C                   ELSE
     C                   MOVE      *BLANK        S#SIGN
     C                   END
 
     C     W#AAMT        IFNE      *ZERO
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      W#AAMT        ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        S#AAMT
     C                   ELSE
     C                   MOVE      *BLANK        S#AAMT
     C                   ENDIF
 
      ** Revolving Credit Indicator
 
     C                   MOVEL     RVCR          S#RVCR
 
      ** New Expiry Date
 
     C     NDEX          IFNE      *ZERO
     C                   Z-ADD     NDEX          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         S#NDEX
     C                   ELSE
     C                   MOVE      *BLANK        S#NDEX
     C                   ENDIF
 
      ** Record Status
 
     C                   SELECT
 
     C     ASTS          WHENEQ    'R'
     C                   MOVEL     'LEF0285'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
 
     C     ASTS          WHENEQ    'C'
     C                   MOVEL     'LEF0286'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
 
     C     ASTS          WHENEQ    'A'
     C                   MOVEL     'LEF0287'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
 
     C                   ENDSL
     C     CLE106        IFEQ      'Y'                                                        CLE106
      *                                                                                       CLE106
      ** Pro Rata Indicator                                                                   CLE106
      *                                                                                       CLE106
     C                   EVAL      S#NPRT = NPRT                                              CLE106
     C                   ENDIF                                                                CLE106
 
     C/COPY WNCPYSRC,LEH00224
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
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRTEXT  -  Set up text from message file                      *
      *****************************************************************
     C     SRTEXT        BEGSR
 
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM      'LERMSGF '    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
 
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
      * Facility Amendment details in file format
     C                   PARM                    LEFCAMPDFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
      * Facility Amendment Details in screen format
     C                   PARM                    FAMD
 
      * Customer details
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
 
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
      *                                                                                       CLE106
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C     @RTCD         IFEQ      '*NRF'                                                     CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
      ** Database error                                                                       CLE106
      *                                                                                       CLE106
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE106
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE106
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C/COPY WNCPYSRC,LEH00225
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
