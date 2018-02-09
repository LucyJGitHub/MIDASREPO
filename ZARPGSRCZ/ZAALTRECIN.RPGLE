     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine alternative rec instructions')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZAALTRECIN - DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS      *
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
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 06Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  179510 - xxMORI - Midas Our Receive Instructions   field not *
      *           being correctly  updated when the Settlement  method*
      *           is  '04' .  It should  contain  the  Counterparty's *
      *           Prime retail account  , combined of  the Customer No*
      *           default Retail account code , the branch code  and  *
      *           the default  Account Sequence  No-01  .             *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                                  200400
      * DATA STRUCTURE FOR RETAIL DETAILS                                                     200400
                                                                                              200400
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SDNOACCD      E                     EXTFLD(QQACCD)                                     CGL029
      * DATA STRUCTURE FOR NOSTRO CODES
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * DATA STRUCTURE FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      /EJECT
     C*****************************************************************
     C*
     C* WORK FIELDS
     C*
      ** nostro
     C                   MOVEL     *BLANK        @NOSTR            2
      ** settlement type
     C                   Z-ADD     *ZERO         @SETP             2 0
      ** settlement type - front office
     C                   MOVEL     *BLANK        @FSETP            5
      ** our account
     C**********         MOVEL     *BLANK        @OURA            12                          CGL029
     C                   MOVEL     *BLANK        @OURA            18                          CGL029
      ** our account - front office
     C**********         MOVEL     *BLANK        @FOURA           12                          CGL029
     C                   MOVEL     *BLANK        @FOURA           18                          CGL029
      ** counterparty nostro
     C                   MOVEL     *BLANK        @CPNO            10
      ** counterparty nostro - front office
     C                   MOVEL     *BLANK        @FCPNO           10
      ** beneficiary
     C                   MOVEL     *BLANK        @BENN            10
      ** beneficiary - front office
     C                   MOVEL     *BLANK        @FBENN           10
     C*
     C**  DETERMINE FRONT OFFICE RECEIVE INSTRUCTIONS
     C*
     C                   EXSR      RECINS
     C*
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* RECINS -  DETERMINE FRONT OFFICE RECEIVE INSTRUCTIONS         *
     C*                                                               *
     C*****************************************************************
     C     RECINS        BEGSR
     C*
     C** SETTLEMENT TYPE - MIDAS
     C*
     C                   Z-ADD     ##RSTM        ##ORCM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   Z-ADD     ##RSTM        @SETP             2 0
     C                   EXSR      SETTYP
     C                   MOVEL     @FSETP        ##DORM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##RONS        ##MORI
     C*                                                                                       200400
     C** OUR SETTLEMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                      200400
     C*                                                                                       200400
     C     ##RSTM        IFEQ      04                                                         200400
     C**********         MOVEL     ##CNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        ##MORI                                200400 CGL029
     C                   MOVEL     ##CNUM        WRK_16           16                          CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        ##MORI                                       CGL029
     C                   MOVE      '01'          ##MORI                                       200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **the**program*field*.*****************************************                  179510 200400
      ************                                                                     179510 200400
     C*****##RSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      #PMORI        ##MORI                                179510 200400
     C************       ENDIF                                                         179510 200400
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C     ##RSTM        IFEQ      01
     C     ##RSTM        OREQ      02
     C     ##RSTM        OREQ      12
     C     ##RSTM        OREQ      07
     C     ##RSTM        OREQ      08
     C*
     C**  If the settlement method is 01,02, 07, 08, 12
     C**  convert the MIDAS nostro number to a shortname
     C*
     C                   MOVEL     ##RONS        @OURA
     C                   EXSR      OURACT
     C                   MOVEL     @FOURA        ##DORI
     C                   ELSE
     C                   MOVEL     ##RONS        ##DORI
     C                   END
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##RIBN        ##MCPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C     ##RIBN        IFNE      *BLANKS
     C                   MOVEL     ##RIBN        @CPNO
     C                   EXSR      CPTNOS
     C                   MOVE      @FCPNO        ##DCPI
     C                   ELSE
     C                   MOVE      *BLANKS       ##DCPI
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETTYP - CONVERT BACK OFFICE SETTLEMENT TYPE TO FRONT OFFICE  *
     C*                                                               *
     C*****************************************************************
     C     SETTYP        BEGSR
     C*
     C     @SETP         IFEQ      00
     C                   MOVE      *BLANKS       @FSETP
     C                   END
     C     @SETP         IFEQ      01
     C                   MOVE      'TELX '       @FSETP
     C                   END
     C     @SETP         IFEQ      07
     C                   MOVE      'CHIPS'       @FSETP
     C                   END
     C     @SETP         IFEQ      08
     C                   MOVE      'SWIFT'       @FSETP
     C                   END
     C     @SETP         IFEQ      12
     C                   MOVE      'CCOLL'       @FSETP
     C                   END
     C     @SETP         IFEQ      03
     C                   MOVE      'COMP '       @FSETP
     C                   END
     C     @SETP         IFEQ      04
     C                   MOVE      'PCURR'       @FSETP
     C                   END
     C     @SETP         IFEQ      14
     C                   MOVE      'CURR '       @FSETP
     C                   END
     C     @SETP         IFEQ      05
     C                   MOVE      'MACC '       @FSETP
     C                   END
     C     @SETP         IFEQ      06
     C                   MOVE      'SUSP '       @FSETP
     C                   END
     C     @SETP         IFEQ      02
     C                   MOVE      'CSENT'       @FSETP
     C                   END
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* OURACT - CONVERT BACK OFFICE NOSTRO TO FRONT OFFICE FMT       *
     C*                                                               *
     C*****************************************************************
     C     OURACT        BEGSR
     C*
     C                   MOVEL     @OURA         @NOSTR
     C*
     C** NOSTRO OF 00 OR BLANK IS VALID
     C*
     C     @NOSTR        IFEQ      '00'
     C     @NOSTR        OREQ      '  '
     C                   MOVEL     *BLANKS       @FOURA
     C                   ELSE
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      ##RCCY        @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC            10                          CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      @NOSTR        @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH1            1
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C** NOSTRO SHORTNAME
     C*
     C                   MOVEL     A7NOSN        @FOURA
     C                   END
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CPTNOS - CONVERT BACK OFFICE COUNTERPARTY NOSTRO TO FRONT OFFI*
     C*                                                               *
     C*****************************************************************
     C     CPTNOS        BEGSR
     C*
     C* IF IT'S A CUSTOMER NUMBER, USE THE SHORTNAME
     C*
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @CPNO         @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     @RTCD         IFEQ      *BLANKS
     C     @KYST         ANDNE     'ERROR  '
     C     @KYST         ANDNE     '*ERROR '
     C                   MOVE      BBCSSN        @FCPNO
     C*
     C* IF NOT A CUSTOMER, MUST BE A SHORTNAME OR COUNTERPARTY NOSTRO
     C*
     C                   ELSE
     C                   MOVEL     @CPNO         @FCPNO
     C                   END
     C                   ENDSR
     C*****************************************************************
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
      ** Customer number                                                                      200400
     C**********         PARM                    ##CNUM            6 0                 200400 CSD027
     C                   PARM                    ##CNUM            6                          CSD027
      ** Rec currency
     C                   PARM                    ##RCCY            3
      ** Rec - settlement method
     C                   PARM                    ##RSTM            2 0
      ** Rec - our nostro
     C**********         PARM                    ##RONS           12                          CGL029
     C                   PARM                    ##RONS           18                          CGL029
      ** rec - intermediary bank
     C                   PARM                    ##RIBN            8
      ***MIDAS*Our Receive Instructions  ( for Settlem Meth '04' )                     179510 200400
     C************       PARM                    #PMORI           12                   179510 200400
      *
      ** OUTPUT
      *
      ** midas our receive method
     C                   PARM                    ##ORCM            2 0
      ** our receive method
     C                   PARM                    ##DORM            5
      ** midas our receive instructions
     C**********         PARM                    ##MORI           12                          CGL029
     C                   PARM                    ##MORI           18                          CGL029
      ** our receive instructions
     C**********         PARM                    ##DORI           12                          CGL029
     C                   PARM                    ##DORI           18                          CGL029
      ** midas customer payment instructions
     C                   PARM                    ##MCPI           10
      ** customer payment instructions
     C                   PARM                    ##DCPI           10
      *                                                                                       200400
      ** Access Retail details via access program                                             200400
      *                                                                                       200400
     C                   CALLB     'AORETLR0'                                                 200400
     C                   PARM      *BLANK        @RTCD                                        200400
     C                   PARM      '*FIRST '     @OPTN                                        200400
     C     SDRETL        PARM      SDRETL        DSFDY                                        200400
      *
     C                   ENDSR
      *****************************************************************
