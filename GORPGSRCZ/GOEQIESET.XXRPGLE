     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Map Equation industry Exposure Data to mgmt limits')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOEQIESET - Map EQ Industry exposure data to management limit*
      *              Industry exposure data                           *
      *                                                               *
      *  Function: This program Map EQ Industry Exposure data to Midas*
      *            Plus Management limit Industry Exposure data       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    XX    - Function of Indicator                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      -  Program exception error routine                *
      *  *INZSR     -  Initialisation Subroutine                      *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.           *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Midas Branch Extension file
     FSDBRCXL1  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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

      * Equation Industry Exposure data
     D EQIEXP        E DS                  EXTNAME(ACBPF)

      * Midas Plus Industry Exposure data
     D MIIEXP        E DS                  EXTNAME(T_MLEQIE)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1

      * Work field for EQ Branch
     D WEQBRCH         S              3
     D I#ERMS          S             50

     D P@RTCD          S              7
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          S             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C     *ENTRY        PLIST
     C                   PARM                    EQIEXP
     C                   PARM                    MIIEXP
      *
      ** Population of Midas Industry Management limit exposure Source DS
      *
      ** Industry Code
      *
     C                   EVAL      INCODE = ACBP1R
      *
      ** Branch from Branch Extension file
      *
     C                   EVAL      WEQBRCH = %TRIM(ACBBRNM)
     C     WEQBRCH       CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
     C                   EVAL      INBRCH = BXBRCD
     C                   ELSE
      *
      ** If Branch not found in the file
      *
     C                   EVAL      DBFILE = 'SDBRCXL1'
     C                   EVAL      DBASE  = 008
     C                   EVAL      DBKEY  = WEQBRCH
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Currency
      *
     C                   EVAL      INCCY = ACBCCY
      *
      ** Instrument Code
      *
     C                   IF        ACBTYP <> *Blank
     C                   EVAL      ININCODE = ACBTYP
     C                   ELSE
      *
     C                   EVAL      P@OP01 ='EqSumConAcType'
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM                    P@OP01
     C                   PARM                    P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
      ** Error
      *
     C     P@RTCD        IFNE      *BLANK
     C                   MOVEL     'AOSVALR0'    DBPGM
     C**********         MOVEL     'GPSVALPD'    DBFILE                                     MD054605
     C                   MOVEL     'GPSVLJW0'    DBFILE                                     MD054605
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF


     C                   MOVEL     P@VL01        ININCODE

     C                   ENDIF
      *
      ** From Date
      *
     C                   EVAL      INFDATE    = ACBDATF
      *
      ** To Date
      *
     C                   EVAL      INTDATE    = ACBDATT
      *
      ** Consumer Banking Exposure
      *
     C                   EVAL      INEXPOSURE = ACBEXP
      *
      ** Consumer Banking Offset
      *
     C                   EVAL      INOFFSET   = ACBOST
      *
      ** Zone
      *
     C                   EVAL      INZONE     = O#ZONE
      *
      ** Captured
      *
     C                   EVAL      INCAPTRD   = *Zero
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activatin                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      /COPY GOCPYSRC,GOGETZONE
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************

**  CPY@
(c) Finastra International Limited 2006
