     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Extension Convert - Italy')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD7CT- GL Accnt. Ext Convert - Italy: File to Scrn Format*
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

     D ItalyFileFmt  E DS                  EXTNAME(REACT1PD)
      ** REACT1PD Transaction Details in File Format

     D RegData       E DS                  EXTNAME(GLAMRXPD)

     D SDBank        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure

     D PRTCD           S              7
     D POPTN           S              7
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D PzADec          S              1P 0                                         LUC139
     D PzField         S             16A                                           LUC139
      ** Parameters definition

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************

      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      ** Date Conversion

     C                   EXSR      SrUNDT
     C                   EXSR      SrTEGL                                    LUC139
     C                   EXSR      SrCMPC                                    LUC139
      *
      ** Set screen fields
      *
     C                   EXSR      SrSetup

      ** Return

     C                   EVAL      *INLR=*ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    ItalyFileFmt
     C                   PARM                    RegData

      ** Initialise program name

     C                   EVAL      DBPGM = 'GLAMAD7CT'

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUNDT - Convert Midas Date                                  *
      *                                                               *
      *****************************************************************
     C     SrUNDT        BEGSR

     C                   EVAL      ZDAYNO = PQUNDT
     C                   EVAL      ZDATE  = 0
     C                   EVAL      ZADATE = *Blanks

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   MOVEL     ZDATE         DDTUNDT

     C                   ENDSR
      *****************************************************************                LUC139
      /EJECT                                                                           LUC139
      *****************************************************************                LUC139
      *                                                               *                LUC139
      *  SrTEGL - Convert Global Effective Rate                       *                LUC139
      *                                                               *                LUC139
      *****************************************************************                LUC139
     C     SrTEGL        BEGSR                                                         LUC139
                                                                                       LUC139
     C                   Move      *Blanks       PzField                               LUC139
     C                   Move      PQTEGL        PzField                               LUC139
     C                   Z-Add     3             PzADec                                LUC139
                                                                                       LUC139
     C                   Callb     'ZEDIT'                                             LUC139
     C                   Parm                    PzField                               LUC139
     C                   Parm                    PzADec                                LUC139
                                                                                       LUC139
     C                   Move      PzField       DDTTEGL                               LUC139
                                                                                       LUC139
     C                   ENDSR                                                         LUC139
      *****************************************************************                LUC139
      /EJECT                                                                           LUC139
      *****************************************************************                LUC139
      *                                                               *                LUC139
      *  SrCMPC - Convert Commission Rate Max UBal                    *                LUC139
      *                                                               *                LUC139
      *****************************************************************                LUC139
     C     SrCMPC        BEGSR                                                         LUC139
                                                                                       LUC139
     C                   Move      *Blanks       PzField                               LUC139
     C                   Move      PQCMPC        PzField                               LUC139
     C                   Z-Add     3             PzADec                                LUC139
                                                                                       LUC139
     C                   Callb     'ZEDIT'                                             LUC139
     C                   Parm                    PzField                               LUC139
     C                   Parm                    PzADec                                LUC139
                                                                                       LUC139
     C                   Move      PzField       DDTCMPC                               LUC139
                                                                                       LUC139
     C                   ENDSR                                                         LUC139
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetup - Setup screen                                       *
      *                                                               *
      *****************************************************************
     C     SrSetup       BEGSR

     C                   MOVE      PQMBCD        DDTMBCD
     C                   MOVE      PQCATC        DDTCATC
     C                   MOVE      PQTPAC        DDTTPAC
     C                   MOVE      PQCLRL        DDTCLRL
     C                   MOVE      PQACST        DDTACST
     C                   MOVE      PQLNIT        DDTLNIT                             LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
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
