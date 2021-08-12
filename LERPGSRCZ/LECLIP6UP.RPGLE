     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan details update - Italian')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIP6UP - MM Loans and Deposits Update - Italian           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

     FLECLT1L1  UF A E           K DISK    COMMIT
      ** Midas LE Customer Loans Extension File - Italy

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
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
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

     D ValidCLIPItl  E DS                  EXTNAME(LEVCLIT1PD)
      ** Externally Defined DS for Update

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************

     C     VPFLNRF       CHAIN     LECLT1L1                           50

      ** Insert or Amend the transaction

     C                   SELECT
     C                   WHEN      ActionCode = 'I'
     C                   EXSR      SrIns
     C                   WHEN      ActionCode = 'A'
     C                   EXSR      SrAmd
     C                   ENDSL

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Program Parameters

     C     *ENTRY        PLIST

      ** Return Code

     C                   PARM                    @RTCD

      ** Action Code

     C                   PARM                    ActionCode

      ** Externally described DS for valid Transaction Detail

     C                   PARM                    ValidCLIPItl

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINS - Insert a transaction                                 *
      *                                                               *
      *****************************************************************
     C     SRINS         BEGSR

      ** If record not found, Insert the transaction

     C                   IF        *IN50 = *ON

      ** Set Transaction fields on insert

     C                   EVAL      PFLNRF = VPFLNRF
     C                   EVAL      PFMOOP = VPFMOOP
     C                   EVAL      PFAGCT = VPFAGCT
     C                   EVAL      PFAGCL = VPFAGCL
     C                   EVAL      PFECBD = VPFECBD
     C                   EVAL      PFSBCR = VPFSBCR
     C                   EVAL      PFINSB = VPFINSB
     C                   EVAL      PFTPPR = VPFTPPR
     C                   EVAL      PFPEPR = VPFPEPR
     C                   EVAL      PFGLPA = VPFGLPA
     C                   EVAL      PFTPFD = VPFTPFD
     C                   EVAL      PFSBLW = VPFSBLW
     C                   EVAL      PFDPIV = VPFDPIV
     C                   EVAL      PFEDIV = VPFEDIV
     C                   EVAL      PFCATC = VPFCATC
     C                   EVAL      PFTPAC = VPFTPAC
     C                   EVAL      PFCLRL = VPFCLRL
     C                   EVAL      PFACST = VPFACST
     C                   EVAL      PFLNIT = VPFLNIT
     C                   EVAL      PFTEGL = VPFTEGL
     C                   EVAL      PFUNDT = VPFUNDT
     C                   EVAL      PFPSAM = VPFPSAM
     C                   EVAL      PFLEAD = VPFLEAD
     C                   EVAL      PFPTRP = VPFPTRP                                        LUC139
     C                   EVAL      PFCMPC = VPFCMPC                                        LUC139

      ** Write new Extension Record

     C                   WRITE     LECLT1D0

     C                   ELSE

      ** Amend the transaction

     C                   EXSR      SRAMD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAMD - Amend a transaction                                  *
      *                                                               *
      *****************************************************************
     C     SRAMD         BEGSR

     C                   IF        *IN50 = *OFF

      ** Set Transaction Detail fields on amend

     C                   EVAL      PFLNRF = VPFLNRF
     C                   EVAL      PFMOOP = VPFMOOP
     C                   EVAL      PFAGCT = VPFAGCT
     C                   EVAL      PFAGCL = VPFAGCL
     C                   EVAL      PFECBD = VPFECBD
     C                   EVAL      PFSBCR = VPFSBCR
     C                   EVAL      PFINSB = VPFINSB
     C                   EVAL      PFTPPR = VPFTPPR
     C                   EVAL      PFPEPR = VPFPEPR
     C                   EVAL      PFGLPA = VPFGLPA
     C                   EVAL      PFTPFD = VPFTPFD
     C                   EVAL      PFSBLW = VPFSBLW
     C                   EVAL      PFDPIV = VPFDPIV
     C                   EVAL      PFEDIV = VPFEDIV
     C                   EVAL      PFCATC = VPFCATC
     C                   EVAL      PFTPAC = VPFTPAC
     C                   EVAL      PFCLRL = VPFCLRL
     C                   EVAL      PFACST = VPFACST
     C                   EVAL      PFLNIT = VPFLNIT
     C                   EVAL      PFTEGL = VPFTEGL
     C                   EVAL      PFUNDT = VPFUNDT
     C                   EVAL      PFPSAM = VPFPSAM
     C                   EVAL      PFLEAD = VPFLEAD
     C                   EVAL      PFPTRP = VPFPTRP                                        LUC139
     C                   EVAL      PFCMPC = VPFCMPC                                        LUC139

      ** Update Record

     C                   UPDATE    LECLT1D0
     C                   ELSE

      ** Insert the transaction

     C                   EXSR      SRINS
     C                   ENDIF

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
