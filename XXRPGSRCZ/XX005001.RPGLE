000100210907                           H DEBUG DATEDIT(*YMD)
000101210907      *****************************************************************
000102210907/*STD *  RPGBASEBND                                                   *
000103210907/*EXI *  TEXT('Midas XX Account Codes Mapping to HO Details')         *
000104210907      *****************************************************************
000105210907      *                                                               *
000106210907      *  Midas - General Ledger Module                                *
000107210907      *                                                               *
000108210907      *  XX005001 - Midas XX Account Codes Mapping to HO Details      *
000109210907      *               Enquiry screen                                  *
000110210907      *                                                               *
000111210907      *  Function:  This program will maintain the mapping between    *
000112210907      *             the Midas Account Codes and HO Details            *
000113210907      *                                                               *
000114210907      *  (C) Finastra International Limited 2021                      *
000115210907      *                                                               *
000116210907      *  Last Amend No. DRI005  *CREATE    Date 13Apr21               *
000117210907      *                                                               *
000118210907      *---------------------------------------------------------------*
000119210907      *                                                               *
000120210907      *  DRI005 - HO and EDW Extracts                                 *
000121210907      *                                                               *
000122210907      *****************************************************************
000123210907      ** Midas A/c Codes Mapping to HO Details screen
000124210907     FXX005001DFCF   E             Workstn Usropn
000125210907     F                                     Sfile(#SFLRCD:##RR)
000126210907     F                                     Infds(Infds#)
000127210907     F                                     Infsr(*PSSR)
000128210907      *
000129210907      ** XX Midas A/c Codes Mapping to HO Details - Rtv
000130210907     FXXACHOML0 IF   E           K DISK    Usropn
000131210907     F                                     Infds(Infds1)
000132210907     F                                     Infsr(*PSSR)
000133210907      *
000134210907      /EJECT
000135210907      *****************************************************************
000136210907      ** +-------------------------------+
000137210907      ** ¦ Data structures specification |
000138210907      ** +-------------------------------+
000139210907      *
000140210907     D PGMDS         ESDs                  Extname(Y2PGDSP)
000141210907
000142210907      ** Display file information data structure
000143210907     D Infds#        E Ds                  Extname(Y2I#DSP)
000144210907
000145210907      ** File information data structure
000146210907     D Infds1        E Ds                  Extname(Y2I1DSP)
000147210907
000148210907      ** Copyright array
000149210907     D RUNDAT          Ds
000150210907     D  MRDT                   1      7
000151210907     D  RDNB                   8     10P 0
000152210907     D  SUC                   11     11
000153210907     D  DFF                   12     12
000154210907     D  MBIN                  13     13
000155210907
000156210907      ** Outward parameters
000157210907
000158210907      ** Outward parameters
000159210907     D PARC            Ds            23
000160210907     D  PAMDAC                 1     10
000161210907     D  PAHOAC                11     15
000162210907     D  PAHOPC                16     19
000163210907     D  PAHOMC                20     22
000164210907     D  PAEXCL                23     23
000165210907
000166210907      ** Validation Array for valid Midas A/c Code
000167210907     D VLD             S              1A   DIM(10) PERRCD(10) CTDATA
000168210907
000169210907      ** Index for looping through the Midas A/c Code
000170210907     D WIdx1           S              2S 0
000171210907
000172210907      ** Midas A/c Code
000173210907     D MidAccod        S              1A   DIM(10)
000174210907
000175210907      ** Parameter declarations
000176210907     D P1Parm          Ds
000177210907     D  P1DFMD                 1      1
000178210907
000179210907      **
000180210907     D                 Ds
000181210907     D  ZAMSDA                 1    132
000182210907     D  ZA0001                 1      1
000183210907     D  ZA0002                 1      1
000184210907      /EJECT
000185210907
000186210907      *****************************************************************
000187210907      ** Entry parameters
000188210907      *****************************************************************
000189210907      *
000190210907     C     *Entry        Plist
000191210907     C                   Parm                    P0RTN             7
000192210907     C     P1DFMD        Parm                    WP0001            1
000193210907
000194210907      ** Initialize
000195210907     C                   Exsr      ZZINIT
000196210907
000197210907     C                   Do        *Hival
000198210907      * Initialise & load subfile page
000199210907     C                   Exsr      BAIZSF
000200210907     C                   Movel     'N'           W0RSF             1
000201210907
000202210907      ** Display screen until reload requested
000203210907     C     W0RSF         Doweq     'N'
000204210907      * Display screen
000205210907     C                   Exsr      CAEXFM
000206210907      * Process response
000207210907      * Cancel & exit program
000208210907     C   03              Cas                     ZXEXPG
000209210907      * HOME: Request subfile reload
000210210907     C   05              Cas                     FBRQRL
000211210907      * Display next SFL page
000212210907     C   27              Cas                     BBLDSF
000213210907      * Process screen input
000214210907     C                   Cas                     DAPR##
000215210907     C                   End
000216210907      *
000217210907     C                   Enddo
000218210907     C                   Enddo
000219210907      /EJECT
000220210907
000221210907      *****************************************************************
000222210907      ** Initialise and load subfile page
000223210907      *****************************************************************
000224210907      *
000225210907     CSR   BAIZSF        Begsr
000226210907      * Clear subfile
000227210907     C                   Seton                                        80
000228210907     C                   Write     #SFLCTL
000229210907     C                   Setoff                                       80
000230210907      * Reset no of records in subfile
000231210907     C                   Z-Add     *Zero         ##RRMX            5 081
000232210907      * Initialize subfile control
000233210907     C     KPOS          Klist
000234210907     C                   Kfld                    XXMACOD
000235210907      * Setup key
000236210907     C                   Move      #2MDAC        XXMACOD
000237210907      *
000238210907     C     KPOS          Setll     XXACHOML0
000239210907     C                   Read      XXACHOML0                            8782
000240210907      * Save previous selector values
000241210907     C     *LIKE         Define    #2MDAC        WZMDAC
000242210907     C                   Movel     #2MDAC        WZMDAC
000243210907     C     *LIKE         Define    #2HOAC        WZHOAC
000244210907     C                   Movel     #2HOAC        WZHOAC
000245210907     C     *LIKE         Define    #2HOPC        WZHOPC
000246210907     C                   Movel     #2HOPC        WZHOPC
000247210907     C     *LIKE         Define    #2HOMC        WZHOMC
000248210907     C                   Movel     #2HOMC        WZHOMC
000249210907     C     *LIKE         Define    #2EXCL        WZEXCL
000250210907     C                   Movel     #2EXCL        WZEXCL
000251210907      *
000252210907     C     *LIKE         Define    #2HOAC        #3HOAC
000253210907     C     *LIKE         Define    #2HOPC        #3HOPC
000254210907     C     *LIKE         Define    #2HOMC        #3HOMC
000255210907     C     *LIKE         Define    #2EXCL        #3EXCL
000256210907     C
000257210907      * Load subfile page
000258210907     C                   Z-Add     0             ##RROK            5 0
000259210907     C                   Exsr      BBLDSF
000260210907     CSR   BAEXIT        Endsr
000261210907      /EJECT
000262210907
000263210907      *****************************************************************
000264210907      ** Load subfile page
000265210907      *****************************************************************
000266210907      *
000267210907     CSR   BBLDSF        Begsr
000268210907      ** Re-establish fields in Read-ahead record
000269210907     C   27              Do
000270210907     C  N82              ReadP     XXACHOML0                              90
000271210907     C  N82              Read      XXACHOML0                              90
000272210907     C                   Enddo
000273210907
000274210907      * Setof record error indicators
000275210907     C                   Movel     *ALL'0'       WKIND0            1
000276210907     C                   Movea     WKIND0        *IN(35)
000277210907      * Start at previous highest record in SFL
000278210907     C                   Z-Add     ##RRMX        ##RR              5 0
000279210907      * Reset count of DBF records Read
000280210907     C                   Z-Add     0             ##RRRD            5 0
000281210907      * Set required pages based on *Set Cursor or *subfile Pages
000282210907     C     W0RR0         Ifgt      0
000283210907     C     W0RR0         Div       ##SFPG        ##SPG             3 0
000284210907     C                   Mvr                     ##SLIN            3 0
000285210907
000286210907     C     ##SLIN        Ifgt      0
000287210907     C                   Add       1             ##SPG
000288210907     C                   Endif
000289210907
000290210907     C     W0SPG         Ifgt      ##SPG
000291210907     C                   Z-Add     W0SPG         ##SPG
000292210907     C                   Endif
000293210907
000294210907     C                   Else
000295210907     C                   Z-Add     W0SPG         ##SPG
000296210907     C                   Endif
000297210907
000298210907      * Compute lines required based on pages
000299210907     C     ##SPG         Mult      ##SFPG        ##SFLN            9 0
000300210907     C     ##SFLN        Ifgt      999
000301210907     C                   Z-Add     999           ##SFLN
000302210907     C                   Endif
000303210907
000304210907      ** Load next SFL page until SFL page full, or scan limit reached
000305210907     C     *IN82         Doweq     '0'
000306210907     C     ##RROK        Andlt     ##SFLN
000307210907     C     ##RRRD        Andlt     W0SLM
000308210907      * Check selection fields - if fail, Read next record
000309210907     C     #2MDAC        Ifeq      *Blanks
000310210907     C     #2HOAC        Ifne      *Blank
000311210907     C                   MOVE      XXMHOAC       #3HOAC
000312210907     C     #3HOAC        CabNe     #2HOAC        BB020
000313210907     C                   Endif
000314210907     C                   Endif
000315210907      *
000316210907     C     #2MDAC        Ifeq      *Blanks
000317210907     C     #2HOAC        Oreq      *Blank
000318210907     C     #2HOPC        Ifne      *Blank
000319210907     C                   Eval      #3HOPC = XXMHOPC
000320210907     C     #3HOPC        CabNe     #2HOPC        BB020
000321210907     C                   Endif
000322210907     C                   Endif
000323210907
000324210907     C     #2MDAC        Ifeq      *Blanks
000325210907     C     #2HOAC        Oreq      *Blank
000326210907     C     #2HOPC        Oreq      *Blank
000327210907     C     #2HOMC        Ifne      *Blank
000328210907     C                   Eval      #3HOMC = XXMHOMC
000329210907     C     #3HOMC        CabNe     #2HOMC        BB020
000330210907     C                   Endif
000331210907     C                   Endif
000332210907
000333210907     C     #2MDAC        Ifeq      *Blanks
000334210907     C     #2HOAC        Oreq      *Blank
000335210907     C     #2HOPC        Oreq      *Blank
000336210907     C     #2HOMC        Oreq      *Blank
000337210907     C     #2EXCL        Ifne      *Blank
000338210907     C                   Eval      #3EXCL = XXMEXCL
000339210907     C     #3EXCL        CabNe     #2EXCL        BB020
000340210907     C                   Endif
000341210907     C                   Endif
000342210907
000343210907      ** Load SFL fields
000344210907     C                   Exsr      MBFL#1
000345210907      * Allow for possible *Set Cursor processing
000346210907     C                   Add       1             ##RR
000347210907     C                   Sub       1             ##RR
000348210907     C                   Movel     'Y'           W0RSL             1
000349210907      * Allow for possible *Set Cursor processing
000350210907     C                   Add       1             ##RR
000351210907      * USER: Initialize subfile record from DBF record
000352210907     C                   Sub       1             ##RR
000353210907      * DBF record not selected
000354210907     C     W0RSL         CabNe     'Y'           BB020
000355210907      * Output to subfile
000356210907     C                   Add       1             ##RR
000357210907     C                   Add       1             ##RROK               81
000358210907      * If SFLRCD invalid, note that errors present
000359210907     C   98
000360210907     CANN99              Seton                                        99
000361210907     C                   Write     #SFLRCD
000362210907      * Tag reference
000363210907     C     BB020         TAG
000364210907      * Increment scan check count
000365210907     C                   Add       1             ##RRRD
000366210907     C                   Read      XXACHOML0                              82
000367210907     C                   Enddo
000368210907      * Tag reference
000369210907     C     BB900         TAG
000370210907
000371210907      ** If no DBF records found, display error message
000372210907     C     ##RR          Ifeq      *Zero
000373210907     C     *IN82         Andeq     '1'
000374210907      * Send message '*No data to display'
000375210907     C                   Movel     'Y2U0008'     ZAMSID
000376210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000377210907     C                   Exsr      ZASNMS
000378210907     C                   Endif
000379210907
000380210907      ** Save highest SFL record load can continue at end point
000381210907     C     ##RR          Ifgt      ##RRMX
000382210907      * Calculate top line
000383210907     C     ##RROK        Div       ##SFPG        ##SPG
000384210907     C                   Mvr                     ##SLIN
000385210907     C     ##SLIN        Ifgt      0
000386210907     C     ##RR          Sub       ##SLIN        ##SFRC
000387210907     C                   Else
000388210907     C     ##RR          Sub       ##SFPG        ##SFRC
000389210907     C                   End
000390210907     C                   Add       1             ##SFRC
000391210907     C                   Z-Add     ##RR          ##RRMX
000392210907     C                   End
000393210907
000394210907      ** If scan limit reached, display error message
000395210907     C     ##RRRD        Ifge      W0SLM
000396210907      * Send message '*Scan limit reached'
000397210907     C                   Movel     'Y2U0017'     ZAMSID
000398210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000399210907     C                   Exsr      ZASNMS
000400210907     C                   Else
000401210907     C                   Z-Add     0             ##RROK
000402210907     C                   End
000403210907     CSR   BBEXIT        Endsr
000404210907      /EJECT
000405210907
000406210907      *****************************************************************
000407210907      ** Display screen
000408210907      *****************************************************************
000409210907     CSR   CAEXFM        Begsr
000410210907      *
000411210907     C     W0HLP         Doueq     'N'
000412210907     C                   Movel     'N'           W0HLP             1
000413210907     C                   Move      *ALL'0'       ##OFF            30
000414210907     C                   MoveA     ##OFF         *IN(1)
000415210907      * Update screen time
000416210907     C                   Time                    ##TME
000417210907      * PUTOVR unless conditioned fields change
000418210907     C                   Seton                                        86
000419210907     C     *IN81         Ifne      CAIN81
000420210907     C                   Setoff                                       86
000421210907     C                   Endif
000422210907     C                   Move      *IN81         CAIN81            1
000423210907      *
000424210907     C                   Write     #MSGCTL
000425210907     C                   Write     #CMDTXT1
000426210907     C                   Exfmt     #SFLCTL
000427210907      * Maintain subfile position where possible
000428210907     C     @#SFRC        Ifgt      *Zero
000429210907     C                   Z-Add     @#SFRC        ##SFRC
000430210907     C                   Endif
000431210907      *
000432210907     C                   Enddo
000433210907      * Clear messages from program message queue
000434210907     C                   Call      'Y2CLMSC'
000435210907     C                   Parm      ##PGM         ZAPGMQ           10
000436210907     C                   Parm      '*SAME'       ZAPGRL            5
000437210907      * Reset first message only flag
000438210907     C                   Movel     'Y'           ZAFSMS            1      99
000439210907     C                   Setoff                                         8392
000440210907     CSR   CAEXIT        Endsr
000441210907      /EJECT
000442210907
000443210907      *****************************************************************
000444210907      ** Process screen input
000445210907      *****************************************************************
000446210907     CSR   DAPR##        Begsr
000447210907
000448210907      ** Confirm/update is not deferred
000449210907     C                   Movel     'N'           W0DCF             1
000450210907      * Change of position specified
000451210907     C     WZMDAC        CasNe     #2MDAC        FBRQRL
000452210907     C     WZHOAC        CasNe     #2HOAC        FBRQRL
000453210907     C     WZHOPC        CasNe     #2HOPC        FBRQRL
000454210907     C     WZHOMC        CasNe     #2HOMC        FBRQRL
000455210907     C     WZEXCL        CasNe     #2EXCL        FBRQRL
000456210907     C                   End
000457210907
000458210907      ** USER: Process subfile control (Pre-confirm)
000459210907      ** Reload subfile requested
000460210907     C     W0RSF         CabEq     'Y'           DAEXIT
000461210907     C     *IN81         Ifeq      '1'
000462210907      * Process subfile records
000463210907     C                   Exsr      DBPRSF
000464210907     C                   Endif
000465210907
000466210907      ** USER: Final processing (Pre-confirm)
000467210907      ** If error, quit processing
000468210907     C     *IN99         CabEq     '1'           DAEXIT
000469210907      * Defer confirm/update requested
000470210907     C     W0DCF         CabEq     'Y'           DAEXIT
000471210907
000472210907      ** USER: Process command keys
000473210907      ** CASE: PAR.Display file mode is Maintenance mode
000474210907     C     P1DFMD        Ifeq      'M'
000475210907      * CASE: CTL.*CMD key is *Add
000476210907     C     *IN09         Ifeq      '1'
000477210907      * Initialize calling parameters
000478210907     C                   Clear                   PARC
000479210907     C                   Movel     #2MDAC        PAMDAC
000480210907      * Call A/c Code HO Details Mapping Maintenance screen
000481210907     C                   Call      'XX005002'                           90
000482210907     C                   Parm      *Blank        W0RTN             7
000483210907     C                   Parm                    PARC
000484210907     C                   Parm      'I'           WQ0001            1
000485210907      *
000486210907     C     *IN90         Ifeq      '1'
000487210907      * Call to program ended in error
000488210907     C                   Movel     'Y2U0032'     W0RTN
000489210907     C                   Movel     *Blanks       W0CLPG           10
000490210907     C                   Movel     'XX005002'    W0CLPG
000491210907      * Send message '*Error occured on Call...'
000492210907     C                   Movel     'Y2U0032'     ZAMSID
000493210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000494210907     C                   Movel     W0CLPG        ZAMSDA
000495210907     C                   Exsr      ZASNMS
000496210907     C                   Endif
000497210907
000498210907      ** Error detected?
000499210907     C     W0RTN         Ifne      *Blank
000500210907     C                   Seton                                        9931
000501210907     C                   Endif
000502210907     C                   Movel     'Y'           W0RSF
000503210907     C                   Endif
000504210907     C                   Else
000505210907
000506210907      ** CASE: *Otherwise
000507210907      ** CASE: CTL.*CMD key is *Go to 'Add' mode
000508210907     C     *IN09         Ifeq      '1'
000509210907      * Send message 'Function key not allowed'
000510210907     C                   Movel     'USR0533'     ZAMSID
000511210907     C                   Exsr      ZASNMS
000512210907     C                   Seton                                        99
000513210907      *
000514210907     C                   Endif
000515210907     C                   Endif
000516210907      *
000517210907     CSR   DAEXIT        Endsr
000518210907      /EJECT
000519210907
000520210907      *****************************************************************
000521210907      ** Process modified subfile record
000522210907      *****************************************************************
000523210907     CSR   DBPRSF        Begsr
000524210907      *
000525210907     C                   ReadC     #SFLRCD                                92
000526210907     C     *IN92         Doweq     '0'
000527210907      * Process subfile record
000528210907     C                   Exsr      DCPRSR
000529210907     C                   Update    #SFLRCD
000530210907     C                   ReadC     #SFLRCD                                92
000531210907      *
000532210907     C                   Enddo
000533210907     CSR   DBEXIT        Endsr
000534210907      /EJECT
000535210907
000536210907      *****************************************************************
000537210907      ** Process subfile record
000538210907      *****************************************************************
000539210907     CSR   DCPRSR        Begsr
000540210907
000541210907      ** Setof error indicators and SFLNXTCHG
000542210907     C                   MoveA     WKIND0        *IN(35)
000543210907     C                   Setoff                                       98
000544210907
000545210907      ** USER: Process subfile record (Pre-confirm)
000546210907      ** Enquire Entered. CASE: RCD.*SFLSEL is *Enquire
000547210907     C     #1SEL         Ifeq      'E'
000548210907      * Initialize calling parameters
000549210907     C                   Clear                   PARC
000550210907     C                   Movel     #1MDAC        PAMDAC
000551210907     C                   Movel     #1HOAC        PAHOAC
000552210907     C                   Movel     #1HOPC        PAHOPC
000553210907     C                   Movel     #1HOMC        PAHOMC
000554210907     C                   Movel     #1EXCL        PAEXCL
000555210907      * Call CNAPS Codeword Maintenance
000556210907     C                   Call      'XX005002'                           90
000557210907     C                   Parm      *Blank        W0RTN             7
000558210907     C                   Parm                    PARC
000559210907     C                   Parm      'E'           WQ0002            1
000560210907      *
000561210907     C     *IN90         Ifeq      '1'
000562210907      * Call to program ended in error
000563210907     C                   Movel     'Y2U0032'     W0RTN
000564210907     C                   Movel     *Blanks       W0CLPG           10
000565210907     C                   Movel     'XX005002'    W0CLPG
000566210907      * Send message '*Error occured on Call...'
000567210907     C                   Movel     'Y2U0032'     ZAMSID
000568210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000569210907     C                   Movel     W0CLPG        ZAMSDA
000570210907     C                   Exsr      ZASNMS
000571210907     C                   Endif
000572210907
000573210907      ** Error detected?
000574210907     C     W0RTN         Ifne      *Blank
000575210907     C                   Seton                                        98
000576210907     C                   Endif
000577210907     C                   Movel     'Y'           W0RSF
000578210907     C                   Endif
000579210907
000580210907      ** Amend or Delete Entered
000581210907      ** CASE: PAR.Display file mode is Maintenance mode
000582210907     C     P1DFMD        Ifeq      'M'
000583210907      * CASE: RCD.*SFLSEL is *Amend
000584210907     C     #1SEL         Ifeq      'A'
000585210907      * Initialize calling parameters
000586210907     C                   Clear                   PARC
000587210907     C                   Movel     #1MDAC        PAMDAC
000588210907     C                   Movel     #1HOAC        PAHOAC
000589210907     C                   Movel     #1HOPC        PAHOPC
000590210907     C                   Movel     #1HOMC        PAHOMC
000591210907     C                   Movel     #1EXCL        PAEXCL
000592210907      * Call CNAPS Codeword Maintenance
000593210907     C                   Call      'XX005002'                           90
000594210907     C                   Parm      *Blank        W0RTN             7
000595210907     C                   Parm                    PARC
000596210907     C                   Parm      'A'           WQ0003            1
000597210907      *
000598210907     C     *IN90         Ifeq      '1'
000599210907      * Call to program ended in error
000600210907     C                   Movel     'Y2U0032'     W0RTN
000601210907     C                   Movel     *Blanks       W0CLPG           10
000602210907     C                   Movel     'XX005002'    W0CLPG
000603210907      * Send message '*Error occured on Call...'
000604210907     C                   Movel     'Y2U0032'     ZAMSID
000605210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000606210907     C                   Movel     W0CLPG        ZAMSDA
000607210907     C                   Exsr      ZASNMS
000608210907     C                   Endif
000609210907
000610210907      ** Error detected?
000611210907     C     W0RTN         Ifne      *Blank
000612210907     C                   Seton                                        98
000613210907     C                   Endif
000614210907     C                   Movel     'Y'           W0RSF
000615210907     C                   Endif
000616210907
000617210907      ** Delete Entered
000618210907      ** CASE: RCD.*SFLSEL is *Delete
000619210907     C     #1SEL         Ifeq      'D'
000620210907      * Initialize calling parameters
000621210907     C                   Clear                   PARC
000622210907     C                   Movel     #1MDAC        PAMDAC
000623210907     C                   Movel     #1HOAC        PAHOAC
000624210907     C                   Movel     #1HOPC        PAHOPC
000625210907     C                   Movel     #1HOMC        PAHOMC
000626210907     C                   Movel     #1EXCL        PAEXCL
000627210907      * Call CNAPS Codeword Maintenance
000628210907     C                   Call      'XX005002'                           90
000629210907     C                   Parm      *Blank        W0RTN             7
000630210907     C                   Parm                    PARC
000631210907     C                   Parm      'D'           WQ0004            1
000632210907      *
000633210907     C     *IN90         Ifeq      '1'
000634210907      * Call to program ended in error
000635210907     C                   Movel     'Y2U0032'     W0RTN
000636210907     C                   Movel     *Blanks       W0CLPG           10
000637210907     C                   Movel     'XX005002'    W0CLPG
000638210907      * Send message '*Error occured on Call...'
000639210907     C                   Movel     'Y2U0032'     ZAMSID
000640210907     C                   Movel     'Y2USRMSG'    ZAMSGF
000641210907     C                   Movel     W0CLPG        ZAMSDA
000642210907     C                   Exsr      ZASNMS
000643210907     C                   Endif
000644210907
000645210907      ** Error detected?
000646210907     C     W0RTN         Ifne      *Blank
000647210907     C                   Seton                                        98
000648210907     C                   Endif
000649210907     C                   Movel     'Y'           W0RSF
000650210907     C                   Endif
000651210907     C                   Else
000652210907
000653210907      ** CASE: *Otherwise
000654210907      ** Amend entered in Enquiry mode
000655210907      ** CASE: RCD.*SFLSEL is *Amend
000656210907     C     #1SEL         Ifeq      'A'
000657210907      * Setup message data for message
000658210907     C                   Movel     #1SEL         ZA0001
000659210907      * Send message 'value for field not valid'
000660210907     C                   Movel     'USR0553'     ZAMSID
000661210907     C                   Exsr      ZASNMS
000662210907     C                   Seton                                        9835
000663210907      *
000664210907     C                   Goto      DCEXIT
000665210907     C                   Endif
000666210907
000667210907      ** Delete entered in Enquiry mode
000668210907      ** CASE: RCD.*SFLSEL is *Delete
000669210907     C     #1SEL         Ifeq      'D'
000670210907      * Setup message data for message
000671210907     C                   Movel     #1SEL         ZA0002
000672210907      * Send message 'value for field not valid'
000673210907     C                   Movel     'USR0553'     ZAMSID
000674210907     C                   Exsr      ZASNMS
000675210907     C                   Seton                                        9835
000676210907      *
000677210907     C                   Goto      DCEXIT
000678210907     C                   Endif
000679210907     C                   Endif
000680210907
000681210907      ** F3 taken from EDTRCD program
000682210907      ** CASE: PGM.*Return code is *User QUIT requested
000683210907     C     W0RTN         Ifeq      'Y2U9999'
000684210907     C                   Movel     W0RTN         P0RTN
000685210907     C                   Exsr      ZYEXPG
000686210907     C                   Endif
000687210907      *
000688210907     C     *IN98         Ifeq      '1'
000689210907      * SFLRCD invalid
000690210907     C  N99              Z-Add     ##RR          ##SFRC               99
000691210907     C                   Seton                                        84
000692210907     C                   Else
000693210907      * SFLRCD valid.
000694210907     C                   Setoff                                       84
000695210907     C                   Movel     *Blank        #1SEL
000696210907     C                   Endif
000697210907      *
000698210907     CSR   DCEXIT        Endsr
000699210907      /EJECT
000700210907
000701210907      *****************************************************************
000702210907      ** Request subfile reload
000703210907      *****************************************************************
000704210907     CSR   FBRQRL        Begsr
000705210907      *
000706210907     C                   Movel     'Y'           W0RSF
000707210907     C     *IN05         Ifeq      *On
000708210907     C                   Move      *Blanks       #2MDAC
000709210907     C                   Setoff                                       70
000710210907     C                   Move      *Blanks       #2HOAC
000711210907     C                   Move      *Blanks       #2HOPC
000712210907     C                   Move      *Blanks       #2HOMC
000713210907     C                   Move      *Blanks       #2EXCL
000714210907     C                   Endif
000715210907      *
000716210907      * Midas A/c Code should be 10 long
000717210907     C                   Setoff                                       70
000718210907     C                   If        #2MDAC <> *Blanks
000719210907     C                   MoveA     #2MDAC        MidAccod
000720210907     C                   For       WIdx1 = 1 TO 10
000721210907     C                   If        %LookUp(MidAccod(WIdx1):VLD) = 0
000722210907     C                   Movel     'DRI0511'     ZAMSID
000723210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000724210907     C                   Seton                                        70
000725210907     C                   Exsr      ZASNMS
000726210907     C                   Movel     'N'           W0RSF
000727210907     C                   Goto      FBEXIT
000728210907     C                   Endif
000729210907     C                   EndFor
000730210907     C                   Endif
000731210907      *
000732210907     CSR   FBEXIT        Endsr
000733210907      /EJECT
000734210907
000735210907      *****************************************************************
000736210907      ** Move XXACHOML0 fields to subfile
000737210907      *****************************************************************
000738210907     CSR   MBFL#1        Begsr
000739210907      *
000740210907     C                   Movel     *Blank        #1SEL
000741210907     C                   Move      XXMACOD       #1MDAC
000742210907     C                   Movel     XXMHOAC       #1HOAC
000743210907     C                   Movel     XXMHOPC       #1HOPC
000744210907     C                   Movel     XXMHOMC       #1HOMC
000745210907     C                   Movel     XXMEXCL       #1EXCL
000746210907      *
000747210907     CSR   MBEXIT        Endsr
000748210907      /EJECT
000749210907
000750210907      *****************************************************************
000751210907      ** Initialise subfile control
000752210907      *****************************************************************
000753210907     CSR   MEIZ#2        Begsr
000754210907      *
000755210907     C                   Movel     *Blank        #2MDAC
000756210907     C                   Movel     *Blank        #2HOAC
000757210907     C                   Movel     *Blank        #2HOPC
000758210907     C                   Movel     *Blank        #2HOMC
000759210907     C                   Movel     *Blank        #2EXCL
000760210907      *
000761210907     CSR   MEEXIT        Endsr
000762210907      /EJECT
000763210907
000764210907      *****************************************************************
000765210907      ** Set up Display file Header Title
000766210907      *****************************************************************
000767210907     CSR   UASUBR        Begsr
000768210907
000769210907      * CASE: PAR.Display file mode is Enquiry mode
000770210907     C     P1DFMD        Ifeq      'E'
000771210907      * Setup message data for message
000772210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000773210907     C                   Call      'Y2RVMGC'                            90
000774210907     C                   Parm      *Blank        W0RTN             7
000775210907     C                   Parm      'DRI0512'     ZAMSID            7
000776210907     C                   Parm                    ZAMSGF           10
000777210907     C                   Parm                    ZAMSDA          132
000778210907     C     WUDFTL        Parm                    W0MTX           132
000779210907     C                   Movel     *Blank        ZAMSDA
000780210907     C                   Movel     *Blank        ZAMSGF
000781210907     C                   Else
000782210907
000783210907      * CASE: PAR.Display file mode is Maintenance mode
000784210907     C     P1DFMD        Ifeq      'M'
000785210907      * Setup message data for message
000786210907     C                   Movel     'XXUSRMSG'    ZAMSGF
000787210907     C                   Call      'Y2RVMGC'                            90
000788210907     C                   Parm      *Blank        W0RTN             7
000789210907     C                   Parm      'DRI0513'     ZAMSID            7
000790210907     C                   Parm                    ZAMSGF           10
000791210907     C                   Parm                    ZAMSDA          132
000792210907     C     WUDFTL        Parm                    W0MTX           132
000793210907     C                   Movel     *Blank        ZAMSDA
000794210907     C                   Movel     *Blank        ZAMSGF
000795210907     C                   Endif
000796210907     C                   Endif
000797210907      * Move to Header Title - Standard Functions  *
000798210907     C                   Movel     WUDFTL        ##URPT
000799210907      *
000800210907     CSR   UAEXIT        Endsr
000801210907      /EJECT
000802210907
000803210907      *****************************************************************
000804210907      ** Set up Display file Footers
000805210907      *****************************************************************
000806210907     CSR   UBSUBR        Begsr
000807210907
000808210907      * CASE: PAR.Display file mode is Enquiry mode
000809210907     C     P1DFMD        Ifeq      'E'
000810210907      * Setup message data for message
000811210907     C                   Movel     ZADFMF        ZAMSGF
000812210907     C                   Call      'Y2RVMGC'                            90
000813210907     C                   Parm      *Blank        W0RTN             7
000814210907     C                   Parm      'USR2911'     ZAMSID            7
000815210907     C                   Parm                    ZAMSGF           10
000816210907     C                   Parm                    ZAMSDA          132
000817210907     C     WUSFT1        Parm                    W0MTX           132
000818210907     C                   Movel     *Blank        ZAMSDA
000819210907     C                   Movel     *Blank        ZAMSGF
000820210907      * Setup message data for message
000821210907     C                   Movel     ZADFMF        ZAMSGF
000822210907     C                   Call      'Y2RVMGC'                            90
000823210907     C                   Parm      *Blank        W0RTN             7
000824210907     C                   Parm      'USR2912'     ZAMSID            7
000825210907     C                   Parm                    ZAMSGF           10
000826210907     C                   Parm                    ZAMSDA          132
000827210907     C     WUSFT2        Parm                    W0MTX           132
000828210907     C                   Movel     *Blank        ZAMSDA
000829210907     C                   Movel     *Blank        ZAMSGF
000830210907     C                   Else
000831210907
000832210907      * CASE: PAR.Display file mode is Maintenance mode
000833210907     C     P1DFMD        Ifeq      'M'
000834210907      * Setup message data for message
000835210907     C                   Movel     ZADFMF        ZAMSGF
000836210907     C                   Call      'Y2RVMGC'                            90
000837210907     C                   Parm      *Blank        W0RTN             7
000838210907     C                   Parm      'USR2913'     ZAMSID            7
000839210907     C                   Parm                    ZAMSGF           10
000840210907     C                   Parm                    ZAMSDA          132
000841210907     C     WUSFT1        Parm                    W0MTX           132
000842210907     C                   Movel     *Blank        ZAMSDA
000843210907     C                   Movel     *Blank        ZAMSGF
000844210907      * Setup message data for message
000845210907      * Retrieve message STD FTR:DSPFIL Maint/2
000846210907     C                   Movel     ZADFMF        ZAMSGF
000847210907     C                   Call      'Y2RVMGC'                            90
000848210907     C                   Parm      *Blank        W0RTN             7
000849210907     C                   Parm      'USR2914'     ZAMSID            7
000850210907     C                   Parm                    ZAMSGF           10
000851210907     C                   Parm                    ZAMSDA          132
000852210907     C     WUSFT2        Parm                    W0MTX           132
000853210907     C                   Movel     *Blank        ZAMSDA
000854210907     C                   Movel     *Blank        ZAMSGF
000855210907     C                   Endif
000856210907     C                   Endif
000857210907      * Move to Double Footer - Standard Functions  *
000858210907     C                   Movel     WUSFT1        ##CTX1
000859210907     C                   Movel     WUSFT2        ##CTX2
000860210907      *
000861210907     CSR   UBEXIT        Endsr
000862210907      /EJECT
000863210907
000864210907      *****************************************************************
000865210907      ** Send message to program's message queue
000866210907      *****************************************************************
000867210907     CSR   ZASNMS        Begsr
000868210907      *
000869210907     C     ZAPGMQ        Ifeq      *Blank
000870210907     C                   Movel     ##PGM         ZAPGMQ
000871210907     C                   Endif
000872210907      * If no message file specified, use default
000873210907     C     ZAMSGF        Ifeq      *Blank
000874210907     C                   Movel     ZADFMF        ZAMSGF
000875210907     C                   Endif
000876210907      *
000877210907     C                   Call      'Y2SNMGC'
000878210907     C                   Parm                    ZAPGMQ           10
000879210907     C                   Parm                    ZAPGRL            5
000880210907     C                   Parm                    ZAMSID            7
000881210907     C                   Parm                    ZAMSGF           10
000882210907     C                   Parm                    ZAMSDA          132
000883210907     C                   Parm                    ZAMSTP            7
000884210907      * Clear all fields for default mechanism next time
000885210907     C                   Movel     *Blank        ZAPGMQ
000886210907     C                   Movel     *Blank        ZAPGRL
000887210907     C                   Movel     *Blank        ZAMSID
000888210907     C                   Movel     *Blank        ZAMSGF
000889210907     C                   Movel     *Blank        ZAMSDA
000890210907     C                   Movel     *Blank        ZAMSTP
000891210907      *
000892210907     CSR   ZAEXIT        Endsr
000893210907      /EJECT
000894210907
000895210907      *****************************************************************
000896210907      ** Cancel & exit program
000897210907      *****************************************************************
000898210907     CSR   ZXEXPG        Begsr
000899210907
000900210907      ** USER: Exit program processing
000901210907     C                   Exsr      ZYEXPG
000902210907      *
000903210907     CSR   ZXEXIT        Endsr
000904210907      /EJECT
000905210907
000906210907      *****************************************************************
000907210907      ** Exit program: Direct
000908210907      *****************************************************************
000909210907     CSR   ZYEXPG        Begsr
000910210907
000911210907      ** Exit program
000912210907     C                   RETURN
000913210907      *
000914210907     CSR   ZYEXIT        Endsr
000915210907      /EJECT
000916210907
000917210907      *****************************************************************
000918210907      ** Initialisation
000919210907      *****************************************************************
000920210907     CSR   ZZINIT        Begsr
000921210907      *
000922210907     C                   Move      *Blank        P0RTN
000923210907     C                   Move      *Blank        W0RTN             7
000924210907     C                   Movel     *Blank        W0RSL             1
000925210907     C                   Movel     *Blank        W0RSF             1
000926210907      * Initialise indicators for re-entry
000927210907     C                   Move      '0'           *IN
000928210907      * Update screen time
000929210907     C                   Time                    ##TME             6 0
000930210907      * Obtain default message file
000931210907     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
000932210907     C                   In        ZADFMF
000933210907      * Define work field Midas Run Date
000934210907     C                   Movel     *Blank        WUMRDT            7
000935210907      * Define work field Run day number
000936210907     C                   Z-Add     *Zero         WURDNB            5 0
000937210907      * Define work field Set Up Complete
000938210907     C                   Movel     *Blank        WUSUC             1
000939210907      * Define work field Date format flag
000940210907     C                   Movel     *Blank        WUDFF             1
000941210907      * Define work field Multi-branching Indicator
000942210907     C                   Movel     *Blank        WUMBIN            1
000943210907      * Define work field Display File Title
000944210907     C                   Movel     *Blank        WUDFTL           53
000945210907      * Define work field STD FTR 1
000946210907     C                   Movel     *Blank        WUSFT1           78
000947210907      * Define work field STD FTR 2
000948210907     C                   Movel     *Blank        WUSFT2           78
000949210907      * Open files first time only
000950210907     C     W0OPN         Ifeq      *Blank
000951210907     C                   Open      XX005001DF
000952210907     C                   Open      XXACHOML0
000953210907      * Signal that files are now Open
000954210907     C                   Move      'Y'           W0OPN             1
000955210907     C                   Endif
000956210907      *
000957210907     C                   Movel     'N'           W0PMT             1
000958210907     C                   Z-Add     13            ##SFPG            3 0
000959210907     C                   Z-Add     1             ##SFRC
000960210907      * Maximum record number
000961210907     C                   Z-Add     *Zero         ##RRMX
000962210907      * Scan limit
000963210907     C                   Z-Add     500           W0SLM             5 0
000964210907      * subfile pages
000965210907     C                   Z-Add     1             W0SPG             3 0
000966210907      * Processed subfile record
000967210907     C                   Z-Add     0             W0RR0             4 0
000968210907
000969210907      ** USER: Initialize program
000970210907      ** Copyright and rundate setup
000971210907     C     *Dtaara       Define                  RUNDAT
000972210907     C                   In        RUNDAT
000973210907     C                   Move      MRDT          ##MRDT            7
000974210907     C                   Move      MRDT          WUMRDT
000975210907     C                   Move      RDNB          WURDNB
000976210907     C                   Move      SUC           WUSUC
000977210907     C                   Move      DFF           WUDFF
000978210907     C                   Move      MBIN          WUMBIN
000979210907      * Set up Display file Header Title
000980210907     C                   Exsr      UASUBR
000981210907      * Set up Display file Footers
000982210907     C                   Exsr      UBSUBR
000983210907     C                   Z-Add     99999         W0SLM
000984210907      * Initialise subfile control
000985210907     C                   Exsr      MEIZ#2
000986210907      *
000987210907     CSR   ZZEXIT        Endsr
000988210907      /EJECT
000989210907
000990210907      *****************************************************************
000991210907      **
000992210907      ** *PSSR  - Program exception error routine
000993210907      **          Called automatiCally if a program error occurs,
000994210907      **          or directly by the program code using Exsr.
000995210907      **          This Subroutine DUMPs the program just once.
000996210907      **
000997210907      *****************************************************************
000998210907     CSR   *PSSR         Begsr
000999210907      *  Standard Midas PSSR processing.
001000210907     C     @RUN          Ifeq      *Blank
001001210907     C                   Move      'Y'           @RUN              1
001002210907     C                   Move      'PSSR   '     P0RTN
001003210907     C                   DUMP
001004210907      *  Route job back into Midas.
001005210907     C                   Seton                                        LR
001006210907     C                   Call      'DBERRCTL'
001007210907     C                   Endif
001008210907      *
001009210907     CSR                 Endsr
001010210907      *****************************************************************
001011210907** VLD
0010122109070123456789
