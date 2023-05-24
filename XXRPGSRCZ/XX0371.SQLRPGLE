     H DEBUG
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('LE Interest Calculation with ARR future rates')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  XX0371 - Midas LE Interest Calculation with ARR future rates *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2023                 *
      *                                                               *
      *  Last Amend No. MD061164 *CREATE   Date 03May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061164 - LE ARR - Forward rates and new report changes.    *
      *             Formalise codes introduced by EF270622, EF230522, *
      *             and ARRLOA.                                       *
      *           - EF270622 - Amend due to rounding differences      *
      *           - EF230522 - Include in PLIST the latest Interest   *
      *             rate used                                         *
      *           - ARRLOA - Pick up future ARR rate BR events        *
      *                                                               *
      *****************************************************************
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     USROPN
     FLOBR      IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDKF)
     F                                     PREFIX(BR)
     F                                     USROPN
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
     D/COPY ZSRSRC,ZDAT10Z1LE
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D WRun            S              1
     D PLoan           S              6
     D PRcdt           S              1    INZ('A')

      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *

     C     KLoan         Chain     CLOANC                             40

     C     NIDT          Ifne      0
     C                   z-add     NIDT          PNIDT
     C                   else
     C     REPT          Ifeq      3
     C     NRPD          andne     0
     C                   z-add     NRPD          PNIDT
     C                   else
     C                   z-add     MDAT          PNIDT
     C                   Endif
     C                   Endif

     C                   z-add     0             ZINTR
     C                   z-add     0             PInta
     C                   z-add     0             ZIRate
     C                   z-add     0             AccInta

s1   C     *In40         Ifeq      *Off
     C     PNIDT         andne     0

     C                   z-add     IACD          ZIBEG
     C                   z-add     INTR          ZIRATE

     C                   Z-Add     ICBS          ZICALC
     C                   Z-Add     CPAM          ZIAMT

     C     KLOBR         Setll     LOBR
     C                   Read      LOBR                                   41

s2   C     *IN41         Doweq     *Off
     C     Lnrf          andeq     BRLnrf

     C                   z-add     BRVdat        ZIEND

     C                   Exsr      SRINTC
     C**********         Add(H)    ZINTR         PInta                           
     C                   Add(H)    ZINTR         AccInta          13 0           

     C                   Exsr      SRNEWI
     C                   Z-Add     BRVdat        ZIBEG

     C                   Read      LOBR                                   41
e2   C                   Enddo

     C                   z-add     PNIDT         ZIEND
     C                   Exsr      SRINTC
     C**********         Add(H)    ZINTR         PInta                           
     C                   Add(H)    ZINTR         AccInta

     C     RDFC          Ifeq      'Y'
     C                   z-add(H)  AccInta       PInta
     C                   Else
     C                   Z-Add     AccInta       PInta
     C                   EndIf

     C                   Add       AITC          PInta
     C     INTC          Ifeq      'Y'
     C     PINTA         Sub       ICTD          PInta
     C                   else
     C     PINTA         Sub       IPRD          PInta
     C                   Endif

e1   C                   Endif
      *
     C                   Close     CLOANC
     C                   Close     LOBR

     C                   Eval      *INLR = *ON
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNEWI - Calculate Rate                                      *
      *                                                               *
      *****************************************************************
     C     SRNEWI        BEGSR
      *
     C                   Select
     C                   When      SPIN ='A'
     C     BRBrte        ADD       RTSP          ZIRATE
     C                   When      SPIN ='S'
     C     BRBrte        SUB       RTSP          ZIRATE
     C                   When      SPIN ='P'
     C     RTSP          DIV       100           WWORK            11 9
     C     BRBrte        MULT      WWORK         ZIRATE
     C                   Endsl
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINTC - Interest Calculation                                *
      *                                                               *
      *****************************************************************
     C     SRINTC        BEGSR
      *
     C                   EXSR      GLINTC
      **********
      ***Round*down*interest*if*required
      **********
     C*****RDFC*         Ifeq      'Y'                                           
     C**********         z-add     ZINTR         RDWORK           13 0           
     C**********         z-add     RDWORK        ZINTR                           
     C**********         Else                                                    
     C**********         Z-add(H)  ZINTR         RUWORK           13 0           
     C**********         Z-Add     RUWORK        ZINTR                           
     C**********         EndIf                                                   
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD             7
     C                   PARM                    PLoan
     C                   PARM                    PInta
     C                   PARM                    ZIRate

      ** Define Local Data Area for error handling
      *
     C     *DTAARA       DEFINE                  LDA

     C     *LIKE         Define    TOTI          PInta
     C     *LIKE         Define    NIDT          PNidt
     C     *LIKE         Define    BRVdat        PVdat
     C     *LIKE         Define    BRLasn        PLasn
      *
      ** Access Bank details via access program
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   If        BjDfin = 'M'
     C                   Move      *On           *In98
     C                   else
     C                   Move      *Off          *In98
     C                   Endif

     C     KLOAN         KLIST
     C                   KFld                    PLoan
     C                   KFld                    PRcdt

     C     KLOBR         KLIST
     C                   KFld                    PLoan
     C                   KFld                    PVdat
     C                   KFld                    PLasn
      *
     C                   Open      CLOANC
     C                   Open      LOBR
      *
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
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   Close     CLOANC
     C                   Close     LOBR

     C                   RETURN

     C                   ENDSR
      *****************************************************************
     C/COPY ZSRSRC,GLINTCZ1LE
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/COPY ZSRSRC,ZSAVEZ1LE
     C/COPY ZSRSRC,ZRSTORZ1LE
     C/COPY ZSRSRC,ZINTDYZ2LE
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZDAT10Z2LE
      *****************************************************************
