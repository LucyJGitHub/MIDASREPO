     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************             LUC109
/*STD *  RPGBASEBND                                                   *             LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***DLM013*-*Extract*Future*IRS*Events****************************             LUC109
      *  XXDL0013 - Midas HOR Extract Future IRS Events               *             LUC109
      *****************************************************************
      * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
      * OF LIBL ***                                                   *
      *****************************************************************
      *                                                               *
      *  Function: To extract Interest Payments and Rate Changes      *
      *            for IRS deals.                                     *
      *            THIS PROGRAM IS LOOSELY BASED OVER DL0401.         *
      *                                                               *
      ***Called*By:*GLCM048*-*HOR*Extract******************************             LUC109
      *  Called By: XXC000048 - Midas HOR Extract                     *             LUC109
      *                                                               *
      ***(c)*Misys*2004************************************************             LUC109
      *  (c) Finastra International Limited 2016                      *             LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 16Sep16               *
      *  Prev Amend No. LUC013             Date 02Jun08               *
      *                 246852             Date 03Apr07               *
      *                 MUI011  *Create    Date 14Jun04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FBM 2.1)                   *
      *  LUC013 - Chain to SDNOSTL1 rather then invoke AONOSTR0.      *
      *  246852 - Errors on FEINT and FETAS extracts                  *
      *  MUI011 - ALMS changes to HOR                                 *
      *                                                               *
      *****************************************************************
      *
     FDEALSDG   IF   E             DISK    INFSR(*PSSR)
     FDLCFSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLDTSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLPCSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLMFEVPP  O    E             DISK    INFSR(*PSSR)
     FSDNOSTL1  IF   E           K DISK                                                       LUC013
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D** GENERAL LEDGER ICD RECORD DETAILS FOR ACCESS PROGRAM
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** External DS for CURRENCY details
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D** External DS for CUSTOMER details
     D*
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
     D** External DS for COUNTRY details
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** External DS for BANK LEDGER details
     D*
     D***SDNOST    E DSSDNOSTPD                                                          LUC013
     D** External DS for NOSTRO details
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR descriptions
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D** Module details
     D*
     D* Dummy data structures used by ACCESS PROGRAMS
     D* (DSSDY only used if file records over 150 chars. long)
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D**   Local data area to hold database error information
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     I*COPY*ZSRSRC,ZFRQB2Z1****                                                     LUC109
     I*COPY*ZSRSRC,ZDATE2Z1****                                                     LUC109
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)                LUC109
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)                  LUC109
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)                LUC109
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)                LUC109
     I*COPY*ZSRSRC,ZDATE9Z1****                                                     LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                       LUC109
     I*COPY*ZSRSRC,ZHOLE*******                                                     LUC109
     D/COPY ZSRSRC,ZHOLELE                                                          LUC109
     D/COPY ZSRSRC,ZHOLILE                                                          LUC109
     D/COPY ZSRSRC,ZINTDYZ1LE                                                       LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                       LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                       LUC109
      /EJECT
     IDEALSDGF
     I              RECI                        RECID
     I              FACO                        WFACO
     IDLPCSCD0
     I              DLNO                        PCDLNO
     I              OTIN                        PCOTIN
     I*COPY*ZSRSRC,ZHOLI******                                                      LUC109
     I*COPY*ZSRSRC,ZINTDYZ1***                                                      LUC109
     I*COPY*ZSRSRC,ZDATE9Z2***                                                      LUC109
     I*COPY*ZSRSRC,ZDAT10Z1***                                                      LUC109
      /EJECT
     C                   MOVEA     CPY@          BIS@             80
     C     *DTAARA       DEFINE                  LDA
      *****************************************************************
      *                                                               *
      *  MAINLINE  - Main processing                                  *
      *                                                               *
      *  Called By:                                                   *
      *  Calls: DETAIL - Process a live IRS deal                      *
      *                                                               *
      *****************************************************************
      *
     C                   READ      DEALSDG                                01
      *
     C     *IN01         DOWEQ     *OFF
      *
      * Select live deals and exclude FRAs
      *
     C     RECID         IFEQ      'D'
     C     DTYP          ANDNE     'FR'
      *
      * Our side
     C                   EXSR      OUR
     C                   EXSR      DETAIL
      *
      * Their side
     C                   EXSR      THEIR
     C                   EXSR      DETAIL
     C                   ENDIF
      *
     C                   READ      DEALSDG                                01
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETAIL - Process a live IRS deal                             *
      *                                                               *
      *  Called By: Mainline                                          *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     DETAIL        BEGSR
      *
      ** SET NEXT INT. PAYMENT & CHANGE DATES AND INT. CALC. END DATE
      *
     C                   EXSR      DATSET
      *
      * Set limit date for current rate
      *
     C                   Z-ADD     99999         WLIMDT            5 0
     C     WBRTT         IFNE      *ZERO
     C     WIPFR         ANDNE     'C'
     C                   Z-ADD     WNICD         WLIMDT
     C                   ENDIF
      *
      * Extract Rate Change event for HOR FETAS extract
      *
     C     WNICD         IFLT      MDAT
     C                   EXSR      OUTTAS
     C                   ENDIF
      *
      ** If the interest is paid up front
      *
     C     CIR001        IFEQ      'Y'
      *
     C     WINPM         IFEQ      'D'
     C     WINPM         OREQ      'Y'
      *
      ** If the deal has not reached its value date
      ** the next payment date is the value date of the deal.
      *
     C                   TESTB     '1'           ACEI                 40
     C     *IN40         IFEQ      '1'
     C                   Z-ADD     VDAT          WICED
     C                   Z-ADD     VDAT          WIPBD
     C                   Z-ADD     VDAT          WNIPD
     C                   END
      *
      ** Suppress interest events for the next interest payment date if
      ** rate fixing is still due.
      *
     C     WINFD         IFGT      *ZERO
     C     WINFD         IFLE      WNIPD
     C                   BITOFF    '0'           WDNSI
     C                   ELSE
      *
      ** If rate fixing is not due, use current base rate as effective
      ** interest rate for next period.
      *
     C     WNICD         IFEQ      WNIPD
     C     WEINR         OREQ      *ZERO
     C                   EXSR      #LEFIN
     C                   END
     C                   END
     C                   ELSE
     C     WNICD         IFEQ      WNIPD
     C     WEINR         OREQ      *ZERO
     C                   EXSR      #LEFIN
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   Z-ADD     WEINR         ZIRATE
      *
      ** CALCULATE INTEREST DUE
      *
     C     CIR001        IFNE      'Y'
     C                   EXSR      INTDUE
     C                   ELSE
     C     WBRTT         IFEQ      0
     C                   EXSR      INTDUE
     C                   ELSE
     C                   TESTB     '0'           WDNSI                    11
     C     *IN11         IFEQ      '1'
     C                   EXSR      INTDUE
     C**********           ELSE                                                               246852
     C**********           Z-ADDMDAT      WICED                                               246852
     C**********           Z-ADDMDAT      WNIPD                                               246852
     C                   END
     C                   END
     C                   END
     C*
     C** CONTINUE PROCESSING UNTIL NO FURTHER INTEREST AMOUNTS CAN
     C** BE CALCULATED
     C*
     C                   SETOFF                                       52
     C     *IN52         DOWNE     '1'
     C*
     C** IF NEXT INTEREST PAYMENT DATE < OR = NEXT CHANGE DATE,
     C** GENERATE INTEREST PAYMENT EVENT
     C*
     C     WNIPD         IFLE      WNICD
      *
      ** If interest is capitalised, maintain a running total
      **   of interest. If the event date is maturity date, set
      **   interest amount to the running total.
      *
     C     CIR001        IFEQ      'Y'
      *
     C     WINPM         IFEQ      'C'
     C     WNIPD         ANDNE     MDAT
     C     WINPM         OREQ      'K'
     C                   ADD       WINTD         WWTOI
     C                   END
      *
     C     WINPM         IFEQ      'C'
     C     WNIPD         ANDEQ     MDAT
     C     WWTOI         ADD       WINTD         WINTD            13 0
     C                   ADD       WIPRD         WINTD
     C                   END
      *
     C                   END
      *
     C                   EXSR      OUTINT
      *
     C                   Z-ADD     0             WINTD            13 0
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     0             WUSI
     C                   Z-ADD     0             WUSA
     C                   END
     C                   END
     C*
     C** IF INT. CALC. END DATE LATER THAN OR = MATURITY DATE, NO
     C** FURTHER CALCS. NECESSARY FOR THESE DETAILS. EXIT FROM LOOP
     C*
     C     WICED         IFGE      MDAT
     C                   SETON                                        52
     C                   ELSE
     C*
     C** STORE NEXT INTEREST PAYMENT AND CHANGE DATES
     C*
     C                   Z-ADD     WNIPD         SNIPD             5 0
     C                   Z-ADD     WNICD         SNICD             5 0
     C*
     C** 1) PROCESS IF NEXT PAY. DATE IS LATER THAN NEXT CHANGE DATE
     C*
     C     SNIPD         IFGT      SNICD
     C*
     C** CALCULATE SUBSEQUENT CHANGE DATE AND NEW INTEREST RATE
     C*
     C                   EXSR      NXTICD
     C*
     C** CALCULATE INTEREST AMOUNT FOR NEW PERIOD
     C*
     C                   EXSR      INTRSX
     C                   END
     C*
     C** 2) PROCESS IF NEXT PAYMENT DATE IS EQUAL TO NEXT CHANGE DATE
     C*
     C     SNIPD         IFEQ      SNICD
     C                   EXSR      NXTICD
     C                   EXSR      NXTIPD
     C                   EXSR      INTRSX
     C                   END
     C*
     C** 3) PROCESS IF NEXT PAY. DATE IS EARLIER THAN NEXT CHANGE DATE
     C*
     C** CALCULATE SUBSEQUENT PAYMENT DATE,NEW INTEREST RATE AND AMOUNT
     C*
     C     SNIPD         IFLT      SNICD
     C                   EXSR      NXTIPD
     C                   EXSR      INTRSX
     C                   END
     C*
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*
      /EJECT
      *****************************************************************
      *                                                               *
      *  S/R #LCASS - Determine next cash flow schedule               *
      *                                                               *
      *****************************************************************
     C     #LCASS        BEGSR
     C                   Z-ADD     ZDAYNO        PRDT
      *
     C     DLNO          IFNE      XDLNO
     C                   MOVE      '1'           *IN30
     C                   END
      *
     C     IRSCFL        CHAIN     DLCFSCD0                           99
     C     *IN99         IFEQ      '1'
     C     DTPR          OREQ      'Y'
     C                   Z-ADD     0             CFLA
     C                   END
      *
      ** Save cash flow amount for the current processing date.
      ** Also save the current deal number.
      *
     C                   Z-ADD     CFLA          XCFLA            13 0
     C                   Z-ADD     DLNO          XDLNO             6 0
      *
     C     IRSCFL        SETGT     DLCFSCD0
     C     IRSCFP        READE     DLCFSCD0                               99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     PRDT          ZDAYNO
     C                   ELSE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   END
      *
      ** Restore saved cash flow amount only if event date in process
      ** is for the current interest period (i.e., it is the first
      ** interest period processing for the deal).
      *
     C     *IN30         IFEQ      '1'
      *
     C                   Z-ADD     XCFLA         CFLA
     C                   END
     C                   MOVE      '0'           *IN30
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S/R #LRATS - Determine next rate change/payment schedule     *
      *                                                               *
      *****************************************************************
     C     #LRATS        BEGSR
     C                   Z-ADD     ZDAYNO        PRDT
     C     IRSDTL        SETGT     DLDTSCD0
     C     IRSDTP        READE     DLDTSCD0                               99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     PRDT          ZDAYNO
     C                   ELSE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   END
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S/R #LINDY - Calculate interest on discount/yield basis      *
      *                                                               *
      *****************************************************************
     C     #LINDY        BEGSR
      *
      ** Interest = Principal ( 1 - 1 / ( 1 + Rate X Number of days/360))
      **          = Principal ( 1 - 360 / ( 360 + Rate X Number of days))
      *
     C     ZICALC        IFEQ      2
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      5
     C     ZICALC        OREQ      7
     C     CIR004        ANDEQ     'Y'
     C                   Z-ADD     36000         ZIWRK3            5 0
     C                   ELSE
     C     ZICALC        IFEQ      1
     C     ZICALC        OREQ      4
     C                   Z-ADD     36500         ZIWRK3
     C                   ELSE
     C                   Z-ADD     36600         ZIWRK3
     C                   END
     C                   END
      *
     C     ZZINDY        MULT      ZIRATE        ZIWRK4           15 7
     C                   ADD       ZIWRK3        ZIWRK4
      *
     C     ZIWRK3        DIV(H)    ZIWRK4        ZIWRK5           15 9
     C     1             SUB       ZIWRK5        ZIWRK5
     C     ZIAMT         MULT(H)   ZIWRK5        ZINTR
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S/R #LEFIN - Update the effective interest rate              *
      *                                                               *
      *****************************************************************
     C     #LEFIN        BEGSR
      *
     C     WSPIN         IFEQ      *BLANK
     C                   Z-ADD     WBRTE         WEINR
     C                   END
      *
     C     WSPIN         IFEQ      'A'
     C     WBRTE         ADD       WRTSP         WEINR
     C                   END
      *
     C     WSPIN         IFEQ      'S'
     C     WBRTE         SUB       WRTSP         WEINR
     C                   END
      *
     C     WSPIN         IFEQ      'P'
     C     WRTSP         DIV       100           WK119
     C     WBRTE         MULT(H)   WK119         WEINR
     C                   ADD       WBRTE         WEINR
     C                   END
      *
     C                   ENDSR
      /EJECT
     C********************************************************************
     C**
     C** INTDUE SR.
     C** PROCEDURE TO CALCULATE INTEREST DUE
     C**
     C*
     C     INTDUE        BEGSR
     C*
     C                   Z-ADD     0             WRKI1            13 0
     C                   Z-ADD     0             WRKI2            13 0
     C                   Z-ADD     0             WRKI3            13 0
     C                   Z-ADD     0             WRKI4            13 0
      *
      ** If interest is paid up front, calculate interest
      ** from the next interest pay date to the one after.
      *
     C     CIR001        IFEQ      'Y'
     C     WINPM         ANDEQ     'D'
     C     CIR001        OREQ      'Y'
     C     WINPM         ANDEQ     'Y'
     C                   Z-ADD     WIACD         ZIBEG
     C                   Z-ADD     WIACD         ZDAYNO
     C                   MOVEL     OURTHR        OTIN
     C                   MOVEL     'P'           RCIP
     C                   EXSR      #LRATS
     C                   Z-ADD     ZDAYNO        ZIEND
     C                   Z-ADD     WICBS         ZICALC
     C                   Z-ADD     WPAMT         ZIAMT
     C*
     C*
     C                   EXSR      GLINTC
     C*
      *
      ** If interest is yield based (method is 'Y')
      *
     C     WINPM         IFEQ      'Y'
     C                   EXSR      #LINDY
     C                   END
     C                   ELSE
     C*
     C** PROCESS GLINTC TO CALCULATE INTEREST AMOUNT
     C*
     C                   Z-ADD     WIACD         ZIBEG
     C                   Z-ADD     WICED         ZIEND
     C                   Z-ADD     WICBS         ZICALC
     C                   Z-ADD     WPAMT         ZIAMT
     C     CIR001        IFNE      'Y'
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     WINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     WINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     WINPM         ANDEQ     'L'
     C                   ADD       WUSI          ZIAMT
     C                   ADD       WUSA          ZIAMT
     C                   END
     C                   EXSR      GLINTC
     C                   ELSE
      *
      ** If frequency is not 'C' for cash flow schedule,
      ** use GLINTC to calculate interest.
      *
     C     WIPFR         IFNE      'C'
      *
      ** Access the previous non-processed record on
      ** principal change schedule.
      *
     C     PCSKEY        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
      *
     C                   Z-ADD     ZIBEG         PRDT
      *
     C     PCSKEY        SETGT     DLPCSCD0
     C                   READP     DLPCSCD0                               85
      *
     C     *IN85         IFEQ      '0'
     C     DTPR          ANDNE     'Y'
     C     PCDLNO        ANDEQ     DLNO
     C     PCOTIN        ANDEQ     OTIN
     C                   MOVE      PAMT          ZIAMT
     C                   ELSE
      *
      ** If interest is capitalised, add the accumulated interest
      **   to the principal.
      *
     C     WINPM         IFEQ      'C'
     C     WINPM         OREQ      'K'
     C     WINPM         OREQ      'A'
     C     CIR006        ANDEQ     'Y'
     C     WINPM         OREQ      'I'
     C     CIR006        ANDEQ     'Y'
      *
     C                   ADD       WWTOI         ZIAMT
      *
     C                   END
      *
     C     CIR002        IFEQ      'Y'
     C     WINPM         OREQ      'A'
     C     CIR006        ANDEQ     'Y'
     C     WINPM         OREQ      'I'
     C     CIR006        ANDEQ     'Y'
     C     WINPM         OREQ      'L'
     C     CIR006        ANDEQ     'Y'
     C                   ADD       WUSI          ZIAMT
     C                   ADD       WUSA          ZIAMT
     C                   END
      *
     C                   END
      *
     C                   EXSR      GLINTC
     C                   ELSE
      *
      ** Determine payment due on next date from cash flow schedule
      *
     C                   MOVEL     OURTHR        OTIN
      *
     C                   Z-ADD     ZIEND         ZDAYNO
     C                   Z-ADD     0             XDLNO
     C                   EXSR      #LCASS
     C                   Z-ADD     CFLA          ZINTR
     C                   END
     C                   END
     C                   END
     C*
     C** CALCULATE ACCRUED INTEREST TO DATE
     C*
     C     ZINTR         ADD(H)    WAITC         WRKI1
     C     WAIAN         ADD       WAIAP         WRKI2
     C     WRKI1         ADD       WRKI2         WRKI3
     C*
     C** ACCR. INT. TO DATE - INT. PAID/RECEIVED TO DATE = INTEREST DUE
     C*
     C     WRKI3         SUB       WIPRD         WRKI4
     C                   Z-ADD     WRKI4         WINTD            13 0
     C*
     C                   ENDSR
      /EJECT
     C********************************************************************
     C**
     C** INTRSX SR.
     C** PROCEDURE TO CALCULATE INTEREST FOR NEXT PERIOD
     C** FOR 'RS' & 'RX' DEALS
     C**
     C*
     C     INTRSX        BEGSR
      *
      ** If interest is paid up front, calculate interest
      ** from the next interest pay date to the one after
      *
     C     CIR001        IFEQ      'Y'
     C     WINPM         ANDEQ     'D'
     C     CIR001        OREQ      'Y'
     C     WINPM         ANDEQ     'Y'
     C                   Z-ADD     WNIPD         WICED
     C                   Z-ADD     WNIPD         ZIBEG
     C                   Z-ADD     WNIPD         ZDAYNO
     C                   MOVEL     OURTHR        OTIN
     C                   MOVEL     'P'           RCIP
     C                   EXSR      #LRATS
     C                   Z-ADD     ZDAYNO        ZIEND
     C                   Z-ADD     WICBS         ZICALC
     C                   Z-ADD     WPAMT         ZIAMT
     C                   Z-ADD     WEINR         ZIRATE
     C*
     C                   EXSR      GLINTC
     C*
      *
      ** If interest is yield based
      *
     C     WINPM         IFEQ      'Y'
     C                   EXSR      #LINDY
     C                   END
     C                   ELSE
     C*
     C** SET START AND END DATES FOR INTEREST CALCULATION.
     C** START DATE = PREVOIUS END DATE,
     C** END DATE = EARLIER OF NEXT CHANGE & PAYMENT DATES
     C*
     C                   Z-ADD     WICED         ZIBEG
     C     WNIPD         IFGT      WNICD
     C                   Z-ADD     WNICD         WICED
     C                   ELSE
     C                   Z-ADD     WNIPD         WICED
     C                   END
      *
      ** Set interest calculation end date to interest payment base
      ** date if CIR005 is switched on and amount code is actual
      *
     C     CIR005        IFEQ      'Y'
     C     ZFREQ         ANDNE     'Z'
     C     WAMCN         ANDEQ     'A'
     C     WNIPD         ANDLE     WNICD
     C     WIPBD         ANDNE     0
     C                   Z-ADD     WIPBD         WICED
     C                   ENDIF
      *
     C                   Z-ADD     WICED         ZIEND
      *
      ** If interest payment frequency is 'C', add cashflow amount
      ** to interest due.
      *
     C     CIR001        IFEQ      'Y'
     C     WIPFR         ANDEQ     'C'
     C                   Z-ADD     CFLA          ZINTR
     C                   ELSE
     C*
     C** CALCULATE INTEREST AMOUNT AND ADD TO INTEREST DUE
     C*
     C                   Z-ADD     WICBS         ZICALC
     C                   Z-ADD     WPAMT         ZIAMT
     C     CIR001        IFEQ      'Y'
      *
      ** Access the previous non-processed record on
      ** principal change schedule.
      *
     C                   MOVEL     OURTHR        OTIN
     C                   Z-ADD     ZIBEG         PRDT
      *
     C     PCSKEY        SETGT     DLPCSCD0
     C                   READP     DLPCSCD0                               85
      *
     C     *IN85         IFEQ      '0'
     C     DTPR          ANDNE     'Y'
     C     PCDLNO        ANDEQ     DLNO
     C     PCOTIN        ANDEQ     OTIN
     C                   MOVE      PAMT          ZIAMT
     C                   ELSE
      *
      ** If interest is capitalised, add the accumulated interest
      **   to the principal.
      *
     C     WINPM         IFEQ      'C'
     C     WINPM         OREQ      'K'
     C     WINPM         OREQ      'A'
     C     CIR006        ANDEQ     'Y'
     C     WINPM         OREQ      'I'
     C     CIR006        ANDEQ     'Y'
     C                   ADD       WWTOI         ZIAMT
     C                   END
      *
     C     CIR002        IFEQ      'Y'
     C     WINPM         OREQ      'A'
     C     CIR006        ANDEQ     'Y'
     C     WINPM         OREQ      'I'
     C     CIR006        ANDEQ     'Y'
     C     WINPM         OREQ      'L'
     C     CIR006        ANDEQ     'Y'
     C                   ADD       WUSI          ZIAMT
     C                   ADD       WUSA          ZIAMT
     C                   END
     C                   END
     C                   ELSE
     C     CIR002        IFEQ      'Y'
     C                   ADD       WUSI          ZIAMT
     C                   ADD       WUSA          ZIAMT
     C                   END
     C                   END
     C                   Z-ADD     WEINR         ZIRATE
     C                   EXSR      GLINTC
     C                   END
     C                   END
     C*
     C     ZINTR         ADD(H)    WINTD         WINTD
     C*
     C                   ENDSR
     C*
      /EJECT
     C********************************************************************
     C**
     C** OUR SR.
     C** PROCEDURE TO MOVE 'OUR' DETAILS TO WORK FIELDS
     C**
     C*
     C     OUR           BEGSR
     C*
     C                   MOVE      UCUCY         WCUCY             3
     C                   MOVE      PSCY          WSETCY            3
     C                   Z-ADD     UPAMT         WPAMT            13 0
     C                   Z-ADD     UBRTT         WBRTT             2 0
     C                   Z-ADD     UBRTE         WBRTE            11 7
     C                   Z-ADD     URTSP         WRTSP            11 7
     C                   Z-ADD     UEINR         WEINR            11 7
     C                   MOVE      USPIN         WSPIN             1
     C                   Z-ADD     UICBS         WICBS             1 0
     C                   Z-ADD     UINFD         WINFD             5 0
     C                   Z-ADD     UNICD         WNICD             5 0
     C                   Z-ADD     UICBD         WICBD             5 0
     C                   MOVE      UICFR         WICFR             1
     C                   Z-ADD     UICFD         WICFD             2 0
     C                   Z-ADD     UNIPD         WNIPD             5 0
     C                   Z-ADD     UIPBD         WIPBD             5 0
     C                   MOVE      UIPFR         WIPFR             1
     C                   Z-ADD     UIPFD         WIPFD             2 0
     C                   Z-ADD     UIACD         WIACD             5 0
     C                   Z-ADD     UAITC         WAITC            13 0
     C                   Z-ADD     UAIAN         WAIAN            13 0
     C                   Z-ADD     UAIAP         WAIAP            13 0
     C                   Z-ADD     UIPRD         WIPRD            13 0
     C                   MOVE      UDNSI         WDNSI             1
     C                   MOVE      UDSTI         WDSTI             1
     C                   Z-ADD     UFRFD         WFRFD             2 0
      *
     C                   Z-ADD     PSETM         WSETM             2 0
     C                   MOVE      UPACC         WPACC            12
     C                   MOVE      POBR          WSBR              3
      *
     C                   EXSR      LOCN
      *
      ** Initialise total amount of interest for capitalised interest.
      *
     C                   Z-ADD     0             WWTOI            15 0
     C                   MOVE      'U'           OURTHR            1
     C                   MOVE      UINPM         WINPM             1
      *
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     OUSI          WUSI             15 0
     C                   Z-ADD     OUSA          WUSA             15 0
     C                   END
      *
      ** Save payment convention -leg 1 details if CIR005 is on
      *
     C     CIR005        IFEQ      'Y'
     C                   MOVE      L1PDCN        WPDCN             2
     C                   MOVE      L1AMCN        WAMCN             2
     C                   MOVE      L1CYP1        WCYP1             3
     C                   MOVE      L1CYP2        WCYP2             3
     C                   MOVE      L1CYP3        WCYP3             3
     C                   MOVE      L1CYP4        WCYP4             3
     C                   MOVE      L1CYP5        WCYP5             3
     C                   MOVE      L1CYP6        WCYP6             3
     C                   MOVE      L1CYP7        WCYP7             3
     C                   MOVE      L1CYP8        WCYP8             3
     C                   MOVE      L1CYP9        WCYP9             3
     C                   MOVE      L1CYP0        WCYP0             3
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
     C********************************************************************
     C**
     C** THEIR SR.
     C** PROCEDURE TO MOVE 'THEIR' DETAILS TO WORK FIELDS
     C**
     C*
     C     THEIR         BEGSR
     C*
     C                   MOVE      TCUCY         WCUCY             3
     C                   MOVE      RSCY          WSETCY
     C                   Z-ADD     TPAMT         WPAMT            13 0
     C                   Z-ADD     TBRTT         WBRTT             2 0
     C                   Z-ADD     TBRTE         WBRTE            11 7
     C                   Z-ADD     TRTSP         WRTSP            11 7
     C                   Z-ADD     TEINR         WEINR            11 7
     C                   MOVE      TSPIN         WSPIN             1
     C                   Z-ADD     TICBS         WICBS             1 0
     C                   Z-ADD     TINFD         WINFD             5 0
     C                   Z-ADD     TNICD         WNICD             5 0
     C                   Z-ADD     TICBD         WICBD             5 0
     C                   MOVE      TICFR         WICFR             1
     C                   Z-ADD     TICFD         WICFD             2 0
     C                   Z-ADD     TNIPD         WNIPD             5 0
     C                   Z-ADD     TIPBD         WIPBD             5 0
     C                   MOVE      TIPFR         WIPFR             1
     C                   Z-ADD     TIPFD         WIPFD             2 0
     C                   Z-ADD     TIACD         WIACD             5 0
     C                   Z-ADD     TAITC         WAITC            13 0
     C                   Z-ADD     TAIAN         WAIAN            13 0
     C                   Z-ADD     TAIAP         WAIAP            13 0
     C                   Z-ADD     TIPRD         WIPRD            13 0
     C                   MOVE      TDNSI         WDNSI             1
     C                   MOVE      TDSTI         WDSTI             1
     C                   Z-ADD     TFRFD         WFRFD             2 0
     C*
     C                   Z-ADD     RSETM         WSETM             2 0
     C                   MOVE      URACC         WPACC            12
     C                   MOVE      ROBR          WSBR              3
      *
     C                   EXSR      LOCN
      *
      ** Initialise total amount of interest for capitalised interest.
      *
     C                   Z-ADD     0             WWTOI
      *
     C                   MOVE      'T'           OURTHR            1
     C                   MOVE      TINPM         WINPM             1
      *
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     TUSI          WUSI             15 0
     C                   Z-ADD     TUSA          WUSA             15 0
     C                   END
      *
      ** Save the following payment convention details
      *
     C     CIR005        IFEQ      'Y'
      *
     C     DTYP          IFEQ      'RX'
      *
     C                   MOVE      L2PDCN        WPDCN
     C                   MOVE      L2AMCN        WAMCN
     C                   MOVE      L2CYP1        WCYP1
     C                   MOVE      L2CYP2        WCYP2
     C                   MOVE      L2CYP3        WCYP3
     C                   MOVE      L2CYP4        WCYP4
     C                   MOVE      L2CYP5        WCYP5
     C                   MOVE      L2CYP6        WCYP6
     C                   MOVE      L2CYP7        WCYP7
     C                   MOVE      L2CYP8        WCYP8
     C                   MOVE      L2CYP9        WCYP9
     C                   MOVE      L2CYP0        WCYP0
      *
     C                   ELSE
      *
     C                   MOVE      L1PDCN        WPDCN
     C                   MOVE      L1AMCN        WAMCN
     C                   MOVE      L1CYP1        WCYP1
     C                   MOVE      L1CYP2        WCYP2
     C                   MOVE      L1CYP3        WCYP3
     C                   MOVE      L1CYP4        WCYP4
     C                   MOVE      L1CYP5        WCYP5
     C                   MOVE      L1CYP6        WCYP6
     C                   MOVE      L1CYP7        WCYP7
     C                   MOVE      L1CYP8        WCYP8
     C                   MOVE      L1CYP9        WCYP9
     C                   MOVE      L1CYP0        WCYP0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
     C**************************************************************************
      /EJECT
     C********************************************************************
     C**
     C** NXTIPD SR.
     C** PROCEDURE TO CALCULATE NEXT INTEREST PAYMENT DATE &
     C** INTEREST PAYMENT BASE DATE
     C**
     C*
     C     NXTIPD        BEGSR
     C*
     C** IF INTEREST PAYMENT FREQUENCY IS NON-BLANK, PROCESS @FREQB &
     C** ZFWDT TO CALCULATE NEXT PAYMENT DATE
     C*
     C     WIPFR         IFNE      ' '
     C                   MOVE      WIPFR         ZFREQ
     C                   Z-ADD     WIPBD         ZDAYNO
     C                   Z-ADD     WIPFD         ZMDAY
      *
     C     CIR005        IFEQ      'N'
     C     ZFREQ         OREQ      'Z'
     C     ZFREQ         OREQ      'C'
     C     WCYP1         OREQ      *BLANK
      *
     C     CIR001        IFNE      'Y'
     C                   EXSR      @FREQB
     C                   Z-ADD     ZDAYNO        CDAT              5 0
     C*
     C                   EXSR      ZFWDT
     C*
     C                   Z-ADD     ZDYNBR        ZDAT              5 0
     C                   ELSE
      *
      ** If frequency is not 'Z' and not 'C',
      ** use @FREQB to calculate next payment date.
      *
     C     ZFREQ         IFNE      'Z'
     C     ZFREQ         IFNE      'C'
     C                   EXSR      @FREQB
     C                   Z-ADD     ZDAYNO        CDAT              5 0
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        ZDAT              5 0
     C                   ELSE
      *
      ** If frequency is 'C' for cash flow schedule
      *
     C                   MOVEL     OURTHR        OTIN
     C                   EXSR      #LCASS
     C                   Z-ADD     ZDAYNO        CDAT
     C                   Z-ADD     ZDAYNO        ZDAT
     C                   END
     C                   ELSE
      *
      ** If frequency is 'Z', determine next date from schedule.
      *
     C                   MOVEL     OURTHR        OTIN
     C                   MOVEL     'P'           RCIP
     C                   EXSR      #LRATS
     C                   Z-ADD     ZDAYNO        CDAT
     C                   Z-ADD     ZDAYNO        ZDAT
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C                   EXSR      ZFRQB3
      *
      ** Adjust date according to payment date convention currencies
      *
     C                   CALL      'DLZIRP'
     C                   PARM                    ZDAYNO
     C                   PARM                    PCURR             3
     C                   PARM      WPDCN         PPDCN             2
     C                   PARM                    ZLOC
     C                   PARM                    BJDFIN
     C                   PARM                    PAJDT             5 0
     C                   PARM                    PBSDT             5 0
      *
     C                   Z-ADD     PBSDT         CDAT
     C                   Z-ADD     PAJDT         ZDAT
      *
      ** Do not return adjusted date if it is equal to or earlier than
      ** previous date (only happens for 'previous' date calculations);
      ** instead use the base date
      *
     C     WIPBD         IFGE      ZDAT
     C                   Z-ADD     PBSDT         ZDAT
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C** IF DATE OUTPUT FROM ZFWDT IS < MATURITY DATE,
     C** SET NEXT INTEREST PAYMENT DATE TO THIS DATE &
     C** SET INTEREST PAYMENT BASE DATE TO DATE OUTPUT FROM @FREQB.
     C** IF NOT, SET BOTH DATES TO MATURITY DATE
     C*
     C     ZDAT          IFLT      MDAT
     C     CDAT          ANDLE     MDAT
     C                   Z-ADD     CDAT          WIPBD
     C                   Z-ADD     ZDAT          WNIPD
     C                   ELSE
     C                   Z-ADD     MDAT          WIPBD
     C                   Z-ADD     MDAT          WNIPD
     C                   END
     C*
     C** IF INTEREST PAYMENT FREQUENCY IS BLANK,
     C** SET BOTH DATES TO MATURITY DATE
     C*
     C                   ELSE
     C                   Z-ADD     MDAT          WIPBD
     C                   Z-ADD     MDAT          WNIPD
     C                   END
     C*
     C                   ENDSR
     C*
     C**************************************************************************
      /EJECT
     C********************************************************************
     C**
     C** NXTICD SR.
     C** PROCEDURE TO CALCULATE NEXT INTEREST CHANGE DATE,
     C** INTEREST CHANGE BASE DATE AND TO SET NEW EFFECTIVE INT. RATE
     C**
     C*
     C     NXTICD        BEGSR
     C*
     C** IF INTEREST CHANGE FREQUENCY IS NON-BLANK, PROCESS @FREQB &
     C** ZFWDT TO CALCULATE NEXT CHANGE DATE
     C*
     C     WICFR         IFNE      ' '
     C                   MOVE      WICFR         ZFREQ
     C                   Z-ADD     WICBD         ZDAYNO
     C                   Z-ADD     WICFD         ZMDAY
      *
     C     CIR005        IFEQ      'N'
     C     ZFREQ         OREQ      'Z'
     C     ZFREQ         OREQ      'C'
     C     WCYP1         OREQ      *BLANK
      *
     C     CIR001        IFNE      'Y'
     C                   EXSR      @FREQB
     C                   Z-ADD     ZDAYNO        CDAT              5 0
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        ZDAT              5 0
     C                   ELSE
      *
      ** If frequency is not 'Z', use @FREQB to calculate next date.
      *
     C     ZFREQ         IFNE      'Z'
     C                   EXSR      @FREQB
     C                   Z-ADD     ZDAYNO        CDAT              5 0
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        ZDAT              5 0
     C                   ELSE
      *
      ** If frequency is 'Z', determine next date from schedule.
      *
     C                   MOVEL     OURTHR        OTIN
     C                   MOVEL     'R'           RCIP
     C                   EXSR      #LRATS
     C                   Z-ADD     ZDAYNO        CDAT
     C                   Z-ADD     ZDAYNO        ZDAT
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C                   EXSR      ZFRQB3
      *
      ** Adjust date according to payment date convention currencies
      *
     C                   CALL      'DLZIRP'
     C                   PARM                    ZDAYNO
     C                   PARM                    PCURR
     C                   PARM      WPDCN         PPDCN
     C                   PARM                    ZLOC
     C                   PARM                    BJDFIN
     C                   PARM                    PAJDT
     C                   PARM                    PBSDT
      *
     C                   Z-ADD     PBSDT         CDAT
     C                   Z-ADD     PAJDT         ZDAT
      *
      ** Do not return adjusted date if it is equal to or earlier than
      ** previous date (only happens for 'previous' date calculations);
      ** instead use the base date
      *
     C     WICBD         IFGE      ZDAT
     C                   Z-ADD     PBSDT         ZDAT
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C** IF DATE OUTPUT FROM ZFWDT IS < MATURITY DATE,
     C** SET NEXT INTEREST CHANGE DATE TO THIS DATE &
     C** SET INTEREST CHANGE BASE DATE TO DATE OUTPUT FROM @FREQB.
     C** IF NOT, SET BOTH DATES TO MATURITY DATE
     C*
     C     ZDAT          IFLT      MDAT
     C                   Z-ADD     CDAT          WICBD
     C                   Z-ADD     ZDAT          WNICD
     C                   ELSE
     C                   Z-ADD     MDAT          WICBD
     C                   Z-ADD     MDAT          WNICD
     C                   END
     C*
     C** IF INTEREST CHANGE FREQUENCY IS BLANK,
     C** SET BOTH DATES TO MATURITY DATE
     C*
     C                   ELSE
     C                   Z-ADD     MDAT          WICBD
     C                   Z-ADD     MDAT          WNICD
     C                   END
     C*
     C** IF PROCESSING PROVIDER'S DETAILS, APPLY SPREAD/RATE TO BASE
     C** RATE TO GET EFFECTIVE INTEREST RATE. IF NOT, EIR = SPREAD/RATE
     C*
     C     WBRTT         IFNE      0
     C*
     C     WSPIN         IFEQ      *BLANK
     C                   Z-ADD     WBRTE         WEINR            11 7
     C                   END
     C*
     C     WSPIN         IFEQ      'A'                                          ** ADD **
     C     WBRTE         ADD       WRTSP         WEINR
     C                   END
     C*
     C     WSPIN         IFEQ      'S'                                          ** SUBTRACT **
     C     WBRTE         SUB       WRTSP         WEINR
     C                   END
     C*
     C     WSPIN         IFEQ      'P'                                          ** PERCENTAGE **
     C     WRTSP         DIV       100           WK119            11 9
     C     WBRTE         MULT(H)   WK119         WEINR
     C                   ADD       WBRTE         WEINR
     C                   END
     C*
     C                   ELSE
     C                   Z-ADD     WRTSP         WEINR
     C                   END
     C*
     C** IF NEGATIVE INTEREST IND. IS ON, REVERSE SIGN OF EIR
     C*
     C                   TESTB     '1'           WDSTI                    13     NEG INTEREST IND
     C     *IN13         IFEQ      '1'
     C                   Z-SUB     WEINR         WEINR
     C                   END
      *
      * Extract Rate Change event for HOR FETAS extract
      *
     C     WNICD         IFLT      MDAT
     C                   EXSR      OUTTAS
     C                   ENDIF
      *
     C                   ENDSR
     C*
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTINT - Output Interest Payment                             *
      *                                                               *
      *  Called By: SELECT                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     OUTINT        BEGSR
      *
     C                   CLEAR                   DLMFEVP0
      *
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      OURTHR        HRCDT
     C                   MOVE      'INT'         HOUTF
     C                   Z-ADD     WNIPD         HEDAT
     C     HEDAT         IFLE      WLIMDT
     C                   Z-ADD     WINTD         HEAMT
     C                   ENDIF
     C                   MOVE      WIPFR         HIPFR
      *
     C                   WRITE     DLMFEVP0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTTAS - Output Interest Rate Change                         *
      *                                                               *
      *  Called By: SELECT                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     OUTTAS        BEGSR
      *
     C                   CLEAR                   DLMFEVP0
      *
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      OURTHR        HRCDT
     C                   MOVE      'TAS'         HOUTF
     C                   Z-ADD     WNICD         HEDAT
     C                   MOVE      WBRTT         HBRTT
     C                   Z-ADD     WRTSP         HRTSP
     C     HEDAT         IFLT      WLIMDT
     C                   Z-ADD     WEINR         HINTR
     C                   ENDIF
     C                   MOVE      WSPIN         HSPIN
     C     WFRFD         IFNE      *ZERO
     C                   Z-ADD     WNICD         ZDAYNO
     C                   Z-ADD     WFRFD         ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        HINFD
     C                   ENDIF
     C                   Z-ADD     WFRFD         HFRFD
     C                   MOVE      WICFR         HICFR
      *
     C                   WRITE     DLMFEVP0
      *
     C                   ENDSR
      /EJECT
     C********************************************************************
     C**
     C** DATSET SR.
     C** PROCEDURE TO SET UP DATES FOR SETTLEMENT EVENTS PROCESSING
     C**
     C*
     C     DATSET        BEGSR
     C*
     C                   MOVE      'N'           WRTFL             1
      **********                                                                              246852
     C***IF*NEXT INTEREST PAYMENT & CHANGE DATES ARE BOTH BLANK,                              246852
     C***SET*THEM TO MATURITY DATE                                                            246852
     C**********                                                                              246852
     C********** WNIPD     IFEQ 0                                                             246852
     C********** WNICD     IFEQ 0                                                             246852
     C**********           Z-ADDMDAT      WNIPD                                               246852
     C**********           Z-ADDMDAT      WNICD                                               246852
     C**********                                                                              246852
     C***IF*NEXT INTEREST PAYMENT DATE IS BLANK & CHANGE DATE IS NOT,                         246852
     C***SET*PAYMENT DATE, FREQUENCY & DAY NO. TO THOSE FOR CHANGE DATE                       246852
     C**********                                                                              246852
     C**********           ELSE                                                               246852
     C**********           Z-ADDWNICD     WNIPD                                               246852
     C**********           MOVE WICFR     WIPFR                                               246852
     C**********           Z-ADDWICFD     WIPFD                                               246852
     C**********           Z-ADDWICBD     WIPBD                                               246852
     C**********           MOVE 'Y'       WRTFL                                               246852
     C**********           END                                                                246852
     C**********                                                                              246852
     C***IF*NEXT INTEREST CHANGE DATE IS BLANK & PAYMENT DATE IS NOT,                         246852
     C***SET*CHANGE DATE TO MATURITY DATE                                                     246852
     C**********                                                                              246852
     C**********           ELSE                                                               246852
     C********** WNICD     IFEQ 0                                                             246852
     C**********           Z-ADDMDAT      WNICD                                               246852
     C**********           END                                                                246852
     C**********           END                                                                246852
     C     WNIPD         IFEQ      0
     C                   Z-ADD     MDAT          WNIPD
     C                   ENDIF
     C     WNICD         IFEQ      0
     C                   Z-ADD     MDAT          WNICD
     C                   ENDIF
     C*
     C** SET INTEREST CALCULATION END DATE TO THE EARLIER OF
     C** NEXT INTERST CHANGE DATE & NEXT INTEREST PAYMENT DATE
     C*
     C     WNIPD         IFGT      WNICD
     C                   Z-ADD     WNICD         WICED             5 0
     C                   ELSE
     C                   Z-ADD     WNIPD         WICED
     C                   END
      *
      ** Set interest calculation end date to the earlier of interest
      ** payment base date & interest rate change base date if
      ** is switched on
      *
     C     CIR005        IFEQ      'Y'
     C     WIPFR         ANDNE     'Z'
     C     WAMCN         ANDEQ     'A'
     C     WNIPD         ANDLE     WNICD
     C     WIPBD         ANDNE     0
     C     WRTFL         ANDNE     'Y'
     C                   Z-ADD     WIPBD         WICED
     C                   ENDIF
     C*
     C                   ENDSR
     C*
      /EJECT
      ********************************************************************
      **
      ** LOCN SR
      ** PROCEDURE TO DETERMINE LOCATION CODE
      **
      *
      *   CALLS       :
      *
      ********************************************************************
     C     LOCN          BEGSR
      *
     C                   MOVEL     WPACC         WRK2              2
     C                   MOVE      WSETM         @NSETM            1 0
     C* Ensure settlement currency is used where appropriate for calls
     C*  to AONOSTRO, sr/@FREQB (similar to sr/ZFREQB), sr/ZFWDT.
     C*
     C     CEU003        IFEQ      'Y'
     C     WSETCY        ANDNE     *BLANKS
     C                   MOVE      WSETCY        WRK3
     C                   ELSE
     C                   MOVE      WCUCY         WRK3              3
     C                   ENDIF
      *
      ** If Settlement method NOT = Previous settlement method
      ** OR          Currency NOT = Previous Currency
      ** OR       Nostro code NOT = Previous Nostro code
      ** Set up new location code
     C     @NSETM        IFNE      @SETM
     C     WRK3          ORNE      @CUCY
     C     WRK2          ORNE      @WRK2
     C                   MOVE      WRK3          @CUCY             3
     C                   MOVE      @NSETM        @SETM             1 0
     C                   MOVE      WRK2          @WRK2             2
      *
      ** If settlement method is via a nostro
     C     @SETM         IFEQ      01
     C     @SETM         OREQ      02
     C     @SETM         OREQ      07
     C     @SETM         OREQ      08
     C     @SETM         OREQ      12
      *
      ** If Nostro Code not blank...set up location.
     C     @WRK2         IFNE      *BLANKS
      *
      ** Call ACCESS program to get NOSTRO record
     C*                    CALL 'AONOSTR0'                                               LUC013
     C*                    PARM '*MSG   ' @RTCD                                          LUC013
     C*                    PARM '*KEY   ' @OPTN                                          LUC013
     C*                    PARM *BLANK    @CUST   6        Customer No.                  LUC013
     C*                    PARM @CUCY     @CCY    3        Currency                      LUC013
     C*                    PARM *BLANKS   @ACCD   4        A/C Code                      LUC013
     C*                    PARM *BLANKS   @ACSN   2        A/C Seq                       LUC013
     C*                    PARM @WRK2     @NOST   2        Nostro No.                    LUC013
     C*                    PARM *BLANKS   @BRCD   3        Branch Code                   LUC013
     C*                    PARM *BLANKS   @CSSN  10        Cust. Shortname               LUC013
     C*                    PARM *BLANKS   @PNOI   1        Prime Nost. Ind               LUC013
     C*          SDNOST    PARM SDNOST    DSFDY                                          LUC013
      *                                                                                  LUC013
      ** If database error, return to calling program                                    LUC013
     C****       @RTCD     IFNE *BLANK                                                   LUC013
      *                                                                                  LUC013
     C     SDNOS         CHAIN     SDNOSTL1                           20
     C     *IN20         IFEQ      *OFF
      *                                                                                  LUC013
      ** Set ZLOC to Nostro location
     C                   MOVE      A7NOSN        ZLOC
     C                   ELSE
      *                                                                                  LUC013
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDNOSTPD'    DBFILE                         ************
     C                   Z-ADD     9             DBASE                          * DBERR 09 *
     C                   MOVEL     @OPTN         DBOPTN            7            ************
     C                   MOVE      @CUCY         @KEY              5
     C                   MOVEL     @WRK2         @KEY
     C                   MOVE      @KEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Else if Nostro code blank set ZLOC to blanks
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   END
      *
      ** Set ZCCY to Deal Currency
     C                   MOVE      @CUCY         ZCCY
      *
      ** Else if not settled via a Nostro
      ** set ZLOC to System Location & ZCCY to local currency
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   MOVE      BJLCCY        ZCCY
     C                   END
      *
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C**
     C**   @FREQB - SR. TO INCREMENT A DAY NUMBER DATE BY A
     C**             PERIOD VALUE DETERMINED BY A CODE.
     C**
     C     @FREQB        BEGSR                                                  *** @FREQB ***
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ZFREQ         ZFREQ             1
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   Z-ADD     ZMDAY         ZMDAY             2 0
     C                   MOVE      ZCCY          ZCCY              3
     C**
     C                   MOVE      ' '           ZTABKY           12
     C*
     C*            FIELDS USED FOR PERIOD CODES M,T,Q,X,Y
     C*
     C                   MOVE      '  '          ZINDE             2
     C                   Z-ADD     0             ZINTO             2 0
     C**
     C**   CONVERT DAY NUMBER TO DATE.
     C                   EXSR      ZDATE2
     C                   SETOFF                                       90
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE D-DAILY-WORKING DAY.
     C     ZFREQ         COMP      'D'                                    91
     C   91ZDAYNO        ADD       1             ZDAYNO
     C   91              GOTO      ZFHCHK
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE W-WEEKLY.
     C     ZFREQ         COMP      'W'                                    91
     C   91ZDAYNO        ADD       7             ZDAYNO
     C   91              GOTO      ZFEND
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE F-FORTNIGHTLY.
     C     ZFREQ         COMP      'F'                                    91
     C   91ZDAYNO        ADD       14            ZDAYNO
     C   91              GOTO      ZFEND
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE S-SEMI-MONTHLY.
     C     ZFREQ         COMP      'S'                                    91
     C   91ZDAY          COMP      15                                 939292
     C   91
     CAN 92              Z-ADD     31            ZDAY
     C   91
     CAN 93              Z-ADD     15            ZDAY
     C   91
     CAN 93ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.
     C     ZFREQ         COMP      'M'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE R-SIX DAYS BEFORE END OF MONTH
     C     ZFREQ         COMP      'R'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE T-BIMONTHLY.
     C     ZFREQ         COMP      'T'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       2             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.
     C     ZFREQ         COMP      'Q'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       3             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE X-SIX MONTHLY.
     C     ZFREQ         COMP      'X'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       6             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.
     C     ZFREQ         COMP      'Y'                                    91
     C   91              MOVE      'IN'          ZINDE
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZYEAR         ADD       1             ZYEAR
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE L-LAST CALENDAR DAY OF MONTH.
     C     ZFREQ         COMP      'L'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.
     C     ZFREQ         COMP      'B'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.
     C     ZFREQ         COMP      'A'                                    91
      *
      ** Since the GENERAL LEDGER file needs to be called only once,
      ** the file is called at the start of the program.
      *
     C   91              Z-ADD     BKAPDT        ZDAYNO
     C                   GOTO      ZFEND
     C**
     C**
     C**   REFORMAT DATE AND ENSURE VALID.
     C     ZFDATE        TAG                                                    ** ZFDATE TAG*
     C**
     C**   VALIDATE MONTH.
     C     ZMTH          COMP      12                                 91
     C   91ZMTH          SUB       12            ZMTH
     C   91ZYEAR         ADD       1             ZYEAR
     C**
     C**   CHECK FOR LEAP YEAR.
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0    92    LEAP YEAR-92 ON
     C**
     C**   VALIDATE DAY NUMBER.
     C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
     C     ZMTH          COMP      2                                      93
     C   92
     CAN 93              Z-ADD     29            ZWRK2
     C**
     C     ZDAY          COMP      ZWRK2                              94
     C   94              Z-ADD     ZWRK2         ZDAY
     C**
     C**   CHECK IF CODE R, TO SUBTRACT 6 DAYS.
     C     ZFREQ         COMP      'R'                                    91
     C   91ZDAY          SUB       6             ZDAY
     C**
     C**   REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.
     C                   MOVEL     ZDAY          ZWRK4             4 0
     C                   MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C   98              MOVE      ZDAY          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C                   EXSR      ZDATE1
     C**
     C**   CHECK IF CODE B, OR M,T,Q,X,Y TO BE CHECKED FOR HOLIDAY.
     C     ZFREQ         COMP      'B'                                    91
     C     ZINDE         COMP      'IN'                                   92
     C*
     C*
     C   92
     CANN99
     COR 91
     CANN99              GOTO      ZFHCHK
     C**
     C*
     C*
     C                   GOTO      ZFEND
     C**
     C**   CHECK IF DAY NUMBER IS A HOLIDAY.
     C**
     C     ZFHCHK        TAG                                                    ** ZFHCHK TAG *
     C                   SETOFF                                       94
     C     ZFREQ         COMP      'D'                                    91
     C     ZFREQ         COMP      'B'                                    92
     C   91
     COR 92              GOTO      ZSETK
     C*
     C*   FOR CODES M,T,Q,X,Y, CHECK ZINDE - 'IN' TO INCREMENT,
     C*                                    - 'DE' TO DECREMENT
     C*
     C     ZINDE         COMP      'IN'                                   90
     C     ZINDE         COMP      'IN'                                   91
     C     ZINDE         COMP      'DE'                                   92
     C**
     C     ZSETK         TAG                                                    ** ZSETK TAG **
3849 C*
     C                   EXSR      ZCHKH
     C*
3854 C*    CHECK IF CURRENCY ON HOLIDAY.
     C*
     C     ZIND          CABEQ     'W'           ZFEND
     C**
     C   92              GOTO      ZDECR
     C*
     C**   INCREMENT OR DECREMENT DAY NUMBER AS REQUIRED.
     C   91ZDAYNO        ADD       1             ZDAYNO
     C*
     C*    ONLY FOR PERIOD CODE = M,T,Q,X OR Y, IF INCREMENTATION
     C*    TAKES THE OUTPUT DATE INTO THE FOLLOWING MONTH, RETURN TO
     C*    THE INPUT DATE AND DECREMENT - 92 ON.
     C*
     C   90
     CAN 91ZINTO         ADD       1             ZINTO
     C   90
     CAN 91ZINTO         ADD       ZDAY          ZINTOT            2 0
     C   90
     CAN 91              MOVE      ZINTOT        ZINTOA            2
     C**TO ALLOW 29 FEB ON LEAP YEARS TO PASS
     C                   SETOFF                                       93
     C   90
     CAN 91ZYEAR         DIV       4             ZLYR
     C   90
     CAN 91              MVR                     ZLY                      92
     C   90
     CAN 91
     CAN 92ZMTH          COMP      2                                      93
     C   93ZINTOA        COMP      '29'                               92
     C   90
     CAN 91
     CANN93ZINTOA        COMP      ZFMD(ZMTH)                         92
     C   90
     CAN 91
     CAN 92ZDAYNO        SUB       ZINTO         ZDAYNO
     C   90
     CAN 91
     CAN 92              MOVE      'DE'          ZINDE
     C**
     C     ZDECR         TAG                                                    ** ZDECR TAG **
3880 C   92ZDAYNO        SUB       1             ZDAYNO
     C                   GOTO      ZFHCHK
     C**
     C**
     C     ZFEND         ENDSR                                                  * ZFEND ENDSR *
     C**
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
     C*
     C     IRSDTL        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C                   KFLD                    PRDT
      *
     C     IRSDTP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
      *
     C     IRSCFL        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
      *
     C     IRSCFP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
      *
     C     SDNOS         KLIST
     C                   KFLD                    @CUCY
     C                   KFLD                    @WRK2
      *                                                                                  LUC013
      ** Obtain BANK details via ACCESS PROGRAM
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** INITIAL PROCESSING
      *
     C     BJDFIN        COMP      'M'                                    98
      *
      ** Access AOSARDR0 to check if CIR001 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR001            1
     C                   ELSE
     C                   MOVE      'N'           CIR001
     C                   END
      *
      ** Access AOSARDR0 to check if CIR002 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CIR002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR002            1
     C                   ELSE
     C                   MOVE      'N'           CIR002
     C                   END
      *
      ** Access Switchable Features Details
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CIR004'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR004            1
     C                   ELSE
     C                   MOVE      'N'           CIR004
     C                   ENDIF
      *
      ** Check if switchable feature CIR005 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     14            DBASE                          * DBERR 14 *
     C                   MOVEL     'CIR005'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR005            1
     C                   ELSE
     C                   MOVE      'N'           CIR005
     C                   ENDIF
      *
      ** Determine if SAR CIR006 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      'CIR006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     15            DBASE
     C                   MOVEL     'CIR006'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR006            1
     C                   ELSE
     C                   MOVE      'N'           CIR006
     C                   ENDIF
      *
      ** Determine if SAR CEU003 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      'CEU003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     17            DBASE
     C                   MOVEL     'CEU003'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU003            1
     C                   ELSE
     C                   MOVE      'N'           CEU003
     C                   ENDIF
      *
     C                   ENDSR
     C**************************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  SR.    Abnormal termination processing                *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     *PSSR         BEGSR
      *                                                               *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   RETURN
     C                   END
      *
     C                   ENDSR
     C*
     C********************************************************************
     C*COPY*ZSRSRC,GLINTCZ1****                                                     LUC109
     C/COPY ZSRSRC,GLINTCZ1LE                                                       LUC109
     C*COPY*ZSRSRC,ZACCH*******                                                     LUC109
     C/COPY ZSRSRC,ZACCHLE                                                          LUC109
     C*COPY*ZSRSRC,ZCHKH*******                                                     LUC109
     C/COPY ZSRSRC,ZCHKHLE                                                          LUC109
     C*COPY*ZSRSRC,ZFWDT*******                                                     LUC109
     C/COPY ZSRSRC,ZFWDT_ILE                                                        LUC109
     C*COPY*ZSRSRC,ZBKDT*******                                                     LUC109
     C/COPY ZSRSRC,ZBKDT_ILE                                                        LUC109
     C*COPY*ZSRSRC,ZFRQB3******                                                     LUC109
     C/COPY ZSRSRC,ZFRQB3_ILE                                                       LUC109
     C*COPY*ZSRSRC,ZDATE1Z2****                                                     LUC109
     C/COPY ZSRSRC,ZDATE1Z2LE                                                       LUC109
     C*COPY*ZSRSRC,ZDATE2Z2****                                                     LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                       LUC109
     C*COPY*ZSRSRC,ZDATE9Z3****                                                     LUC109
     C/COPY ZSRSRC,ZDATE9Z3LE                                                       LUC109
     C*COPY*ZSRSRC,ZDAT10Z2****                                                     LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                       LUC109
     C*COPY*ZSRSRC,ZINTDYZ2****                                                     LUC109
     C/COPY ZSRSRC,ZINTDYZ2LE                                                       LUC109
      /EJECT
**   CPY@
(c) Finastra International Limited 2016
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
