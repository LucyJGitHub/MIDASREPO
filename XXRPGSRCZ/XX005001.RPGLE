000100210908     H DEBUG DATEDIT(*YMD)
000101210908      *****************************************************************
000102210908/*STD *  RPGBASEBND                                                   *
000103210908/*EXI *  TEXT('Midas XX Account Codes Mapping to HO Details')         *
000104210908      *****************************************************************
000105210908      *                                                               *
000106210908      *  Midas - General Ledger Module                                *
000107210908      *                                                               *
000108210908      *  XX005001 - Midas XX Account Codes Mapping to HO Details      *
000109210908      *               Enquiry screen                                  *
000110210908      *                                                               *
000111210908      *  Function:  This program will maintain the mapping between    *
000112210908      *             the Midas Account Codes and HO Details            *
000113210908      *                                                               *
000114210908      *  (C) Finastra International Limited 2021                      *
000115210908      *                                                               *
000116210908      *  Last Amend No. DRI005  *CREATE    Date 13Apr21               *
000117210908      *                                                               *
000118210908      *---------------------------------------------------------------*
000119210908      *                                                               *
000120210908      *  DRI005 - HO and EDW Extracts                                 *
000121210908      *                                                               *
000122210908      *****************************************************************
000123210908      ** Midas A/c Codes Mapping to HO Details screen
000124210908     FXX005001DFCF   E             Workstn Usropn
000125210908     F                                     Sfile(#SFLRCD:##RR)
000126210908     F                                     Infds(Infds#)
000127210908     F                                     Infsr(*PSSR)
000128210908      *
000129210908      ** XX Midas A/c Codes Mapping to HO Details - Rtv
000130210908     FXXACHOML0 IF   E           K DISK    Usropn
000131210908     F                                     Infds(Infds1)
000132210908     F                                     Infsr(*PSSR)
000133210908      *
000134210908      /EJECT
000135210908      *****************************************************************
000136210908      ** +-------------------------------+
000137210908      ** ¦ Data structures specification |
000138210908      ** +-------------------------------+
000139210908      *
000140210908     D PGMDS         ESDs                  Extname(Y2PGDSP)
000141210908
000142210908      ** Display file information data structure
000143210908     D Infds#        E Ds                  Extname(Y2I#DSP)
000144210908
000145210908      ** File information data structure
000146210908     D Infds1        E Ds                  Extname(Y2I1DSP)
000147210908
000148210908      ** Copyright array
000149210908     D RUNDAT          Ds
000150210908     D  MRDT                   1      7
000151210908     D  RDNB                   8     10P 0
000152210908     D  SUC                   11     11
000153210908     D  DFF                   12     12
000154210908     D  MBIN                  13     13
000155210908
000156210908      ** Outward parameters
000157210908
000158210908      ** Outward parameters
000159210908     D PARC            Ds            23
000160210908     D  PAMDAC                 1     10
000161210908     D  PAHOAC                11     15
000162210908     D  PAHOPC                16     19
000163210908     D  PAHOMC                20     22
000164210908     D  PAEXCL                23     23
000165210908
000166210908      ** Validation Array for valid Midas A/c Code
000167210908     D VLD             S              1A   DIM(10) PERRCD(10) CTDATA
000168210908
000169210908      ** Index for looping through the Midas A/c Code
000170210908     D WIdx1           S              2S 0
000171210908
000172210908      ** Midas A/c Code
000173210908     D MidAccod        S              1A   DIM(10)
000174210908
000175210908      ** Parameter declarations
000176210908     D P1Parm          Ds
000177210908     D  P1DFMD                 1      1
000178210908
000179210908      **
000180210908     D                 Ds
000181210908     D  ZAMSDA                 1    132
000182210908     D  ZA0001                 1      1
000183210908     D  ZA0002                 1      1
000184210908      /EJECT
000185210908
000186210908      *****************************************************************
000187210908      ** Entry parameters
000188210908      *****************************************************************
000189210908      *
000190210908     C     *Entry        Plist
000191210908     C                   Parm                    P0RTN             7
000192210908     C     P1DFMD        Parm                    WP0001            1
000193210908
000194210908      ** Initialize
000195210908     C                   Exsr      ZZINIT
000196210908
000197210908     C                   Do        *Hival
000198210908      * Initialise & load subfile page
000199210908     C                   Exsr      BAIZSF
000200210908     C                   Movel     'N'           W0RSF             1
000201210908
000202210908      ** Display screen until reload requested
000203210908     C     W0RSF         Doweq     'N'
000204210908      * Display screen
000205210908     C                   Exsr      CAEXFM
000206210908      * Process response
000207210908      * Cancel & exit program
000208210908     C   03              Cas                     ZXEXPG
000209210908      * HOME: Request subfile reload
000210210908     C   05              Cas                     FBRQRL
000211210908      * Display next SFL page
000212210908     C   27              Cas                     BBLDSF
000213210908      * Process screen input
000214210908     C                   Cas                     DAPR##
000215210908     C                   End
000216210908      *
000217210908     C                   Enddo
000218210908     C                   Enddo
000219210908      /EJECT
000220210908
000221210908      *****************************************************************
000222210908      ** Initialise and load subfile page
000223210908      *****************************************************************
000224210908      *
000225210908     CSR   BAIZSF        Begsr
000226210908      * Clear subfile
000227210908     C                   Seton                                        80
000228210908     C                   Write     #SFLCTL
000229210908     C                   Setoff                                       80
000230210908      * Reset no of records in subfile
000231210908     C                   Z-Add     *Zero         ##RRMX            5 081
000232210908      * Initialize subfile control
000233210908     C     KPOS          Klist
000234210908     C                   Kfld                    XXMACOD
000235210908      * Setup key
000236210908     C                   Move      #2MDAC        XXMACOD
000237210908      *
000238210908     C     KPOS          Setll     XXACHOML0
000239210908     C                   Read      XXACHOML0                            8782
000240210908      * Save previous selector values
000241210908     C     *LIKE         Define    #2MDAC        WZMDAC
000242210908     C                   Movel     #2MDAC        WZMDAC
000243210908     C     *LIKE         Define    #2HOAC        WZHOAC
000244210908     C                   Movel     #2HOAC        WZHOAC
000245210908     C     *LIKE         Define    #2HOPC        WZHOPC
000246210908     C                   Movel     #2HOPC        WZHOPC
000247210908     C     *LIKE         Define    #2HOMC        WZHOMC
000248210908     C                   Movel     #2HOMC        WZHOMC
000249210908     C     *LIKE         Define    #2EXCL        WZEXCL
000250210908     C                   Movel     #2EXCL        WZEXCL
000251210908      *
000252210908     C     *LIKE         Define    #2HOAC        #3HOAC
000253210908     C     *LIKE         Define    #2HOPC        #3HOPC
000254210908     C     *LIKE         Define    #2HOMC        #3HOMC
000255210908     C     *LIKE         Define    #2EXCL        #3EXCL
000256210908     C
000257210908      * Load subfile page
000258210908     C                   Z-Add     0             ##RROK            5 0
000259210908     C                   Exsr      BBLDSF
000260210908     CSR   BAEXIT        Endsr
000261210908      /EJECT
000262210908
000263210908      *****************************************************************
000264210908      ** Load subfile page
000265210908      *****************************************************************
000266210908      *
000267210908     CSR   BBLDSF        Begsr
000268210908      ** Re-establish fields in Read-ahead record
000269210908     C   27              Do
000270210908     C  N82              ReadP     XXACHOML0                              90
000271210908     C  N82              Read      XXACHOML0                              90
000272210908     C                   Enddo
000273210908
000274210908      * Setof record error indicators
000275210908     C                   Movel     *ALL'0'       WKIND0            1
000276210908     C                   Movea     WKIND0        *IN(35)
000277210908      * Start at previous highest record in SFL
000278210908     C                   Z-Add     ##RRMX        ##RR              5 0
000279210908      * Reset count of DBF records Read
000280210908     C                   Z-Add     0             ##RRRD            5 0
000281210908      * Set required pages based on *Set Cursor or *subfile Pages
000282210908     C     W0RR0         Ifgt      0
000283210908     C     W0RR0         Div       ##SFPG        ##SPG             3 0
000284210908     C                   Mvr                     ##SLIN            3 0
000285210908
000286210908     C     ##SLIN        Ifgt      0
000287210908     C                   Add       1             ##SPG
000288210908     C                   Endif
000289210908
000290210908     C     W0SPG         Ifgt      ##SPG
000291210908     C                   Z-Add     W0SPG         ##SPG
000292210908     C                   Endif
000293210908
000294210908     C                   Else
000295210908     C                   Z-Add     W0SPG         ##SPG
000296210908     C                   Endif
000297210908
000298210908      * Compute lines required based on pages
000299210908     C     ##SPG         Mult      ##SFPG        ##SFLN            9 0
000300210908     C     ##SFLN        Ifgt      999
000301210908     C                   Z-Add     999           ##SFLN
000302210908     C                   Endif
000303210908
000304210908      ** Load next SFL page until SFL page full, or scan limit reached
000305210908     C     *IN82         Doweq     '0'
000306210908     C     ##RROK        Andlt     ##SFLN
000307210908     C     ##RRRD        Andlt     W0SLM
000308210908      * Check selection fields - if fail, Read next record
000309210908     C     #2MDAC        Ifeq      *Blanks
000310210908     C     #2HOAC        Ifne      *Blank
000311210908     C                   MOVE      XXMHOAC       #3HOAC
000312210908     C     #3HOAC        CabNe     #2HOAC        BB020
000313210908     C                   Endif
000314210908     C                   Endif
000315210908      *
000316210908     C     #2MDAC        Ifeq      *Blanks
000317210908     C     #2HOAC        Oreq      *Blank
000318210908     C     #2HOPC        Ifne      *Blank
000319210908     C                   Eval      #3HOPC = XXMHOPC
000320210908     C     #3HOPC        CabNe     #2HOPC        BB020
000321210908     C                   Endif
000322210908     C                   Endif
000323210908
000324210908     C     #2MDAC        Ifeq      *Blanks
000325210908     C     #2HOAC        Oreq      *Blank
000326210908     C     #2HOPC        Oreq      *Blank
000327210908     C     #2HOMC        Ifne      *Blank
000328210908     C                   Eval      #3HOMC = XXMHOMC
000329210908     C     #3HOMC        CabNe     #2HOMC        BB020
000330210908     C                   Endif
000331210908     C                   Endif
000332210908
000333210908     C     #2MDAC        Ifeq      *Blanks
000334210908     C     #2HOAC        Oreq      *Blank
000335210908     C     #2HOPC        Oreq      *Blank
000336210908     C     #2HOMC        Oreq      *Blank
000337210908     C     #2EXCL        Ifne      *Blank
000338210908     C                   Eval      #3EXCL = XXMEXCL
000339210908     C     #3EXCL        CabNe     #2EXCL        BB020
000340210908     C                   Endif
000341210908     C                   Endif
000342210908
000343210908      ** Load SFL fields
000344210908     C                   Exsr      MBFL#1
000345210908      * Allow for possible *Set Cursor processing
000346210908     C                   Add       1             ##RR
000347210908     C                   Sub       1             ##RR
000348210908     C                   Movel     'Y'           W0RSL             1
000349210908      * Allow for possible *Set Cursor processing
000350210908     C                   Add       1             ##RR
000351210908      * USER: Initialize subfile record from DBF record
000352210908     C                   Sub       1             ##RR
000353210908      * DBF record not selected
000354210908     C     W0RSL         CabNe     'Y'           BB020
000355210908      * Output to subfile
000356210908     C                   Add       1             ##RR
000357210908     C                   Add       1             ##RROK               81
000358210908      * If SFLRCD invalid, note that errors present
000359210908     C   98
000360210908     CANN99              Seton                                        99
000361210908     C                   Write     #SFLRCD
000362210908      * Tag reference
000363210908     C     BB020         TAG
000364210908      * Increment scan check count
000365210908     C                   Add       1             ##RRRD
000366210908     C                   Read      XXACHOML0                              82
000367210908     C                   Enddo
000368210908      * Tag reference
000369210908     C     BB900         TAG
000370210908
000371210908      ** If no DBF records found, display error message
000372210908     C     ##RR          Ifeq      *Zero
000373210908     C     *IN82         Andeq     '1'
000374210908      * Send message '*No data to display'
000375210908     C                   Movel     'Y2U0008'     ZAMSID
000376210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000377210908     C                   Exsr      ZASNMS
000378210908     C                   Endif
000379210908
000380210908      ** Save highest SFL record load can continue at end point
000381210908     C     ##RR          Ifgt      ##RRMX
000382210908      * Calculate top line
000383210908     C     ##RROK        Div       ##SFPG        ##SPG
000384210908     C                   Mvr                     ##SLIN
000385210908     C     ##SLIN        Ifgt      0
000386210908     C     ##RR          Sub       ##SLIN        ##SFRC
000387210908     C                   Else
000388210908     C     ##RR          Sub       ##SFPG        ##SFRC
000389210908     C                   End
000390210908     C                   Add       1             ##SFRC
000391210908     C                   Z-Add     ##RR          ##RRMX
000392210908     C                   End
000393210908
000394210908      ** If scan limit reached, display error message
000395210908     C     ##RRRD        Ifge      W0SLM
000396210908      * Send message '*Scan limit reached'
000397210908     C                   Movel     'Y2U0017'     ZAMSID
000398210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000399210908     C                   Exsr      ZASNMS
000400210908     C                   Else
000401210908     C                   Z-Add     0             ##RROK
000402210908     C                   End
000403210908     CSR   BBEXIT        Endsr
000404210908      /EJECT
000405210908
000406210908      *****************************************************************
000407210908      ** Display screen
000408210908      *****************************************************************
000409210908     CSR   CAEXFM        Begsr
000410210908      *
000411210908     C     W0HLP         Doueq     'N'
000412210908     C                   Movel     'N'           W0HLP             1
000413210908     C                   Move      *ALL'0'       ##OFF            30
000414210908     C                   MoveA     ##OFF         *IN(1)
000415210908      * Update screen time
000416210908     C                   Time                    ##TME
000417210908      * PUTOVR unless conditioned fields change
000418210908     C                   Seton                                        86
000419210908     C     *IN81         Ifne      CAIN81
000420210908     C                   Setoff                                       86
000421210908     C                   Endif
000422210908     C                   Move      *IN81         CAIN81            1
000423210908      *
000424210908     C                   Write     #MSGCTL
000425210908     C                   Write     #CMDTXT1
000426210908     C                   Exfmt     #SFLCTL
000427210908      * Maintain subfile position where possible
000428210908     C     @#SFRC        Ifgt      *Zero
000429210908     C                   Z-Add     @#SFRC        ##SFRC
000430210908     C                   Endif
000431210908      *
000432210908     C                   Enddo
000433210908      * Clear messages from program message queue
000434210908     C                   Call      'Y2CLMSC'
000435210908     C                   Parm      ##PGM         ZAPGMQ           10
000436210908     C                   Parm      '*SAME'       ZAPGRL            5
000437210908      * Reset first message only flag
000438210908     C                   Movel     'Y'           ZAFSMS            1      99
000439210908     C                   Setoff                                         8392
000440210908     CSR   CAEXIT        Endsr
000441210908      /EJECT
000442210908
000443210908      *****************************************************************
000444210908      ** Process screen input
000445210908      *****************************************************************
000446210908     CSR   DAPR##        Begsr
000447210908
000448210908      ** Confirm/update is not deferred
000449210908     C                   Movel     'N'           W0DCF             1
000450210908      * Change of position specified
000451210908     C     WZMDAC        CasNe     #2MDAC        FBRQRL
000452210908     C     WZHOAC        CasNe     #2HOAC        FBRQRL
000453210908     C     WZHOPC        CasNe     #2HOPC        FBRQRL
000454210908     C     WZHOMC        CasNe     #2HOMC        FBRQRL
000455210908     C     WZEXCL        CasNe     #2EXCL        FBRQRL
000456210908     C                   End
000457210908
000458210908      ** USER: Process subfile control (Pre-confirm)
000459210908      ** Reload subfile requested
000460210908     C     W0RSF         CabEq     'Y'           DAEXIT
000461210908     C     *IN81         Ifeq      '1'
000462210908      * Process subfile records
000463210908     C                   Exsr      DBPRSF
000464210908     C                   Endif
000465210908
000466210908      ** USER: Final processing (Pre-confirm)
000467210908      ** If error, quit processing
000468210908     C     *IN99         CabEq     '1'           DAEXIT
000469210908      * Defer confirm/update requested
000470210908     C     W0DCF         CabEq     'Y'           DAEXIT
000471210908
000472210908      ** USER: Process command keys
000473210908      ** CASE: PAR.Display file mode is Maintenance mode
000474210908     C     P1DFMD        Ifeq      'M'
000475210908      * CASE: CTL.*CMD key is *Add
000476210908     C     *IN09         Ifeq      '1'
000477210908      * Initialize calling parameters
000478210908     C                   Clear                   PARC
000479210908     C                   Movel     #2MDAC        PAMDAC
000480210908      * Call A/c Code HO Details Mapping Maintenance screen
000481210908     C                   Call      'XX005002'                           90
000482210908     C                   Parm      *Blank        W0RTN             7
000483210908     C                   Parm                    PARC
000484210908     C                   Parm      'I'           WQ0001            1
000485210908      *
000486210908     C     *IN90         Ifeq      '1'
000487210908      * Call to program ended in error
000488210908     C                   Movel     'Y2U0032'     W0RTN
000489210908     C                   Movel     *Blanks       W0CLPG           10
000490210908     C                   Movel     'XX005002'    W0CLPG
000491210908      * Send message '*Error occured on Call...'
000492210908     C                   Movel     'Y2U0032'     ZAMSID
000493210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000494210908     C                   Movel     W0CLPG        ZAMSDA
000495210908     C                   Exsr      ZASNMS
000496210908     C                   Endif
000497210908
000498210908      ** Error detected?
000499210908     C     W0RTN         Ifne      *Blank
000500210908     C                   Seton                                        9931
000501210908     C                   Endif
000502210908     C                   Movel     'Y'           W0RSF
000503210908     C                   Endif
000504210908     C                   Else
000505210908
000506210908      ** CASE: *Otherwise
000507210908      ** CASE: CTL.*CMD key is *Go to 'Add' mode
000508210908     C     *IN09         Ifeq      '1'
000509210908      * Send message 'Function key not allowed'
000510210908     C                   Movel     'USR0533'     ZAMSID
000511210908     C                   Exsr      ZASNMS
000512210908     C                   Seton                                        99
000513210908      *
000514210908     C                   Endif
000515210908     C                   Endif
000516210908      *
000517210908     CSR   DAEXIT        Endsr
000518210908      /EJECT
000519210908
000520210908      *****************************************************************
000521210908      ** Process modified subfile record
000522210908      *****************************************************************
000523210908     CSR   DBPRSF        Begsr
000524210908      *
000525210908     C                   ReadC     #SFLRCD                                92
000526210908     C     *IN92         Doweq     '0'
000527210908      * Process subfile record
000528210908     C                   Exsr      DCPRSR
000529210908     C                   Update    #SFLRCD
000530210908     C                   ReadC     #SFLRCD                                92
000531210908      *
000532210908     C                   Enddo
000533210908     CSR   DBEXIT        Endsr
000534210908      /EJECT
000535210908
000536210908      *****************************************************************
000537210908      ** Process subfile record
000538210908      *****************************************************************
000539210908     CSR   DCPRSR        Begsr
000540210908
000541210908      ** Setof error indicators and SFLNXTCHG
000542210908     C                   MoveA     WKIND0        *IN(35)
000543210908     C                   Setoff                                       98
000544210908
000545210908      ** USER: Process subfile record (Pre-confirm)
000546210908      ** Enquire Entered. CASE: RCD.*SFLSEL is *Enquire
000547210908     C     #1SEL         Ifeq      'E'
000548210908      * Initialize calling parameters
000549210908     C                   Clear                   PARC
000550210908     C                   Movel     #1MDAC        PAMDAC
000551210908     C                   Movel     #1HOAC        PAHOAC
000552210908     C                   Movel     #1HOPC        PAHOPC
000553210908     C                   Movel     #1HOMC        PAHOMC
000554210908     C                   Movel     #1EXCL        PAEXCL
000555210908      * Call CNAPS Codeword Maintenance
000556210908     C                   Call      'XX005002'                           90
000557210908     C                   Parm      *Blank        W0RTN             7
000558210908     C                   Parm                    PARC
000559210908     C                   Parm      'E'           WQ0002            1
000560210908      *
000561210908     C     *IN90         Ifeq      '1'
000562210908      * Call to program ended in error
000563210908     C                   Movel     'Y2U0032'     W0RTN
000564210908     C                   Movel     *Blanks       W0CLPG           10
000565210908     C                   Movel     'XX005002'    W0CLPG
000566210908      * Send message '*Error occured on Call...'
000567210908     C                   Movel     'Y2U0032'     ZAMSID
000568210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000569210908     C                   Movel     W0CLPG        ZAMSDA
000570210908     C                   Exsr      ZASNMS
000571210908     C                   Endif
000572210908
000573210908      ** Error detected?
000574210908     C     W0RTN         Ifne      *Blank
000575210908     C                   Seton                                        98
000576210908     C                   Endif
000577210908     C                   Movel     'Y'           W0RSF
000578210908     C                   Endif
000579210908
000580210908      ** Amend or Delete Entered
000581210908      ** CASE: PAR.Display file mode is Maintenance mode
000582210908     C     P1DFMD        Ifeq      'M'
000583210908      * CASE: RCD.*SFLSEL is *Amend
000584210908     C     #1SEL         Ifeq      'A'
000585210908      * Initialize calling parameters
000586210908     C                   Clear                   PARC
000587210908     C                   Movel     #1MDAC        PAMDAC
000588210908     C                   Movel     #1HOAC        PAHOAC
000589210908     C                   Movel     #1HOPC        PAHOPC
000590210908     C                   Movel     #1HOMC        PAHOMC
000591210908     C                   Movel     #1EXCL        PAEXCL
000592210908      * Call CNAPS Codeword Maintenance
000593210908     C                   Call      'XX005002'                           90
000594210908     C                   Parm      *Blank        W0RTN             7
000595210908     C                   Parm                    PARC
000596210908     C                   Parm      'A'           WQ0003            1
000597210908      *
000598210908     C     *IN90         Ifeq      '1'
000599210908      * Call to program ended in error
000600210908     C                   Movel     'Y2U0032'     W0RTN
000601210908     C                   Movel     *Blanks       W0CLPG           10
000602210908     C                   Movel     'XX005002'    W0CLPG
000603210908      * Send message '*Error occured on Call...'
000604210908     C                   Movel     'Y2U0032'     ZAMSID
000605210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000606210908     C                   Movel     W0CLPG        ZAMSDA
000607210908     C                   Exsr      ZASNMS
000608210908     C                   Endif
000609210908
000610210908      ** Error detected?
000611210908     C     W0RTN         Ifne      *Blank
000612210908     C                   Seton                                        98
000613210908     C                   Endif
000614210908     C                   Movel     'Y'           W0RSF
000615210908     C                   Endif
000616210908
000617210908      ** Delete Entered
000618210908      ** CASE: RCD.*SFLSEL is *Delete
000619210908     C     #1SEL         Ifeq      'D'
000620210908      * Initialize calling parameters
000621210908     C                   Clear                   PARC
000622210908     C                   Movel     #1MDAC        PAMDAC
000623210908     C                   Movel     #1HOAC        PAHOAC
000624210908     C                   Movel     #1HOPC        PAHOPC
000625210908     C                   Movel     #1HOMC        PAHOMC
000626210908     C                   Movel     #1EXCL        PAEXCL
000627210908      * Call CNAPS Codeword Maintenance
000628210908     C                   Call      'XX005002'                           90
000629210908     C                   Parm      *Blank        W0RTN             7
000630210908     C                   Parm                    PARC
000631210908     C                   Parm      'D'           WQ0004            1
000632210908      *
000633210908     C     *IN90         Ifeq      '1'
000634210908      * Call to program ended in error
000635210908     C                   Movel     'Y2U0032'     W0RTN
000636210908     C                   Movel     *Blanks       W0CLPG           10
000637210908     C                   Movel     'XX005002'    W0CLPG
000638210908      * Send message '*Error occured on Call...'
000639210908     C                   Movel     'Y2U0032'     ZAMSID
000640210908     C                   Movel     'Y2USRMSG'    ZAMSGF
000641210908     C                   Movel     W0CLPG        ZAMSDA
000642210908     C                   Exsr      ZASNMS
000643210908     C                   Endif
000644210908
000645210908      ** Error detected?
000646210908     C     W0RTN         Ifne      *Blank
000647210908     C                   Seton                                        98
000648210908     C                   Endif
000649210908     C                   Movel     'Y'           W0RSF
000650210908     C                   Endif
000651210908     C                   Else
000652210908
000653210908      ** CASE: *Otherwise
000654210908      ** Amend entered in Enquiry mode
000655210908      ** CASE: RCD.*SFLSEL is *Amend
000656210908     C     #1SEL         Ifeq      'A'
000657210908      * Setup message data for message
000658210908     C                   Movel     #1SEL         ZA0001
000659210908      * Send message 'value for field not valid'
000660210908     C                   Movel     'USR0553'     ZAMSID
000661210908     C                   Exsr      ZASNMS
000662210908     C                   Seton                                        9835
000663210908      *
000664210908     C                   Goto      DCEXIT
000665210908     C                   Endif
000666210908
000667210908      ** Delete entered in Enquiry mode
000668210908      ** CASE: RCD.*SFLSEL is *Delete
000669210908     C     #1SEL         Ifeq      'D'
000670210908      * Setup message data for message
000671210908     C                   Movel     #1SEL         ZA0002
000672210908      * Send message 'value for field not valid'
000673210908     C                   Movel     'USR0553'     ZAMSID
000674210908     C                   Exsr      ZASNMS
000675210908     C                   Seton                                        9835
000676210908      *
000677210908     C                   Goto      DCEXIT
000678210908     C                   Endif
000679210908     C                   Endif
000680210908
000681210908      ** F3 taken from EDTRCD program
000682210908      ** CASE: PGM.*Return code is *User QUIT requested
000683210908     C     W0RTN         Ifeq      'Y2U9999'
000684210908     C                   Movel     W0RTN         P0RTN
000685210908     C                   Exsr      ZYEXPG
000686210908     C                   Endif
000687210908      *
000688210908     C     *IN98         Ifeq      '1'
000689210908      * SFLRCD invalid
000690210908     C  N99              Z-Add     ##RR          ##SFRC               99
000691210908     C                   Seton                                        84
000692210908     C                   Else
000693210908      * SFLRCD valid.
000694210908     C                   Setoff                                       84
000695210908     C                   Movel     *Blank        #1SEL
000696210908     C                   Endif
000697210908      *
000698210908     CSR   DCEXIT        Endsr
000699210908      /EJECT
000700210908
000701210908      *****************************************************************
000702210908      ** Request subfile reload
000703210908      *****************************************************************
000704210908     CSR   FBRQRL        Begsr
000705210908      *
000706210908     C                   Movel     'Y'           W0RSF
000707210908     C     *IN05         Ifeq      *On
000708210908     C                   Move      *Blanks       #2MDAC
000709210908     C                   Setoff                                       70
000710210908     C                   Move      *Blanks       #2HOAC
000711210908     C                   Move      *Blanks       #2HOPC
000712210908     C                   Move      *Blanks       #2HOMC
000713210908     C                   Move      *Blanks       #2EXCL
000714210908     C                   Endif
000715210908      *
000716210908      * Midas A/c Code should be 10 long
000717210908     C                   Setoff                                       70
000718210908     C                   If        #2MDAC <> *Blanks
000719210908     C                   MoveA     #2MDAC        MidAccod
000720210908     C                   For       WIdx1 = 1 TO 10
000721210908     C                   If        %LookUp(MidAccod(WIdx1):VLD) = 0
000722210908     C                   Movel     'DRI0511'     ZAMSID
000723210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000724210908     C                   Seton                                        70
000725210908     C                   Exsr      ZASNMS
000726210908     C                   Movel     'N'           W0RSF
000727210908     C                   Goto      FBEXIT
000728210908     C                   Endif
000729210908     C                   EndFor
000730210908     C                   Endif
000731210908      *
000732210908     CSR   FBEXIT        Endsr
000733210908      /EJECT
000734210908
000735210908      *****************************************************************
000736210908      ** Move XXACHOML0 fields to subfile
000737210908      *****************************************************************
000738210908     CSR   MBFL#1        Begsr
000739210908      *
000740210908     C                   Movel     *Blank        #1SEL
000741210908     C                   Move      XXMACOD       #1MDAC
000742210908     C                   Movel     XXMHOAC       #1HOAC
000743210908     C                   Movel     XXMHOPC       #1HOPC
000744210908     C                   Movel     XXMHOMC       #1HOMC
000745210908     C                   Movel     XXMEXCL       #1EXCL
000746210908      *
000747210908     CSR   MBEXIT        Endsr
000748210908      /EJECT
000749210908
000750210908      *****************************************************************
000751210908      ** Initialise subfile control
000752210908      *****************************************************************
000753210908     CSR   MEIZ#2        Begsr
000754210908      *
000755210908     C                   Movel     *Blank        #2MDAC
000756210908     C                   Movel     *Blank        #2HOAC
000757210908     C                   Movel     *Blank        #2HOPC
000758210908     C                   Movel     *Blank        #2HOMC
000759210908     C                   Movel     *Blank        #2EXCL
000760210908      *
000761210908     CSR   MEEXIT        Endsr
000762210908      /EJECT
000763210908
000764210908      *****************************************************************
000765210908      ** Set up Display file Header Title
000766210908      *****************************************************************
000767210908     CSR   UASUBR        Begsr
000768210908
000769210908      * CASE: PAR.Display file mode is Enquiry mode
000770210908     C     P1DFMD        Ifeq      'E'
000771210908      * Setup message data for message
000772210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000773210908     C                   Call      'Y2RVMGC'                            90
000774210908     C                   Parm      *Blank        W0RTN             7
000775210908     C                   Parm      'DRI0512'     ZAMSID            7
000776210908     C                   Parm                    ZAMSGF           10
000777210908     C                   Parm                    ZAMSDA          132
000778210908     C     WUDFTL        Parm                    W0MTX           132
000779210908     C                   Movel     *Blank        ZAMSDA
000780210908     C                   Movel     *Blank        ZAMSGF
000781210908     C                   Else
000782210908
000783210908      * CASE: PAR.Display file mode is Maintenance mode
000784210908     C     P1DFMD        Ifeq      'M'
000785210908      * Setup message data for message
000786210908     C                   Movel     'XXUSRMSG'    ZAMSGF
000787210908     C                   Call      'Y2RVMGC'                            90
000788210908     C                   Parm      *Blank        W0RTN             7
000789210908     C                   Parm      'DRI0513'     ZAMSID            7
000790210908     C                   Parm                    ZAMSGF           10
000791210908     C                   Parm                    ZAMSDA          132
000792210908     C     WUDFTL        Parm                    W0MTX           132
000793210908     C                   Movel     *Blank        ZAMSDA
000794210908     C                   Movel     *Blank        ZAMSGF
000795210908     C                   Endif
000796210908     C                   Endif
000797210908      * Move to Header Title - Standard Functions  *
000798210908     C                   Movel     WUDFTL        ##URPT
000799210908      *
000800210908     CSR   UAEXIT        Endsr
000801210908      /EJECT
000802210908
000803210908      *****************************************************************
000804210908      ** Set up Display file Footers
000805210908      *****************************************************************
000806210908     CSR   UBSUBR        Begsr
000807210908
000808210908      * CASE: PAR.Display file mode is Enquiry mode
000809210908     C     P1DFMD        Ifeq      'E'
000810210908      * Setup message data for message
000811210908     C                   Movel     ZADFMF        ZAMSGF
000812210908     C                   Call      'Y2RVMGC'                            90
000813210908     C                   Parm      *Blank        W0RTN             7
000814210908     C                   Parm      'USR2911'     ZAMSID            7
000815210908     C                   Parm                    ZAMSGF           10
000816210908     C                   Parm                    ZAMSDA          132
000817210908     C     WUSFT1        Parm                    W0MTX           132
000818210908     C                   Movel     *Blank        ZAMSDA
000819210908     C                   Movel     *Blank        ZAMSGF
000820210908      * Setup message data for message
000821210908     C                   Movel     ZADFMF        ZAMSGF
000822210908     C                   Call      'Y2RVMGC'                            90
000823210908     C                   Parm      *Blank        W0RTN             7
000824210908     C                   Parm      'USR2912'     ZAMSID            7
000825210908     C                   Parm                    ZAMSGF           10
000826210908     C                   Parm                    ZAMSDA          132
000827210908     C     WUSFT2        Parm                    W0MTX           132
000828210908     C                   Movel     *Blank        ZAMSDA
000829210908     C                   Movel     *Blank        ZAMSGF
000830210908     C                   Else
000831210908
000832210908      * CASE: PAR.Display file mode is Maintenance mode
000833210908     C     P1DFMD        Ifeq      'M'
000834210908      * Setup message data for message
000835210908     C                   Movel     ZADFMF        ZAMSGF
000836210908     C                   Call      'Y2RVMGC'                            90
000837210908     C                   Parm      *Blank        W0RTN             7
000838210908     C                   Parm      'USR2913'     ZAMSID            7
000839210908     C                   Parm                    ZAMSGF           10
000840210908     C                   Parm                    ZAMSDA          132
000841210908     C     WUSFT1        Parm                    W0MTX           132
000842210908     C                   Movel     *Blank        ZAMSDA
000843210908     C                   Movel     *Blank        ZAMSGF
000844210908      * Setup message data for message
000845210908      * Retrieve message STD FTR:DSPFIL Maint/2
000846210908     C                   Movel     ZADFMF        ZAMSGF
000847210908     C                   Call      'Y2RVMGC'                            90
000848210908     C                   Parm      *Blank        W0RTN             7
000849210908     C                   Parm      'USR2914'     ZAMSID            7
000850210908     C                   Parm                    ZAMSGF           10
000851210908     C                   Parm                    ZAMSDA          132
000852210908     C     WUSFT2        Parm                    W0MTX           132
000853210908     C                   Movel     *Blank        ZAMSDA
000854210908     C                   Movel     *Blank        ZAMSGF
000855210908     C                   Endif
000856210908     C                   Endif
000857210908      * Move to Double Footer - Standard Functions  *
000858210908     C                   Movel     WUSFT1        ##CTX1
000859210908     C                   Movel     WUSFT2        ##CTX2
000860210908      *
000861210908     CSR   UBEXIT        Endsr
000862210908      /EJECT
000863210908
000864210908      *****************************************************************
000865210908      ** Send message to program's message queue
000866210908      *****************************************************************
000867210908     CSR   ZASNMS        Begsr
000868210908      *
000869210908     C     ZAPGMQ        Ifeq      *Blank
000870210908     C                   Movel     ##PGM         ZAPGMQ
000871210908     C                   Endif
000872210908      * If no message file specified, use default
000873210908     C     ZAMSGF        Ifeq      *Blank
000874210908     C                   Movel     ZADFMF        ZAMSGF
000875210908     C                   Endif
000876210908      *
000877210908     C                   Call      'Y2SNMGC'
000878210908     C                   Parm                    ZAPGMQ           10
000879210908     C                   Parm                    ZAPGRL            5
000880210908     C                   Parm                    ZAMSID            7
000881210908     C                   Parm                    ZAMSGF           10
000882210908     C                   Parm                    ZAMSDA          132
000883210908     C                   Parm                    ZAMSTP            7
000884210908      * Clear all fields for default mechanism next time
000885210908     C                   Movel     *Blank        ZAPGMQ
000886210908     C                   Movel     *Blank        ZAPGRL
000887210908     C                   Movel     *Blank        ZAMSID
000888210908     C                   Movel     *Blank        ZAMSGF
000889210908     C                   Movel     *Blank        ZAMSDA
000890210908     C                   Movel     *Blank        ZAMSTP
000891210908      *
000892210908     CSR   ZAEXIT        Endsr
000893210908      /EJECT
000894210908
000895210908      *****************************************************************
000896210908      ** Cancel & exit program
000897210908      *****************************************************************
000898210908     CSR   ZXEXPG        Begsr
000899210908
000900210908      ** USER: Exit program processing
000901210908     C                   Exsr      ZYEXPG
000902210908      *
000903210908     CSR   ZXEXIT        Endsr
000904210908      /EJECT
000905210908
000906210908      *****************************************************************
000907210908      ** Exit program: Direct
000908210908      *****************************************************************
000909210908     CSR   ZYEXPG        Begsr
000910210908
000911210908      ** Exit program
000912210908     C                   RETURN
000913210908      *
000914210908     CSR   ZYEXIT        Endsr
000915210908      /EJECT
000916210908
000917210908      *****************************************************************
000918210908      ** Initialisation
000919210908      *****************************************************************
000920210908     CSR   ZZINIT        Begsr
000921210908      *
000922210908     C                   Move      *Blank        P0RTN
000923210908     C                   Move      *Blank        W0RTN             7
000924210908     C                   Movel     *Blank        W0RSL             1
000925210908     C                   Movel     *Blank        W0RSF             1
000926210908      * Initialise indicators for re-entry
000927210908     C                   Move      '0'           *IN
000928210908      * Update screen time
000929210908     C                   Time                    ##TME             6 0
000930210908      * Obtain default message file
000931210908     C     *Dtaara       Define    Y2MGFLA       ZADFMF           10
000932210908     C                   In        ZADFMF
000933210908      * Define work field Midas Run Date
000934210908     C                   Movel     *Blank        WUMRDT            7
000935210908      * Define work field Run day number
000936210908     C                   Z-Add     *Zero         WURDNB            5 0
000937210908      * Define work field Set Up Complete
000938210908     C                   Movel     *Blank        WUSUC             1
000939210908      * Define work field Date format flag
000940210908     C                   Movel     *Blank        WUDFF             1
000941210908      * Define work field Multi-branching Indicator
000942210908     C                   Movel     *Blank        WUMBIN            1
000943210908      * Define work field Display File Title
000944210908     C                   Movel     *Blank        WUDFTL           53
000945210908      * Define work field STD FTR 1
000946210908     C                   Movel     *Blank        WUSFT1           78
000947210908      * Define work field STD FTR 2
000948210908     C                   Movel     *Blank        WUSFT2           78
000949210908      * Open files first time only
000950210908     C     W0OPN         Ifeq      *Blank
000951210908     C                   Open      XX005001DF
000952210908     C                   Open      XXACHOML0
000953210908      * Signal that files are now Open
000954210908     C                   Move      'Y'           W0OPN             1
000955210908     C                   Endif
000956210908      *
000957210908     C                   Movel     'N'           W0PMT             1
000958210908     C                   Z-Add     13            ##SFPG            3 0
000959210908     C                   Z-Add     1             ##SFRC
000960210908      * Maximum record number
000961210908     C                   Z-Add     *Zero         ##RRMX
000962210908      * Scan limit
000963210908     C                   Z-Add     500           W0SLM             5 0
000964210908      * subfile pages
000965210908     C                   Z-Add     1             W0SPG             3 0
000966210908      * Processed subfile record
000967210908     C                   Z-Add     0             W0RR0             4 0
000968210908
000969210908      ** USER: Initialize program
000970210908      ** Copyright and rundate setup
000971210908     C     *Dtaara       Define                  RUNDAT
000972210908     C                   In        RUNDAT
000973210908     C                   Move      MRDT          ##MRDT            7
000974210908     C                   Move      MRDT          WUMRDT
000975210908     C                   Move      RDNB          WURDNB
000976210908     C                   Move      SUC           WUSUC
000977210908     C                   Move      DFF           WUDFF
000978210908     C                   Move      MBIN          WUMBIN
000979210908      * Set up Display file Header Title
000980210908     C                   Exsr      UASUBR
000981210908      * Set up Display file Footers
000982210908     C                   Exsr      UBSUBR
000983210908     C                   Z-Add     99999         W0SLM
000984210908      * Initialise subfile control
000985210908     C                   Exsr      MEIZ#2
000986210908      *
000987210908     CSR   ZZEXIT        Endsr
000988210908      /EJECT
000989210908
000990210908      *****************************************************************
000991210908      **
000992210908      ** *PSSR  - Program exception error routine
000993210908      **          Called automatiCally if a program error occurs,
000994210908      **          or directly by the program code using Exsr.
000995210908      **          This Subroutine DUMPs the program just once.
000996210908      **
000997210908      *****************************************************************
000998210908     CSR   *PSSR         Begsr
000999210908      *  Standard Midas PSSR processing.
001000210908     C     @RUN          Ifeq      *Blank
001001210908     C                   Move      'Y'           @RUN              1
001002210908     C                   Move      'PSSR   '     P0RTN
001003210908     C                   DUMP
001004210908      *  Route job back into Midas.
001005210908     C                   Seton                                        LR
001006210908     C                   Call      'DBERRCTL'
001007210908     C                   Endif
001008210908      *
001009210908     CSR                 Endsr
001010210908      *****************************************************************
001011210908** VLD
0010122109080123456789
