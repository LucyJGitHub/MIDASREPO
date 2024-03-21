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

     D DSSDY         E DS                  EXTNAME(DSSDY)

     D ORDCST          DS           175
     D  DDORC1                 1     35
     D  DDORC2                36     70
     D  DDORC3                71    105
     D  DDORC4               106    140
     D  DDORC5               141    175

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

     D P#RTCD          S              7A
     D P#OPTN          S              7A
     D P#KEY1          S             10A
     D P#KYST          S              7A

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C     *ENTRY        PLIST

     C                   PARM                    DPORC1
     C                   PARM                    DPORC2
     C                   PARM                    DPORC3
     C                   PARM                    DPORC4
     C                   PARM                    DPORC5
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
     C                             %SUBST(ORDCST:36:10) <> *BLANKS

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

     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2024
