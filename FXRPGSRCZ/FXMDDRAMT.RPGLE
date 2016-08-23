     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Calculate maximum daily delivery riskmat')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXMDDRAMT - Calculate Maximum Daily Delivery Risk            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 215567             Date 25Mar03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 185612  *CREATE    Date 22May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215667 - Current transaction amount is being added to the    *
      *           total exposure amount twice (during insertion and   *
      *           authorisation).  Applied fix 208997.                *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  185612 - Calculate Maximum Daily Delivery Risk.              *
      *                                                               *
      *****************************************************************
 
     FSDCUSTL4  IF   E           K DISK
 
     FDEALSDBL  IF   E           K DISK
     F                                     RENAME(FXDEALP0:DEALSDL)
 
     FEMDDRNT   IF   E           K DISK
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D**  SIX ARAYS FOR CUSTOMER FX LIMITS
     D XFDT            S              5  0 DIM(6)                               PERIOD END DATES
     D XFLM            S              9  0 DIM(6)                               PERIOD LIMIT AMT.
     D XFXP            S             10  0 DIM(6)                               PERIOD EXPOS AMT.
     D XFMP            S             11  0 DIM(6)                               80% OF LIMIT
     D*
     D POW             S              7  3 DIM(7) CTDATA PERRCD(1)
     D*
     D                 DS
     D  XFDA                   1     18  0
     D                                     DIM(6)                               PERIOD END DAYS
     D  XFDAA                  1     18
     D                                     DIM(6)                               CHILDRENS CNUMS.
     D  XFDAIN                 1     18
     D                 DS
     D  XFPC                   1     18  2
     D                                     DIM(6)                               PERIOD PERCENTGE.
     D  XFPCIN                 1     18
     D*
     D                 DS                                                       S01272
     D  START                  1      3  0                                      S01272
     D  ENDAY                  4      6  0                                      S01272
     D  PERIOD                 1      6                                         S01272
     D*                                                                   S01272
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * DATA STRUCTURE FOR Currency details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * DATA STRUCTURE FOR Customer details
 
     D SDCLLM        E DS                  EXTNAME(SDCLLMPD)
     D** EXTERNAL DS FOR CUSTOMER LIMITS DETAILS
 
     D SDLIMT        E DS                  EXTNAME(SDLIMTPD)
     D** EXTERNAL DS FOR LIMITS DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D** EXTERNAL DS FOR DEALING BASE CCY
 
     D SDEXPM        E DS                  EXTNAME(SDEXPMPD)
     D** EXTERNAL DS FOR EXPOSURE MANAGEMENT
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS FOR ACCESS PROGRAMS, long DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields used by ZFWDT
      ** ~~~~~~~~~~~~~~~~~~~~~~~~~
      ** Currency
     D ZCCY            S              3A
 
      ** Date
     D ZDATE           S              6A
 
      ** Midas day number
     D ZDAYNO          S              5P 0
     D ZDYNBR          S                   LIKE(ZDAYNO)
 
      ** Holiday indicator
     D ZIND            S              1A
 
      ** Location code
     D ZLOC            S              3A
 
      ** Number of days
     D ZNRDYS          S              2P 0
 
      ** INPUT PARMS
      ** ~~~~~~~~~~~
      ** Action code
     D DDACTN          S              1A
 
      ** Customer
     D DDCUST          S             10A
 
      ** Buy Currency
     D DDBCCY          S              3A
 
      ** Sell Currency
     D DDSCCY          S              3A
 
     D** Run Day Number from SDBANKPD
     D BJRDNB          S              5  0
 
      ** System Location Code from SDBANKPD
     D BJSLCD          S              3A
 
      ** Buy Currency Decimal Places
     D BUYCDP          S              1  0
 
      ** Buy Amount
     D BAMT            S             13  0
 
      ** Buy Currency Exchange Rate
     D BYERLC          S             15  8
 
      ** Buy Currency Multiply/Divide Indicator
     D BYMDIN          S              1A
 
      ** Sell Amount
     D SAMT            S             13  0
 
      ** Net FX Exposure Indicator
     D W#NFXE          S              1A
 
      ** Exposure Management indicator
     D BGEXMG          S              1A
 
      ** Value Date in day number format
     D @VDYNO          S              5  0
 
      ** Work Fields
      ** ~~~~~~~~~~~
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires ERR_ARRAYS and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C     Strt          TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      *' +----------------------------------------------------------------+
 
      **Initialization
 
     C                   Z-ADD     0             TOTPAR
      *
      **Set Net Exposure indicator
     C                   MOVE      *BLANK        W#NFXE
     C     CDL002        IFEQ      'Y'
     C     BGEXMG        ANDEQ     'Y'
     C                   MOVE      BUNTEM        W#NFXE
     C                   ENDIF
