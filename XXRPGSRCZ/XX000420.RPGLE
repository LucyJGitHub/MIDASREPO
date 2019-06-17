     H DEBUG
     H*COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')                         JMI112
     H COPYRIGHT('(c) Finastra International System 2018')                                    JMI112
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Past Due processing extract')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      ***LE000080*-*Midas*Past*Due*processing*extract******************                       JMI112
      *  XX000420 - Midas Past Due processing extract                 *                       JMI112
      *                                                               *
      *  Function:  This module will interface past due events to     *
      *             OPICS.  It will check if a loan has gone past due *
      *             and if so, loan details should be output to OPICS *
      *             reversing the existing loan and then inserting a  *
      *             new loan.  It is also required to output history  *
      *             events in order to allow the OPICS loan schedule  *
      *             to be updated.                                    *
      *                                                               *
      *  Component of: LEC0605                                        *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************                       JMI112
      *  (c) Finastra International Limited 2018                      *                       JMI112
      *                                                               *
      *  Last Amend No. JMI112             Date 24May18               *
      *  Prev Amend No. CGL086  *CREATE    Date 31Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI112 - Midas-Opics Data Transfer Amendments. Upgrade to    *
      *           FBM 2.1                                             *
      *  CGL086 - Midas-Opics Data Transfer Amendments                *
      *                                                               *
      *****************************************************************
      /EJECT
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR) PREFIX(DK_)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR) PREFIX(CL_)
     F                                     RENAME(CLOANCLF:CLOANCL)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F*LEHISTL8**IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     F*LEHISTL9**IF   E           K DISK    INFSR(*PSSR)                                      JMI112
     FXXHISTL1  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
     FXXHISTL2  IF   E           K DISK    INFSR(*PSSR)                                       JMI112
      /SPACE 3

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
     D  RDNO                   8     10P 0

     D CLOANCLDS     E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
     D CL_FIL1                 2     24
     D CL_FIL2                34     49
     D CL_FIL3                57     57
     D CL_FIL4                64     65
     D CL_FIL5                82     83
     D CL_FIL6                90     91
     D CL_FIL7               102    117
     D CL_FIL8               139    196
     D CL_FIL9               203    208
     D CL_FIL10              215    216
     D CL_FIL11              252    253
     D CL_FIL12              265    298
     D CL_FIL13              382    390
     D CL_FIL14              397    397
     D CL_FIL15              401    401
     D CL_FIL16              412    448
     D CL_FIL17              458   1092
     D CL_FIL18             1099   1103
     D CL_FIL19             1166   1170
     D CL_FIL20             1188   1192
     D CL_FIL21             1200   1278
     D CL_FIL22             1285   1290
     D CL_FIL23             1300   1303
     D CL_FIL24             1310   1320
     D CL_FIL25             1349   1350
     D CL_FIL26             1358   1358
     D CL_FIL27             1481   1484
     D CL_FIL28             1492   1633
     D CL_FIL29             1758   1773

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *****************************************************************

      ** Breakdown of Data to be output to MQ Series Queue
     D                 DS
     D**PASDUEDTAQ             1   1773                                                       JMI112
     D  PASDUEDTAQ             1   2025                                                       JMI112
     D PDACTN                  1      1
     D PDFIL1                  2     24
     D PDDDAT                 25     29S 0
     D PDVDAT                 30     34S 0
     D PDMDAT                 35     39S 0
     D PDFIL2                 40     55
     D PDCPAM                 56     68S 0
     D PDFIL3                 69     69
     D PDINTR                 70     80S 7
     D PDFIL4                 81     82
     D PDBRTE                 83     93S 7
     D PDRTSP                 94    104S 7
     D PDMARG                105    111S 5
     D PDFIL5                112    113
     D PDWTRT                114    124S 7
     D PDFIL6                125    126
     D PDRAMT                127    139S 0
     D PDNRPD                140    144S 0
     D PDFIL7                145    160
     D PDPSAM                161    173S 0
     D PDBCXR                174    186S 8
     D PDFCXR                187    199S 8
     D PDFIL8                200    257
     D PDRLDT                258    262S 0
     D PDNROD                263    267S 0
     D PDFIL9                268    273
     D PDNRTS                274    284S 7
     D PDFIL10               285    286
     D PDAWTP                287    299S 0
     D PDWTRD                300    312S 0
     D PDWTWD                313    325S 0
     D PDIWOD                326    338S 0
     D PDPWOD                339    351S 0
     D PDFIL11               352    353
     D PDPDIN                354    366S 0
     D PDLSWC                367    369S 0
     D PDLSWS                370    372S 0
     D PDFIL12               373    406
     D PDTOTI                407    419S 0
     D PDNIDT                420    424S 0
     D PDIBDT                425    429S 0
     D PDSLID                430    434S 0
     D PDAIPD                435    447S 0
     D PDDLRC                448    452S 0
     D PDIACD                453    457S 0
     D PDAITC                458    470S 0
     D PDTFEP                471    483S 0
     D PDAIAP                484    496S 0
     D PDIPRD                497    509S 0
     D PDIPRM                510    522S 0
     D PDICTD                523    535S 0
     D PDAIMN                536    548S 0
     D PDRBDT                549    553S 0
     D PDNOPS                554    556S 0
     D PDFIL13               557    565
     D PDORED                566    570S 0
     D PDLCD                 571    575S 0
     D PDFIL14               576    576
     D PDTNLU                577    581S 0
     D PDFIL15               582    582
     D PDORMD                583    587S 0
     D PDORTI                588    600S 0
     D PDFIL16               601    637
     D PDOMDT                638    642S 0
     D PDNIPD                643    647S 0
     D PDNMDT                648    652S 0
     D PDFIL17               653   1287
     D PDFSRP               1288   1298S 7
     D PDFIL18              1299   1303
     D PDTCOF               1304   1316S 0
     D PDACPD               1317   1329S 0
     D PDACDA               1330   1342S 0
     D PDACAJ               1343   1355S 0
     D PDACAP               1356   1368S 0
     D PDCOFD               1369   1381S 0
     D PDCOFM               1382   1394S 0
     D PDCFCD               1395   1407S 0
     D PDNFRS               1408   1418S 7
     D PDFIL19              1419   1423
     D PDPDCF               1424   1436S 0
     D PDFCTD               1437   1441S 0
     D PDFWOD               1442   1454S 0
     D PDFIL20              1455   1459
     D PDFCRA               1460   1472S 0
     D PDFIL21              1473   1551
     D PDLRLD               1552   1556S 0
     D PDLMCD               1557   1561S 0
     D PDFIL22              1562   1567
     D PDOINR               1568   1578S 7
     D PDOIDT               1579   1583S 0
     D PDFIL23              1584   1587
     D PDRFRT               1588   1598S 7
     D PDFIL24              1599   1609
     D PDURPL               1610   1622S 0
     D PDPLAM               1623   1635S 0
     D PDPLDT               1636   1648S 0
     D PDYUPL               1649   1661S 0
     D PDFIL25              1662   1663
     D PDCHGA               1664   1676S 0
     D PDFIL26              1677   1677
     D PDFLTI               1678   1690S 0
     D PDFRPD               1691   1695S 0
     D PDACCH               1696   1708S 0
     D PDEFUP               1709   1721S 0
     D PDECUP               1722   1734S 0
     D PDAIPN               1735   1747S 0
     D PDAITN               1748   1760S 0
     D PDAIAN               1761   1773S 0
     D PDIPRN               1774   1786S 0
     D PDAINN               1787   1799S 0
     D PDTOTN               1800   1812S 0
     D PDICTN               1813   1825S 0
     D PDIWON               1826   1838S 0
     D PDIPNM               1839   1851S 0
     D PDPDNN               1852   1864S 0
     D PDSPAM               1865   1877S 0
     D PDFPAM               1878   1890S 0
     D PDREXR               1891   1903S 8
     D PDFIL27              1904   1907
     D PDPEXR               1908   1920S 8
     D PDFIL28              1921   2062
     D PDTFDP               2063   2077S 0
     D PDFDPA               2078   2092S 0
     D PDTFAM               2093   2107S 0
     D PDTFAC               2108   2122S 0
     D PDTFOF               2123   2137S 0
     D PDAFDP               2138   2152S 0
     D PDCFDP               2153   2167S 0
     D PDAMDS               2168   2182S 0
     D PDAMAD               2183   2197S 0
     D PDANAD               2198   2212S 0
     D PDDSAM               2213   2227S 0
     D PDAMCO               2228   2242S 0
     D PDYMCO               2243   2257S 0
     D PDYAIN               2258   2272S 0
     D PDBASR               2273   2283S 7
     D PDNBSR               2284   2294S 7
     D PDFIL29              2295   2310
      *
     D                 DS
     D  PSDHISDTAQ             1     60
     D HIBR                    1      3
     D*HILNRF****              4      9S 0                                                    JMI112
     D HILNRF                  4      9                                                       JMI112
     D HIHISDTE               10     14
     D HIRATE                 15     27S 0
     D HIMVAMT                28     42
     D HIINTAMT               43     57S 0
     D HICCYDP                58     58S 0
     D HIPTYP                 59     60

     D                 DS
     D  Old_Details            1     60
     D O_HIBR                  1      3
     D*O_HILNRF**              4      9S 0                                                    JMI112
     D O_HILNRF                4      9                                                       JMI112
     D O_HIHISDTE             10     14
     D O_HIRATE               15     27S 0
     D O_HIMVAMT              28     42
     D O_HIINTAMT             43     57S 0
     D O_HICCYDP              58     58S 0
     D O_HIPTYP               59     60

     D DataQueueLib    S             10A   INZ('*LIBL     ')

      /SPACE 3
      *****************************************************************
      * Main Subroutine
      *****************************************************************
      *
      * Past Due loans Procesing
      *
      * Read LOAMSDK
     C                   READ      LELOAML3                               80
      *
      * Do until end of file
     C     *IN80         DOWEQ     *OFF
      *
     C                   IF        DK_ORED = RDNO and DK_AMTP = 'PD'
     C                   CLEAR                   CLOANCLDS
     C                   CLEAR                   PASDUEDTAQ
     C                   EXSR      LOANDT
     C                   EXSR      RTVPSDHST
     C                   ENDIF
      *
     C                   READ      LELOAML3                               80
     C                   ENDDO
      *
      ** Terminate program
     C                   SETON                                            LR
     C                   RETURN
      *
      ********************************************************************
      *  LOANDT - Retrieve Loan Details from CLOANCL
      ********************************************************************
      *
     C     LOANDT        BEGSR
      *
     C     DK_LNRF       CHAIN     CLOANCL                            81
      *
      * If record found then move the value of Start Last Interest Date to
      * Value Date
     C     *IN81         IFEQ      *OFF
     C                   Z-ADD     CL_SLID       CL_VDAT
      *
      * Retrieve interest rate and principal amount as at start last interest da
      * from history details
      *
     C                   MOVE      CL_BRCA       KBRCA             3
     C***********        Z-ADD     CL_CNUM       KCNUM             6 0                        JMI112
     C                   MOVE      CL_CNUM       KCNUM             6                          JMI112
     C***********        Z-ADD     CL_LNRF       KLNRF             6 0                        JMI112
     C                   MOVE      CL_LNRF       KLNRF             6                          JMI112
     C                   Z-ADD     CL_SLID       KVDAT             5 0
     C                   Z-ADD     99            KPRSQ             2 0
     C                   MOVE      'IH'          KAMTP             2
      *
     C*****KHISTN2       CHAIN     LEHISTL8                           71                      JMI112
     C     KHISTN2       CHAIN     XXHISTL1                           71                      JMI112
      *
     C     *IN71         IFEQ      *OFF
     C                   Z-ADD     PRAM          CL_CPAM
     C                   Z-ADD     BRTE          CL_INTR
     C     SPIN          IFEQ      'A'
     C     SPIN          OREQ      ' '
     C                   ADD       RTSP          CL_INTR
     C                   ELSE
     C                   SUB       RTSP          CL_INTR
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Send a DELETE record to OPICS
     C                   MOVE      'R'           PDACTN
      *
     C                   EXSR      SRPDDTL
      *
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm      'PASDUEDTAQ'  DataQueueName    10
     C                   Parm                    DataQueueLib
     C***********        Parm      1773          DataQueueLen      5 0                        JMI112
     C                   Parm      2025          DataQueueLen      5 0                        JMI112
     C                   Parm      PASDUEDTAQ    DataQueueVal   1583
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Send an INSERT record to OPICS
     C                   MOVE      'I'           PDACTN
      *
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm      'PASDUEDTAQ'  DataQueueName
     C                   Parm                    DataQueueLib
     C***********        Parm      1773          DataQueueLen      5 0                        JMI112
     C                   Parm      2025          DataQueueLen      5 0                        JMI112
     C                   Parm      PASDUEDTAQ    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Database error of not found on CLOANCL
     C                   ELSE
      *
     C                   MOVEL     'CLOANCL'     DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     DK_LNRF       DBKEY
     C                   EXSR      *PSSR

     C                   ENDIF
      *
     C                   ENDSR
      *******************************************************************
      *
      * RTVPSDHST - Retrieve history events for Past due loans from
      *             HISTSHP and HISTSHQ
      *
      *******************************************************************
     C     RTVPSDHST     BEGSR
      *
     C                   EXSR      CLRHIST
      *
     C                   Z-ADD     0             TTLAMT           15 0
     C                   Z-ADD     0             TTINTA           15 0
     C                   Z-ADD     99            KPRSQ             2 0
     C                   MOVE      *BLANKS       Old_Details
      *
     C                   Z-ADD     VDAT          O_VDAT            5 0
      *
     C*****KHISTS        SETGT     LEHISTL9                                                   JMI112
     C*****KHISTSE       READE     LEHISTL9                               83                  JMI112
     C     KHISTS        SETGT     XXHISTL2                                                   JMI112
     C     KHISTSE       READE     XXHISTL2                               83                  JMI112
     C     *IN83         DOWEQ     *OFF
      *
      * Retrieve record types E or D
      *
     C                   IF        RCDT = 'E' OR RCDT = 'D'

     C                   Z-ADD     CL_INTR       TINTR            13 7
      *
      * Compute amount
     C                   IF        AMTP = 'PI'
     C                   EVAL      TTLAMT = TTLAMT - PRAM
     C                   ENDIF
      *
      *
     C     AMTP          IFEQ      'MR'
     C     AMTP          OREQ      'RE'
     C                   EVAL      TTINTA = TTINTA + INTA
     C                   EVAL      TTLAMT = TTLAMT + PRAM
     C                   ENDIF


      * Interest Rate Change
     C     AMTP          IFEQ      'SC'
     C     AMTP          OREQ      'BC'
     C     AMTP          OREQ      'BR'
     C     AMTP          OREQ      'RO'
     C     AMTP          OREQ      'SA'
     C                   Z-ADD     BRTE          TINTR
     C     SPIN          IFEQ      'A'
     C     SPIN          OREQ      ' '
     C                   ADD       RTSP          TINTR
     C                   ELSE
     C                   SUB       RTSP          TINTR
     C                   ENDIF
     C                   ENDIF

      * Loan CCY decimals
     C                   MOVE      CCY           WKCCY             3
     C                   EXSR      SRCURR

      * Save accumulated values
     C                   MOVE      BRCA          O_HIBR
     C                   MOVE      LNRF          O_HILNRF
     C                   MOVE      VDAT          O_HIHISDTE
     C                   Z-ADD     0             O_HIRATE
     C                   Z-ADD     TINTR         TINTR138         13 8
     C                   MOVE      TINTR138      O_HIRATE
     C                   Z-ADD     TTLAMT        ZFLD15

     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C                   MOVE      ZOUT21        O_HIMVAMT

     C                   MOVE      TTINTA        O_HIINTAMT
     C                   MOVE      A6NBDP        O_HICCYDP
     C                   MOVE      PTYP          O_HIPTYP

     C                   ENDIF
      *
     C                   Z-ADD     VDAT          O_VDAT            5 0
     C*****KHISTSE       READE     LEHISTL9                               83                  JMI112
     C     KHISTSE       READE     XXHISTL2                               83                  JMI112
      *
      * If date has changed then output saved details from the last record
      * assuming there are details saved
      * Also output if indicator 83 is ON.
      *
     C     VDAT          IFNE      O_VDAT
     C     Old_Details   ANDNE     *BLANKS
     C     *IN83         OREQ      *ON
     C     Old_Details   ANDNE     *BLANKS

     C                   MOVE      Old_Details   PSDHISDTAQ
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm      'PSDHISDTAQ'  DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm      60            DataQueueLen      5 0
     C                   Parm      PSDHISDTAQ    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Reset running totals fields
     C                   Z-ADD     0             TTLAMT           15 0
     C                   Z-ADD     0             TTINTA           15 0
     C                   MOVE      *BLANKS       Old_Details
      *
     C                   Endif
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      * SRCURR - Access currency details
      *******************************************************************
     C     SRCURR        BEGSR
      * Loan CCY decimals
     C                   CALL      'AOCURRR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WKCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WKCCY         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *
      ** SRPDDTL - move values to Data Queue
      *
      *******************************************************************
     C     SRPDDTL       BEGSR
      *
     C                   MOVE      CL_FIL1       PDFIL1
     C                   MOVE      CL_FIL2       PDFIL2
     C                   MOVE      CL_FIL3       PDFIL3
     C                   MOVE      CL_FIL4       PDFIL4
     C                   MOVE      CL_FIL5       PDFIL5
     C                   MOVE      CL_FIL6       PDFIL6
     C                   MOVE      CL_FIL7       PDFIL7
     C                   MOVE      CL_FIL8       PDFIL8
     C                   MOVE      CL_FIL9       PDFIL9
     C                   MOVE      CL_FIL10      PDFIL10
     C                   MOVE      CL_FIL11      PDFIL11
     C                   MOVE      CL_FIL12      PDFIL12
     C                   MOVE      CL_FIL13      PDFIL13
     C                   MOVE      CL_FIL14      PDFIL14
     C                   MOVE      CL_FIL15      PDFIL15
     C                   MOVE      CL_FIL16      PDFIL16
     C                   MOVE      CL_FIL17      PDFIL17
     C                   MOVE      CL_FIL18      PDFIL18
     C                   MOVE      CL_FIL19      PDFIL19
     C                   MOVE      CL_FIL20      PDFIL20
     C                   MOVE      CL_FIL21      PDFIL21
     C                   MOVE      CL_FIL22      PDFIL22
     C                   MOVE      CL_FIL23      PDFIL23
     C                   MOVE      CL_FIL24      PDFIL24
     C                   MOVE      CL_FIL25      PDFIL25
     C                   MOVE      CL_FIL26      PDFIL26
     C                   MOVE      CL_FIL27      PDFIL27
     C                   MOVE      CL_FIL28      PDFIL28
     C                   MOVE      CL_FIL29      PDFIL29
     C*
     C                   MOVE      CL_DDAT       PDDDAT
     C                   MOVE      CL_VDAT       PDVDAT
     C                   MOVE      CL_MDAT       PDMDAT
     C                   MOVE      CL_CPAM       PDCPAM
      * Interest Rate
     C                   MOVE      CL_INTR       PDINTR
      *
      * Current Base Rate
     C                   MOVE      CL_BRTE       PDBRTE
      *
      * Rate/Spread
     C                   MOVE      CL_RTSP       PDRTSP
      *
      * Margin
     C                   MOVE      CL_MARG       PDMARG
      *
      * Withholding Tax Rate
     C                   MOVE      CL_WTRT       PDWTRT
      *
     C                   MOVE      CL_RAMT       PDRAMT
     C                   MOVE      CL_NRPD       PDNRPD
     C                   MOVE      CL_PSAM       PDPSAM
      * Base Currency Exchange Rate
     C                   MOVE      CL_BCXR       PDBCXR
      *
      * Facility Currency Exchange Rate
     C                   MOVE      CL_FCXR       PDFCXR
      *
     C                   MOVE      CL_RLDT       PDRLDT
     C                   MOVE      CL_NROD       PDNROD
      * Next Rate/Spread
     C                   MOVE      CL_NRTS       PDNRTS
      *
     C                   MOVE      CL_AWTP       PDAWTP
     C                   MOVE      CL_WTRD       PDWTRD
     C                   MOVE      CL_WTWD       PDWTWD
     C                   MOVE      CL_IWOD       PDIWOD
     C                   MOVE      CL_PWOD       PDPWOD
     C                   MOVE      CL_PDIN       PDPDIN
     C                   MOVE      CL_LSWC       PDLSWC
     C                   MOVE      CL_LSWS       PDLSWS
     C                   MOVE      CL_TOTI       PDTOTI
     C                   MOVE      CL_NIDT       PDNIDT
     C                   MOVE      CL_IBDT       PDIBDT
     C                   MOVE      CL_SLID       PDSLID
     C                   MOVE      CL_AIPD       PDAIPD
     C                   MOVE      CL_DLRC       PDDLRC
     C                   MOVE      CL_IACD       PDIACD
     C                   MOVE      CL_AITC       PDAITC
     C                   MOVE      CL_TFEP       PDTFEP
     C                   MOVE      CL_AIAP       PDAIAP
     C                   MOVE      CL_IPRD       PDIPRD
     C                   MOVE      CL_IPRM       PDIPRM
     C                   MOVE      CL_ICTD       PDICTD
     C                   MOVE      CL_AIMN       PDAIMN
     C                   MOVE      CL_RBDT       PDRBDT
     C                   MOVE      CL_NOPS       PDNOPS
     C                   MOVE      CL_ORED       PDORED
     C                   MOVE      CL_LCD        PDLCD
     C                   MOVE      CL_TNLU       PDTNLU
     C                   MOVE      CL_ORMD       PDORMD
     C                   MOVE      CL_ORTI       PDORTI
     C                   MOVE      CL_OMDT       PDOMDT
     C                   MOVE      CL_NIPD       PDNIPD
     C                   MOVE      CL_NMDT       PDNMDT
      * Funding Spread Rate
     C                   MOVE      CL_FSRP       PDFSRP
      *
     C                   MOVE      CL_TCOF       PDTCOF
     C                   MOVE      CL_ACPD       PDACPD
     C                   MOVE      CL_ACDA       PDACDA
     C                   MOVE      CL_ACAJ       PDACAJ
     C                   MOVE      CL_ACAP       PDACAP
     C                   MOVE      CL_COFD       PDCOFD
     C                   MOVE      CL_COFM       PDCOFM
     C                   MOVE      CL_CFCD       PDCFCD
      * New Funding Spread Rate
     C                   MOVE      CL_NFRS       PDNFRS
      *
     C                   MOVE      CL_PDCF       PDPDCF
     C                   MOVE      CL_FCTD       PDFCTD
     C                   MOVE      CL_FWOD       PDFWOD
     C                   MOVE      CL_FCRA       PDFCRA
     C                   MOVE      CL_LRLD       PDLRLD
     C                   MOVE      CL_LMCD       PDLMCD
      * Original Interest Rate
     C                   Z-ADD     0             PDOINR
      *
     C                   MOVE      CL_OIDT       PDOIDT
      * Other additional fields
     C                   MOVE      CL_RFRT       PDRFRT
     C                   MOVE      CL_FSURPL     PDURPL
     C                   MOVE      CL_FSPLAM     PDPLAM
     C                   MOVE      CL_FSPLDT     PDPLDT
     C                   MOVE      CL_FSYUPL     PDYUPL
     C                   MOVE      CL_CHGA       PDCHGA
     C                   MOVE      CL_FLTI       PDFLTI
     C                   MOVE      CL_FRPD       PDFRPD
     C                   MOVE      CL_ACCH       PDACCH
     C                   MOVE      CL_FSEFUP     PDEFUP
     C                   MOVE      CL_FSECUP     PDECUP
     C                   MOVE      CL_AIPN       PDAIPN
     C                   MOVE      CL_AITN       PDAITN
     C                   MOVE      CL_AIAN       PDAIAN
     C                   MOVE      CL_IPRN       PDIPRN
     C                   MOVE      CL_AINN       PDAINN
     C                   MOVE      CL_TOTN       PDTOTN
     C                   MOVE      CL_ICTN       PDICTN
     C                   MOVE      CL_IWON       PDIWON
     C                   MOVE      CL_IPNM       PDIPNM
     C                   MOVE      CL_PDNN       PDPDNN
     C                   MOVE      CL_FSCPAM     PDSPAM
     C                   MOVE      CL_FPAM       PDFPAM
     C                   MOVE      CL_REXR       PDREXR
     C                   MOVE      CL_PEXR       PDPEXR
     C                   MOVE      CL_TFDP       PDTFDP
     C                   MOVE      CL_TFDPA      PDFDPA
     C                   MOVE      CL_TFAM       PDTFAM
     C                   MOVE      CL_TFAC       PDTFAC
     C                   MOVE      CL_TFOF       PDTFOF
     C                   MOVE      CL_AFDP       PDAFDP
     C                   MOVE      CL_CFDP       PDCFDP
     C                   MOVE      CL_AMDS       PDAMDS
     C                   MOVE      CL_AMADJ      PDAMAD
     C                   MOVE      CL_ANADJ      PDANAD
     C                   MOVE      CL_DSAM       PDDSAM
     C                   MOVE      CL_AMCOST     PDAMCO
     C                   MOVE      CL_YMCOST     PDYMCO
     C                   MOVE      CL_YAINT      PDYAIN
     C                   MOVE      CL_BASR       PDBASR
     C                   MOVE      CL_NBSR       PDNBSR
     C*
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Get rundate
     C                   IN        RUNDAT
      *
     C     KHISTS        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KPRSQ
      *
     C     KHISTN2       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KAMTP
      *
     C     KHISTSE       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
      *
      * Clear Data Queue
     C                   Call      'QCLRDTAQ'                           90
     C                   Parm      'PASDUEDTAQ'  DataQueueName
     C                   Parm                    DataQueueLib
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Call      'QCLRDTAQ'                           90
     C                   Parm      'PSDHISDTAQ'  DataQueueName
     C                   Parm                    DataQueueLib
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * CLRHIST - Clear HISTS fields
      *****************************************************************
     C     CLRHIST       BEGSR
      *
     C                   MOVE      *BLANKS       BRCA
     C***********        Z-ADD     0             LNRF                                         JMI112
     C                   MOVE      *BLANKS       LNRF                                         JMI112
     C                   Z-ADD     0             VDAT
     C                   MOVE      *BLANKS       INTR
     C                   Z-ADD     0             PRAM
     C                   Z-ADD     0             INTA
     C                   Z-ADD     0             IPRD
     C                   MOVE      *BLANKS       CCY
     C                   MOVE      *BLANKS       PTYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(C) Finastra International Limited 2018                                                       JMI112
