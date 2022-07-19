      *****************************************************************
     H DEBUG
     H FIXNBR (*NOINPUTPACKED)
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Utility program for AR1019910')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPG/UTLE0662 - Utility to update incorrect YILN, YPLN and    *
      *                 YPLC of loans inserted on year 2012 in        *
      *                 PF/CLOANCK and PF/MCLONCK.                    *
      *                                                               *
      *  Function:  This program reports loans inserted on or after   *
      *             01Jan12 with incorrect YILN, YPLN and YPLC.       *
      *             When on update mode, program will correct these   *
      *             fields in PF/CLOANCK and PF/MCLONCK.              *
      *                                                               *
      *  Called By: UTCLE0662                                         *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. AR1019909 *CREATE  Date 15Jul22               *
      *                                                               *
      *  -----------------------------------------------------------  *
      *                                                               *
      *  AR1019909 - Incorrect amount posted for Interest Accrued Year*
      *              to Date in report LE0950P1, due to incorrect     *
      *              value of fields YILN, YPLN and YPLC. Additional  *
      *              solution to case 00668303. (Child: AR1019910)    *
      *                                                               *
      *****************************************************************
     FUTL662L1  IF   E           K DISK
     FUTL662L2  IF   E           K DISK    RENAME(CLOANCLF:MCLONCLF)
     FCLOAN     UF   E           K DISK    IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(*PSSR)
     FMLOAN     UF   E           K DISK    RENAME(CLOANCKF:MCLONCKF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     IGNORE(CLOANCLF)
     F                                     INFSR(*PSSR)
     FHISTR     IF   E           K DISK    IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHQF)
     F                                     PREFIX(CH_)
     FMHISR     IF   E           K DISK    IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHQF)
     F                                     RENAME(HISTSHPF:MHISTHPF)
     F                                     PREFIX(MH_)
     FUTL662P1  O    E             PRINTER OFLIND(*IN03)
     F                                     INFDS(SPOOL1)
      /EJECT
      *****************************************************************
      *   F U N C T I O N  O F  I N D I C A T O R S                   *
      *****************************************************************
      *    01      Update mode when on                                *
      *    02      No details to report                               *
      *    03      Printer File Overflow Indicator                    *
      *    04      Loan record is from MCLONCK                        *
      *    11      Field YILN updated                                 *
      *    12      Field YPLN updated                                 *
      *    13      Field YPLC updated                                 *
      *    20      Number of Decimal Places = 0 for loan CCY          *
      *    21      Number of Decimal Places = 1 for loan CCY          *
      *    22      Number of Decimal Places = 2 for loan CCY          *
      *    23      Number of Decimal Places = 3 for loan CCY          *
      *    30      Number of Decimal Places = 0 for local CCY         *
      *    31      Number of Decimal Places = 1 for local CCY         *
      *    32      Number of Decimal Places = 2 for local CCY         *
      *    33      Number of Decimal Places = 3 for local CCY         *
      *    85      No record found CLOANCK/MCLONCK                    *
      *                                                               *
      *****************************************************************
      *   S U B R O U T I N E  I N D E X                              *
      *****************************************************************
      *  SrInit       - Initialization subroutine                     *
      *  SrCloanck    - Read and process records from CLOANCK         *
      *  SrMclonck    - Read and process records from MCLONCK         *
      *  SrProcLoan   - Process loans from CLOANCK/MCLONCK            *
      *  SrFmtDate    - Format Date                                   *
      *  SrGetXRate   - Get the Cross Rate between loan and local ccy *
      *  SrCvtAmount  - Converts Amount via *mod/ZCONVZ1              *
      *  SrGetCurDet  - Determine currency details                    *
      *  SrGetHisSpot - Get Historic Spot Rate                        *
      *  SrFmtDisp    - Format amounts to be displayed                *
      *****************************************************************
      *       D A T A   S P E C S                                     *
      *****************************************************************

      ** DS for LDA

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** Bank Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data structure for Currency details.

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External data structures for Historic Spot Rates Details

     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)

      ** Data structure for Access Program

     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** ZDate2 parameters

     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A

      ** Parameters for ZXRATE module

     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1

      ** Parameters for ZCONVZ1 module

     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

     D @RUN            S              1
     D @CCY            S              3
     D @DATE           S              5  0
     D WkSPRT          S             13P 8
     D WkMDIN          S              1
     D HVDAT           S              5  0

     D SPOOL1          DS
     D OFFLN                 188    189B 0
     D CURLIN                367    368B 0

      *****************************************************************
      *            KEY   L I S T S                                    *
      *****************************************************************

     C     KHIST         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNRF

      *****************************************************************
      *            M A I N   P R O C E D U R E                        *
      *****************************************************************

     C                   EXSR      SrInit
     C                   EXSR      SrCloanck
     C                   EXSR      SrMclonck

      ** Set on LR.

     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit  - Program Initialisation routine                     *
      *                                                               *
      *  Called by: Main procedure                                    *
      *                                                               *
      *  Calls: AOBANKR0                                              *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR

      ** Entry parameter

     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
     C                   IF        MODE = 'u'
     C                             or MODE = 'U'
     C                   MOVE      '1'           *IN01
     C                   ENDIF

     C     *DTAARA       DEFINE                  LDA
     C                   Z-ADD     0             PAGE              2 0
     C                   Z-ADD     0             RLON

      ** Access bank details.

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      '       '
     C     *LOCK         IN        LDA
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'UTLE0662'    DBPGM
     C                   MOVE      ' '           DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   Z-ADD     001           DBASE                          * DBERR 001*
     C                   OUT       LDA                                          ************
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Write report header.

     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCloanck - Read and process records from CLOANCL            *
      *                                                               *
      *  Called by: Main procedure                                    *
      *                                                               *
      *  Calls: SrProcLoan                                            *
      *                                                               *
      *****************************************************************
     C     SrCloanck     BEGSR

      ** Read PF/CLOANCL
      ** Process records with Value date >= 01Jan12

     C                   READ      UTL662L1
     C                   DOW       NOT %EOF(UTL662L1)

     C                   IF        *IN03 = '1'
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   MOVE      0             *IN03
     C                   ENDIF

     C     LNRF          CHAIN     CLOANCKF                           85

     C                   IF        *IN85 = '0'
     C                   EXSR      SrProcLoan

     C                   MOVEA     '000'         *IN(11)
     C                   IF        YILN <> AYILN
     C                   EVAL      YILN = AYILN
     C                   EVAL      *IN11 = '1'
     C                   ENDIF
     C                   IF        YPLN <> AYPLN
     C                   EVAL      YPLN = AYPLN
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   IF        YPLC <> AYPLC
     C                   EVAL      YPLC = AYPLC
     C                   EVAL      *IN13 = '1'
     C                   ENDIF

     C                   Z-ADD     10            RQDLIN            2 0
     C     OFFLN         SUB       CURLIN        AVALIN            2 0
     C     AVALIN        IFLT      RQDLIN
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   ENDIF

     C                   IF        *IN11 = '1' or *IN12 = '1'
     C                             or *IN13 = '1'
     C                   ADD       1             RLON
     C                   WRITE     DETAIL1
     C                   IF        *IN01 = '1'
     C                   UPDATE    CLOANCKF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   READ      UTL662L1

     C                   ENDDO

      ** Trailer

     C                   IF        RLON = 0
     C                   EVAL      *IN02 = '1'
     C                   ENDIF

     C                   Z-ADD     5             RQDLIN
     C     OFFLN         SUB       CURLIN        AVALIN
     C     AVALIN        IFLT      RQDLIN
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   ENDIF

     C                   WRITE     TRAILER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMclonck - Read and process records from MCLONCK            *
      *                                                               *
      *  Called by: Main procedure                                    *
      *                                                               *
      *  Calls: SrProcLoan                                            *
      *                                                               *
      *****************************************************************
     C     SrMclonck     BEGSR

      ** Write report header for MCLONCK.

     C                   Z-ADD     0             RLON
     C                   ADD       1             PAGE
     C                   WRITE     HEADER2

      ** Read PF/MCLONCL
      ** Process records with Value date >= 01Jan12

     C                   READ      UTL662L2
     C                   DOW       NOT %EOF(UTL662L2)

     C                   IF        *IN03 = '1'
     C                   ADD       1             PAGE
     C                   WRITE     HEADER2
     C                   MOVE      0             *IN03
     C                   ENDIF

     C     LNRF          CHAIN     MCLONCKF                           85

     C                   IF        *IN85 = '0'
     C                   MOVE      '1'           *IN04
     C                   EXSR      SrProcLoan

     C                   MOVEA     '000'         *IN(11)
     C                   IF        YILN <> AYILN
     C                   EVAL      YILN = AYILN
     C                   EVAL      *IN11 = '1'
     C                   ENDIF
     C                   IF        YPLN <> AYPLN
     C                   EVAL      YPLN = AYPLN
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   IF        YPLC <> AYPLC
     C                   EVAL      YPLC = AYPLC
     C                   EVAL      *IN13 = '1'
     C                   ENDIF


     C                   Z-ADD     10            RQDLIN
     C     OFFLN         SUB       CURLIN        AVALIN
     C     AVALIN        IFLT      RQDLIN
     C                   ADD       1             PAGE
     C                   WRITE     HEADER2
     C                   ENDIF

     C                   IF        *IN11 = '1' or *IN12 = '1'
     C                             or *IN13 = '1'
     C                   ADD       1             RLON
     C                   WRITE     DETAIL1
     C                   IF        *IN01 = '1'
     C                   UPDATE    MCLONCKF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   READ      UTL662L2

     C                   ENDDO

      ** Trailer

     C                   IF        RLON = 0
     C                   EVAL      *IN02 = '1'
     C                   ENDIF

     C                   Z-ADD     5             RQDLIN
     C     OFFLN         SUB       CURLIN        AVALIN
     C     AVALIN        IFLT      RQDLIN
     C                   ADD       1             PAGE
     C                   WRITE     HEADER2
     C                   ENDIF

     C                   WRITE     TRAILER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcLoan - Subroutine that processes records from CLOANCK  *
      *               and MCLONCK with incorrect YILN, YPLN, YPLC and *
      *               VDAT >=  01Jan12.                               *
      *                                                               *
      *  Called by: SrCloanck, SrMclonck                              *
      *                                                               *
      *****************************************************************
     C     SrProcLoan    BEGSR

     C                   MOVE      RECI          WRECI
     C                   MOVE      LNRF          WLNRF
     C                   MOVE      CCY           WCCY

     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      SrFmtDate
     C                   MOVE      ZADATE        WVDAT

     C                   Z-ADD     MDAT          ZDAYNO
     C                   EXSR      SrFmtDate
     C                   MOVE      ZADATE        WMDAT

     C                   Z-ADD     YILN          WYILN            13 0
     C                   Z-ADD     YPLN          WYPLN            13 0
     C                   Z-ADD     YPLC          WYPLC            13 0

     C                   Z-ADD     0             AYILN            13 0
     C                   Z-ADD     0             AYPLN            13 0
     C                   Z-ADD     0             AYPLC            13 0

      ** Get Details of the 'From' Ccy (Loan CCY)
     C                   EVAL      @CCY = CCY
     C                   EXSR      SrGetCurDet
     C                   EVAL      ZCDPI = A6NBDP

      ** Get Details of the 'To' Ccy (Local CCY)

     C                   EVAL      @CCY = BJLCCY
     C                   EXSR      SrGetCurDet
     C                   EVAL      ZCDPO = A6NBDP

      ** Read records from HISTSHP if *IN04 = 0

     C                   IF        *IN04 = '0'

     C     KHIST         SETLL     HISTR
     C                   READ      HISTR
     C                   DOW       NOT %EOF(HISTR)

     C                   IF        WLNRF = CH_LNRF
     C                   IF        CH_AMTP = 'RE' or CH_AMTP = 'MR' or
     C                             (CH_AMTP = 'IN' and INTC <> 'Y')
     C                             or CH_AMTP = 'MA'
     C                   ADD       CH_INTA       AYPLN

     C                   IF        CH_CCY <> BJLCCY
     C                             AND CH_INTA <> 0

      ** Get the cross rate between the Loan ccy & Local ccy

     C                   EVAL      ZCCYI = CH_CCY
     C                   EVAL      ZCCYO = BJLCCY
     C                   EVAL      HVDAT = CH_VDAT
     C                   EXSR      SrGetXRate
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX

      ** Convert interest amount from loan ccy to local ccy

     C                   EVAL      ZAMTCI = CH_INTA
     C                   EXSR      SrCvtAmount
     C                   Z-ADD     ZAMTCO        SYPLC            13 0
     C                   ADD       SYPLC         AYPLC

     C                   ELSE
     C                   ADD       CH_INTA       AYPLC
     C                   ENDIF

     C                   ENDIF
     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   READ      HISTR
     C                   ENDDO

     C                   ENDIF

      ** Read records from MHISTHP if *IN04 = 1

     C                   IF        *IN04 = '1'

     C     KHIST         SETLL     MHISR
     C                   READ      MHISR
     C                   DOW       NOT %EOF(MHISR)

     C                   IF        WLNRF = MH_LNRF
     C                   IF        MH_AMTP = 'RE' or MH_AMTP = 'MR' or
     C                             (MH_AMTP = 'IN' and INTC <> 'Y')
     C                             or MH_AMTP = 'MA'
     C                   ADD       MH_INTA       AYPLN

     C                   IF        MH_CCY <> BJLCCY
     C                             AND MH_INTA <> 0

      ** Get the cross rate between the Loan ccy & Local ccy

     C                   EVAL      ZCCYI = MH_CCY
     C                   EVAL      ZCCYO = BJLCCY
     C                   EVAL      HVDAT = MH_VDAT
     C                   EXSR      SrGetXRate
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX

      ** Convert interest amount from loan ccy to local ccy

     C                   EVAL      ZAMTCI = MH_INTA
     C                   EXSR      SrCvtAmount
     C                   Z-ADD     ZAMTCO        SYPLC
     C                   ADD       SYPLC         AYPLC

     C                   ELSE
     C                   ADD       MH_INTA       AYPLC
     C                   ENDIF
     C                   ENDIF

     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   READ      MHISR
     C                   ENDDO

     C                   ENDIF

      ** Format Display fields

     C                   EXSR      SrFmtDisp

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDate -  Format Date                                      *
      *                                                               *
      * Called by: SrProcLoan                                         *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
     C     SrFmtDate     BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetXRate - Subroutine to Get the Cross Rate between Two    *
      *               Currencies                                      *
      *                                                               *
      * Called by: SrProcLoan                                         *
      *                                                               *
      * Calls: SrGetCurDet, SrGetHisSpot, ZXRATE                      *
      *                                                               *
      *****************************************************************
     C     SrGetXRate    BEGSR

     C                   EVAL      @CCY = ZCCYI
     C                   EVAL      @DATE = HVDAT
     C                   EXSR      SrGetHisSpot
     C                   EVAL      ZRATE1 = WkSPRT
     C                   EVAL      ZMDI1 = WkMDIN

     C                   EVAL      @CCY = ZCCYO
     C                   EVAL      @DATE = HVDAT
     C                   EXSR      SrGetHisSpot
     C                   EVAL      ZRATE2 = WkSPRT
     C                   EVAL      ZMDI2 = WkMDIN

     C                   CALL      'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2

      ** Outputs

     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetCurDet - Subroutine to determine currency details       *
      *                                                               *
      *  Called by: SrProcLoan                                        *
      *                                                               *
      *  Calls: AOCURRR0                                              *
      *                                                               *
      *****************************************************************
     C     SrGetCurDet   BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'UTLE0662'    DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     002           DBASE                          * DBERR 002*
     C                   MOVEL     @CCY          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetHisSpot - Subroutine to Get Historic Spot Rate          *
      *                                                               *
      *  Called by: SrGetXRate                                        *
      *                                                               *
      *  Calls: AOCUHSR0                                              *
      *                                                               *
      *****************************************************************
     C     SrGetHisSpot  BEGSR

      ** Call Access Program for Historic Spot Rates

     C                   CALL      'AOCUHSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @Date
     C                   PARM                    @CCY
     C     SDCUHS        PARM      SDCUHS        DSSDY

      ** Handle Database Error.

     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'UTLE0662'    DBPGM
     C                   MOVEL     'SDCUHSPD'    DBFILE                         ************
     C                   Z-ADD     003           DBASE                          * DBERR 003*
     C                   MOVEL     @CCY          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WkSPRT = G2SPRT
     C                   EVAL      WkMDIN = G2MDIN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtAmount - Subroutine that Converts Amount via            *
      *                *mod/ZCONVZ1                                   *
      *                                                               *
      *  Called by: SrProcLoan                                        *
      *                                                               *
      *  Calls: ZCONVZ1                                               *
      *                                                               *
      *****************************************************************
     C     SrCvtAmount   BEGSR

     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO

      ** Output

     C                   PARM      *ZEROS        ZAMTCO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtDisp - Subroutine to format display amounts with correct*
      *              decimal places.                                  *
      *                                                               *
      *  Called by: SrProcLoan                                        *
      *                                                               *
      *****************************************************************
     C     SrFmtDisp     BEGSR

     C                   MOVEA     '0000'        *IN(20)
     C                   MOVEA     '0000'        *IN(30)

     C                   IF        ZCDPI = 0
     C                   MOVE      '1'           *IN20
     C                   ENDIF
     C                   IF        ZCDPI = 1
     C                   MOVE      '1'           *IN21
     C                   ENDIF
     C                   IF        ZCDPI = 2
     C                   MOVE      '1'           *IN22
     C                   ENDIF
     C                   IF        ZCDPI = 3
     C                   MOVE      '1'           *IN23
     C                   ENDIF

     C                   IF        ZCDPO = 0
     C                   MOVE      '1'           *IN30
     C                   ENDIF
     C                   IF        ZCDPO = 1
     C                   MOVE      '1'           *IN31
     C                   ENDIF
     C                   IF        ZCDPO = 2
     C                   MOVE      '1'           *IN32
     C                   ENDIF
     C                   IF        ZCDPO = 3
     C                   MOVE      '1'           *IN33
     C                   ENDIF

     C                   IF        *IN20 = '1'
     C                   MOVE      WYILN         WYILN0
     C                   MOVE      WYPLN         WYPLN0
     C                   MOVE      AYILN         AYILN0
     C                   MOVE      AYPLN         AYPLN0
     C                   ENDIF
     C                   IF        *IN21 = '1'
     C                   MOVE      WYILN         WYILN1
     C                   MOVE      WYPLN         WYPLN1
     C                   MOVE      AYILN         AYILN1
     C                   MOVE      AYPLN         AYPLN1
     C                   ENDIF
     C                   IF        *IN22 = '1'
     C                   MOVE      WYILN         WYILN2
     C                   MOVE      WYPLN         WYPLN2
     C                   MOVE      AYILN         AYILN2
     C                   MOVE      AYPLN         AYPLN2
     C                   ENDIF
     C                   IF        *IN23 = '1'
     C                   MOVE      WYILN         WYILN3
     C                   MOVE      WYPLN         WYPLN3
     C                   MOVE      AYILN         AYILN3
     C                   MOVE      AYPLN         AYPLN3
     C                   ENDIF

     C                   IF        *IN30 = '1'
     C                   MOVE      WYPLC         WYPLC0
     C                   MOVE      AYPLC         AYPLC0
     C                   ENDIF
     C                   IF        *IN31 = '1'
     C                   MOVE      WYPLC         WYPLC1
     C                   MOVE      AYPLC         AYPLC1
     C                   ENDIF
     C                   IF        *IN32 = '1'
     C                   MOVE      WYPLC         WYPLC2
     C                   MOVE      AYPLC         AYPLC2
     C                   ENDIF
     C                   IF        *IN33 = '1'
     C                   MOVE      WYPLC         WYPLC3
     C                   MOVE      AYPLC         AYPLC3
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Subroutine to handle error condition.               *
      *                                                               *
      *  Called by: Main procedure                                    *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = ' '
     C                   MOVE      'Y'           @RUN
     C                   DUMP
     C                   ENDIF

     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
