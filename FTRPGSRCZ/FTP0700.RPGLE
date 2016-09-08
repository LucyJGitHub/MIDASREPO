     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0700 - Validate SWIFT for SWIFT key                       *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD036414           Date 05Nov15               *
      *  Prev Amend No. MD31937            Date 13Jan15               *
      *                 AR856737           Date 15Jul2011             *
      *                 ESL038             Date 22Feb2005             *
      *                 EEE065 *Create     Date 01Jan2004             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036414   - MT101 failed                                    *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 Upgrade STP to Midas Plus level.                    *
      *           Renamed QQDFAC field in SDBRCHPD                    *
      *  ESL038 - ING FT STP Development                              *
      *  EEE065 - FT Validation for SWIFT key                         *
      *                                                               *
      *****************************************************************
     FFTSWKYV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT keys             Retrieval index
      *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
      ***************** FIRST COMPILE TIME ARRAY *********************
      *
      *
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                       AR856737
      *
      * Branch Data Structure *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      * Customer details      *
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D* SAR file details
     D  SCLCD        E                     EXTFLD(LCD)
      *
     D P1PARM          DS           256
      *
      *  Define data structure used to pass parameters
      *
      * Booking branch
     D  I#BRCA                 1      3
      * Information type  (S=SWIFT C=Customer)
     D  I#TYPE                 4      4
      * SWIFT BIC
     D  I#SBIC                 5     15
      * Customer
     D  I#CUST                16     21
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D W#Valid         S              1
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         Incoming dat
      *
      *  Set up primary reference
      *
     C                   MOVEL     P1PARM        W0PREF
      *
      *  Set up subroutine stack name
      *
     C                   Z-ADD     1             Q
     C                   MOVEL     *BLANKS       @STK
     C                   MOVEL     'MAIN  '      @STK(Q)
      *================================================================
      *
      * Initialise
      *
     C     #FIRST        IFEQ      *BLANKS
     C                   EXSR      ZZINIT
     C                   MOVEL     'Y'           #FIRST            1
     C                   END
      *
      * Validate SWIFT for SWIFT key
      *
     C                   EXSR      SRVKEY
      *================================================================
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Terminate program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVKEY   : Validate SWIFT key                                *
      *                                                               *
      *  Called By: Main                                              *
      *                                                               *
      *  Calls    : SRERR - Report errors                             *
      *                                                               *
      *****************************************************************
     CSR   SRVKEY        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRVKEY'      @STK(Q)
      *
      *  If customer passed
      *
     C     I#TYPE        IFEQ      'C'
      *
      *  Call to access pgm for Customer details
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      I#CUST        @CNUM            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      *  Call to access pgm for Branch details
      *
     C                   CALL      'AOBRCHR0'                           9090
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      I#BRCA        @BRCD            10
     C     SDBRCH        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOBRCHR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *  Set up key for access to database
      *
     C                   MOVEL     A8BTID        SWOKEY
     C     I#TYPE        IFEQ      'C'
     C                   MOVEL     BBCSID        SWCKEY
     C                   ELSE
     C                   MOVEL     I#SBIC        SWCKEY
     C                   ENDIF
      *
      *  If branch has not TID then exit
      *
     C     A8BTID        IFEQ      *BLANKS
     C                   MOVEL     'SWK0001'     P0RTN
     C                   GOTO      EXVKEY
     C                   ENDIF
      *
      *  Check if connected
      *
     C                   IF        %Subst(Swckey:8:1) = '1'
     C                   MOVEL     'SWK0007'     P0RTN
     C                   GOTO      EXVKEY
     C                   Endif
      *
      *  Define key
      *
     C     SWKY          KLIST
     C                   KFLD                    SWOKEY
     C                   KFLD                    SWCKEY
      *
      *  Get match
      *
     C     SWKY          CHAIN     @SWKYV1                            90
      *
      * Check dates
     C     *IN90         IFEQ      *OFF
     C                   Exsr      SrPayDate
     C                   ENDIF

     C     *IN90         IFEQ      *ON
     C     W#Valid       OREQ      'N'
      * General country
     C**********         MOVE      '  '          SWCKEY                                     MD036414
     C                   MOVE      *BLANKS       SWCKEY                                     MD036414
     C     SWKY          CHAIN     @SWKYV1                            90
      *
      * Check dates
     C     *IN90         IFEQ      *OFF
     C                   Exsr      SrPayDate
     C                   ENDIF

     C     *IN90         IFEQ      *ON
     C     W#Valid       OREQ      'N'
      * General SWIFT
     C                   MOVE      '    '        SWCKEY
     C     SWKY          CHAIN     @SWKYV1                            90
      *
      * Check dates
     C     *IN90         IFEQ      *OFF
     C                   Exsr      SrPayDate
     C                   ENDIF

      * No match
     C     *IN90         IFEQ      *ON
     C     W#Valid       OREQ      'N'
     C                   MOVEL     'SWK0002'     P0RTN
     C                   GOTO      EXVKEY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *  Match found is it included ?
      *
     C                   SELECT
     C     SWAKEY        WHENEQ    '0'
     C                   MOVEL     '       '     P0RTN
     C     SWAKEY        WHENEQ    '5'
     C                   MOVEL     'SWK0004'     P0RTN
     C                   OTHER
     C                   MOVEL     'SWK0005'     P0RTN
     C                   ENDSL
      *
      *  Unwind subroutine stack name
      *
     C     EXVKEY        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q                 5 0
      *
     CSR                 ENDSR
      /EJECT
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPayDate : Check for pay route active                       *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrPayDate     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrPayDate'   @STK(Q)
      *
     C                   If        SwStat = ' '
     C                   Eval      W#Valid = 'Y'
     C                   Goto      ExPayDate
     C                   Endif
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
      * Active and no date range
     C                   If        %Found and swStat = 'A'
     C                             and swStdt = 0 and swEndt = 0
     C                             or
      * Active and start date passed and no end date
     C                             %Found and swStat = 'A'
     C                             and swStdt > 0 and swStdt <= WuRdnb
     C                             and swEndt = 0
     C                             or
      * Active and start date passed and end date not passed
     C                             %Found and swStat = 'A'
     C                             and swStdt > 0 and swStdt < WuRdnb
     C                             and swEndt > 0 and swEndt >= WuRdnb
     C                             or
      * Active and no start date and end date not passed
     C                             %Found and swStat = 'A'
     C                             and swStdt = 0
     C                             and swEndt > 0 and swEndt >= WuRdnb
     C                             or
      * Suspended but start date not passed
     C                             %Found and swStat = 'S'
     C                             and swStdt > 0 and swStdt > WuRdnb
     C                             or
      * Suspended but end date passed
     C                             %Found and swStat = 'S'
     C                             and swEndt > 0 and swEndt < WuRdnb
     C                   Eval      W#Valid = 'Y'
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExPayDate     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
      *
      *  Set up copyright parameter
      *
     C                   MOVEA     CPY@          MKI@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'ZZINIT'      @STK(Q)
      *
     C                   MOVE      *BLANK        P0RTN
      *
      * Initialise indicators for re-entry
      *
     C                   MOVE      '0'           *IN
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      * Update screen time
      *
     C                   TIME                    ##TME             6 0
      *
      * Obtain default message file
      *
     C                   MOVEL     'FTUSRMSG'    ZADFMF           10
      *
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Get modules information
      *
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDMMOD        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     14            W0ERNB                         * DB ERROR 14 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Access SAR details file to determine if EEE065 is switched ON
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*VERIFY'     P@OPTN            7
     C                   PARM      'EEE065'      P@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   MOVE      'N'           EEE065            1
     C                   MOVE      '0'           *IN80
      *
      ** If core feature is switched ON, set a variable field to
      ** condition the rest of the processing
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           EEE065
     C                   MOVE      '1'           *IN80
     C                   ELSE
      *
      ** else, database error (return code other than *NRF)
      *
     C     P@RTCD        IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     21            W0ERNB                         * DB ERROR 21 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *================================================================
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
