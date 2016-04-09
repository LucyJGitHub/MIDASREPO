     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Map Equation Country Exposure Data to Management')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOEQCESET - Map EQ Country exposure data to management limit *
      *              Country exposure data                            *
      *                                                               *
      *  Function:  This program Map EQ Country Exposure data to Midas*
      *             Plus Management limit Country Exposure data       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Equation Country Exposure data
     D EQCEXP        E DS                  EXTNAME(ACAPF)
      * Midas Plus Country Exposure data
     D MICEXP        E DS                  EXTNAME(T_MLEQCE)
 
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    EQCEXP
     C                   PARM                    MICEXP
      *
      ** Population of Midas Country Management limit exposure Source DS
      *
      *
      ** Country Code
      *
     C                   EVAL      CNCODE = ACACNAR
      *
      ** Branch from Branch Extension file
      *
     C                   EVAL      WEQBRCH = %TRIM(ACABRNM)
     C     WEQBRCH       CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
     C                   EVAL      CNBRCH = BXBRCD
     C                   ELSE
      *
      ** If Branch not found in the file
      *
     C                   EVAL      DBFILE = 'SDBRCXL1'
     C                   EVAL      DBASE  = 007
     C                   EVAL      DBKEY  = WEQBRCH
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Currency
      *
     C                   EVAL      CNCCY = ACACCY
      *
      ** Instrument Code
      *
     C                   IF        ACATYP <> *Blanks
     C                   EVAL      CNINCODE = ACATYP
     C                   ELSE
     C                   EVAL      P@OP01 = 'EqSumConAcType'
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
     C                   MOVEL     'GPSVALPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     P@VL01        CNINCODE
     C                   ENDIF
      *
      ** From Date
      *
     C                   EVAL      CNFDATE    = ACADATF
      *
      ** To Date
      *
     C                   EVAL      CNTDATE    = ACADATT
      *
      ** Consumer Banking Exposure
      *
     C                   EVAL      CNEXPOSURE = ACAEXP
      *
      ** Consumer Banking Offset
      *
     C                   EVAL      CNOFFSET   = ACAOST
      *
      ** Zone
      *
     C                   EVAL      CNZONE = O#ZONE
      *
      ** Captured
      *
     C                   EVAL      CNCAPTRD = *Zero
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C/COPY GOCPYSRC,GOGETZONE
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
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
