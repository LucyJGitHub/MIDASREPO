     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Utility Update Program for DEALSDG ')         *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  SMU91002 - Midas SM Utility Update Program for DEALSDG and   *
      *             DLGHISPD files.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060920A *CREATE  Date 29Apr23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060920A - FRA/IRS: incorrect reflection of interest in     *
      *              assets and liabilities for CAPS/Coll/Floor.      *
      *            - Update old RF deals for details in Our/Their     *
      *              side.                                            *
      *                                                               *
      *****************************************************************
      *
     FDEALALL   UF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     FDEALSALL  UF   E           K DISK
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
     F                                     IGNORE(DLBHISD0)
     F                                     IGNORE(DLCHISD0)
     F                                     IGNORE(DLDHISD0)
     F                                     IGNORE(DLEHISD0)
     FSMU91002P1O    E             PRINTER OFLIND(*IN95)
     FSMU91002P2O    E             PRINTER OFLIND(*IN96)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   95    - Page overflow on SMU91002P1                         *
      *   LR    - End of Program                                      *
      *   U7,U8 - Database error occured.                             *
      *                                                               *
      *****************************************************************
     F/SPACE 3
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D WRUN            S              1
      *
      ** DS Our details
     D OURDTL          DS
     D  XCUCY
     D  XPAMT
     D  XBRTT
     D  XSTRT
     D  XBRTE
     D  XRTSP
     D  XSPIN
     D  XEINR
     D  XICBS
     D  XFRFD
     D  XINFD
     D  XSLIP
     D  XNICD
     D  XICBD
     D  XICFR
     D  XICFD
     D  XNIPD
     D  XIPBD
     D  XIPFR
     D  XIPFD
     D  XBCXR
     D  XIACD
     D  XIALC
     D  XAITC
     D  XAIPD
     D  XAIAN
     D  XAIAP
     D  XIPRD
     D  XIPRM
     D  XNSAM
     D  XTAXD
     D  XTAXM
     D  XLPCD
     D  XAEXA
     D  XDNSI
     D  XDSTI
     D  XINPM
     D  XNPCD
     D  XUSI
     D  XUSA
     D  XRFIN
     D  XOBRT
     D  XOPAM
     D  XFRRF
     D  XLULRC
     D  XSOYLC
     D  XSUIPB
     D  XSUPRB
     D  XSUIAB
     D  XSUALB
     D  XSUITB
     D  XSUINB
     D  XSUPMB
     D  XSUSAB
     D  XSUPAM
     D  XSUURL
     D  XSUURP
     D  XSUEFR
     D  XSOFYC
     D  XSOFCC
     D  XSOSDT
     D  XSOS1B
     D  XSOS1D
     D  XSOS2B
     D  XSOS2D
     D  XSOEDT
     D  XSOE1B
     D  XSOE1D
     D  XSOE2B
     D  XSOE2D
     D  XBLRT
     D  XRFRR
     D  XCALM
     D  XBADJ
     D  XFLOR
     D  XLBDY
     D  XLODY
     D  XOPSH
     D  XRRDP
     D  XDBAV
     D  XRTKN
     D  XRCHG
      *
      ** DS Their details
     D THRDTL          DS
     D  YCUCY
     D  YPAMT
     D  YBRTT
     D  YSTRT
     D  YBRTE
     D  YRTSP
     D  YSPIN
     D  YEINR
     D  YICBS
     D  YFRFD
     D  YINFD
     D  YSLIP
     D  YNICD
     D  YICBD
     D  YICFR
     D  YICFD
     D  YNIPD
     D  YIPBD
     D  YIPFR
     D  YIPFD
     D  YBCXR
     D  YIACD
     D  YIALC
     D  YAITC
     D  YAIPD
     D  YAIAN
     D  YAIAP
     D  YIPRD
     D  YIPRM
     D  YNSAM
     D  YTAXD
     D  YTAXM
     D  YLPCD
     D  YAEXA
     D  YDNSI
     D  YDSTI
     D  YINPM
     D  YNPCD
     D  YUSI
     D  YUSA
     D  YRFIN
     D  YOBRT
     D  YOPAM
     D  YFRRF
     D  YLTLRC
     D  YSTYLC
     D  YSTIPB
     D  YSTPRB
     D  YSTIAB
     D  YSTALB
     D  YSTITB
     D  YSTINB
     D  YSTPMB
     D  YSTSAB
     D  YSTPAM
     D  YSTURL
     D  YSTURP
     D  YSTEFR
     D  YSTFYC
     D  YSTFCC
     D  YSTSDT
     D  YSTS1B
     D  YSTS1D
     D  YSTS2B
     D  YSTS2D
     D  YSTEDT
     D  YSTE1B
     D  YSTE1D
     D  YSTE2B
     D  YSTE2D
     D  YBLRT
     D  YRFRR
     D  YCALM
     D  YBADJ
     D  YFLOR
     D  YLBDY
     D  YLODY
     D  YOPSH
     D  YRRDP
     D  YDBAV
     D  YRTKN
     D  YRCHG
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRMAIN1 - Main Processing 01                                 *
      *  SRMAIN2 - Main Processing 02                                 *
      *  SRPRT01 - Generate reports 01                                *
      *  SRPRT02 - Generate reports 02                                *
      *  *PSSR  - Error Processing                                    *
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
     C/TITLE Program Start
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Perform main 01 routine for DEALSDG processing
      *
     C                   EXSR      SRMAIN1

     C     TOTAL1        IFEQ      0
     C                   WRITE     HEADP1
     C                   WRITE     NODETP1
     C                   ELSE
     C                   WRITE     TOTALP1
     C                   ENDIF
      *
      ** Perform main 02 routine for DLGHISPD processing
      *
     C                   EXSR      SRMAIN2

     C     TOTAL2        IFEQ      0
     C                   WRITE     HEADP2
     C                   WRITE     NODETP2
     C                   ELSE
     C                   WRITE     TOTALP2
     C                   ENDIF
      *
      ** End program.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
     C/TITLE SR/INIT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial processing                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Define work fields for deal's Our details
      *
     C     *LIKE         DEFINE    UCUCY         XCUCY
     C     *LIKE         DEFINE    UPAMT         XPAMT
     C     *LIKE         DEFINE    UBRTT         XBRTT
     C     *LIKE         DEFINE    USTRT         XSTRT
     C     *LIKE         DEFINE    UBRTE         XBRTE
     C     *LIKE         DEFINE    URTSP         XRTSP
     C     *LIKE         DEFINE    USPIN         XSPIN
     C     *LIKE         DEFINE    UEINR         XEINR
     C     *LIKE         DEFINE    UICBS         XICBS
     C     *LIKE         DEFINE    UFRFD         XFRFD
     C     *LIKE         DEFINE    UINFD         XINFD
     C     *LIKE         DEFINE    USLIP         XSLIP
     C     *LIKE         DEFINE    UNICD         XNICD
     C     *LIKE         DEFINE    UICBD         XICBD
     C     *LIKE         DEFINE    UICFR         XICFR
     C     *LIKE         DEFINE    UICFD         XICFD
     C     *LIKE         DEFINE    UNIPD         XNIPD
     C     *LIKE         DEFINE    UIPBD         XIPBD
     C     *LIKE         DEFINE    UIPFR         XIPFR
     C     *LIKE         DEFINE    UIPFD         XIPFD
     C     *LIKE         DEFINE    UBCXR         XBCXR
     C     *LIKE         DEFINE    UIACD         XIACD
     C     *LIKE         DEFINE    UIALC         XIALC
     C     *LIKE         DEFINE    UAITC         XAITC
     C     *LIKE         DEFINE    UAIPD         XAIPD
     C     *LIKE         DEFINE    UAIAN         XAIAN
     C     *LIKE         DEFINE    UAIAP         XAIAP
     C     *LIKE         DEFINE    UIPRD         XIPRD
     C     *LIKE         DEFINE    UIPRM         XIPRM
     C     *LIKE         DEFINE    UNSAM         XNSAM
     C     *LIKE         DEFINE    UTAXD         XTAXD
     C     *LIKE         DEFINE    UTAXM         XTAXM
     C     *LIKE         DEFINE    ULPCD         XLPCD
     C     *LIKE         DEFINE    UAEXA         XAEXA
     C     *LIKE         DEFINE    UDNSI         XDNSI
     C     *LIKE         DEFINE    UDSTI         XDSTI
     C     *LIKE         DEFINE    UINPM         XINPM
     C     *LIKE         DEFINE    UNPCD         XNPCD
     C     *LIKE         DEFINE    OUSI          XUSI
     C     *LIKE         DEFINE    OUSA          XUSA
     C     *LIKE         DEFINE    URFIN         XRFIN
     C     *LIKE         DEFINE    UOBRT         XOBRT
     C     *LIKE         DEFINE    UOPAM         XOPAM
     C     *LIKE         DEFINE    UFRRF         XFRRF
     C     *LIKE         DEFINE    PLULRC        XLULRC
     C     *LIKE         DEFINE    FSOYLC        XSOYLC
     C     *LIKE         DEFINE    FSUIPB        XSUIPB
     C     *LIKE         DEFINE    FSUPRB        XSUPRB
     C     *LIKE         DEFINE    FSUIAB        XSUIAB
     C     *LIKE         DEFINE    FSUALB        XSUALB
     C     *LIKE         DEFINE    FSUITB        XSUITB
     C     *LIKE         DEFINE    FSUINB        XSUINB
     C     *LIKE         DEFINE    FSUPMB        XSUPMB
     C     *LIKE         DEFINE    FSUSAB        XSUSAB
     C     *LIKE         DEFINE    FSUPAM        XSUPAM
     C     *LIKE         DEFINE    FSUURL        XSUURL
     C     *LIKE         DEFINE    FSUURP        XSUURP
     C     *LIKE         DEFINE    FSUEFR        XSUEFR
     C     *LIKE         DEFINE    FSOFYC        XSOFYC
     C     *LIKE         DEFINE    FSOFCC        XSOFCC
     C     *LIKE         DEFINE    FSOSDT        XSOSDT
     C     *LIKE         DEFINE    FSOS1B        XSOS1B
     C     *LIKE         DEFINE    FSOS1D        XSOS1D
     C     *LIKE         DEFINE    FSOS2B        XSOS2B
     C     *LIKE         DEFINE    FSOS2D        XSOS2D
     C     *LIKE         DEFINE    FSOEDT        XSOEDT
     C     *LIKE         DEFINE    FSOE1B        XSOE1B
     C     *LIKE         DEFINE    FSOE1D        XSOE1D
     C     *LIKE         DEFINE    FSOE2B        XSOE2B
     C     *LIKE         DEFINE    FSOE2D        XSOE2D
     C     *LIKE         DEFINE    UBLRT         XBLRT
     C     *LIKE         DEFINE    URFRR         XRFRR
     C     *LIKE         DEFINE    UCALM         XCALM
     C     *LIKE         DEFINE    UBADJ         XBADJ
     C     *LIKE         DEFINE    UFLOR         XFLOR
     C     *LIKE         DEFINE    ULBDY         XLBDY
     C     *LIKE         DEFINE    ULODY         XLODY
     C     *LIKE         DEFINE    UOPSH         XOPSH
     C     *LIKE         DEFINE    URRDP         XRRDP
     C     *LIKE         DEFINE    UDBAV         XDBAV
     C     *LIKE         DEFINE    URTKN         XRTKN
     C     *LIKE         DEFINE    URCHG         XRCHG
      *
      ** Define work fields for deal's Their details
      *
     C     *LIKE         DEFINE    TCUCY         YCUCY
     C     *LIKE         DEFINE    TPAMT         YPAMT
     C     *LIKE         DEFINE    TBRTT         YBRTT
     C     *LIKE         DEFINE    TSTRT         YSTRT
     C     *LIKE         DEFINE    TBRTE         YBRTE
     C     *LIKE         DEFINE    TRTSP         YRTSP
     C     *LIKE         DEFINE    TSPIN         YSPIN
     C     *LIKE         DEFINE    TEINR         YEINR
     C     *LIKE         DEFINE    TICBS         YICBS
     C     *LIKE         DEFINE    TFRFD         YFRFD
     C     *LIKE         DEFINE    TINFD         YINFD
     C     *LIKE         DEFINE    TSLIP         YSLIP
     C     *LIKE         DEFINE    TNICD         YNICD
     C     *LIKE         DEFINE    TICBD         YICBD
     C     *LIKE         DEFINE    TICFR         YICFR
     C     *LIKE         DEFINE    TICFD         YICFD
     C     *LIKE         DEFINE    TNIPD         YNIPD
     C     *LIKE         DEFINE    TIPBD         YIPBD
     C     *LIKE         DEFINE    TIPFR         YIPFR
     C     *LIKE         DEFINE    TIPFD         YIPFD
     C     *LIKE         DEFINE    TBCXR         YBCXR
     C     *LIKE         DEFINE    TIACD         YIACD
     C     *LIKE         DEFINE    TIALC         YIALC
     C     *LIKE         DEFINE    TAITC         YAITC
     C     *LIKE         DEFINE    TAIPD         YAIPD
     C     *LIKE         DEFINE    TAIAN         YAIAN
     C     *LIKE         DEFINE    TAIAP         YAIAP
     C     *LIKE         DEFINE    TIPRD         YIPRD
     C     *LIKE         DEFINE    TIPRM         YIPRM
     C     *LIKE         DEFINE    TNSAM         YNSAM
     C     *LIKE         DEFINE    TTAXD         YTAXD
     C     *LIKE         DEFINE    TTAXM         YTAXM
     C     *LIKE         DEFINE    TLPCD         YLPCD
     C     *LIKE         DEFINE    TAEXA         YAEXA
     C     *LIKE         DEFINE    TDNSI         YDNSI
     C     *LIKE         DEFINE    TDSTI         YDSTI
     C     *LIKE         DEFINE    TINPM         YINPM
     C     *LIKE         DEFINE    TNPCD         YNPCD
     C     *LIKE         DEFINE    TUSI          YUSI
     C     *LIKE         DEFINE    TUSA          YUSA
     C     *LIKE         DEFINE    TRFIN         YRFIN
     C     *LIKE         DEFINE    TOBRT         YOBRT
     C     *LIKE         DEFINE    TOPAM         YOPAM
     C     *LIKE         DEFINE    TFRRF         YFRRF
     C     *LIKE         DEFINE    PLTLRC        YLTLRC
     C     *LIKE         DEFINE    FSTYLC        YSTYLC
     C     *LIKE         DEFINE    FSTIPB        YSTIPB
     C     *LIKE         DEFINE    FSTPRB        YSTPRB
     C     *LIKE         DEFINE    FSTIAB        YSTIAB
     C     *LIKE         DEFINE    FSTALB        YSTALB
     C     *LIKE         DEFINE    FSTITB        YSTITB
     C     *LIKE         DEFINE    FSTINB        YSTINB
     C     *LIKE         DEFINE    FSTPMB        YSTPMB
     C     *LIKE         DEFINE    FSTSAB        YSTSAB
     C     *LIKE         DEFINE    FSTPAM        YSTPAM
     C     *LIKE         DEFINE    FSTURL        YSTURL
     C     *LIKE         DEFINE    FSTURP        YSTURP
     C     *LIKE         DEFINE    FSTEFR        YSTEFR
     C     *LIKE         DEFINE    FSTFYC        YSTFYC
     C     *LIKE         DEFINE    FSTFCC        YSTFCC
     C     *LIKE         DEFINE    FSTSDT        YSTSDT
     C     *LIKE         DEFINE    FSTS1B        YSTS1B
     C     *LIKE         DEFINE    FSTS1D        YSTS1D
     C     *LIKE         DEFINE    FSTS2B        YSTS2B
     C     *LIKE         DEFINE    FSTS2D        YSTS2D
     C     *LIKE         DEFINE    FSTEDT        YSTEDT
     C     *LIKE         DEFINE    FSTE1B        YSTE1B
     C     *LIKE         DEFINE    FSTE1D        YSTE1D
     C     *LIKE         DEFINE    FSTE2B        YSTE2B
     C     *LIKE         DEFINE    FSTE2D        YSTE2D
     C     *LIKE         DEFINE    TBLRT         YBLRT
     C     *LIKE         DEFINE    TRFRR         YRFRR
     C     *LIKE         DEFINE    TCALM         YCALM
     C     *LIKE         DEFINE    TBADJ         YBADJ
     C     *LIKE         DEFINE    TFLOR         YFLOR
     C     *LIKE         DEFINE    TLBDY         YLBDY
     C     *LIKE         DEFINE    TLODY         YLODY
     C     *LIKE         DEFINE    TOPSH         YOPSH
     C     *LIKE         DEFINE    TRRDP         YRRDP
     C     *LIKE         DEFINE    TDBAV         YDBAV
     C     *LIKE         DEFINE    TRTKN         YRTKN
     C     *LIKE         DEFINE    TRCHG         YRCHG
      *
     C                   EVAL      TOTAL1 = 0
     C                   EVAL      TOTAL2 = 0
     C                   EVAL      WRUN = ' '
      *
     C                   ENDSR
      *
      *****************************************************************
     C/TITLE SR/SRMAIN1
      *****************************************************************
      *                                                               *
      *  SRMAIN1 - Main Routine                                       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN1       BEGSR
      *
      ** Update the DEALSDG file for old RF deals.
      *
     C     *LOVAL        SETLL     DEALALL
     C                   READ      DEALALL
     C                   DOW       NOT %EOF(DEALALL)
      *
     C                   IF        DTYP = 'RF'
     C                   IF        (BYSL = 'B' AND UEINR <> 0) OR
     C                             (BYSL = 'B' AND UBRTT <> ' ') OR
     C                             (BYSL = 'S' AND TEINR <> 0) OR
     C                             (BYSL = 'S' AND TBRTT <> ' ')
      *
     C                   CLEAR                   OURDTL
     C                   CLEAR                   THRDTL
      *
      ** Move Our details to work fields
      *
     C                   EVAL      XCUCY = UCUCY
     C                   EVAL      XPAMT = UPAMT
     C                   EVAL      XBRTT = UBRTT
     C                   EVAL      XSTRT = USTRT
     C                   EVAL      XBRTE = UBRTE
     C                   EVAL      XRTSP = URTSP
     C                   EVAL      XSPIN = USPIN
     C                   EVAL      XEINR = UEINR
     C                   EVAL      XICBS = UICBS
     C                   EVAL      XFRFD = UFRFD
     C                   EVAL      XINFD = UINFD
     C                   EVAL      XSLIP = USLIP
     C                   EVAL      XNICD = UNICD
     C                   EVAL      XICBD = UICBD
     C                   EVAL      XICFR = UICFR
     C                   EVAL      XICFD = UICFD
     C                   EVAL      XNIPD = UNIPD
     C                   EVAL      XIPBD = UIPBD
     C                   EVAL      XIPFR = UIPFR
     C                   EVAL      XIPFD = UIPFD
     C                   EVAL      XBCXR = UBCXR
     C                   EVAL      XIACD = UIACD
     C                   EVAL      XIALC = UIALC
     C                   EVAL      XAITC = UAITC
     C                   EVAL      XAIPD = UAIPD
     C                   EVAL      XAIAN = UAIAN
     C                   EVAL      XAIAP = UAIAP
     C                   EVAL      XIPRD = UIPRD
     C                   EVAL      XIPRM = UIPRM
     C                   EVAL      XNSAM = UNSAM
     C                   EVAL      XTAXD = UTAXD
     C                   EVAL      XTAXM = UTAXM
     C                   EVAL      XLPCD = ULPCD
     C                   EVAL      XAEXA = UAEXA
     C                   EVAL      XDNSI = UDNSI
     C                   EVAL      XDSTI = UDSTI
     C                   EVAL      XINPM = UINPM
     C                   EVAL      XNPCD = UNPCD
     C                   EVAL      XUSI  = OUSI
     C                   EVAL      XUSA  = OUSA
     C                   EVAL      XRFIN = URFIN
     C                   EVAL      XOBRT = UOBRT
     C                   EVAL      XOPAM = UOPAM
     C                   EVAL      XFRRF = UFRRF
     C                   EVAL      XLULRC = PLULRC
     C                   EVAL      XSOYLC = FSOYLC
     C                   EVAL      XSUIPB = FSUIPB
     C                   EVAL      XSUPRB = FSUPRB
     C                   EVAL      XSUIAB = FSUIAB
     C                   EVAL      XSUALB = FSUALB
     C                   EVAL      XSUITB = FSUITB
     C                   EVAL      XSUINB = FSUINB
     C                   EVAL      XSUPMB = FSUPMB
     C                   EVAL      XSUSAB = FSUSAB
     C                   EVAL      XSUPAM = FSUPAM
     C                   EVAL      XSUURL = FSUURL
     C                   EVAL      XSUURP = FSUURP
     C                   EVAL      XSUEFR = FSUEFR
     C                   EVAL      XSOFYC = FSOFYC
     C                   EVAL      XSOFCC = FSOFCC
     C                   EVAL      XSOSDT = FSOSDT
     C                   EVAL      XSOS1B = FSOS1B
     C                   EVAL      XSOS1D = FSOS1D
     C                   EVAL      XSOS2B = FSOS2B
     C                   EVAL      XSOS2D = FSOS2D
     C                   EVAL      XSOEDT = FSOEDT
     C                   EVAL      XSOE1B = FSOE1B
     C                   EVAL      XSOE1D = FSOE1D
     C                   EVAL      XSOE2B = FSOE2B
     C                   EVAL      XSOE2D = FSOE2D
     C                   EVAL      XBLRT = UBLRT
     C                   EVAL      XRFRR = URFRR
     C                   EVAL      XCALM = UCALM
     C                   EVAL      XBADJ = UBADJ
     C                   EVAL      XFLOR = UFLOR
     C                   EVAL      XLBDY = ULBDY
     C                   EVAL      XLODY = ULODY
     C                   EVAL      XOPSH = UOPSH
     C                   EVAL      XRRDP = URRDP
     C                   EVAL      XDBAV = UDBAV
     C                   EVAL      XRTKN = URTKN
     C                   EVAL      XRCHG = URCHG
      *
      ** Move Their details to work fields
      *
     C                   EVAL      YCUCY = TCUCY
     C                   EVAL      YPAMT = TPAMT
     C                   EVAL      YBRTT = TBRTT
     C                   EVAL      YSTRT = TSTRT
     C                   EVAL      YBRTE = TBRTE
     C                   EVAL      YRTSP = TRTSP
     C                   EVAL      YSPIN = TSPIN
     C                   EVAL      YEINR = TEINR
     C                   EVAL      YICBS = TICBS
     C                   EVAL      YFRFD = TFRFD
     C                   EVAL      YINFD = TINFD
     C                   EVAL      YSLIP = TSLIP
     C                   EVAL      YNICD = TNICD
     C                   EVAL      YICBD = TICBD
     C                   EVAL      YICFR = TICFR
     C                   EVAL      YICFD = TICFD
     C                   EVAL      YNIPD = TNIPD
     C                   EVAL      YIPBD = TIPBD
     C                   EVAL      YIPFR = TIPFR
     C                   EVAL      YIPFD = TIPFD
     C                   EVAL      YBCXR = TBCXR
     C                   EVAL      YIACD = TIACD
     C                   EVAL      YIALC = TIALC
     C                   EVAL      YAITC = TAITC
     C                   EVAL      YAIPD = TAIPD
     C                   EVAL      YAIAN = TAIAN
     C                   EVAL      YAIAP = TAIAP
     C                   EVAL      YIPRD = TIPRD
     C                   EVAL      YIPRM = TIPRM
     C                   EVAL      YNSAM = TNSAM
     C                   EVAL      YTAXD = TTAXD
     C                   EVAL      YTAXM = TTAXM
     C                   EVAL      YLPCD = TLPCD
     C                   EVAL      YAEXA = TAEXA
     C                   EVAL      YDNSI = TDNSI
     C                   EVAL      YDSTI = TDSTI
     C                   EVAL      YINPM = TINPM
     C                   EVAL      YNPCD = TNPCD
     C                   EVAL      YUSI = TUSI
     C                   EVAL      YUSA = TUSA
     C                   EVAL      YRFIN = TRFIN
     C                   EVAL      YOBRT = TOBRT
     C                   EVAL      YOPAM = TOPAM
     C                   EVAL      YFRRF = TFRRF
     C                   EVAL      YLTLRC = PLTLRC
     C                   EVAL      YSTYLC = FSTYLC
     C                   EVAL      YSTIPB = FSTIPB
     C                   EVAL      YSTPRB = FSTPRB
     C                   EVAL      YSTIAB = FSTIAB
     C                   EVAL      YSTALB = FSTALB
     C                   EVAL      YSTITB = FSTITB
     C                   EVAL      YSTINB = FSTINB
     C                   EVAL      YSTPMB = FSTPMB
     C                   EVAL      YSTSAB = FSTSAB
     C                   EVAL      YSTPAM = FSTPAM
     C                   EVAL      YSTURL = FSTURL
     C                   EVAL      YSTURP = FSTURP
     C                   EVAL      YSTEFR = FSTEFR
     C                   EVAL      YSTFYC = FSTFYC
     C                   EVAL      YSTFCC = FSTFCC
     C                   EVAL      YSTSDT = FSTSDT
     C                   EVAL      YSTS1B = FSTS1B
     C                   EVAL      YSTS1D = FSTS1D
     C                   EVAL      YSTS2B = FSTS2B
     C                   EVAL      YSTS2D = FSTS2D
     C                   EVAL      YSTEDT = FSTEDT
     C                   EVAL      YSTE1B = FSTE1B
     C                   EVAL      YSTE1D = FSTE1D
     C                   EVAL      YSTE2B = FSTE2B
     C                   EVAL      YSTE2D = FSTE2D
     C                   EVAL      YBLRT = TBLRT
     C                   EVAL      YRFRR = TRFRR
     C                   EVAL      YCALM = TCALM
     C                   EVAL      YBADJ = TBADJ
     C                   EVAL      YFLOR = TFLOR
     C                   EVAL      YLBDY = TLBDY
     C                   EVAL      YLODY = TLODY
     C                   EVAL      YOPSH = TOPSH
     C                   EVAL      YRRDP = TRRDP
     C                   EVAL      YDBAV = TDBAV
     C                   EVAL      YRTKN = TRTKN
     C                   EVAL      YRCHG = TRCHG
      *
      ** Then swap Their details to Our details
      *
     C                   EVAL      UCUCY = YCUCY
     C                   EVAL      UPAMT = YPAMT
     C                   EVAL      UBRTT = YBRTT
     C                   EVAL      USTRT = YSTRT
     C                   EVAL      UBRTE = YBRTE
     C                   EVAL      URTSP = YRTSP
     C                   EVAL      USPIN = YSPIN
     C                   EVAL      UEINR = YEINR
     C                   EVAL      UICBS = YICBS
     C                   EVAL      UFRFD = YFRFD
     C                   EVAL      UINFD = YINFD
     C                   EVAL      USLIP = YSLIP
     C                   EVAL      UNICD = YNICD
     C                   EVAL      UICBD = YICBD
     C                   EVAL      UICFR = YICFR
     C                   EVAL      UICFD = YICFD
     C                   EVAL      UNIPD = YNIPD
     C                   EVAL      UIPBD = YIPBD
     C                   EVAL      UIPFR = YIPFR
     C                   EVAL      UIPFD = YIPFD
     C                   EVAL      UBCXR = YBCXR
     C                   EVAL      UIACD = YIACD
     C                   EVAL      UIALC = YIALC
     C                   EVAL      UAITC = YAITC
     C                   EVAL      UAIPD = YAIPD
     C                   EVAL      UAIAN = YAIAN
     C                   EVAL      UAIAP = YAIAP
     C                   EVAL      UIPRD = YIPRD
     C                   EVAL      UIPRM = YIPRM
     C                   EVAL      UNSAM = YNSAM
     C                   EVAL      UTAXD = YTAXD
     C                   EVAL      UTAXM = YTAXM
     C                   EVAL      ULPCD = YLPCD
     C                   EVAL      UAEXA = YAEXA
     C                   EVAL      UDNSI = YDNSI
     C                   EVAL      UDSTI = YDSTI
     C                   EVAL      UINPM = YINPM
     C                   EVAL      UNPCD = YNPCD
     C                   EVAL      OUSI = YUSI
     C                   EVAL      OUSA = YUSA
     C                   EVAL      URFIN = YRFIN
     C                   EVAL      UOBRT = YOBRT
     C                   EVAL      UOPAM = YOPAM
     C                   EVAL      UFRRF = YFRRF
     C                   EVAL      PLULRC = YLTLRC
     C                   EVAL      FSOYLC = YSTYLC
     C                   EVAL      FSUIPB = YSTIPB
     C                   EVAL      FSUPRB = YSTPRB
     C                   EVAL      FSUIAB = YSTIAB
     C                   EVAL      FSUALB = YSTALB
     C                   EVAL      FSUITB = YSTITB
     C                   EVAL      FSUINB = YSTINB
     C                   EVAL      FSUPMB = YSTPMB
     C                   EVAL      FSUSAB = YSTSAB
     C                   EVAL      FSUPAM = YSTPAM
     C                   EVAL      FSUURL = YSTURL
     C                   EVAL      FSUURP = YSTURP
     C                   EVAL      FSUEFR = YSTEFR
     C                   EVAL      FSOFYC = YSTFYC
     C                   EVAL      FSOFCC = YSTFCC
     C                   EVAL      FSOSDT = YSTSDT
     C                   EVAL      FSOS1B = YSTS1B
     C                   EVAL      FSOS1D = YSTS1D
     C                   EVAL      FSOS2B = YSTS2B
     C                   EVAL      FSOS2D = YSTS2D
     C                   EVAL      FSOEDT = YSTEDT
     C                   EVAL      FSOE1B = YSTE1B
     C                   EVAL      FSOE1D = YSTE1D
     C                   EVAL      FSOE2B = YSTE2B
     C                   EVAL      FSOE2D = YSTE2D
     C                   EVAL      UBLRT = YBLRT
     C                   EVAL      URFRR = YRFRR
     C                   EVAL      UCALM = YCALM
     C                   EVAL      UBADJ = YBADJ
     C                   EVAL      UFLOR = YFLOR
     C                   EVAL      ULBDY = YLBDY
     C                   EVAL      ULODY = YLODY
     C                   EVAL      UOPSH = YOPSH
     C                   EVAL      URRDP = YRRDP
     C                   EVAL      UDBAV = YDBAV
     C                   EVAL      URTKN = YRTKN
     C                   EVAL      URCHG = YRCHG
      *
      ** Also swap Our details to Their details
      *
     C                   EVAL      TCUCY = XCUCY
     C                   EVAL      TPAMT = XPAMT
     C                   EVAL      TBRTT = XBRTT
     C                   EVAL      TSTRT = XSTRT
     C                   EVAL      TBRTE = XBRTE
     C                   EVAL      TRTSP = XRTSP
     C                   EVAL      TSPIN = XSPIN
     C                   EVAL      TEINR = XEINR
     C                   EVAL      TICBS = XICBS
     C                   EVAL      TFRFD = XFRFD
     C                   EVAL      TINFD = XINFD
     C                   EVAL      TSLIP = XSLIP
     C                   EVAL      TNICD = XNICD
     C                   EVAL      TICBD = XICBD
     C                   EVAL      TICFR = XICFR
     C                   EVAL      TICFD = XICFD
     C                   EVAL      TNIPD = XNIPD
     C                   EVAL      TIPBD = XIPBD
     C                   EVAL      TIPFR = XIPFR
     C                   EVAL      TIPFD = XIPFD
     C                   EVAL      TBCXR = XBCXR
     C                   EVAL      TIACD = XIACD
     C                   EVAL      TIALC = XIALC
     C                   EVAL      TAITC = XAITC
     C                   EVAL      TAIPD = XAIPD
     C                   EVAL      TAIAN = XAIAN
     C                   EVAL      TAIAP = XAIAP
     C                   EVAL      TIPRD = XIPRD
     C                   EVAL      TIPRM = XIPRM
     C                   EVAL      TNSAM = XNSAM
     C                   EVAL      TTAXD = XTAXD
     C                   EVAL      TTAXM = XTAXM
     C                   EVAL      TLPCD = XLPCD
     C                   EVAL      TAEXA = XAEXA
     C                   EVAL      TDNSI = XDNSI
     C                   EVAL      TDSTI = XDSTI
     C                   EVAL      TINPM = XINPM
     C                   EVAL      TNPCD = XNPCD
     C                   EVAL      TUSI = XUSI
     C                   EVAL      TUSA = XUSA
     C                   EVAL      TRFIN = XRFIN
     C                   EVAL      TOBRT = XOBRT
     C                   EVAL      TOPAM = XOPAM
     C                   EVAL      TFRRF = XFRRF
     C                   EVAL      PLTLRC = XLULRC
     C                   EVAL      FSTYLC = XSOYLC
     C                   EVAL      FSTIPB = XSUIPB
     C                   EVAL      FSTPRB = XSUPRB
     C                   EVAL      FSTIAB = XSUIAB
     C                   EVAL      FSTALB = XSUALB
     C                   EVAL      FSTITB = XSUITB
     C                   EVAL      FSTINB = XSUINB
     C                   EVAL      FSTPMB = XSUPMB
     C                   EVAL      FSTSAB = XSUSAB
     C                   EVAL      FSTPAM = XSUPAM
     C                   EVAL      FSTURL = XSUURL
     C                   EVAL      FSTURP = XSUURP
     C                   EVAL      FSTEFR = XSUEFR
     C                   EVAL      FSTFYC = XSOFYC
     C                   EVAL      FSTFCC = XSOFCC
     C                   EVAL      FSTSDT = XSOSDT
     C                   EVAL      FSTS1B = XSOS1B
     C                   EVAL      FSTS1D = XSOS1D
     C                   EVAL      FSTS2B = XSOS2B
     C                   EVAL      FSTS2D = XSOS2D
     C                   EVAL      FSTEDT = XSOEDT
     C                   EVAL      FSTE1B = XSOE1B
     C                   EVAL      FSTE1D = XSOE1D
     C                   EVAL      FSTE2B = XSOE2B
     C                   EVAL      FSTE2D = XSOE2D
     C                   EVAL      TBLRT = XBLRT
     C                   EVAL      TRFRR = XRFRR
     C                   EVAL      TCALM = XCALM
     C                   EVAL      TBADJ = XBADJ
     C                   EVAL      TFLOR = XFLOR
     C                   EVAL      TLBDY = XLBDY
     C                   EVAL      TLODY = XLODY
     C                   EVAL      TOPSH = XOPSH
     C                   EVAL      TRRDP = XRRDP
     C                   EVAL      TDBAV = XDBAV
     C                   EVAL      TRTKN = XRTKN
     C                   EVAL      TRCHG = XRCHG
      *
     C                   UPDATE    DEALSDGF
      *
      ** Print report
      *
     C                   ADD       1             TOTAL1
     C                   EVAL      PDLNO = DLNO
     C                   EVAL      PBYSL = BYSL
     C                   EXSR      SRPRT01
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      DEALALL
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRMAIN2
      *****************************************************************
      *                                                               *
      *  SRMAIN2 - Main Routine 02                                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN2       BEGSR
      *
      ** Update the DLGHISPD file for old RF deals.
      *
     C     *LOVAL        SETLL     DEALSALL
     C                   READ      DEALSALL
     C                   DOW       NOT %EOF(DEALSALL)
      *
     C                   IF        DTYP = 'RF'
     C                   IF        (BYSL = 'B' AND UEINR <> 0) OR
     C                             (BYSL = 'B' AND UBRTT <> ' ') OR
     C                             (BYSL = 'S' AND TEINR <> 0) OR
     C                             (BYSL = 'S' AND TBRTT <> ' ')
      *
     C                   CLEAR                   OURDTL
     C                   CLEAR                   THRDTL
      *
      ** Move Our details to work fields
      *
     C                   EVAL      XCUCY = UCUCY
     C                   EVAL      XPAMT = UPAMT
     C                   EVAL      XBRTT = UBRTT
     C                   EVAL      XSTRT = USTRT
     C                   EVAL      XBRTE = UBRTE
     C                   EVAL      XRTSP = URTSP
     C                   EVAL      XSPIN = USPIN
     C                   EVAL      XEINR = UEINR
     C                   EVAL      XICBS = UICBS
     C                   EVAL      XFRFD = UFRFD
     C                   EVAL      XINFD = UINFD
     C                   EVAL      XSLIP = USLIP
     C                   EVAL      XNICD = UNICD
     C                   EVAL      XICBD = UICBD
     C                   EVAL      XICFR = UICFR
     C                   EVAL      XICFD = UICFD
     C                   EVAL      XNIPD = UNIPD
     C                   EVAL      XIPBD = UIPBD
     C                   EVAL      XIPFR = UIPFR
     C                   EVAL      XIPFD = UIPFD
     C                   EVAL      XBCXR = UBCXR
     C                   EVAL      XIACD = UIACD
     C                   EVAL      XIALC = UIALC
     C                   EVAL      XAITC = UAITC
     C                   EVAL      XAIPD = UAIPD
     C                   EVAL      XAIAN = UAIAN
     C                   EVAL      XAIAP = UAIAP
     C                   EVAL      XIPRD = UIPRD
     C                   EVAL      XIPRM = UIPRM
     C                   EVAL      XNSAM = UNSAM
     C                   EVAL      XTAXD = UTAXD
     C                   EVAL      XTAXM = UTAXM
     C                   EVAL      XLPCD = ULPCD
     C                   EVAL      XAEXA = UAEXA
     C                   EVAL      XDNSI = UDNSI
     C                   EVAL      XDSTI = UDSTI
     C                   EVAL      XINPM = UINPM
     C                   EVAL      XNPCD = UNPCD
     C                   EVAL      XUSI  = OUSI
     C                   EVAL      XUSA  = OUSA
     C                   EVAL      XRFIN = URFIN
     C                   EVAL      XOBRT = UOBRT
     C                   EVAL      XOPAM = UOPAM
     C                   EVAL      XFRRF = UFRRF
     C                   EVAL      XLULRC = PLULRC
     C                   EVAL      XSOYLC = FSOYLC
     C                   EVAL      XSUIPB = FSUIPB
     C                   EVAL      XSUPRB = FSUPRB
     C                   EVAL      XSUIAB = FSUIAB
     C                   EVAL      XSUALB = FSUALB
     C                   EVAL      XSUITB = FSUITB
     C                   EVAL      XSUINB = FSUINB
     C                   EVAL      XSUPMB = FSUPMB
     C                   EVAL      XSUSAB = FSUSAB
     C                   EVAL      XSUPAM = FSUPAM
     C                   EVAL      XSUURL = FSUURL
     C                   EVAL      XSUURP = FSUURP
     C                   EVAL      XSUEFR = FSUEFR
     C                   EVAL      XSOFYC = FSOFYC
     C                   EVAL      XSOFCC = FSOFCC
     C                   EVAL      XSOSDT = FSOSDT
     C                   EVAL      XSOS1B = FSOS1B
     C                   EVAL      XSOS1D = FSOS1D
     C                   EVAL      XSOS2B = FSOS2B
     C                   EVAL      XSOS2D = FSOS2D
     C                   EVAL      XSOEDT = FSOEDT
     C                   EVAL      XSOE1B = FSOE1B
     C                   EVAL      XSOE1D = FSOE1D
     C                   EVAL      XSOE2B = FSOE2B
     C                   EVAL      XSOE2D = FSOE2D
     C                   EVAL      XBLRT = UBLRT
     C                   EVAL      XRFRR = URFRR
     C                   EVAL      XCALM = UCALM
     C                   EVAL      XBADJ = UBADJ
     C                   EVAL      XFLOR = UFLOR
     C                   EVAL      XLBDY = ULBDY
     C                   EVAL      XLODY = ULODY
     C                   EVAL      XOPSH = UOPSH
     C                   EVAL      XRRDP = URRDP
     C                   EVAL      XDBAV = UDBAV
     C                   EVAL      XRTKN = URTKN
     C                   EVAL      XRCHG = URCHG
      *
      ** Move Their details to work fields
      *
     C                   EVAL      YCUCY = TCUCY
     C                   EVAL      YPAMT = TPAMT
     C                   EVAL      YBRTT = TBRTT
     C                   EVAL      YSTRT = TSTRT
     C                   EVAL      YBRTE = TBRTE
     C                   EVAL      YRTSP = TRTSP
     C                   EVAL      YSPIN = TSPIN
     C                   EVAL      YEINR = TEINR
     C                   EVAL      YICBS = TICBS
     C                   EVAL      YFRFD = TFRFD
     C                   EVAL      YINFD = TINFD
     C                   EVAL      YSLIP = TSLIP
     C                   EVAL      YNICD = TNICD
     C                   EVAL      YICBD = TICBD
     C                   EVAL      YICFR = TICFR
     C                   EVAL      YICFD = TICFD
     C                   EVAL      YNIPD = TNIPD
     C                   EVAL      YIPBD = TIPBD
     C                   EVAL      YIPFR = TIPFR
     C                   EVAL      YIPFD = TIPFD
     C                   EVAL      YBCXR = TBCXR
     C                   EVAL      YIACD = TIACD
     C                   EVAL      YIALC = TIALC
     C                   EVAL      YAITC = TAITC
     C                   EVAL      YAIPD = TAIPD
     C                   EVAL      YAIAN = TAIAN
     C                   EVAL      YAIAP = TAIAP
     C                   EVAL      YIPRD = TIPRD
     C                   EVAL      YIPRM = TIPRM
     C                   EVAL      YNSAM = TNSAM
     C                   EVAL      YTAXD = TTAXD
     C                   EVAL      YTAXM = TTAXM
     C                   EVAL      YLPCD = TLPCD
     C                   EVAL      YAEXA = TAEXA
     C                   EVAL      YDNSI = TDNSI
     C                   EVAL      YDSTI = TDSTI
     C                   EVAL      YINPM = TINPM
     C                   EVAL      YNPCD = TNPCD
     C                   EVAL      YUSI = TUSI
     C                   EVAL      YUSA = TUSA
     C                   EVAL      YRFIN = TRFIN
     C                   EVAL      YOBRT = TOBRT
     C                   EVAL      YOPAM = TOPAM
     C                   EVAL      YFRRF = TFRRF
     C                   EVAL      YLTLRC = PLTLRC
     C                   EVAL      YSTYLC = FSTYLC
     C                   EVAL      YSTIPB = FSTIPB
     C                   EVAL      YSTPRB = FSTPRB
     C                   EVAL      YSTIAB = FSTIAB
     C                   EVAL      YSTALB = FSTALB
     C                   EVAL      YSTITB = FSTITB
     C                   EVAL      YSTINB = FSTINB
     C                   EVAL      YSTPMB = FSTPMB
     C                   EVAL      YSTSAB = FSTSAB
     C                   EVAL      YSTPAM = FSTPAM
     C                   EVAL      YSTURL = FSTURL
     C                   EVAL      YSTURP = FSTURP
     C                   EVAL      YSTEFR = FSTEFR
     C                   EVAL      YSTFYC = FSTFYC
     C                   EVAL      YSTFCC = FSTFCC
     C                   EVAL      YSTSDT = FSTSDT
     C                   EVAL      YSTS1B = FSTS1B
     C                   EVAL      YSTS1D = FSTS1D
     C                   EVAL      YSTS2B = FSTS2B
     C                   EVAL      YSTS2D = FSTS2D
     C                   EVAL      YSTEDT = FSTEDT
     C                   EVAL      YSTE1B = FSTE1B
     C                   EVAL      YSTE1D = FSTE1D
     C                   EVAL      YSTE2B = FSTE2B
     C                   EVAL      YSTE2D = FSTE2D
     C                   EVAL      YBLRT = TBLRT
     C                   EVAL      YRFRR = TRFRR
     C                   EVAL      YCALM = TCALM
     C                   EVAL      YBADJ = TBADJ
     C                   EVAL      YFLOR = TFLOR
     C                   EVAL      YLBDY = TLBDY
     C                   EVAL      YLODY = TLODY
     C                   EVAL      YOPSH = TOPSH
     C                   EVAL      YRRDP = TRRDP
     C                   EVAL      YDBAV = TDBAV
     C                   EVAL      YRTKN = TRTKN
     C                   EVAL      YRCHG = TRCHG
      *
      ** Then swap Their details to Our details
      *
     C                   EVAL      UCUCY = YCUCY
     C                   EVAL      UPAMT = YPAMT
     C                   EVAL      UBRTT = YBRTT
     C                   EVAL      USTRT = YSTRT
     C                   EVAL      UBRTE = YBRTE
     C                   EVAL      URTSP = YRTSP
     C                   EVAL      USPIN = YSPIN
     C                   EVAL      UEINR = YEINR
     C                   EVAL      UICBS = YICBS
     C                   EVAL      UFRFD = YFRFD
     C                   EVAL      UINFD = YINFD
     C                   EVAL      USLIP = YSLIP
     C                   EVAL      UNICD = YNICD
     C                   EVAL      UICBD = YICBD
     C                   EVAL      UICFR = YICFR
     C                   EVAL      UICFD = YICFD
     C                   EVAL      UNIPD = YNIPD
     C                   EVAL      UIPBD = YIPBD
     C                   EVAL      UIPFR = YIPFR
     C                   EVAL      UIPFD = YIPFD
     C                   EVAL      UBCXR = YBCXR
     C                   EVAL      UIACD = YIACD
     C                   EVAL      UIALC = YIALC
     C                   EVAL      UAITC = YAITC
     C                   EVAL      UAIPD = YAIPD
     C                   EVAL      UAIAN = YAIAN
     C                   EVAL      UAIAP = YAIAP
     C                   EVAL      UIPRD = YIPRD
     C                   EVAL      UIPRM = YIPRM
     C                   EVAL      UNSAM = YNSAM
     C                   EVAL      UTAXD = YTAXD
     C                   EVAL      UTAXM = YTAXM
     C                   EVAL      ULPCD = YLPCD
     C                   EVAL      UAEXA = YAEXA
     C                   EVAL      UDNSI = YDNSI
     C                   EVAL      UDSTI = YDSTI
     C                   EVAL      UINPM = YINPM
     C                   EVAL      UNPCD = YNPCD
     C                   EVAL      OUSI = YUSI
     C                   EVAL      OUSA = YUSA
     C                   EVAL      URFIN = YRFIN
     C                   EVAL      UOBRT = YOBRT
     C                   EVAL      UOPAM = YOPAM
     C                   EVAL      UFRRF = YFRRF
     C                   EVAL      PLULRC = YLTLRC
     C                   EVAL      FSOYLC = YSTYLC
     C                   EVAL      FSUIPB = YSTIPB
     C                   EVAL      FSUPRB = YSTPRB
     C                   EVAL      FSUIAB = YSTIAB
     C                   EVAL      FSUALB = YSTALB
     C                   EVAL      FSUITB = YSTITB
     C                   EVAL      FSUINB = YSTINB
     C                   EVAL      FSUPMB = YSTPMB
     C                   EVAL      FSUSAB = YSTSAB
     C                   EVAL      FSUPAM = YSTPAM
     C                   EVAL      FSUURL = YSTURL
     C                   EVAL      FSUURP = YSTURP
     C                   EVAL      FSUEFR = YSTEFR
     C                   EVAL      FSOFYC = YSTFYC
     C                   EVAL      FSOFCC = YSTFCC
     C                   EVAL      FSOSDT = YSTSDT
     C                   EVAL      FSOS1B = YSTS1B
     C                   EVAL      FSOS1D = YSTS1D
     C                   EVAL      FSOS2B = YSTS2B
     C                   EVAL      FSOS2D = YSTS2D
     C                   EVAL      FSOEDT = YSTEDT
     C                   EVAL      FSOE1B = YSTE1B
     C                   EVAL      FSOE1D = YSTE1D
     C                   EVAL      FSOE2B = YSTE2B
     C                   EVAL      FSOE2D = YSTE2D
     C                   EVAL      UBLRT = YBLRT
     C                   EVAL      URFRR = YRFRR
     C                   EVAL      UCALM = YCALM
     C                   EVAL      UBADJ = YBADJ
     C                   EVAL      UFLOR = YFLOR
     C                   EVAL      ULBDY = YLBDY
     C                   EVAL      ULODY = YLODY
     C                   EVAL      UOPSH = YOPSH
     C                   EVAL      URRDP = YRRDP
     C                   EVAL      UDBAV = YDBAV
     C                   EVAL      URTKN = YRTKN
     C                   EVAL      URCHG = YRCHG
      *
      ** Also swap Our details to Their details
      *
     C                   EVAL      TCUCY = XCUCY
     C                   EVAL      TPAMT = XPAMT
     C                   EVAL      TBRTT = XBRTT
     C                   EVAL      TSTRT = XSTRT
     C                   EVAL      TBRTE = XBRTE
     C                   EVAL      TRTSP = XRTSP
     C                   EVAL      TSPIN = XSPIN
     C                   EVAL      TEINR = XEINR
     C                   EVAL      TICBS = XICBS
     C                   EVAL      TFRFD = XFRFD
     C                   EVAL      TINFD = XINFD
     C                   EVAL      TSLIP = XSLIP
     C                   EVAL      TNICD = XNICD
     C                   EVAL      TICBD = XICBD
     C                   EVAL      TICFR = XICFR
     C                   EVAL      TICFD = XICFD
     C                   EVAL      TNIPD = XNIPD
     C                   EVAL      TIPBD = XIPBD
     C                   EVAL      TIPFR = XIPFR
     C                   EVAL      TIPFD = XIPFD
     C                   EVAL      TBCXR = XBCXR
     C                   EVAL      TIACD = XIACD
     C                   EVAL      TIALC = XIALC
     C                   EVAL      TAITC = XAITC
     C                   EVAL      TAIPD = XAIPD
     C                   EVAL      TAIAN = XAIAN
     C                   EVAL      TAIAP = XAIAP
     C                   EVAL      TIPRD = XIPRD
     C                   EVAL      TIPRM = XIPRM
     C                   EVAL      TNSAM = XNSAM
     C                   EVAL      TTAXD = XTAXD
     C                   EVAL      TTAXM = XTAXM
     C                   EVAL      TLPCD = XLPCD
     C                   EVAL      TAEXA = XAEXA
     C                   EVAL      TDNSI = XDNSI
     C                   EVAL      TDSTI = XDSTI
     C                   EVAL      TINPM = XINPM
     C                   EVAL      TNPCD = XNPCD
     C                   EVAL      TUSI = XUSI
     C                   EVAL      TUSA = XUSA
     C                   EVAL      TRFIN = XRFIN
     C                   EVAL      TOBRT = XOBRT
     C                   EVAL      TOPAM = XOPAM
     C                   EVAL      TFRRF = XFRRF
     C                   EVAL      PLTLRC = XLULRC
     C                   EVAL      FSTYLC = XSOYLC
     C                   EVAL      FSTIPB = XSUIPB
     C                   EVAL      FSTPRB = XSUPRB
     C                   EVAL      FSTIAB = XSUIAB
     C                   EVAL      FSTALB = XSUALB
     C                   EVAL      FSTITB = XSUITB
     C                   EVAL      FSTINB = XSUINB
     C                   EVAL      FSTPMB = XSUPMB
     C                   EVAL      FSTSAB = XSUSAB
     C                   EVAL      FSTPAM = XSUPAM
     C                   EVAL      FSTURL = XSUURL
     C                   EVAL      FSTURP = XSUURP
     C                   EVAL      FSTEFR = XSUEFR
     C                   EVAL      FSTFYC = XSOFYC
     C                   EVAL      FSTFCC = XSOFCC
     C                   EVAL      FSTSDT = XSOSDT
     C                   EVAL      FSTS1B = XSOS1B
     C                   EVAL      FSTS1D = XSOS1D
     C                   EVAL      FSTS2B = XSOS2B
     C                   EVAL      FSTS2D = XSOS2D
     C                   EVAL      FSTEDT = XSOEDT
     C                   EVAL      FSTE1B = XSOE1B
     C                   EVAL      FSTE1D = XSOE1D
     C                   EVAL      FSTE2B = XSOE2B
     C                   EVAL      FSTE2D = XSOE2D
     C                   EVAL      TBLRT = XBLRT
     C                   EVAL      TRFRR = XRFRR
     C                   EVAL      TCALM = XCALM
     C                   EVAL      TBADJ = XBADJ
     C                   EVAL      TFLOR = XFLOR
     C                   EVAL      TLBDY = XLBDY
     C                   EVAL      TLODY = XLODY
     C                   EVAL      TOPSH = XOPSH
     C                   EVAL      TRRDP = XRRDP
     C                   EVAL      TDBAV = XDBAV
     C                   EVAL      TRTKN = XRTKN
     C                   EVAL      TRCHG = XRCHG
      *
     C                   UPDATE    DLGHISD0
      *
      ** Print report
      *
     C                   ADD       1             TOTAL2
     C                   EVAL      PDLNO = DLNO
     C                   EVAL      PBYSL = BYSL
     C                   EXSR      SRPRT02
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      DEALSALL
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
     C/TITLE SR/SRPSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine.                           *
      *                                                               *
      *  Called By:                                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   WRITE     HEADP1
     C                   WRITE     DBERROR
      *
      ** Set on indicators to end the program.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRPRINT
      *****************************************************************
      *                                                               *
      *  SRPRT01 - Report the affected record                         *
      *                                                               *
      *  Called By: SRMAIN1                                           *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPRT01       BEGSR
      *
     C                   IF        TOTAL1 > 0
     C                   WRITE     HEADP1
     C                   WRITE     DTL01
     C                   WRITE     HEADP1
     C                   WRITE     DTL02
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRPRINT
      *****************************************************************
      *                                                               *
      *  SRPRT02 - Report the affected record                         *
      *                                                               *
      *  Called By: SRMAIN2                                           *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPRT02       BEGSR
      *
     C                   IF        TOTAL2 > 0
     C                   WRITE     HEADP2
     C                   WRITE     DTL021
     C                   WRITE     HEADP2
     C                   WRITE     DTL022
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
** CPY@ **      OBJECT COPYRIGHT
(c) Finastra International Limited 2023
