     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup NAs Purchased TRAP record')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETNASP - Setup NAs Purchased TRAP record                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11830           Date 11Aug06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3860            Date 11Aug04               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3860 - (recompile)                                        *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPUTXTL0  IF A E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
      ** DEFINE FIELDS FOR ZDATE10
     D                 DS
     D ZWDTIN                  1      8S 0
     D  ZWYYYY                 1      4S 0
     D  ZWMTH                  5      6S 0
     D  ZWDAY                  7      8S 0
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG11830
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    MMDENB
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    MaturityDate      5 0            Midas day no.
 
      * CONVERT DATES
 
     C                   EXSR      CONVT_DATES
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * CONVERT DATES
      *****************************************************************
     C     CONVT_DATES   BEGSR
 
      * deal date
     C                   Z-ADD     HLDDYY        ZWYYYY                         ¦
     C                   Z-ADD     HLDDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     HLDDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        DealDate                         Midas day no.
      * value date
     C                   Z-ADD     HLVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HLVDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     HLVDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        ValueDate                        Midas day no.
      * maturity date
     C                   Z-ADD     HLMDYY        ZWYYYY                         ¦
     C                   Z-ADD     HLMDMM        ZWMTH                          ¦ maturity date
     C                   Z-ADD     HLMDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        MaturityDate                     Midas day no.
 
      * Customer branch                                                                     BUG11830
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
      * Risk customer branch                                                                BUG11830
     C     T_CNUM        IFNE      T_RCST                                                   BUG11830
     C                   MOVEL     T_RCST        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   ENDIF                                                              BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
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
     C                   MOVEL     'NASP'        T_SMOD
      * Customer
     C                   MOVEL     HLCNUM        T_CNUM
      * Portfolio reference
     C                   MOVEL     *BLANK        T_PTFR
      * Booking Branch
     C                   MOVEL     HLBRCA        T_BRCA
      * Book
     C                   MOVEL     HLBOKC        T_BOOK
      * Transaction Reference
     C                   MOVEL     HLDN38        T_TREF
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
     C                   MOVEL     HLMTYP        T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     HLSTYP        T_TRST
      * Transaction Profit Centre
     C                   MOVEL     HLPRFC        T_TPFC
      * Risk Customer
     C                   MOVEL     HLISCN        T_RCST
      * Risk Currency
     C                   MOVEL     HLCCY         T_RCCY
      * Transaction Date
     C                   Z-ADD     DealDate      T_TDAT
      * Start Date
     C                   Z-ADD     ValueDate     T_SDAT
      * End Date
     C                   Z-ADD     MaturityDate  T_EDAT
      * Issuer Exposure
     C                   MOVEL     'Y'           T_ISEI
      * Matured?
     C     HLDSTS        IFEQ      'M'
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C     HLDDLT        IFEQ      'D'
     C                   MOVEL     'D'           T_ACTN
     C                   ELSE
     C                   MOVEL     'A'           T_ACTN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN            8 0
     C                   PARM                    ZZMDNO            5 0
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
