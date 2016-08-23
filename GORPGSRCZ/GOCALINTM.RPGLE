     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Calculate interest for many periods')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOCALINTM - Calculate Interest for Many Periods              *
      *                                                               *
      *  Function:  This module calculates interest over many         *
      *             interest periods.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER016             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016 - German Interest Calculation: Upgrade of FGE059      *
      *           to Midas Plus                                       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D/COPY GOCPYSRC,GOEVDARRS
     D/COPY GOCPYSRC,GOEVSARRS
 
 
     D W#DATA          DS            28
     D  W#DATE                 1      5S 0
     D  W#CPNR                 6     11P 7
     D  W#CFCT                12     17P 9
     D  W#PPCP                18     25P 0
     D  W#IR                  26     26
     D  W#MP                  27     27
     D  W#PP                  28     28
 
      *
      * INPUT PARAMETERS
      *
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
      * mode
     C                   PARM                    I#MODE           10            * MODE
      * dec.places
     C                   PARM                    I#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM                    I#NMDP            1 0          * NOM.DEC.PLCS
      * int.calc.method
     C                   PARM                    I#ICMT            7            * INT CAL MTHD
      * int paymts/year
     C                   PARM                    I#IPY             2 0          * INT PAY PER YR
      * Yen bond?, mort-backed, part-paid, fully paid price, accuracy
     C                   PARM                    I#YBON            1            * YEN BOND ?
     C                   PARM                    I#MORT            1            * MORT-BACKED
     C                   PARM                    I#PART            1            * PART PAID
     C                   PARM                    I#FUPP           15 0          * FULLY PAID PRICE
     C                   PARM                    I#ACUR            1 0          * ACCURACY
      * nominal
     C                   PARM                    I#NOML           15 0          * NOMINAL
      * start & end date
     C                   PARM                    I#SDAT            5 0          * START DATE
     C                   PARM                    I#EDAT            5 0          * END DATE
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp
      * last/next interest period?
     C                   PARM                    #LNIPERIOD        1
      * OUTPUTS
     C                   PARM                    O#TINT           15 2          * INTEREST
     C                   PARM                    O#TINTP          15 9          * INTEREST %
     C                   PARM                    O#TINTF          15 9          * INTEREST FACTOR
      *
      * RESET OUTGOING INTEREST AND INTEREST %
      *
     C                   Z-ADD     0             O#TINT
     C                   Z-ADD     0             O#TINTP
     C                   Z-ADD     0             O#TINTF
 
 
     C                   SELECT
 
      * INITIALISE
 
     C     I#MODE        WHENEQ    '*INIT   '
 
     C                   EXSR      INIT
 
     C                   OTHER
 
      * CALCULATE
 
     C                   EXSR      CALC
 
     C                   ENDSL
 
      * RETURN
 
     C                   RETURN
 
      **********************************************************************
     C     CALC          BEGSR                                                  *** ZACCDC ***
 
      * If start date not supplied, it is the last interest payment date
      * prior to the end date
 
     C     I#SDAT        IFEQ      *ZERO
     C                   Z-ADD     I#EDAT        E_PRDT
     C                   EXSR      GET_LNIPDT
     C                   Z-ADD     W#LIDT        I#SDAT
     C                   ENDIF
 
      * If end date not supplied, it is the next interest payment date
      * after the start date
 
     C     I#EDAT        IFEQ      *ZERO
     C                   Z-ADD     I#SDAT        E_PRDT
     C                   EXSR      GET_LNIPDT
     C                   Z-ADD     W#NIDT        I#EDAT
     C                   ENDIF
 
      * Get the interest rate, current factor and partly paid price
      * as at the input start date
 
     C                   EXSR      GET_INITVL
     C                   Z-ADD     W#DATE        Z#SDAT            5 0
 
      * Calculate the effective interest rate
 
     C                   EXSR      ZRATE
 
      * Loop through the events and accumulate interest
      * from the input start date to end date
 
     C                   ADD       1             #I
     C     #I            IFLE      ArrSizSum
     C                   MOVE      #DATA(#I)     W#DATA
     C                   ENDIF
      *
     C     #I            DOWLE     ArrSizSum
     C     W#DATE        ANDLT     I#EDAT
 
      * Calculate the accrued interest up to the latest event date.
 
     C                   Z-ADD     W#DATE        Z#EDAT            5 0
     C                   EXSR      ACCRUE
     C                   ADD       W#INT         O#TINT
     C                   ADD       W#INTP        O#TINTP
     C                   ADD       W#INTF        O#TINTF
 
      * Update the coupon rate, current factor and partly paid price
 
     C                   Z-ADD     W#CPNR        Z#CPNR
     C                   Z-ADD     W#CFCT        Z#CFCT
     C                   Z-ADD     W#PPCP        Z#PPCP
 
      * Calculate the effective interest rate
 
     C                   EXSR      ZRATE
     C                   Z-ADD     W#DATE        Z#SDAT
 
     C                   ADD       1             #I
     C     #I            IFLE      ArrSizSum
     C                   MOVE      #DATA(#I)     W#DATA
     C                   ENDIF
 
     C                   ENDDO
 
      * Calculate the accrued interest up to the end date.
 
     C                   Z-ADD     I#EDAT        Z#EDAT
     C                   EXSR      ACCRUE
     C                   ADD       W#INT         O#TINT
     C                   ADD       W#INTP        O#TINTP
     C                   ADD       W#INTF        O#TINTF
      *
     C                   ENDSR
      *****************************************************************
     C     GET_INITVL    BEGSR
 
      * Find first record of event prior to or at start date
      * (if no details found get next date after start date)
 
     C                   Z-ADD     1             #I
     C     I#SDAT        LOOKUP    #DATE(#I)                            9999    *
     C     *IN99         IFEQ      '0'
     C     *IN99         OREQ      '1'
     C     #DATE(#I)     ANDEQ     *ZERO
     C     I#SDAT        LOOKUP    #DATE(#I)                          99        *
     C                   ENDIF
 
     C     *IN99         IFEQ      '1'
     C                   MOVE      #DATA(#I)     W#DATA
     C                   Z-ADD     W#CPNR        Z#CPNR
     C                   Z-ADD     W#CFCT        Z#CFCT
     C                   Z-ADD     W#PPCP        Z#PPCP
     C                   ELSE
 
      * Return in error if no details at all
 
     C                   EVAL      I#ERMS = 'NO DETAILS PASSED TO GOCALINTM'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ACCRUE        BEGSR
      *
      ** CALCULATE NUMBER OF DAYS (BETWEEN Z#SDAT AND Z#EDAT)
      *
     C                   EXSR      CAL_NDYS
      *
      * GET LAST AND NEXT INT DATES STRADDLING THE END DATE (W#LIDT/W#NIDT)
      *
     C                   Z-ADD     Z#EDAT        E_PRDT
     C                   EXSR      GET_LNIPDT
      *
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *
     C                   EXSR      CAL_YBAS
      *
      * CALCULATE INTEREST (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *
     C                   EXSR      CAL_INTA
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE NUMBER OF DAYS (BETWEEN Z#SDAT AND Z#EDAT)
      *********************************************************************
     C     CAL_NDYS      BEGSR
      *
     C                   CALLB     'GOCALNDYS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      Z#SDAT        W#SDAT            5 0          * START DATE
     C                   PARM      Z#EDAT        W#EDAT            5 0          * END DATE
     C                   PARM      *ZERO         W#NDYS            5 0          * NO. OF DAYS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCALNDYS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** GET LAST AND NEXT INT PAYMENT DATES STRADDLING AN EVENT DATE
      *********************************************************************
     C     GET_LNIPDT    BEGSR
 
      ** GET LAST AND NEXT EVENT DATE
 
     C                   CALLB     'GOMNTEVDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM      '*GETLNEVDT'  W#MODE           10
     C                   PARM      *BLANK        W#TYPE            2
 
      * EVENT
     C                   PARM                    E_EVNT
 
      * EVENT DATA ARRAY
     C                   PARM                    #arevdt_ip
 
      * LAST/NEXT PERIOD?
     C                   PARM      #LNIPERIOD    #LN_PERIOD        1
 
      * LAST DATE
      * NEXT DATE
     C                   PARM      *ZERO         W#LIDT            5 0
     C                   PARM      *ZERO         W#NIDT            5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOMNTEVDT'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *********************************************************************
     C     CAL_YBAS      BEGSR
 
     C                   CALLB     'GOCALYBAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM      I#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      I#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM                    W#LIDT            5 0          * LAST INT DATE
     C                   PARM                    W#NIDT            5 0          * NEXT INT DATE
     C                   PARM      *ZERO         W#YBAS            5 0          * YEAR BASIS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCALYBAS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE INTEREST (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *********************************************************************
     C     CAL_INTA      BEGSR
 
     C                   CALLB     'GOCALINTA'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM                    W#NDYS            5 0          * NO. OF DAYS
     C                   PARM                    W#YBAS            5 0          * YEAR BASIS
     C                   PARM      I#NOML        W#NOML           15 0          * NOMINAL
     C                   PARM      I#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      I#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM      I#ICMT        W#ICMT                                       CER016
     C                   PARM      Z#IRAT        W#IRAT           11 7          * INT.RATE
     C                   PARM      *ZERO         W#CLRT           11 7          * CEILING RATE
     C                   PARM      *ZERO         W#FLRT           11 7          * FLOOR RATE
     C                   PARM      I#YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      I#ACUR        W#ACUR            1 0          * ACCURACY
     C                   PARM      *ZERO         W#INT            15 2          * INTEREST
     C                   PARM      *ZERO         W#INTP           15 9          * INTEREST %
     C                   PARM      *ZERO         W#INTF           15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCALINTA'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
     C     ZRATE         BEGSR
 
      **  If coupon rate or partly paid price are zero then set the
      **  effective interest rate to zero and exit; else set up the
      **  interest rate with the current coupon rate.
 
     C     Z#CPNR        IFEQ      *ZEROS
     C     I#PART        OREQ      'Y'
     C     Z#PPCP        ANDEQ     *ZEROS
     C                   Z-ADD     *ZEROS        Z#IRAT
     C                   GOTO      EZRATE
     C                   ELSE
     C                   Z-ADD     Z#CPNR        Z#IRAT           11 7
     C                   END
 
      **  If partly paid, then calculate the fraction of part payment
      **  and multiply the interest rate by it.
 
     C     I#PART        IFEQ      'Y'
     C     Z#PPCP        ANDNE     I#FUPP
     C     Z#PPCP        DIV       I#FUPP        WRK109           10 9
     C                   MULT(H)   WRK109        Z#IRAT
     C                   END
 
      **  If mortgage backed security, then multiply the
      **  interest rate by the current factor.
 
     C     I#MORT        IFEQ      'Y'
     C                   MULT(H)   Z#CFCT        Z#IRAT
     C                   END
 
     C     EZRATE        ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     INIT          BEGSR
 
      * clear event dates and data
 
     C                   CLEAR                   E_EVNT
 
     C                   CLEAR                   #DATE
     C                   CLEAR                   #DATA
 
      * Load interest payment dates
 
     C                   MOVE      #_ipdat       #_WKdat
     C                   MOVE      #_ipdta       #_WKdta
     C                   MOVE      'IP'          W#TYPE            2
 
     C                   EXSR      LOAD
 
      * Load interest rate change dates
 
     C                   MOVE      #_irdat       #_WKdat
     C                   MOVE      #_irdta       #_WKdta
     C                   MOVE      'IR'          W#TYPE
 
     C                   EXSR      LOAD
 
      * Load mortgage payment dates
 
     C                   MOVE      #_mpdat       #_WKdat
     C                   MOVE      #_mpdta       #_WKdta
     C                   MOVE      'MP'          W#TYPE
 
     C                   EXSR      LOAD
 
      * Load part payment dates
 
     C                   MOVE      #_ppdat       #_WKdat
     C                   MOVE      #_ppdta       #_WKdta
     C                   MOVE      'PP'          W#TYPE
 
     C                   EXSR      LOAD
 
      * Sort dates and data arrays
 
     C                   SORTA     #DATE
     C                   SORTA     #DATA
 
      * Roll up data in arrays
 
     C     *LIKE         DEFINE    W#CPNR        Z#CPNR
     C     *LIKE         DEFINE    W#CFCT        Z#CFCT
     C     *LIKE         DEFINE    W#PPCP        Z#PPCP
     C                   Z-ADD     *ZERO         Z#CPNR
     C                   MOVE      *ZERO         Z#CFCT
     C                   MOVE      *ZERO         Z#PPCP
 
     C                   Z-ADD     1             #I                5 0
     C     *BLANK        LOOKUP    #DATA(#I)                          99        *
     C     #I            DOUGT     ArrSizSum
 
     C                   MOVE      #DATA(#I)     W#DATA
     C     W#IR          IFNE      'Y'
     C                   Z-ADD     Z#CPNR        W#CPNR
     C                   ENDIF
     C     W#MP          IFNE      'Y'
     C                   Z-ADD     Z#CFCT        W#CFCT
     C                   ENDIF
     C     W#PP          IFNE      'Y'
     C                   Z-ADD     Z#PPCP        W#PPCP
     C                   ENDIF
     C                   MOVE      W#DATA        #DATA(#I)
 
     C                   Z-ADD     W#CPNR        Z#CPNR
     C                   MOVE      W#CFCT        Z#CFCT
     C                   MOVE      W#PPCP        Z#PPCP
 
     C                   ADD       1             #I
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     LOAD          BEGSR
 
     C                   Z-ADD     1             #I                5 0
 
      * Load dates and data
 
     C     #I            DOWLE     ArrSizDet
     C     #_WKdat(#I)   ANDNE     *ZERO
 
     C                   Z-ADD     1             #J                5 0
     C     #_WKdat(#I)   LOOKUP    #DATE(#J)                              99    *
     C     *in99         IFEQ      '1'
     C                   MOVE      #DATA(#J)     W#DATA
     C                   EXSR      UPDATATR
     C                   MOVE      W#DATA        #DATA(#J)
     C                   ELSE
     C                   Z-ADD     1             #J
     C     *ZERO         LOOKUP    #DATE(#J)                              99    *
     C                   MOVE      #_WKdat(#I)   #DATE(#J)
     C                   CLEAR                   W#DATA
     C                   EXSR      UPDATATR
     C                   MOVE      W#DATA        #DATA(#J)
     C                   ENDIF
 
     C                   ADD       1             #I
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     UPDATATR      BEGSR
     C                   MOVE      #_WKdat(#I)   W#DATE
     C                   SELECT
     C     W#TYPE        WHENEQ    'IR'
     C                   MOVE      #_WKdta(#I)   W#CPNR
     C                   MOVE      'Y'           W#IR
     C     W#TYPE        WHENEQ    'MP'
     C                   MOVE      #_WKdta(#I)   W#CFCT
     C                   MOVE      'Y'           W#MP
     C     W#TYPE        WHENEQ    'PP'
     C                   MOVE      #_WKdta(#I)   W#PPCP
     C                   MOVE      'Y'           W#PP
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
