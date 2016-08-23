     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Posting Details')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOPOSTDTS - Posting Details                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG18222           Date 21Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18222 - Increase LOANTYPES array size to 9999 to          *
      *             accomodate more than 1000 loan types              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FSDLOANL0  IF   E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      **  Transaction type/module
     D TABCDE          S              2    DIM(46) CTDATA PERRCD(1)
     D TABTYP          S              6    DIM(46) ALT(TABCDE)
 
 
      ** Loan types
     D*LOANTYPES       S              2    DIM(999)                                         BUG18222
     D LOANTYPES       S              2    DIM(9999)                                        BUG18222
 
      ** Declared variable                                                                    CGL029
     D I#OTRF          S             21                                                       CGL029
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#OL              1
     C                   PARM                    I#TRYP            2
     C                   PARM                    I#TNMR            6
     C                   PARM                    I#PNAR           30
     C                   PARM                    I#SPOS            7
     C                   PARM                    I#OTTP           10
     C**********         PARM                    I#OTRF           15                          CGL029
     C                   PARM                    I#OTRF                                       CGL029
      * OUTPUTS
     C                   PARM                    O#TMOD            2
     C                   PARM                    O#TSMD            4
     C                   PARM                    O#TREF           20
 
      * Determine module/sub-module/transaction reference
 
     C                   MOVEL     *BLANK        O#TMOD
     C                   MOVEL     *BLANK        O#TSMD
     C                   MOVEL     *BLANK        O#TREF
 
     C     I#OL          IFEQ      'Y'
     C                   EXSR      DET_MODTREF_OL
     C                   ELSE
     C                   EXSR      DET_MODTREF
     C                   ENDIF
 
      * return
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * Determine module/sub-module/transaction reference
      ********************************************************************
     C     DET_MODTREF_OLBEGSR
 
     C                   SELECT
     C     I#TRYP        WHENEQ    'OP'
     C     I#TNMR        ANDEQ     *BLANK
     C                   MOVEL     'FT'          O#TMOD
     C                   MOVEL     'OTPY'        O#TSMD
     C                   MOVEL     I#PNAR        O#TREF
     C     I#TRYP        WHENEQ    'IN'
     C     I#TNMR        ANDEQ     *BLANK
     C                   MOVEL     'FT'          O#TMOD
     C                   MOVEL     'INPY'        O#TSMD
     C                   MOVEL     I#PNAR        O#TREF
     C                   OTHER
     C     I#TRYP        LOOKUP    TABCDE        TABTYP                   99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     TABTYP        O#TMOD
     C                   MOVE      TABTYP        O#TSMD
     C                   MOVEL     I#TNMR        O#TREF
     C                   ELSE
     C     I#TRYP        IFNE      *BLANK                                       *
     C     I#TRYP        LOOKUP    LOANTYPES                              99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'LE'          O#TMOD
     C                   MOVE      'CLIP'        O#TSMD
     C                   MOVEL     I#TNMR        O#TREF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine module/sub-module/transaction reference
      ********************************************************************
     C     DET_MODTREF   BEGSR
 
     C                   MOVEL     I#OTTP        TranType          2
 
     C                   SELECT
      * FT
     C     I#SPOS        WHENEQ    '  GE-FT'
     C     TranType      IFEQ      'OP'
     C                   MOVEL     'FT'          O#TMOD
     C                   MOVEL     'OTPY'        O#TSMD
     C                   MOVEL     I#OTRF        O#TREF
     C                   ENDIF
     C     TranType      IFEQ      'IN'
     C                   MOVEL     'FT'          O#TMOD
     C                   MOVEL     'INPY'        O#TSMD
     C                   MOVEL     I#OTRF        O#TREF
     C                   ENDIF
      * DL
     C     I#SPOS        WHENEQ    '  GE-DL'
     C     TranType      LOOKUP    TABCDE        TABTYP                   99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     TABTYP        O#TMOD
     C                   MOVE      TABTYP        O#TSMD
     C                   MOVEL     I#OTRF        O#TREF
     C                   ENDIF
      * LE
     C     I#SPOS        WHENEQ    '  GE-LE'
     C     TranType      IFNE      *BLANK                                       *
     C     TranType      LOOKUP    LOANTYPES                              99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'LE'          O#TMOD
     C                   MOVE      'CLIP'        O#TSMD
     C                   MOVEL     I#OTRF        O#TREF
     C                   ENDIF
     C                   ENDIF
      * SE
     C     I#SPOS        WHENEQ    '  GE-ST'
     C     TranType      LOOKUP    TABCDE        TABTYP                   99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     TABTYP        O#TMOD
     C                   MOVE      TABTYP        O#TSMD
     C                   MOVEL     I#OTRF        O#TREF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Access loan types
 
     C**********         Z-ADD     0             X                 3 0                      BUG18222
     C                   Z-ADD     0             X                 4 0                      BUG18222
     C     *LOVAL        SETLL     SDLOANL0
     C                   READ      SDLOANL0                               99
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             X
     C                   MOVEL     AYLNTY        LOANTYPES(X)
     C                   READ      SDLOANL0                               99
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** TABCDE/TABTYP. TRANSACTION TYPES
TPSETRAD
TSSETRAD
WISEDPWI
WOSEDPWO
FPDLFXDL
FSDLFXDL
CXDLFXDL
PIDLFXDL
SIDLFXDL
SWDLFXDL
OPDLFXDL
OTDLFXDL
IPDLLDNI
TIDLLDNI
CLDLLDNI
LNDLLDNI
DLDLLDNI
FLDLLDNI
LPDLLDNI
DPDLLDNI
ITDLLDNI
TDDLLDNI
CDDLLDNI
CIDLLDNI
FTDLLDNI
DTDLLDNI
LTDLLDNI
C1DLNASP
C2DLNASP
BPDLNASP
BDDLNASP
DADLNASP
TADLNASP
TBDLNASP
CSDLNASS
BSDLNASS
BRDLNASS
TSDLNASS
RADLNASS
TRDLNASS
FRDLFRAS
RSDLSIRS
RXDLCIRS
RPDLCFCO
RFDLCFCO
RRDLCFCO
