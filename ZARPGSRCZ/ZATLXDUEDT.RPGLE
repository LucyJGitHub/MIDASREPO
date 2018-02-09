     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine Telex Due Date')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZATLXDUEDT - DETERMINE TELEX DUE DATE                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     D  ZNRDYS         S              2S 0
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * DATA STRUCTURE FOR CURRENCY DETAILS
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for NOSTRO Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      /EJECT
     C*****************************************************************
      *
      **  DETERMINE TELEX NOTICE DAYS
      *
     C                   EXSR      TLXNOT
      *
      **  DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      ** RETURN
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TLXNOT - DETERMINE TELEX NOTICE DAYS                         *
     C*                                                              *
     C****************************************************************
     C     TLXNOT        BEGSR
      *
      ** Access currency details using deal currency, to get
      ** telex notice days for deal currency.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @CCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C     @RTCD         IFNE      *BLANK
     C                   Z-ADD     0             @TNOTD
     C                   ELSE
     C                   Z-ADD     A6TXND        @TNOTD            2 0
     C                   END
      *
      ** Access currency details using local currency, to get
      ** telex notice days for local currency.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJLCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C     @RTCD         IFNE      *BLANK
     C                   Z-ADD     0             @TNOTL
     C                   ELSE
     C                   Z-ADD     A6TXND        @TNOTL            2 0
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TLXDUE - DETERMINE TELEX DUE DATE                            *
     C*                                                              *
     C****************************************************************
     C     TLXDUE        BEGSR
      *
      ** Deal currency applies.
      *
     C     @DLOLC        IFEQ      'D'
     C     BJDNWD        SUB       1             ZDAYNO
     C                   MOVE      @CCY          ZCCY1
     C                   EXSR      NOSLOC
     C                   Z-ADD     @TNOTD        ZNRDYS
      *
      ** Local currency applies.
      *
     C                   ELSE
     C     BJDNWD        SUB       1             ZDAYNO
     C                   MOVE      BJLCCY        ZCCY1
     C                   MOVE      BJSLCD        ZLOC1
     C                   Z-ADD     @TNOTL        ZNRDYS
     C                   END
      *
      ** Execute common routine to calculate telex due date
      *
     C                   MOVE      BJLCCY        ZCCY2
     C                   MOVE      BJSLCD        ZLOC2
     C                   Z-ADD     ZDAYNO        ZDYNBR
      *
     C     ZNRDYS        IFNE      0
     C                   CALLB     'ZF2C'
     C                   PARM                    ZRTCD            10
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY1             3
     C                   PARM                    ZLOC1             3
     C                   PARM                    ZCCY2             3
     C                   PARM                    ZLOC2             3
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR            5 0
     C                   END
      *
      * Telex Due Date
      *
     C                   Z-ADD     ZDYNBR        @TLXDU
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* NOSLOC - DETERMINE NOSTRO LOCATION                           *
     C*                                                              *
     C****************************************************************
     C     NOSLOC        BEGSR
      *
      * ACCESS NOSTRO DETAILS
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM      ZCCY1         @CYCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD            10                          CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      @NOSTR        @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C* IF NO RECORD FOUND, ZLOC1 IS BLANK
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *BLANK        ZLOC1
     C                   ELSE
     C*
     C** ELSE MOVE LOCATION (LAST 3 CHARACTERS OF SHORTNAME) INTO ZLOC1
     C*
     C                   MOVE      A7NOSN        ZLOC1
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** Deal or local Currency
     C                   PARM                    @DLOLC            1
      *
      ** Currency
     C                   PARM                    @CCY              3
      *
      ** Nostro
     C                   PARM                    @NOSTR            2
      *
      ** Date of Next Working Day
     C                   PARM                    BJDNWD            5 0
      *
      ** Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** System Location
     C                   PARM                    BJSLCD            3
      *
      ** OUTPUT
      *
      ** Telex Due Date
     C                   PARM                    @TLXDU            5 0
      *
      *
     C                   ENDSR
      *****************************************************************
