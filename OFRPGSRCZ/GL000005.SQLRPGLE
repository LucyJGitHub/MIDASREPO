     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Fixed Asset Details Window')
      *****************************************************************
      *                                                               *
      *  Midas - STANDING DATA MODULE                                 *
      *                                                               *
      *  GL000005  - Fixed Asset Details Window                       *
      *                                                               *
      *  Function:  This program will display a pop-up window upon    *
      *             maintenance of, or enquiry upon, an account.      *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL141  *CREATE    Date 12Dec12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL141 - Amount Accruals Extended Narrative                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03      F3 Pressed EXIT PROGRAM                         *
      *       05      F5 Refresh Input Screen                         *
      *       12      F12 Pressed GOTO PREVIOUS SCREEN                *
      *                                                               *
      *****************************************************************
      *
     FGL0001DF  CF   E             WORKSTN
      * General Fixed Asset Details Window
      *
      /EJECT
      *****************************************************************
      *
     D ARR1            S              1    DIM(12)
     D ARR2            S              1    DIM(11)
      ** Array for formatting character field
      *
      ** array @Z stores amount with decimal (execution time array)
      *
      ** Array @Q stores amount as it is (execution time array)
      *
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
      ** Array used in SR/ZCONVN for currency conversion
      *
      ** Array containing Copyright statement
      *
     D/COPY ZSRSRC,ZALIGNZ1LE
     D/COPY ZSRSRC,ZFRPEDZ1LE
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
     D  L_ZZ019      E                     EXTFLD(ZZ019)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second data structure for Access Programs, long DS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank Details Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access Programs, Short Data Structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details
      *
     D  SARLCD       E                     EXTFLD(LCD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Profile
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data Structure for Currency Codes
      *
      ** PARAMETER ENTRY
      *
     D DATA            DS          1024
     D  #1BRCA                 1      3
     D  #1AREF                 4      9  0
     D  #1ATYP                10     10
      *
     D                 DS
     D  FULNAM                 1     46
     D  @FNAM1                 1     23
     D  @FNAM2                24     46
     D  @FNAM3                47     69
      *
      * Data structure to redefine array @Z as returned field @@AMTD
     D                 DS
     D  @@AMTD                 1     14
     D  @Z                     1     14
     D                                     DIM(14)
      *
      * Data structure to redefine array @Q as input field @@AMTW
     D                 DS
     D  @@AMTW                 1     13  0
     D  @Q                     1     13  0
     D                                     DIM(13)
      *
     D AmtAcc        E DS                  EXTNAME(GLAMAC1D)
     D** Midas GL Amount Accruals extension file

     D APOSTY0       E DS                  EXTNAME(APOSTPD)
     D** Midas GL GE-AA APOSTPD Records

     D CCYCount        S              4  0

      /EJECT
      *****************************************************************
      *                M A I N    P R O C E S S I N G
      *****************************************************************

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

      **   Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1
     C                   PARM                    DATA
     C                   PARM                    W0RTN             7
     C                   PARM                    WLEN              3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    SROW              3 0
     C                   PARM                    SCOL              3 0
     C                   PARM                    TITLE             7
     C                   PARM                    SPARE           256
      *--------------------------------------------------------------
      *
     C                   EXSR      INIT
      *
     C                   WRITE     ASSUMEF
      *
     C     CGL141        IFEQ      'Y'
     C                   EXSR      RESET
     C                   EXSR      PROC1
     C                   ENDIF
      * Exit from program
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      * Send message to program's message queue.
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL(P)  ##PGM         ZAPGMQ
     C                   END
      *
     C     'GB'          CAT       ZAMSGF:0      ZAMSGF
     C                   MOVEL     '12'          ZAMSDA
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
     C     ZAEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      * Clear message file
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Initialise field
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Initialise data
      ** Only do first time through
      *
     C                   MOVE(P)   'D'           ZECODE
     C                   MOVE      '.'           DECMAL            1
     C                   MOVE      'Y'           WFIRST            1
      *
      ** Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define window position
      *
     C                   Z-ADD     SROW          SWROW
     C                   Z-ADD     SCOL          SWCOL
     C                   MOVEL(P)  ##PGM         @@PGM            10
     C                   MOVE      'N'           ERR               1
      *
      ** Establish switchable features
      *
     C                   MOVE      'N'           CGL141            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CGL141'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL141
     C                   ENDIF
      *
      ** Call Access Program for Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Call Access Program for Base Currency Details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6NBDP        WLCDP             2 0
     C                   MOVEL     'Y'           VPROC             1
      *
      ** Determine the last accrual profit date
      *
     C                   MOVEL(P)  #1AREF        WOTRF            21

     C/exec SQL
     C+ select *
     C+ into :APOSTY0
     C+ from APOSTPD
     C+ where SPOS = '  GE-AA'  and OTRF = :WOTRF
     C/end-exec

     C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'
     C                   Z-ADD     VALD          ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        WACDT             6
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Reset/Refresh the screen if F5 is pressed  FORMAT A
      *****************************************************************
     C     RESET         BEGSR
      *
      ** Reset all error indicators
     C                   SETOFF                                       20
     C                   MOVEA     '00000000'    *IN(31)
     C                   MOVEA     '0'           *IN(39)
      *
      ** Protect input fields if enquiry and enable command keys
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C     ACTN          OREQ      'A'
      *
     C/exec SQL
     C+ select *
     C+ into :AmtAcc
     C+ from GLAMAC1D
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec

     C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'

      ** Get decimal value using purchase currency
     C                   MOVE(P)   SGPCCY        @AJCD
     C                   EXSR      GETCCY
     C                   MOVEL     *BLANKS       SGPCCY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A6CYCD        SGPCCY
     C                   ENDIF
     C                   MOVEL(P)  SGPCCY        #PCCY
      *
     C                   MOVEL(P)  SGASTP        #ASTP
     C                   MOVEL(P)  SGASTD        #ASTD
     C                   MOVEL(P)  SGACAT        #ACAT
     C                   MOVEL(P)  SGACAD        #ACAD
     C                   MOVEL(P)  SGADES        #ADES
      *
     C     SGPDAT        IFNE      *ZERO
     C                   Z-ADD     SGPDAT        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #PDAT
     C                   ENDIF
      *
     C     SGPVFC        IFNE      *ZERO
     C                   MOVE(P)   SGPVFC        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PVFC
     C                   ENDIF
      *
     C     SGCNRT        IFNE      *ZERO
     C                   MOVE(P)   SGCNRT        @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #CNRT
     C                   ENDIF
      *
     C     SGPVLC        IFNE      *ZERO
     C                   MOVE(P)   SGPVLC        @@AMTW
     C                   Z-ADD     WLCDP         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PVLC
     C                   ENDIF
      *
     C     SGQNTY        IFNE      *ZERO
     C                   MOVE(P)   SGQNTY        @@AMTW
     C                   Z-ADD     *ZERO         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #QNTY
     C                   ENDIF
      *
     C                   MOVEL(P)  SGSPNM        #SPNM
     C                   MOVEL(P)  SGLOCN        #LOCN
     C                   MOVEL(P)  SGLODE        #LODE
     C                   MOVEL(P)  SGLOC1        #LOC1
     C                   MOVEL(P)  SGREM1        #REM1
     C                   MOVEL(P)  SGREM2        #REM2
     C                   MOVEL(P)  SGPMOD        #PMOD
     C                   MOVEL(P)  SGPYNO        #PYNO
      *
     C     SGRTDP        IFNE      *ZERO
     C                   MOVE(P)   SGRTDP        @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #RTDP
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * If Insert or Amend and no record on AmtAcc
      * product code if defined for the account
      *
     C                   IF        ACTN = 'A'
     C                             and %Subst(SQLState:1:2) = '02'
     C                             or ACTN = 'I'
      *
     C                   MOVEL     *BLANKS       #ASTP
     C                   MOVEL     *BLANKS       #ASTD
     C                   MOVEL     *BLANKS       #ACAT
     C                   MOVEL     *BLANKS       #ACAD
     C                   MOVEL     *BLANKS       #ADES
     C                   MOVEL     *BLANKS       #PDAT
     C                   MOVEL     *BLANKS       #PVFC
     C                   MOVEL     *BLANKS       #CNRT
     C                   MOVEL     *BLANKS       #PVLC
     C                   MOVEL     *BLANKS       #PCCY
     C                   MOVEL     *BLANKS       #QNTY
     C                   MOVEL     *BLANKS       #SPNM
     C                   MOVEL     *BLANKS       #LOCN
     C                   MOVEL     *BLANKS       #LODE
     C                   MOVEL     *BLANKS       #LOC1
     C                   MOVEL     *BLANKS       #REM1
     C                   MOVEL     *BLANKS       #REM2
     C                   MOVEL     *BLANKS       #PMOD
     C                   MOVEL     *BLANKS       #PYNO
     C                   MOVEL     *BLANKS       #RTDP
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Reset/Refresh the screen if F5 is pressed  FORMAT B
      *****************************************************************
     C     RESETB        BEGSR
      *
      ** Reset all error indicators
     C                   SETOFF                                       20
     C                   MOVEA     '00000000'    *IN(40)
     C                   MOVEA     '00000000'    *IN(48)
     C                   MOVEA     '0'           *IN(56)
      *
      ** Protect input fields if enquiry and enable command keys
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C     ACTN          OREQ      'A'
      *
     C/exec SQL
     C+ select *
     C+ into :AmtAcc
     C+ from GLAMAC1D
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec

     C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'

      ** Get decimal value using purchase currency
     C     #PCCY         IFEQ      *BLANKS
     C                   ELSE
     C                   MOVE(P)   SGPCCY        @AJCD
     C                   EXSR      GETCCY
     C                   MOVEL     *BLANKS       SGPCCY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A6CYCD        SGPCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Write Off
      *
     C     SGPWDT        IFNE      *ZERO
     C                   Z-ADD     SGPWDT        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #PWDT
     C                   MOVEL     #PWDT         WPWDT             6
     C                   ENDIF
      *
     C     SGPWQT        IFNE      *ZERO
     C                   MOVE(P)   SGPWQT        @@AMTW
     C                   Z-ADD     *ZERO         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PWQT
     C                   ENDIF
     C                   Z-ADD     SGPWQT        WPWQT             5 0
      *
     C     SGPLDD        IFNE      *ZERO
     C                   Z-ADD     SGPLDD        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #PLDD
     C                   ENDIF
      *
     C     SGPPVQ        IFNE      *ZERO
     C                   MOVE(P)   SGPPVQ        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PPVQ
     C                   ENDIF
      *
     C     SGPPLC        IFNE      *ZERO
     C                   MOVE(P)   SGPPLC        @@AMTW
     C                   Z-ADD     WLCDP         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PPLC
     C                   ENDIF
      *
     C     SGPDQT        IFNE      *ZERO
     C                   MOVE(P)   SGPDQT        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PDQT
     C                   ENDIF
      *
     C     SGPBQT        IFNE      *ZERO
     C                   MOVE(P)   SGPBQT        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #PBQT
     C                   ENDIF
      *
      ** Complete Write Off
      *
     C     SGCWDT        IFNE      *ZERO
     C                   Z-ADD     SGCWDT        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #CWDT
     C                   MOVEL     #CWDT         WCWDT             6
     C                   ENDIF
      *
     C     SGCLDD        IFNE      *ZERO
     C                   Z-ADD     SGCLDD        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #CLDD
     C                   ENDIF
      *
     C     SGCPVQ        IFNE      *ZERO
     C                   MOVE(P)   SGCPVQ        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #CPVQ
     C                   ENDIF
     C                   Z-ADD     SGCPVQ        WCPVEQ            5 0
      *
     C     SGCPLC        IFNE      *ZERO
     C                   MOVE(P)   SGCPLC        @@AMTW
     C                   Z-ADD     WLCDP         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #CPLC
     C                   ENDIF
      *
     C     SGCDQT        IFNE      *ZERO
     C                   MOVE(P)   SGCDQT        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #CDQT
     C                   ENDIF
      *
     C     SGCBQT        IFNE      *ZERO
     C                   MOVE(P)   SGCBQT        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #CBQT
     C                   ENDIF
      *
      ** Complete Sale
      *
     C     SGDTSL        IFNE      *ZERO
     C                   Z-ADD     SGDTSL        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #DTSL
     C                   ENDIF
      *
     C     SGSLDD        IFNE      *ZERO
     C                   Z-ADD     SGSLDD        ZDAYNO
     C                   EXSR      FORDAT
     C                   MOVEL(P)  ZDATFM        #SLDD
     C                   ENDIF
      *
     C                   MOVEL(P)  SGBNAM        #BNAM
     C                   MOVEL(P)  #BNAM         WBNAM            30
     C                   MOVEL(P)  SGBAD1        #BAD1
     C                   MOVEL(P)  SGBAD2        #BAD2
     C                   MOVEL(P)  SGPRMO        #PRMO
     C                   MOVEL(P)  SGPRNO        #PRNO
      *
     C     SGARCV        IFNE      *ZERO
     C                   MOVE(P)   SGARCV        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #ARCV
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * If Insert or Amend and no record on AmtAcc
      * product code if defined for the account
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
      *
     C                   If        %Subst(SQLState:1:2) = '02'
      *
      ** Partial Write Off
     C                   MOVEL     *BLANKS       #PWDT
     C                   MOVEL     *BLANKS       #PWQT
     C                   MOVEL     *BLANKS       #PLDD
     C                   MOVEL     *BLANKS       #PPVQ
     C                   MOVEL     *BLANKS       #PPLC
     C                   MOVEL     *BLANKS       #PDQT
     C                   MOVEL     *BLANKS       #PBQT
      *
      ** Complete Write Off
     C                   MOVEL     *BLANKS       #CWDT
     C                   MOVEL     *BLANKS       #CLDD
     C                   MOVEL     *BLANKS       #CPVQ
     C                   MOVEL     *BLANKS       #CPLC
     C                   MOVEL     *BLANKS       #CDQT
     C                   MOVEL     *BLANKS       #CBQT
      *
      ** Complete Sale
     C                   MOVEL     *BLANKS       #DTSL
     C                   MOVEL     *BLANKS       #SLDD
     C                   MOVEL     *BLANKS       #BNAM
     C                   MOVEL     *BLANKS       #BAD1
     C                   MOVEL     *BLANKS       #BAD2
     C                   MOVEL     *BLANKS       #PRMO
     C                   MOVEL     *BLANKS       #PRNO
     C                   MOVEL     *BLANKS       #ARCV
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * CLEAR 2
      *****************************************************************
      *
     C     CLRF2         BEGSR
     C                   CLEAR                   GL0001F2
     C                   Z-ADD     SROW          SWROW
     C                   Z-ADD     SCOL          SWCOL
     C                   MOVEL(P)  @@PGM         ##PGM
     C*                    MOVELTEXT      STITL     P
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Procedure 1
      *****************************************************************
      *
     C     PROC1         BEGSR
      *
      ** Continue to redisplay the screen if *IN,03,12 remains off
      *
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
     C     VPROC         ANDEQ     'Y'
      *
      ** Main format of the display file
      *
     C     ERR           IFEQ      'Y'
     C                   WRITE     #MSGCTL
     C                   ENDIF
     C                   EXFMT     GL0001F1
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   MOVE      'N'           ERR
     C                   MOVEA     '00000000'    *IN(30)
     C                   MOVEA     '00000000'    *IN(38)
     C                   MOVEA     '00000000'    *IN(46)
     C                   MOVEA     '000'         *IN(54)
      *
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C                   MOVE(P)   'Y2U9999'     W0RTN
     C     *IN05         WHENEQ    *ON
     C                   EXSR      RESET
     C     *IN12         WHENEQ    *ON
     C                   MOVE(P)   'USR0790'     W0RTN
     C                   OTHER
     C                   MOVEL     'N'           WDFT1             1
     C     ACTN          IFNE      'D'
     C                   EXSR      VAL1
     C                   ENDIF
      *
     C     ERR           IFEQ      'N'
     C     WDFT1         ANDEQ     'N'
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
     C     WFIRST        IFEQ      'Y'
     C                   EXSR      CLRF2
     C                   ENDIF
     C                   ENDIF
      *
      ** Refresh only for first time
      *
     C     WFIRST        IFEQ      'Y'
     C                   EXSR      RESETB
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
      *
     C                   EXSR      PROC2
      *
     C     *IN12         IFEQ      *ON
     C                   SETOFF                                       12
     C                   ELSE
     C                   MOVEL(P)  'N'           VPROC
     C                   ENDIF
     C     ERR           IFEQ      'Y'
     C                   MOVEL(P)  'Y'           VPROC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDDO
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Procedure 2
      *****************************************************************
     C     PROC2         BEGSR
      *
      ** Continue to redisplay the screen if *IN,03,12 remains off
      *
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
      ** Main format of the display file
      *
     C     ERR           IFEQ      'Y'
     C                   WRITE     #MSGCTL2
     C                   ENDIF
     C                   EXFMT     GL0001F2
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL2
     C                   MOVE      'N'           ERR
     C                   MOVEA     '00000000'    *IN(40)
     C                   MOVEA     '00000000'    *IN(48)
     C                   MOVEA     '000'         *IN(54)
      *
     C                   MOVE(P)   *BLANKS       W0RTN
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C                   MOVE(P)   'Y2U9999'     W0RTN
     C     *IN05         WHENEQ    *ON
     C                   EXSR      CLRF2
     C                   EXSR      RESETB
     C     *IN12         WHENEQ    *ON
     C                   MOVE(P)   'USR0790'     W0RTN
     C                   OTHER
     C     ACTN          IFNE      'D'
     C                   MOVE      'N'           WDFTP             1
     C                   MOVE      'N'           WDFTC             1
     C                   MOVE      'N'           WDFTS             1
     C                   MOVEL     'N'           WDFT2             1
     C                   EXSR      VAL2
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C     ERR           IFEQ      'N'
     C     WDFTP         ANDEQ     'N'
     C     WDFTC         ANDEQ     'N'
     C     WDFTS         ANDEQ     'N'
     C     WDFT2         ANDEQ     'N'
     C                   SETON                                        12
     C                   MOVEL(P)  'N'           VPROC
     C                   EXSR      UPDATE
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDDO
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Get Currency Details
      *****************************************************************
     C     GETCCY        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Clear @AJCD for next use
      *
     C                   CLEAR                   @AJCD
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Validate date
      *****************************************************************
     C     VALDAT        BEGSR
      *
     C                   CALL      'ZA0270'
     C                   PARM                    WDATE             6 0
     C                   PARM      BJDFIN        WFRMT             1
     C                   PARM      *BLANKS       WERROR            1
     C                   PARM                    WDYNO             5 0
      *
      ** Clear WDATE for next use
      *
     C                   CLEAR                   WDATE
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Format date to MM/DD/YY
      *****************************************************************
     C     FORDAT        BEGSR
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        ZDYNBR            1
     C                   PARM                    ZDATFM            6 0
     C                   PARM                    ZDATE             7
      *
      ** Clear ZDAYNO for next use
      *
     C                   CLEAR                   ZDAYNO
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Validate the screen 1
      *****************************************************************
     C     VAL1          BEGSR
      *
      ** Purchase Date
      *
     C                   Z-ADD     *ZERO         WPDAT             5 0
     C     #PDAT         IFNE      *BLANKS
     C                   MOVE(P)   #PDAT         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         WPDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN32
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1102'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** Currency
      *
     C     #PCCY         IFNE      *BLANKS
     C                   Z-ADD     *ZERO         #PCCYD            1 0
      *
     C/exec SQL
     C+ select count(*)
     C+ into :CCYCount
     C+ from SDCURRL2 L
     C+ where L.A6CYCD = :#PCCY
     C/end-exec

     C                   If        CCYCount = 0
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN34
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1104'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      *
     C                   MOVE(P)   #PCCY         @AJCD
     C                   EXSR      GETCCY
     C                   MOVE      A6CYCD        #PCCY
     C                   Z-ADD     A6NBDP        #PCCYD
     C                   ENDIF
     C                   ENDIF
      *
      ** Purchase Value in Foreign Currency
      *
     C                   Z-ADD     *ZERO         WPVFC            16 0
     C     #PVFC         IFNE      *BLANKS
     C                   MOVEL     'Y'           OKPVFC            1
      *
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKPVFC
     C                   MOVE      *ON           *IN33
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1129'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PVFC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WPVFC
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           OKPVFC
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN33
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1103'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Conversion Rate
     C                   Z-ADD     *ZERO         WCNRT            13 8
     C     #CNRT         IFNE      *BLANKS
     C                   MOVEL     'Y'           OKCNRT            1
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CNRT         ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WCNRT
     C     WCNRT         MULT      10            WCNRT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           OKCNRT
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN35
     C                   MOVEL     'GLX1105'     ZAMSID
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** Compute correct purchase value in local currency
      *
     C     *LIKE         DEFINE    #PVLC         WPVLC
     C                   MOVEL     *BLANKS       WPVLC
     C     #CNRT         IFNE      *BLANKS
     C     OKCNRT        ANDEQ     'Y'
     C     #PVFC         ANDNE     *BLANKS
     C     OKPVFC        ANDEQ     'Y'
     C                   MOVEL     #PCCY         ZCCYI
     C                   MOVEL     BJCYCD        ZCCYO
     C                   Z-ADD     #PCCYD        ZCDPI
     C                   Z-ADD     WLCDP         ZCDPO
     C                   Z-ADD     WPVFC         ZAMTCI
     C                   Z-ADD     WCNRT         ZEXCH
     C                   EXSR      ZCONV
     C                   MOVE(P)   ZAMTCO        @@AMTW
     C                   Z-ADD     WLCDP         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        WPVLC
     C                   ENDIF
      *
      ** Purchase Value in Local Currency
      *
     C     #PVLC         IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PVLC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     WLCDP         ZADEC
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1106'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     #PVLC         IFNE      WPVLC
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN36
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1138'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     #CNRT         IFNE      *BLANKS
     C     OKCNRT        ANDEQ     'Y'
     C     #PVFC         ANDNE     *BLANKS
     C     OKPVFC        ANDEQ     'Y'
     C                   MOVE(P)   WPVLC         #PVLC
     C                   MOVEL     'Y'           WDFT1
     C                   ENDIF
     C                   ENDIF
      *
      ** Quantity
      *
     C                   Z-ADD     *ZERO         WQNTY            16 0
     C     #QNTY         IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #QNTY         ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WQNTY
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN37
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1107'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** Remarks
      *
     C     #REM1         IFEQ      *BLANKS
     C     #REM2         ANDNE     *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN39
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1109'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Rate of Depreciation
      *
     C                   Z-ADD     *ZERO         WRTDP            13 8
     C     #RTDP         IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #RTDP         ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WRTDP
     C     WRTDP         MULT      10            WRTDP
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN31
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1101'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WRTDP         IFGT      100
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN31
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1139'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Validate the screen 2
      *****************************************************************
     C     VAL2          BEGSR
     C                   MOVEA     '000'         *IN(61)
      *
      ** Partial Write off Date
      *
     C     #PWDT         IFNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   MOVE(P)   #PWDT         WDATE
     C                   EXSR      VALDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN40
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1110'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Partial write off date must not be prior the purchase date
      *
     C     WDYNO         IFLT      WPDAT
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN40
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1142'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Write off Quantity
      *
     C                   Z-ADD     *ZERO         WPWQTN           16 0
     C     #PWQT         IFNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PWQT         ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WPWQTN
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN41
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WPWQTN        IFGT      WQNTY
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN41
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1150'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Write off Purch Value for w/f Qty
      *
     C                   Z-ADD     *ZERO         WPPVQ            16 0
     C     #PPVQ         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN61
     C                   MOVEL     'Y'           OKPPVQ            1
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKPPVQ
     C                   MOVE      *ON           *IN42
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1130'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PPVQ         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WPPVQ
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKPPVQ
     C                   MOVE      *ON           *IN42
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1112'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WPPVQ         IFGT      WPVFC
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKPPVQ
     C                   MOVE      *ON           *IN42
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1151'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Compute correct partial w/d value in local ccy
      *
     C     *LIKE         DEFINE    #PPLC         WPPLC
     C                   MOVEL     *BLANKS       WPPLC
     C     #CNRT         IFNE      *BLANKS
     C     OKCNRT        ANDEQ     'Y'
     C     #PPVQ         ANDNE     *BLANKS
     C     OKPPVQ        ANDEQ     'Y'
     C                   MOVEL     #PCCY         ZCCYI
     C                   MOVEL     BJCYCD        ZCCYO
     C                   Z-ADD     #PCCYD        ZCDPI
     C                   Z-ADD     WLCDP         ZCDPO
     C                   Z-ADD     WPPVQ         ZAMTCI
     C                   Z-ADD     WCNRT         ZEXCH
     C                   EXSR      ZCONV
     C                   MOVE(P)   ZAMTCO        @@AMTW
     C                   Z-ADD     WLCDP         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        WPPLC
     C                   ENDIF
      *
      ** Partial Write off Purch Value for w/f Qty in Local Ccy
      *
     C     #PPLC         IFNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PPLC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     WLCDP         ZADEC
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN43
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1113'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     #PPLC         IFNE      WPPLC
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN43
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1156'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Default write off purchase value in local currency
      *
     C     #CNRT         IFNE      *BLANKS
     C     OKCNRT        ANDEQ     'Y'
     C     #PPVQ         ANDNE     *BLANKS
     C     OKPPVQ        ANDEQ     'Y'
     C                   MOVE(P)   WPPLC         #PPLC
     C                   MOVEL     'Y'           WDFT2
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Write off Dep Value for w/f Qty
     C                   Z-ADD     *ZERO         WPDQT            16 0
     C     #PDQT         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN61
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN44
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1131'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PDQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WPDQT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN44
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1114'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WPDQT         IFGT      WPPVQ
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN44
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1141'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Write off Date Last Dep Date
      *
     C     #PLDD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   MOVE(P)   #PLDD         WDATE
     C                   EXSR      VALDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1124'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WDYNO         IFLT      WPDAT
     C     WDYNO         ORGT      BJRDNB
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1145'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Write off Book Value for w/f Qty
      *
     C                   Z-ADD     *ZERO         WPBQT            16 0
     C     #PBQT         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN61
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN45
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1132'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PBQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WPBQT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN45
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1115'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WPBQT         IFGT      WPPVQ
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN45
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1153'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Complete Write off Date
      *
     C     #CWDT         IFNE      *BLANKS
     C                   MOVE      *ON           *IN62
     C                   MOVE(P)   #CWDT         WDATE
     C                   EXSR      VALDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN46
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1116'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Complete write off date must not be prior the purchase date
      *
     C     WDYNO         IFLT      WPDAT
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN46
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1143'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Complete Write off Purch Value for w/f Qty
      *
     C                   Z-ADD     *ZERO         WCPVQ            16 0
     C     #CPVQ         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN62
     C                   MOVEL     'Y'           OKCPVQ            1
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKCPVQ
     C                   MOVE      *ON           *IN47
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1133'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CPVQ         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WCPVQ
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKCPVQ
     C                   MOVE      *ON           *IN47
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1117'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WCPVQ         IFGT      WPVFC
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'N'           OKCPVQ
     C                   MOVE      *ON           *IN47
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1152'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Complete Write off Purch Value for w/f Qty in Local Ccy
      *
     C     #CPLC         IFNE      *BLANKS
     C                   MOVE      *ON           *IN62
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CPLC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     WLCDP         ZADEC
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN48
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1118'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
      *
      ** Default write off purchase value in local currency
      *
     C     #CNRT         IFNE      *BLANKS
     C     OKCNRT        ANDEQ     'Y'
     C     #CPVQ         ANDNE     *BLANKS
     C     OKCPVQ        ANDEQ     'Y'
     C                   MOVEL     #PCCY         ZCCYI
     C                   MOVEL     BJCYCD        ZCCYO
     C                   Z-ADD     #PCCYD        ZCDPI
     C                   Z-ADD     WLCDP         ZCDPO
     C                   Z-ADD     WCPVQ         ZAMTCI
     C                   Z-ADD     WCNRT         ZEXCH
     C                   EXSR      ZCONV
     C                   MOVE(P)   ZAMTCO        @@AMTW
     C                   Z-ADD     WLCDP         @@QECN
     C                   EXSR      ZA0920
     C                   MOVE(P)   @@AMTD        #CPLC
     C                   MOVEL     'Y'           WDFT2
     C                   ENDIF
     C                   ENDIF
      *
      ** Complete Write off Dep Value for w/f Qty
     C                   Z-ADD     *ZERO         WCDQT            16 0
     C     #CDQT         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN62
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN49
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1134'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CDQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WCDQT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN49
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1119'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WCDQT         IFGT      WCPVQ
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN49
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1148'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Complete Write off Last Dep Date
      *
     C     #CLDD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN62
      *
     C                   MOVE(P)   #CLDD         WDATE
     C                   EXSR      VALDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN55
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1125'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WDYNO         IFLT      WPDAT
     C     WDYNO         ORGT      BJRDNB
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN55
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1146'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Complete Write off Book Value for w/f Qty
      *
     C                   Z-ADD     *ZERO         WCBQT            16 0
     C     #CBQT         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN62
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1135'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CBQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WCBQT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1120'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WCBQT         IFGT      WCPVQ
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1154'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Date of Sale
     C     #DTSL         IFNE      *BLANKS
     C                   MOVE      *ON           *IN63
     C                   MOVE(P)   #DTSL         WDATE
     C                   EXSR      VALDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1121'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Complete date of sale must not be prior the purchase date
      *
     C     WDYNO         IFLT      WPDAT
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1144'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Amount Received
      *
     C     #ARCV         IFNE      *BLANKS
      *
     C                   MOVE      *ON           *IN63
     C     #PCCY         IFEQ      *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1136'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #ARCV         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     #PCCYD        ZADEC
     C                   EXSR      ZALIGN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1122'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Buyer's Address
      *
     C     #BAD1         IFEQ      *BLANKS
     C     #BAD2         ANDNE     *BLANKS
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN53
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1123'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Complete Sale Last Dep Date
      *
     C     #SLDD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN63
     C                   MOVE(P)   #SLDD         WDATE
     C                   EXSR      VALDAT
      *
     C     WERROR        IFEQ      '1'
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN56
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1127'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WDYNO         IFLT      WPDAT
     C     WDYNO         ORGT      BJRDNB
     C                   MOVE      'Y'           ERR
     C                   MOVE      *ON           *IN56
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1147'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Buyer's name, Address, Pay Recv Mode/No
      *
     C     #BAD1         IFNE      *BLANKS
     C     #BAD2         ORNE      *BLANKS
     C     #BNAM         ORNE      *BLANKS
     C     #PRMO         ORNE      *BLANKS
     C     #PRNO         ORNE      *BLANKS
     C                   MOVE      *ON           *IN63
     C                   ENDIF
      *
      ** Only enter details for one section
      *
     C     *IN61         IFEQ      *ON
     C     *IN62         ANDEQ     *ON
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1140'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     *IN62         IFEQ      *ON
     C     *IN63         ANDEQ     *ON
     C                   MOVE      'Y'           ERR
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   MOVEL     'GLX1149'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Dep Date Defaulting
      *
     C     WACDT         IFNE      *BLANKS
      *
     C     *IN61         IFEQ      *ON
     C     #PLDD         ANDEQ     *BLANKS
     C                   MOVEL(P)  WACDT         #PLDD
     C                   MOVE      'Y'           WDFTP
     C                   ENDIF
      *
     C     *IN62         IFEQ      *ON
     C     #CLDD         ANDEQ     *BLANKS
     C                   MOVEL(P)  WACDT         #CLDD
     C                   MOVE      'Y'           WDFTC
     C                   ENDIF
      *
     C     *IN63         IFEQ      *ON
     C     #SLDD         ANDEQ     *BLANKS
     C                   MOVEL(P)  WACDT         #SLDD
     C                   MOVE      'Y'           WDFTS
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Update the extension file
      *****************************************************************
     C     UPDATE        BEGSR
      *
     C     ACTN          IFEQ      'I'
      *
     C                   CLEAR                   AmtAcc
     C                   EXSR      MOVRT1
     C                   EXSR      MOVRT2
      *
     C/exec SQL
     C+ insert into GLAMAC1D
     C+    ( SGBRCA
     C+     ,SGAREF
     C+     ,SGATYP
     C+     ,SGASTP
     C+     ,SGASTD
     C+     ,SGRTDP
     C+     ,SGACAT
     C+     ,SGACAD
     C+     ,SGADES
     C+     ,SGPDAT
     C+     ,SGPVFC
     C+     ,SGPCCY
     C+     ,SGCNRT
     C+     ,SGPVLC
     C+     ,SGQNTY
     C+     ,SGSPNM
     C+     ,SGLOCN
     C+     ,SGLODE
     C+     ,SGLOC1
     C+     ,SGREM1
     C+     ,SGREM2
     C+     ,SGPMOD
     C+     ,SGPYNO
     C+     ,SGPWDT
     C+     ,SGPWQT
     C+     ,SGPPVQ
     C+     ,SGPPLC
     C+     ,SGPDQT
     C+     ,SGPLDD
     C+     ,SGPBQT
     C+     ,SGCWDT
     C+     ,SGCPVQ
     C+     ,SGCPLC
     C+     ,SGCDQT
     C+     ,SGCLDD
     C+     ,SGCBQT
     C+     ,SGBNAM
     C+     ,SGBAD1
     C+     ,SGBAD2
     C+     ,SGPRNO
     C+     ,SGPRMO
     C+     ,SGARCV
     C+     ,SGDTSL
     C+     ,SGSLDD )
     C+ values
     C+ (:SGBRCA
     C+     ,:SGAREF
     C+     ,:SGATYP
     C+     ,:SGASTP
     C+     ,:SGASTD
     C+     ,:SGRTDP
     C+     ,:SGACAT
     C+     ,:SGACAD
     C+     ,:SGADES
     C+     ,:SGPDAT
     C+     ,:SGPVFC
     C+     ,:SGPCCY
     C+     ,:SGCNRT
     C+     ,:SGPVLC
     C+     ,:SGQNTY
     C+     ,:SGSPNM
     C+     ,:SGLOCN
     C+     ,:SGLODE
     C+     ,:SGLOC1
     C+     ,:SGREM1
     C+     ,:SGREM2
     C+     ,:SGPMOD
     C+     ,:SGPYNO
     C+     ,:SGPWDT
     C+     ,:SGPWQT
     C+     ,:SGPPVQ
     C+     ,:SGPPLC
     C+     ,:SGPDQT
     C+     ,:SGPLDD
     C+     ,:SGPBQT
     C+     ,:SGCWDT
     C+     ,:SGCPVQ
     C+     ,:SGCPLC
     C+     ,:SGCDQT
     C+     ,:SGCLDD
     C+     ,:SGCBQT
     C+     ,:SGBNAM
     C+     ,:SGBAD1
     C+     ,:SGBAD2
     C+     ,:SGPRNO
     C+     ,:SGPRMO
     C+     ,:SGARCV
     C+     ,:SGDTSL
     C+     ,:SGSLDD )
     C/end-exec

     C                   ENDIF
      *
     C     ACTN          IFEQ      'A'
      *
     C/exec SQL
     C+ select *
     C+ into :AmtAcc
     C+ from GLAMAC1D
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec

     C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'
      *
     C                   EXSR      MOVRT1
     C                   EXSR      MOVRT2

     C/exec SQL
     C+ update GLAMAC1D
     C+ set  SGBRCA =  :SGBRCA
     C+     ,SGAREF =  :SGAREF
     C+     ,SGATYP =  :SGATYP
     C+     ,SGASTP =  :SGASTP
     C+     ,SGASTD =  :SGASTD
     C+     ,SGRTDP =  :SGRTDP
     C+     ,SGACAT =  :SGACAT
     C+     ,SGACAD =  :SGACAD
     C+     ,SGADES =  :SGADES
     C+     ,SGPDAT =  :SGPDAT
     C+     ,SGPVFC =  :SGPVFC
     C+     ,SGPCCY =  :SGPCCY
     C+     ,SGCNRT =  :SGCNRT
     C+     ,SGPVLC =  :SGPVLC
     C+     ,SGQNTY =  :SGQNTY
     C+     ,SGSPNM =  :SGSPNM
     C+     ,SGLOCN =  :SGLOCN
     C+     ,SGLODE =  :SGLODE
     C+     ,SGLOC1 =  :SGLOC1
     C+     ,SGREM1 =  :SGREM1
     C+     ,SGREM2 =  :SGREM2
     C+     ,SGPMOD =  :SGPMOD
     C+     ,SGPYNO =  :SGPYNO
     C+     ,SGPWDT =  :SGPWDT
     C+     ,SGPWQT =  :SGPWQT
     C+     ,SGPPVQ =  :SGPPVQ
     C+     ,SGPPLC =  :SGPPLC
     C+     ,SGPDQT =  :SGPDQT
     C+     ,SGPLDD =  :SGPLDD
     C+     ,SGPBQT =  :SGPBQT
     C+     ,SGCWDT =  :SGCWDT
     C+     ,SGCPVQ =  :SGCPVQ
     C+     ,SGCPLC =  :SGCPLC
     C+     ,SGCDQT =  :SGCDQT
     C+     ,SGCLDD =  :SGCLDD
     C+     ,SGCBQT =  :SGCBQT
     C+     ,SGBNAM =  :SGBNAM
     C+     ,SGBAD1 =  :SGBAD1
     C+     ,SGBAD2 =  :SGBAD2
     C+     ,SGPRNO =  :SGPRNO
     C+     ,SGPRMO =  :SGPRMO
     C+     ,SGARCV =  :SGARCV
     C+     ,SGDTSL =  :SGDTSL
     C+     ,SGSLDD =  :SGSLDD
     C+ where SGBRCA =  :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec

     C                   ELSE
     C                   CLEAR                   AmtAcc
     C                   EXSR      MOVRT1
     C                   EXSR      MOVRT2
     C/exec SQL
     C+ insert into GLAMAC1D
     C+ values(:AmtAcc)
     C/end-exec

     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Move 1 subroutine (1st Screen)
      *****************************************************************
     C     MOVRT1        BEGSR
      *
     C     #PCCY         IFNE      *BLANKS
     C                   MOVE      #PCCY         @AJCD
     C                   EXSR      GETCCY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A6CYCD        #PCCY
     C                   ELSE
     C                   MOVE      *BLANKS       #PCCY
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL(P)  #1BRCA        SGBRCA
     C                   MOVEL(P)  #1AREF        SGAREF
     C                   MOVEL(P)  #1ATYP        SGATYP
      *
     C                   MOVEL(P)  #ASTP         SGASTP
     C                   MOVEL(P)  #ASTD         SGASTD
     C                   MOVEL(P)  #ACAT         SGACAT
     C                   MOVEL(P)  #ACAD         SGACAD
     C                   MOVEL(P)  #ADES         SGADES
      *
     C                   MOVE(P)   #PDAT         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGPDAT
      *
     C                   MOVEL(P)  #PCCY         SGPCCY
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PVFC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPVFC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CNRT         ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGCNRT
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PVLC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     WLCDP         ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPVLC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #QNTY         ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGQNTY
      *
     C                   MOVEL(P)  #SPNM         SGSPNM
     C                   MOVEL(P)  #LOCN         SGLOCN
     C                   MOVEL(P)  #LODE         SGLODE
     C                   MOVEL(P)  #LOC1         SGLOC1
     C                   MOVEL(P)  #REM1         SGREM1
     C                   MOVEL(P)  #REM2         SGREM2
     C                   MOVEL(P)  #PMOD         SGPMOD
     C                   MOVEL(P)  #PYNO         SGPYNO
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #RTDP         ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGRTDP
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * Move 2 subroutine (2nd Screen)
      *****************************************************************
     C     MOVRT2        BEGSR
      *
      ** Partial Write Off
      *
     C                   MOVE(P)   #PWDT         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGPWDT
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PWQT         ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPWQT
      *
     C                   MOVE(P)   #PLDD         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGPLDD
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PPVQ         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPPVQ
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PPLC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     WLCDP         ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPPLC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PDQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPDQT
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #PBQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGPBQT
      *
      ** Complete Write Off
      *
     C                   MOVE(P)   #CWDT         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGCWDT
      *
     C                   MOVE(P)   #CLDD         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGCLDD
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CPVQ         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGCPVQ
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CPLC         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     WLCDP         ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGCPLC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CDQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGCDQT
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #CBQT         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGCBQT
      *
      ** Complete Sale
      *
     C                   MOVE(P)   #DTSL         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGDTSL
      *
     C                   MOVE(P)   #SLDD         WDATE
     C                   EXSR      VALDAT
     C                   Z-ADD     WDYNO         SGSLDD
      *
     C                   MOVEL(P)  #BNAM         SGBNAM
     C                   MOVEL(P)  #BAD1         SGBAD1
     C                   MOVEL(P)  #BAD2         SGBAD2
     C                   MOVEL(P)  #PRMO         SGPRMO
     C                   MOVEL(P)  #PRNO         SGPRNO
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   #ARCV         ZFIELD
     C                   Z-ADD     12            ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE(P)   ZFIELD        SGARCV
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * ZA0920 routine
      *****************************************************************
     C     ZA0920        BEGSR
      *
      * INITIALIZATION
     C                   MOVE      '0'           @@SWT1            1
      *
      * FINDING WHERE DECIMAL POSITION IS
      *
     C     14            SUB       @@QECN        @@QECW            2 0
      *
      * FINDING OUT MOST SIGNIFICANT POSITION
      *
     C     @@QECW        SUB       1             @@SIG             2 0
     C                   MOVEA     *BLANKS       @Z
     C                   Z-ADD     1             @@Q               2 0
      *
      * CHECK TO SEE IF NO.OF DECIMAL PLACES IS ZERO. IF ZERO
      * THEN SIGNIFICANT POSITION IS 14 AND POSITION 1 IS BLANK
     C     @@QECW        IFEQ      14
     C                   Z-ADD     14            @@SIG
     C                   Z-ADD     2             @@Z               2 0
     C                   ELSE
     C                   Z-ADD     1             @@Z               2 0
     C                   END
      *
      * PERFORMING ACTUAL MOVEMENT
     C     @@Z           DOWLT     15
     C     @@Q           ANDLT     14
      *
      * SWITCH FOR ZERO SUPPRESSION
     C                   MOVE      '0'           @@SWT
      *
      * IF ELEMENT OF ARRAY @Q  IS ZERO AND INDEX @@Z FOR ARRAY @Z
      * IS *LT SIG.POSITION AND ALSO *LT DECIMAL POSITION THEN ZERO
      * CAN BE SUPPRESSED AND ZERO SUPPRESSION SWITCH IS SETON
      *
     C     @Q(@@Q)       IFEQ      0
     C     @@SWT1        ANDEQ     '0'
     C     @@Z           ANDLT     @@SIG
     C     @@Z           ANDLT     @@QECW
     C                   MOVE      *BLANK        @Z(@@Z)
     C                   MOVE      '1'           @@SWT             1
     C                   END
      *
      * IF INDEX @@Z FOR ARRAY @Z IS EQUAL TO THE DECIMAL POSITION
      * AND NOT EQUAL TO THE LENGTH OF THE ARRAY @Z(14) THEN MOVE
      * DECIMAL POSITION AND INCREMENT @@Z BY 1
      *
     C     @@Z           IFEQ      @@QECW
     C     @@Z           ANDNE     14
     C                   MOVE      DECMAL        @Z(@@Z)
     C                   ADD       1             @@Z
     C                   END
      *
      * IF ZERO HAS NOT BEEN SUPPRESSED THEN MOVE ELEMENT FROM ARRAY
      * @Q TO @Z.SETON ZERO SUPPRESSION SWITCH OVER(@@SWT1)
     C     @@SWT         IFEQ      '0'
     C                   MOVE      @Q(@@Q)       @Z(@@Z)
     C                   MOVE      '1'           @@SWT1
     C                   END
      *
     C                   ADD       1             @@Q
     C                   ADD       1             @@Z
      *
     C                   END
      *
      * Dummy moves for definition of work fields.
     C                   GOTO      ZA0929
     C                   MOVE      @@QECN        @@QECN            1 0
      *
     C                   CLEAR                   @@AMTW
      *
     C     ZA0929        ENDSR
      *
      /EJECT
     C*****************************************************************
      *******/COPY ZSRSRC,ZALIGNZ2
      /COPY ZSRSRC,ZALIGNZ2LE
      ******/COPY ZSRSRC,ZFRPEDZ3
      /COPY ZSRSRC,ZFRPEDZ2LE
      ******/COPY ZSRSRC,ZCONVZ1
      /COPY ZSRSRC,ZCONVZ1ILE
      *
      /EJECT
**CTDATA POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**CTDATA CPY@
(c) Finastra International Limited 2012
