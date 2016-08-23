     H DEBUG
      *****************************************************************
/*OVR *  OVRDBF FILE(LEILONLX) TOFILE(LEILONL2) SHARE(*NO)            *
/*OVR *  OVRDBF FILE(LEILAMLX) TOFILE(LEILAML2) SHARE(*NO)            *             CAP061
/*OVR *  OVRDBF FILE(LEIROLLX) TOFILE(LEIROLL2) SHARE(*NO)            *             CAP062
/*OVR *  OVRDBF FILE(LEIMRPLX) TOFILE(LEIMRPL2) SHARE(*NO)            *             CAP063
/*OVR *  OVRDBF FILE(LEIFEELX) TOFILE(LEIFEEL2) SHARE(*NO)            *             CAP064
/*OVR *  OVRDBF FILE(LEIFACLX) TOFILE(LEIFACL2) SHARE(*NO)            *             CAP068
/*OVR *  OVRDBF FILE(LEITISLZ) TOFILE(LEITISL2) SHARE(*NO)            *                       CLE035
/*OVR *  DSPFFD FILE(TRANSA) OUTPUT(*OUTFILE) OUTFILE(QTEMP/FFD)      *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid lending transaction maintenance')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  LE2031   - INVALID LENDING TRANSACTION MAINTENANCE           *
      *                                                               *
      *  Function:  This screen function allows invalid lending       *
      *             transactions to be enquired upon or deleted.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256407             Date 04Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE038             Date 11May04               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE036             Date 22Oct03               *
      *                 CLE034             Date 05May03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 16May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CAP064             Date 07Jun01               *
      *                 CAP063             Date 05Jun01               *
      *                 CAP062             Date 04Jun01               *
      *                 CAP061             Date 31May01               *
      *                 CAP053  *CREATE    Date 12Mar01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  256407 - Use correct message file for settlement error msgs  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by       *
      *           Amount (Recompile)                                  *
      *  CLE035 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Income Splits                                       *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Allow repayments in facility currency. (Recompile)  *
      *  CLE034 - Lending Enhancements.                               *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAP068 - Lending API enhancements - Facility Input           *
      *  CAP064 - Lending API enhancements - Fees Input               *
      *  CAP063 - Lending API enhancements - Manual Repayment         *
      *  CAP062 - Lending API enhancements - Rollover Input           *
      *  CAP061 - Lending API enhancements - Loans Amendment          *
      *  CAP053 - Lending API enhancements - Loans Input              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLE2031DF  CF   E             WORKSTN
     FLEILONL2  IF   E           K DISK
     F                                     RENAME(LEILONP0:LEILONP2) USROPN
     FLEILONLX  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEILONP0:LEILONDL) USROPN
     F                                     COMMIT
 
     FLEILAML2  IF   E           K DISK                                         CAP061
     F                                     RENAME(LEILAMP0:LEILAMP2) USROPN     CAP061
     F                                     PREFIX(A1)                           CAP061
     FLEILAMLX  UF   E           K DISK    INFSR(*PSSR)                         CAP061
     F                                     RENAME(LEILAMP0:LEILAMDL) USROPN     CAP061
     F                                     COMMIT                               CAP061
 
     FLEIROLL2  IF   E           K DISK                                         CAP062
     F                                     RENAME(LEIROLP0:LEIROLP2) USROPN     CAP062
     F                                     PREFIX(B1)                           CAP062
     FLEIROLLX  UF   E           K DISK    INFSR(*PSSR)                         CAP062
     F                                     RENAME(LEIROLP0:LEIROLDL) USROPN     CAP062
     F                                     PREFIX(B2)                           CAP062
     F                                     COMMIT                               CAP062
 
     FLEIMRPL2  IF   E           K DISK                                         CAP063
     F                                     RENAME(LEIMRPD0:LEIMRPD2) USROPN     CAP063
     F                                     PREFIX(C1)                           CAP063
     FLEIMRPLX  UF   E           K DISK    INFSR(*PSSR)                         CAP063
     F                                     RENAME(LEIMRPD0:LEIMRPDL) USROPN     CAP063
     F                                     COMMIT                               CAP063
 
     FLEIFEEL2  IF   E           K DISK                                         CAP064
     F                                     RENAME(LEIFEEP0:LEIFEEP2) USROPN     CAP064
     F                                     PREFIX(D1)                           CAP064
     FLEIFEELX  UF   E           K DISK    INFSR(*PSSR)                         CAP064
     F                                     RENAME(LEIFEEP0:LEIFEEDL) USROPN     CAP064
     F                                     COMMIT                               CAP064
 
     FLEIFACL2  IF   E           K DISK                                         CAP068
     F                                     RENAME(LEIFACP0:LEIFACP2) USROPN     CAP068
     F                                     PREFIX(E1)                           CAP068
     FLEIFACLX  UF   E           K DISK    INFSR(*PSSR)                         CAP068
     F                                     RENAME(LEIFACP0:LEIFACDL) USROPN     CAP068
     F                                     COMMIT                               CAP068
 
     FFFD       IF   E           K DISK    USROPN
 
     FLEISTLL2  UF   E           K DISK    USROPN                                             CLE034
      ** Settlement Allocations Input Invalid Data                                            CLE034
      *                                                                                       CLE034
     FLEITISL2  IF   E           K DISK                                                       CLE035
     F                                     RENAME(LEITISD0:LEITISD2) USROPN                   CLE035
     F                                     PREFIX(F1)                                         CLE035
      ** Invalid Income Splits by repair number                                               CLE035
                                                                                              CLE035
     FLEITISLZ  UF   E           K DISK    INFSR(*PSSR)                                       CLE035
     F                                     RENAME(LEITISD0:LEITISDL) USROPN                   CLE035
     F                                     COMMIT                                             CLE035
      ** Invalid Income Splits by repair number                                               CLE035
                                                                                              CLE035
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
      ** Short Data Structure for Access Programs                                             CLE034
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CLE034
      ** Externally described DS for SAR details                                              CLE034
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE034
                                                                                              CLE034
     D MES             S              1    DIM(80) CTDATA PERRCD(80)
 
     D @FLDN           S             10A   DIM(300)
     D @FLDD           S             30A   DIM(300)
     D @FLDC           S             35A   DIM(300)
 
     D @RPGN           S             10A   DIM(300)
     D @ATRB           S             10A   DIM(300)
     D @DESC           S             30A   DIM(300)
 
     D ALLFD           DS           450
     D  DDFD01                 1     30
     D  DDFD02                31     60
     D  DDFD03                61     90
     D  DDFD04                91    120
     D  DDFD05               121    150
     D  DDFD06               151    180
     D  DDFD07               181    210
     D  DDFD08               211    240
     D  DDFD09               241    270
     D  DDFD10               271    300
     D  DDFD11               301    330
     D  DDFD12               331    360
     D  DDFD13               361    390
     D  DDFD14               391    420
     D  DDFD15               421    450
 
     D ALLFC           DS           525
     D  DDFC01                 1     35
     D  DDFC02                36     70
     D  DDFC03                71    105
     D  DDFC04               106    140
     D  DDFC05               141    175
     D  DDFC06               176    210
     D  DDFC07               211    245
     D  DDFC08               246    280
     D  DDFC09               281    315
     D  DDFC10               316    350
     D  DDFC11               351    385
     D  DDFC12               386    420
     D  DDFC13               421    455
     D  DDFC14               456    490
     D  DDFC15               491    525
 
     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  DATFMT                12     12
 
     D LEILONX       E DS                  EXTNAME(LEILONPD)
 
     D LEILAMX       E DS                  EXTNAME(LEILAMPD) PREFIX(A1)             CAP061
     D LEIROLX       E DS                  EXTNAME(LEIROLPD) PREFIX(B1)             CAP062
     D LEIMRPX       E DS                  EXTNAME(LEIMRPPD) PREFIX(C1)             CAP063
     D LEIFEEX       E DS                  EXTNAME(LEIFEEPD) PREFIX(D1)             CAP064
     D LEIFACX       E DS                  EXTNAME(LEIFACPD) PREFIX(E1)             CAP068
     D LEITISX       E DS                  EXTNAME(LEITISPD) PREFIX(F1)                       CLE035
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for AOSARDR0                                                              CLE034
                                                                                              CLE034
     D PRtrnCode       S              7A                                                      CLE034
     D POptn           S              7A                                                      CLE034
     D PSard           S              6A                                                      CLE034
                                                                                              CLE034
      ** Switchable feature                                                                   CLE034
                                                                                              CLE034
     D CLE034          S              1A                                                      CLE034
     D CLE035          S              1A                                                      CLE035
                                                                                              CLE034
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALIZATION
 
     C                   EXSR      INIT
 
      * Write/Read Screen
 
     C                   EXSR      WRSCRN
 
      * DO WHILE COMMAND 10 OR 12 NOT TAKEN
 
     C     *INKJ         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
 
      * Write/Read Screen
 
     C                   EXSR      WRSCRN
     C                   END
 
      * IF COMMAND 10 TAKEN, DELETE THE TRANSACTION
 
     C     *INKJ         IFEQ      '1'
     C     InvFil        IFEQ      'LEILONPD'
     C     IREPN         CHAIN     LEILONDL                           99
     C  N99              DELETE    LEILONDL
     C                   COMMIT
     C                   END
                                                                                CAP061
     C                   If        InvFil = 'LEILAMPD'                          CAP061
     C     IREPN         Chain     LEILAMDL                           99        CAP061
     C                   If        not *IN99                                    CAP061
     C                   Delete    LEILAMDL                                     CAP061
     C                   Commit                                                 CAP061
     C                   EndIf                                                  CAP061
     C                   EndIf                                                  CAP061
 
     C                   If        InvFil = 'LEIROLPD'                          CAP062
     C     IREPN         Chain     LEIROLDL                           99        CAP062
     C                   If        not *IN99                                    CAP062
     C                   Delete    LEIROLDL                                     CAP062
     C                   Commit                                                 CAP062
     C                   EndIf                                                  CAP062
     C                   EndIf                                                  CAP062
 
     C                   If        InvFil = 'LEIMRPPD'                          CAP063
     C     IREPN         Chain     LEIMRPDL                           99        CAP063
     C                   If        not *IN99                                    CAP063
     C                   Delete    LEIMRPDL                                     CAP063
     C                   Commit                                                 CAP063
     C                   EndIf                                                  CAP063
     C                   EndIf                                                  CAP063
 
     C                   If        InvFil = 'LEIFEEPD'                          CAP064
     C     IREPN         Chain     LEIFEEDL                           99        CAP064
     C                   If        not *IN99                                    CAP064
     C                   Delete    LEIFEEDL                                     CAP064
     C                   Commit                                                 CAP064
     C                   EndIf                                                  CAP064
     C                   EndIf                                                  CAP064
                                                                                CAP064
     C                   If        InvFil = 'LEIFACPD'                          CAP068
     C     IREPN         Chain     LEIFACDL                           99        CAP068
     C                   If        not *IN99                                    CAP068
     C                   Delete    LEIFACDL                                     CAP068
     C                   Commit                                                 CAP068
     C                   EndIf                                                  CAP068
     C                   EndIf                                                  CAP068
                                                                                CAP068
     C                   IF        CLE034 = 'Y' AND                                           CLE034
     C                             InvFil = 'LEISTLPD'                                        CLE034
     C     IREPN         CHAIN     LEISTLL2                           99                      CLE034
     C                   IF        NOT *IN99                                                  CLE034
     C                   DELETE    LEISTLL2                                                   CLE034
     C                   COMMIT                                                               CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   IF        CLE035 = 'Y' AND                                           CLE035
     C                             InvFil = 'LEITISPD'                                        CLE035
     C     IREPN         CHAIN     LEITISDL                           99                      CLE035
                                                                                              CLE035
      ** Delete invalid income split transactions                                             CLE035
                                                                                              CLE035
     C                   IF        NOT *IN99                                                  CLE035
     C                   DELETE    LEITISDL                                                   CLE035
     C                   COMMIT                                                               CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   END
 
     C                   CLOSE     LEILONL2
     C                   CLOSE     LEILONLX
     C                   CLOSE     LEILAML2                                     CAP061
     C                   CLOSE     LEILAMLX                                     CAP061
     C                   CLOSE     LEIROLL2                                     CAP062
     C                   CLOSE     LEIROLLX                                     CAP062
     C                   CLOSE     LEIMRPL2                                     CAP063
     C                   CLOSE     LEIMRPLX                                     CAP063
     C                   CLOSE     LEIFEEL2                                     CAP064
     C                   CLOSE     LEIFEELX                                     CAP064
     C                   CLOSE     LEIFACL2                                     CAP068
     C                   CLOSE     LEIFACLX                                     CAP068
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   CLOSE     LEISTLL2                                                   CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE035
      ** Close Invalid income split file                                                      CLE035
                                                                                              CLE035
     C                   IF        CLE035 = 'Y'                                               CLE035
     C                   CLOSE     LEITISL2                                                   CLE035
     C                   CLOSE     LEITISLZ                                                   CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      **  Clear screen message queue.
 
     C                   CALL      'ZA0250'
 
      *  Return
 
     C                   RETURN
      /EJECT
      *****************************************************************
      * WRITE/READ SCREEN
      *****************************************************************
     C     WRSCRN        BEGSR
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL1
      *
     C                   MOVEA     '00'          *IN(25)
     C                   READ      #RCDDTL1                               99
 
      ** If rollup requested, get next 15 fields and contents
 
     C     *IN25         IFEQ      '1'
     C                   ADD       15            @P
     C     @P            IFGT      @LFN
     C                   Z-ADD     1             @P
     C                   ENDIF
     C                   EXSR      SETSFC
     C                   ELSE
 
      ** If rolldown requested, get previous 15 fields and contents
 
     C     *IN26         IFEQ      '1'
     C                   SUB       15            @P
     C     @P            IFLE      0
     C                   Z-ADD     1             @P
     C                   ENDIF
     C                   EXSR      SETSFC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      * Get the invalid transaction using the repair number
 
     C                   SELECT
 
     C     InvFil        WHENEQ    'LEILONPD'
     C                   OPEN      LEILONL2
     C                   OPEN      LEILONLX
     C     IREPN         CHAIN     LEILONP2                           99
 
     C     InvFil        WHENEQ    'LEILAMPD'                                   CAP061
     C                   OPEN      LEILAML2                                     CAP061
     C                   OPEN      LEILAMLX                                     CAP061
     C     IREPN         CHAIN     LEILAMP2                           99        CAP061
     C                   EVAL      XMSID = A1XMSID                              CAP061
 
     C     InvFil        WHENEQ    'LEIROLPD'                                   CAP062
     C                   OPEN      LEIROLL2                                     CAP062
     C                   OPEN      LEIROLLX                                     CAP062
     C     IREPN         CHAIN     LEIROLP2                           99        CAP062
     C                   EVAL      XMSID = B1XMSID                              CAP062
 
     C     InvFil        WHENEQ    'LEIMRPPD'                                   CAP063
     C                   OPEN      LEIMRPL2                                     CAP063
     C                   OPEN      LEIMRPLX                                     CAP063
     C     IREPN         CHAIN     LEIMRPD2                           99        CAP063
     C                   EVAL      XMSID = C1XMSID                              CAP063
 
     C     InvFil        WHENEQ    'LEIFEEPD'                                   CAP064
     C                   OPEN      LEIFEEL2                                     CAP064
     C                   OPEN      LEIFEELX                                     CAP064
     C     IREPN         CHAIN     LEIFEEP2                           99        CAP064
     C                   EVAL      XMSID = D1XMSID                              CAP064
                                                                                CAP068
     C     InvFil        WHENEQ    'LEIFACPD'                                   CAP068
     C                   OPEN      LEIFACL2                                     CAP068
     C                   OPEN      LEIFACLX                                     CAP068
     C     IREPN         CHAIN     LEIFACP2                           99        CAP068
     C                   EVAL      XMSID = E1XMSID                              CAP068
                                                                                              CLE034
     C     CLE034        WHENEQ    'Y'                                                        CLE034
     C     InvFil        ANDEQ     'LEIFACPD'                                                 CLE034
     C                   OPEN      LEISTLL2                                                   CLE034
     C     IREPN         CHAIN     LEISTLL2                           99                      CLE034
                                                                                              CLE035
      ** Open Invalid income splits file                                                      CLE035
                                                                                              CLE035
     C     CLE035        WHENEQ    'Y'                                                        CLE035
     C     InvFil        ANDEQ     'LEITISPD'                                                 CLE035
     C                   OPEN      LEITISL2                                                   CLE035
     C                   OPEN      LEITISLZ                                                   CLE035
     C     IREPN         CHAIN     LEITISD2                           99                      CLE035
     C                   EVAL      XMSID = F1XMSID                                            CLE035
                                                                                              CLE035
     C                   ENDSL
 
     C     *in99         IFEQ      '1'
     C                   RETURN
     C                   ENDIF
 
      * Add the error message to the message subfile
 
     C                   DUMP                                                   CAP068
     C                   EXSR      ADDERR2SF
 
      * Fill field description and contents arrays
 
     C                   MOVEL     *BLANK        @FLDD
     C                   MOVEL     *BLANK        @FLDC
      *
     C                   EXSR      FILLARR
 
      * Store last field number
 
     C                   Z-ADD     @P            @LFN              5 0
 
      * Set initial screen fields and contents
 
     C                   Z-ADD     1             @P
     C                   EXSR      SETSFC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Set Screen Fields and Contents                                *
      *****************************************************************
     C     SETSFC        BEGSR
 
      * Move field description and contents into output fields
 
     C                   MOVEL     *BLANK        ALLFD
     C                   MOVEL     *BLANK        ALLFC
     C                   MOVEA     @FLDD(@P)     ALLFD
     C                   MOVEA     @FLDC(@P)     ALLFC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Fill Field Description and Contents Arrays                    *
      *****************************************************************
     C     FILLARR       BEGSR
      *
     C                   Z-ADD     1             @P
      *
     C     @P            DOWLE     300
     C     @DESC(@P)     ANDNE     *BLANK
 
     C                   MOVEL     @RPGN(@P)     WHFLDI
     C                   MOVEL     @ATRB(@P)     WHIBO
     C                   MOVE      @ATRB(@P)     WHFLDB
     C                   MOVEL     @DESC(@P)     WHFTXT
 
     C                   MOVEL     WHFLDI        @FLDN(@P)
     C                   MOVEL     WHFTXT        @FLDD(@P)
 
     C                   If        InvFil = 'LEILONPD'                          CAP061
     C     WHFLDB        SUBST     LEILONX:WHIBO @FLDC(@P)
     C                   Endif                                                  CAP061
 
     C                   If        InvFil = 'LEILAMPD'                          CAP061
     C     WHFLDB        SUBST     LEILAMX:WHIBO @FLDC(@P)                      CAP061
     C                   Endif                                                  CAP061
 
     C                   If        InvFil = 'LEIROLPD'                          CAP062
     C     WHFLDB        SUBST     LEIROLX:WHIBO @FLDC(@P)                      CAP062
     C                   Endif                                                  CAP062
 
     C                   If        InvFil = 'LEIMRPPD'                          CAP063
     C     WHFLDB        SUBST     LEIMRPX:WHIBO @FLDC(@P)                      CAP063
     C                   Endif                                                  CAP063
 
     C                   If        InvFil = 'LEIFEEPD'                          CAP064
     C     WHFLDB        SUBST     LEIFEEX:WHIBO @FLDC(@P)                      CAPO64
     C                   Endif                                                  CAP064
 
     C                   If        InvFil = 'LEIFACPD'                          CAP068
     C     WHFLDB        SUBST     LEIFACX:WHIBO @FLDC(@P)                      CAP068
     C                   Endif                                                  CAP068
 
     C                   IF        CLE035 = 'Y' and                                           CLE035
     C                             InvFil = 'LEITISPD'                                        CLE035
     C     WHFLDB        SUBST     LEITISX:WHIBO @FLDC(@P)                                    CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ADD       1             @P
 
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ADD ERROR MESSAGES TO SUBFILE                                 *
      *****************************************************************
     C     ADDERR2SF     BEGSR
 
      *  Display error message
 
      * If a Lending error use message file 'LERMSGF'.
      * If a settlement detail error use message file 'DRSMM'.
 
     C                   MOVEL     XMSID         MSGF3             2
     C     MSGF3         IFEQ      'LE'
     C                   MOVEL     'LERMSGF '    ZAMSGF
     C                   ELSE
     C                   MOVEL     'DRSMM   '    ZAMSGF
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##PGM         ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM      XMSID         ZAMSID            7            Message Id.
     C**********         PARM      'LERMSGF '    ZAMSGF           10            Message file. 256407
     C                   PARM                    ZAMSGF           10            Message file. 256407
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Parameters passed into the program
 
     C     *ENTRY        PLIST
 
      * INPUTS
 
      * Invalid file name
     C                   PARM                    InvFil            8
 
      * Repair Number
     C                   PARM                    IREPN             5 0
 
      **  Run date in DDMMMYY
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Initialize program name
 
     C                   MOVEL     'LE2031    '  DBPGM
     C                   MOVEL     'LE2031    '  ##PGM
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
 
      * Get invalid file field attributes and description
 
     C                   EXSR      GETFILD
 
      **  Clear screen message queue.
 
     C                   CALL      'ZA0250'
 
     C                   CALL      'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       PRtrnCode                                    CLE034
     C                   PARM      '*VERIFY'     POptn                                        CLE034
     C                   PARM      'CLE034'      PSard                                        CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
                                                                                              CLE034
     C                   IF        PRtrnCode = *BLANKS                                        CLE034
                                                                                              CLE034
     C                   EVAL      CLE034 = 'Y'                                               CLE034
                                                                                              CLE034
     C                   ELSE                                                                 CLE034
                                                                                              CLE034
     C                   EVAL      CLE034 = 'N'                                               CLE034
                                                                                              CLE034
     C                   IF        PRtrnCode <> '*NRF   '                                     CLE034
     C     *LOCK         IN        LDA                                                        CLE034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE034
     C                   EVAL      DBKEY = 'CLE034'                                           CLE034
     C                   EVAL      DBASE = 01                                                 CLE034
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CLE034
     C                   OUT       LDA                                                        CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
                                                                                              CLE035
      ** Access SCSARDPD to determine if Nordea Income Splits enhancement                     CLE035
      ** is on                                                                                CLE035
                                                                                              CLE035
     C                   EVAL      CLE035 = 'N'                                               CLE035
     C                   CALL      'AOSARDR0'                                                 CLE035
     C                   PARM      *BLANKS       PRtrnCode                                    CLE035
     C                   PARM      '*VERIFY'     POptn                                        CLE035
     C                   PARM      'CLE035'      PSard                                        CLE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE035
                                                                                              CLE035
     C                   IF        PRtrnCode = *BLANKS                                        CLE035
     C                   EVAL      CLE035 = 'Y'                                               CLE035
     C                   ELSE                                                                 CLE035
     C                   IF        PRtrnCode <> '*NRF   '                                     CLE035
     C     *LOCK         IN        LDA                                                        CLE035
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE035
     C                   EVAL      DBKEY = 'CLE035'                                           CLE035
     C                   EVAL      DBASE = 002                                                CLE035
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CLE035
     C                   OUT       LDA                                                        CLE035
     C                   EXSR      *PSSR                                                      CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Get File Details                                              *
      *****************************************************************
     C     GETFILD       BEGSR
      *
     C                   Z-ADD     59            MESLEN           15 5
     C                   MOVEA     InvFil        MES(13)
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    MES
     C                   PARM                    MESLEN
 
      * Error
 
     C     *IN99         IFEQ      '1'
     C                   GOTO      E_GETFILD
     C                   END
 
      * Open file
 
     C                   OPEN      FFD
 
      * Read file
 
     C                   Z-ADD     1             @P                5 0
     C                   READ      FFD                                    99    *
      *
     C     *IN99         DOWEQ     '0'
 
     C                   MOVEL     WHFLDI        FirstCHAR         1
     C     FirstCHAR     IFEQ      'S'
     C                   MOVEL     WHFLDI        @RPGN(@P)
     C                   MOVEL     WHIBO         @ATRB(@P)
     C                   MOVE      WHFLDB        @ATRB(@P)
     C                   MOVEL     WHFTXT        @DESC(@P)
     C                   ADD       1             @P
     C                   ENDIF
      *
     C                   READ      FFD                                    99    *
     C                   ENDDO
 
      * Close file
 
     C                   CLOSE     FFD
      *
     C     E_GETFILD     ENDSR
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** MES
DSPFFD FILE(          ) OUTPUT(*OUTFILE) OUTFILE(QTEMP/FFD)
