     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup Cap/Floor/Collar TRAP')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETCFCO - Setup Cap/Floor/Collar TRAP record               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11830           Date 11Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPUTXTL0  IF A E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D CFCOS         E DS                  EXTNAME(DEALSDG)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG11830
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    CFCOS
      * OUTPUTS
     C                   PARM                    T_TRAP
 
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
     C                   MOVEL     'DL'          T_MOD
      * Sub module
     C                   MOVEL     'CFCO'        T_SMOD
      * Customer
     C                   MOVEL     CNUM          T_CNUM
      * Portfolio reference
     C                   MOVEL     *BLANK        T_PTFR
      * Booking Branch
     C                   MOVEL     BRCA          T_BRCA
      * Book
     C                   MOVEL     BOKC          T_BOOK
      * Transaction Reference
     C                   MOVEL     DLNO          T_TREF
      * Identifier
     C     GPUTXTK       CHAIN     GPUTXTD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XTZONE
     C                   MOVEL     T_MOD         XTMOD
     C                   MOVEL     T_SMOD        XTSMOD
     C                   MOVEL     T_TREF        XTTREF
     C                   Z-ADD     O#NTID        XTID
     C                   WRITE     GPUTXTD0
     C                   ENDIF
     C                   Z-ADD     XTID          T_ID
      * Shortname
     C                   EVAL      T_SNAM = T_TREF
      * Transaction Type
     C                   MOVEL     DTYP          T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     DLST          T_TRST
      * Transaction Profit Centre
     C                   MOVEL     PRFC          T_TPFC
      * Risk Customer
     C                   MOVEL     CNUM          T_RCST
      * Risk Currency
     C                   MOVEL     UCUCY         T_RCCY
      * Transaction Date
     C                   Z-ADD     DDAT          T_TDAT
      * Start Date
     C                   Z-ADD     VDAT          T_SDAT
      * End Date
     C                   Z-ADD     MDAT          T_EDAT
      * Matured?
     C     RECI          IFEQ      'M'
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C     RECI          IFEQ      'R'
     C                   MOVEL     'D'           T_ACTN
     C                   ELSE
     C                   MOVEL     'A'           T_ACTN
     C                   ENDIF
      * Customer branch
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
      *
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
 
     C     GPUTXTK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2003
