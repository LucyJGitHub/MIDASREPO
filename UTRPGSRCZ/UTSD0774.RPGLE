     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Reporting/update utility for MD-38430')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  UTSD0774 - Reporting/Updating program for SDCOMPPD           *
      *             and GZCOMPPD records with less than3 chars.       *
      *                                                               *
      *  Function: Program will print a list of SDCOMPPD/GZSDCOMPPD/  *
      *            TABLET3 records with blanks. Also update all files *
      *            using the company code field.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD038430 *Create   Date 19May16               *
      *  Prev Amend No. MDnnnnnn           Date nnXxxnn               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD038430 - Unable to grant BFTC HKG user Company Codes.      *
      *             List all SDCOMPPD/GZSDCOMPPD/TABLET3 records      *
      *             with blanks to be formatted with zeros in front.  *
      *             Included SDBANKPD, GZSDBANKPD, TABLETR, SDBTSMPD, *
      *             SDBTSFPD, SDBTMHPD, SDBTFHPD, GLOLEMPD, OLPOSOA   *
      *             and GZOLPOSA in the reporting/update of company   *
      *             codes that need to be changed to have 3-chars.    *
      *                                                               *
      *****************************************************************
     FSDCOMPL0  UF   E           K DISK
     FGZSDCOMPL0UF   E           K DISK
     FSDBRCHL0  UF   E           K DISK
     FGZSDBRCHL0UF   E           K DISK    RENAME(SDBRCHD0:GZSDBRCHD0)
     FTABLET3   UF   E           K DISK
     FTABLETR   UF   E           K DISK
     FUTSD0774L0UF   E           K DISK
     F                                     PREFIX(A_)
     FUTSD0774L1UF   E           K DISK
     F                                     PREFIX(B_)
     FUTSD0774L2UF   E           K DISK
     F                                     PREFIX(C_)
     FUTSD0774L3UF   E           K DISK
     F                                     PREFIX(D_)
     FUTSD0774L4UF   E           K DISK
     F                                     PREFIX(E_)
     FUTSD0774L5UF   E           K DISK
     FGZOLPOSL0 UF   E           K DISK    RENAME(OLPOSOAF:GZOLPOSOAF)
     FMCMPS     UF   E           K DISK
     FDLTCSTV0  UF   E           K DISK
     FSDBANKPD  IF   E             DISK
      ** Reports
     FUTSD0774P1O    E             PRINTER OFLIND(*IN66)
     FUTSD0774P2O    E             PRINTER OFLIND(*IN68)

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
     D COMCODE         DS             3
     D  CC1                    1      1
     D  CC2                    2      2
     D  CC3                    3      3
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Mode Parameter
     D ModeParm        S              1A
     D Mode            S              6A
      ** Line Counters
     D X1Counter       S              6  0
     D X2Counter       S              6  0
     D BrCounter       S              6  0
     D SMCounter       S              6  0
     D SFCounter       S              6  0
     D MHCounter       S              6  0
     D FHCounter       S              6  0
     D GLCounter       S              6  0
     D OLCounter       S              6  0
     D MCCounter       S              6  0
     D DLCounter       S              6  0
     D CCCtr           S              6  0
     D CCArr           S              3A   DIM(100)
      *
      **  MAIN ROUTINE
      *
     C                   Z-ADD     0             X1Counter
     C                   MOVEL     *BLANKS       OLDCC             3
     C                   MOVEL     *BLANKS       COMCODE           3
      *
      ** Read all Company codes that have less than 3 characters.
      *
     C     *LOVAL        SETLL     SDCOMPL0
     C                   READ      SDCOMPL0                               10
      *
     C     *IN10         DOWEQ     '0'
      *
     C                   MOVEL     APCMCD        COMCODE
      *
     C     APCMCD        IFNE      ' '
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   MOVEL     APCMCD        OLDCC
     C                   EXSR      SRChkCC
      *
     C                   Exsr      PrintX1
      *
      ** If update mode (*IN30=*ON) update records on SDCOMPPD, GZSDCOMPPD and TABLET3.
      *
     C     *IN30         IFEQ      *ON
     C     APCMCD        CHAIN     GZSDCOMPL0                         20
     C                   MOVEL     COMCODE       APCMCD
     C     *IN20         IFEQ      *OFF
     C                   UPDATE    SDCOMPD0                                     ** Update GZSDCOMPPD
     C                   ENDIF
     C                   UPDATE    @APREB3                                      ** Update SDCOMPPD
     C     OLDCC         CHAIN     TABLET3                            20
     C     *IN20         IFEQ      *OFF
     C                   MOVEL     APCMCD        CMPYM                          ** Update TABLET3
     C                   UPDATE    TABLET3F
     C                   ENDIF
     C                   ENDIF                                                  ** If *IN30 = *ON
      *
     C                   ENDIF                                                  ** If blank char fnd
     C                   ENDIF                                                  ** If Code not blank
      *
      ** Read next record
      *
     C                   READ      SDCOMPL0                               10
      *
     C                   ENDDO
      *
      ** Print Totals for P1 if details are printed
      *
     C                   If        X1Counter > 0
     C                   Eval      UTCOUNT = X1Counter
     C                   Else
     C                   Eval      *IN67 = *On
     C                   Write     UTPAGHDR
     C                   Write     UTTITLE
     C                   Endif
     C                   Write     UTFINTTL
     C                   Write     UTENDRPT
      *
      ** Process for other files using Company Code field
      *
     C                   Eval      *IN67 = *Off
     C                   EXSR      SRChkBR
     C                   If        BrCounter > 0
     C                   MOVEL     'SDBRCHPD  '  MDFILE           10
     C                   Z-ADD     BrCounter     MDCOUNT           6 0
     C                   EXSR      PrintX2
     C                   MOVEL     'GZSDBRCHPD'  MDFILE
     C                   EXSR      PrintX2
     C                   MOVEL     'TABLETR   '  MDFILE
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkSM
     C                   If        SMCounter > 0
     C                   MOVEL     'SDBTSMPD  '  MDFILE
     C                   Z-ADD     SMCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkSF
     C                   If        SFCounter > 0
     C                   MOVEL     'SDBTSFPD  '  MDFILE
     C                   Z-ADD     SFCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkMH
     C                   If        MHCounter > 0
     C                   MOVEL     'SDBTMHPD  '  MDFILE
     C                   Z-ADD     MHCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkFH
     C                   If        FHCounter > 0
     C                   MOVEL     'SDBTFHPD  '  MDFILE
     C                   Z-ADD     FHCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkGL
     C                   If        GLCounter > 0
     C                   MOVEL     'GLOLEMPD  '  MDFILE
     C                   Z-ADD     GLCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkOL
     C                   If        GLCounter > 0
     C                   MOVEL     'OLPOSOA   '  MDFILE
     C                   Z-ADD     OLCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   MOVEL     'GZOLPOSOA '  MDFILE
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkMC
     C                   If        MCCounter > 0
     C                   MOVEL     'MCMPSDD   '  MDFILE
     C                   Z-ADD     MCCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
     C                   EXSR      SRChkDL
     C                   If        DLCounter > 0
     C                   MOVEL     'DLTCSTPD  '  MDFILE
     C                   Z-ADD     DLCounter     MDCOUNT
     C                   EXSR      PrintX2
     C                   Endif
      *
      ** Print Totals for P2 if details are printed
      *
     C                   If        X2Counter > 0
     C                   Eval      UTTFCOUNT = X2Counter
     C                   Else
     C                   Eval      *IN67 = *On
     C                   Write     UTPAGHDR2
     C                   Write     UTTITLE2
     C                   Endif
     C                   Write     UTFINTTL2
     C                   Write     UTENDRPT2
      *
      ** End Program
      *
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      *
      *   SRChkCC - SR to check/update Company Codes Standing Data file.
      *
      *****************************************************************
     C     SRChkCC       BEGSR
      *
      ** '__X'
     C     CC1           IFEQ      ' '
     C     CC2           ANDEQ     ' '
     C     CC3           ANDNE     ' '
     C                   MOVEL     '00'          COMCODE
     C                   ENDIF
      ** '_X_'
     C     CC1           IFEQ      ' '
     C     CC2           ANDNE     ' '
     C     CC3           ANDEQ     ' '
     C                   MOVEL     CC2           CC3
     C                   MOVEL     '00'          COMCODE
     C                   ENDIF
      ** 'X__'
     C     CC1           IFNE      ' '
     C     CC2           ANDEQ     ' '
     C     CC3           ANDEQ     ' '
     C                   MOVEL     CC1           CC3
     C                   MOVEL     '00'          COMCODE
     C                   ENDIF
      ** '_XX'
     C     CC1           IFEQ      ' '
     C     CC2           ANDNE     ' '
     C     CC3           ANDNE     ' '
     C                   MOVEL     '0'           COMCODE
     C                   ENDIF
      ** 'XX_'
     C     CC1           IFNE      ' '
     C     CC2           ANDNE     ' '
     C     CC3           ANDEQ     ' '
     C                   MOVE      CC2           CC23              2
     C                   MOVEL     CC1           CC23              2
     C                   MOVE      CC23          COMCODE
     C                   MOVEL     '0'           COMCODE
     C                   ENDIF
      ** 'X_X'
     C     CC1           IFNE      ' '
     C     CC2           ANDEQ     ' '
     C     CC3           ANDNE     ' '
     C                   MOVEL     CC1           CC2
     C                   MOVEL     '0'           COMCODE
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkBR - SR to Check/update Branches using Company Code.
      *
      *****************************************************************
     C     SRChkBR       BEGSR
      *
     C                   Z-ADD     *ZERO         BrCounter
      *
     C     *LOVAL        SETLL     SDBRCHL0
     C                   READ      SDBRCHL0                               21
      *
     C     *IN21         DOWEQ     '0'
      *
     C                   MOVEL     A8CMCD        COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   MOVEL     A8CMCD        OLDCC
     C                   EXSR      SRChkCC
     C                   Eval      BrCounter = BrCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on SDBRCHPD, GZSDBRCHPD and TABLETR.
      *
     C     *IN30         IFEQ      *ON
     C     A8BRCD        CHAIN     GZSDBRCHD0                         22
     C                   MOVEL     COMCODE       A8CMCD
     C     *IN22         IFEQ      *OFF
     C                   UPDATE    GZSDBRCHD0
     C                   ENDIF
     C                   UPDATE    @A8REB1
     C     A8BRCD        CHAIN     TABLETR                            22
     C     *IN22         IFEQ      *OFF
     C                   MOVEL     A8CMCD        CMPYM
     C                   UPDATE    TABLETRF                                     ** Update TABLETR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDBRCHL0                               21
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkSM - SR to Check/update Company Code in PF/SDBTSMPD
      *
      *****************************************************************
     C     SRChkSM       BEGSR
      *
     C                   Z-ADD     *ZERO         SMCounter
      *
     C     *LOVAL        SETLL     UTSD0774L0
     C                   READ      UTSD0774L0                             23
      *
     C     *IN23         DOWEQ     '0'
      *
     C                   MOVEL     A_E0CMPY      COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   MOVEL     A_E0CMPY      OLDCC
     C                   EXSR      SRChkCC
     C                   Eval      SMCounter = SMCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on SDBTSMPD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     COMCODE       A_E0CMPY
     C                   UPDATE    SDBTSMD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      UTSD0774L0                             23
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkSF - SR to Check/update Company Code in PF/SDBTSFPD
      *
      *****************************************************************
     C     SRChkSF       BEGSR
      *
     C                   Z-ADD     *ZERO         SFCounter
      *
     C     *LOVAL        SETLL     UTSD0774L1
     C                   READ      UTSD0774L1                             24
      *
     C     *IN24         DOWEQ     '0'
      *
     C                   MOVEL     B_E1CMPY      COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   MOVEL     B_E1CMPY      OLDCC
     C                   EXSR      SRChkCC
     C                   Eval      SFCounter = SFCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on SDBTSFPD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     COMCODE       B_E1CMPY
     C                   UPDATE    SDBTSFD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      UTSD0774L1                             24
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkMH - SR to Check/update Company Code in PF/SDBTMHPD
      *
      *****************************************************************
     C     SRChkMH       BEGSR
      *
     C                   Z-ADD     *ZERO         MHCounter
      *
     C     *LOVAL        SETLL     UTSD0774L2
     C                   READ      UTSD0774L2                             25
      *
     C     *IN25         DOWEQ     '0'
      *
     C                   MOVEL     C_E2CMPY      COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   MOVEL     C_E2CMPY      OLDCC
     C                   EXSR      SRChkCC
     C                   Eval      MHCounter = MHCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on SDBTMHPD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     COMCODE       C_E2CMPY
     C                   UPDATE    SDBTMHD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      UTSD0774L2                             25
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkFH - SR to Check/update Company Code in PF/SDBTFHPD
      *
      *****************************************************************
     C     SRChkFH       BEGSR
      *
     C                   Z-ADD     *ZERO         FHCounter
      *
     C     *LOVAL        SETLL     UTSD0774L3
     C                   READ      UTSD0774L3                             26
      *
     C     *IN26         DOWEQ     '0'
      *
     C                   MOVEL     D_E3CMPY      COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   MOVEL     D_E3CMPY      OLDCC
     C                   EXSR      SRChkCC
     C                   Eval      FHCounter = FHCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on SDBTFHPD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     COMCODE       D_E3CMPY
     C                   UPDATE    SDBTFHD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      UTSD0774L3                             26
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkGL - SR to Check/update Company Code in PF/GLOLEMPD
      *
      *****************************************************************
     C     SRChkGL       BEGSR
      *
     C                   Z-ADD     *ZERO         GLCounter
      *
     C     *LOVAL        SETLL     UTSD0774L4
     C                   READ      UTSD0774L4                             27
      *
     C     *IN27         DOWEQ     '0'
      *
     C                   MOVEL     E_CMPYM       COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   EXSR      SRChkCC
     C                   Eval      GLCounter = GLCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on GLOLEMPD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     COMCODE       E_CMPYM
     C                   UPDATE    GLOLEMD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      UTSD0774L4                             27
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkOL - SR to Check/update Company Code in PF/OLPOSOA
      *
      *****************************************************************
     C     SRChkOL       BEGSR
      *
     C                   Z-ADD     *ZERO         OLCounter
      *
     C     *LOVAL        SETLL     UTSD0774L5
     C                   READ      UTSD0774L5                             28
      *
     C     *IN28         DOWEQ     '0'
      *
     C                   MOVEL     CMPYM         COMCODE
      *
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   EXSR      SRChkCC
     C                   Eval      OLCounter = OLCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on OLPOSOA.
      *
     C     *IN30         IFEQ      *ON
     C     KOLP          CHAIN     GZOLPOSL0                          29
     C                   MOVEL     COMCODE       CMPYM
     C     *IN29         IFEQ      *OFF
     C                   UPDATE    GZOLPOSOAF
     C                   ENDIF
     C                   UPDATE    OLPOSOAF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      UTSD0774L5                             28
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkMC- SR to Check/update Company Codes in PF/MCMPSDD
      *
      *****************************************************************
     C     SRChkMC       BEGSR
      *
     C                   Z-ADD     *ZERO         MCCounter
      *
     C     *LOVAL        SETLL     MCMPS
     C                   READ      MCMPS                                  31
      *
     C     *IN31         DOWEQ     '0'
     C     VCMP          IFNE      *BLANKS
      *
     C                   MOVEA     VCMP          CCArr
     C                   Z-ADD     1             CCCtr
     C                   MOVEL     'N'           CCUpd             1
      *
     C     CCCtr         DOWLE     100
     C                   MOVEL     CCArr(CCCtr)  COMCODE
     C     COMCODE       IFNE      ' '
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
     C                   MOVEL     'Y'           CCUpd
     C                   EXSR      SRChkCC
     C                   MOVEL     COMCODE       CCArr(CCCtr)
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             CCCtr
     C                   ENDDO
      *
     C     CCUpd         IFEQ      'Y'
     C                   Eval      MCCounter = MCCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on MCMPSD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEA     CCArr         VCMP
     C                   UPDATE    MCMPSDDF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      MCMPS                                  31
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   SRChkDL - SR to Check/update Company Code in PF/DLTCSTPD
      *
      *****************************************************************
     C     SRChkDL       BEGSR
      *
     C                   Z-ADD     *ZERO         DLCounter
      *
     C     *LOVAL        SETLL     DLTCSTV0
     C                   READ      DLTCSTV0                               32
      *
     C     *IN32         DOWEQ     '0'
      *
     C                   MOVEL     GCMCD         COMCODE
      *
     C     COMCODE       IFNE      ' '
     C     CC1           IFEQ      ' '
     C     CC2           OREQ      ' '
     C     CC3           OREQ      ' '
      *
     C                   EXSR      SRChkCC
     C                   Eval      DLCounter = DLCounter + 1
      *
      ** If update mode (*IN30=*ON) update records on DLTCDTPD.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     COMCODE       GCMCD
     C                   UPDATE    DLTCSTP0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      DLTCSTV0                               32
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *
      *   PRINTX1 - Report Generation Routine for UTSD0774P1
      *
      *****************************************************************
     C     PRINTX1       BEGSR
      *
      ** Print header on every start of page
      *
     C                   If        *IN66 = *On and X1Counter = 0
     C                   Write     UTPAGHDR
     C                   Eval      *IN66 = *Off
     C                   Endif
      *
      ** If first SECTYD detail, print Title Lines
      *
     C                   If        X1Counter = 0
     C                   Write     UTTITLE
     C                   Endif
      *
      ** If next page, write header and title line again
      *
     C                   If        X1Counter > 0 and *IN66 = *On
     C                   Write     UTPAGHDR
     C                   Write     UTTITLE
     C                   Eval      *IN66 = *Off
     C                   Endif
      *
      ** Print SDCOMPPD details
      *
     C                   Eval      UTOLDCC = APCMCD
     C                   Eval      UTNEWCC = COMCODE
     C                   Write     UTDTLRCD
     C                   Eval      X1Counter = X1Counter + 1

     C                   ENDSR
      *****************************************************************
      *
      *   PRINTX2 - Report Generation Routine for UTSD0774P2
      *
      *****************************************************************
     C     PRINTX2       BEGSR
      *
      ** Print header on every start of page
      *
     C                   If        *IN68 = *On and X2Counter = 0
     C                   Write     UTPAGHDR2
     C                   Eval      *IN68 = *Off
     C                   Endif
      *
      ** Print Title Lines
      *
     C                   If        X2Counter = 0
     C                   Write     UTTITLE2
     C                   Endif
      *
      ** If next page, write header and title line again
      *
     C                   If        X2Counter > 0 and *IN68 = *On
     C                   Write     UTPAGHDR2
     C                   Write     UTTITLE2
     C                   Eval      *IN68 = *Off
     C                   Endif
      *
      ** Print File details
      *
     C                   Eval      UTMFILE = MDFILE
     C                   Eval      UTFCOUNT = MDCOUNT
     C                   Write     UTDTLRCD2
     C                   Eval      X2Counter = X2Counter + 1

     C                   ENDSR
      *****************************************************************
      * ZDATE1 - Convert a date into a day number
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
      *
     C                   ENDSR
      *****************************************************************
      * ZDATE2 - Convert a day number into DDMMYY date format
      *****************************************************************
     C     ZDATE2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    Z2DAYNO           5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    Z2DATE            6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *   INIT SUBROUTINE
      *
      *****************************************************************
     C     *INZSR        BEGSR
     C
     C     *ENTRY        PLIST
     C                   PARM                    ModeParm
      *
     C                   If        ModeParm = 'U' or ModeParm = 'u'
     C                   Eval      Mode = 'UPDATE'
     C                   Eval      *IN30 = *On
     C                   ELSE
     C                   Eval      Mode = 'AUDIT'
     C                   Eval      *IN30 = *Off
     C                   Endif
      *
      *  Seton overflow indicator to write the header on first print
      *
     C                   Eval      *IN66 = *On
     C                   Eval      *IN67 = *Off
     C                   Eval      *IN68 = *On
      *
      *  Print Midas Run Date on report
      *
     C                   Read      SDBANKD0
     C                   If        Not %Eof
     C                   Eval      UTMRDT = BJMRDT
     C                   Endif

     C*                  EXSR      ZDATE1
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 002 *
     C                   Z-ADD     2             DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     KOLP          KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CCY
     C                   KFLD                    RECN
      *
     C                   ENDSR
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
