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
      *  Last Amend No. MD059057           Date 14Oct21               *
      *  Prev Amend No. DAI101D            Date 13Oct19               *
      *                 DAI101C            Date 11Oct19               *
      *                 DAI101A            Date 29May19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL141  *CREATE    Date 12Dec12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD059057 - Missing changes in SP2021B compat - (DAI103B)     *
      *             (Recompile Only)                                  *
      *  DAI101D - Access shadow files for REJECT option              *
      *  DAI101C - Allow Amend of Unauthorised Amount Accruals        *
      *  DAI101A - Amount Accrual Authorisation with CGL141           *
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
      *       15      F15 Accrual Extended Narrative Window           *                      DAI101A
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
     D  #1PROG                11     20                                                      DAI101A
     D  #1CHTP                21     21                                                      DAI101A
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

     D XXAmtAcc      E DS                  EXTNAME(XXGLAMAC1D)                               DAI101A
      ** Midas XX Amount Accruals extension file - for authorisation                         DAI101A
                                                                                             DAI101A
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
      *                                                                                      DAI101A
     C                   MOVE      'N'           DAI101            1                         DAI101A
     C                   CALL      'AOSARDR0'                                                DAI101A
     C                   PARM      *BLANKS       @RTCD                                       DAI101A
     C                   PARM      '*KEY'        @OPTN                                       DAI101A
     C                   PARM      'DAI101'      @KEY6                                       DAI101A
     C     SCSARD        PARM      SCSARD        DSFDY                                       DAI101A
      *                                                                                      DAI101A
     C     @RTCD         IFEQ      *BLANKS                                                   DAI101A
     C                   MOVE      'Y'           DAI101                                      DAI101A
     C                   ENDIF                                                               DAI101A
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
     C     ACTN          OREQ      'X'                                                       DAI101A
     C     DAI101        ANDEQ     'Y'                                                       DAI101A
     C     ACTN          OREQ      'R'                                                       DAI101D
     C     DAI101        ANDEQ     'Y'                                                       DAI101D
     C                   SETON                                        20
     C     DAI101        IFEQ      'Y'                                                       DAI101A
     C     ACTN          ANDEQ     'X'                                                       DAI101A
     C                   SETON                                        25                     DAI101A
     C                   ENDIF                                                               DAI101A
     C                   ENDIF
      *
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C     ACTN          OREQ      'A'
     C     ACTN          OREQ      'X'                                                       DAI101A
     C     DAI101        ANDEQ     'Y'                                                       DAI101A
     C     ACTN          OREQ      'R'                                                       DAI101D
     C     DAI101        ANDEQ     'Y'                                                       DAI101D
      *
     C     ACTN          Ifne      'X'                                          SActnNEX     DAI101A
     C     #1PROG        AndNE     'XX000091'                                                DAI101B
     C     ACTN          Oreq      'D'                                                       DAI101B
     C     #1PROG        AndEq     'XX000091'                                                DAI101B
     C     #1CHTP        AndEq     'D'                                                       DAI101B
     C     ACTN          Oreq      'E'                                                       DAI101B
     C     #1PROG        AndEq     'XX000091'                                                DAI101B
     C     #1CHTP        AndEq     'D'                                                       DAI101B
     C     ACTN          Oreq      'X'                                                       DAI101B
     C     #1CHTP        AndEq     'D'                                                       DAI101B
     C     ACTN          Oreq      'R'                                                       DAI101D
     C     #1PROG        AndEq     'XX000091'                                                DAI101D
                                                                                             DAI101A
     C     DAI101        Ifeq      'N'                                                       DAI101A
      *                                                                                      DAI101A
     C/exec SQL
     C+ select *
     C+ into :AmtAcc
     C+ from GLAMAC1D
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec

     C                   Else                                                                DAI101A
      *                                                                                      DAI101A
      ** DAI101 ON, load records from GLAMAC1D to XXAmtAcc                                   DAI101A
      *                                                                                      DAI101A
     C/exec SQL                                                                              DAI101A
     C+ select *                                                                             DAI101A
     C+ into :XXAmtAcc                                                                       DAI101A
     C+ from GLAMAC1D                                                                        DAI101A
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP                     DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C                   Endif                                                               DAI101A
                                                                                             DAI101A
      * If no records found and in Amend mode, try the shadow file as an                     DAI101C
      * unauthorised Amount Accrual may be getting amended                                   DAI101C
     C                   If        %Subst(SQLState:1:2) = '02'                               DAI101C
     C**********                   and ACTN = 'A'                                    DAI101C DAI101D
     C                             and (ACTN= 'A' OR ACTN = 'R')                             DAI101D
     C                             and DAI101 = 'Y'                                          DAI101C
     C
     C/exec SQL                                                                              DAI101C
     C+ select *                                                                             DAI101C
     C+ into :XXAmtAcc                                                                       DAI101C
     C+ from XXGLAMAC1D                                                                      DAI101C
     C+ where XGBRCA = :#1BRCA and XGAREF = :#1AREF                                          DAI101C
     C/end-exec                                                                              DAI101C
     C                   Endif
      *
     C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'
                                                                                             DAI101A
     C     DAI101        Ifeq      'N'                                                       DAI101A

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
      * Amount Accrual Authorisation is ON, format XXGLAMC1D                                 DAI101A
      *                                                                                      DAI101A
     C                   Else                                                                DAI101A
      *                                                                                      DAI101A
      ** Get decimal value using purchase currency                                           DAI101A
     C                   MOVE(P)   XGPCCY        @AJCD                                       DAI101A
     C                   EXSR      GETCCY                                                    DAI101A
     C                   MOVEL     *BLANKS       XGPCCY                                      DAI101A
     C     @RTCD         IFEQ      *BLANKS                                                   DAI101A
     C                   MOVE      A6CYCD        XGPCCY                                      DAI101A
     C                   ENDIF                                                               DAI101A
     C                   MOVEL(P)  XGPCCY        #PCCY                                       DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  XGASTP        #ASTP                                       DAI101A
     C                   MOVEL(P)  XGASTD        #ASTD                                       DAI101A
     C                   MOVEL(P)  XGACAT        #ACAT                                       DAI101A
     C                   MOVEL(P)  XGACAD        #ACAD                                       DAI101A
     C                   MOVEL(P)  XGADES        #ADES                                       DAI101A
      *                                                                                      DAI101A
     C     XGPDAT        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGPDAT        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #PDAT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPVFC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPVFC        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PVFC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCNRT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCNRT        @@AMTW                                      DAI101A
     C                   Z-ADD     7             @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CNRT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPVLC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPVLC        @@AMTW                                      DAI101A
     C                   Z-ADD     WLCDP         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PVLC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGQNTY        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGQNTY        @@AMTW                                      DAI101A
     C                   Z-ADD     *ZERO         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #QNTY                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  XGSPNM        #SPNM                                       DAI101A
     C                   MOVEL(P)  XGLOCN        #LOCN                                       DAI101A
     C                   MOVEL(P)  XGLODE        #LODE                                       DAI101A
     C                   MOVEL(P)  XGLOC1        #LOC1                                       DAI101A
     C                   MOVEL(P)  XGREM1        #REM1                                       DAI101A
     C                   MOVEL(P)  XGREM2        #REM2                                       DAI101A
     C                   MOVEL(P)  XGPMOD        #PMOD                                       DAI101A
     C                   MOVEL(P)  XGPYNO        #PYNO                                       DAI101A
      *                                                                                      DAI101A
     C     XGRTDP        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGRTDP        @@AMTW                                      DAI101A
     C                   Z-ADD     7             @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #RTDP                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   Endif                                                               DAI101A
      *                                                                                      DAI101A
     C                   ENDIF
      *                                                                                      DAI101A
     C                   Else                                                   XActnNEX     DAI101A
      *                                                                                      DAI101A
      ** ACTN is X, DAI101 is ON                                                             DAI101A
      *                                                                                      DAI101A
     C/exec SQL                                                                              DAI101A
     C+ select *                                                                             DAI101A
     C+ into :XXAmtAcc                                                                       DAI101A
     C+ from XXGLAMAC1D                                                                      DAI101A
     C+ where XGBRCA = :#1BRCA and XGAREF = :#1AREF and XGATYP = :#1ATYP                     DAI101A
     C/end-exec                                                                              DAI101A
     C                   If        %Subst(SQLState:1:2) = '00' or               SSqlState    DAI101A
     C                             %Subst(SQLState:1:2) = '01'                               DAI101A
      *                                                                                      DAI101A
      ** Get decimal value using purchase currency                                           DAI101A
     C                   MOVE(P)   XGPCCY        @AJCD                                       DAI101A
     C                   EXSR      GETCCY                                                    DAI101A
     C                   MOVEL     *BLANKS       XGPCCY                                      DAI101A
     C     @RTCD         IFEQ      *BLANKS                                                   DAI101A
     C                   MOVE      A6CYCD        XGPCCY                                      DAI101A
     C                   ENDIF                                                               DAI101A
     C                   MOVEL(P)  XGPCCY        #PCCY                                       DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  XGASTP        #ASTP                                       DAI101A
     C                   MOVEL(P)  XGASTD        #ASTD                                       DAI101A
     C                   MOVEL(P)  XGACAT        #ACAT                                       DAI101A
     C                   MOVEL(P)  XGACAD        #ACAD                                       DAI101A
     C                   MOVEL(P)  XGADES        #ADES                                       DAI101A
      *                                                                                      DAI101A
     C     XGPDAT        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGPDAT        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #PDAT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPVFC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPVFC        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PVFC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCNRT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCNRT        @@AMTW                                      DAI101A
     C                   Z-ADD     7             @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CNRT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPVLC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPVLC        @@AMTW                                      DAI101A
     C                   Z-ADD     WLCDP         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PVLC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGQNTY        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGQNTY        @@AMTW                                      DAI101A
     C                   Z-ADD     *ZERO         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #QNTY                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  XGSPNM        #SPNM                                       DAI101A
     C                   MOVEL(P)  XGLOCN        #LOCN                                       DAI101A
     C                   MOVEL(P)  XGLODE        #LODE                                       DAI101A
     C                   MOVEL(P)  XGLOC1        #LOC1                                       DAI101A
     C                   MOVEL(P)  XGREM1        #REM1                                       DAI101A
     C                   MOVEL(P)  XGREM2        #REM2                                       DAI101A
     C                   MOVEL(P)  XGPMOD        #PMOD                                       DAI101A
     C                   MOVEL(P)  XGPYNO        #PYNO                                       DAI101A
      *                                                                                      DAI101A
     C     XGRTDP        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGRTDP        @@AMTW                                      DAI101A
     C                   Z-ADD     7             @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #RTDP                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   Endif                                                  ESqlState    DAI101A
     C                   Endif                                                  EActnNEX     DAI101A
      *                                                                                      DAI101A
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
     C     ACTN          OREQ      'X'                                                       DAI101A
     C     DAI101        ANDEQ     'Y'                                                       DAI101A
     C     ACTN          OREQ      'R'                                                       DAI101D
     C     DAI101        ANDEQ     'Y'                                                       DAI101D
     C                   SETON                                        20
     C     DAI101        IFEQ      'Y'                                                       DAI101A
     C     ACTN          ANDEQ     'X'                                                       DAI101A
     C                   SETON                                        25                     DAI101A
     C                   ENDIF                                                               DAI101A
     C                   ENDIF
      *
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C     ACTN          OREQ      'A'
     C     ACTN          OREQ      'X'                                                       DAI101A
     C     DAI101        ANDEQ     'Y'                                                       DAI101A
     C     ACTN          OREQ      'R'                                                       DAI101D
     C     DAI101        ANDEQ     'Y'                                                       DAI101D
      *                                                                                      DAI101A
     C     ACTN          Ifne      'X'                                          SActnNEX     DAI101A
     C     #1PROG        AndNE     'XX000091'                                                DAI101B
     C     ACTN          Oreq      'D'                                                       DAI101B
     C     #1PROG        AndEq     'XX000091'                                                DAI101B
     C     #1CHTP        AndEq     'D'                                                       DAI101B
     C     ACTN          Oreq      'E'                                                       DAI101B
     C     #1PROG        AndEq     'XX000091'                                                DAI101B
     C     #1CHTP        AndEq     'D'                                                       DAI101B
     C     ACTN          Oreq      'X'                                                       DAI101B
     C     #1CHTP        AndEq     'D'                                                       DAI101B
     C     ACTN          Oreq      'R'                                                       DAI101D
     C     #1PROG        AndEq     'XX000091'                                                DAI101D
      *                                                                                      DAI101A
     C     DAI101        Ifeq      'N'                                                       DAI101A
      *
     C/exec SQL
     C+ select *
     C+ into :AmtAcc
     C+ from GLAMAC1D
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec
     C                   Else                                                                DAI101A
      *                                                                                      DAI101A
      ** ACTN NE X, DAI101 is ON                                                             DAI101A
      *                                                                                      DAI101A
     C/exec SQL                                                                              DAI101A
     C+ select *                                                                             DAI101A
     C+ into :XXAmtAcc                                                                       DAI101A
     C+ from GLAMAC1D                                                                        DAI101A
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP                     DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C                   Endif                                                               DAI101A

     C                   If        %Subst(SQLState:1:2) = '02'                               DAI101C
     C**********                   and ACTN = 'A'                                    DAI101C DAI101D
     C                             and (ACTN= 'A' OR ACTN = 'R')                             DAI101D
     C                             and DAI101 = 'Y'                                          DAI101C
     C/exec SQL                                                                              DAI101C
     C+ select *                                                                             DAI101C
     C+ into :XXAmtAcc                                                                       DAI101C
     C+ from XXGLAMAC1D                                                                      DAI101C
     C+ where XGBRCA = :#1BRCA and XGAREF = :#1AREF                                          DAI101C
     C/end-exec                                                                              DAI101C
     C                   Endif
     C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'

     C     DAI101        Ifeq      'N'                                          SDAI101      DAI101A
                                                                                             DAI101A
      ** ACTN NE 'X', Format fields from GLAMAC1D, DAI101 is OFF                             DAI101A
                                                                                             DAI101A
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
     C                   Else                                                   XDAI101      DAI101A
      *                                                                                      DAI101A
      ** ACTN NE 'X', Format fields from XXGLAMAC1D, DAI101 is ON                            DAI101A
      *                                                                                      DAI101A
      ** Get decimal value using purchase currency                                           DAI101A
     C     #PCCY         IFEQ      *BLANKS                                                   DAI101A
     C                   ELSE                                                                DAI101A
     C                   MOVE(P)   XGPCCY        @AJCD                                       DAI101A
     C                   EXSR      GETCCY                                                    DAI101A
     C                   MOVEL     *BLANKS       XGPCCY                                      DAI101A
     C     @RTCD         IFEQ      *BLANKS                                                   DAI101A
     C                   MOVE      A6CYCD        XGPCCY                                      DAI101A
     C                   ENDIF                                                               DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
      ** Partial Write Off                                                                   DAI101A
      *                                                                                      DAI101A
     C     XGPWDT        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGPWDT        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #PWDT                                       DAI101A
     C                   MOVEL     #PWDT         WPWDT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPWQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPWQT        @@AMTW                                      DAI101A
     C                   Z-ADD     *ZERO         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PWQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
     C                   Z-ADD     XGPWQT        WPWQT                                       DAI101A
      *                                                                                      DAI101A
     C     XGPLDD        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGPLDD        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #PLDD                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPPVQ        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPPVQ        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PPVQ                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPPLC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPPLC        @@AMTW                                      DAI101A
     C                   Z-ADD     WLCDP         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PPLC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPDQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPDQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PDQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPBQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPBQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PBQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
      ** Complete Write Off                                                                  DAI101A
      *                                                                                      DAI101A
     C     XGCWDT        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGCWDT        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #CWDT                                       DAI101A
     C                   MOVEL     #CWDT         WCWDT             6                         DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCLDD        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGCLDD        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #CLDD                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCPVQ        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCPVQ        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CPVQ                                       DAI101A
     C                   ENDIF                                                               DAI101A
     C                   Z-ADD     XGCPVQ        WCPVEQ                                      DAI101A
      *                                                                                      DAI101A
     C     XGCPLC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCPLC        @@AMTW                                      DAI101A
     C                   Z-ADD     WLCDP         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CPLC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCDQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCDQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CDQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCBQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCBQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CBQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
      ** Complete Sale                                                                       DAI101A
      *                                                                                      DAI101A
     C     XGDTSL        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGDTSL        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #DTSL                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGSLDD        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGSLDD        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #SLDD                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  XGBNAM        #BNAM                                       DAI101A
     C                   MOVEL(P)  #BNAM         WBNAM            30                         DAI101A
     C                   MOVEL(P)  XGBAD1        #BAD1                                       DAI101A
     C                   MOVEL(P)  XGBAD2        #BAD2                                       DAI101A
     C                   MOVEL(P)  XGPRMO        #PRMO                                       DAI101A
     C                   MOVEL(P)  XGPRNO        #PRNO                                       DAI101A
      *                                                                                      DAI101A
     C     XGARCV        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGARCV        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #ARCV                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   Endif                                                  EDAI101      DAI101A
     C                   ENDIF
     C                   Else                                                   XActnNEX     DAI101A
      *                                                                                      DAI101A
      ** ACTN is 'X', DAI101 is ON                                                           DAI101A
     C/exec SQL                                                                              DAI101A
     C+ select *                                                                             DAI101A
     C+ into :XXAmtAcc                                                                       DAI101A
     C+ from XXGLAMAC1D                                                                      DAI101A
     C+ where XGBRCA = :#1BRCA and XGAREF = :#1AREF and XGATYP = :#1ATYP                     DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C                   If        %Subst(SQLState:1:2) = '00' or               SSqlState    DAI101A
     C                             %Subst(SQLState:1:2) = '01'                               DAI101A
                                                                                             DAI101A
      ** Get decimal value using purchase currency                                           DAI101A
     C     #PCCY         IFEQ      *BLANKS                                                   DAI101A
     C                   ELSE                                                                DAI101A
     C                   MOVE(P)   XGPCCY        @AJCD                                       DAI101A
     C                   EXSR      GETCCY                                                    DAI101A
     C                   MOVEL     *BLANKS       XGPCCY                                      DAI101A
     C     @RTCD         IFEQ      *BLANKS                                                   DAI101A
     C                   MOVE      A6CYCD        XGPCCY                                      DAI101A
     C                   ENDIF                                                               DAI101A
     C                   ENDIF                                                               DAI101A
                                                                                             DAI101A
      ** Partial Write Off                                                                   DAI101A
      *                                                                                      DAI101A
     C     XGPWDT        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGPWDT        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #PWDT                                       DAI101A
     C                   MOVEL     #PWDT         WPWDT             6                         DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPWQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPWQT        @@AMTW                                      DAI101A
     C                   Z-ADD     *ZERO         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PWQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
     C                   Z-ADD     XGPWQT        WPWQT             5 0                       DAI101A
      *                                                                                      DAI101A
     C     XGPLDD        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGPLDD        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #PLDD                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPPVQ        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPPVQ        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PPVQ                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPPLC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPPLC        @@AMTW                                      DAI101A
     C                   Z-ADD     WLCDP         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PPLC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPDQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPDQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PDQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGPBQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGPBQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #PBQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
      ** Complete Write Off                                                                  DAI101A
      *                                                                                      DAI101A
     C     XGCWDT        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGCWDT        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #CWDT                                       DAI101A
     C                   MOVEL     #CWDT         WCWDT             6                         DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCLDD        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGCLDD        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #CLDD                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCPVQ        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCPVQ        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CPVQ                                       DAI101A
     C                   ENDIF                                                               DAI101A
     C                   Z-ADD     XGCPVQ        WCPVEQ            5 0                       DAI101A
      *                                                                                      DAI101A
     C     XGCPLC        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCPLC        @@AMTW                                      DAI101A
     C                   Z-ADD     WLCDP         @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CPLC                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCDQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCDQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CDQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGCBQT        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGCBQT        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #CBQT                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
      ** Complete Sale                                                                       DAI101A
      *                                                                                      DAI101A
     C     XGDTSL        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGDTSL        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #DTSL                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C     XGSLDD        IFNE      *ZERO                                                     DAI101A
     C                   Z-ADD     XGSLDD        ZDAYNO                                      DAI101A
     C                   EXSR      FORDAT                                                    DAI101A
     C                   MOVEL(P)  ZDATFM        #SLDD                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  XGBNAM        #BNAM                                       DAI101A
     C                   MOVEL(P)  #BNAM         WBNAM            30                         DAI101A
     C                   MOVEL(P)  XGBAD1        #BAD1                                       DAI101A
     C                   MOVEL(P)  XGBAD2        #BAD2                                       DAI101A
     C                   MOVEL(P)  XGPRMO        #PRMO                                       DAI101A
     C                   MOVEL(P)  XGPRNO        #PRNO                                       DAI101A
      *                                                                                      DAI101A
     C     XGARCV        IFNE      *ZERO                                                     DAI101A
     C                   MOVE(P)   XGARCV        @@AMTW                                      DAI101A
     C                   Z-ADD     A6NBDP        @@QECN                                      DAI101A
     C                   EXSR      ZA0920                                                    DAI101A
     C                   MOVE(P)   @@AMTD        #ARCV                                       DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   Endif                                                  ESqlState    DAI101A
      *                                                                                      DAI101A
     C                   Endif                                                  EActnNEX     DAI101A
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
     C     ACTN          ANDNE     'X'                                                       DAI101A
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
     C     ACTN          OREQ      'D'                                                       DAI101A
     C     DAI101        ANDEQ     'Y'                                                       DAI101A
     C     #1PROG        ANDNE     'XX000091'                                                DAI101B
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
     C     DAI101        IFEQ      'N'                                                       DAI101A
     C                   CLEAR                   AmtAcc
     C                   EXSR      MOVRT1
     C                   EXSR      MOVRT2
     C                   Else                                                                DAI101A
     C                   Clear                   XXAmtAcc                                    DAI101A
     C                   EXSR      XOVRT1                                                    DAI101A
     C                   EXSR      XOVRT2                                                    DAI101A
     C                   Endif                                                               DAI101A
      *
     C     DAI101        IFeq      'N'                                                       DAI101A
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
     C                   Else                                                                DAI101A
     C/exec SQL                                                                              DAI101A
     C+ insert into XXGLAMAC1D                                                               DAI101A
     C+    ( XGBRCA                                                                          DAI101A
     C+     ,XGAREF                                                                          DAI101A
     C+     ,XGATYP                                                                          DAI101A
     C+     ,XGASTP                                                                          DAI101A
     C+     ,XGASTD                                                                          DAI101A
     C+     ,XGRTDP                                                                          DAI101A
     C+     ,XGACAT                                                                          DAI101A
     C+     ,XGACAD                                                                          DAI101A
     C+     ,XGADES                                                                          DAI101A
     C+     ,XGPDAT                                                                          DAI101A
     C+     ,XGPVFC                                                                          DAI101A
     C+     ,XGPCCY                                                                          DAI101A
     C+     ,XGCNRT                                                                          DAI101A
     C+     ,XGPVLC                                                                          DAI101A
     C+     ,XGQNTY                                                                          DAI101A
     C+     ,XGSPNM                                                                          DAI101A
     C+     ,XGLOCN                                                                          DAI101A
     C+     ,XGLODE                                                                          DAI101A
     C+     ,XGLOC1                                                                          DAI101A
     C+     ,XGREM1                                                                          DAI101A
     C+     ,XGREM2                                                                          DAI101A
     C+     ,XGPMOD                                                                          DAI101A
     C+     ,XGPYNO                                                                          DAI101A
     C+     ,XGPWDT                                                                          DAI101A
     C+     ,XGPWQT                                                                          DAI101A
     C+     ,XGPPVQ                                                                          DAI101A
     C+     ,XGPPLC                                                                          DAI101A
     C+     ,XGPDQT                                                                          DAI101A
     C+     ,XGPLDD                                                                          DAI101A
     C+     ,XGPBQT                                                                          DAI101A
     C+     ,XGCWDT                                                                          DAI101A
     C+     ,XGCPVQ                                                                          DAI101A
     C+     ,XGCPLC                                                                          DAI101A
     C+     ,XGCDQT                                                                          DAI101A
     C+     ,XGCLDD                                                                          DAI101A
     C+     ,XGCBQT                                                                          DAI101A
     C+     ,XGBNAM                                                                          DAI101A
     C+     ,XGBAD1                                                                          DAI101A
     C+     ,XGBAD2                                                                          DAI101A
     C+     ,XGPRNO                                                                          DAI101A
     C+     ,XGPRMO                                                                          DAI101A
     C+     ,XGARCV                                                                          DAI101A
     C+     ,XGDTSL                                                                          DAI101A
     C+     ,XGSLDD )                                                                        DAI101A
     C+ values                                                                               DAI101A
     C+ (:XGBRCA                                                                             DAI101A
     C+     ,:XGAREF                                                                         DAI101A
     C+     ,:XGATYP                                                                         DAI101A
     C+     ,:XGASTP                                                                         DAI101A
     C+     ,:XGASTD                                                                         DAI101A
     C+     ,:XGRTDP                                                                         DAI101A
     C+     ,:XGACAT                                                                         DAI101A
     C+     ,:XGACAD                                                                         DAI101A
     C+     ,:XGADES                                                                         DAI101A
     C+     ,:XGPDAT                                                                         DAI101A
     C+     ,:XGPVFC                                                                         DAI101A
     C+     ,:XGPCCY                                                                         DAI101A
     C+     ,:XGCNRT                                                                         DAI101A
     C+     ,:XGPVLC                                                                         DAI101A
     C+     ,:XGQNTY                                                                         DAI101A
     C+     ,:XGSPNM                                                                         DAI101A
     C+     ,:XGLOCN                                                                         DAI101A
     C+     ,:XGLODE                                                                         DAI101A
     C+     ,:XGLOC1                                                                         DAI101A
     C+     ,:XGREM1                                                                         DAI101A
     C+     ,:XGREM2                                                                         DAI101A
     C+     ,:XGPMOD                                                                         DAI101A
     C+     ,:XGPYNO                                                                         DAI101A
     C+     ,:XGPWDT                                                                         DAI101A
     C+     ,:XGPWQT                                                                         DAI101A
     C+     ,:XGPPVQ                                                                         DAI101A
     C+     ,:XGPPLC                                                                         DAI101A
     C+     ,:XGPDQT                                                                         DAI101A
     C+     ,:XGPLDD                                                                         DAI101A
     C+     ,:XGPBQT                                                                         DAI101A
     C+     ,:XGCWDT                                                                         DAI101A
     C+     ,:XGCPVQ                                                                         DAI101A
     C+     ,:XGCPLC                                                                         DAI101A
     C+     ,:XGCDQT                                                                         DAI101A
     C+     ,:XGCLDD                                                                         DAI101A
     C+     ,:XGCBQT                                                                         DAI101A
     C+     ,:XGBNAM                                                                         DAI101A
     C+     ,:XGBAD1                                                                         DAI101A
     C+     ,:XGBAD2                                                                         DAI101A
     C+     ,:XGPRNO                                                                         DAI101A
     C+     ,:XGPRMO                                                                         DAI101A
     C+     ,:XGARCV                                                                         DAI101A
     C+     ,:XGDTSL                                                                         DAI101A
     C+     ,:XGSLDD )                                                                       DAI101A
     C/end-exec                                                                              DAI101A
     C                   Endif                                                               DAI101A

     C                   ENDIF
      *
 B1  C     ACTN          IFEQ      'A'
     C*****ACTN          Oreq      'D'                                               DAI101A DAI101B
      *                                                                                      DAI101A
 B2  C     DAI101        IFeq      'N'                                                       DAI101A
      *
     C/exec SQL
     C+ select *
     C+ into :AmtAcc
     C+ from GLAMAC1D
     C+ where SGBRCA = :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP
     C/end-exec
     C                                                                                       DAI101A
 X2  C                   Else                                                                DAI101A
     C                                                                                       DAI101A
     C/exec SQL                                                                              DAI101A
     C+ select *                                                                             DAI101A
     C+ into :XXAmtAcc                                                                       DAI101A
     C+ from XXGLAMAC1D                                                                      DAI101A
     C+ where XGBRCA = :#1BRCA and XGAREF = :#1AREF and XGATYP = :#1ATYP                     DAI101A
     C/end-exec                                                                              DAI101A
     C                                                                                       DAI101A
 E2  C                   Endif                                                               DAI101A

 B2  C                   If        %Subst(SQLState:1:2) = '00' or
     C                             %Subst(SQLState:1:2) = '01'
      *
 B3  C     DAI101        Ifeq      'N'                                                       DAI101A
     C                   EXSR      MOVRT1
     C                   EXSR      MOVRT2
 X3  C                   Else                                                                DAI101A
     C                   EXSR      XOVRT1                                                    DAI101A
     C                   EXSR      XOVRT2                                                    DAI101A
 E3  C                   Endif                                                               DAI101A

 B3  C     DAI101        IFeq      'N'                                                       DAI101A
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

     C                   Else                                                                DAI101C
     C/exec SQL                                                                              DAI101C
     C+ update XXGLAMAC1D                                                                    DAI101C
     C+ set  XGBRCA =  :XGBRCA                                                               DAI101C
     C+     ,XGAREF =  :XGAREF                                                               DAI101C
     C+     ,XGATYP =  :XGATYP                                                               DAI101C
     C+     ,XGASTP =  :XGASTP                                                               DAI101C
     C+     ,XGASTD =  :XGASTD                                                               DAI101C
     C+     ,XGRTDP =  :XGRTDP                                                               DAI101C
     C+     ,XGACAT =  :XGACAT                                                               DAI101C
     C+     ,XGACAD =  :XGACAD                                                               DAI101C
     C+     ,XGADES =  :XGADES                                                               DAI101C
     C+     ,XGPDAT =  :XGPDAT                                                               DAI101C
     C+     ,XGPVFC =  :XGPVFC                                                               DAI101C
     C+     ,XGPCCY =  :XGPCCY                                                               DAI101C
     C+     ,XGCNRT =  :XGCNRT                                                               DAI101C
     C+     ,XGPVLC =  :XGPVLC                                                               DAI101C
     C+     ,XGQNTY =  :XGQNTY                                                               DAI101C
     C+     ,XGSPNM =  :XGSPNM                                                               DAI101C
     C+     ,XGLOCN =  :XGLOCN                                                               DAI101C
     C+     ,XGLODE =  :XGLODE                                                               DAI101C
     C+     ,XGLOC1 =  :XGLOC1                                                               DAI101C
     C+     ,XGREM1 =  :XGREM1                                                               DAI101C
     C+     ,XGREM2 =  :XGREM2                                                               DAI101C
     C+     ,XGPMOD =  :XGPMOD                                                               DAI101C
     C+     ,XGPYNO =  :XGPYNO                                                               DAI101C
     C+     ,XGPWDT =  :XGPWDT                                                               DAI101C
     C+     ,XGPWQT =  :XGPWQT                                                               DAI101C
     C+     ,XGPPVQ =  :XGPPVQ                                                               DAI101C
     C+     ,XGPPLC =  :XGPPLC                                                               DAI101C
     C+     ,XGPDQT =  :XGPDQT                                                               DAI101C
     C+     ,XGPLDD =  :XGPLDD                                                               DAI101C
     C+     ,XGPBQT =  :XGPBQT                                                               DAI101C
     C+     ,XGCWDT =  :XGCWDT                                                               DAI101C
     C+     ,XGCPVQ =  :XGCPVQ                                                               DAI101C
     C+     ,XGCPLC =  :XGCPLC                                                               DAI101C
     C+     ,XGCDQT =  :XGCDQT                                                               DAI101C
     C+     ,XGCLDD =  :XGCLDD                                                               DAI101C
     C+     ,XGCBQT =  :XGCBQT                                                               DAI101C
     C+     ,XGBNAM =  :XGBNAM                                                               DAI101C
     C+     ,XGBAD1 =  :XGBAD1                                                               DAI101C
     C+     ,XGBAD2 =  :XGBAD2                                                               DAI101C
     C+     ,XGPRNO =  :XGPRNO                                                               DAI101C
     C+     ,XGPRMO =  :XGPRMO                                                               DAI101C
     C+     ,XGARCV =  :XGARCV                                                               DAI101C
     C+     ,XGDTSL =  :XGDTSL                                                               DAI101C
     C+     ,XGSLDD =  :XGSLDD                                                               DAI101C
     C+ where XGBRCA =  :#1BRCA and XGAREF = :#1AREF and XGATYP = :#1ATYP                    DAI101C
     C/end-exec                                                                              DAI101C
 E3  C                   Endif                                                               DAI101A

 X2  C                   ELSE
      *                                                                                      DAI101A
      ** not found on GLAMAC1D or XXGLAMAC1D                                                 DAI101A
      *                                                                                      DAI101A
 B3  C     DAI101        Ifeq      'N'                                                       DAI101A
     C                   CLEAR                   AmtAcc
     C                   EXSR      MOVRT1
     C                   EXSR      MOVRT2
 X3  C                   Else                                                                DAI101A
     C                   Clear                   XXAmtAcc                                    DAI101A
     C                   EXSR      XOVRT1                                                    DAI101A
     C                   EXSR      XOVRT2                                                    DAI101A
 E3  C                   Endif                                                               DAI101A
                                                                                             DAI101A
     C     DAI101        Ifeq      'N'                                                       DAI101A
                                                                                             DAI101A
     C/exec SQL
     C+ insert into GLAMAC1D
     C+ values(:AmtAcc)
     C/end-exec

     C                   Else                                                                DAI101A
                                                                                             DAI101A
     C/exec SQL                                                                              DAI101A
     C+ insert into XXGLAMAC1D                                                               DAI101A
     C+ values(:XXAmtAcc)                                                                    DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C                   Endif                                                               DAI101A
                                                                                             DAI101A
     C                   ENDIF
     C                   ENDIF
      *
     C     ACTN          IFEQ      'X'                                                       DAI101A
     C     DAI101        Andeq     'Y'                                                       DAI101A
      *                                                                                      DAI101A
     C/exec SQL                                                                              DAI101A
     C+ select *                                                                             DAI101A
     C+ into :AmtAcc                                                                         DAI101A
     C+ from XXGLAMAC1D                                                                      DAI101A
     C+ where XGBRCA = :#1BRCA and XGAREF = :#1AREF and XGATYP = :#1ATYP                     DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C                   If        %Subst(SQLState:1:2) = '00' or                            DAI101A
     C                             %Subst(SQLState:1:2) = '01'                               DAI101A
      *                                                                                      DAI101A
     C                   EXSR      MOVRT1                                                    DAI101A
     C                   EXSR      MOVRT2                                                    DAI101A
      *                                                                                      DAI101A
     C                   Select                                                              DAI101A
                                                                                             DAI101A
      ** Change Type on XXAMACPD is Insert                                                   DAI101A
                                                                                             DAI101A
     C     #1CHTP        WhenEq    'I'                                                       DAI101A
                                                                                             DAI101A
     C/exec SQL                                                                              DAI101A
     C+ insert into GLAMAC1D                                                                 DAI101A
     C+ values(:AmtAcc)                                                                      DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C     #1CHTP        WhenEq    'A'                                                       DAI101A
     C     #1CHTP        OREq      'D'                                                       DAI101A
                                                                                             DAI101A
     C/exec SQL                                                                              DAI101A
     C+ update GLAMAC1D                                                                      DAI101A
     C+ set  SGBRCA =  :SGBRCA                                                               DAI101A
     C+     ,SGAREF =  :SGAREF                                                               DAI101A
     C+     ,SGATYP =  :SGATYP                                                               DAI101A
     C+     ,SGASTP =  :SGASTP                                                               DAI101A
     C+     ,SGASTD =  :SGASTD                                                               DAI101A
     C+     ,SGRTDP =  :SGRTDP                                                               DAI101A
     C+     ,SGACAT =  :SGACAT                                                               DAI101A
     C+     ,SGACAD =  :SGACAD                                                               DAI101A
     C+     ,SGADES =  :SGADES                                                               DAI101A
     C+     ,SGPDAT =  :SGPDAT                                                               DAI101A
     C+     ,SGPVFC =  :SGPVFC                                                               DAI101A
     C+     ,SGPCCY =  :SGPCCY                                                               DAI101A
     C+     ,SGCNRT =  :SGCNRT                                                               DAI101A
     C+     ,SGPVLC =  :SGPVLC                                                               DAI101A
     C+     ,SGQNTY =  :SGQNTY                                                               DAI101A
     C+     ,SGSPNM =  :SGSPNM                                                               DAI101A
     C+     ,SGLOCN =  :SGLOCN                                                               DAI101A
     C+     ,SGLODE =  :SGLODE                                                               DAI101A
     C+     ,SGLOC1 =  :SGLOC1                                                               DAI101A
     C+     ,SGREM1 =  :SGREM1                                                               DAI101A
     C+     ,SGREM2 =  :SGREM2                                                               DAI101A
     C+     ,SGPMOD =  :SGPMOD                                                               DAI101A
     C+     ,SGPYNO =  :SGPYNO                                                               DAI101A
     C+     ,SGPWDT =  :SGPWDT                                                               DAI101A
     C+     ,SGPWQT =  :SGPWQT                                                               DAI101A
     C+     ,SGPPVQ =  :SGPPVQ                                                               DAI101A
     C+     ,SGPPLC =  :SGPPLC                                                               DAI101A
     C+     ,SGPDQT =  :SGPDQT                                                               DAI101A
     C+     ,SGPLDD =  :SGPLDD                                                               DAI101A
     C+     ,SGPBQT =  :SGPBQT                                                               DAI101A
     C+     ,SGCWDT =  :SGCWDT                                                               DAI101A
     C+     ,SGCPVQ =  :SGCPVQ                                                               DAI101A
     C+     ,SGCPLC =  :SGCPLC                                                               DAI101A
     C+     ,SGCDQT =  :SGCDQT                                                               DAI101A
     C+     ,SGCLDD =  :SGCLDD                                                               DAI101A
     C+     ,SGCBQT =  :SGCBQT                                                               DAI101A
     C+     ,SGBNAM =  :SGBNAM                                                               DAI101A
     C+     ,SGBAD1 =  :SGBAD1                                                               DAI101A
     C+     ,SGBAD2 =  :SGBAD2                                                               DAI101A
     C+     ,SGPRNO =  :SGPRNO                                                               DAI101A
     C+     ,SGPRMO =  :SGPRMO                                                               DAI101A
     C+     ,SGARCV =  :SGARCV                                                               DAI101A
     C+     ,SGDTSL =  :SGDTSL                                                               DAI101A
     C+     ,SGSLDD =  :SGSLDD                                                               DAI101A
     C+ where SGBRCA =  :#1BRCA and SGAREF = :#1AREF and SGATYP = :#1ATYP                    DAI101A
     C/end-exec                                                                              DAI101A
      *
      ** no record selected for update
      *
     C                   If        %Subst(SQLState:1:2) = '02'                               DAI101A
     C/exec SQL                                                                              DAI101A
     C+ insert into GLAMAC1D                                                                 DAI101A
     C+ values(:AmtAcc)                                                                      DAI101A
     C/end-exec                                                                              DAI101A
     C                   Endif                                                               DAI101A
                                                                                             DAI101A
     C                   EndSl                                                               DAI101A
                                                                                             DAI101A
                                                                                             DAI101A
     C                   If        %Subst(SQLState:1:2) = '00' or                            DAI101A
     C                             %Subst(SQLState:1:2) = '01'                               DAI101A
     C/exec SQL                                                                              DAI101A
     C+ delete from XXGLAMAC1D                                                               DAI101A
     C+ where XGBRCA =  :#1BRCA and XGAREF = :#1AREF and XGATYP = :#1ATYP                    DAI101A
     C/end-exec                                                                              DAI101A
                                                                                             DAI101A
     C                   Endif                                                               DAI101A
     C                   Endif                                                               DAI101A
                                                                                             DAI101A
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
      *****************************************************************                      DAI101A
      * Move 1 subroutine (1st Screen) - XXGLAMAC1D                                          DAI101A
      *****************************************************************                      DAI101A
     C     XOVRT1        BEGSR                                                               DAI101A
      *                                                                                      DAI101A
     C     #PCCY         IFNE      *BLANKS                                                   DAI101A
     C                   MOVE      #PCCY         @AJCD                                       DAI101A
     C                   EXSR      GETCCY                                                    DAI101A
     C     @RTCD         IFEQ      *BLANKS                                                   DAI101A
     C                   MOVE      A6CYCD        #PCCY                                       DAI101A
     C                   ELSE                                                                DAI101A
     C                   MOVE      *BLANKS       #PCCY                                       DAI101A
     C                   ENDIF                                                               DAI101A
     C                   ENDIF                                                               DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  #1BRCA        XGBRCA                                      DAI101A
     C                   MOVEL(P)  #1AREF        XGAREF                                      DAI101A
     C                   MOVEL(P)  #1ATYP        XGATYP                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  #ASTP         XGASTP                                      DAI101A
     C                   MOVEL(P)  #ASTD         XGASTD                                      DAI101A
     C                   MOVEL(P)  #ACAT         XGACAT                                      DAI101A
     C                   MOVEL(P)  #ACAD         XGACAD                                      DAI101A
     C                   MOVEL(P)  #ADES         XGADES                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #PDAT         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGPDAT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  #PCCY         XGPCCY                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PVFC         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPVFC                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #CNRT         ZFIELD                                      DAI101A
     C                   Z-ADD     4             ZADIG                                       DAI101A
     C                   Z-ADD     7             ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGCNRT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PVLC         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     WLCDP         ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPVLC                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #QNTY         ZFIELD                                      DAI101A
     C                   Z-ADD     5             ZADIG                                       DAI101A
     C                   Z-ADD     0             ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGQNTY                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  #SPNM         XGSPNM                                      DAI101A
     C                   MOVEL(P)  #LOCN         XGLOCN                                      DAI101A
     C                   MOVEL(P)  #LODE         XGLODE                                      DAI101A
     C                   MOVEL(P)  #LOC1         XGLOC1                                      DAI101A
     C                   MOVEL(P)  #REM1         XGREM1                                      DAI101A
     C                   MOVEL(P)  #REM2         XGREM2                                      DAI101A
     C                   MOVEL(P)  #PMOD         XGPMOD                                      DAI101A
     C                   MOVEL(P)  #PYNO         XGPYNO                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #RTDP         ZFIELD                                      DAI101A
     C                   Z-ADD     4             ZADIG                                       DAI101A
     C                   Z-ADD     7             ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGRTDP                                      DAI101A
      *                                                                                      DAI101A
     C                   ENDSR                                                               DAI101A
      *                                                                                      DAI101A
      /EJECT                                                                                 DAI101A
      *****************************************************************                      DAI101A
      * Move 2 subroutine (2nd Screen) with DAI101 - XXGLAMAC1D                              DAI101A
      *****************************************************************                      DAI101A
     C     XOVRT2        BEGSR                                                               DAI101A
      *                                                                                      DAI101A
      ** Partial Write Off                                                                   DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #PWDT         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGPWDT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PWQT         ZFIELD                                      DAI101A
     C                   Z-ADD     5             ZADIG                                       DAI101A
     C                   Z-ADD     0             ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPWQT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #PLDD         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGPLDD                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PPVQ         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPPVQ                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PPLC         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     WLCDP         ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPPLC                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PDQT         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPDQT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #PBQT         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGPBQT                                      DAI101A
      *                                                                                      DAI101A
      ** Complete Write Off                                                                  DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #CWDT         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGCWDT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #CLDD         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGCLDD                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #CPVQ         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGCPVQ                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #CPLC         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     WLCDP         ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGCPLC                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #CDQT         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGCDQT                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #CBQT         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGCBQT                                      DAI101A
      *                                                                                      DAI101A
      ** Complete Sale                                                                       DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #DTSL         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGDTSL                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE(P)   #SLDD         WDATE                                       DAI101A
     C                   EXSR      VALDAT                                                    DAI101A
     C                   Z-ADD     WDYNO         XGSLDD                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVEL(P)  #BNAM         XGBNAM                                      DAI101A
     C                   MOVEL(P)  #BAD1         XGBAD1                                      DAI101A
     C                   MOVEL(P)  #BAD2         XGBAD2                                      DAI101A
     C                   MOVEL(P)  #PRMO         XGPRMO                                      DAI101A
     C                   MOVEL(P)  #PRNO         XGPRNO                                      DAI101A
      *                                                                                      DAI101A
     C                   MOVE      *BLANKS       ZFIELD                                      DAI101A
     C                   MOVE(P)   #ARCV         ZFIELD                                      DAI101A
     C                   Z-ADD     12            ZADIG                                       DAI101A
     C                   Z-ADD     A6NBDP        ZADEC                                       DAI101A
     C                   EXSR      ZALIGN                                                    DAI101A
     C                   MOVE(P)   ZFIELD        XGARCV                                      DAI101A
      *                                                                                      DAI101A
     C                   ENDSR                                                               DAI101A
      *                                                                                      DAI101A
      /EJECT                                                                                 DAI101A
      *****************************************************************                      DAI101A
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
