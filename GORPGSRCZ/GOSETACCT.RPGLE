     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup Account TRAP record')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETACCT - Setup Account TRAP record                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11830           Date 11Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2312            Date 05May04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2312 - Accounts not extracted - 10 digit a/c code error.  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGPUTXGL0  IF A E           K DISK    INFSR(*PSSR)


     D/COPY ZACPYSRC,STD_D_SPEC


     D ACCT          E DS                  EXTNAME(ACCNTAB)


      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)


     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG11830

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    ACCT
      * OUTPUTS
     C                   PARM                    T_TRAP
     C                   PARM                    T_PRRN            5 0

      * DETERMINE IF TRANSACTION TYPE/SUB TYPE TO BE EXTRACTED

     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'GL'          I#MOD
     C                   MOVEL     ACOD          I#TRTP
     C                   MOVE      ACOD          I#TRST                                      BUG2312

     C                   EXSR      DET_TSEX
      * No extract
     C     W#RTCD        IFEQ      '*NOEXT*'
     C                   MOVEL     '*NOEXT*'     I#RTCD
     C                   RETURN
     C                   ENDIF

      * SETUP TRANSACTION INDEX RECORD

     C                   EXSR      SETUP_TRAP

      * RETURN

     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR

      * Clear Transaction Index

     C                   CLEAR                   T_TRAP

      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'GL'          T_MOD
      * Sub module
     C                   MOVEL     'ACCT'        T_SMOD
      * Customer
     C                   MOVEL     CNUM          T_CNUM
      * Portfolio reference
     C                   MOVEL     PTFR          T_PTFR
      * Booking Branch
     C                   MOVEL     BRCA          T_BRCA
      * Account Currency
     C                   MOVEL     CCY           T_ACCY
      * Account Code
     C                   MOVEL     ACOD          T_ACOD
      * Account Sequence
     C                   MOVEL     ACSQ          T_ACSQ
      * Identifier
     C     GPUTXGK       CHAIN     GPUTXGD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XGZONE
     C                   MOVEL     T_CNUM        XGCNUM
     C                   MOVEL     T_BRCA        XGBRCA
     C                   MOVEL     T_ACCY        XGACCY
     C                   MOVEL     T_ACOD        XGACOD
     C                   MOVEL     T_ACSQ        XGACSQ
     C                   Z-ADD     O#NTID        XGID
     C                   Z-ADD     *ZERO         XGPRRN
     C                   WRITE     GPUTXGD0
     C                   ENDIF
     C                   Z-ADD     XGID          T_ID
     C                   Z-ADD     XGPRRN        T_PRRN
      * Shortname
     C                   MOVEL     T_CNUM        W#CNUM            6
     C                   EVAL      T_SNAM = T_BRCA+'-'+W#CNUM+'-'
     C                                    +T_ACCY+'-'+T_ACOD+'-'+T_ACSQ
      * Transaction Type
     C                   MOVEL     ACOD          T_TRTP
      * Transaction Sub-Type
     C**********         MOVEL     *BLANK        T_TRST                                      BUG2312
     C                   MOVE      ACOD          T_TRST                                      BUG2312
      * Transaction Profit Centre
     C                   MOVEL     PRFC          T_TPFC
      * Risk Customer
     C                   MOVEL     CNUM          T_RCST
      * Risk Currency
     C                   MOVEL     CCY           T_RCCY
      * Transaction Date
     C                   Z-ADD     DACO          T_TDAT
      * Start Date
     C                   Z-ADD     DACO          T_SDAT
      * End Date
     C                   Z-ADD     DACC          T_EDAT
      * Omit from exposure
     C     O#INST        IFEQ      'N'
     C                   MOVEL     'Y'           T_OMEI
     C                   ENDIF
      * Action
     C                   MOVEL     'A'           T_ACTN
      *
      * Customer branch
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DETERMINE IF TRANSACTION TYPE/SUB TYPE TO BE EXTRACTED
      *****************************************************************
     C     DET_TSEX      BEGSR

      /COPY GOCPYSRC,GODETTSEX

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************                  BUG11830
      * Access customer details                                                             BUG11830
      ********************************************************************                  BUG11830
     C     ACS_CUST      BEGSR                                                              BUG11830
     C                   CALLB     'AOCUSTR0'                                               BUG11830
     C                   PARM      *BLANKS       @RTCD             7                        BUG11830
     C                   PARM      '*KEY   '     @OPTN             7                        BUG11830
     C                   PARM                    @KEY1            10                        BUG11830
     C                   PARM      *BLANKS       @KYST             7                        BUG11830
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG11830
     C     @RTCD         IFNE      *BLANK                                                   BUG11830
     C     @KYST         OREQ      '*ERROR'                                                 BUG11830
     C                   CLEAR                   SDCUST                                     BUG11830
     C                   ENDIF                                                              BUG11830
     C                   ENDSR                                                              BUG11830
      *****************************************************************                     BUG11830
      /SPACE 5                                                                              BUG11830
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR

      * Get Zone

      /COPY GOCPYSRC,GOGETZONE


      * key list

     C     GPUTXGK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_ACCY
     C                   KFLD                    T_ACOD
     C                   KFLD                    T_ACSQ
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2003
