000100210121     H COPYRIGHT('(c) Finastra International Limited 2020')
000101210121      *****************************************************************
000102210121/*STD *  RPGBASEBND                                                   *
000103210121/*EXI *  TEXT('Midas Loan Activity Enquiry adoptation program')       *
000104210121      *****************************************************************
000105210121      *                                                               *
000106210121      *  Midas - Application Programming Interfaces module            *
000107210121      *                                                               *
000108210121      *  APCALRTE - Loan Activity Enquiry adoptation program          *
000109210121      *                                                               *
000110210121      *  (c) Finastra International Limited 2020                      *
000112210121      *                                                               *
000113210121      *  Last Amend No. CLE172 *CREATE     Date 01Oct20               *
000114210121      *                                                               *
000115210121      *****************************************************************
000116210121      *                                                               *
000117210121      *  CLE172 - LIBOR Deregulation - Lending                        *
000118210121      *                                                               *
000119210121      *****************************************************************
000120210121      ** +--------------------------------------+
000121210121      ** | Automatically included D-specs       |
000122210121      ** | ==============================       |
000123210121      ** +--------------------------------------+
000124210121
000125210121      ** +--------------------------------------+
000126210121      ** | End of automatically included D-specs|
000127210121      ** | =====================================|
000128210121      ** +--------------------------------------+
000129210121
000136210121      ** Input Buffer
000137210121     D I@JavaInp       DS            13
000138210121     D  I@LNIN                 1      6
000139210121     D  I@DTIN                 7     12
000140210121     D  I@CDIN                13     13
000148210121
000149210121      ** Output Fields
000152210121     D O@CNUM          S              6
000153210121     D O@CRNM          S             20
000154210121     D O@OLNO          S              6
000155210121     D O@CSSN          S             20
000156210121     D O@LNRF          S              6
000157210121     D O@BRCA          S              3
000158210121     D O@TOLN          S              6
000159210121     D O@ACST          S              7
000160210121     D O@FCUS          S              6
000161210121     D O@FTYP          S              6
000162210121     D O@LNKS          S              3
000163210121     D O@MNSG          S              3
000164210121     D O@GASS          S              3
000165210121     D O@CPAM          S             18
000166210121     D O@CCYL          S              3
000167210121     D O@INOT          S             18
000168210121     D O@RDFC          S              1
000169210121     D O@RAMT          S             17
000170210121     D O@RFRQ          S              1
000171210121     D O@RDYN          S              2
000172210121     D O@NRPD          S              7
000173210121     D O@REPT          S              1
000174210121     D O@ADDI          S              1
000175210121     D O@IPFR          S              2
000176210121     D O@IFDY          S              2
000177210121     D O@NIDT          S              7
000178210121     D O@CAPI          S              3
000179210121     D O@MDAT          S              7
000180210121     D O@PWOD          S             17
000181210121     D O@IWOD          S             17
000182210121     D O@WTWD          S             17
000183210121     D O@NROD          S              7
000184210121     D O@AIMN          S             17
000185210121
000186210121      ** +--- Start of main processing -----------------------------------+
000187210121
000196210121     C                   CALL      'LE0212'
000197210121     C                   PARM                    I@LNIN
000198210121     C                   PARM                    I@DTIN
000199210121     C                   PARM                    I@CDIN
000202210121     C                   PARM                    O@CNUM
000203210121     C                   PARM                    O@CRNM
000204210121     C                   PARM                    O@OLNO
000205210121     C                   PARM                    O@CSSN
000206210121     C                   PARM                    O@LNRF
000207210121     C                   PARM                    O@BRCA
000208210121     C                   PARM                    O@TOLN
000209210121     C                   PARM                    O@ACST
000210210121     C                   PARM                    O@FCUS
000211210121     C                   PARM                    O@FTYP
000212210121     C                   PARM                    O@LNKS
000213210121     C                   PARM                    O@MNSG
000214210121     C                   PARM                    O@GASS
000215210121     C                   PARM                    O@CPAM
000216210121     C                   PARM                    O@CCYL
000217210121     C                   PARM                    O@INOT
000218210121     C                   PARM                    O@RDFC
000219210121     C                   PARM                    O@RAMT
000220210121     C                   PARM                    O@RFRQ
000221210121     C                   PARM                    O@RDYN
000222210121     C                   PARM                    O@NRPD
000224210121     C                   PARM                    O@REPT
000225210121     C                   PARM                    O@ADDI
000226210121     C                   PARM                    O@IPFR
000227210121     C                   PARM                    O@IFDY
000228210121     C                   PARM                    O@NIDT
000229210121     C                   PARM                    O@CAPI
000230210121     C                   PARM                    O@MDAT
000231210121     C                   PARM                    O@PWOD
000232210121     C                   PARM                    O@IWOD
000233210121     C                   PARM                    O@WTWD
000234210121     C                   PARM                    O@NROD
000235210121     C                   PARM                    O@AIMN
000236210121
000237210121     C                   SETON                                        LR
000238210121     C                   RETURN
000239210121      ****************************************************************
000240210121      *  Initialisation                                              *
000241210121      ****************************************************************
000242210121     C     *INZSR        BEGSR
000243210121
000244210121     C     *ENTRY        PLIST
000245210121     C                   PARM                    I@JavaInp
000248210121     C                   PARM                    O@CNUM
000249210121     C                   PARM                    O@CRNM
000250210121     C                   PARM                    O@OLNO
000251210121     C                   PARM                    O@CSSN
000252210121     C                   PARM                    O@LNRF
000253210121     C                   PARM                    O@BRCA
000254210121     C                   PARM                    O@TOLN
000255210121     C                   PARM                    O@ACST
000256210121     C                   PARM                    O@FCUS
000257210121     C                   PARM                    O@FTYP
000258210121     C                   PARM                    O@LNKS
000259210121     C                   PARM                    O@MNSG
000260210121     C                   PARM                    O@GASS
000261210121     C                   PARM                    O@CPAM
000262210121     C                   PARM                    O@CCYL
000263210121     C                   PARM                    O@INOT
000264210121     C                   PARM                    O@RDFC
000265210121     C                   PARM                    O@RAMT
000266210121     C                   PARM                    O@RFRQ
000267210121     C                   PARM                    O@RDYN
000268210121     C                   PARM                    O@NRPD
000270210121     C                   PARM                    O@REPT
000271210121     C                   PARM                    O@ADDI
000272210121     C                   PARM                    O@IPFR
000273210121     C                   PARM                    O@IFDY
000274210121     C                   PARM                    O@NIDT
000275210121     C                   PARM                    O@CAPI
000276210121     C                   PARM                    O@MDAT
000277210121     C                   PARM                    O@PWOD
000278210121     C                   PARM                    O@IWOD
000279210121     C                   PARM                    O@WTWD
000280210121     C                   PARM                    O@NROD
000281210121     C                   PARM                    O@AIMN
000282210121
000283210121     C                   ENDSR
000284210121      ****************************************************************
000285210121
000286210121