0951 C*
     C* Call Access Prog. to obtain CURRENCY DETAILS for Buy ccy
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
0951 C*
     C* If error occurs...
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 903*
     C                   MOVEL     DDBCCY        DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      #END
     C                   END
     C                   EVAL      BUYCDP = A6NBDP
     C                   EVAL      BYERLC = A6ERLC
     C                   EVAL      BYMDIN = A6MDIN
0951 C*
     C* Call Access Prog. to obtain CURRENCY DETAILS for Decimal Places
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BNCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
0951 C*
     C* If error occurs...
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @AJCD         DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      #END
     C                   END
0951 C*
0346 C     A6NBDP        ADD       4             DEP               1 0
     C                   Z-ADD     POW(DEP)      FACTOR            7 0
     C*
     C* OBTAIN NUMBER OF DAYS FORWARD FOR 'SP'
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      BNCYCD        ZCCY
     C                   Z-ADD     A6SPDY        ZNRDYS
     C                   MOVE      BJSLCD        ZLOC
     C                   EXSR      ZFWDT
     C     ZDYNBR        SUB       BJRDNB        SP                5 0
     C                   Z-ADD     ZDYNBR        SPDAT             5 0
     C*
     C*  CONVERT TODAY'S DEAL INTO LIMIT CURRENCY FOR LATER CALCS.
     C     DDBCCY        IFEQ      BNCYCD
     C     BAMT          DIV(H)    FACTOR        DLAMT            13 0
     C                   ELSE
     C*
     C*  USE SELL CCY FOR CONVERSION IFEQ BASE CURRENCY
     C     DDSCCY        IFEQ      BNCYCD
     C     SAMT          DIV(H)    FACTOR        DLAMT
     C                   Z-SUB     DLAMT         DLAMT
     C                   ELSE
     C*
     C     BUYCDP        ADD       4             DEP
     C     BAMT          DIV(H)    POW(DEP)      DLAMT
     C     BYERLC        IFNE      0
     C     BYMDIN        IFEQ      'D'
     C     DLAMT         DIV(H)    BYERLC        DLAMT
     C                   ELSE
     C     DLAMT         MULT(H)   BYERLC        DLAMT
     C                   END
     C                   END
     C*
     C                   END
     C                   END
     C*
     C* CHECK FOR WARNING ERRORS IF DEAL APPROACHING MDDR AND FX LIMITS
     C* AND DETERMINE IF DEAL IS VALUED LESS THAN 10 DAYS FORWARD.
     C*
     C* CALL ACCESS OBJECT OBTAIN PARENT NO.
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCUST        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C**********         MOVE      BBCUST        CUSNM             6 0                        CSD027
     C                   MOVE      BBCUST        CUSNM             6                          CSD027
     C     @VDYNO        SUB       BJRDNB        DTWRK             5 0
     C*****DTWRK         IFLT      SP                                                         215567
     C     DTWRK         IFLE      SP                                                         215567
     C                   MOVE      'Y'           SPOTIN            1
     C                   ELSE
     C                   MOVE      'N'           SPOTIN            1
     C                   END
     C*
     C*    ACCESS LIMIT FILE FOR CUSTOMER TO OBTAIN FX LIMIT INFO.
     C*    ALSO GET MDDR FOR CUSTOMER IF AN ORPHAN.
     C     BBPCNB        IFEQ      *BLANKS
     C                   CALL      'AOCLLMR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BBCUST        @CUSN             6
     C                   PARM      'B'           @LEVL             1
     C                   PARM      DDBRSN        @BCCD             3
     C     SDCLLM        PARM      SDCLLM        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   CALL      'AOCLLMR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BBCUST        @CUSN             6
     C                   PARM      'S'           @LEVL             1
     C                   PARM      'SYS'         @BCCD             3
     C     SDCLLM        PARM      SDCLLM        DSFDY
     C                   END
     C                   ELSE
     C                   CALL      'AOCLLMR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BBPCNB        @CUSN             6
     C                   PARM      'B'           @LEVL             1
     C                   PARM      DDBRSN        @BCCD             3
     C     SDCLLM        PARM      SDCLLM        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   CALL      'AOCLLMR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BBPCNB        @CUSN             6
     C                   PARM      'S'           @LEVL             1
     C                   PARM      'SYS'         @BCCD             3
     C     SDCLLM        PARM      SDCLLM        DSFDY
     C                   END
     C                   END
     C     @RTCD         IFNE      *BLANK
     C                   Z-ADD     0             CFLED
     C                   Z-ADD     0             CFLAM
     C                   MOVE      *BLANKS       CFLTY
     C                   Z-ADD     0             PRLAM
     C                   ELSE
     C                   Z-ADD     DZFLED        CFLED             5 0
     C                   Z-ADD     DZFXFA        CFLAM             9 0
     C                   MOVE      DZFXLT        CFLTY             3
     C                   Z-ADD     DZMDDR        PRLAM             9 0
     C                   END
     C*
     C** Prevent decimal data error if no record found by initialising
     C** blank fields.
     C     @RTCD         IFEQ      '*NRF    '
     C                   CLEAR                   SDCLLM
     C                   END
     C*
     C     BBPCNB        CABEQ     *BLANKS       CMDDR
     C*
     C*  CHAIN TO SDCUSTL4 TO OBTAIN CHILDREN'S NOS.
     C     BBPCNB        SETLL     SDCUSTL4
     C     PACCHN        TAG
     C     BBPCNB        READE     SDCUSTL4                               75
     C     *IN75         CABEQ     '1'           CMDDR2
     C                   MOVE      'N'           RDALL             1
     C**********         Z-ADD     CUSNM         CUSHLD            6 0                        CSD027
     C                   MOVE      CUSNM         CUSHLD            6                          CSD027
     C                   MOVE      BBCUST        CUSNM
     C                   EXSR      #ZIEA
     C**********         Z-ADD     CUSHLD        CUSNM                                        CSD027
     C                   EVAL      CUSNM = CUSHLD                                             CSD027
     C     *INU7         CABEQ     '1'           #END
     C                   GOTO      PACCHN
     C*
     C     CMDDR         TAG
     C*
     C     BBPCNB        IFEQ      *BLANKS
     C                   MOVE      'N'           RDALL
     C                   EXSR      #ZIEA
     C     *INU7         CABEQ     '1'           #END
     C                   END
     C*
     C     CMDDR2        TAG
     C*
     C*   ADD TODAY'S DEAL TO ACCUMULATED SUMS.
     C                   ADD       DLAMT         TOTPAR
     C*
     C*   CALCULATE 70% OF MDDR LIMIT FOR PARENT OR ORPHAN.
     C     PRLAM         MULT      700           PRLAMT           11 0
     C*
     C*   DETERMINE IF TOTAL ACCUMULATED DEALS EXCEED MDDR LIMIT,
     C*   OUTPUT ERROR MESSAGE IF EXCEEDS
     C     TOTPAR        IFGT      PRLAMT
     C     TOTPAR        DIV(H)    1000          TPAR              9 0
     C                   MOVE      '1'           *IN52
     C                   MOVE      '1'           *IN09
     C*******            MOVE      *BLANKS       M@MGDA
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      PRLAM         @@ALPH
     C                   Z-ADD     0             @@IDP
     C                   Z-ADD     9             @@IINT
     C                   EXSR      ZA0840
     C*******            MOVE      @@ALPH        M@0115
     C                   MOVE      @@ALPH        DDMDDR           16
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      TPAR          @@ALPH
     C                   Z-ADD     0             @@IDP
     C                   Z-ADD     9             @@IINT
     C                   EXSR      ZA0840
     C                   MOVE      @@ALPH        DDEXP1           16
     C                   MOVEL     'S4'          EXCEED            2
     C                   ADD       1             Ix
     C                   MOVEL     '*ANY'        FldNameArr(Ix)
     C                   MOVEL     'FXM1066'     MsgIdArr(Ix)
     C                   END
     C*
     C     CALCFX        TAG                                                    ** CALCFX TAG *
     C*
     C*   CHECK IF CUSTOMER FX LIMIT TYPE ZERO, OR EXPIRY DATE PASSED
     C*   OR TODAY.
     C     SPOTIN        IFEQ      'Y'
     C     DZFLAM        IFEQ      *ZERO
     C     CFLAM         ANDEQ     *ZERO
     C                   MOVE      *ON           *IN80
     C                   ENDIF
     C                   ELSE
     C     CFLAM         IFEQ      0
     C                   MOVE      *ON           *IN80
     C                   ENDIF
     C                   ENDIF
     C  N80CFLTY         COMP      *BLANKS                                80
     C     DZMDDR        COMP      0                                      82
     C*
     C     *IN80         IFEQ      '0'
     C     CFLED         IFEQ      0
     C                   Z-ADD     99999         CFLED
     C                   ELSE
     C     CFLED         CABGT     BJRDNB        SETARR
     C                   END
     C                   END
     C**  FOR EXPIRY OR NO LIMIT, SET UP ONE PERIOD 001-999 WITH ZERO A
     C                   Z-ADD     0             XFDA
     C                   MOVEA     '999'         XFDAA
     C                   Z-ADD     99999         XFDT(1)
     C                   Z-ADD     0             XFLM(1)
     C                   Z-ADD     0             XFXP(1)
     C*
     C     SETARR        TAG
     C*
     C*  SETUP LIMITS ARRAYS
     C     *IN80         IFEQ      '0'
     C                   EXSR      #ZIEC
     C     *INU7         CABEQ     '1'           #END
     C                   END
     C*
     C*  DO FX CALCULATIONS FOR CUSTOMER
     C*
     C*  CHAIN TO SDCUSTL4 TO OBTAIN CHILDREN'S NOS.
     C     BBPCNB        IFNE      *BLANKS
     C     BBPCNB        SETLL     SDCUSTL4
     C                   MOVE      '0'           *IN75
     C     *IN75         DOUEQ     '1'
     C     BBPCNB        READE     SDCUSTL4                               75
     C     *IN75         IFEQ      '0'
     C                   MOVE      'Y'           RDALL
     C**********         Z-ADD     CUSNM         CUSHLD            6 0                        CSD027
     C                   MOVE      CUSNM         CUSHLD            6                          CSD027
     C                   MOVE      BBCUST        CUSNM
     C                   EXSR      #ZIEA
     C**********         Z-ADD     CUSHLD        CUSNM                                        CSD027
     C                   EVAL      CUSNM = CUSHLD                                             CSD027
     C     *INU7         CABEQ     '1'           #END
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      'Y'           RDALL
     C                   EXSR      #ZIEA
     C     *INU7         CABEQ     '1'           #END
     C                   END
     C*
     C*  ADD TODAY'S DEAL TO APPROPRIATE PERIODS
     C                   Z-ADD     @VDYNO        DLVALU
     C     DDACTN        IFEQ      'I'                                                        215667
     C                   Z-ADD     DLAMT         DLAMTF
     C     SPOTIN        IFEQ      'Y'
     C                   Z-ADD     DLAMT         SPAMT
     C                   END
     C                   EXSR      #ZIEB
     C                   END                                                                  215667
     C*
     C*  DEAL EDIT NOT SO GOOD IF LIMIT IS 1000.
     C*  FORMAT EXPOSURE AFTER MAKING THE LIMIT COMP
     C*
     C*  DETERMINE 80% OF LIMIT AMOUNTS.
     C     XFLM          MULT      800           XFMP
     C*
      *** Check only the period within which the value date falls.
      *** Previous periods which exceed their limits are not relevant.
      *** If 'D' = 0 this means the value date is within two days of
      *** run date and therefore processing is skipped.
      *
     C     D             IFNE      0
     C                   Z-ADD     D             L                 1 0
     C*
     C     XFXP(L)       IFGE      XFMP(L)
     C                   MOVE      XFDA(L)       ENDAY             3 0
     C     L             SUB       1             N                 1 0  0505
     C*
     C     *IN05         IFEQ      '1'
     C                   MOVE      '001'         START             3 0
     C                   ELSE
     C                   MOVE      XFDA(N)       ENDOR             3 0
     C     ENDOR         ADD       1             START
     C                   END
     C*
     C*  CUT THE EXPOSURE DOWN TO SCREEN SIZE
     C     XFXP          DIV(H)    1000          XFXP
     C                   MOVE      '1'           *IN09
     C                   MOVE      '1'           *IN52
     C*******            MOVE      *BLANKS       M@MGDA
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      XFLM(L)       @@ALPH
     C                   Z-ADD     0             @@IDP
     C                   Z-ADD     9             @@IINT
     C                   EXSR      ZA0840
     C*******            MOVE      @@ALPH        M@0115
     C*******            MOVEL     PERIOD        M@0115
     C                   MOVE      @@ALPH        DDLIM3            9
     C                   MOVEL     PERIOD        DDLIMT            6
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      XFXP(L)       @@ALPH
     C                   Z-ADD     0             @@IDP
     C                   Z-ADD     10            @@IINT
     C                   EXSR      ZA0840
     C                   MOVE      DDLIMT        DDLIM2            3
     C                   MOVEL     DDLIMT        DDLIM1            3
     C     A2E1LP        IFEQ      'SP '
     C     D             ANDEQ     1
     C                   MOVE      '001'         DDLIM1
     C                   MOVE      'SP '         DDLIM2
     C                   END
     C                   MOVE      @@ALPH        DDEXP2           16
     C                   MOVEL     'S5'          EXCEED
     C                   ADD       1             Ix
     C                   MOVEL     '*ANY'        FldNameArr(Ix)
     C                   MOVEL     'FXM1067'     MsgIdArr(Ix)
     C                   GOTO      #END
     C*
     C                   END
     C                   ELSE
      *
      *** Process Spot exposure for Switchable Feature S01433
      *
     C     S01433        IFEQ      'S01433'
     C     SPOTIN        ANDEQ     'Y'
     C     A2E1LP        ANDNE     'SP '
     C*  CUT THE EXPOSURE DOWN TO SCREEN SIZE
     C     SPAMT         DIV(H)    1000          SPAMT            13 0
     C     SPAMT         IFGT      DZFLAM
     C                   MOVE      SPAMT         @@ALPH
     C                   Z-ADD     0             @@IDP
     C                   Z-ADD     10            @@IINT
     C                   EXSR      ZA0840
     C                   MOVE      @@ALPH        DDEXP2
     C                   MOVE      '001'         DDLIM1
     C                   MOVE      'SP '         DDLIM2
     C                   MOVE      DZFLAM        DDLIM3
     C                   MOVEL     'S5'          EXCEED
     C                   ADD       1             Ix
     C                   MOVEL     '*ANY'        FldNameArr(Ix)
     C                   MOVEL     'FXM1067'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
     C*
     C     #END          TAG
     C*
      ** Return
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZIEA    - Read deals file and add all amounts for customer   *
      *            in order to check MDDR                             *
      *                                                               *
      * CALLS    #ZIEB    - FX exposure calculation                   *
      *                                                               *
      * CALLED BY  #ZIE   - MDDR processing                           *
      *                                                               *
      *****************************************************************
     C     #ZIEA         BEGSR
     C*
     C*   READ DEALSDB FILE
     C*  IF RDALL EQUALS (Y) THEN READ ALL DEALS FOR THAT CUSTOMER
     C*  IF RDALL EQUALS (N) THEN READ DEALS FOR CUST. AND VALUE DATE
     C     RDALL         IFNE      'Y'
     C     DLKEY2        SETLL     DEALSDL
     C                   ELSE
     C     CUSNM         SETLL     DEALSDL
     C                   END
     C*
     C     *IN74         DOUEQ     '1'
     C     RDALL         IFNE      'Y'
     C     DLKEY2        READE     DEALSDL                                74
     C                   ELSE
     C     CUSNM         READE     DEALSDL                                74
     C                   END
     C     *IN74         IFEQ      '1'
     C     FHDDLT        OREQ      'D'
     C     FHTYPE        OREQ      'OP'
      *
      * Net FX Exposure and Buy Netted
     C     W#NFXE        OREQ      'Y'
     C     FHNBRF        ANDNE     *BLANKS
      *
     C                   Z-ADD     0             SUMA
     C                   ELSE
     C**   CHECK TO WHICH CCY IS SELL AND WHICH IS BUY
     C     *LIKE         DEFINE    FHDAM1        @SLMT
     C     *LIKE         DEFINE    FHCCY1        @SLCY
     C     *LIKE         DEFINE    FHDAM1        @PUAM
     C     *LIKE         DEFINE    FHCCY1        @PUCY
     C     FHDAM1        IFLT      0
     C                   Z-SUB     FHDAM1        @SLMT
     C                   MOVE      FHCCY1        @SLCY
     C                   Z-ADD     FHDAM2        @PUAM
     C                   MOVE      FHCCY2        @PUCY
     C                   ELSE
     C                   Z-SUB     FHDAM2        @SLMT
     C                   MOVE      FHCCY2        @SLCY
     C                   Z-ADD     FHDAM1        @PUAM
     C                   MOVE      FHCCY1        @PUCY
     C                   END
     C**   CHECK IF LIMIT CURRENCY IS EQUAL TO SELL CURRENCY.
     C     @SLCY         IFEQ      BNCYCD
     C     @SLMT         DIV(H)    FACTOR        SUMA             13 0
     C                   ELSE
     C*
     C     @PUCY         IFEQ      BNCYCD
     C     @PUAM         DIV(H)    FACTOR        SUMA
     C                   ELSE
     C*
     C* ACCESS TO CURRENCY RECORD FOR LIMIT CURRENCY DEC.PLACES
     C*                                          AND EXCH. RATE.
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @PUCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   MOVEL     @AJCD         DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      #ZIEA9
     C                   END
     C*
     C     A6NBDP        ADD       4             DEP
     C     @PUAM         DIV(H)    POW(DEP)      SUMA
     C     A6ERLC        IFNE      0
     C*
     C** According to SD0021E, the Multiply/Divide indicator for Limit
     C** Exchange rate against Limit Ccy is the same as the one for
     C** the Spot rate.
     C*
     C     A6MDIN        IFEQ      'D'
     C     SUMA          DIV(H)    A6ERLC        SUMA
     C                   ELSE
     C     SUMA          MULT      A6ERLC        SUMA
     C                   END
     C                   END
     C*
     C                   END
     C                   END
     C     RDALL         IFNE      'Y'
     C                   ADD       SUMA          TOTPAR           15 0
     C                   ELSE
     C                   Z-ADD     SUMA          DLAMTF           13 0
     C                   Z-ADD     @VDYNO        DLVALU            5 0
     C                   EXSR      #ZIEB
     C                   END
     C*
     C                   END
     C                   END
     C*
     C* Get FX Nets
     C     W#NFXE        IFEQ      'Y'
     C*  IF RDALL EQUALS (Y) THEN READ ALL Nets FOR THAT CUSTOMER
     C*  IF RDALL EQUALS (N) THEN READ Nets FOR CUST. AND VALUE DATE
     C     RDALL         IFNE      'Y'
     C     DLKEY3        CHAIN     EMDDRNT                            74
     C                   ELSE
     C     CUSNM         CHAIN     EMDDRNT                            74
     C                   ENDIF
     C*
     C     *IN74         DOWEQ     *OFF
     C* CHECK IF LIMIT CURRENCY IS EQUAL TO Buy CURRENCY.
     C     AMCCYD        IFEQ      BNCYCD
     C     AMDBUY        DIV(H)    FACTOR        SUMA             13 0
     C                   ELSE
     C*
     C* ACCESS TO CURRENCY RECORD FOR LIMIT CURRENCY DEC.PLACES
     C*                                          AND EXCH. RATE.
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      AMCCYD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '043'         DBASE                          * DBERR 43 *
     C                   MOVEL     @AJCD         DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      #ZIEA9
     C                   ENDIF
     C*
     C     A6NBDP        ADD       4             DEP
     C     AMDBUY        DIV(H)    POW(DEP)      SUMA
     C     A6ERLC        IFNE      0
     C*
     C** According to SD0021E, the Multiply/Divide indicator for Limit
     C** Exchange rate against Limit Ccy is the same as the one for
     C** the Spot rate.
     C     A6MDIN        IFEQ      'D'
     C     SUMA          DIV(H)    A6ERLC        SUMA
     C                   ELSE
     C     SUMA          MULT      A6ERLC        SUMA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C     RDALL         IFNE      'Y'
     C                   ADD       SUMA          TOTPAR           15 0
     C                   ELSE
     C                   Z-ADD     SUMA          DLAMTF           13 0
     C                   Z-ADD     @VDYNO        DLVALU            5 0
     C                   EXSR      #ZIEB
     C                   ENDIF
     C*
     C     RDALL         IFNE      'Y'
     C     DLKEY3        READE     EMDDRNT                                74
     C                   ELSE
     C     CUSNM         READE     EMDDRNT                                74
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C*
     C*
     C     #ZIEA9        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZIEB    - Calculate Exposure for Customer FX deal            *
      *                                                               *
      * CALLED BY  #ZIE   - MDDR processing                           *
      *            #ZIEA  - Reads amounts on DEALS file for a customer*
      *                                                               *
      *****************************************************************
     C     #ZIEB         BEGSR
     C*
     C                   Z-ADD     0             D
     C*  VALUE DATE IS SPOT DATE AND START OF THE LIMIT PERIOD IS NOT 'SP'
     C     SPOTIN        IFEQ      'Y'
     C*****A2E1LP        ANDEQ     'SP '                                                      215667
     C     DLVALU        ANDLE     XFDT(1)                                                    215667
     C     SPOTIN        OREQ      'N'
     C*
     C*  VALUE DATE IS GT TODAY PLUS TWO - AMOUNT IS ADDED INTO EVERY
     C*  PERIOD PROCESSING & INCLUDING THE PERIOD WHICH INCLUDES THE
     C*  VALUE DATE.
     C                   Z-ADD     0             D
     C     D             DOUGE     6
     C                   ADD       1             D
     C**
     C**  ADD AMOUNT INTO THIS PERIOD
     C                   ADD       DLAMTF        XFXP(D)
     C*
     C**  LOOP AGAIN TO ADD AMOUNT INTO THE NEXT PERIOD IF
     C**  -- VALUE DATE EXCEEDS THIS END OF PERIOD DATE,
     C**  -- LESS THAN SIX PERIODS HAVE BEEN USED.
     C     DLVALU        CABLE     XFDT(D)       #ZIEB9
     C                   END
     C                   ELSE
      *
      *** PROCESS S01433
      *
     C     SPOTIN        IFEQ      'Y'
     C     *IN74         ANDNE     *ON
     C     FHVDDN        ANDLT     SPDAT
     C     FHVDDN        ANDGT     BJRDNB
     C                   ADD       DLAMTF        SPAMT
     C                   ENDIF
     C                   END
     C*
     C     #ZIEB9        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #ZIEC    - Set up arrays of limit periods and amounts for FX  *
      *            customer limits
      *                                                               *
      * CALLED BY  #ZIE   - MDDR processing                           *
      *                                                               *
      *****************************************************************
     C     #ZIEC         BEGSR
     C*
     C*  RESET ARRAYS TO ZERO
     C                   Z-ADD     0             XFDA
     C                   Z-ADD     0             XFDT
     C                   Z-ADD     0             XFLM
     C                   Z-ADD     0             XFXP
     C                   Z-ADD     0             XFPC
     C                   Z-ADD     0             XFMP
     C*
     C*          =============
     C     BYPAS1        TAG                                                    ** BYPAS1 **
     C*          =============
     C*
     C*  - NOT EXPIRED - ACCESS LIMITS REC. ON LIMITS FILE
     C                   CALL      'AOLIMTR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CFLTY         @CRNB             3
     C     SDLIMT        PARM      SDLIMT        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDLIMTPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   MOVEL     @CRNB         DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      #ZIEC9
     C                   END
     C**
     C*  MOVE DATA FROM INPUT FIELDS TO FX ARRAYS.
     C     A2E1LP        IFEQ      'SP '
     C                   MOVE      A2E1LP        XFDAA(1)
     C                   ELSE
     C                   MOVE      A2E1LP        XFDA(1)
     C                   END
     C                   Z-ADD     A2E2LP        XFDA(2)
     C                   Z-ADD     A2E3LP        XFDA(3)
     C                   Z-ADD     A2E4LP        XFDA(4)
     C                   Z-ADD     A2E5LP        XFDA(5)
     C                   Z-ADD     A2E6LP        XFDA(6)
     C**
     C     A2PL1P        DIV       100           XFPC(1)
     C     A2PL2P        DIV       100           XFPC(2)
     C     A2PL3P        DIV       100           XFPC(3)
     C     A2PL4P        DIV       100           XFPC(4)
     C     A2PL5P        DIV       100           XFPC(5)
     C     A2PL6P        DIV       100           XFPC(6)
     C**
     C**
     C**  LOOP PROCESSES XFDAA - IF ANY ELEMENT IS BLANK OR 999
     C**  THE CORRESPONDING ELEMENTS IN XFDA & XFDT ARE SET TO NINES.
     C**  ESLE XFDT IS CALCULATED BY ADDING RUND TO XFDA,
     C**       XFLM IS CALCULATED BY MULTIPLYING LIMIT AMOUNT BY XFPC
     C                   Z-ADD     0             D                 2 0
     C     D             DOUGE     6
     C                   ADD       1             D
     C*
     C     XFDAA(1)      IFEQ      'SP '
     C                   Z-ADD     SP            XFDA(1)
     C                   END
     C*
      *
      *** XFDAA is set to zeroes not blanks if period has not been
      *** defined.  The period dates are set to maximum as a catchall.
      *
     C     XFDAA(D)      IFEQ      '000'
     C                   Z-ADD     999           XFDA(D)
     C                   Z-ADD     99999         XFDT(D)
     C                   GOTO      #ZIEC9
     C                   ELSE
     C     XFDA(D)       ADD       BJRDNB        XFDT(D)
     C     A2E1LP        IFEQ      'SP '
     C     D             ANDEQ     1
     C                   Z-ADD     DZFLAM        XFLM(D)
     C                   ELSE
     C     CFLAM         MULT      XFPC(D)       XFLM(D)
     C                   ENDIF
     C     XFDAA(D)      IFEQ      '999'
     C                   Z-ADD     99999         XFDT(D)
     C                   GOTO      #ZIEC9
     C                   END
     C                   END
     C*
     C                   END
     C*
     C     #ZIEC9        ENDSR
      /EJECT
      *****************************************************************
      *  ZFWDT  - Subroutine to contain the call to the ZFWDT         *
      *           module without disturbing the converted FX0820      *
      *           code                                                *
      *****************************************************************
 
     C     ZFWDT         BEGSR
 
     C                   CALLB     'ZFWDT'
      ** Inputs
      **                                   Midas day number
     C                   PARM                    ZDAYNO
      **                                   Number of days forward
     C                   PARM                    ZNRDYS
      **                                   Working day number ZNRDYS forward
     C                   PARM                    ZDYNBR
      **                                   Currency
     C                   PARM                    ZCCY
      **                                   Location
     C                   PARM                    ZLOC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     ZA0840        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C                   PARM                    @@MTID            1            Million/Thous.
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Maximum Daily Delivery Risk fields:
     C                   PARM                    DDMDDR           16
     C                   PARM                    DDEXP1           16
     C                   PARM                    DDEXP2           16
     C                   PARM                    DDLIMT            6
     C                   PARM                    DDLIM1            3
     C                   PARM                    DDLIM2            3
     C                   PARM                    DDLIM3            9
 
      ** Inputs to this procedure
      ** ------------------------
 
     C** Action code
     C                   PARM                    DDACTN
     C** Customer
     C                   PARM                    DDCUST
     C** Buy Currency
     C                   PARM                    DDBCCY
     C** Sell Currency
     C                   PARM                    DDSCCY
     C** Run Day Number from SDBANKPD
     C                   PARM                    BJRDNB
      ** System Location Code from SDBANKPD
     C                   PARM                    BJSLCD
      ** Buy Amount
     C                   PARM                    BAMT
      ** Sell Amount
     C                   PARM                    SAMT
      ** Exposure Management indicator
     C                   PARM                    BGEXMG
      ** Value Date in day number format
     C                   PARM                    @VDYNO
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Ix
     C                   PARM                    DDBRSN            3
      *
      ** Clear output fields
      *
     C                   MOVE      *BLANK        DDEXP1
     C                   MOVE      *BLANK        DDEXP2
     C                   MOVE      *BLANK        DDLIM1
     C                   MOVE      *BLANK        DDLIM2
     C                   MOVE      *BLANK        DDLIM3
     C                   MOVE      *BLANK        DDMDDR
 
      ** Key list for DEALSDL
 
     C     DLKEY2        KLIST
     C                   KFLD                    CUSNM
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
      *
     C     DLKEY3        KLIST
     C                   KFLD                    CUSNM
     C                   KFLD                    @VDYNO
