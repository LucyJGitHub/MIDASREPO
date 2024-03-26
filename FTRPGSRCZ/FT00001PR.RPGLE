     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Return Customer Postal Address Details')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT00001PR - Return Customer Postal Address Details           *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. CSW123   *CREATE   Date 08Jan24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW123 - SWIFT ISO 20022 - Phase 2 (Structured Addresses)    *
      *                                                               *
      *****************************************************************
      ** Midas SD Customer Details Ext C - Keyed
     FSDCUSXL1  IF   E           K DISK
     F
     FACNUMA    IF   E           K DISK    RENAME(ACCNTABF:ACNUMAF)
     FACCNT     IF   E           K DISK    IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External data structure for Nostro customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D SDACCNT       E DS                  EXTNAME(ACCNTAB)
     D   IFBRCA      E                     EXTFLD(BRCA)
     D   IFCNUM      E                     EXTFLD(CNUM)
     D   IFCCY       E                     EXTFLD(CCY)
     D   IFACOD      E                     EXTFLD(ACOD)
     D   IFACSQ      E                     EXTFLD(ACSQ)
     D   IFIBAN      E                     EXTFLD(IBAN)
     D   IFIBSEQN    E                     EXTFLD(IBSEQN)
     D   IFRECI      E                     EXTFLD(RECI)
     D   IFATYP      E                     EXTFLD(ATYP)
     D   IFLCD       E                     EXTFLD(LCD)

     D                 DS
     D K#CNUM                  1      6
     D K#CCY                   7      9
     D K#ACOD                 10     19  0
     D K#ACSQ                 20     21  0
     D K#BRCA                 22     24
     D AKEYF                   1     24

     D ORDCST          DS           175
     D  DDORC1                 1     35
     D  DDORC2                36     70
     D  DDORC3                71    105
     D  DDORC4               106    140
     D  DDORC5               141    175
     D ORET                    1     10
     D ORETN                  11     35
     D ORETS                   2     11
     D ORETSN                 12     35
     D ONUM                    1      6
     D OCOD                    7     16
     D OSEQ                   17     18
     D OBRC                   19     21
     D OBRCA                  22     24
     D OSEQA                  18     19
     D ONUMS                   2      7
     D OCUSS                   2     11
     D OCODS                   8     17
     D OSEQS                  18     19
     D OBRCS                  20     22
     D  IBAN1                  1     34
     D  IBAN2                  2     35

      * Blank Line Analysis data structure
     D* ADCH26                36    210
     D* ADCH36                71    210

      * SWIFT Address Analysis data structure
     D* ADSLSH                 1      1
     D* ADSWFT                 1     11
     D* ADEXSW                12     35
     D* ADSLS2                36     36
     D* ADSWF2                36     46
     D* ADEXS2                47     70
     D* ADCH26                36    210
     D* ADCH36                71    210
     D* ADSLSH                 1      1
     D* ADSWFT                 1     11
     D* ADEXSW                12     35
     D* ADSLS2                36     36
     D* ADSWF2                36     46
     D* ADEXS2                47     70

     DCLSWTK           DS
     D SW                      1     12

     D DDCNAM          S            140A
     D DDDEPT          S             70A
     D DDSDEP          S             70A
     D DDSTRE          S             70A
     D DDBUIU          S             16A
     D DDBUIA          S             35A
     D DDFLOR          S             70A
     D DDPOSB          S             16A
     D DDROOM          S             70A
     D DDPOSC          S             16A
     D DDTWNN          S             35A
     D DDTWNL          S             35A
     D DDDISN          S             35A
     D DDCTRS          S             35A
     D DDCTRY          S              2A
     D DDRTCD          S              7A
     D DPORC1          S             35A
     D DPORC2          S             35A
     D DPORC3          S             35A
     D DPORC4          S             35A
     D DPORC5          S             35A
     D DPTYPP          S              1A
     D DPSMCY          S              3A

     D P#RTCD          S              7A
     D P#OPTN          S              7A
     D P#KEY1          S             10A
     D P#KYST          S              7A
     D ##CSID          S              1A
     D WRETA           S             10S 0
     D PRTCD           S              7A
     D P@IBAN          S             34A
     D CFT004          S              1A
     D POptn           S              7A
     D PSard           S              6A

     ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** Midas general constant fields

      /COPY FTCPYSRC,SFTVALCSLL
     D/COPY FTCPYSRC,SFTADDRILE

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EVAL      DDCNAM = *BLANKS
     C                   EVAL      DDDEPT = *BLANKS
     C                   EVAL      DDSDEP = *BLANKS
     C                   EVAL      DDSTRE = *BLANKS
     C                   EVAL      DDBUIU = *BLANKS
     C                   EVAL      DDBUIA = *BLANKS
     C                   EVAL      DDFLOR = *BLANKS
     C                   EVAL      DDPOSB = *BLANKS
     C                   EVAL      DDROOM = *BLANKS
     C                   EVAL      DDPOSC = *BLANKS
     C                   EVAL      DDTWNN = *BLANKS
     C                   EVAL      DDTWNL = *BLANKS
     C                   EVAL      DDDISN = *BLANKS
     C                   EVAL      DDCTRS = *BLANKS
     C                   EVAL      DDCTRY = *BLANKS
     C                   EVAL      DDRTCD = *BLANKS

     C                   EVAL      DDORC1 = DPORC1
     C                   EVAL      DDORC2 = DPORC2
     C                   EVAL      DDORC3 = DPORC3
     C                   EVAL      DDORC4 = DPORC4
     C                   EVAL      DDORC5 = DPORC5

      ** Validate for Ordering Customer Number and shortname

     C                   IF        %SUBST(DDORC1:1:1) = '/' AND
     C                             %SUBST(ORDCST:12:164) = *BLANKS OR
     C                             %SUBST(DDORC1:1:1) <> '/' AND
     C                             %SUBST(ORDCST:11:165) = *BLANKS OR
     C                             %SUBST(DDORC1:1:1) = '/' AND
     C                             %SUBST(ORDCST:45:130) = *BLANKS  AND
     C                             %SUBST(ORDCST:36:10) <> *BLANKS OR
     C                             %SUBST(DDORC1:1:1) = '/' AND
     C                             DDORC2 <> *BLANKS

     C                   IF        %SUBST(DDORC1:1:1) = '/'
     C                   EVAL      P#KEY1 = DDORC2
     C                   ELSE
     C                   MOVEL     DDORC1        P#KEY1
     C                   ENDIF

     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       P#RTCD
     C                   PARM      '*KEY   '     P#OPTN
     C                   PARM                    P#KEY1
     C                   PARM      *Blanks       P#KYST
     C     SDCUST        PARM      *Blanks       DSSDY

     C                   IF        P#RTCD = *BLANKS

     C     BBCUST        CHAIN     SDCUSXL1

     C                   IF        %FOUND(SDCUSXL1)
     C                   EVAL      DDCNAM = XCCNAM
     C                   EVAL      DDDEPT = XCDEPT
     C                   EVAL      DDSDEP = XCSDEP
     C                   EVAL      DDSTRE = XCSTRE
     C                   EVAL      DDBUIU = XCBUIU
     C                   EVAL      DDBUIA = XCBUIA
     C                   EVAL      DDFLOR = XCFLOR
     C                   EVAL      DDPOSB = XCPOSB
     C                   EVAL      DDROOM = XCROOM
     C                   EVAL      DDPOSC = XCPOSC
     C                   EVAL      DDTWNN = XCTWNN
     C                   EVAL      DDTWNL = XCTWNL
     C                   EVAL      DDDISN = XCDISN
     C                   EVAL      DDCTRS = XCCTRS
     C                   EVAL      DDCTRY = XCCTRY
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDRTCD = '*NRF'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDRTCD = '*NRF'
     C                   ENDIF

      ** Check if it is a retail account
     C                   IF        DDRTCD = '*NRF'
     C                             AND DPTYPP = 'D'
     C                   IF        %SUBST(DDORC1:1:1) = '/'
     C                             AND ORETSN = *BLANKS
     C                   MOVEL     ORETS         WRETA
     C                   ENDIF
     C                   IF        %SUBST(DDORC1:1:1) <> '/'
     C                             AND ORETN = *BLANKS
     C                   MOVEL     ORET          WRETA
     C                   ENDIF
     C     WRETA         CHAIN     ACNUMA
     C                   IF        %FOUND(ACNUMA)
     C                             AND RECI = 'D'
     C                   EVAL      DDRTCD = *BLANKS

     C     CNUM          CHAIN     SDCUSXL1

     C                   IF        %FOUND(SDCUSXL1)
     C                   EVAL      DDCNAM = XCCNAM
     C                   EVAL      DDDEPT = XCDEPT
     C                   EVAL      DDSDEP = XCSDEP
     C                   EVAL      DDSTRE = XCSTRE
     C                   EVAL      DDBUIU = XCBUIU
     C                   EVAL      DDBUIA = XCBUIA
     C                   EVAL      DDFLOR = XCFLOR
     C                   EVAL      DDPOSB = XCPOSB
     C                   EVAL      DDROOM = XCROOM
     C                   EVAL      DDPOSC = XCPOSC
     C                   EVAL      DDTWNN = XCTWNN
     C                   EVAL      DDTWNL = XCTWNL
     C                   EVAL      DDDISN = XCDISN
     C                   EVAL      DDCTRS = XCCTRS
     C                   EVAL      DDCTRY = XCCTRY
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Check if input is a SWIFT
     C                   IF        DDRTCD = '*NRF'

     C                   Eval      ADDRSS = *Blanks
     C                   Eval      ADCHK1 = DPORC1
     C                   Eval      ADCHK2 = DPORC2
     C                   Eval      ADCHK3 = DPORC3
     C                   Eval      ADCHK4 = DPORC4
     C                   Eval      ADCHK5 = DPORC5

     C                   If        ADCH26 = *Blanks and
     C                             ADEXSW = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADEXS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'

      *  First 11 characters should be key for CLSWT.
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        CLSWTK
     C                   Else
     C                   Movel     ADCHK2        CLSWTK
     C                   End

     C                   Exsr      SWIFT

     C                   If        ADSLSH = '/'and *IN31=*Off and *IN32=*Off
     C                             or ADSLSH <> '/'

     C                   If        *IN31 = *On
     C                             AND ##CSID = 'Y'
     C                   EVAL      DDRTCD = *BLANKS

     C     BBCUST        CHAIN     SDCUSXL1

     C                   IF        %FOUND(SDCUSXL1)
     C                   EVAL      DDCNAM = XCCNAM
     C                   EVAL      DDDEPT = XCDEPT
     C                   EVAL      DDSDEP = XCSDEP
     C                   EVAL      DDSTRE = XCSTRE
     C                   EVAL      DDBUIU = XCBUIU
     C                   EVAL      DDBUIA = XCBUIA
     C                   EVAL      DDFLOR = XCFLOR
     C                   EVAL      DDPOSB = XCPOSB
     C                   EVAL      DDROOM = XCROOM
     C                   EVAL      DDPOSC = XCPOSC
     C                   EVAL      DDTWNN = XCTWNN
     C                   EVAL      DDTWNL = XCTWNL
     C                   EVAL      DDDISN = XCDISN
     C                   EVAL      DDCTRS = XCCTRS
     C                   EVAL      DDCTRY = XCCTRY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Check if it is a retail account
     C                   IF        DDRTCD = '*NRF'
     C                             AND DPTYPP = 'D'

     C                   If        %SUBST(ORDCST:1:1) = '/'
     C                   MOVE      ONUMS         K#CNUM
     C                   Move      DPSMCY        K#CCY
     C                   Move      OCODS         K#ACOD
     C                   Move      OSEQS         K#ACSQ
     C                   Move      OBRCA         K#BRCA
     C                   Else
     C                   MOVE      ONUM          K#CNUM
     C                   Move      DPSMCY        K#CCY
     C                   Move      OCOD          K#ACOD
     C                   Move      OSEQ          K#ACSQ
     C                   Move      OBRC          K#BRCA
     C                   Endif

     C     AKEY          CHAIN     ACCNT
     C                   IF        %FOUND(ACCNT)
     C                             AND RECI = 'D'
     C                   EVAL      DDRTCD = *BLANKS

     C     CNUM          CHAIN     SDCUSXL1

     C                   IF        %FOUND(SDCUSXL1)
     C                   EVAL      DDCNAM = XCCNAM
     C                   EVAL      DDDEPT = XCDEPT
     C                   EVAL      DDSDEP = XCSDEP
     C                   EVAL      DDSTRE = XCSTRE
     C                   EVAL      DDBUIU = XCBUIU
     C                   EVAL      DDBUIA = XCBUIA
     C                   EVAL      DDFLOR = XCFLOR
     C                   EVAL      DDPOSB = XCPOSB
     C                   EVAL      DDROOM = XCROOM
     C                   EVAL      DDPOSC = XCPOSC
     C                   EVAL      DDTWNN = XCTWNN
     C                   EVAL      DDTWNL = XCTWNL
     C                   EVAL      DDDISN = XCDISN
     C                   EVAL      DDCTRS = XCCTRS
     C                   EVAL      DDCTRY = XCCTRY
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Check if it is an IBAN
     C                   IF        DDRTCD = '*NRF'
     C                             AND DPTYPP = 'C'
     C                             AND CFT004 = 'Y'
     C                             AND DDORC2 = *BLANKS

     C                   If        %SUBST(ORDCST:1:1) = '/'
     C                   Call      'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      IBAN2         P@Iban
     C     SDACCNT       Parm      SDACCNT       DSSDY
     C                   Else
     C                   Call      'AOIBANR2'
     C                   Parm      *Blanks       PRTCD
     C                   Parm      IBAN1         P@Iban
     C     SDACCNT       Parm      SDACCNT       DSSDY
     C                   EndIf

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DDRTCD = *BLANKS

     C     IFCNUM        CHAIN     SDCUSXL1

     C                   IF        %FOUND(SDCUSXL1)
     C                   EVAL      DDCNAM = XCCNAM
     C                   EVAL      DDDEPT = XCDEPT
     C                   EVAL      DDSDEP = XCSDEP
     C                   EVAL      DDSTRE = XCSTRE
     C                   EVAL      DDBUIU = XCBUIU
     C                   EVAL      DDBUIA = XCBUIA
     C                   EVAL      DDFLOR = XCFLOR
     C                   EVAL      DDPOSB = XCPOSB
     C                   EVAL      DDROOM = XCROOM
     C                   EVAL      DDPOSC = XCPOSC
     C                   EVAL      DDTWNN = XCTWNN
     C                   EVAL      DDTWNL = XCTWNL
     C                   EVAL      DDDISN = XCDISN
     C                   EVAL      DDCTRS = XCCTRS
     C                   EVAL      DDCTRY = XCCTRY
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

     C                   PARM                    DPORC1
     C                   PARM                    DPORC2
     C                   PARM                    DPORC3
     C                   PARM                    DPORC4
     C                   PARM                    DPORC5
     C                   PARM                    DPTYPP
     C                   PARM                    DPSMCY
     C                   PARM                    DDCNAM
     C                   PARM                    DDDEPT
     C                   PARM                    DDSDEP
     C                   PARM                    DDSTRE
     C                   PARM                    DDBUIU
     C                   PARM                    DDBUIA
     C                   PARM                    DDFLOR
     C                   PARM                    DDPOSB
     C                   PARM                    DDROOM
     C                   PARM                    DDPOSC
     C                   PARM                    DDTWNN
     C                   PARM                    DDTWNL
     C                   PARM                    DDDISN
     C                   PARM                    DDCTRS
     C                   PARM                    DDCTRY
     C                   PARM                    DDRTCD

      ** Key list for account validation
     C     AKEY          KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#CCY
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ
     C                   KFLD                    K#BRCA

      ** Check if feature CFT004 is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
     C                   EVAL      CFT004 = 'N'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine SWIFT
     E/COPY FTCPYSRC,SFTSWFTCLE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2024
