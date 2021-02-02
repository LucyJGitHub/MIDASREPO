     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Loan Activity Enquiry adoptation program')       *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APCALRTE - Loan Activity Enquiry adoptation program          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172 *CREATE     Date 01Oct20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | Automatically included D-specs       |
      ** | ==============================       |
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** | End of automatically included D-specs|
      ** | =====================================|
      ** +--------------------------------------+

      ** Input Buffer
     D I@JavaInp       DS            13
     D  I@LNIN                 1      6
     D  I@DTIN                 7     12
     D  I@CDIN                13     13

      ** Output Fields
     D O@CNUM          S              6
     D O@CRNM          S             20
     D O@OLNO          S              6
     D O@CSSN          S             20
     D O@LNRF          S              6
     D O@BRCA          S              3
     D O@TOLN          S              6
     D O@ACST          S              7
     D O@FCUS          S              6
     D O@FTYP          S              6
     D O@LNKS          S              3
     D O@MNSG          S              3
     D O@GASS          S              3
     D O@CPAM          S             18
     D O@CCYL          S              3
     D O@INOT          S             18
     D O@RDFC          S              1
     D O@RAMT          S             17
     D O@RFRQ          S              1
     D O@RDYN          S              2
     D O@NRPD          S              7
     D O@REPT          S              1
     D O@ADDI          S              1
     D O@IPFR          S              2
     D O@IFDY          S              2
     D O@NIDT          S              7
     D O@CAPI          S              3
     D O@MDAT          S              7
     D O@PWOD          S             17
     D O@IWOD          S             17
     D O@WTWD          S             17
     D O@NROD          S              7
     D O@AIMN          S             17

      ** +--- Start of main processing -----------------------------------+

     C                   CALL      'LE0212'
     C                   PARM                    I@LNIN
     C                   PARM                    I@DTIN
     C                   PARM                    I@CDIN
     C*                  PARM                    O@CNUM
     C*                  PARM                    O@CRNM
     C*                  PARM                    O@OLNO
     C*                  PARM                    O@CSSN
     C*                  PARM                    O@LNRF
     C*                  PARM                    O@BRCA
     C*                  PARM                    O@TOLN
     C*                  PARM                    O@ACST
     C*                  PARM                    O@FCUS
     C*                  PARM                    O@FTYP
     C*                  PARM                    O@LNKS
     C*                  PARM                    O@MNSG
     C*                  PARM                    O@GASS
     C*                  PARM                    O@CPAM
     C*                  PARM                    O@CCYL
     C*                  PARM                    O@INOT
     C*                  PARM                    O@RDFC
     C*                  PARM                    O@RAMT
     C*                  PARM                    O@RFRQ
     C*                  PARM                    O@RDYN
     C*                  PARM                    O@NRPD
     C*                  PARM                    O@REPT
     C*                  PARM                    O@ADDI
     C*                  PARM                    O@IPFR
     C*                  PARM                    O@IFDY
     C*                  PARM                    O@NIDT
     C*                  PARM                    O@CAPI
     C*                  PARM                    O@MDAT
     C*                  PARM                    O@PWOD
     C*                  PARM                    O@IWOD
     C*                  PARM                    O@WTWD
     C*                  PARM                    O@NROD
     C*                  PARM                    O@AIMN

     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      *  Initialisation                                              *
      ****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    I@JavaInp
     C*                  PARM                    O@CNUM
     C*                  PARM                    O@CRNM
     C*                  PARM                    O@OLNO
     C*                  PARM                    O@CSSN
     C*                  PARM                    O@LNRF
     C*                  PARM                    O@BRCA
     C*                  PARM                    O@TOLN
     C*                  PARM                    O@ACST
     C*                  PARM                    O@FCUS
     C*                  PARM                    O@FTYP
     C*                  PARM                    O@LNKS
     C*                  PARM                    O@MNSG
     C*                  PARM                    O@GASS
     C*                  PARM                    O@CPAM
     C*                  PARM                    O@CCYL
     C*                  PARM                    O@INOT
     C*                  PARM                    O@RDFC
     C*                  PARM                    O@RAMT
     C*                  PARM                    O@RFRQ
     C*                  PARM                    O@RDYN
     C*                  PARM                    O@NRPD
     C*                  PARM                    O@REPT
     C*                  PARM                    O@ADDI
     C*                  PARM                    O@IPFR
     C*                  PARM                    O@IFDY
     C*                  PARM                    O@NIDT
     C*                  PARM                    O@CAPI
     C*                  PARM                    O@MDAT
     C*                  PARM                    O@PWOD
     C*                  PARM                    O@IWOD
     C*                  PARM                    O@WTWD
     C*                  PARM                    O@NROD
     C*                  PARM                    O@AIMN

     C                   ENDSR
      ****************************************************************