0951 C*
     C* Call Access Prog. to obtain base ccy for dealing info
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
0951 C*
     C* If error occurs...
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDDEALPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 903*
     C                   MOVEL     *BLANK        DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   END
0951 C*
     C* Check if FX Netting switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL002'      @SARD             6
     C                   PARM                    DSFDY
0951 C*
     C* Set switchable feature indicator
     C                   MOVE      'N'           CDL002            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDL002
     C                   ELSE
     C     @RTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 903*
     C                   MOVEL     'CDL002'      DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   END
     C                   END
0951 C*
     C* Get Exposure Management ICD
     C     BGEXMG        IFEQ      'Y'
     C                   CALL      'AOEXPMR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDEXPM        PARM      SDEXPM        DSFDY
0951 C*
     C* If error occurs...
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDEXPMPD'    DBFILE                         ************
     C                   MOVEL     '908'         DBASE                          * DBERR 903*
     C                   MOVEL     *BLANK        DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      *** Check if S01433 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01433'      @SARD             6
     C                   PARM                    DSFDY
     C                   MOVE      *BLANK        S01433            6
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'S01433'      S01433
     C                   ELSE
     C     @RTCD         IFNE      '*NRF'
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 909*
     C                   MOVEL     'S01433'      DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   END
     C                   END
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   POW - POWERS OF 10
0000001
0000010
0000100
0001000
0010000
0100000
1000000
