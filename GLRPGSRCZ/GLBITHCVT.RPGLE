     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE file to screen format')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITHCVT - Batch Header Conversion:                         *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Batch Header *
      *             from file to screen format                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MDA00267           Date 25May16               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24567           Date 14Jul09               *
      *                 260029             Date 29Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15754           Date 30Jan08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7895            Date 18Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG3749            Date 18Aug04               *
      *                 BUG711             Date 19Mar04               *
      *                 CAP084  *CREATE    Date 12Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MDA00267 - Incorrect value is shown in the Total Amount in   *
      *             Batch Entry. Padded Zeros to the left of the      *
      *             amount being converted.                           *
      *             Applied MDA00267(AR655832) for MD038130           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24567 - Unable to delete batch header due to error        *
      *           validating of total amount                          *
      *  260029 - Applied core fix 251260.                            *
      *  251260 - Journal entry hash item no. do not match. Increase  *
      *           length of field DDHINC from 2A to 3A (Recompile).   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15754 - Applied fix 249471.                               *
      *  249471 - Calculated Hash Total and No. of Items added to     *
      *           Header input screen.                                *
      *  BUG7895 - Action code field added to GLBITHPD (Recompiled)   *
      *  CSC024 - Open Month End                                      *
      *  BUG3749 - Decimal input field is not read in                 *
      *  BUG711 - Recompiled due to change in GLBITHPD                *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************


      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------

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

     D BITHFilFmt    E DS                  EXTNAME(GLJENHPD)
      ** Batch Header Transaction Details in File Format

     D BITHDets      E DS                  EXTNAME(GLBITHPD)
      ** Batch Header Transaction Details in Screen Format


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      **************************************************************
      /EJECT
      **************************************************************

      ** Initialisation

     C                   EXSR      INIT

      ** Set screen fields

     C                   EXSR      SCREEN

      ** Return

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR

      * Branch Code
     C                   EVAL      DDBCDA = BRBCDA

      * Department Code
     C                   EVAL      DDDPCD = BRDPCD

      * Multiple Branch Batch Indicator
     C                   EVAL      DDMBRB = BRMBRB

      * Batch Description
     C                   EVAL      DDBDES = BRBDES

      * Batch Total Input
     C     BRHIIN        IFEQ      *ZERO
     C     BRHDIN        ANDEQ     *ZERO                                                     BUG3749
     C                   MOVEL     *BLANKS       DDFMAM
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C**********         MOVE      BRHIIN        ZFIELD                                      BUG3749
     C     BRHIIN        IFNE      *ZERO                                                     BUG3749
     C     BRHIIN        MULT      1000          WBRHIIN          18 0                       BUG3749
     C                   ENDIF                                                               BUG3749
     C                   ADD       BRHDIN        WBRHIIN                                     BUG3749
     C**********         MOVE      WBRHIIN       ZFIELD                             BUG3749 BUG24567
     C                   EVALR     ZFIELD = %CHAR(WBRHIIN)                                  BUG24567
     C                   MOVEL     *ZEROS        XFIELD           16                        MDA00267
     C                   EVALR     ZFIELD = XFIELD + %TRIM(ZFIELD)                          MDA00267
     C                   Z-ADD     3             ZADEC                                       BUG3749
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDFMAM
     C                   ENDIF

      * Number of Items
     C     BRHINI        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDNOIS
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BRHINI        ZFIELD
     C                   Z-ADD     0             ZADEC                                       BUG3749
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNOIS
     C                   ENDIF
      * Batch Status
     C                   EVAL      DDBHAI = BRBHAI

      * Batch Number
     C                   EVAL      DDBTNB = BRBTNB

      ** Month End Adjustment Batch                                                           CSC024
                                                                                              CSC024
     C                   EVAL      DDMEAB = BRMEAB                                            CSC024
                                                                                              CSC024
      *                                                                                       249471
      ** Calculated Hash Total                                                                249471
      *                                                                                       249471
     C     BRHICC        IFEQ      *ZERO                                                      249471
     C     BRHDCC        ANDEQ     *ZERO                                                      249471
     C                   MOVEL     *BLANKS       DDHICC                                       249471
     C                   ELSE                                                                 249471
     C                   MOVE      *BLANKS       ZFIELD                                       249471
     C     BRHICC        IFNE      *ZERO                                                      249471
     C     BRHICC        MULT      1000          WBRHICC          18 0                        249471
     C                   ENDIF                                                                249471
     C                   ADD       BRHDCC        WBRHICC                                      249471
     C                   MOVE      WBRHICC       ZFIELD                                       249471
     C                   Z-ADD     3             ZADEC                                        249471
     C                   EXSR      ZEDIT                                                      249471
     C                   MOVE      ZFIELD        DDHICC                                       249471
     C                   ENDIF                                                                249471
      *                                                                                       249471
      ** Calculated No. of Items                                                              249471
      *                                                                                       249471
     C     BRHINC        IFEQ      *ZERO                                                      249471
     C                   MOVEL     *BLANKS       DDHINC                                       249471
     C                   ELSE                                                                 249471
     C                   MOVE      *BLANKS       ZFIELD                                       249471
     C                   MOVE      BRHINC        ZFIELD                                       249471
     C                   Z-ADD     0             ZADEC                                        249471
     C                   EXSR      ZEDIT                                                      249471
     C                   MOVE      ZFIELD        DDHINC                                       249471
     C                   ENDIF                                                                249471
      *                                                                                       249471
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C**********         PARM      0             ZADEC             1 0                       BUG3749
     C                   PARM                    ZADEC             1 0                       BUG3749

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALISATION
      *****************************************************************
     C     INIT          BEGSR

      ** Blank outputs

     C                   MOVEL     *BLANK        BITHDets

      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Batch Header Details File Format
     C                   PARM                    BITHFilFmt
      *

      * Output Parameters

      * Batch Header Details Screen Format
     C                   PARM                    BITHDets


      ** Initialise program name

     C                   EVAL      DBPGM = 'GLBITHCVT'

      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
