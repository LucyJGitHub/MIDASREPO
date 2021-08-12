     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan details convert - Italian')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIP6CT - LE Loan Details Convert - Italian                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 BUG14705           Date 24Aug07               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  BUG14705 - Italian field dest econ inv was set to blanks     *
      *             when equal to zero                                *
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

     D CrFilFmtItl   E DS                  EXTNAME(LECLT1PD)
      ** LE Customer Loans Details in File Format

     D CrFilFmtCl    E DS                  EXTNAME(CLOANCL)
      ** LE Customer Loans in File Format

     D RegData       E DS                  EXTNAME(LECLRXPD)
      ** LE Customer Loans Extra Data in Screen Format

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Programs, Long Data Structure

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** DS for Currency Codes

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PZfld16A        S             16A
     D PZDec1P0        S              1P 0
      ** Parameters for ZEDIT

     D PZDayNo         S              5P 0
     D PZDate6P0       S              6P 0
     D PZADate         S              7A
      ** Parameters for ZDATE2

     D PRTCD           S              7A
     D POPTN           S              7A
     D PCHR003         S              3A
      ** Parameters for AOCURRR0

     D BJDFIN          S              1A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialisation

     C                   EXSR      SrInit

      ** Set screen fields

     C                   EXSR      SrScreen

      ** Return

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      **  Program Parameters

     C     *ENTRY        PLIST

     C                   PARM                    ReturnCode
     C                   PARM                    CrFilFmtItl
     C                   PARM                    CrFilFmtCL
     C                   PARM                    BJDFIN
     C                   PARM                    RegData

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR

     C                   CLEAR                   DDTMOOP
     C                   CLEAR                   DDTAGCT
     C                   CLEAR                   DDTAGCL
     C                   CLEAR                   DDTECBD
     C                   CLEAR                   DDTSBCR
     C                   CLEAR                   DDTINSB
     C                   CLEAR                   DDTTPPR
     C                   CLEAR                   DDTPEPR
     C                   CLEAR                   DDTGLPA
     C                   CLEAR                   DDTTPFD
     C                   CLEAR                   DDTSBLW
     C                   CLEAR                   DDTDPIV
     C                   CLEAR                   DDTEDIV
     C                   CLEAR                   DDTCATC
     C                   CLEAR                   DDTTPAC
     C                   CLEAR                   DDTCLRL
     C                   CLEAR                   DDTACST
     C                   CLEAR                   DDTLNIT
     C                   CLEAR                   DDTTEGL
     C                   CLEAR                   DDTUNDT
     C                   CLEAR                   DDTPSAM
     C                   CLEAR                   DDTLEAD
     C                   CLEAR                   DDTPTRP                                  LUC139
     C                   CLEAR                   DDTCMPC                                  LUC139

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CCY           PCHR003
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScreen - Set Screen Fields                                 *
      *                                                               *
      *****************************************************************
     C     SrScreen      BEGSR

     C                   MOVE      PFMOOP        DDTMOOP

     C                   IF        PFAGCT = *ZERO
     C                   MOVE      *BLANKS       DDTAGCT
     C                   ELSE
     C                   MOVE      PFAGCT        DDTAGCT
     C                   ENDIF

     C                   IF        PFAGCL = *ZERO
     C                   MOVE      *BLANKS       DDTAGCL
     C                   ELSE
     C                   MOVE      PFAGCL        DDTAGCL
     C                   ENDIF

     C                   IF        PFECBD = *ZERO
     C                   MOVE      *BLANKS       DDTECBD
     C                   ELSE
     C                   MOVE      PFECBD        DDTECBD
     C                   ENDIF

     C                   MOVE      PFSBCR        DDTSBCR
     C                   MOVE      PFINSB        DDTINSB

     C                   IF        PFTPPR = *ZERO
     C                   MOVE      *BLANKS       DDTTPPR
     C                   ELSE
     C                   MOVE      PFTPPR        DDTTPPR
     C                   ENDIF

     C                   IF        PFPEPR = *ZERO
     C                   MOVE      *BLANKS       DDTPEPR
     C                   ELSE
     C                   MOVE      PFPEPR        DDTPEPR
     C                   ENDIF

     C                   MOVE      PFGLPA        DDTGLPA
     C                   MOVE      PFTPFD        DDTTPFD
     C                   MOVE      PFSBLW        DDTSBLW

     C                   IF        PFDPIV = *ZERO
     C                   MOVE      *BLANKS       DDTDPIV
     C                   ELSE
     C                   MOVE      PFDPIV        DDTDPIV
     C                   ENDIF

     C**********         IF        PFEDIV = *ZERO                                           BUG14705
     C**********         MOVE      *BLANKS       DDTEDIV                                    BUG14705
     C**********         ELSE                                                               BUG14705
     C                   MOVE      PFEDIV        DDTEDIV
     C**********         ENDIF                                                              BUG14705

     C                   IF        PFCATC = *ZERO
     C                   MOVE      *BLANKS       DDTCATC
     C                   ELSE
     C                   MOVE      PFCATC        DDTCATC
     C                   ENDIF

     C                   MOVE      PFTPAC        DDTTPAC
     C                   MOVE      PFCLRL        DDTCLRL
     C                   MOVE      PFACST        DDTACST
     C                   MOVE      PFLNIT        DDTLNIT

     C                   IF        PFTEGL = *ZERO
     C                   MOVE      *BLANKS       DDTTEGL
     C                   ELSE
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVE      PFTEGL        PZFld16A
     C                   EVAL      PZDec1P0 = 3
     C                   EXSR      SRZEDIT
     C                   MOVE      PZFld16A      DDTTEGL
     C                   ENDIF

     C                   IF        PFUNDT = *ZERO
     C                   MOVE      *BLANKS       DDTUNDT
     C                   ELSE
     C                   MOVE      PFUNDT        PZDayNo
     C                   EVAL      PZDate6P0 = *ZERO
     C                   EVAL      PZADate   = *BLANKS
     C                   EXSR      SrZDATE2
     C                   MOVE      PZDate6P0     DDTUNDT
     C                   ENDIF

     C                   IF        PFPSAM = *ZERO
     C                   MOVE      *BLANKS       DDTPSAM
     C                   ELSE
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVE      PFPSAM        PZFld16A
     C                   EVAL      PZDec1P0 = A6NBDP
     C                   EXSR      SRZEDIT
     C                   MOVE      PZFld16A      DDTPSAM
     C                   ENDIF

     C                   MOVE      PFLEAD        DDTLEAD

     C                   MOVE      PFPTRP        DDTPTRP                                 LUC139
                                                                                         LUC139
     C                   IF        PFCMPC = *ZERO                                        LUC139
     C                   MOVE      *BLANKS       DDTCMPC                                 LUC139
     C                   ELSE                                                            LUC139
     C                   MOVE      *BLANKS       PZFld16A                                LUC139
     C                   MOVE      PFCMPC        PZFld16A                                LUC139
     C                   EVAL      PZDec1P0 = 3                                          LUC139
     C                   EXSR      SRZEDIT                                               LUC139
     C                   MOVE      PZFld16A      DDTCMPC                                 LUC139
     C                   ENDIF                                                           LUC139
                                                                                         LUC139
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDATE2 - Format a date for output                          *
      *                                                               *
      *****************************************************************
     C     SrZDATE2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate6P0
     C                   PARM                    PZADate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZEDIT - Edit an unsigned field                             *
      *                                                               *
      *****************************************************************
     C     SrZEDIT       BEGSR

     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDec1P0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
